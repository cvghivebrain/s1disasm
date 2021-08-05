; ---------------------------------------------------------------------------
; Object 29 - points that appear when you destroy something
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Poi_Index(pc,d0.w),d1
		jsr	Poi_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Poi_Index:	index *,,2
		ptr Poi_Main
		ptr Poi_Slower
; ===========================================================================

Poi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Points,ost_mappings(a0)
		move.w	#tile_Nem_Points+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.w	#-$300,ost_y_vel(a0) ; move object upwards

Poi_Slower:	; Routine 2
		tst.w	ost_y_vel(a0)	; is object moving?
		bpl.w	DeleteObject	; if not, delete
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)	; reduce object	speed
		rts	
