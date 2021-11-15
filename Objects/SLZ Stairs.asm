; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase (SLZ)
; ---------------------------------------------------------------------------

Staircase:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Stair_Index(pc,d0.w),d1
		jsr	Stair_Index(pc,d1.w)
		out_of_range	DeleteObject,ost_stair_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================
Stair_Index:	index *,,2
		ptr Stair_Main
		ptr Stair_Move
		ptr Stair_Solid

ost_stair_x_start:	equ $30					; original x-axis position (2 bytes)
ost_stair_y_start:	equ $32					; original y-axis position (2 bytes)
ost_stair_wait_time:	equ $34					; time delay for stairs to move (2 bytes)
ost_stair_flag:		equ $36					; 1 = stood on; $80+ = hit from below
ost_stair_child_id:	equ $37					; which child the current object is; $38-$3B
ost_stair_children:	equ $38					; OST indices of child objects (4 bytes)
ost_stair_parent:	equ $3C					; address of OST of parent object (4 bytes)
; ===========================================================================

Stair_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		moveq	#ost_stair_children,d3
		moveq	#1,d4
		btst	#status_xflip_bit,ost_status(a0)	; is object flipped?
		beq.s	@notflipped				; if not, branch
		moveq	#ost_stair_children+3,d3
		moveq	#-1,d4

	@notflipped:
		move.w	ost_x_pos(a0),d2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	@makeblocks
; ===========================================================================

@loop:
		bsr.w	FindNextFreeObj
		bne.w	@fail
		move.b	#4,ost_routine(a1)

@makeblocks:
		move.b	#id_Staircase,0(a1)			; load another block object
		move.l	#Map_Stair,ost_mappings(a1)
		move.w	#0+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#$10,ost_actwidth(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.w	d2,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_x_pos(a0),ost_stair_x_start(a1)
		move.w	ost_y_pos(a1),ost_stair_y_start(a1)
		addi.w	#$20,d2
		move.b	d3,ost_stair_child_id(a1)		; values $38-$3B (or $3B-$38 if flipped)
		move.l	a0,ost_stair_parent(a1)
		add.b	d4,d3
		dbf	d1,@loop				; repeat sequence 3 times

	@fail:

Stair_Move:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Stair_TypeIndex(pc,d0.w),d1
		jsr	Stair_TypeIndex(pc,d1.w)

Stair_Solid:	; Routine 4
		movea.l	ost_stair_parent(a0),a2
		moveq	#0,d0
		move.b	ost_stair_child_id(a0),d0
		move.b	(a2,d0.w),d0
		add.w	ost_stair_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		tst.b	d4
		bpl.s	loc_10F92
		move.b	d4,ost_stair_flag(a2)

loc_10F92:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	locret_10FA0
		move.b	#1,ost_stair_flag(a2)

locret_10FA0:
		rts	
; ===========================================================================
Stair_TypeIndex:index *
		ptr Stair_Type00				; form staircase when stood on
		ptr Stair_Type01
		ptr Stair_Type02				; form staircase when hit from below
		ptr Stair_Type01
; ===========================================================================

Stair_Type00:
		tst.w	ost_stair_wait_time(a0)
		bne.s	loc_10FC0
		cmpi.b	#1,ost_stair_flag(a0)
		bne.s	locret_10FBE
		move.w	#30,ost_stair_wait_time(a0)		; set time delay to half a second

locret_10FBE:
		rts	
; ===========================================================================

loc_10FC0:
		subq.w	#1,ost_stair_wait_time(a0)
		bne.s	locret_10FBE
		addq.b	#1,ost_subtype(a0)			; add 1 to type
		rts	
; ===========================================================================

Stair_Type02:
		tst.w	ost_stair_wait_time(a0)
		bne.s	loc_10FE0
		tst.b	ost_stair_flag(a0)
		bpl.s	locret_10FDE
		move.w	#60,ost_stair_wait_time(a0)		; set time delay to 1 second

locret_10FDE:
		rts	
; ===========================================================================

loc_10FE0:
		subq.w	#1,ost_stair_wait_time(a0)
		bne.s	loc_10FEC
		addq.b	#1,ost_subtype(a0)			; add 1 to type
		rts	
; ===========================================================================

loc_10FEC:
		lea	ost_stair_children(a0),a1
		move.w	ost_stair_wait_time(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts	
; ===========================================================================

Stair_Type01:
		lea	ost_stair_children(a0),a1
		cmpi.b	#$80,(a1)
		beq.s	locret_11038
		addq.b	#1,(a1)
		moveq	#0,d1
		move.b	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.b	d3,(a1)+
		move.b	d2,(a1)+
		move.b	d1,(a1)+

locret_11038:
		rts	
		rts	
