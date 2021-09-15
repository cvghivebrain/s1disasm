; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Edge_SolidWall:
		bsr.w	Edge_SolidWall2
		beq.s	loc_8AA8
		bmi.w	loc_8AC4
		tst.w	d0
		beq.w	loc_8A92
		bmi.s	loc_8A7C
		tst.w	ost_x_vel(a1)
		bmi.s	loc_8A92
		bra.s	loc_8A82
; ===========================================================================

loc_8A7C:
		tst.w	ost_x_vel(a1)
		bpl.s	loc_8A92

loc_8A82:
		sub.w	d0,ost_x_pos(a1)
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)

loc_8A92:
		btst	#status_air_bit,ost_status(a1)
		bne.s	loc_8AB6
		bset	#status_pushing_bit,ost_status(a1)
		bset	#status_pushing_bit,ost_status(a0)
		rts	
; ===========================================================================

loc_8AA8:
		btst	#status_pushing_bit,ost_status(a0)
		beq.s	locret_8AC2
		move.w	#id_Run,ost_anim(a1)

loc_8AB6:
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a1)

locret_8AC2:
		rts	
; ===========================================================================

loc_8AC4:
		tst.w	ost_y_vel(a1)
		bpl.s	locret_8AD8
		tst.w	d3
		bpl.s	locret_8AD8
		sub.w	d3,ost_y_pos(a1)
		move.w	#0,ost_y_vel(a1)

locret_8AD8:
		rts	
; End of function Edge_SolidWall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Edge_SolidWall2:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	loc_8B48
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8B48
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ost_y_pos(a1),d3
		sub.w	ost_y_pos(a0),d3
		add.w	d2,d3
		bmi.s	loc_8B48
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	loc_8B48
		tst.b	(f_lockmulti).w
		bmi.s	loc_8B48
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w
		bhs.s	loc_8B48
		tst.w	(v_debuguse).w
		bne.s	loc_8B48
		move.w	d0,d5
		cmp.w	d0,d1
		bhs.s	loc_8B30
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_8B30:
		move.w	d3,d1
		cmp.w	d3,d2
		bhs.s	loc_8B3C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_8B3C:
		cmp.w	d1,d5
		bhi.s	loc_8B44
		moveq	#1,d4
		rts	
; ===========================================================================

loc_8B44:
		moveq	#-1,d4
		rts	
; ===========================================================================

loc_8B48:
		moveq	#0,d4
		rts	
; End of function Edge_SolidWall2
