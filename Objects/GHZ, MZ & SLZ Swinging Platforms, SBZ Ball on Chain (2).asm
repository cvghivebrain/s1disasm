; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Move2:
		bsr.w	CalcSine
		move.w	ost_swing_y_start(a0),d2
		move.w	ost_swing_x_start(a0),d3
		lea	ost_subtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_7BCE:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_ost_all&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	ost_swing_radius(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a1)
		move.w	d5,ost_x_pos(a1)
		dbf	d6,loc_7BCE
		rts	
; End of function Swing_Move2

; ===========================================================================

Swing_ChkDel:
		out_of_range	Swing_DelAll,ost_swing_x_start(a0)
		rts	
; ===========================================================================

Swing_DelAll:
		moveq	#0,d2
		lea	ost_subtype(a0),a2
		move.b	(a2)+,d2

Swing_DelLoop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,Swing_DelLoop ; repeat for length of	chain
		rts	
; ===========================================================================

Swing_Delete:	; Routine 6, 8
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Swing_Display:	; Routine $A
		bra.w	DisplaySprite
