; ---------------------------------------------------------------------------
; Object 58 - giant spiked balls (SYZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3 - subtypes 1/2/$B3/$C3/$E3/$F3
; ---------------------------------------------------------------------------

BigSpikeBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BBall_Index(pc,d0.w),d1
		jmp	BBall_Index(pc,d1.w)
; ===========================================================================
BBall_Index:	index offset(*),,2
		ptr BBall_Main
		ptr BBall_Move

		rsobj BigSpikeBall,$38
ost_bball_y_start:	rs.w 1					; $38 ; original y-axis position
ost_bball_x_start:	rs.w 1					; $3A ; original x-axis position
ost_bball_radius:	rs.b 1					; $3C ; radius of circle
ost_bball_speed:	rs.w 1					; $3E ; speed
		rsobjend
; ===========================================================================

BBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto BBall_Move next
		move.l	#Map_BBall,ost_mappings(a0)
		move.w	#tile_Nem_BigSpike,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$18,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_bball_x_start(a0)
		move.w	ost_y_pos(a0),ost_bball_y_start(a0)
		move.b	#id_col_16x16+id_col_hurt,ost_col_type(a0)
		move.b	ost_subtype(a0),d1			; get object type
		andi.b	#$F0,d1					; read only the	high nybble
		ext.w	d1
		asl.w	#3,d1					; multiply by 8
		move.w	d1,ost_bball_speed(a0)			; set object speed
		move.b	ost_status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0					; move x/yflip bits into bits 6-7
		move.b	d0,ost_angle(a0)			; use as angle
		move.b	#$50,ost_bball_radius(a0)		; set radius of circle motion

BBall_Move:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get object type
		andi.w	#7,d0					; read only the	2nd digit
		add.w	d0,d0
		move.w	BBall_Types(pc,d0.w),d1
		jsr	BBall_Types(pc,d1.w)
		out_of_range	DeleteObject,ost_bball_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================
BBall_Types:	index offset(*)
		ptr BBall_Still					; 0 - unused
		ptr BBall_Sideways				; 1
		ptr BBall_UpDown				; 2
		ptr BBall_Circle				; $x3
; ===========================================================================

; Type 0 - doesn't move
BBall_Still:
		rts	
; ===========================================================================

; Type 1
BBall_Sideways:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_60).w,d0		; get oscillating value
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.noflip
		neg.w	d0					; invert if xflipped
		add.w	d1,d0

	.noflip:
		move.w	ost_bball_x_start(a0),d1		; get initial x pos
		sub.w	d0,d1					; subtract difference
		move.w	d1,ost_x_pos(a0)			; update position
		rts	
; ===========================================================================

; Type 2
BBall_UpDown:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_60).w,d0		; get oscillating value
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.noflip
		neg.w	d0					; invert if xflipped
		addi.w	#$80,d0

	.noflip:
		move.w	ost_bball_y_start(a0),d1		; get initial y pos
		sub.w	d0,d1					; subtract difference
		move.w	d1,ost_y_pos(a0)			; update position
		rts	
; ===========================================================================

; Type 3
BBall_Circle:
		move.w	ost_bball_speed(a0),d0			; get rotation speed
		add.w	d0,ost_angle(a0)			; add to angle
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l				; convert angle to sine
		move.w	ost_bball_y_start(a0),d2
		move.w	ost_bball_x_start(a0),d3
		moveq	#0,d4
		move.b	ost_bball_radius(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a0)			; update position
		move.w	d5,ost_x_pos(a0)
		rts	
