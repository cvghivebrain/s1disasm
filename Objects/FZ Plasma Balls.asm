; ---------------------------------------------------------------------------
; Object 86 - energy balls (FZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj86_Index(pc,d0.w),d0
		jmp	Obj86_Index(pc,d0.w)
; ===========================================================================
Obj86_Index:	index *,,2
		ptr Obj86_Main
		ptr Obj86_Generator
		ptr Obj86_MakeBalls
		ptr loc_1A962
		ptr loc_1A982

ost_plasma_flag:	equ $29	; flag set when firing
;			equ $30	; ?  (2 bytes)
;			equ $32	; ?  (2 bytes)
ost_plasma_parent:	equ $34	; address of OST of parent object (4 bytes)
;			equ $38	; ?  (2 bytes)
; ===========================================================================

Obj86_Main:	; Routine 0
		move.w	#$2588,ost_x_pos(a0)
		move.w	#$53C,ost_y_pos(a0)
		move.w	#tile_Nem_FzBoss,ost_tile(a0)
		move.l	#Map_PLaunch,ost_mappings(a0)
		move.b	#0,ost_anim(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_width(a0)
		move.b	#8,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		addq.b	#2,ost_routine(a0)

Obj86_Generator:; Routine 2
		movea.l	ost_plasma_parent(a0),a1
		cmpi.b	#6,ost_fz_mode(a1)
		bne.s	loc_1A850
		move.b	#id_ExplosionBomb,(a0)
		move.b	#0,ost_routine(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A850:
		move.b	#0,ost_anim(a0)
		tst.b	ost_plasma_flag(a0)
		beq.s	loc_1A86C
		addq.b	#2,ost_routine(a0)
		move.b	#1,ost_anim(a0)
		move.b	#$3E,ost_subtype(a0)

loc_1A86C:
		move.w	#$13,d1
		move.w	#8,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bmi.s	loc_1A89A
		subi.w	#$140,d0
		bmi.s	loc_1A89A
		tst.b	ost_render(a0)
		bpl.w	Obj84_Delete

loc_1A89A:
		lea	Ani_PLaunch(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Obj86_MakeBalls:; Routine 4
		tst.b	ost_plasma_flag(a0)
		beq.w	loc_1A954
		clr.b	ost_plasma_flag(a0)
		add.w	$30(a0),d0
		andi.w	#$1E,d0
		adda.w	d0,a2
		addq.w	#4,$30(a0)
		clr.w	$32(a0)
		moveq	#3,d2

Obj86_Loop:
		jsr	(FindNextFreeObj).l
		bne.w	loc_1A954
		move.b	#id_BossPlasma,(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	#$53C,ost_y_pos(a1)
		move.b	#8,ost_routine(a1)
		move.w	#tile_Nem_FzBoss+tile_pal2,ost_tile(a1)
		move.l	#Map_Plasma,ost_mappings(a1)
		move.b	#$C,ost_height(a1)
		move.b	#$C,ost_width(a1)
		move.b	#0,ost_col_type(a1)
		move.b	#3,ost_priority(a1)
		move.w	#$3E,ost_subtype(a1)
		move.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a1)
		move.l	a0,ost_plasma_parent(a1)
		jsr	(RandomNumber).l
		move.w	$32(a0),d1
		muls.w	#-$4F,d1
		addi.w	#$2578,d1
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d1,d0
		move.w	d0,$30(a1)
		addq.w	#1,$32(a0)
		move.w	$32(a0),$38(a0)
		dbf	d2,Obj86_Loop	; repeat sequence 3 more times

loc_1A954:
		tst.w	$32(a0)
		bne.s	loc_1A95E
		addq.b	#2,ost_routine(a0)

loc_1A95E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A962:	; Routine 6
		move.b	#2,ost_anim(a0)
		tst.w	$38(a0)
		bne.s	loc_1A97E
		move.b	#2,ost_routine(a0)
		movea.l	ost_plasma_parent(a0),a1
		move.w	#-1,$32(a1)

loc_1A97E:
		bra.w	loc_1A86C
; ===========================================================================

loc_1A982:	; Routine 8
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Obj86_Index2(pc,d0.w),d0
		jsr	Obj86_Index2(pc,d0.w)
		lea	Ani_Plasma(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
Obj86_Index2:	index *
		ptr loc_1A9A6
		ptr loc_1A9C0
		ptr loc_1AA1E
; ===========================================================================

loc_1A9A6:
		move.w	$30(a0),d0
		sub.w	ost_x_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,ost_x_vel(a0)
		move.w	#$B4,ost_subtype(a0)
		addq.b	#2,ost_routine2(a0)
		rts	
; ===========================================================================

loc_1A9C0:
		tst.w	ost_x_vel(a0)
		beq.s	loc_1A9E6
		jsr	(SpeedToPos).l
		move.w	ost_x_pos(a0),d0
		sub.w	$30(a0),d0
		bcc.s	loc_1A9E6
		clr.w	ost_x_vel(a0)
		add.w	d0,ost_x_pos(a0)
		movea.l	ost_plasma_parent(a0),a1
		subq.w	#1,$32(a1)

loc_1A9E6:
		move.b	#0,ost_anim(a0)
		subq.w	#1,ost_subtype(a0)
		bne.s	locret_1AA1C
		addq.b	#2,ost_routine2(a0)
		move.b	#1,ost_anim(a0)
		move.b	#$9A,ost_col_type(a0)
		move.w	#$B4,ost_subtype(a0)
		moveq	#0,d0
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_vel(a0)
		move.w	#$140,ost_y_vel(a0)

locret_1AA1C:
		rts	
; ===========================================================================

loc_1AA1E:
		jsr	(SpeedToPos).l
		cmpi.w	#$5E0,ost_y_pos(a0)
		bcc.s	loc_1AA34
		subq.w	#1,ost_subtype(a0)
		beq.s	loc_1AA34
		rts	
; ===========================================================================

loc_1AA34:
		movea.l	ost_plasma_parent(a0),a1
		subq.w	#1,$38(a1)
		bra.w	Obj84_Delete
