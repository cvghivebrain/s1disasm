; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


GBall_Move:
		tst.b	ost_ball_direction(a0) ; is ball swinging right?
		bne.s	@right		; if yes, branch
		move.w	ost_ball_angle(a0),d0
		addq.w	#8,d0
		move.w	d0,ost_ball_angle(a0)
		add.w	d0,ost_angle(a0)
		cmpi.w	#$200,d0
		bne.s	@not_at_highest
		move.b	#1,ost_ball_direction(a0)
		bra.s	@not_at_highest
; ===========================================================================

	@right:
		move.w	ost_ball_angle(a0),d0
		subq.w	#8,d0
		move.w	d0,ost_ball_angle(a0)
		add.w	d0,ost_angle(a0)
		cmpi.w	#-$200,d0
		bne.s	@not_at_highest
		move.b	#0,ost_ball_direction(a0)

	@not_at_highest:
		move.b	ost_angle(a0),d0
; End of function GBall_Move
