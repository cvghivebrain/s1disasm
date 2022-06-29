; ---------------------------------------------------------------------------
; Object 35 - fireball that sits on the	floor (MZ)
; (appears when	you walk on sinking platforms)

; spawned by:
;	LargeGrass - subtype 0
;	GrassFire - subtype 1
; ---------------------------------------------------------------------------

GrassFire:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GFire_Index(pc,d0.w),d1
		jmp	GFire_Index(pc,d1.w)
; ===========================================================================
GFire_Index:	index *,,2
		ptr GFire_Main
		ptr GFire_Spread
		ptr GFire_Move

		rsobj GrassFire
ost_burn_x_start:	rs.w 1					; $2A ; original x position
ost_burn_y_start:	rs.w 1					; $2C ; original y position
		rsset $30
ost_burn_coll_ptr:	rs.l 1					; $30 ; pointer to collision data
		rsset $38
ost_burn_parent:	rs.l 1					; $38 ; address of OST of parent object
ost_burn_sink:		rs.w 1					; $3C ; pixels the platform has sunk when stood on
		rsobjend
; ===========================================================================

GFire_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto GFire_Spread next
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		move.w	ost_x_pos(a0),ost_burn_x_start(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		move.b	#8,ost_displaywidth(a0)
		play.w	1, jsr, sfx_Burning			; play burning sound
		tst.b	ost_subtype(a0)				; is this the first fireball?
		beq.s	GFire_Spread				; if yes, branch
		addq.b	#2,ost_routine(a0)			; goto GFire_Move next
		bra.w	GFire_Move
; ===========================================================================

GFire_Spread:	; Routine 2
		movea.l	ost_burn_coll_ptr(a0),a1		; a1 = pointer to platform heightmap
		move.w	ost_x_pos(a0),d1
		sub.w	ost_burn_x_start(a0),d1			; d1 = relative x position on platform
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0				; get value from heightmap
		neg.w	d0
		add.w	ost_burn_y_start(a0),d0			; get initial y position
		move.w	d0,d2
		add.w	ost_burn_sink(a0),d0			; add difference when platform sinks
		move.w	d0,ost_y_pos(a0)			; update y position
		cmpi.w	#$84,d1
		bcc.s	@no_fire				; branch if beyond right edge of platform
		addi.l	#$10000,ost_x_pos(a0)			; move 1px right
		cmpi.w	#$80,d1
		bcc.s	@no_fire
		move.l	ost_x_pos(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	@no_fire
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.s	@no_fire				; branch if not found
		move.b	#id_GrassFire,ost_id(a1)		; create another fire
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	d2,ost_burn_y_start(a1)			; initial y pos (ignores platform sinking)
		move.w	ost_burn_sink(a0),ost_burn_sink(a1)
		move.b	#1,ost_subtype(a1)			; child type, doesn't spawn more fire
		movea.l	ost_burn_parent(a0),a2
		bsr.w	LGrass_AddChildToList			; add to list in parent's OST

	@no_fire:
		bra.s	GFire_Animate
; ===========================================================================

GFire_Move:	; Routine 4
		move.w	ost_burn_y_start(a0),d0
		add.w	ost_burn_sink(a0),d0
		move.w	d0,ost_y_pos(a0)			; update position

GFire_Animate:
		lea	(Ani_GFire).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_GFire:	index *
		ptr ani_gfire_0
		
ani_gfire_0:	dc.b 5
		dc.b id_frame_fire_vertical1
		dc.b id_frame_fire_vertical1+afxflip
		dc.b id_frame_fire_vertical2
		dc.b id_frame_fire_vertical2+afxflip
		dc.b afEnd
		even
