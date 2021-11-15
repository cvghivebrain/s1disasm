; ---------------------------------------------------------------------------
; Object 35 - fireball that sits on the	floor (MZ)
; (appears when	you walk on sinking platforms)
; ---------------------------------------------------------------------------

GrassFire:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GFire_Index(pc,d0.w),d1
		jmp	GFire_Index(pc,d1.w)
; ===========================================================================
GFire_Index:	index *,,2
		ptr GFire_Main
		ptr loc_B238
		ptr GFire_Move

ost_burn_x_start:	equ $2A					; original x position (2 bytes)
ost_burn_y_start:	equ $2C					; original y position (2 bytes)
ost_burn_coll_ptr:	equ $30					; pointer to collision data (4 bytes)
ost_burn_parent:	equ $38					; address of OST of parent object (4 bytes)
ost_burn_sink:		equ $3C					; pixels the platform has sunk when stood on
; ===========================================================================

GFire_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		move.w	ost_x_pos(a0),ost_burn_x_start(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		move.b	#8,ost_actwidth(a0)
		play.w	1, jsr, sfx_Burning			; play burning sound
		tst.b	ost_subtype(a0)
		beq.s	loc_B238
		addq.b	#2,ost_routine(a0)
		bra.w	GFire_Move
; ===========================================================================

loc_B238:	; Routine 2
		movea.l	ost_burn_coll_ptr(a0),a1
		move.w	ost_x_pos(a0),d1
		sub.w	ost_burn_x_start(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	ost_burn_y_start(a0),d0
		move.w	d0,d2
		add.w	ost_burn_sink(a0),d0
		move.w	d0,ost_y_pos(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_B2B0
		addi.l	#$10000,ost_x_pos(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_B2B0
		move.l	ost_x_pos(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_B2B0
		bsr.w	FindNextFreeObj
		bne.s	loc_B2B0
		move.b	#id_GrassFire,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	d2,ost_burn_y_start(a1)
		move.w	ost_burn_sink(a0),ost_burn_sink(a1)
		move.b	#1,ost_subtype(a1)
		movea.l	ost_burn_parent(a0),a2
		bsr.w	sub_B09C

loc_B2B0:
		bra.s	GFire_Animate
; ===========================================================================

GFire_Move:	; Routine 4
		move.w	ost_burn_y_start(a0),d0
		add.w	ost_burn_sink(a0),d0
		move.w	d0,ost_y_pos(a0)

GFire_Animate:
		lea	(Ani_GFire).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
