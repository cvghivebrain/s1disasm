; ---------------------------------------------------------------------------
; Object 85 - Eggman (FZ)
; ---------------------------------------------------------------------------

Obj85_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

BossFinal:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj85_Index(pc,d0.w),d0
		jmp	Obj85_Index(pc,d0.w)
; ===========================================================================
Obj85_Index:	index *,,2
		ptr Obj85_Main
		ptr Obj85_Eggman
		ptr Obj85_Panel
		ptr Obj85_Legs
		ptr loc_1A2C6
		ptr loc_1A3AC
		ptr loc_1A264

Obj85_ObjData:	dc.w $100, $100, tile_Nem_Sbz2Eggman_FZ		; x pos, y pos,	VRAM setting
		dc.l Map_SEgg					; mappings pointer
		dc.w $25B0, $590, tile_Nem_FzBoss
		dc.l Map_EggCyl
		dc.w $26E0, $596, tile_Nem_FzEggman
		dc.l Map_FZLegs
		dc.w $26E0, $596, tile_Nem_Sbz2Eggman_FZ
		dc.l Map_SEgg
		dc.w $26E0, $596, tile_Nem_Eggman
		dc.l Map_Eggman
		dc.w $26E0, $596, tile_Nem_Eggman
		dc.l Map_Eggman

Obj85_ObjData2:	dc.b 2,	0, 4, $20, $19				; routine num, animation, sprite priority, width, height
		dc.b 4,	0, 1, $12, 8
		dc.b 6,	0, 3, 0, 0
		dc.b 8,	0, 3, 0, 0
		dc.b $A, 0, 3, $20, $20
		dc.b $C, 0, 3, 0, 0

;			equ $30	; ?  (2 bytes)
;			equ $32	; ?  (2 bytes)
ost_fz_parent:		equ $34					; address of OST of parent object - children only (4 bytes)
ost_fz_mode:		equ $34					; action being performed, increments of 2 - parent only
ost_fz_flash_num:	equ $35					; number of times to make boss flash when hit - parent only
ost_fz_plasma_child:	equ $36					; address of OST of plasma object - parent only (2 bytes)
ost_fz_cylinder_child:	equ $38					; address of OST of cylinder object - parent only (2 bytes * 4)
; ===========================================================================

Obj85_Main:	; Routine 0
		lea	Obj85_ObjData(pc),a2
		lea	Obj85_ObjData2(pc),a3
		movea.l	a0,a1
		moveq	#5,d1
		bra.s	Obj85_LoadBoss
; ===========================================================================

Obj85_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_19E20

Obj85_LoadBoss:
		move.b	#id_BossFinal,(a1)
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,ost_tile(a1)
		move.l	(a2)+,ost_mappings(a1)
		move.b	(a3)+,ost_routine(a1)
		move.b	(a3)+,ost_anim(a1)
		move.b	(a3)+,ost_priority(a1)
		if Revision=0
			move.b	(a3)+,ost_width(a1)
		else
			move.b	(a3)+,ost_actwidth(a1)
		endc
		move.b	(a3)+,ost_height(a1)
		move.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a0)
		move.l	a0,ost_fz_parent(a1)
		dbf	d1,Obj85_Loop				; repeat 5 more times

loc_19E20:
		lea	ost_fz_plasma_child(a0),a2
		jsr	(FindFreeObj).l
		bne.s	loc_19E5A
		move.b	#id_BossPlasma,(a1)			; load energy ball object
		move.w	a1,(a2)
		move.l	a0,ost_plasma_parent(a1)
		lea	ost_fz_cylinder_child(a0),a2
		moveq	#0,d2
		moveq	#3,d1

loc_19E3E:
		jsr	(FindNextFreeObj).l
		bne.s	loc_19E5A
		move.w	a1,(a2)+
		move.b	#id_EggmanCylinder,(a1)			; load crushing	cylinder object
		move.l	a0,ost_cylinder_parent(a1)
		move.b	d2,ost_subtype(a1)
		addq.w	#2,d2
		dbf	d1,loc_19E3E

loc_19E5A:
		move.w	#0,ost_fz_mode(a0)
		move.b	#8,ost_col_property(a0)			; set number of hits to 8
		move.w	#-1,$30(a0)

Obj85_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	ost_fz_mode(a0),d0
		move.w	off_19E80(pc,d0.w),d0
		jsr	off_19E80(pc,d0.w)
		jmp	(DisplaySprite).l
; ===========================================================================
off_19E80:	index *,,2
		ptr loc_19E90
		ptr loc_19EA8
		ptr loc_19FE6
		ptr loc_1A02A
		ptr loc_1A074
		ptr loc_1A112
		ptr loc_1A192
		ptr loc_1A1D4
; ===========================================================================

loc_19E90:
		tst.l	(v_plc_buffer).w
		bne.s	loc_19EA2
		cmpi.w	#$2450,(v_camera_x_pos).w
		bcs.s	loc_19EA2
		addq.b	#2,ost_fz_mode(a0)

loc_19EA2:
		addq.l	#1,(v_random).w
		rts	
; ===========================================================================

loc_19EA8:
		tst.w	$30(a0)
		bpl.s	loc_19F10
		clr.w	$30(a0)
		jsr	(RandomNumber).l
		andi.w	#$C,d0
		move.w	d0,d1
		addq.w	#2,d1
		tst.l	d0
		bpl.s	loc_19EC6
		exg	d1,d0

loc_19EC6:
		lea	word_19FD6(pc),a1
		move.w	(a1,d0.w),d0
		move.w	(a1,d1.w),d1
		move.w	d0,$30(a0)
		moveq	#-1,d2
		move.w	ost_fz_cylinder_child(a0,d0.w),d2
		movea.l	d2,a1
		move.b	#-1,ost_cylinder_flag(a1)
		move.w	#-1,$30(a1)
		move.w	ost_fz_cylinder_child(a0,d1.w),d2
		movea.l	d2,a1
		move.b	#1,ost_cylinder_flag(a1)
		move.w	#0,$30(a1)
		move.w	#1,$32(a0)
		clr.b	ost_fz_flash_num(a0)
		play.w	1, jsr, sfx_Rumbling			; play rumbling sound

loc_19F10:
		tst.w	$32(a0)
		bmi.w	loc_19FA6
		bclr	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	loc_19F2E
		bset	#status_xflip_bit,ost_status(a0)

loc_19F2E:
		move.w	#$2B,d1
		move.w	#$14,d2
		move.w	#$14,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		tst.w	d4
		bgt.s	loc_19F50

loc_19F48:
		tst.b	ost_fz_flash_num(a0)
		bne.s	loc_19F88
		bra.s	loc_19F96
; ===========================================================================

loc_19F50:
		addq.w	#7,(v_random).w
		cmpi.b	#id_Roll,(v_ost_player+ost_anim).w
		bne.s	loc_19F48
		move.w	#$300,d0
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	loc_19F6A
		neg.w	d0

loc_19F6A:
		move.w	d0,(v_ost_player+ost_x_vel).w
		tst.b	ost_fz_flash_num(a0)
		bne.s	loc_19F88
		subq.b	#1,ost_col_property(a0)
		move.b	#$64,ost_fz_flash_num(a0)
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

loc_19F88:
		subq.b	#1,ost_fz_flash_num(a0)
		beq.s	loc_19F96
		move.b	#3,ost_anim(a0)
		bra.s	loc_19F9C
; ===========================================================================

loc_19F96:
		move.b	#1,ost_anim(a0)

loc_19F9C:
		lea	Ani_SEgg(pc),a1
		jmp	(AnimateSprite).l
; ===========================================================================

loc_19FA6:
		tst.b	ost_col_property(a0)
		beq.s	loc_19FBC
		addq.b	#2,ost_fz_mode(a0)
		move.w	#-1,$30(a0)
		clr.w	$32(a0)
		rts	
; ===========================================================================

loc_19FBC:
		if Revision=0
		else
			moveq	#100,d0
			bsr.w	AddPoints
		endc
		move.b	#6,ost_fz_mode(a0)
		move.w	#$25C0,ost_x_pos(a0)
		move.w	#$53C,ost_y_pos(a0)
		move.b	#$14,ost_height(a0)
		rts	
; ===========================================================================
word_19FD6:	dc.w 0,	2, 2, 4, 4, 6, 6, 0
; ===========================================================================

loc_19FE6:
		moveq	#-1,d0
		move.w	ost_fz_plasma_child(a0),d0
		movea.l	d0,a1
		tst.w	$30(a0)
		bpl.s	loc_1A000
		clr.w	$30(a0)
		move.b	#-1,ost_plasma_flag(a1)
		bsr.s	loc_1A020

loc_1A000:
		moveq	#$F,d0
		and.w	(v_vblank_counter_word).w,d0
		bne.s	loc_1A00A
		bsr.s	loc_1A020

loc_1A00A:
		tst.w	$32(a0)
		beq.s	locret_1A01E
		subq.b	#2,ost_fz_mode(a0)
		move.w	#-1,$30(a0)
		clr.w	$32(a0)

locret_1A01E:
		rts	
; ===========================================================================

loc_1A020:
		play.w	1, jmp, sfx_Electricity			; play electricity sound
; ===========================================================================

loc_1A02A:
		if Revision=0
			move.b	#$30,ost_width(a0)
		else
			move.b	#$30,ost_actwidth(a0)
		endc
		bset	#status_xflip_bit,ost_status(a0)
		jsr	(SpeedToPos).l
		move.b	#6,ost_frame(a0)
		addi.w	#$10,ost_y_vel(a0)
		cmpi.w	#$59C,ost_y_pos(a0)
		bcs.s	loc_1A070
		move.w	#$59C,ost_y_pos(a0)
		addq.b	#2,ost_fz_mode(a0)
		if Revision=0
			move.b	#$20,ost_width(a0)
		else
			move.b	#$20,ost_actwidth(a0)
		endc
		move.w	#$100,ost_x_vel(a0)
		move.w	#-$100,ost_y_vel(a0)
		addq.b	#2,(v_dle_routine).w

loc_1A070:
		bra.w	loc_1A166
; ===========================================================================

loc_1A074:
		bset	#status_xflip_bit,ost_status(a0)
		move.b	#4,ost_anim(a0)
		jsr	(SpeedToPos).l
		addi.w	#$10,ost_y_vel(a0)
		cmpi.w	#$5A3,ost_y_pos(a0)
		bcs.s	loc_1A09A
		move.w	#-$40,ost_y_vel(a0)

loc_1A09A:
		move.w	#$400,ost_x_vel(a0)
		move.w	ost_x_pos(a0),d0
		sub.w	(v_ost_player+ost_x_pos).w,d0
		bpl.s	loc_1A0B4
		move.w	#$500,ost_x_vel(a0)
		bra.w	loc_1A0F2
; ===========================================================================

loc_1A0B4:
		subi.w	#$70,d0
		bcs.s	loc_1A0F2
		subi.w	#$100,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$100,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	loc_1A0F2
		subi.w	#$80,ost_x_vel(a0)
		subi.w	#$38,d0
		bcs.s	loc_1A0F2
		clr.w	ost_x_vel(a0)

loc_1A0F2:
		cmpi.w	#$26A0,ost_x_pos(a0)
		bcs.s	loc_1A110
		move.w	#$26A0,ost_x_pos(a0)
		move.w	#$240,ost_x_vel(a0)
		move.w	#-$4C0,ost_y_vel(a0)
		addq.b	#2,ost_fz_mode(a0)

loc_1A110:
		bra.s	loc_1A15C
; ===========================================================================

loc_1A112:
		jsr	(SpeedToPos).l
		cmpi.w	#$26E0,ost_x_pos(a0)
		bcs.s	loc_1A124
		clr.w	ost_x_vel(a0)

loc_1A124:
		addi.w	#$34,ost_y_vel(a0)
		tst.w	ost_y_vel(a0)
		bmi.s	loc_1A142
		cmpi.w	#$592,ost_y_pos(a0)
		bcs.s	loc_1A142
		move.w	#$592,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)

loc_1A142:
		move.w	ost_x_vel(a0),d0
		or.w	ost_y_vel(a0),d0
		bne.s	loc_1A15C
		addq.b	#2,ost_fz_mode(a0)
		move.w	#-$180,ost_y_vel(a0)
		move.b	#1,ost_col_property(a0)

loc_1A15C:
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l

loc_1A166:
		cmpi.w	#$2700,(v_boundary_right).w
		bge.s	loc_1A172
		addq.w	#2,(v_boundary_right).w

loc_1A172:
		cmpi.b	#$C,ost_fz_mode(a0)
		bge.s	locret_1A190
		move.w	#$1B,d1
		move.w	#$70,d2
		move.w	#$71,d3
		move.w	ost_x_pos(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

locret_1A190:
		rts	
; ===========================================================================

loc_1A192:
		move.l	#Map_Eggman,ost_mappings(a0)
		move.w	#tile_Nem_Eggman,ost_tile(a0)
		move.b	#0,ost_anim(a0)
		bset	#status_xflip_bit,ost_status(a0)
		jsr	(SpeedToPos).l
		cmpi.w	#$544,ost_y_pos(a0)
		bcc.s	loc_1A1D0
		move.w	#$180,ost_x_vel(a0)
		move.w	#-$18,ost_y_vel(a0)
		move.b	#id_col_24x24,ost_col_type(a0)
		addq.b	#2,ost_fz_mode(a0)

loc_1A1D0:
		bra.w	loc_1A15C
; ===========================================================================

loc_1A1D4:
		bset	#status_xflip_bit,ost_status(a0)
		jsr	(SpeedToPos).l
		tst.w	$30(a0)
		bne.s	loc_1A1FC
		tst.b	ost_col_type(a0)
		bne.s	loc_1A216
		move.w	#$1E,$30(a0)
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

loc_1A1FC:
		subq.w	#1,$30(a0)
		bne.s	loc_1A216
		tst.b	ost_status(a0)
		bpl.s	loc_1A210
		move.w	#$60,ost_y_vel(a0)
		bra.s	loc_1A216
; ===========================================================================

loc_1A210:
		move.b	#id_col_24x24,ost_col_type(a0)

loc_1A216:
		cmpi.w	#$2790,(v_ost_player+ost_x_pos).w
		blt.s	loc_1A23A
		move.b	#1,(f_lock_controls).w
		move.w	#0,(v_joypad_hold).w
		clr.w	(v_ost_player+ost_inertia).w
		tst.w	ost_y_vel(a0)
		bpl.s	loc_1A248
		move.w	#$100,(v_joypad_hold).w

loc_1A23A:
		cmpi.w	#$27E0,(v_ost_player+ost_x_pos).w
		blt.s	loc_1A248
		move.w	#$27E0,(v_ost_player+ost_x_pos).w

loc_1A248:
		cmpi.w	#$2900,ost_x_pos(a0)
		bcs.s	loc_1A260
		tst.b	ost_render(a0)
		bmi.s	loc_1A260
		move.b	#id_Ending,(v_gamemode).w
		bra.w	Obj85_Delete
; ===========================================================================

loc_1A260:
		bra.w	loc_1A15C
; ===========================================================================

loc_1A264:	; Routine $C
		movea.l	ost_fz_parent(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.w	Obj85_Delete
		move.b	#7,ost_anim(a0)
		cmpi.b	#$C,ost_fz_mode(a1)
		bge.s	loc_1A280
		bra.s	loc_1A2A6
; ===========================================================================

loc_1A280:
		tst.w	ost_x_vel(a1)
		beq.s	loc_1A28C
		move.b	#$B,ost_anim(a0)

loc_1A28C:
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l

loc_1A296:
		movea.l	ost_fz_parent(a0),a1
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)

loc_1A2A6:
		movea.l	ost_fz_parent(a0),a1
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A2C6:	; Routine 8
		movea.l	ost_fz_parent(a0),a1
		move.b	(a1),d0
		cmp.b	(a0),d0
		bne.w	Obj85_Delete
		cmpi.l	#Map_Eggman,ost_mappings(a1)
		beq.s	loc_1A2E4
		move.b	#$A,ost_frame(a0)
		bra.s	loc_1A2A6
; ===========================================================================

loc_1A2E4:
		move.b	#id_ani_boss_face1,ost_anim(a0)
		tst.b	ost_col_property(a1)
		ble.s	loc_1A312
		move.b	#id_ani_boss_panic,ost_anim(a0)
		move.l	#Map_Eggman,ost_mappings(a0)
		move.w	#tile_Nem_Eggman,ost_tile(a0)
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l
		bra.w	loc_1A296
; ===========================================================================

loc_1A312:
		tst.b	ost_render(a0)
		bpl.w	Obj85_Delete
		bsr.w	BossExplode
		move.b	#2,ost_priority(a0)
		move.b	#id_ani_fzeggman_0,ost_anim(a0)
		move.l	#Map_FZDamaged,ost_mappings(a0)
		move.w	#tile_Nem_FzEggman,ost_tile(a0)
		lea	Ani_FZEgg(pc),a1
		jsr	(AnimateSprite).l
		bra.w	loc_1A296
; ===========================================================================

Obj85_Legs:	; Routine 6
		bset	#status_xflip_bit,ost_status(a0)
		movea.l	ost_fz_parent(a0),a1
		cmpi.l	#Map_Eggman,ost_mappings(a1)
		beq.s	loc_1A35E
		bra.w	loc_1A2A6
; ===========================================================================

loc_1A35E:
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		tst.b	ost_anim_time(a0)
		bne.s	loc_1A376
		move.b	#$14,ost_anim_time(a0)

loc_1A376:
		subq.b	#1,ost_anim_time(a0)
		bgt.s	loc_1A38A
		addq.b	#1,ost_frame(a0)
		cmpi.b	#id_frame_fzlegs_retracted,ost_frame(a0)
		bgt.w	Obj85_Delete

loc_1A38A:
		bra.w	loc_1A296
; ===========================================================================

Obj85_Panel:	; Routine 4
		move.b	#id_frame_cylinder_controlpanel,ost_frame(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	loc_1A3A6
		tst.b	ost_render(a0)
		bpl.w	Obj85_Delete

loc_1A3A6:
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1A3AC:	; Routine $A
		move.b	#0,ost_frame(a0)
		bset	#status_xflip_bit,ost_status(a0)
		movea.l	ost_fz_parent(a0),a1
		cmpi.b	#$C,ost_fz_mode(a1)
		bne.s	loc_1A3D0
		cmpi.l	#Map_Eggman,ost_mappings(a1)
		beq.w	Obj85_Delete

loc_1A3D0:
		bra.w	loc_1A2A6
