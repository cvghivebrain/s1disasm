; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ, LZ, SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jmp	MBlock_Index(pc,d1.w)
; ===========================================================================
MBlock_Index:	index *,,2
		ptr MBlock_Main
		ptr MBlock_Platform
		ptr MBlock_StandOn

MBlock_Var:	dc.b $10, 0		; object width,	frame number
		dc.b $20, 1
		dc.b $20, 2
		dc.b $40, 3
		dc.b $30, 4

ost_mblock_x_start:	equ $30	; original x position (2 bytes)
ost_mblock_y_start:	equ $32	; original y position (2 bytes)
ost_mblock_wait_time:	equ $34	; time delay before moving platform back - subtype x9/xA only (2 bytes)
ost_mblock_move_flag:	equ $36	; 1 = move platform back to its original position - subtype x9/xA only
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_MBlock,ost_mappings(a0)
		move.w	#tile_Nem_MzBlock+tile_pal3,ost_tile(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	loc_FE44
		move.l	#Map_MBlockLZ,ost_mappings(a0) ; LZ specific code
		move.w	#tile_Nem_LzBlock3+tile_pal3,ost_tile(a0)
		move.b	#7,ost_height(a0)

loc_FE44:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	loc_FE60
		move.w	#tile_Nem_Stomper+tile_pal2,ost_tile(a0) ; SBZ specific code (object 5228)
		cmpi.b	#$28,ost_subtype(a0) ; is object 5228 ?
		beq.s	loc_FE60	; if yes, branch
		move.w	#tile_Nem_SlideFloor+tile_pal3,ost_tile(a0) ; SBZ specific code (object 523x)

loc_FE60:
		move.b	#render_rel,ost_render(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	MBlock_Var(pc,d0.w),a2
		move.b	(a2)+,ost_actwidth(a0)
		move.b	(a2)+,ost_frame(a0)
		move.b	#4,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_mblock_y_start(a0)
		andi.b	#$F,ost_subtype(a0)

MBlock_Platform: ; Routine 2
		bsr.w	MBlock_Move
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(PlatformObject).l
		bra.s	MBlock_ChkDel
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	MBlock_Move
		move.w	(sp)+,d2
		jsr	(MvSonicOnPtfm2).l

MBlock_ChkDel:
		out_of_range	DeleteObject,ost_mblock_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================

MBlock_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	MBlock_TypeIndex(pc,d0.w),d1
		jmp	MBlock_TypeIndex(pc,d1.w)
; ===========================================================================
MBlock_TypeIndex:index *
		ptr MBlock_Type00
		ptr MBlock_Type01
		ptr MBlock_Type02
		ptr MBlock_Type03
		ptr MBlock_Type02
		ptr MBlock_Type05
		ptr MBlock_Type06
		ptr MBlock_Type07
		ptr MBlock_Type08
		ptr MBlock_Type02
		ptr MBlock_Type0A
; ===========================================================================

MBlock_Type00:
		rts	
; ===========================================================================

MBlock_Type01:
		move.b	(v_oscillate+$E).w,d0
		move.w	#$60,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_FF26
		neg.w	d0
		add.w	d1,d0

loc_FF26:
		move.w	ost_mblock_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

MBlock_Type02:
		cmpi.b	#id_MBlock_StandOn,ost_routine(a0) ; is Sonic standing on the platform?
		bne.s	MBlock_02_Wait
		addq.b	#1,ost_subtype(a0) ; if yes, add 1 to type

MBlock_02_Wait:
		rts	
; ===========================================================================

MBlock_Type03:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1		; has the platform hit a wall?
		bmi.s	MBlock_03_End	; if yes, branch
		addq.w	#1,ost_x_pos(a0) ; move platform to the right
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		rts	
; ===========================================================================

MBlock_03_End:
		clr.b	ost_subtype(a0)	; change to type 00 (non-moving	type)
		rts	
; ===========================================================================

MBlock_Type05:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		bsr.w	ObjHitWallRight
		tst.w	d1		; has the platform hit a wall?
		bmi.s	MBlock_05_End	; if yes, branch
		addq.w	#1,ost_x_pos(a0) ; move platform to the right
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		rts	
; ===========================================================================

MBlock_05_End:
		addq.b	#1,ost_subtype(a0) ; change to type 06 (falling)
		rts	
; ===========================================================================

MBlock_Type06:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0) ; make the platform fall
		bsr.w	ObjFloorDist
		tst.w	d1		; has platform hit the floor?
		bpl.w	locret_FFA0	; if not, branch
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop platform	falling
		clr.b	ost_subtype(a0)	; change to type 00 (non-moving)

locret_FFA0:
		rts	
; ===========================================================================

MBlock_Type07:
		tst.b	(f_switch+2).w	; has switch number 02 been pressed?
		beq.s	MBlock_07_ChkDel
		subq.b	#3,ost_subtype(a0) ; if yes, change object type to 04

MBlock_07_ChkDel:
		addq.l	#4,sp
		out_of_range	DeleteObject,ost_mblock_x_start(a0)
		rts	
; ===========================================================================

MBlock_Type08:
		move.b	(v_oscillate+$1E).w,d0
		move.w	#$80,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_FFE2
		neg.w	d0
		add.w	d1,d0

loc_FFE2:
		move.w	ost_mblock_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

MBlock_Type0A:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		add.w	d3,d3
		moveq	#8,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_10004
		neg.w	d1
		neg.w	d3

loc_10004:
		tst.w	ost_mblock_move_flag(a0) ; is platform set to move back?
		bne.s	MBlock_0A_Back	; if yes, branch
		move.w	ost_x_pos(a0),d0
		sub.w	ost_mblock_x_start(a0),d0
		cmp.w	d3,d0
		beq.s	MBlock_0A_Wait
		add.w	d1,ost_x_pos(a0) ; move platform
		move.w	#300,ost_mblock_wait_time(a0) ; set time delay to 5 seconds
		rts	
; ===========================================================================

MBlock_0A_Wait:
		subq.w	#1,ost_mblock_wait_time(a0) ; subtract 1 from time delay
		bne.s	locret_1002E	; if time remains, branch
		move.w	#1,ost_mblock_move_flag(a0) ; set platform to move back to its original position

locret_1002E:
		rts	
; ===========================================================================

MBlock_0A_Back:
		move.w	ost_x_pos(a0),d0
		sub.w	ost_mblock_x_start(a0),d0
		beq.s	MBlock_0A_Reset
		sub.w	d1,ost_x_pos(a0) ; return platform to its original position
		rts	
; ===========================================================================

MBlock_0A_Reset:
		clr.w	ost_mblock_move_flag(a0)
		subq.b	#1,ost_subtype(a0)
		rts	
