; ---------------------------------------------------------------------------
; Object 08 - water splash (LZ)
; ---------------------------------------------------------------------------

Splash:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Spla_Index(pc,d0.w),d1
		jmp	Spla_Index(pc,d1.w)
; ===========================================================================
Spla_Index:	index *,,2
		ptr Spla_Main
		ptr Spla_Display
		ptr Spla_Delete
; ===========================================================================

Spla_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Splash,ost_mappings(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		move.w	#tile_Nem_Splash+tile_pal3,ost_tile(a0)
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a0) ; copy x-position from Sonic

Spla_Display:	; Routine 2
		move.w	(v_waterpos1).w,ost_y_pos(a0) ; copy y-position from water height
		lea	(Ani_Splash).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Spla_Delete:	; Routine 4
		jmp	(DeleteObject).l	; delete when animation	is complete
