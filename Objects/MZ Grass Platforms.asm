; ---------------------------------------------------------------------------
; Object 2F - large grass-covered platforms (MZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 1/$15/$20/$21/$22/$23/$29/$2A/$2B
; ---------------------------------------------------------------------------

LargeGrass:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LGrass_Index(pc,d0.w),d1
		jmp	LGrass_Index(pc,d1.w)
; ===========================================================================
LGrass_Index:	index *,,2
		ptr LGrass_Main
		ptr LGrass_Action

LGrass_Data:	index *
LGrass_Data_0:	ptr LGrass_Coll_Wide				; heightmap data
		dc.b id_frame_grass_wide, $40			; frame number,	platform width
LGrass_Data_1:	ptr LGrass_Coll_Sloped
		dc.b id_frame_grass_sloped, $40
LGrass_Data_2:	ptr LGrass_Coll_Narrow
		dc.b id_frame_grass_narrow, $20

ost_grass_x_start:	equ $2A					; original x position (2 bytes)
ost_grass_y_start:	equ $2C					; original y position (2 bytes)
ost_grass_coll_ptr:	equ $30					; pointer to collision data (4 bytes)
ost_grass_sink:		equ $34					; pixels the platform has sunk when stood on
ost_grass_burn_flag:	equ $35					; 0 = not burning; 1 = burning
ost_grass_children:	equ $36					; OST indices of child objects (8 bytes)

sizeof_grass_data:	equ LGrass_Data_1-LGrass_Data
; ===========================================================================

LGrass_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto LGrass_Action next
		move.l	#Map_LGrass,ost_mappings(a0)
		move.w	#tile_pal3+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#5,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_grass_y_start(a0)
		move.w	ost_x_pos(a0),ost_grass_x_start(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0					; d0 = high nybble of subtype, multiplied by 4
		lea	LGrass_Data(pc,d0.w),a1
		move.w	(a1)+,d0				; get pointer to heightmap data
		lea	LGrass_Data(pc,d0.w),a2
		move.l	a2,ost_grass_coll_ptr(a0)		; get pointer to heightmap data again
		move.b	(a1)+,ost_frame(a0)
		move.b	(a1),ost_displaywidth(a0)
		andi.b	#$F,ost_subtype(a0)			; clear high nybble of subtype
		move.b	#$40,ost_height(a0)
		bset	#render_useheight_bit,ost_render(a0)

LGrass_Action:	; Routine 2
		bsr.w	LGrass_Types
		tst.b	ost_solid(a0)				; is platform being stood on?
		beq.s	LGrass_Solid				; if not, branch
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform				; update flags if Sonic leaves plaform
		btst	#status_platform_bit,ost_status(a1)	; is Sonic still on platform?
		bne.w	LGrass_Slope				; if yes, branch
		clr.b	ost_solid(a0)
		bra.s	LGrass_Display
; ===========================================================================

LGrass_Slope:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		movea.l	ost_grass_coll_ptr(a0),a2
		move.w	ost_x_pos(a0),d2
		bsr.w	SlopeObject_NoChk
		bra.s	LGrass_Display
; ===========================================================================

LGrass_Solid:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1					; width
		move.w	#$20,d2					; height
		cmpi.b	#id_frame_grass_narrow,ost_frame(a0)	; is this a narrow platform?
		bne.s	@not_narrow				; if not, branch
		move.w	#$30,d2					; use larger height

	@not_narrow:
		movea.l	ost_grass_coll_ptr(a0),a2
		bsr.w	SolidObject_Heightmap

LGrass_Display:
		bsr.w	DisplaySprite
		bra.w	LGrass_ChkDel

; ---------------------------------------------------------------------------
; Subroutine to update platform position and load burning grass object
; ---------------------------------------------------------------------------

LGrass_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (high nybble was removed earlier)
		andi.w	#7,d0					; read only bits 0-2
		add.w	d0,d0
		move.w	LGrass_TypeIndex(pc,d0.w),d1
		jmp	LGrass_TypeIndex(pc,d1.w)
; End of function LGrass_Types

; ===========================================================================
LGrass_TypeIndex:
		index *
		ptr LGrass_Type00
		ptr LGrass_Type01
		ptr LGrass_Type02
		ptr LGrass_Type03
		ptr LGrass_Type04
		ptr LGrass_Type05
; ===========================================================================

; Type 0 - doesn't move
LGrass_Type00:
		rts
; ===========================================================================

; Type 1 - moves up and down 32 pixels
LGrass_Type01:
		move.b	(v_oscillating_0_to_20).w,d0
		move.w	#$20,d1
		bra.s	LGrass_Move
; ===========================================================================

; Type 2 - moves up and down 48 pixels
LGrass_Type02:
		move.b	(v_oscillating_0_to_30).w,d0
		move.w	#$30,d1
		bra.s	LGrass_Move
; ===========================================================================

; Type 3 - moves up and down 64 pixels
LGrass_Type03:
		move.b	(v_oscillating_0_to_40).w,d0
		move.w	#$40,d1
		bra.s	LGrass_Move
; ===========================================================================

; Type 4 - moves up and down 96 pixels (unused)
LGrass_Type04:
		move.b	(v_oscillating_0_to_60).w,d0
		move.w	#$60,d1

LGrass_Move:
		btst	#3,ost_subtype(a0)			; is bit 3 of subtype set? (+8)
		beq.s	@no_rev					; if not, branch
		neg.w	d0					; reverse direction
		add.w	d1,d0

	@no_rev:
		move.w	ost_grass_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)			; update y position
		rts	
; ===========================================================================

; Type 5 - sinks when stood on and catches fire
LGrass_Type05:
		move.b	ost_grass_sink(a0),d0			; get current sink distance
		tst.b	ost_solid(a0)				; is platform being stood on?
		bne.s	@stood_on				; if yes, branch
		subq.b	#2,d0					; decrement sink distance
		bcc.s	@update_sink				; branch if not < 0
		moveq	#0,d0					; reset to 0
		bra.s	@update_sink
; ===========================================================================

@stood_on:
		addq.b	#4,d0					; add 4 to sink distance
		cmpi.b	#$40,d0					; has it reached $40?
		bcs.s	@update_sink				; if not, branch
		move.b	#$40,d0					; max $40

@update_sink:
		move.b	d0,ost_grass_sink(a0)			; update sink distance
		jsr	(CalcSine).l				; convert to sine
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	ost_grass_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)			; update position
		cmpi.b	#$20,ost_grass_sink(a0)
		bne.s	@skip_fire				; branch if not at $20
		tst.b	ost_grass_burn_flag(a0)
		bne.s	@skip_fire				; branch if already burning
		move.b	#1,ost_grass_burn_flag(a0)		; set burning flag
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.s	@skip_fire				; branch if not found

		move.b	#id_GrassFire,ost_id(a1)		; load sitting flame object (this spreads itself)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_grass_y_start(a0),ost_burn_y_start(a1)
		addq.w	#8,ost_burn_y_start(a1)
		subq.w	#3,ost_burn_y_start(a1)
		subi.w	#$40,ost_x_pos(a1)			; start at left side of platform
		move.l	ost_grass_coll_ptr(a0),ost_burn_coll_ptr(a1)
		move.l	a0,ost_burn_parent(a1)			; save parent OST address
		movea.l	a0,a2
		bsr.s	LGrass_AddChildToList			; save first flame OST index to list in parent OST

	@skip_fire:
		moveq	#0,d2
		lea	ost_grass_children(a0),a2		; get address of child list
		move.b	(a2)+,d2				; get quantity
		subq.b	#1,d2
		bcs.s	@skip_fire_sink				; branch if 0

	@loop_fire_sink:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.w	#v_ost_all&$FFFF,d0			; convert child OST index to address
		movea.w	d0,a1
		move.w	d1,ost_burn_sink(a1)			; copy parent sink distance to child
		dbf	d2,@loop_fire_sink			; repeat for all children

	@skip_fire_sink:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to add child to list in parent OST

; input:
;	a1 = address of OST of child fire
;	a2 = address of OST of parent platform
; ---------------------------------------------------------------------------

LGrass_AddChildToList:
		lea	ost_grass_children(a2),a2		; load list of child objects
		moveq	#0,d0
		move.b	(a2),d0					; get child count
		addq.b	#1,(a2)					; increment child counter
		lea	1(a2,d0.w),a2				; go to end of list
		move.w	a1,d0					; get child OST address
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0					; d0 = OST index of child
		move.b	d0,(a2)					; copy d0 to end of list
		rts	
; End of function LGrass_AddChildToList

; ===========================================================================

LGrass_ChkDel:
		tst.b	ost_grass_burn_flag(a0)			; is platform burning?
		beq.s	@not_burning				; if not, branch
		tst.b	ost_render(a0)				; is platform off screen?
		bpl.s	LGrass_DelFlames			; if yes, branch

	@not_burning:
		out_of_range	DeleteObject,ost_grass_x_start(a0)
		rts	
; ===========================================================================

LGrass_DelFlames:
		moveq	#0,d2
		lea	ost_grass_children(a0),a2		; get child OST list
		move.b	(a2),d2					; get quantity
		clr.b	(a2)+					; clear quantity
		subq.b	#1,d2
		bcs.s	@no_fire				; branch if 0

	@loop_del:
		moveq	#0,d0
		move.b	(a2),d0
		clr.b	(a2)+
		lsl.w	#6,d0
		addi.w	#v_ost_all&$FFFF,d0			; convert child OST index to address
		movea.w	d0,a1
		bsr.w	DeleteChild				; delete child object
		dbf	d2,@loop_del				; repeat for all children

		move.b	#0,ost_grass_burn_flag(a0)
		move.b	#0,ost_grass_sink(a0)

	@no_fire:
		rts
