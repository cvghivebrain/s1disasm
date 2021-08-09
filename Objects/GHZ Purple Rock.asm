; ---------------------------------------------------------------------------
; Object 3B - purple rock (GHZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Rock_Index(pc,d0.w),d1
		jmp	Rock_Index(pc,d1.w)
; ===========================================================================
Rock_Index:	index *,,2
		ptr Rock_Main
		ptr Rock_Solid
; ===========================================================================

Rock_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_PRock,ost_mappings(a0)
		move.w	#tile_Nem_PplRock+tile_pal4,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$13,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)

Rock_Solid:	; Routine 2
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
