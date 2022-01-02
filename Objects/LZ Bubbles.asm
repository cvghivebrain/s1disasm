; ---------------------------------------------------------------------------
; Object 64 - bubbles (LZ)
; ---------------------------------------------------------------------------

Bubble:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bub_Index(pc,d0.w),d1
		jmp	Bub_Index(pc,d1.w)
; ===========================================================================
Bub_Index:	index *,,2
		ptr Bub_Main
		ptr Bub_Animate
		ptr Bub_ChkWater
		ptr Bub_Display
		ptr Bub_Delete
		ptr Bub_BblMaker

ost_bubble_inhalable:	equ $2E					; flag set when bubble is collectable
ost_bubble_x_start:	equ $30					; original x-axis position (2 bytes)
ost_bubble_wait_time:	equ $32					; time until next bubble spawn
ost_bubble_wait_master:	equ $33					; time between bubble spawns
ost_bubble_mini_count:	equ $34					; number of smaller bubbles to spawn
ost_bubble_flag:	equ $36					; 1 = ?; +$4000 = ?; +$8000 = ? (2 bytes)
ost_bubble_random_time:	equ $38					; randomised time between mini bubble spawns (2 bytes)
ost_bubble_type_list:	equ $3C					; address of bubble type list (4 bytes)
; ===========================================================================

Bub_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bub,ost_mappings(a0)
		move.w	#tile_Nem_Bubbles+tile_hi,ost_tile(a0)
		move.b	#$80+render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	ost_subtype(a0),d0			; get bubble type
		bpl.s	@bubble					; if type is $0-$7F, branch

		addq.b	#8,ost_routine(a0)			; goto Bub_BblMaker next
		andi.w	#$7F,d0					; ignore bit 7 (deduct $80)
		move.b	d0,ost_bubble_wait_time(a0)
		move.b	d0,ost_bubble_wait_master(a0)		; set bubble frequency
		move.b	#id_ani_bubble_bubmaker,ost_anim(a0)
		bra.w	Bub_BblMaker
; ===========================================================================

@bubble:
		move.b	d0,ost_anim(a0)
		move.w	ost_x_pos(a0),ost_bubble_x_start(a0)
		move.w	#-$88,ost_y_vel(a0)			; float bubble upwards
		jsr	(RandomNumber).l
		move.b	d0,ost_angle(a0)

Bub_Animate:	; Routine 2
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#id_frame_bubble_full,ost_frame(a0)	; is bubble full-size?
		bne.s	Bub_ChkWater				; if not, branch

		move.b	#1,ost_bubble_inhalable(a0)		; set "inhalable" flag

Bub_ChkWater:	; Routine 4
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; is bubble underwater?
		bcs.s	@wobble					; if yes, branch

@burst:
		move.b	#id_Bub_Display,ost_routine(a0)		; goto Bub_Display next
		addq.b	#3,ost_anim(a0)				; run "bursting" animation
		bra.w	Bub_Display
; ===========================================================================

@wobble:
		move.b	ost_angle(a0),d0
		addq.b	#1,ost_angle(a0)
		andi.w	#$7F,d0
		lea	(Drown_WobbleData).l,a1
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	ost_bubble_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)			; change bubble's x-axis position
		tst.b	ost_bubble_inhalable(a0)
		beq.s	@display
		bsr.w	Bub_ChkSonic				; has Sonic touched the	bubble?
		beq.s	@display				; if not, branch

		bsr.w	ResumeMusic				; cancel countdown music
		play.w	1, jsr, sfx_Bubble			; play collecting bubble sound
		lea	(v_ost_player).w,a1
		clr.w	ost_x_vel(a1)
		clr.w	ost_y_vel(a1)
		clr.w	ost_inertia(a1)				; stop Sonic
		move.b	#id_GetAir,ost_anim(a1)			; use bubble-collecting animation
		move.w	#35,ost_sonic_lock_time(a1)
		move.b	#0,ost_sonic_jump(a1)
		bclr	#status_pushing_bit,ost_status(a1)
		bclr	#status_rolljump_bit,ost_status(a1)
		btst	#status_jump_bit,ost_status(a1)
		beq.w	@burst
		bclr	#status_jump_bit,ost_status(a1)
		move.b	#$13,ost_height(a1)
		move.b	#9,ost_width(a1)
		subq.w	#5,ost_y_pos(a1)
		bra.w	@burst
; ===========================================================================

@display:
		bsr.w	SpeedToPos
		tst.b	ost_render(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Display:	; Routine 6
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_render(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Delete:	; Routine 8
		bra.w	DeleteObject
; ===========================================================================

Bub_BblMaker:	; Routine $A
		tst.w	ost_bubble_flag(a0)			; any flags set?
		bne.s	@loc_12874				; if yes, branch
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; is bubble maker underwater?
		bcc.w	@chkdel					; if not, branch
		tst.b	ost_render(a0)				; is bubble maker on screen?
		bpl.w	@chkdel					; if not, branch
		subq.w	#1,ost_bubble_random_time(a0)
		bpl.w	@loc_12914
		move.w	#1,ost_bubble_flag(a0)

	@tryagain:
		jsr	(RandomNumber).l
		move.w	d0,d1
		andi.w	#7,d0
		cmpi.w	#6,d0					; random number over 6?
		bcc.s	@tryagain				; if yes, branch

		move.b	d0,ost_bubble_mini_count(a0)		; set number of small/medium bubbles to spawn
		andi.w	#$C,d1
		lea	(Bub_BblTypes).l,a1
		adda.w	d1,a1
		move.l	a1,ost_bubble_type_list(a0)
		subq.b	#1,ost_bubble_wait_time(a0)
		bpl.s	@loc_12872
		move.b	ost_bubble_wait_master(a0),ost_bubble_wait_time(a0)
		bset	#7,ost_bubble_flag(a0)

@loc_12872:
		bra.s	@loc_1287C
; ===========================================================================

@loc_12874:
		subq.w	#1,ost_bubble_random_time(a0)
		bpl.w	@loc_12914

@loc_1287C:
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		move.w	d0,ost_bubble_random_time(a0)
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Bubble,ost_id(a1)			; load bubble object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		subq.w	#8,d0
		add.w	d0,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		moveq	#0,d0
		move.b	ost_bubble_mini_count(a0),d0
		movea.l	ost_bubble_type_list(a0),a2
		move.b	(a2,d0.w),ost_subtype(a1)
		btst	#7,ost_bubble_flag(a0)
		beq.s	@fail
		jsr	(RandomNumber).l
		andi.w	#3,d0
		bne.s	@loc_buh
		bset	#6,ost_bubble_flag(a0)
		bne.s	@fail
		move.b	#2,ost_subtype(a1)			; make bubble large

@loc_buh:
		tst.b	ost_bubble_mini_count(a0)
		bne.s	@fail
		bset	#6,ost_bubble_flag(a0)
		bne.s	@fail
		move.b	#2,ost_subtype(a1)			; make bubble large

	@fail:
		subq.b	#1,ost_bubble_mini_count(a0)
		bpl.s	@loc_12914
		jsr	(RandomNumber).l
		andi.w	#$7F,d0
		addi.w	#$80,d0
		add.w	d0,ost_bubble_random_time(a0)
		clr.w	ost_bubble_flag(a0)

@loc_12914:
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l

@chkdel:
		out_of_range	DeleteObject
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.w	DisplaySprite
		rts	
; ===========================================================================
; bubble production sequence

; 0 = small bubble, 1 =	medium bubble

Bub_BblTypes:	dc.b 0,	1, 0, 0, 0, 0, 1, 0, 0,	0, 0, 1, 0, 1, 0, 0, 1,	0

; ===========================================================================

Bub_ChkSonic:
		tst.b	(v_lock_multi).w
		bmi.s	@loc_12998
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		move.w	ost_x_pos(a0),d1
		subi.w	#$10,d1
		cmp.w	d0,d1
		bcc.s	@loc_12998
		addi.w	#$20,d1
		cmp.w	d0,d1
		bcs.s	@loc_12998
		move.w	ost_y_pos(a1),d0
		move.w	ost_y_pos(a0),d1
		cmp.w	d0,d1
		bcc.s	@loc_12998
		addi.w	#$10,d1
		cmp.w	d0,d1
		bcs.s	@loc_12998
		moveq	#1,d0
		rts	
; ===========================================================================

@loc_12998:
		moveq	#0,d0
		rts	
