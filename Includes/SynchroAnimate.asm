; ---------------------------------------------------------------------------
; Subroutine to	change synchronised animation variables (rings, giant rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_syncani_0_time).w ; has timer reached 0?
		bpl.s	Sync2		; if not, branch
		move.b	#$B,(v_syncani_0_time).w ; reset timer
		subq.b	#1,(v_syncani_0_frame).w ; next frame
		andi.b	#7,(v_syncani_0_frame).w ; max frame is 7

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_syncani_1_time).w
		bpl.s	Sync3
		move.b	#7,(v_syncani_1_time).w
		addq.b	#1,(v_syncani_1_frame).w
		andi.b	#3,(v_syncani_1_frame).w

; Used for nothing
Sync3:
		subq.b	#1,(v_syncani_2_time).w
		bpl.s	Sync4
		move.b	#7,(v_syncani_2_time).w
		addq.b	#1,(v_syncani_2_frame).w
		cmpi.b	#6,(v_syncani_2_frame).w
		blo.s	Sync4
		move.b	#0,(v_syncani_2_frame).w

; Used for bouncing rings
Sync4:
		tst.b	(v_syncani_3_time).w ; has timer reached 0? (starts at -1)
		beq.s	SyncEnd		; if yes, branch
		moveq	#0,d0
		move.b	(v_syncani_3_time).w,d0
		add.w	(v_syncani_3_accumulator).w,d0
		move.w	d0,(v_syncani_3_accumulator).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_syncani_3_frame).w
		subq.b	#1,(v_syncani_3_time).w

SyncEnd:
		rts	
; End of function SynchroAnimate
