; ---------------------------------------------------------------------------
; Object 4D - lava geyser / lavafall (MZ)
; ---------------------------------------------------------------------------

LavaGeyser:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Geyser_Index(pc,d0.w),d1
		jsr	Geyser_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Geyser_Index:	index *,,2
		ptr Geyser_Main
		ptr Geyser_Action
		ptr loc_EFFC
		ptr Geyser_Delete

Geyser_Speeds:	dc.w $FB00, 0

ost_geyser_y_start:	equ $30					; original y position (2 bytes)
ost_geyser_parent:	equ $3C					; address of OST of parent object (4 bytes)
; ===========================================================================

Geyser_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	ost_y_pos(a0),ost_geyser_y_start(a0)
		tst.b	ost_subtype(a0)
		beq.s	@isgeyser
		subi.w	#$250,ost_y_pos(a0)

	@isgeyser:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	Geyser_Speeds(pc,d0.w),ost_y_vel(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	@makelava
		bra.s	@activate
; ===========================================================================

	@loop:
		bsr.w	FindNextFreeObj
		bne.s	@fail

@makelava:
		move.b	#id_LavaGeyser,ost_id(a1)
		move.l	#Map_Geyser,ost_mappings(a1)
		move.w	#tile_Nem_Lava+tile_pal4,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#1,ost_priority(a1)
		move.b	#id_ani_geyser_bubble4,ost_anim(a1)
		tst.b	ost_subtype(a0)
		beq.s	@fail
		move.b	#id_ani_geyser_end,ost_anim(a1)

	@fail:
		dbf	d1,@loop
		rts	
; ===========================================================================

@activate:
		addi.w	#$60,ost_y_pos(a1)
		move.w	ost_geyser_y_start(a0),ost_geyser_y_start(a1)
		addi.w	#$60,ost_geyser_y_start(a1)
		move.b	#id_col_32x112+id_col_hurt,ost_col_type(a1)
		move.b	#$80,ost_height(a1)
		bset	#render_useheight_bit,ost_render(a1)
		addq.b	#4,ost_routine(a1)
		move.l	a0,ost_geyser_parent(a1)
		tst.b	ost_subtype(a0)
		beq.s	@sound
		moveq	#0,d1
		bsr.w	@loop
		addq.b	#2,ost_routine(a1)
		bset	#tile_yflip_bit,ost_tile(a1)
		addi.w	#$100,ost_y_pos(a1)
		move.b	#0,ost_priority(a1)
		move.w	ost_geyser_y_start(a0),ost_geyser_y_start(a1)
		move.l	ost_geyser_parent(a0),ost_geyser_parent(a1)
		move.b	#0,ost_subtype(a0)

	@sound:
		play.w	1, jsr, sfx_Burning			; play flame sound

Geyser_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	Geyser_Types(pc,d0.w),d1
		jsr	Geyser_Types(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite

Geyser_ChkDel:
		out_of_range	DeleteObject
		rts	
; ===========================================================================
Geyser_Types:	index *
		ptr Geyser_Type00
		ptr Geyser_Type01
; ===========================================================================

Geyser_Type00:
		addi.w	#$18,ost_y_vel(a0)			; increase object's falling speed
		move.w	ost_geyser_y_start(a0),d0
		cmp.w	ost_y_pos(a0),d0
		bcc.s	locret_EFDA
		addq.b	#4,ost_routine(a0)
		movea.l	ost_geyser_parent(a0),a1
		move.b	#id_ani_geyser_bubble3,ost_anim(a1)

locret_EFDA:
		rts	
; ===========================================================================

Geyser_Type01:
		addi.w	#$18,ost_y_vel(a0)			; increase object's falling speed
		move.w	ost_geyser_y_start(a0),d0
		cmp.w	ost_y_pos(a0),d0
		bcc.s	locret_EFFA
		addq.b	#4,ost_routine(a0)
		movea.l	ost_geyser_parent(a0),a1
		move.b	#id_ani_geyser_bubble2,ost_anim(a1)

locret_EFFA:
		rts	
; ===========================================================================

loc_EFFC:	; Routine 4
		movea.l	ost_geyser_parent(a0),a1
		cmpi.b	#6,ost_routine(a1)
		beq.w	Geyser_Delete
		move.w	ost_y_pos(a1),d0
		addi.w	#$60,d0
		move.w	d0,ost_y_pos(a0)
		sub.w	ost_geyser_y_start(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_F026
		moveq	#$B,d1

loc_F026:
		cmpi.w	#$80,d0
		ble.s	loc_F02E
		moveq	#$E,d1

loc_F02E:
		subq.b	#1,ost_anim_time(a0)
		bpl.s	loc_F04C
		move.b	#7,ost_anim_time(a0)
		addq.b	#1,ost_anim_frame(a0)
		cmpi.b	#2,ost_anim_frame(a0)
		bcs.s	loc_F04C
		move.b	#0,ost_anim_frame(a0)

loc_F04C:
		move.b	ost_anim_frame(a0),d0
		add.b	d1,d0
		move.b	d0,ost_frame(a0)
		bra.w	Geyser_ChkDel
; ===========================================================================

Geyser_Delete:	; Routine 6
		bra.w	DeleteObject
