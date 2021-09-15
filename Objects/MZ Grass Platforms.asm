; ---------------------------------------------------------------------------
; Object 2F - large grass-covered platforms (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LGrass_Index(pc,d0.w),d1
		jmp	LGrass_Index(pc,d1.w)
; ===========================================================================
LGrass_Index:	index *,,2
		ptr LGrass_Main
		ptr LGrass_Action

LGrass_Data:	index *
		ptr LGrass_Data1	 	; collision angle data
		dc.b 0,	$40			; frame	number,	platform width
		ptr LGrass_Data3
		dc.b 1,	$40
		ptr LGrass_Data2
		dc.b 2,	$20

ost_grass_x_start:	equ $2A	; original x position (2 bytes)
ost_grass_y_start:	equ $2C	; original y position (2 bytes)
ost_grass_coll_ptr:	equ $30	; pointer to collision data (4 bytes)
ost_grass_sink:		equ $34	; pixels the platform has sunk when stood on
ost_grass_burn_flag:	equ $35	; 0 = not burning; 1 = burning
ost_grass_children:	equ $36	; OST indices of child objects (8 bytes)
; ===========================================================================

LGrass_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_LGrass,ost_mappings(a0)
		move.w	#tile_pal3+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#5,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_grass_y_start(a0)
		move.w	ost_x_pos(a0),ost_grass_x_start(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	LGrass_Data(pc,d0.w),a1
		move.w	(a1)+,d0
		lea	LGrass_Data(pc,d0.w),a2
		move.l	a2,ost_grass_coll_ptr(a0)
		move.b	(a1)+,ost_frame(a0)
		move.b	(a1),ost_actwidth(a0)
		andi.b	#$F,ost_subtype(a0)
		move.b	#$40,ost_height(a0)
		bset	#render_useheight_bit,ost_render(a0)

LGrass_Action:	; Routine 2
		bsr.w	LGrass_Types
		tst.b	ost_routine2(a0)
		beq.s	LGrass_Solid
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform
		btst	#status_platform_bit,ost_status(a1)
		bne.w	LGrass_Slope
		clr.b	ost_routine2(a0)
		bra.s	LGrass_Display
; ===========================================================================

LGrass_Slope:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		movea.l	ost_grass_coll_ptr(a0),a2
		move.w	ost_x_pos(a0),d2
		bsr.w	SlopeObject_NoChk
		bra.s	LGrass_Display
; ===========================================================================

LGrass_Solid:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		move.w	#$20,d2
		cmpi.b	#2,ost_frame(a0)
		bne.s	loc_AF8E
		move.w	#$30,d2

loc_AF8E:
		movea.l	ost_grass_coll_ptr(a0),a2
		bsr.w	SolidObject2F

LGrass_Display:
		bsr.w	DisplaySprite
		bra.w	LGrass_ChkDel

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LGrass_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	LGrass_TypeIndex(pc,d0.w),d1
		jmp	LGrass_TypeIndex(pc,d1.w)
; End of function LGrass_Types

; ===========================================================================
LGrass_TypeIndex:index *
		ptr LGrass_Type00
		ptr LGrass_Type01
		ptr LGrass_Type02
		ptr LGrass_Type03
		ptr LGrass_Type04
		ptr LGrass_Type05
; ===========================================================================

LGrass_Type00:
		rts			; type 00 platform doesn't move
; ===========================================================================

LGrass_Type01:
		move.b	(v_oscillate+2).w,d0
		move.w	#$20,d1
		bra.s	LGrass_Move
; ===========================================================================

LGrass_Type02:
		move.b	(v_oscillate+6).w,d0
		move.w	#$30,d1
		bra.s	LGrass_Move
; ===========================================================================

LGrass_Type03:
		move.b	(v_oscillate+$A).w,d0
		move.w	#$40,d1
		bra.s	LGrass_Move
; ===========================================================================

LGrass_Type04:
		move.b	(v_oscillate+$E).w,d0
		move.w	#$60,d1

LGrass_Move:
		btst	#3,ost_subtype(a0)
		beq.s	loc_AFF2
		neg.w	d0
		add.w	d1,d0

loc_AFF2:
		move.w	ost_grass_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0) ; update position on y-axis
		rts	
; ===========================================================================

LGrass_Type05:
		move.b	ost_grass_sink(a0),d0
		tst.b	ost_routine2(a0)
		bne.s	loc_B010
		subq.b	#2,d0
		bcc.s	loc_B01C
		moveq	#0,d0
		bra.s	loc_B01C
; ===========================================================================

loc_B010:
		addq.b	#4,d0
		cmpi.b	#$40,d0
		bcs.s	loc_B01C
		move.b	#$40,d0

loc_B01C:
		move.b	d0,ost_grass_sink(a0)
		jsr	(CalcSine).l
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	ost_grass_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		cmpi.b	#$20,ost_grass_sink(a0)
		bne.s	loc_B07A
		tst.b	ost_grass_burn_flag(a0)
		bne.s	loc_B07A
		move.b	#1,ost_grass_burn_flag(a0)
		bsr.w	FindNextFreeObj
		bne.s	loc_B07A
		move.b	#id_GrassFire,0(a1) ; load sitting flame object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_grass_y_start(a0),ost_grass_y_start(a1)
		addq.w	#8,ost_grass_y_start(a1)
		subq.w	#3,ost_grass_y_start(a1)
		subi.w	#$40,ost_x_pos(a1)
		move.l	ost_grass_coll_ptr(a0),ost_burn_coll_ptr(a1)
		move.l	a0,ost_burn_parent(a1)
		movea.l	a0,a2
		bsr.s	sub_B09C

loc_B07A:
		moveq	#0,d2
		lea	ost_grass_children(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	locret_B09A

loc_B086:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.w	#v_ost_all&$FFFF,d0
		movea.w	d0,a1
		move.w	d1,ost_burn_sink(a1)
		dbf	d2,loc_B086

locret_B09A:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_B09C:
		lea	ost_grass_children(a2),a2 ; load list of child objects
		moveq	#0,d0
		move.b	(a2),d0
		addq.b	#1,(a2)
		lea	1(a2,d0.w),a2	; go to end of list
		move.w	a1,d0
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0		; d0 = OST index of child
		move.b	d0,(a2)		; copy d0 to end of list
		rts	
; End of function sub_B09C

; ===========================================================================

LGrass_ChkDel:
		tst.b	ost_grass_burn_flag(a0)
		beq.s	loc_B0C6
		tst.b	ost_render(a0)
		bpl.s	LGrass_DelFlames

loc_B0C6:
		out_of_range	DeleteObject,ost_grass_x_start(a0)
		rts	
; ===========================================================================

LGrass_DelFlames:
		moveq	#0,d2

loc_B0E8:
		lea	ost_grass_children(a0),a2
		move.b	(a2),d2
		clr.b	(a2)+
		subq.b	#1,d2
		bcs.s	locret_B116

loc_B0F4:
		moveq	#0,d0
		move.b	(a2),d0
		clr.b	(a2)+
		lsl.w	#6,d0
		addi.w	#v_ost_all&$FFFF,d0
		movea.w	d0,a1
		bsr.w	DeleteChild
		dbf	d2,loc_B0F4
		move.b	#0,ost_grass_burn_flag(a0)
		move.b	#0,ost_grass_sink(a0)

locret_B116:
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for large moving platforms (MZ)
; ---------------------------------------------------------------------------
LGrass_Data1:	incbin	"misc\mz_pfm1.bin"
		even
LGrass_Data2:	incbin	"misc\mz_pfm2.bin"
		even
LGrass_Data3:	incbin	"misc\mz_pfm3.bin"
		even
