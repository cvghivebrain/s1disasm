; ---------------------------------------------------------------------------
; Subroutine to	change synchronised animation variables (rings, giant rings)

;	uses d0.l
; ---------------------------------------------------------------------------

SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_syncani_0_time).w			; decrement timer
		bpl.s	Sync2					; branch if time remains
		move.b	#11,(v_syncani_0_time).w		; reset timer
		subq.b	#1,(v_syncani_0_frame).w		; decrement frame
		andi.b	#7,(v_syncani_0_frame).w		; wraps to 7 after 0

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_syncani_1_time).w			; decrement timer
		bpl.s	Sync3					; branch if time remains
		move.b	#7,(v_syncani_1_time).w			; reset timer
		addq.b	#1,(v_syncani_1_frame).w		; increment frame
		andi.b	#3,(v_syncani_1_frame).w		; wraps to 0 after 3

; Used for nothing
Sync3:
		subq.b	#1,(v_syncani_2_time).w			; decrement timer
		bpl.s	Sync4					; branch if time remains
		move.b	#7,(v_syncani_2_time).w			; reset timer
		addq.b	#1,(v_syncani_2_frame).w		; increment frame
		cmpi.b	#6,(v_syncani_2_frame).w
		blo.s	Sync4					; branch if 0-5
		move.b	#0,(v_syncani_2_frame).w		; wraps to 0 after 5

; Used for bouncing rings
Sync4:
		tst.b	(v_syncani_3_time).w			; this is set to 255 when Sonic loses rings
		beq.s	SyncEnd					; branch if 0
		moveq	#0,d0
		move.b	(v_syncani_3_time).w,d0
		add.w	(v_syncani_3_accumulator).w,d0
		move.w	d0,(v_syncani_3_accumulator).w		; add timer to accumulator
		rol.w	#7,d0
		andi.w	#3,d0					; read only bits $E-$11
		move.b	d0,(v_syncani_3_frame).w		; use those bits as frame (0-3)
		subq.b	#1,(v_syncani_3_time).w			; decrement timer

SyncEnd:
		rts
