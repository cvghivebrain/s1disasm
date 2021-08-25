; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BGHZ_Index(pc,d0.w),d1
		jmp	BGHZ_Index(pc,d1.w)
; ===========================================================================
BGHZ_Index:	index *,,2
		ptr BGHZ_Main
		ptr BGHZ_ShipMain
		ptr BGHZ_FaceMain
		ptr BGHZ_FlameMain

BGHZ_ObjData:	dc.b id_BGHZ_ShipMain,	0	; routine number, animation
		dc.b id_BGHZ_FaceMain,	1
		dc.b id_BGHZ_FlameMain,	7

ost_bghz_parent_x_pos:	equ $30	; parent x position (2 bytes)
ost_bghz_parent:	equ $34	; address of OST of parent object (4 bytes)
ost_bghz_parent_y_pos:	equ $38	; parent y position (2 bytes)
ost_bghz_wait_time:	equ $3C	; time to wait between each action (2 bytes)
ost_bghz_flash_num:	equ $3E	; number of times to make boss flash when hit
ost_bghz_wobble:	equ $3F	; wobble state as Eggman moves back & forth (1 byte incremented every frame & interpreted by CalcSine)
; ===========================================================================

BGHZ_Main:	; Routine 0
		lea	(BGHZ_ObjData).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	BGHZ_LoadBoss
; ===========================================================================

BGHZ_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_17772

BGHZ_LoadBoss:
		move.b	(a2)+,ost_routine(a1)
		move.b	#id_BossGreenHill,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.l	#Map_Eggman,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.b	#3,ost_priority(a1)
		move.b	(a2)+,ost_anim(a1)
		move.l	a0,ost_bghz_parent(a1)
		dbf	d1,BGHZ_Loop	; repeat sequence 2 more times

loc_17772:
		move.w	ost_x_pos(a0),ost_bghz_parent_x_pos(a0)
		move.w	ost_y_pos(a0),ost_bghz_parent_y_pos(a0)
		move.b	#$F,ost_col_type(a0)
		move.b	#8,ost_col_property(a0) ; set number of hits to 8

BGHZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	BGHZ_ShipIndex(pc,d0.w),d1
		jsr	BGHZ_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	ost_status(a0),d0
		andi.b	#status_xflip+status_yflip,d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0) ; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================
BGHZ_ShipIndex:	index *
		ptr BGHZ_ShipStart
		ptr BGHZ_MakeBall
		ptr BGHZ_ShipMove
		ptr loc_17954
		ptr loc_1797A
		ptr loc_179AC
		ptr loc_179F6
; ===========================================================================

BGHZ_ShipStart:
		move.w	#$100,ost_y_vel(a0) ; move ship down
		bsr.w	BossMove
		cmpi.w	#$338,ost_bghz_parent_y_pos(a0)
		bne.s	loc_177E6
		move.w	#0,ost_y_vel(a0) ; stop ship
		addq.b	#2,ost_routine2(a0) ; goto next routine

loc_177E6:
		move.b	ost_bghz_wobble(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	ost_bghz_parent_y_pos(a0),d0
		move.w	d0,ost_y_pos(a0)
		move.w	ost_bghz_parent_x_pos(a0),ost_x_pos(a0)
		addq.b	#2,ost_bghz_wobble(a0)
		cmpi.b	#8,ost_routine2(a0)
		bcc.s	locret_1784A
		tst.b	ost_status(a0)
		bmi.s	loc_1784C
		tst.b	ost_col_type(a0)
		bne.s	locret_1784A
		tst.b	ost_bghz_flash_num(a0)
		bne.s	BGHZ_ShipFlash
		move.b	#$20,ost_bghz_flash_num(a0) ; set number of times for ship to flash
		sfx	sfx_HitBoss,0,0,0 ; play boss damage sound

BGHZ_ShipFlash:
		lea	(v_pal_dry+$22).w,a1 ; load 2nd palette, 2nd entry
		moveq	#0,d0		; move 0 (black) to d0
		tst.w	(a1)
		bne.s	loc_1783C
		move.w	#cWhite,d0	; move 0EEE (white) to d0

loc_1783C:
		move.w	d0,(a1)		; load colour stored in	d0
		subq.b	#1,ost_bghz_flash_num(a0)
		bne.s	locret_1784A
		move.b	#$F,ost_col_type(a0)

locret_1784A:
		rts	
; ===========================================================================

loc_1784C:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#8,ost_routine2(a0)
		move.w	#$B3,ost_bghz_wait_time(a0)
		rts	

; ---------------------------------------------------------------------------
; Defeated boss	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossDefeated:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_178A2
		jsr	(FindFreeObj).l
		bne.s	locret_178A2
		move.b	#id_ExplosionBomb,0(a1)	; load explosion object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,ost_x_pos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,ost_y_pos(a1)

locret_178A2:
		rts	
; End of function BossDefeated

; ---------------------------------------------------------------------------
; Subroutine to	move a boss
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossMove:
		move.l	ost_bghz_parent_x_pos(a0),d2
		move.l	ost_bghz_parent_y_pos(a0),d3
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	ost_y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,ost_bghz_parent_x_pos(a0)
		move.l	d3,ost_bghz_parent_y_pos(a0)
		rts	
; End of function BossMove

; ===========================================================================


BGHZ_MakeBall:
		move.w	#-$100,ost_x_vel(a0)
		move.w	#-$40,ost_y_vel(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a0)
		bne.s	loc_17916
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine2(a0)
		jsr	(FindNextFreeObj).l
		bne.s	loc_17910
		move.b	#id_BossBall,0(a1) ; load swinging ball object
		move.w	ost_bghz_parent_x_pos(a0),ost_x_pos(a1)
		move.w	ost_bghz_parent_y_pos(a0),ost_y_pos(a1)
		move.l	a0,ost_ball_parent(a1)

loc_17910:
		move.w	#$77,ost_bghz_wait_time(a0)

loc_17916:
		bra.w	loc_177E6
; ===========================================================================

BGHZ_ShipMove:
		subq.w	#1,ost_bghz_wait_time(a0)
		bpl.s	BGHZ_Reverse
		addq.b	#2,ost_routine2(a0)
		move.w	#$3F,ost_bghz_wait_time(a0)
		move.w	#$100,ost_x_vel(a0) ; move the ship sideways
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a0)
		bne.s	BGHZ_Reverse
		move.w	#$7F,ost_bghz_wait_time(a0)
		move.w	#$40,ost_x_vel(a0)

BGHZ_Reverse:
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	loc_17950
		neg.w	ost_x_vel(a0)	; reverse direction of the ship

loc_17950:
		bra.w	loc_177E6
; ===========================================================================

loc_17954:
		subq.w	#1,ost_bghz_wait_time(a0)
		bmi.s	loc_17960
		bsr.w	BossMove
		bra.s	loc_17976
; ===========================================================================

loc_17960:
		bchg	#status_xflip_bit,ost_status(a0)
		move.w	#$3F,ost_bghz_wait_time(a0)
		subq.b	#2,ost_routine2(a0)
		move.w	#0,ost_x_vel(a0)

loc_17976:
		bra.w	loc_177E6
; ===========================================================================

loc_1797A:
		subq.w	#1,ost_bghz_wait_time(a0)
		bmi.s	loc_17984
		bra.w	BossDefeated
; ===========================================================================

loc_17984:
		bset	#status_xflip_bit,ost_status(a0)
		bclr	#status_onscreen_bit,ost_status(a0)
		clr.w	ost_x_vel(a0)
		addq.b	#2,ost_routine2(a0)
		move.w	#-$26,ost_bghz_wait_time(a0)
		tst.b	(v_bossstatus).w
		bne.s	locret_179AA
		move.b	#1,(v_bossstatus).w

locret_179AA:
		rts	
; ===========================================================================

loc_179AC:
		addq.w	#1,ost_bghz_wait_time(a0)
		beq.s	loc_179BC
		bpl.s	loc_179C2
		addi.w	#$18,ost_y_vel(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179BC:
		clr.w	ost_y_vel(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179C2:
		cmpi.w	#$30,ost_bghz_wait_time(a0)
		bcs.s	loc_179DA
		beq.s	loc_179E0
		cmpi.w	#$38,ost_bghz_wait_time(a0)
		bcs.s	loc_179EE
		addq.b	#2,ost_routine2(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179DA:
		subq.w	#8,ost_y_vel(a0)
		bra.s	loc_179EE
; ===========================================================================

loc_179E0:
		clr.w	ost_y_vel(a0)
		music	bgm_GHZ,0,0,0 ; play GHZ music

loc_179EE:
		bsr.w	BossMove
		bra.w	loc_177E6
; ===========================================================================

loc_179F6:
		move.w	#$400,ost_x_vel(a0)
		move.w	#-$40,ost_y_vel(a0)
		cmpi.w	#$2AC0,(v_limitright2).w
		beq.s	loc_17A10
		addq.w	#2,(v_limitright2).w
		bra.s	loc_17A16
; ===========================================================================

loc_17A10:
		tst.b	ost_render(a0)
		bpl.s	BGHZ_ShipDel

loc_17A16:
		bsr.w	BossMove
		bra.w	loc_177E6
; ===========================================================================

BGHZ_ShipDel:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#1,d1
		movea.l	ost_bghz_parent(a0),a1
		move.b	ost_routine2(a1),d0
		subq.b	#4,d0
		bne.s	loc_17A3E
		cmpi.w	#$2A00,ost_bghz_parent_x_pos(a1)
		bne.s	loc_17A46
		moveq	#4,d1

loc_17A3E:
		subq.b	#6,d0
		bmi.s	loc_17A46
		moveq	#$A,d1
		bra.s	loc_17A5A
; ===========================================================================

loc_17A46:
		tst.b	ost_col_type(a1)
		bne.s	loc_17A50
		moveq	#5,d1
		bra.s	loc_17A5A
; ===========================================================================

loc_17A50:
		cmpi.b	#4,(v_player+ost_routine).w
		bcs.s	loc_17A5A
		moveq	#4,d1

loc_17A5A:
		move.b	d1,ost_anim(a0)
		subq.b	#2,d0
		bne.s	BGHZ_FaceDisp
		move.b	#6,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	BGHZ_FaceDel

BGHZ_FaceDisp:
		bra.s	BGHZ_Display
; ===========================================================================

BGHZ_FaceDel:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_FlameMain:	; Routine 6
		move.b	#7,ost_anim(a0)
		movea.l	ost_bghz_parent(a0),a1
		cmpi.b	#$C,ost_routine2(a1)
		bne.s	loc_17A96
		move.b	#$B,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.s	BGHZ_FlameDel
		bra.s	BGHZ_FlameDisp
; ===========================================================================

loc_17A96:
		move.w	ost_x_vel(a1),d0
		beq.s	BGHZ_FlameDisp
		move.b	#8,ost_anim(a0)

BGHZ_FlameDisp:
		bra.s	BGHZ_Display
; ===========================================================================

BGHZ_FlameDel:
		jmp	(DeleteObject).l
; ===========================================================================

BGHZ_Display:
		movea.l	ost_bghz_parent(a0),a1
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	ost_status(a0),d0
		andi.b	#status_xflip+status_yflip,d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d0,ost_render(a0)
		jmp	(DisplaySprite).l
