; ---------------------------------------------------------------------------
; Object 68 - conveyor belts (SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Conv_Index(pc,d0.w),d1
		jmp	Conv_Index(pc,d1.w)
; ===========================================================================
Conv_Index:	index *,,2
		ptr Conv_Main
		ptr Conv_Action

conv_speed:	equ $36
conv_width:	equ $38
; ===========================================================================

Conv_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#128,conv_width(a0) ; set width to 128 pixels
		move.b	ost_subtype(a0),d1 ; get object type
		andi.b	#$F,d1		; read only the	2nd digit
		beq.s	@typeis0	; if zero, branch
		move.b	#56,conv_width(a0) ; set width to 56 pixels

	@typeis0:
		move.b	ost_subtype(a0),d1 ; get object type
		andi.b	#$F0,d1		; read only the	1st digit
		ext.w	d1
		asr.w	#4,d1
		move.w	d1,conv_speed(a0) ; set belt speed

Conv_Action:	; Routine 2
		bsr.s	@movesonic
		out_of_range.s	@delete
		rts	

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

@movesonic:
		moveq	#0,d2
		move.b	conv_width(a0),d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(v_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	@notonconveyor
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		addi.w	#$30,d1
		cmpi.w	#$30,d1
		bcc.s	@notonconveyor
		btst	#1,ost_status(a1)
		bne.s	@notonconveyor
		move.w	conv_speed(a0),d0
		add.w	d0,ost_x_pos(a1)

	@notonconveyor:
		rts	
