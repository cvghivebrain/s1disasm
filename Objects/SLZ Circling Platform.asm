; ---------------------------------------------------------------------------
; Object 5A - platforms	moving in circles (SLZ)

; spawned by:
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes 0-7
; ---------------------------------------------------------------------------

CirclingPlatform:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Circ_Index(pc,d0.w),d1
		jsr	Circ_Index(pc,d1.w)
		out_of_range	DeleteObject,ost_circ_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================
Circ_Index:	index *,,2
		ptr Circ_Main
		ptr Circ_Platform
		ptr Circ_StoodOn

		rsobj CirclingPlatform,$30
ost_circ_y_start:	rs.w 1					; $30 ; original y-axis position
ost_circ_x_start:	rs.w 1					; $32 ; original x-axis position
		rsobjend
; ===========================================================================

Circ_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Circ_Platform next
		move.l	#Map_Circ,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$18,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_circ_x_start(a0)
		move.w	ost_y_pos(a0),ost_circ_y_start(a0)

Circ_Platform:	; Routine 2
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		jsr	(DetectPlatform).l			; detect collision and goto Circ_StoodOn next if true
		bra.w	Circ_Types
; ===========================================================================

Circ_StoodOn:	; Routine 4
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		jsr	(ExitPlatform).l			; goto Circ_Platform next if Sonic leaves platform
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	Circ_Types
		move.w	(sp)+,d2
		jmp	(MoveWithPlatform2).l			; update Sonic's position
; ===========================================================================

Circ_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$C,d0					; read bits 2 & 3 of subtype (0, 4, 8 or $C)
		lsr.w	#1,d0					; divide by 2
		move.w	Circ_Type_Index(pc,d0.w),d1
		jmp	Circ_Type_Index(pc,d1.w)
; ===========================================================================
Circ_Type_Index:
		index *,,4
		ptr Circ_Anticlockwise				; types 0-3
		ptr Circ_Clockwise				; types 4-7
; ===========================================================================

Circ_Anticlockwise:
		move.b	(v_oscillating_0_to_A0).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(v_oscillating_0_to_A0_alt).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,ost_subtype(a0)			; is type 1 or 3?
		beq.s	@not_1_or_3				; if not, branch
		neg.w	d1
		neg.w	d2

	@not_1_or_3:
		btst	#1,ost_subtype(a0)			; is type 2 or 3?
		beq.s	@not_2_or_3				; if not, branch
		neg.w	d1
		exg	d1,d2

	@not_2_or_3:
		add.w	ost_circ_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		add.w	ost_circ_y_start(a0),d2
		move.w	d2,ost_y_pos(a0)
		rts	
; ===========================================================================

Circ_Clockwise:
		move.b	(v_oscillating_0_to_A0).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(v_oscillating_0_to_A0_alt).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,ost_subtype(a0)
		beq.s	@not_1_or_3
		neg.w	d1
		neg.w	d2

	@not_1_or_3:
		btst	#1,ost_subtype(a0)
		beq.s	@not_2_or_3
		neg.w	d1
		exg	d1,d2

	@not_2_or_3:
		neg.w	d1					; reverse x position delta
		add.w	ost_circ_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		add.w	ost_circ_y_start(a0),d2
		move.w	d2,ost_y_pos(a0)
		rts	
