; ---------------------------------------------------------------------------
; Object 33 - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------

PushBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	PushB_Index(pc,d0.w),d1
		jmp	PushB_Index(pc,d1.w)
; ===========================================================================
PushB_Index:	index *,,2
		ptr PushB_Main
		ptr PushB_Action
		ptr PushB_ChkVisible

PushB_Var:
PushB_Var_0:	dc.b $10, id_frame_pblock_single	; object width,	frame number
PushB_Var_1:	dc.b $40, id_frame_pblock_four

sizeof_PushB_Var:	equ PushB_Var_1-PushB_Var

ost_pblock_lava_speed:	equ $30	; x axis speed when block is on lava (2 bytes)
ost_pblock_lava_flag:	equ $32	; 1 = block is on lava
ost_pblock_x_start:	equ $34	; original x position (2 bytes)
ost_pblock_y_start:	equ $36	; original y position (2 bytes)
; ===========================================================================

PushB_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$F,ost_height(a0)
		move.b	#$F,ost_width(a0)
		move.l	#Map_Push,ost_mappings(a0)
		move.w	#tile_Nem_MzBlock+tile_pal3,ost_tile(a0) ; MZ specific code
		cmpi.b	#1,(v_zone).w
		bne.s	@notLZ
		move.w	#$3DE+tile_pal3,ost_tile(a0) ; LZ specific code

	@notLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_pblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_pblock_y_start(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype
		add.w	d0,d0
		andi.w	#$E,d0		; read low nybble
		lea	PushB_Var(pc,d0.w),a2 ; get width & frame values from array
		move.b	(a2)+,ost_actwidth(a0)
		move.b	(a2)+,ost_frame(a0)
		tst.b	ost_subtype(a0)	; is subtype 0?
		beq.s	@chkgone	; if yes, branch
		move.w	#tile_Nem_MzBlock+tile_pal3+tile_hi,ost_tile(a0) ; make sprite appear in foreground

	@chkgone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	PushB_Action
		bclr	#7,2(a2,d0.w)
		bset	#0,2(a2,d0.w)
		bne.w	DeleteObject

PushB_Action:	; Routine 2
		tst.b	ost_pblock_lava_flag(a0) ; is block on lava?
		bne.w	PushB_OnLava	; if yes, branch
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	PushB_Solid
		cmpi.w	#(id_MZ<<8)+0,(v_zone).w ; is the level MZ act 1?
		bne.s	PushB_Display	; if not, branch
		bclr	#7,ost_subtype(a0)
		move.w	ost_x_pos(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	PushB_Display
		cmpi.w	#$AA1,d0	; is block between $A20 and $AA1 on x axis?
		bcc.s	PushB_Display	; if not, branch
		
		move.w	(v_cstomp_y_pos).w,d0
		subi.w	#$1C,d0
		move.w	d0,ost_y_pos(a0)
		bset	#7,(v_cstomp_y_pos).w
		bset	#7,ost_subtype(a0)

	PushB_Display:
		out_of_range.s	PushB_ChkDel
		bra.w	DisplaySprite
; ===========================================================================

PushB_ChkDel:
		out_of_range.s	PushB_ChkDel2,ost_pblock_x_start(a0)
		move.w	ost_pblock_x_start(a0),ost_x_pos(a0)
		move.w	ost_pblock_y_start(a0),ost_y_pos(a0)
		move.b	#id_PushB_ChkVisible,ost_routine(a0)
		bra.s	PushB_ChkVisible
; ===========================================================================

PushB_ChkDel2:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@del
		bclr	#0,2(a2,d0.w)

	@del:
		bra.w	DeleteObject
; ===========================================================================

PushB_ChkVisible:	; Routine 4
		bsr.w	CheckOffScreen_Wide ; is block still on screen?
		beq.s	@visible	; if yes, branch
		move.b	#id_PushB_Action,ost_routine(a0)
		clr.b	ost_pblock_lava_flag(a0)
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)

	@visible:
		rts	
; ===========================================================================

PushB_OnLava:
		move.w	ost_x_pos(a0),-(sp)
		cmpi.b	#4,ost_routine2(a0)
		bcc.s	loc_C056
		bsr.w	SpeedToPos

loc_C056:
		btst	#status_air_bit,ost_status(a0) ; has block been thrown into the air?
		beq.s	PushB_OnLava2	; if not, branch
		addi.w	#$18,ost_y_vel(a0)
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.w	loc_C09E
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop block falling when it reaches the ground
		bclr	#status_air_bit,ost_status(a0)
		move.w	(a1),d0		; get 16x16 tile the block is on
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0	; is it block $16A+ (lava)?
		bcs.s	loc_C09E	; if not, branch
		move.w	ost_pblock_lava_speed(a0),d0
		asr.w	#3,d0
		move.w	d0,ost_x_vel(a0) ; make block float horizontally
		move.b	#1,ost_pblock_lava_flag(a0)
		clr.w	ost_y_sub(a0)

loc_C09E:
		bra.s	loc_C0E6
; ===========================================================================

PushB_OnLava2:
		tst.w	ost_x_vel(a0)
		beq.w	loc_C0D6
		bmi.s	@wall_left
	
	@wall_right:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		jsr	(FindWallRightObj).l
		tst.w	d1		; has block touched a wall?
		bmi.s	PushB_Stop	; if yes, branch
		bra.s	loc_C0E6
; ===========================================================================

	@wall_left:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		not.w	d3
		jsr	(FindWallLeftObj).l
		tst.w	d1		; has block touched a wall?
		bmi.s	PushB_Stop	; if yes, branch
		bra.s	loc_C0E6
; ===========================================================================

PushB_Stop:
		clr.w	ost_x_vel(a0)	; stop block moving
		bra.s	loc_C0E6
; ===========================================================================

loc_C0D6:
		addi.l	#$2001,ost_y_pos(a0)
		cmpi.b	#$A0,ost_y_sub+1(a0)
		bcc.s	loc_C104

loc_C0E6:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	PushB_Solid
		bsr.s	PushB_ChkLava
		bra.w	PushB_Display
; ===========================================================================

loc_C104:
		move.w	(sp)+,d4
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		bra.w	PushB_ChkDel
; ===========================================================================

PushB_ChkLava:
		cmpi.w	#(id_MZ<<8)+1,(v_zone).w ; is the level MZ act 2?
		bne.s	PushB_ChkLava2	; if not, branch
		move.w	#-$20,d2
		cmpi.w	#$DD0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$CC0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$BA0,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		rts	
; ===========================================================================

PushB_ChkLava2:
		cmpi.w	#(id_MZ<<8)+2,(v_zone).w ; is the level MZ act 3?
		bne.s	PushB_NoLava	; if not, branch
		move.w	#$20,d2
		cmpi.w	#$560,ost_x_pos(a0)
		beq.s	PushB_LoadLava
		cmpi.w	#$5C0,ost_x_pos(a0)
		beq.s	PushB_LoadLava

PushB_NoLava:
		rts	
; ===========================================================================

PushB_LoadLava:
		bsr.w	FindFreeObj
		bne.s	locret_C184
		move.b	#id_GeyserMaker,0(a1) ; load lava geyser object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		add.w	d2,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		addi.w	#$10,ost_y_pos(a1)
		move.l	a0,ost_gmake_parent(a1)

locret_C184:
		rts	
; ===========================================================================

PushB_Solid:
		move.b	ost_routine2(a0),d0
		beq.w	loc_C218
		subq.b	#2,d0
		bne.s	loc_C1AA
		bsr.w	ExitPlatform
		btst	#status_platform_bit,ost_status(a1)
		bne.s	loc_C1A4
		clr.b	ost_routine2(a0)
		rts	
; ===========================================================================

loc_C1A4:
		move.w	d4,d2
		bra.w	MoveWithPlatform
; ===========================================================================

loc_C1AA:
		subq.b	#2,d0
		bne.s	loc_C1F2
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.w	locret_C1F0
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)
		clr.b	ost_routine2(a0)
		move.w	(a1),d0		; get 16x16 tile the block is on
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0	; is it block $16A+ (lava)?
		bcs.s	locret_C1F0	; if not, branch
		move.w	ost_pblock_lava_speed(a0),d0
		asr.w	#3,d0
		move.w	d0,ost_x_vel(a0) ; make block float horizontally
		move.b	#1,ost_pblock_lava_flag(a0)
		clr.w	ost_y_sub(a0)

locret_C1F0:
		rts	
; ===========================================================================

loc_C1F2:
		bsr.w	SpeedToPos
		move.w	ost_x_pos(a0),d0
		andi.w	#$C,d0
		bne.w	locret_C2E4
		andi.w	#-$10,ost_x_pos(a0)
		move.w	ost_x_vel(a0),ost_pblock_lava_speed(a0)
		clr.w	ost_x_vel(a0)
		subq.b	#2,ost_routine2(a0)
		rts	
; ===========================================================================

loc_C218:
		bsr.w	Solid_ChkEnter
		tst.w	d4
		beq.w	locret_C2E4
		bmi.w	locret_C2E4
		tst.b	ost_pblock_lava_flag(a0)
		beq.s	loc_C230
		bra.w	locret_C2E4
; ===========================================================================

loc_C230:
		tst.w	d0
		beq.w	locret_C2E4
		bmi.s	loc_C268
		btst	#status_xflip_bit,ost_status(a1)
		bne.w	locret_C2E4
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		jsr	(FindWallRightObj).l
		move.w	(sp)+,d0
		tst.w	d1
		bmi.w	locret_C2E4
		addi.l	#$10000,ost_x_pos(a0)
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	loc_C294
; ===========================================================================

loc_C268:
		btst	#status_xflip_bit,ost_status(a1)
		beq.s	locret_C2E4
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		not.w	d3
		jsr	(FindWallLeftObj).l
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	locret_C2E4
		subi.l	#$10000,ost_x_pos(a0)
		moveq	#-1,d0
		move.w	#-$40,d1

loc_C294:
		lea	(v_ost_player).w,a1
		add.w	d0,ost_x_pos(a1)
		move.w	d1,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)
		move.w	d0,-(sp)
		play.w	1, jsr, sfx_Push		; play pushing sound
		move.w	(sp)+,d0
		tst.b	ost_subtype(a0)	; is bit 7 of subtype set?
		bmi.s	locret_C2E4	; if yes, branch
		move.w	d0,-(sp)
		jsr	(FindFloorObj).l
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	loc_C2E0
		move.w	#$400,ost_x_vel(a0)
		tst.w	d0
		bpl.s	loc_C2D8
		neg.w	ost_x_vel(a0)

loc_C2D8:
		move.b	#6,ost_routine2(a0)
		bra.s	locret_C2E4
; ===========================================================================

loc_C2E0:
		add.w	d1,ost_y_pos(a0)

locret_C2E4:
		rts	
