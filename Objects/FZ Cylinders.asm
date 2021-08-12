; ---------------------------------------------------------------------------
; Object 84 - cylinder Eggman hides in (FZ)
; ---------------------------------------------------------------------------

Obj84_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

EggmanCylinder:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj84_Index(pc,d0.w),d0
		jmp	Obj84_Index(pc,d0.w)
; ===========================================================================
Obj84_Index:	index *,,2
		ptr Obj84_Main
		ptr loc_1A4CE
		ptr loc_1A57E

Obj84_PosData:	dc.w $24D0, $620
		dc.w $2550, $620
		dc.w $2490, $4C0
		dc.w $2510, $4C0
; ===========================================================================

Obj84_Main:	; Routine
		lea	Obj84_PosData(pc),a1
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		adda.w	d0,a1
		move.b	#render_rel,ost_render(a0)
		bset	#7,ost_render(a0)
		bset	#4,ost_render(a0)
		move.w	#tile_Nem_FzBoss,ost_tile(a0)
		move.l	#Map_EggCyl,ost_mappings(a0)
		move.w	(a1)+,ost_x_pos(a0)
		move.w	(a1),ost_y_pos(a0)
		move.w	(a1)+,$38(a0)
		move.b	#$20,ost_height(a0)
		move.b	#$60,ost_width(a0)
		move.b	#$20,ost_actwidth(a0)
		move.b	#$60,ost_height(a0)
		move.b	#3,ost_priority(a0)
		addq.b	#2,ost_routine(a0)

loc_1A4CE:	; Routine 2
		cmpi.b	#2,ost_subtype(a0)
		ble.s	loc_1A4DC
		bset	#1,ost_render(a0)

loc_1A4DC:
		clr.l	$3C(a0)
		tst.b	$29(a0)
		beq.s	loc_1A4EA
		addq.b	#2,ost_routine(a0)

loc_1A4EA:
		move.l	$3C(a0),d0
		move.l	$38(a0),d1
		add.l	d0,d1
		swap	d1
		move.w	d1,ost_y_pos(a0)
		cmpi.b	#4,ost_routine(a0)
		bne.s	loc_1A524
		tst.w	$30(a0)
		bpl.s	loc_1A524
		moveq	#-$A,d0
		cmpi.b	#2,ost_subtype(a0)
		ble.s	loc_1A514
		moveq	#$E,d0

loc_1A514:
		add.w	d0,d1
		movea.l	$34(a0),a1
		move.w	d1,ost_y_pos(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)

loc_1A524:
		move.w	#$2B,d1
		move.w	#$60,d2
		move.w	#$61,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		moveq	#0,d0
		move.w	$3C(a0),d1
		bpl.s	loc_1A550
		neg.w	d1
		subq.w	#8,d1
		bcs.s	loc_1A55C
		addq.b	#1,d0
		asr.w	#4,d1
		add.w	d1,d0
		bra.s	loc_1A55C
; ===========================================================================

loc_1A550:
		subi.w	#$27,d1
		bcs.s	loc_1A55C
		addq.b	#1,d0
		asr.w	#4,d1
		add.w	d1,d0

loc_1A55C:
		move.b	d0,ost_frame(a0)
		move.w	(v_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bmi.s	loc_1A578
		subi.w	#$140,d0
		bmi.s	loc_1A578
		tst.b	ost_render(a0)
		bpl.w	Obj84_Delete

loc_1A578:
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A57E:	; Routine 4
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.w	off_1A590(pc,d0.w),d0
		jsr	off_1A590(pc,d0.w)
		bra.w	loc_1A4EA
; ===========================================================================
off_1A590:	index *
		ptr loc_1A598
		ptr loc_1A598
		ptr loc_1A604
		ptr loc_1A604
; ===========================================================================

loc_1A598:
		tst.b	$29(a0)
		bne.s	loc_1A5D4
		movea.l	$34(a0),a1
		tst.b	ost_col_property(a1)
		bne.s	loc_1A5B4
		bsr.w	BossDefeated
		subi.l	#$10000,$3C(a0)

loc_1A5B4:
		addi.l	#$20000,$3C(a0)
		bcc.s	locret_1A602
		clr.l	$3C(a0)
		movea.l	$34(a0),a1
		subq.w	#1,$32(a1)
		clr.w	$30(a1)
		subq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

loc_1A5D4:
		cmpi.w	#-$10,$3C(a0)
		bge.s	loc_1A5E4
		subi.l	#$28000,$3C(a0)

loc_1A5E4:
		subi.l	#$8000,$3C(a0)
		cmpi.w	#-$A0,$3C(a0)
		bgt.s	locret_1A602
		clr.w	$3E(a0)
		move.w	#-$A0,$3C(a0)
		clr.b	$29(a0)

locret_1A602:
		rts	
; ===========================================================================

loc_1A604:
		bset	#1,ost_render(a0)
		tst.b	$29(a0)
		bne.s	loc_1A646
		movea.l	$34(a0),a1
		tst.b	ost_col_property(a1)
		bne.s	loc_1A626
		bsr.w	BossDefeated
		addi.l	#$10000,$3C(a0)

loc_1A626:
		subi.l	#$20000,$3C(a0)
		bcc.s	locret_1A674
		clr.l	$3C(a0)
		movea.l	$34(a0),a1
		subq.w	#1,$32(a1)
		clr.w	$30(a1)
		subq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

loc_1A646:
		cmpi.w	#$10,$3C(a0)
		blt.s	loc_1A656
		addi.l	#$28000,$3C(a0)

loc_1A656:
		addi.l	#$8000,$3C(a0)
		cmpi.w	#$A0,$3C(a0)
		blt.s	locret_1A674
		clr.w	$3E(a0)
		move.w	#$A0,$3C(a0)
		clr.b	$29(a0)

locret_1A674:
		rts	
