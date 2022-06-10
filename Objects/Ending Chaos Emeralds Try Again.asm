; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on	the "TRY AGAIN"	screen

; spawned by:
;	EndEggman
; ---------------------------------------------------------------------------

TryChaos:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	TCha_Index(pc,d0.w),d1
		jsr	TCha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
TCha_Index:	index *,,2
		ptr TCha_Main
		ptr TCha_Move

ost_ectry_x_start:	equ $38					; x-axis centre of emerald circle (2 bytes)
ost_ectry_y_start:	equ $3A					; y-axis centre of emerald circle (2 bytes)
ost_ectry_radius:	equ $3C					; radius
ost_ectry_speed:	equ $3E					; speed at which emeralds rotate around central point (2 bytes)
; ===========================================================================

TCha_Main:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#countof_emeralds-1,d1
		sub.b	(v_emeralds).w,d1

@makeemerald:
		move.b	#id_TryChaos,(a1)			; load emerald object
		addq.b	#2,ost_routine(a1)			; goto TCha_Move next
		move.l	#Map_ECha,ost_mappings(a1)
		move.w	#tile_Nem_EndEm_TryAgain,ost_tile(a1)
		move.b	#render_abs,ost_render(a1)
		move.b	#1,ost_priority(a1)
		move.w	#$104,ost_x_pos(a1)
		move.w	#$120,ost_ectry_x_start(a1)
		move.w	#$EC,ost_y_screen(a1)
		move.w	ost_y_screen(a1),ost_ectry_y_start(a1)
		move.b	#$1C,ost_ectry_radius(a1)
		lea	(v_emerald_list).w,a3

	@chkemerald:
		moveq	#0,d0
		move.b	(v_emeralds).w,d0			; get emerald count
		subq.w	#1,d0
		bcs.s	@no_emeralds				; branch if 0

	@chkloop:
		cmp.b	(a3,d0.w),d2				; have you got specific emerald?
		bne.s	@no_match				; if not, branch
		addq.b	#1,d2					; try next emerald
		bra.s	@chkemerald
; ===========================================================================

	@no_match:
		dbf	d0,@chkloop				; repeat for number of emeralds you have

	@no_emeralds:
		move.b	d2,ost_frame(a1)
		addq.b	#1,ost_frame(a1)
		addq.b	#1,d2
		move.b	#$80,ost_angle(a1)
		move.b	d3,ost_anim_time(a1)
		move.b	d3,ost_anim_delay(a1)
		addi.w	#10,d3
		lea	sizeof_ost(a1),a1
		dbf	d1,@makeemerald

TCha_Move:	; Routine 2
		tst.w	ost_ectry_speed(a0)			; should be 0, 2 or -2 (changed by Eggman object)
		beq.s	@no_move				; branch if 0
		tst.b	ost_anim_time(a0)
		beq.s	@update_angle				; branch if timer is 0
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bne.s	@chk_angle				; branch if not 0

	@update_angle:
		move.w	ost_ectry_speed(a0),d0			; 2 or -2
		add.w	d0,ost_angle(a0)			; update angle

	@chk_angle:
		move.b	ost_angle(a0),d0			; get angle
		beq.s	@angle_0				; branch if 0
		cmpi.b	#$80,d0
		bne.s	@angle_not_80				; branch if not $80

	@angle_0:
		clr.w	ost_ectry_speed(a0)
		move.b	ost_anim_delay(a0),ost_anim_time(a0)

	@angle_not_80:
		jsr	(CalcSine).l				; convert angle (d0) to sine (d0) and cosine (d1)
		moveq	#0,d4
		move.b	ost_ectry_radius(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	ost_ectry_x_start(a0),d1
		add.w	ost_ectry_y_start(a0),d0
		move.w	d1,ost_x_pos(a0)
		move.w	d0,ost_y_screen(a0)

	@no_move:
		rts	
