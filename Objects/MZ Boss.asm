; ---------------------------------------------------------------------------
; Object 73 - Eggman (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj73_Index(pc,d0.w),d1
		jmp	Obj73_Index(pc,d1.w)
; ===========================================================================
Obj73_Index:	index *,,2
		ptr Obj73_Main
		ptr Obj73_ShipMain
		ptr Obj73_FaceMain
		ptr Obj73_FlameMain
		ptr Obj73_TubeMain

Obj73_ObjData:	dc.b id_Obj73_ShipMain,	id_ani_boss_ship, 4		; routine number, animation, priority
		dc.b id_Obj73_FaceMain,	id_ani_boss_face1, 4
		dc.b id_Obj73_FlameMain, id_ani_boss_blank, 4
		dc.b id_Obj73_TubeMain,	0, 3

ost_bmz_parent_x_pos:	equ $30	; parent x position (2 bytes)
ost_bmz_lava_time:	equ $34	; time between fireballs coming out of lava - parent only
ost_bmz_parent:		equ $34	; address of OST of parent object - children only (4 bytes)
ost_bmz_parent_y_pos:	equ $38	; parent y position (2 bytes)
ost_bmz_wait_time:	equ $3C	; time to wait between each action (2 bytes)
ost_bmz_flash_num:	equ $3E	; number of times to make boss flash when hit
ost_bmz_wobble:		equ $3F	; wobble state as Eggman moves back & forth (1 byte incremented every frame & interpreted by CalcSine)
; ===========================================================================

Obj73_Main:	; Routine 0
		move.w	ost_x_pos(a0),ost_bmz_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_bmz_parent_y_pos(a0)
		move.b	#$F,ost_col_type(a0)
		move.b	#8,ost_col_property(a0) ; set number of hits to 8
		lea	Obj73_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	Obj73_LoadBoss
; ===========================================================================

Obj73_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	Obj73_ShipMain
		move.b	#id_BossMarble,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

Obj73_LoadBoss:
		bclr	#status_xflip_bit,ost_status(a0)
		clr.b	ost_routine2(a1)
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,ost_anim(a1)
		move.b	(a2)+,ost_priority(a1)
		move.l	#Map_Eggman,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.l	a0,ost_bmz_parent(a1)
		dbf	d1,Obj73_Loop	; repeat sequence 3 more times

Obj73_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Obj73_ShipIndex(pc,d0.w),d1
		jsr	Obj73_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0) ; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
Obj73_ShipIndex:index *,,2
		ptr Obj73_ShipStart
		ptr loc_183AA
		ptr loc_184F6
		ptr loc_1852C
		ptr loc_18582
; ===========================================================================

Obj73_ShipStart:
		move.b	ost_bmz_wobble(a0),d0
		addq.b	#2,ost_bmz_wobble(a0)
		jsr	(CalcSine).l
		asr.w	#2,d0
		move.w	d0,ost_y_vel(a0)
		move.w	#-$100,ost_x_vel(a0)
		bsr.w	BossMove
		cmpi.w	#$1910,ost_bmz_parent_x_pos(a0)
		bne.s	loc_18334
		addq.b	#2,ost_routine2(a0)
		clr.b	ost_subtype(a0)
		clr.l	ost_x_vel(a0)

loc_18334:
		jsr	(RandomNumber).l
		move.b	d0,ost_bmz_lava_time(a0)

loc_1833E:
		move.w	ost_bmz_parent_y_pos(a0),ost_y_pos(a0)
		move.w	ost_bmz_parent_x_pos(a0),ost_x_pos(a0)
		cmpi.b	#4,ost_routine2(a0)
		bcc.s	locret_18390
		tst.b	ost_status(a0)
		bmi.s	loc_18392
		tst.b	ost_col_type(a0)
		bne.s	locret_18390
		tst.b	ost_bmz_flash_num(a0)
		bne.s	loc_18374
		move.b	#$28,ost_bmz_flash_num(a0)
		sfx	sfx_BossHit,0,0,0 ; play boss damage sound

loc_18374:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_18382
		move.w	#cWhite,d0

loc_18382:
		move.w	d0,(a1)
		subq.b	#1,ost_bmz_flash_num(a0)
		bne.s	locret_18390
		move.b	#$F,ost_col_type(a0)

locret_18390:
		rts	
; ===========================================================================

loc_18392:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#4,ost_routine2(a0)
		move.w	#$B4,ost_bmz_wait_time(a0)
		clr.w	ost_x_vel(a0)
		rts	
; ===========================================================================

loc_183AA:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.w	off_183C2(pc,d0.w),d0
		jsr	off_183C2(pc,d0.w)
		andi.b	#6,ost_subtype(a0)
		bra.w	loc_1833E
; ===========================================================================
off_183C2:	index *
		ptr loc_183CA
		ptr Obj73_MakeLava2
		ptr loc_183CA
		ptr Obj73_MakeLava2
; ===========================================================================

loc_183CA:
		tst.w	ost_x_vel(a0)
		bne.s	loc_183FE
		moveq	#$40,d0
		cmpi.w	#$22C,ost_bmz_parent_y_pos(a0)
		beq.s	loc_183E6
		bcs.s	loc_183DE
		neg.w	d0

loc_183DE:
		move.w	d0,ost_y_vel(a0)
		bra.w	BossMove
; ===========================================================================

loc_183E6:
		move.w	#$200,ost_x_vel(a0)
		move.w	#$100,ost_y_vel(a0)
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	loc_183FE
		neg.w	ost_x_vel(a0)

loc_183FE:
		cmpi.b	#$18,ost_bmz_flash_num(a0)
		bcc.s	Obj73_MakeLava
		bsr.w	BossMove
		subq.w	#4,ost_y_vel(a0)

Obj73_MakeLava:
		subq.b	#1,ost_bmz_lava_time(a0)
		bcc.s	loc_1845C
		jsr	(FindFreeObj).l
		bne.s	loc_1844A
		move.b	#id_LavaBall,0(a1) ; load fireball object that comes from lava
		move.w	#$2E8,ost_y_pos(a1) ; set y position
		jsr	(RandomNumber).l
		andi.l	#$FFFF,d0
		divu.w	#$50,d0
		swap	d0
		addi.w	#$1878,d0
		move.w	d0,ost_x_pos(a1)
		lsr.b	#7,d1
		move.w	#$FF,ost_subtype(a1)

loc_1844A:
		jsr	(RandomNumber).l
		andi.b	#$1F,d0
		addi.b	#$40,d0
		move.b	d0,ost_bmz_lava_time(a0)

loc_1845C:
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_18474
		cmpi.w	#$1910,ost_bmz_parent_x_pos(a0)
		blt.s	locret_1849C
		move.w	#$1910,ost_bmz_parent_x_pos(a0)
		bra.s	loc_18482
; ===========================================================================

loc_18474:
		cmpi.w	#$1830,ost_bmz_parent_x_pos(a0)
		bgt.s	locret_1849C
		move.w	#$1830,ost_bmz_parent_x_pos(a0)

loc_18482:
		clr.w	ost_x_vel(a0)
		move.w	#-$180,ost_y_vel(a0)
		cmpi.w	#$22C,ost_bmz_parent_y_pos(a0)
		bcc.s	loc_18498
		neg.w	ost_y_vel(a0)

loc_18498:
		addq.b	#2,ost_subtype(a0)

locret_1849C:
		rts	
; ===========================================================================

Obj73_MakeLava2:
		bsr.w	BossMove
		move.w	ost_bmz_parent_y_pos(a0),d0
		subi.w	#$22C,d0
		bgt.s	locret_184F4
		move.w	#$22C,d0
		tst.w	ost_y_vel(a0)
		beq.s	loc_184EA
		clr.w	ost_y_vel(a0)
		move.w	#$50,ost_bmz_wait_time(a0)
		bchg	#status_xflip_bit,ost_status(a0)
		jsr	(FindFreeObj).l
		bne.s	loc_184EA
		move.w	ost_bmz_parent_x_pos(a0),ost_x_pos(a1)
		move.w	ost_bmz_parent_y_pos(a0),ost_y_pos(a1)
		addi.w	#$18,ost_y_pos(a1)
		move.b	#id_BossFire,(a1) ; load lava ball object that comes from ship
		move.b	#1,ost_subtype(a1)

loc_184EA:
		subq.w	#1,ost_bmz_wait_time(a0)
		bne.s	locret_184F4
		addq.b	#2,ost_subtype(a0)

locret_184F4:
		rts	
; ===========================================================================

loc_184F6:
		subq.w	#1,ost_bmz_wait_time(a0)
		bmi.s	loc_18500
		bra.w	BossDefeated
; ===========================================================================

loc_18500:
		bset	#status_xflip_bit,ost_status(a0)
		bclr	#status_onscreen_bit,ost_status(a0)
		clr.w	ost_x_vel(a0)
		addq.b	#2,ost_routine2(a0)
		move.w	#-$26,ost_bmz_wait_time(a0)
		tst.b	(v_boss_status).w
		bne.s	locret_1852A
		move.b	#1,(v_boss_status).w
		clr.w	ost_y_vel(a0)

locret_1852A:
		rts	
; ===========================================================================

loc_1852C:
		addq.w	#1,ost_bmz_wait_time(a0)
		beq.s	loc_18544
		bpl.s	loc_1854E
		cmpi.w	#$270,ost_bmz_parent_y_pos(a0)
		bcc.s	loc_18544
		addi.w	#$18,ost_y_vel(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_18544:
		clr.w	ost_y_vel(a0)
		clr.w	ost_bmz_wait_time(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_1854E:
		cmpi.w	#$30,ost_bmz_wait_time(a0)
		bcs.s	loc_18566
		beq.s	loc_1856C
		cmpi.w	#$38,ost_bmz_wait_time(a0)
		bcs.s	loc_1857A
		addq.b	#2,ost_routine2(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_18566:
		subq.w	#8,ost_y_vel(a0)
		bra.s	loc_1857A
; ===========================================================================

loc_1856C:
		clr.w	ost_y_vel(a0)
		music	mus_MZ,0,0,0	; play MZ music

loc_1857A:
		bsr.w	BossMove
		bra.w	loc_1833E
; ===========================================================================

loc_18582:
		move.w	#$500,ost_x_vel(a0)
		move.w	#-$40,ost_y_vel(a0)
		cmpi.w	#$1960,(v_limitright2).w
		bcc.s	loc_1859C
		addq.w	#2,(v_limitright2).w
		bra.s	loc_185A2
; ===========================================================================

loc_1859C:
		tst.b	ost_render(a0)
		bpl.s	Obj73_ShipDel

loc_185A2:
		bsr.w	BossMove
		bra.w	loc_1833E
; ===========================================================================

Obj73_ShipDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj73_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#id_ani_boss_face1,d1
		movea.l	ost_bmz_parent(a0),a1
		move.b	ost_routine2(a1),d0
		subq.w	#2,d0
		bne.s	loc_185D2
		btst	#1,ost_subtype(a1)
		beq.s	loc_185DA
		tst.w	ost_y_vel(a1)
		bne.s	loc_185DA
		moveq	#id_ani_boss_laugh,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185D2:
		subq.b	#2,d0
		bmi.s	loc_185DA
		moveq	#id_ani_boss_defeat,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185DA:
		tst.b	ost_col_type(a1)
		bne.s	loc_185E4
		moveq	#id_ani_boss_hit,d1
		bra.s	loc_185EE
; ===========================================================================

loc_185E4:
		cmpi.b	#id_Sonic_Hurt,(v_ost_player+ost_routine).w
		bcs.s	loc_185EE
		moveq	#id_ani_boss_laugh,d1

loc_185EE:
		move.b	d1,ost_anim(a0)
		subq.b	#4,d0
		bne.s	loc_18602
		move.b	#id_ani_boss_panic,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	Obj73_FaceDel

loc_18602:
		bra.s	Obj73_Display
; ===========================================================================

Obj73_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj73_FlameMain:; Routine 6
		move.b	#id_ani_boss_blank,ost_anim(a0)
		movea.l	ost_bmz_parent(a0),a1
		cmpi.b	#8,ost_routine2(a1)
		blt.s	loc_1862A
		move.b	#id_ani_boss_bigflame,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	Obj73_FlameDel
		bra.s	loc_18636
; ===========================================================================

loc_1862A:
		tst.w	ost_x_vel(a1)
		beq.s	loc_18636
		move.b	#8,ost_anim(a0)

loc_18636:
		bra.s	Obj73_Display
; ===========================================================================

Obj73_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

Obj73_Display:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l

loc_1864A:
		movea.l	ost_bmz_parent(a0),a1
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d0,ost_render(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

Obj73_TubeMain:	; Routine 8
		movea.l	ost_bmz_parent(a0),a1
		cmpi.b	#8,ost_routine2(a1)
		bne.s	loc_18688
		tst.b	ost_render(a0)
		bpl.s	Obj73_TubeDel

loc_18688:
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#tile_Nem_Weapons+tile_pal2,ost_tile(a0)
		move.b	#id_frame_boss_pipe,ost_frame(a0)
		bra.s	loc_1864A
; ===========================================================================

Obj73_TubeDel:
		jmp	(DeleteObject).l
