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

Obj84_PosData:	dc.w $24D0, $620				; bottom left
		dc.w $2550, $620				; bottom right
		dc.w $2490, $4C0				; top left
		dc.w $2510, $4C0				; top right

ost_cylinder_flag:	equ $29					; flag set when moving
;			equ $30	; ?  (2 bytes)
ost_cylinder_parent:	equ $34					; address of OST of parent object (4 bytes)
ost_cylinder_y_start:	equ $38					; original y position (2 bytes)
ost_cylinder_y_move:	equ $3C					; amount the cylinder has moved (4 bytes)
; ===========================================================================

Obj84_Main:	; Routine
		lea	Obj84_PosData(pc),a1
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (0/2/4/6)
		add.w	d0,d0
		adda.w	d0,a1
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		bset	#render_useheight_bit,ost_render(a0)
		move.w	#tile_Nem_FzBoss,ost_tile(a0)
		move.l	#Map_EggCyl,ost_mappings(a0)
		move.w	(a1)+,ost_x_pos(a0)
		move.w	(a1),ost_y_pos(a0)
		move.w	(a1)+,ost_cylinder_y_start(a0)
		move.b	#$20,ost_height(a0)
		move.b	#$60,ost_width(a0)
		move.b	#$20,ost_actwidth(a0)
		move.b	#$60,ost_height(a0)
		move.b	#3,ost_priority(a0)
		addq.b	#2,ost_routine(a0)

loc_1A4CE:	; Routine 2
		cmpi.b	#2,ost_subtype(a0)			; is cylinder on ceiling?
		ble.s	loc_1A4DC				; if not, branch
		bset	#status_yflip_bit,ost_render(a0)	; yflip

loc_1A4DC:
		clr.l	ost_cylinder_y_move(a0)
		tst.b	ost_cylinder_flag(a0)
		beq.s	loc_1A4EA
		addq.b	#2,ost_routine(a0)

loc_1A4EA:
		move.l	ost_cylinder_y_move(a0),d0
		move.l	ost_cylinder_y_start(a0),d1
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
		movea.l	ost_cylinder_parent(a0),a1
		move.w	d1,ost_y_pos(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)

loc_1A524:
		move.w	#$2B,d1
		move.w	#$60,d2
		move.w	#$61,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		moveq	#0,d0
		move.w	ost_cylinder_y_move(a0),d1
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
		move.w	(v_ost_player+ost_x_pos).w,d0
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
off_1A590:	index *,,2
		ptr Obj84_Bottom
		ptr Obj84_Bottom
		ptr Obj84_Top
		ptr Obj84_Top
; ===========================================================================

Obj84_Bottom:
		tst.b	ost_cylinder_flag(a0)
		bne.s	loc_1A5D4
		movea.l	ost_cylinder_parent(a0),a1
		tst.b	ost_col_property(a1)
		bne.s	loc_1A5B4
		bsr.w	BossExplode
		subi.l	#$10000,ost_cylinder_y_move(a0)

loc_1A5B4:
		addi.l	#$20000,ost_cylinder_y_move(a0)
		bcc.s	locret_1A602
		clr.l	ost_cylinder_y_move(a0)
		movea.l	ost_cylinder_parent(a0),a1
		subq.w	#1,$32(a1)
		clr.w	$30(a1)
		subq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

loc_1A5D4:
		cmpi.w	#-$10,ost_cylinder_y_move(a0)
		bge.s	loc_1A5E4
		subi.l	#$28000,ost_cylinder_y_move(a0)

loc_1A5E4:
		subi.l	#$8000,ost_cylinder_y_move(a0)
		cmpi.w	#-$A0,ost_cylinder_y_move(a0)
		bgt.s	locret_1A602
		clr.w	ost_cylinder_y_move+2(a0)
		move.w	#-$A0,ost_cylinder_y_move(a0)
		clr.b	ost_cylinder_flag(a0)

locret_1A602:
		rts	
; ===========================================================================

Obj84_Top:
		bset	#render_yflip_bit,ost_render(a0)
		tst.b	ost_cylinder_flag(a0)
		bne.s	loc_1A646
		movea.l	ost_cylinder_parent(a0),a1
		tst.b	ost_col_property(a1)
		bne.s	loc_1A626
		bsr.w	BossExplode
		addi.l	#$10000,ost_cylinder_y_move(a0)

loc_1A626:
		subi.l	#$20000,ost_cylinder_y_move(a0)
		bcc.s	locret_1A674
		clr.l	ost_cylinder_y_move(a0)
		movea.l	ost_cylinder_parent(a0),a1
		subq.w	#1,$32(a1)
		clr.w	$30(a1)
		subq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

loc_1A646:
		cmpi.w	#$10,ost_cylinder_y_move(a0)
		blt.s	loc_1A656
		addi.l	#$28000,ost_cylinder_y_move(a0)

loc_1A656:
		addi.l	#$8000,ost_cylinder_y_move(a0)
		cmpi.w	#$A0,ost_cylinder_y_move(a0)
		blt.s	locret_1A674
		clr.w	ost_cylinder_y_move+2(a0)
		move.w	#$A0,ost_cylinder_y_move(a0)
		clr.b	ost_cylinder_flag(a0)

locret_1A674:
		rts	
