; ---------------------------------------------------------------------------
; Object 64 - bubbles (LZ)

; spawned by:
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3, ObjPos_SBZ3 - subtypes $80/$81/$82
;	Bubble - subtypes 0/1/2
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

		rsobj Bubble,$2E
ost_bubble_inhalable:	rs.w 1					; $2E ; flag set when bubble is collectable
ost_bubble_x_start:	rs.w 1					; $30 ; original x-axis position
ost_bubble_wait_time:	rs.b 1					; $32 ; time until next bubble spawn
ost_bubble_wait_master:	rs.b 1					; $33 ; time between bubble spawns
ost_bubble_mini_count:	rs.b 1					; $34 ; number of smaller bubbles to spawn
ost_bubble_flag:	rs.w 1					; $36 ; 1 = bubbles currently spawning; +$4000 = large bubble spawned; +$8000 = allow large bubble
ost_bubble_random_time:	rs.w 1					; $38 ; randomised time between mini bubble spawns
		rsset $3C
ost_bubble_type_list:	rs.l 1					; $3C ; address of bubble type list
		rsobjend
; ===========================================================================

Bub_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Bub_Animate next
		move.l	#Map_Bub,ost_mappings(a0)
		move.w	#tile_Nem_Bubbles+tile_hi,ost_tile(a0)
		move.b	#render_onscreen+render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	ost_subtype(a0),d0			; get bubble type
		bpl.s	.bubble					; if type is 0/1/2, branch

		addq.b	#8,ost_routine(a0)			; goto Bub_BblMaker next
		andi.w	#$7F,d0					; ignore bit 7 (deduct $80)
		move.b	d0,ost_bubble_wait_time(a0)
		move.b	d0,ost_bubble_wait_master(a0)		; set bubble frequency
		move.b	#id_ani_bubble_bubmaker,ost_anim(a0)
		bra.w	Bub_BblMaker
; ===========================================================================

.bubble:
		move.b	d0,ost_anim(a0)				; use animation 0/1/2 (small/medium/large)
		move.w	ost_x_pos(a0),ost_bubble_x_start(a0)
		move.w	#-$88,ost_y_vel(a0)			; float bubble upwards
		jsr	(RandomNumber).l
		move.b	d0,ost_angle(a0)			; set high byte of ost_angle as random number

Bub_Animate:	; Routine 2
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l			; run animation and goto Bub_ChkWater next
		cmpi.b	#id_frame_bubble_full,ost_frame(a0)	; is bubble full-size?
		bne.s	Bub_ChkWater				; if not, branch

		move.b	#1,ost_bubble_inhalable(a0)		; set "inhalable" flag

Bub_ChkWater:	; Routine 4
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; is bubble underwater?
		bcs.s	.wobble					; if yes, branch

.burst:
		move.b	#id_Bub_Display,ost_routine(a0)		; goto Bub_Display next
		addq.b	#3,ost_anim(a0)				; type 0/1: goto Bub_Delete next; type 2: use burst animation & goto Bub_Delete
		bra.w	Bub_Display
; ===========================================================================

.wobble:
		move.b	ost_angle(a0),d0
		addq.b	#1,ost_angle(a0)
		andi.w	#$7F,d0
		lea	(Drown_WobbleData).l,a1
		move.b	(a1,d0.w),d0				; get byte from wobble array (see "Objects\LZ Drowning Numbers.asm")
		ext.w	d0
		add.w	ost_bubble_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)			; change bubble's x position
		tst.b	ost_bubble_inhalable(a0)		; can bubble be inhaled?
		beq.s	.display				; if not, branch
		bsr.w	Bub_ChkSonic				; has Sonic touched the	bubble?
		beq.s	.display				; if not, branch

		bsr.w	ResumeMusic				; cancel countdown music
		play.w	1, jsr, sfx_Bubble			; play collecting bubble sound
		lea	(v_ost_player).w,a1
		clr.w	ost_x_vel(a1)
		clr.w	ost_y_vel(a1)
		clr.w	ost_inertia(a1)				; stop Sonic
		move.b	#id_GetAir,ost_anim(a1)			; use bubble-collecting animation
		move.w	#sonic_lock_time_bubble,ost_sonic_lock_time(a1) ; lock controls for 35 frames
		move.b	#0,ost_sonic_jump(a1)			; cancel jump
		bclr	#status_pushing_bit,ost_status(a1)
		bclr	#status_rolljump_bit,ost_status(a1)
		btst	#status_jump_bit,ost_status(a1)
		beq.w	.burst
		bclr	#status_jump_bit,ost_status(a1)
		move.b	#$13,ost_height(a1)
		move.b	#9,ost_width(a1)
		subq.w	#5,ost_y_pos(a1)
		bra.w	.burst
; ===========================================================================

.display:
		bsr.w	SpeedToPos				; update position
		tst.b	ost_render(a0)				; is bubble on-screen?
		bpl.s	.delete					; if not, branch
		jmp	(DisplaySprite).l

	.delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Display:	; Routine 6
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_render(a0)
		bpl.s	.delete
		jmp	(DisplaySprite).l

	.delete:
		jmp	(DeleteObject).l
; ===========================================================================

Bub_Delete:	; Routine 8
		bra.w	DeleteObject
; ===========================================================================

Bub_BblMaker:	; Routine $A
		tst.w	ost_bubble_flag(a0)			; any flags set?
		bne.s	.chk_time				; if yes, branch
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; is bubble maker underwater?
		bcc.w	.chkdel					; if not, branch
		tst.b	ost_render(a0)				; is bubble maker on-screen?
		bpl.w	.chkdel					; if not, branch
		subq.w	#1,ost_bubble_random_time(a0)		; decrement timer
		bpl.w	.animate				; branch if time remains
		move.w	#1,ost_bubble_flag(a0)			; set flag for bubble spawn

	.loop_until_clear:
		jsr	(RandomNumber).l
		move.w	d0,d1
		andi.w	#7,d0					; read only bits 0-2 of random number
		cmpi.w	#6,d0					; are both bits 1 & 2 set?
		bcc.s	.loop_until_clear			; if yes, branch

		move.b	d0,ost_bubble_mini_count(a0)		; set number of small/medium bubbles to spawn (0-5)
		andi.w	#$C,d1					; read only bits 2-3 of random number
		lea	(Bub_BblTypes).l,a1
		adda.w	d1,a1					; jump to multiple of 4 within type array
		move.l	a1,ost_bubble_type_list(a0)
		subq.b	#1,ost_bubble_wait_time(a0)		; decrement timer
		bpl.s	.wait					; branch if time remains
		move.b	ost_bubble_wait_master(a0),ost_bubble_wait_time(a0) ; reset timer (based on original subtype)
		bset	#7,ost_bubble_flag(a0)			; allow large bubble in current sequence

	.wait:
		bra.s	.spawn_bubble
; ===========================================================================

.chk_time:
		subq.w	#1,ost_bubble_random_time(a0)		; decrement timer
		bpl.w	.animate				; branch if time remains

.spawn_bubble:
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		move.w	d0,ost_bubble_random_time(a0)		; set next random time (max 32 frames)
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_Bubble,ost_id(a1)			; load bubble object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		subq.w	#8,d0
		add.w	d0,ost_x_pos(a1)			; randomise initial x pos
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		moveq	#0,d0
		move.b	ost_bubble_mini_count(a0),d0		; get number of bubbles to spawn
		movea.l	ost_bubble_type_list(a0),a2		; get address of type array
		move.b	(a2,d0.w),ost_subtype(a1)		; load type from array
		btst	#7,ost_bubble_flag(a0)
		beq.s	.fail
		jsr	(RandomNumber).l
		andi.w	#3,d0					; are either lowest 2 bits of random number set?
		bne.s	.skip_large				; if yes, branch
		bset	#6,ost_bubble_flag(a0)			; set large bubble flag
		bne.s	.fail					; branch if already set
		move.b	#id_ani_bubble_large,ost_subtype(a1)	; make bubble large

	.skip_large:
		tst.b	ost_bubble_mini_count(a0)		; is this the last bubble in the current sequence?
		bne.s	.fail					; if not, branch
		bset	#6,ost_bubble_flag(a0)			; set large bubble flag
		bne.s	.fail					; branch if already set
		move.b	#id_ani_bubble_large,ost_subtype(a1)	; make bubble large

	.fail:
		subq.b	#1,ost_bubble_mini_count(a0)		; decrement bubble count
		bpl.s	.animate				; branch if +ve
		jsr	(RandomNumber).l
		andi.w	#$7F,d0
		addi.w	#$80,d0
		add.w	d0,ost_bubble_random_time(a0)		; set timer for next sequence
		clr.w	ost_bubble_flag(a0)			; clear all flags

.animate:
		lea	(Ani_Bub).l,a1
		jsr	(AnimateSprite).l

.chkdel:
		out_of_range	DeleteObject
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.w	DisplaySprite				; display if below water
		rts	
; ===========================================================================
; bubble production sequence

; 0 = small bubble, 1 =	medium bubble

Bub_BblTypes:	dc.b 0,	1, 0, 0, 0, 0, 1, 0, 0,	0, 0, 1, 0, 1, 0, 0, 1,	0

; ---------------------------------------------------------------------------
; Subroutine to check large bubble's collision with Sonic

; output:
;	d0 = collision flag: 1 = yes; 0 = no
; ---------------------------------------------------------------------------

Bub_ChkSonic:
		tst.b	(v_lock_multi).w			; is object collision disabled?
		bmi.s	.no_collision				; if yes, branch
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		move.w	ost_x_pos(a0),d1
		subi.w	#$10,d1
		cmp.w	d0,d1
		bcc.s	.no_collision				; branch if Sonic is left of bubble
		addi.w	#$20,d1
		cmp.w	d0,d1
		bcs.s	.no_collision				; branch if Sonic is right of bubble
		move.w	ost_y_pos(a1),d0
		move.w	ost_y_pos(a0),d1
		cmp.w	d0,d1
		bcc.s	.no_collision				; branch if Sonic is above bubble
		addi.w	#$10,d1
		cmp.w	d0,d1
		bcs.s	.no_collision				; branch if Sonic is below bubble
		moveq	#1,d0					; set collision flag
		rts	
; ===========================================================================

.no_collision:
		moveq	#0,d0
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Bub:	index *
		ptr ani_bubble_small
		ptr ani_bubble_medium
		ptr ani_bubble_large
		ptr ani_bubble_incroutine
		ptr ani_bubble_incroutine
		ptr ani_bubble_burst
		ptr ani_bubble_bubmaker
		
ani_bubble_small:						; small bubble forming
		dc.b $E
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b afRoutine
		even

ani_bubble_medium:						; medium bubble forming
		dc.b $E
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b afRoutine

ani_bubble_large:						; full size bubble forming
		dc.b $E
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_5
		dc.b id_frame_bubble_full
		dc.b afRoutine
		even

ani_bubble_incroutine:						; increment routine counter (no animation)
		dc.b 4
		dc.b afRoutine

ani_bubble_burst:						; large bubble bursts
		dc.b 4
		dc.b id_frame_bubble_full
		dc.b id_frame_bubble_burst1
		dc.b id_frame_bubble_burst2
		dc.b afRoutine
		even

ani_bubble_bubmaker:						; bubble maker on the floor
		dc.b $F
		dc.b id_frame_bubble_bubmaker1
		dc.b id_frame_bubble_bubmaker2
		dc.b id_frame_bubble_bubmaker3
		dc.b afEnd
		even
