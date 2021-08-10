; ---------------------------------------------------------------------------
; Object 66 - rotating disc junction that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Jun_Index(pc,d0.w),d1
		jmp	Jun_Index(pc,d1.w)
; ===========================================================================
Jun_Index:	index *,,2
		ptr Jun_Main
		ptr Jun_Action
		ptr Jun_Display
		ptr Jun_Release

jun_frame:	equ $34		; current frame
jun_reverse:	equ $36		; flag set when switch is pressed
jun_switch:	equ $38		; which switch will reverse the disc
; ===========================================================================

Jun_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#1,d1
		movea.l	a0,a1
		bra.s	@makeitem
; ===========================================================================

	@repeat:
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Junction,0(a1)
		addq.b	#4,ost_routine(a1) ; goto Jun_Display next
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#3,ost_priority(a1)
		move.b	#$10,ost_frame(a1) ; use large circular sprite

@makeitem:
		move.l	#Map_Jun,ost_mappings(a1)
		move.w	#tile_Nem_SbzWheel2+tile_pal3,ost_tile(a1)
		ori.b	#render_rel,ost_render(a1)
		move.b	#$38,ost_actwidth(a1)

	@fail:
		dbf	d1,@repeat

		move.b	#$30,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		move.w	#$3C,$30(a0)
		move.b	#1,jun_frame(a0)
		move.b	ost_subtype(a0),jun_switch(a0)

Jun_Action:	; Routine 2
		bsr.w	Jun_ChkSwitch
		tst.b	ost_render(a0)
		bpl.w	Jun_Display
		move.w	#$30,d1
		move.w	d1,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		btst	#5,ost_status(a0)	; is Sonic pushing the disc?
		beq.w	Jun_Display	; if not, branch

		lea	(v_player).w,a1
		moveq	#$E,d1
		move.w	ost_x_pos(a1),d0
		cmp.w	ost_x_pos(a0),d0	; is Sonic to the left of the disc?
		bcs.s	@isleft		; if yes, branch
		moveq	#7,d1		

	@isleft:
		cmp.b	ost_frame(a0),d1	; is the gap next to Sonic?
		bne.s	Jun_Display	; if not, branch

		move.b	d1,$32(a0)
		addq.b	#4,ost_routine(a0) ; goto Jun_Release next
		move.b	#1,(f_lockmulti).w ; lock controls
		move.b	#id_Roll,ost_anim(a1) ; make Sonic use "rolling" animation
		move.w	#$800,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)
		move.w	#0,ost_y_vel(a1)
		bclr	#5,ost_status(a0)
		bclr	#5,ost_status(a1)
		bset	#1,ost_status(a1)
		move.w	ost_x_pos(a1),d2
		move.w	ost_y_pos(a1),d3
		bsr.w	Jun_ChgPos
		add.w	d2,ost_x_pos(a1)
		add.w	d3,ost_y_pos(a1)
		asr	ost_x_pos(a1)
		asr	ost_y_pos(a1)

Jun_Display:	; Routine 4
		bra.w	RememberState
; ===========================================================================

Jun_Release:	; Routine 6
		move.b	ost_frame(a0),d0
		cmpi.b	#4,d0		; is gap pointing down?
		beq.s	@release	; if yes, branch
		cmpi.b	#7,d0		; is gap pointing right?
		bne.s	@dontrelease	; if not, branch

	@release:
		cmp.b	$32(a0),d0
		beq.s	@dontrelease
		lea	(v_player).w,a1
		move.w	#0,ost_x_vel(a1)
		move.w	#$800,ost_y_vel(a1)
		cmpi.b	#4,d0
		beq.s	@isdown
		move.w	#$800,ost_x_vel(a1)
		move.w	#$800,ost_y_vel(a1)

	@isdown:
		clr.b	(f_lockmulti).w	; unlock controls
		subq.b	#4,ost_routine(a0)

	@dontrelease:
		bsr.s	Jun_ChkSwitch
		bsr.s	Jun_ChgPos
		bra.w	RememberState

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Jun_ChkSwitch:
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	jun_switch(a0),d0
		btst	#0,(a2,d0.w)	; is switch pressed?
		beq.s	@unpressed	; if not, branch

		tst.b	jun_reverse(a0)	; has switch previously	been pressed?
		bne.s	@animate	; if yes, branch
		neg.b	jun_frame(a0)
		move.b	#1,jun_reverse(a0) ; set to "previously pressed"
		bra.s	@animate
; ===========================================================================

@unpressed:
		clr.b	jun_reverse(a0)	; set to "not yet pressed"

@animate:
		subq.b	#1,ost_anim_time(a0) ; decrement frame timer
		bpl.s	@nochange	; if time remains, branch
		move.b	#7,ost_anim_time(a0)
		move.b	jun_frame(a0),d1
		move.b	ost_frame(a0),d0
		add.b	d1,d0
		andi.b	#$F,d0
		move.b	d0,ost_frame(a0)	; update frame

	@nochange:
		rts	
; End of function Jun_ChkSwitch


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Jun_ChgPos:
		lea	(v_player).w,a1
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		add.w	d0,d0
		lea	@data(pc,d0.w),a2
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_y_pos(a0),d0
		move.w	d0,ost_y_pos(a1)
		rts	


@data:		dc.b -$20,    0, -$1E,   $E ; disc x-pos, Sonic x-pos, disc y-pos, Sonic y-pos
		dc.b -$18,  $18,  -$E,  $1E
		dc.b    0,  $20,   $E,  $1E
		dc.b  $18,  $18,  $1E,   $E
		dc.b  $20,    0,  $1E,  -$E
		dc.b  $18, -$18,   $E, -$1E
		dc.b    0, -$20,  -$E, -$1E
		dc.b -$18, -$18, -$1E,  -$E
