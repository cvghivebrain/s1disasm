; ---------------------------------------------------------------------------
; Object 18 - platforms	(GHZ, SYZ, SLZ)
; ---------------------------------------------------------------------------

BasicPlatform:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Plat_Index(pc,d0.w),d1
		jmp	Plat_Index(pc,d1.w)
; ===========================================================================
Plat_Index:	index *,,2
		ptr Plat_Main
		ptr Plat_Solid
		ptr Plat_Action2
		ptr Plat_Delete
		ptr Plat_Action

ost_plat_y_pos:		equ $2C	; y position ignoring dip when Sonic is on the platform (2 bytes)
ost_plat_x_start:	equ $32	; original x position (2 bytes)
ost_plat_y_start:	equ $34	; original y position (2 bytes)
ost_plat_y_nudge:	equ $38	; amount of dip when Sonic is on the platform
ost_plat_wait_time:	equ $3A	; time delay for platform moving when stood on (2 bytes)
; ===========================================================================

Plat_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.l	#Map_Plat_GHZ,ost_mappings(a0)
		move.b	#$20,ost_actwidth(a0)
		cmpi.b	#id_SYZ,(v_zone).w ; check if level is SYZ
		bne.s	@notSYZ

		move.l	#Map_Plat_SYZ,ost_mappings(a0) ; SYZ specific code
		move.b	#$20,ost_actwidth(a0)

	@notSYZ:
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	@notSLZ
		move.l	#Map_Plat_SLZ,ost_mappings(a0) ; SLZ specific code
		move.b	#$20,ost_actwidth(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#3,ost_subtype(a0)

	@notSLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_plat_y_pos(a0)
		move.w	ost_y_pos(a0),ost_plat_y_start(a0)
		move.w	ost_x_pos(a0),ost_plat_x_start(a0)
		move.w	#$80,ost_angle(a0)
		moveq	#0,d1
		move.b	ost_subtype(a0),d0
		cmpi.b	#id_Plat_Type_UpDown_Large,d0 ; is object type $A (large platform)?
		bne.s	@setframe	; if not, branch
		addq.b	#id_frame_plat_large,d1 ; use frame #1
		move.b	#$20,ost_actwidth(a0) ; set width

	@setframe:
		move.b	d1,ost_frame(a0) ; set frame to d1

Plat_Solid:	; Routine 2
		tst.b	ost_plat_y_nudge(a0)
		beq.s	loc_7EE0
		subq.b	#4,ost_plat_y_nudge(a0)

	loc_7EE0:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		bsr.w	DetectPlatform

Plat_Action:	; Routine 8
		bsr.w	Plat_Move
		bsr.w	Plat_Nudge
		bsr.w	DisplaySprite
		bra.w	Plat_ChkDel
; ===========================================================================

Plat_Action2:	; Routine 4
		cmpi.b	#$40,ost_plat_y_nudge(a0)
		beq.s	loc_7F06
		addq.b	#4,ost_plat_y_nudge(a0)

	loc_7F06:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		bsr.w	ExitPlatform
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	Plat_Move
		bsr.w	Plat_Nudge
		move.w	(sp)+,d2
		bsr.w	MoveWithPlatform2
		bsr.w	DisplaySprite
		bra.w	Plat_ChkDel

		rts

; ---------------------------------------------------------------------------
; Subroutine to	move platform slightly when you	stand on it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Plat_Nudge:
		move.b	ost_plat_y_nudge(a0),d0
		bsr.w	CalcSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	ost_plat_y_pos(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; End of function Plat_Nudge

; ---------------------------------------------------------------------------
; Subroutine to	move platforms
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Plat_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jmp	@index(pc,d1.w)
; End of function Plat_Move

; ===========================================================================
@index:		index *
		ptr Plat_Type_Still		; 0
		ptr Plat_Type_Sideways		; 1
		ptr Plat_Type_UpDown		; 2
		ptr Plat_Type_Falls		; 3
		ptr Plat_Type_Falls_Now		; 4
		ptr Plat_Type_Sideways_Rev	; 5
		ptr Plat_Type_UpDown_Rev	; 6
		ptr Plat_Type_Rises		; 7
		ptr Plat_Type_Rises_Now		; 8
		ptr Plat_Type_Still		; 9
		ptr Plat_Type_UpDown_Large	; $A
		ptr Plat_Type_UpDown_Slow	; $B
		ptr Plat_Type_UpDown_Slow_Rev	; $C
; ===========================================================================

; Type 0
; Type 9
Plat_Type_Still:
		rts			; platform 00 doesn't move
; ===========================================================================

; Type 5
Plat_Type_Sideways_Rev:
		move.w	ost_plat_x_start(a0),d0
		move.b	ost_angle(a0),d1 ; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$40,d1
		bra.s	Plat_Type_Sideways_Move
; ===========================================================================

; Type 1
Plat_Type_Sideways:
		move.w	ost_plat_x_start(a0),d0
		move.b	ost_angle(a0),d1 ; load platform-motion variable
		subi.b	#$40,d1

	Plat_Type_Sideways_Move:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,ost_x_pos(a0) ; change position on x-axis
		bra.w	Plat_Type_Update_Angle
; ===========================================================================

; Type $C
Plat_Type_UpDown_Slow_Rev:
		move.w	ost_plat_y_start(a0),d0
		move.b	(v_oscillate+$E).w,d1 ; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$30,d1
		bra.s	Plat_Type_UpDown_Move
; ===========================================================================

; Type $B
Plat_Type_UpDown_Slow:
		move.w	ost_plat_y_start(a0),d0
		move.b	(v_oscillate+$E).w,d1 ; load platform-motion variable
		subi.b	#$30,d1
		bra.s	Plat_Type_UpDown_Move
; ===========================================================================

; Type 6
Plat_Type_UpDown_Rev:
		move.w	ost_plat_y_start(a0),d0
		move.b	ost_angle(a0),d1 ; load platform-motion variable
		neg.b	d1		; reverse platform-motion
		addi.b	#$40,d1
		bra.s	Plat_Type_UpDown_Move
; ===========================================================================

; Type 2
Plat_Type_UpDown:
		move.w	ost_plat_y_start(a0),d0
		move.b	ost_angle(a0),d1 ; load platform-motion variable
		subi.b	#$40,d1

	Plat_Type_UpDown_Move:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,ost_plat_y_pos(a0) ; change position on y-axis
		bra.w	Plat_Type_Update_Angle
; ===========================================================================

; Type 3
Plat_Type_Falls:
		tst.w	ost_plat_wait_time(a0) ; is time delay set?
		bne.s	@type03_wait	; if yes, branch
		btst	#status_platform_bit,ost_status(a0) ; is Sonic standing on the platform?
		beq.s	@type03_nomove	; if not, branch
		move.w	#30,ost_plat_wait_time(a0) ; set time delay to 0.5 seconds

	@type03_nomove:
		rts	

	@type03_wait:
		subq.w	#1,ost_plat_wait_time(a0) ; subtract 1 from time
		bne.s	@type03_nomove	; if time is > 0, branch
		move.w	#32,ost_plat_wait_time(a0)
		addq.b	#1,ost_subtype(a0) ; change to type 04 (falling)
		rts	
; ===========================================================================

; Type 4
Plat_Type_Falls_Now:
		tst.w	ost_plat_wait_time(a0)
		beq.s	@loc_8048
		subq.w	#1,ost_plat_wait_time(a0)
		bne.s	@loc_8048
		btst	#status_platform_bit,ost_status(a0)
		beq.s	@loc_8042
		bset	#status_air_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a1)
		move.b	#id_Sonic_Control,ost_routine(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_routine2(a0)
		move.w	ost_y_vel(a0),ost_y_vel(a1)

	@loc_8042:
		move.b	#id_Plat_Action,ost_routine(a0)

	@loc_8048:
		move.l	ost_plat_y_pos(a0),d3
		move.w	ost_y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,ost_plat_y_pos(a0)
		addi.w	#ost_plat_y_nudge,ost_y_vel(a0)
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_plat_y_pos(a0),d0
		bcc.s	@locret_8074
		move.b	#id_Plat_Delete,ost_routine(a0)

	@locret_8074:
		rts	
; ===========================================================================

; Type 7
Plat_Type_Rises:
		tst.w	ost_plat_wait_time(a0) ; is time delay set?
		bne.s	@type07_wait	; if yes, branch
		lea	(v_button_state).w,a2	; load switch statuses
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; move object type ($x7) to d0
		lsr.w	#4,d0		; divide d0 by 8, round	down
		tst.b	(a2,d0.w)	; has switch no. d0 been pressed?
		beq.s	@type07_nomove	; if not, branch
		move.w	#60,ost_plat_wait_time(a0) ; set time delay to 1 second

	@type07_nomove:
		rts	

	@type07_wait:
		subq.w	#1,ost_plat_wait_time(a0) ; subtract 1 from time delay
		bne.s	@type07_nomove	; if time is > 0, branch
		addq.b	#1,ost_subtype(a0) ; change to type 08
		rts	
; ===========================================================================

; Type 8
Plat_Type_Rises_Now:
		subq.w	#2,ost_plat_y_pos(a0) ; move platform up
		move.w	ost_plat_y_start(a0),d0
		subi.w	#$200,d0
		cmp.w	ost_plat_y_pos(a0),d0 ; has platform moved $200 pixels?
		bne.s	@type08_nostop	; if not, branch
		clr.b	ost_subtype(a0)	; change to type 00 (stop moving)

	@type08_nostop:
		rts	
; ===========================================================================

; Type $A
Plat_Type_UpDown_Large:
		move.w	ost_plat_y_start(a0),d0
		move.b	ost_angle(a0),d1 ; load platform-motion variable
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,ost_plat_y_pos(a0) ; change position on y-axis

Plat_Type_Update_Angle:
		move.b	(v_oscillate+$1A).w,ost_angle(a0) ; update platform-movement variable
		rts	
; ===========================================================================

Plat_ChkDel:
		out_of_range.s	Plat_Delete,ost_plat_x_start(a0)
		rts	
; ===========================================================================

Plat_Delete:	; Routine 6
		bra.w	DeleteObject
