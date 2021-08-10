; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall	from the ceiling (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Brick_Index(pc,d0.w),d1
		jmp	Brick_Index(pc,d1.w)
; ===========================================================================
Brick_Index:	index *,,2
		ptr Brick_Main
		ptr Brick_Action

brick_origY:	equ $30
; ===========================================================================

Brick_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$F,ost_height(a0)
		move.b	#$F,ost_width(a0)
		move.l	#Map_Brick,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		move.w	ost_y_pos(a0),brick_origY(a0)
		move.w	#$5C0,$32(a0)

Brick_Action:	; Routine 2
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#7,d0		; read only the	1st digit
		add.w	d0,d0
		move.w	Brick_TypeIndex(pc,d0.w),d1
		jsr	Brick_TypeIndex(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject

	@chkdel:
		if Revision=0
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
		else
			out_of_range	DeleteObject
			bra.w	DisplaySprite
		endc
; ===========================================================================
Brick_TypeIndex:index *
		ptr Brick_Type00
		ptr Brick_Type01
		ptr Brick_Type02
		ptr Brick_Type03
		ptr Brick_Type04
; ===========================================================================

Brick_Type00:
		rts	
; ===========================================================================

Brick_Type02:
		move.w	(v_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	loc_E888
		neg.w	d0

loc_E888:
		cmpi.w	#$90,d0		; is Sonic within $90 pixels of	the block?
		bcc.s	Brick_Type01	; if not, resume wobbling
		move.b	#3,ost_subtype(a0)	; if yes, make the block fall

Brick_Type01:
		moveq	#0,d0
		move.b	(v_oscillate+$16).w,d0
		btst	#3,ost_subtype(a0)
		beq.s	loc_E8A8
		neg.w	d0
		addi.w	#$10,d0

loc_E8A8:
		move.w	brick_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)	; update the block's position to make it wobble
		rts	
; ===========================================================================

Brick_Type03:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)	; increase falling speed
		bsr.w	ObjFloorDist
		tst.w	d1		; has the block	hit the	floor?
		bpl.w	locret_E8EE	; if not, branch
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop the block falling
		move.w	ost_y_pos(a0),brick_origY(a0)
		move.b	#4,ost_subtype(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		if Revision=0
		cmpi.w	#$2E8,d0
		else
			cmpi.w	#$16A,d0
		endc
		bcc.s	locret_E8EE
		move.b	#0,ost_subtype(a0)

locret_E8EE:
		rts	
; ===========================================================================

Brick_Type04:
		moveq	#0,d0
		move.b	(v_oscillate+$12).w,d0
		lsr.w	#3,d0
		move.w	brick_origY(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)	; make the block wobble
		rts	
