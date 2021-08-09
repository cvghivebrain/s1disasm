; ---------------------------------------------------------------------------
; Object 61 - blocks (LZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LBlk_Index(pc,d0.w),d1
		jmp	LBlk_Index(pc,d1.w)
; ===========================================================================
LBlk_Index:	index *,,2
		ptr LBlk_Main
		ptr LBlk_Action

LBlk_Var:	dc.b $10, $10		; width, height
		dc.b $20, $C
		dc.b $10, $10
		dc.b $10, $10

lblk_height:	equ $16		; block height
lblk_origX:	equ $34		; original x-axis position
lblk_origY:	equ $30		; original y-axis position
lblk_time:	equ $36		; time delay for block movement
lblk_untouched:	equ $38		; flag block as untouched
; ===========================================================================

LBlk_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_LBlock,ost_mappings(a0)
		move.w	#tile_Nem_LzDoor2+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get block type
		lsr.w	#3,d0		; read only the 1st digit
		andi.w	#$E,d0
		lea	LBlk_Var(pc,d0.w),a2
		move.b	(a2)+,ost_actwidth(a0) ; set width
		move.b	(a2),lblk_height(a0) ; set height
		lsr.w	#1,d0
		move.b	d0,ost_frame(a0)
		move.w	ost_x_pos(a0),lblk_origX(a0)
		move.w	ost_y_pos(a0),lblk_origY(a0)
		move.b	ost_subtype(a0),d0 ; get block type
		andi.b	#$F,d0		; read only the 2nd digit
		beq.s	LBlk_Action	; branch if 0
		cmpi.b	#7,d0
		beq.s	LBlk_Action	; branch if 7
		move.b	#1,lblk_untouched(a0)

LBlk_Action:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	lblk_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject
		move.b	d4,$3F(a0)
		bsr.w	loc_12180

@chkdel:
		out_of_range	DeleteObject,lblk_origX(a0)
		bra.w	DisplaySprite
; ===========================================================================
@index:		index *
		ptr @type00
		ptr @type01
		ptr @type02
		ptr @type03
		ptr @type04
		ptr @type05
		ptr @type06
		ptr @type07
; ===========================================================================

@type00:
		rts	
; ===========================================================================

@type01:
@type03:
		tst.w	lblk_time(a0)	; does time remain?
		bne.s	@wait01		; if yes, branch
		btst	#3,ost_status(a0)	; is Sonic standing on the object?
		beq.s	@donothing01	; if not, branch
		move.w	#30,lblk_time(a0) ; wait for half second

	@donothing01:
		rts	
; ===========================================================================

	@wait01:
		subq.w	#1,lblk_time(a0); decrement waiting time
		bne.s	@donothing01	; if time remains, branch
		addq.b	#1,ost_subtype(a0) ; goto @type02 or @type04
		clr.b	lblk_untouched(a0) ; flag block as touched
		rts	
; ===========================================================================

@type02:
@type06:
		bsr.w	SpeedToPos
		addq.w	#8,ost_y_vel(a0)	; make block fall
		bsr.w	ObjFloorDist
		tst.w	d1		; has block hit the floor?
		bpl.w	@nofloor02	; if not, branch
		addq.w	#1,d1
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop when it touches the floor
		clr.b	ost_subtype(a0)	; set type to 00 (non-moving type)

	@nofloor02:
		rts	
; ===========================================================================

@type04:
		bsr.w	SpeedToPos
		subq.w	#8,ost_y_vel(a0)	; make block rise
		bsr.w	ObjHitCeiling
		tst.w	d1		; has block hit the ceiling?
		bpl.w	@noceiling04	; if not, branch
		sub.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop when it touches the ceiling
		clr.b	ost_subtype(a0)	; set type to 00 (non-moving type)

	@noceiling04:
		rts	
; ===========================================================================

@type05:
		cmpi.b	#1,$3F(a0)	; is Sonic touching the	block?
		bne.s	@notouch05	; if not, branch
		addq.b	#1,ost_subtype(a0) ; goto @type06
		clr.b	lblk_untouched(a0)

	@notouch05:
		rts	
; ===========================================================================

@type07:
		move.w	(v_waterpos1).w,d0
		sub.w	ost_y_pos(a0),d0	; is block level with water?
		beq.s	@stop07		; if yes, branch
		bcc.s	@fall07		; branch if block is above water
		cmpi.w	#-2,d0
		bge.s	@loc_1214E
		moveq	#-2,d0

	@loc_1214E:
		add.w	d0,ost_y_pos(a0)	; make the block rise with water level
		bsr.w	ObjHitCeiling
		tst.w	d1		; has block hit the ceiling?
		bpl.w	@noceiling07	; if not, branch
		sub.w	d1,ost_y_pos(a0)	; stop block

	@noceiling07:
		rts	
; ===========================================================================

@fall07:
		cmpi.w	#2,d0
		ble.s	@loc_1216A
		moveq	#2,d0

	@loc_1216A:
		add.w	d0,ost_y_pos(a0)	; make the block sink with water level
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.w	@stop07
		addq.w	#1,d1
		add.w	d1,ost_y_pos(a0)

	@stop07:
		rts	
; ===========================================================================

loc_12180:
		tst.b	lblk_untouched(a0) ; has block been stood on or touched?
		beq.s	locret_121C0	; if yes, branch
		btst	#3,ost_status(a0)	; is Sonic standing on it now?
		bne.s	loc_1219A	; if yes, branch
		tst.b	$3E(a0)
		beq.s	locret_121C0
		subq.b	#4,$3E(a0)
		bra.s	loc_121A6
; ===========================================================================

loc_1219A:
		cmpi.b	#$40,$3E(a0)
		beq.s	locret_121C0
		addq.b	#4,$3E(a0)

loc_121A6:
		move.b	$3E(a0),d0
		jsr	(CalcSine).l
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	lblk_origY(a0),d0
		move.w	d0,ost_y_pos(a0)

locret_121C0:
		rts	
