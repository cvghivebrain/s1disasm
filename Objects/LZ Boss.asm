; ---------------------------------------------------------------------------
; Object 77 - Eggman (LZ)
; ---------------------------------------------------------------------------

BossLabyrinth:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj77_Index(pc,d0.w),d1
		jmp	Obj77_Index(pc,d1.w)
; ===========================================================================
Obj77_Index:	index *,,2
		ptr Obj77_Main
		ptr Obj77_ShipMain
		ptr Obj77_FaceMain
		ptr Obj77_FlameMain

Obj77_ObjData:	dc.b id_Obj77_ShipMain,	id_ani_boss_ship	; routine number, animation
		dc.b id_Obj77_FaceMain,	id_ani_boss_face1
		dc.b id_Obj77_FlameMain, id_ani_boss_blank

ost_blz_parent_x_pos:	equ $30					; parent x position (2 bytes)
ost_blz_parent:		equ $34					; address of OST of parent object (4 bytes)
ost_blz_parent_y_pos:	equ $38					; parent y position (2 bytes)
ost_blz_wait_time:	equ $3C					; time to wait between each action (2 bytes)
ost_blz_flash_num:	equ $3E					; number of times to make boss flash when hit
ost_blz_wobble:		equ $3F					; wobble state as Eggman moves back & forth (1 byte incremented every frame & interpreted by CalcSine)
; ===========================================================================

Obj77_Main:	; Routine 0
		move.w	#$1E10,ost_x_pos(a0)
		move.w	#$5C0,ost_y_pos(a0)
		move.w	ost_x_pos(a0),ost_blz_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_blz_parent_y_pos(a0)
		move.b	#id_col_24x24,ost_col_type(a0)
		move.b	#8,ost_col_property(a0)			; set number of hits to 8
		move.b	#4,ost_priority(a0)
		lea	Obj77_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	Obj77_LoadBoss
; ===========================================================================

Obj77_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	Obj77_ShipMain
		move.b	#id_BossLabyrinth,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

Obj77_LoadBoss:
		bclr	#status_xflip_bit,ost_status(a0)
		clr.b	ost_routine2(a1)
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,ost_anim(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.l	#Map_Eggman,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.l	a0,ost_blz_parent(a1)
		dbf	d1,Obj77_Loop

Obj77_ShipMain:	; Routine 2
		lea	(v_ost_player).w,a1
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Obj77_ShipIndex(pc,d0.w),d1
		jsr	Obj77_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
Obj77_ShipIndex:index *
		ptr loc_17F1E
		ptr loc_17FA0
		ptr loc_17FE0
		ptr loc_1801E
		ptr loc_180BC
		ptr loc_180F6
		ptr loc_1812A
		ptr loc_18152
; ===========================================================================

loc_17F1E:
		move.w	ost_x_pos(a1),d0
		cmpi.w	#$1DA0,d0
		bcs.s	loc_17F38
		move.w	#-$180,ost_y_vel(a0)
		move.w	#$60,ost_x_vel(a0)
		addq.b	#2,ost_routine2(a0)

loc_17F38:
		bsr.w	BossMove
		move.w	ost_blz_parent_y_pos(a0),ost_y_pos(a0)
		move.w	ost_blz_parent_x_pos(a0),ost_x_pos(a0)

loc_17F48:
		tst.b	ost_blz_wait_time+1(a0)
		bne.s	loc_17F8E
		tst.b	ost_status(a0)
		bmi.s	loc_17F92
		tst.b	ost_col_type(a0)
		bne.s	locret_17F8C
		tst.b	ost_blz_flash_num(a0)
		bne.s	loc_17F70
		move.b	#$20,ost_blz_flash_num(a0)
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

loc_17F70:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_17F7E
		move.w	#cWhite,d0

loc_17F7E:
		move.w	d0,(a1)
		subq.b	#1,ost_blz_flash_num(a0)
		bne.s	locret_17F8C
		move.b	#id_col_24x24,ost_col_type(a0)

locret_17F8C:
		rts	
; ===========================================================================

loc_17F8E:
		bra.w	BossDefeated
; ===========================================================================

loc_17F92:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#-1,ost_blz_wait_time+1(a0)
		rts	
; ===========================================================================

loc_17FA0:
		moveq	#-2,d0
		cmpi.w	#$1E48,ost_blz_parent_x_pos(a0)
		bcs.s	loc_17FB6
		move.w	#$1E48,ost_blz_parent_x_pos(a0)
		clr.w	ost_x_vel(a0)
		addq.w	#1,d0

loc_17FB6:
		cmpi.w	#$500,ost_blz_parent_y_pos(a0)
		bgt.s	loc_17FCA
		move.w	#$500,ost_blz_parent_y_pos(a0)
		clr.w	ost_y_vel(a0)
		addq.w	#1,d0

loc_17FCA:
		bne.s	loc_17FDC
		move.w	#$140,ost_x_vel(a0)
		move.w	#-$200,ost_y_vel(a0)
		addq.b	#2,ost_routine2(a0)

loc_17FDC:
		bra.w	loc_17F38
; ===========================================================================

loc_17FE0:
		moveq	#-2,d0
		cmpi.w	#$1E70,ost_blz_parent_x_pos(a0)
		bcs.s	loc_17FF6
		move.w	#$1E70,ost_blz_parent_x_pos(a0)
		clr.w	ost_x_vel(a0)
		addq.w	#1,d0

loc_17FF6:
		cmpi.w	#$4C0,ost_blz_parent_y_pos(a0)
		bgt.s	loc_1800A
		move.w	#$4C0,ost_blz_parent_y_pos(a0)
		clr.w	ost_y_vel(a0)
		addq.w	#1,d0

loc_1800A:
		bne.s	loc_1801A
		move.w	#-$180,ost_y_vel(a0)
		addq.b	#2,ost_routine2(a0)
		clr.b	ost_blz_wobble(a0)

loc_1801A:
		bra.w	loc_17F38
; ===========================================================================

loc_1801E:
		cmpi.w	#$100,ost_blz_parent_y_pos(a0)
		bgt.s	loc_1804E
		move.w	#$100,ost_blz_parent_y_pos(a0)
		move.w	#$140,ost_x_vel(a0)
		move.w	#-$80,ost_y_vel(a0)
		tst.b	ost_blz_wait_time+1(a0)
		beq.s	loc_18046
		asl	ost_x_vel(a0)
		asl	ost_y_vel(a0)

loc_18046:
		addq.b	#2,ost_routine2(a0)
		bra.w	loc_17F38
; ===========================================================================

loc_1804E:
		bset	#status_xflip_bit,ost_status(a0)
		addq.b	#2,ost_blz_wobble(a0)
		move.b	ost_blz_wobble(a0),d0
		jsr	(CalcSine).l
		tst.w	d1
		bpl.s	loc_1806C
		bclr	#status_xflip_bit,ost_status(a0)

loc_1806C:
		asr.w	#4,d0
		swap	d0
		clr.w	d0
		add.l	ost_blz_parent_x_pos(a0),d0
		swap	d0
		move.w	d0,ost_x_pos(a0)
		move.w	ost_y_vel(a0),d0
		move.w	(v_ost_player+ost_y_pos).w,d1
		sub.w	ost_y_pos(a0),d1
		bcs.s	loc_180A2
		subi.w	#$48,d1
		bcs.s	loc_180A2
		asr.w	#1,d0
		subi.w	#$28,d1
		bcs.s	loc_180A2
		asr.w	#1,d0
		subi.w	#$28,d1
		bcs.s	loc_180A2
		moveq	#0,d0

loc_180A2:
		ext.l	d0
		asl.l	#8,d0
		tst.b	ost_blz_wait_time+1(a0)
		beq.s	loc_180AE
		add.l	d0,d0

loc_180AE:
		add.l	d0,ost_blz_parent_y_pos(a0)
		move.w	ost_blz_parent_y_pos(a0),ost_y_pos(a0)
		bra.w	loc_17F48
; ===========================================================================

loc_180BC:
		moveq	#-2,d0
		cmpi.w	#$1F4C,ost_blz_parent_x_pos(a0)
		bcs.s	loc_180D2
		move.w	#$1F4C,ost_blz_parent_x_pos(a0)
		clr.w	ost_x_vel(a0)
		addq.w	#1,d0

loc_180D2:
		cmpi.w	#$C0,ost_blz_parent_y_pos(a0)
		bgt.s	loc_180E6
		move.w	#$C0,ost_blz_parent_y_pos(a0)
		clr.w	ost_y_vel(a0)
		addq.w	#1,d0

loc_180E6:
		bne.s	loc_180F2
		addq.b	#2,ost_routine2(a0)
		bclr	#status_xflip_bit,ost_status(a0)

loc_180F2:
		bra.w	loc_17F38
; ===========================================================================

loc_180F6:
		tst.b	ost_blz_wait_time+1(a0)
		bne.s	loc_18112
		cmpi.w	#$1EC8,ost_x_pos(a1)
		blt.s	loc_18126
		cmpi.w	#$F0,ost_y_pos(a1)
		bgt.s	loc_18126
		move.b	#$32,ost_blz_wait_time(a0)

loc_18112:
		play.w	0, jsr, mus_LZ				; play LZ music
		if Revision<>0
			clr.b	(f_boss_boundary).w
		endc
		bset	#status_xflip_bit,ost_status(a0)
		addq.b	#2,ost_routine2(a0)

loc_18126:
		bra.w	loc_17F38
; ===========================================================================

loc_1812A:
		tst.b	ost_blz_wait_time+1(a0)
		bne.s	loc_18136
		subq.b	#1,ost_blz_wait_time(a0)
		bne.s	loc_1814E

loc_18136:
		clr.b	ost_blz_wait_time(a0)
		move.w	#$400,ost_x_vel(a0)
		move.w	#-$40,ost_y_vel(a0)
		clr.b	ost_blz_wait_time+1(a0)
		addq.b	#2,ost_routine2(a0)

loc_1814E:
		bra.w	loc_17F38
; ===========================================================================

loc_18152:
		cmpi.w	#$2030,(v_boundary_right).w
		bcc.s	loc_18160
		addq.w	#2,(v_boundary_right).w
		bra.s	loc_18166
; ===========================================================================

loc_18160:
		tst.b	ost_render(a0)
		bpl.s	Obj77_ShipDel

loc_18166:
		bra.w	loc_17F38
; ===========================================================================

Obj77_ShipDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj77_FaceMain:	; Routine 4
		movea.l	ost_blz_parent(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.s	Obj77_FaceDel
		moveq	#0,d0
		move.b	ost_routine2(a1),d0
		moveq	#id_ani_boss_face1,d1
		tst.b	ost_blz_wait_time+1(a0)
		beq.s	loc_1818C
		moveq	#id_ani_boss_defeat,d1
		bra.s	loc_181A0
; ===========================================================================

loc_1818C:
		tst.b	ost_col_type(a1)
		bne.s	loc_18196
		moveq	#id_ani_boss_hit,d1
		bra.s	loc_181A0
; ===========================================================================

loc_18196:
		cmpi.b	#id_Sonic_Hurt,(v_ost_player+ost_routine).w
		bcs.s	loc_181A0
		moveq	#id_ani_boss_laugh,d1

loc_181A0:
		move.b	d1,ost_anim(a0)
		cmpi.b	#$E,d0
		bne.s	loc_181B6
		move.b	#id_ani_boss_panic,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	Obj77_FaceDel

loc_181B6:
		bra.s	Obj77_Display
; ===========================================================================

Obj77_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj77_FlameMain:; Routine 6
		move.b	#id_ani_boss_blank,ost_anim(a0)
		movea.l	ost_blz_parent(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.s	Obj77_FlameDel
		cmpi.b	#$E,ost_routine2(a1)
		bne.s	loc_181F0
		move.b	#id_ani_boss_bigflame,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	Obj77_FlameDel
		bra.s	loc_181F0
; ===========================================================================
		tst.w	ost_x_vel(a1)
		beq.s	loc_181F0
		move.b	#id_ani_boss_flame1,ost_anim(a0)

loc_181F0:
		bra.s	Obj77_Display
; ===========================================================================

Obj77_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj77_Display:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		movea.l	ost_blz_parent(a0),a1
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d0,ost_render(a0)
		jmp	(DisplaySprite).l
