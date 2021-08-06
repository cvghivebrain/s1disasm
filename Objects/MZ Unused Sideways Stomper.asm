; ---------------------------------------------------------------------------
; Object 45 - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SStom_Index(pc,d0.w),d1
		jmp	SStom_Index(pc,d1.w)
; ===========================================================================
SStom_Index:	index *,,2
		ptr SStom_Main
		ptr SStom_Solid
		ptr loc_BA8E
		ptr SStom_Display
		ptr SStom_Pole

		;	routine		frame
		;		 xpos
SStom_Var:	dc.b	2,  	 4,	0	; main block
		dc.b	4,	-$1C,	1	; spikes
		dc.b	8,	 $34,	3	; pole
		dc.b	6,	 $28,	2	; wall bracket

;word_B9BE:	; Note that this indicates three subtypes
SStom_Len:	dc.w $3800	; short
		dc.w $A000	; long
		dc.w $5000	; medium
; ===========================================================================

SStom_Main:	; Routine 0
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	SStom_Len(pc,d0.w),d2
		lea	(SStom_Var).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	@load

	@loop:
		bsr.w	FindNextFreeObj
		bne.s	@fail

	@load:
		move.b	(a2)+,ost_routine(a1)
		move.b	#id_SideStomp,0(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_pos(a1)
		move.l	#Map_SStom,ost_mappings(a1)
		move.w	#tile_Nem_MzMetal,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.w	ost_x_pos(a1),$30(a1)
		move.w	ost_x_pos(a0),$3A(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#$20,ost_actwidth(a1)
		move.w	d2,$34(a1)
		move.b	#4,ost_priority(a1)
		cmpi.b	#1,(a2)		; is subobject spikes?
		bne.s	@notspikes	; if not, branch
		move.b	#$91,ost_col_type(a1) ; use harmful collision type

	@notspikes:
		move.b	(a2)+,ost_frame(a1)
		move.l	a0,$3C(a1)
		dbf	d1,@loop	; repeat 3 times

		move.b	#3,ost_priority(a1)

	@fail:
		move.b	#$10,ost_actwidth(a0)

SStom_Solid:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	SStom_Move
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		bra.w	SStom_ChkDel
; ===========================================================================

SStom_Pole:	; Routine 8
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,ost_frame(a0)

loc_BA8E:	; Routine 4
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,ost_x_pos(a0)

SStom_Display:	; Routine 6
		bsr.w	DisplaySprite

SStom_ChkDel:
		out_of_range	DeleteObject,$3A(a0)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SStom_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	off_BAD6(pc,d0.w),d1
		jmp	off_BAD6(pc,d1.w)
; End of function SStom_Move

; ===========================================================================
		; This indicates only two subtypes... that do the same thing
		; Compare to SStom_Len. This breaks subtype 02
off_BAD6:	index *
		ptr loc_BADA
		ptr loc_BADA
; ===========================================================================

loc_BADA:
		tst.w	$36(a0)
		beq.s	loc_BB08
		tst.w	$38(a0)
		beq.s	loc_BAEC
		subq.w	#1,$38(a0)
		bra.s	loc_BB3C
; ===========================================================================

loc_BAEC:
		subi.w	#$80,$32(a0)
		bcc.s	loc_BB3C
		move.w	#0,$32(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#0,$36(a0)
		bra.s	loc_BB3C
; ===========================================================================

loc_BB08:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_BB3C
		move.w	ost_x_vel(a0),d0
		addi.w	#$70,ost_x_vel(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_BB3C
		move.w	d1,$32(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

loc_BB3C:
		moveq	#0,d0
		move.b	$32(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,ost_x_pos(a0)
		rts
