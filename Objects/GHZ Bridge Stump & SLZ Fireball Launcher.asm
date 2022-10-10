; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump, SLZ lava thrower)

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtype 3
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtype 0
; ---------------------------------------------------------------------------

Scenery:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Scen_Index(pc,d0.w),d1
		jmp	Scen_Index(pc,d1.w)
; ===========================================================================
Scen_Index:	index offset(*)
		ptr Scen_Main
		ptr Scen_ChkDel

sizeof_scen_values:	equ Scen_Values_1-Scen_Values_0
; ===========================================================================

Scen_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Scen_ChkDel next
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; copy object subtype to d0
		mulu.w	#sizeof_scen_values,d0			; multiply by $A
		lea	Scen_Values(pc,d0.w),a1
		move.l	(a1)+,ost_mappings(a0)
		move.w	(a1)+,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	(a1)+,ost_frame(a0)
		move.b	(a1)+,ost_displaywidth(a0)
		move.b	(a1)+,ost_priority(a0)
		move.b	(a1)+,ost_col_type(a0)

Scen_ChkDel:	; Routine 2
		out_of_range	DeleteObject
		bra.w	DisplaySprite
		
; ---------------------------------------------------------------------------
; Variables for	object $1C are stored in an array
; ---------------------------------------------------------------------------
Scen_Values:
Scen_Values_0:	dc.l Map_Scen					; mappings address
		dc.w tile_Nem_SlzCannon+tile_pal3		; VRAM setting
		dc.b id_frame_scen_cannon, 8, 2, 0		; frame, width, priority, collision response
		
Scen_Values_1:	dc.l Map_Scen
		dc.w tile_Nem_SlzCannon+tile_pal3
		dc.b id_frame_scen_cannon, 8, 2, 0
		
Scen_Values_2:	dc.l Map_Scen
		dc.w tile_Nem_SlzCannon+tile_pal3
		dc.b id_frame_scen_cannon, 8, 2, 0
		
Scen_Values_3:	dc.l Map_Bri
		dc.w tile_Nem_Bridge+tile_pal3
		dc.b id_frame_bridge_stump, $10, 1, 0
		even
