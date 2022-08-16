; ---------------------------------------------------------------------------
; Object 4B - giant ring for entry to special stage

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_MZ1, ObjPos_MZ2
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_LZ1, ObjPos_LZ2
;	ObjPos_SLZ1, ObjPos_SLZ2
; ---------------------------------------------------------------------------

GiantRing:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GRing_Index(pc,d0.w),d1
		jmp	GRing_Index(pc,d1.w)
; ===========================================================================
GRing_Index:	index *,,2
		ptr GRing_Main
		ptr GRing_Animate
		ptr GRing_Collect
		ptr GRing_Delete
; ===========================================================================

GRing_Main:	; Routine 0
		move.l	#Map_GRing,ost_mappings(a0)
		move.w	#(vram_giantring/sizeof_cell)+tile_pal2,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$40,ost_displaywidth(a0)
		tst.b	ost_render(a0)
		bpl.s	GRing_Animate
		cmpi.b	#countof_emeralds,(v_emeralds).w	; do you have 6 emeralds?
		beq.w	GRing_Delete				; if yes, branch
		cmpi.w	#rings_for_special_stage,(v_rings).w	; do you have at least 50 rings?
		bcc.s	GRing_Okay				; if yes, branch
		rts	
; ===========================================================================

GRing_Okay:
		addq.b	#2,ost_routine(a0)			; goto GRing_Animate next
		move.b	#2,ost_priority(a0)
		move.b	#id_col_8x16+id_col_item,ost_col_type(a0) ; when Sonic hits the item, goto GRing_Collect next (see ReactToItem)
		move.w	#sizeof_Art_BigRing,(v_giantring_gfx_offset).w ; signal that Art_BigRing should be loaded ($C40 is the size of Art_BigRing)

GRing_Animate:	; Routine 2
		move.b	(v_syncani_1_frame).w,ost_frame(a0)
		out_of_range	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

GRing_Collect:	; Routine 4
		subq.b	#2,ost_routine(a0)			; goto GRing_Animate next
		move.b	#0,ost_col_type(a0)
		bsr.w	FindFreeObj				; find free OST slot
		bne.w	.fail					; branch if not found
		move.b	#id_RingFlash,ost_id(a1)		; load giant ring flash object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.l	a0,ost_flash_parent(a1)
		move.w	(v_ost_player+ost_x_pos).w,d0
		cmp.w	ost_x_pos(a0),d0			; has Sonic come from the left?
		bcs.s	.noflip					; if yes, branch
		bset	#render_xflip_bit,ost_render(a1)	; reverse flash object

	.fail:
	.noflip:
		play.w	1, jsr, sfx_GiantRing			; play giant ring sound
		bra.s	GRing_Animate
; ===========================================================================

GRing_Delete:	; Routine 6
		bra.w	DeleteObject
