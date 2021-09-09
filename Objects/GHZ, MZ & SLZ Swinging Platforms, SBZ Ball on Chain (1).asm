; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
;	    - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

SwingingPlatform:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Swing_Index(pc,d0.w),d1
		jmp	Swing_Index(pc,d1.w)
; ===========================================================================
Swing_Index:	index *,,2
		ptr Swing_Main
		ptr Swing_SetSolid
		ptr Swing_Action2
		ptr Swing_Delete
		ptr Swing_Delete
		ptr Swing_Display
		ptr Swing_Action

ost_swing_y_start:	equ $38	; original y-axis position (2 bytes)
ost_swing_x_start:	equ $3A	; original x-axis position (2 bytes)
ost_swing_radius:	equ $3C	; distance of chainlink from anchor
; ===========================================================================

Swing_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Swing_GHZ,ost_mappings(a0) ; GHZ and MZ specific code
		move.w	#tile_Nem_Swing+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#8,ost_height(a0)
		move.w	ost_y_pos(a0),ost_swing_y_start(a0)
		move.w	ost_x_pos(a0),ost_swing_x_start(a0)
		cmpi.b	#id_SLZ,(v_zone).w ; check if level is SLZ
		bne.s	@notSLZ

		move.l	#Map_Swing_SLZ,ost_mappings(a0) ; SLZ specific code
		move.w	#tile_Nem_SlzSwing+tile_pal3,ost_tile(a0)
		move.b	#$20,ost_actwidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#$99,ost_col_type(a0)

	@notSLZ:
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		bne.s	@length

		move.l	#Map_BBall,ost_mappings(a0) ; SBZ specific code
		move.w	#tile_Nem_BigSpike_SBZ,ost_tile(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#$18,ost_height(a0)
		move.b	#$86,ost_col_type(a0)
		move.b	#id_Swing_Action,ost_routine(a0) ; goto Swing_Action next

@length:
		move.b	0(a0),d4
		moveq	#0,d1
		lea	ost_subtype(a0),a2 ; move chain length to a2
		move.b	(a2),d1		; d1 = chain length
		move.w	d1,-(sp)
		andi.w	#$F,d1		; max length is 15
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3		; d3 = chain length in pixels
		addq.b	#8,d3
		move.b	d3,ost_swing_radius(a0)
		subq.b	#8,d3
		tst.b	ost_frame(a0)
		beq.s	@makechain
		addq.b	#8,d3
		subq.w	#1,d1

@makechain:
		bsr.w	FindFreeObj
		bne.s	@fail
		addq.b	#1,ost_subtype(a0)
		move.w	a1,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+	; save child OST index to byte list in parent OST
		move.b	#$A,ost_routine(a1) ; goto Swing_Display next
		move.b	d4,0(a1)	; load swinging	object
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		bclr	#6,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#4,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#1,ost_frame(a1)
		move.b	d3,ost_swing_radius(a1) ; radius is smaller for chainlinks closer to top
		subi.b	#$10,d3
		bcc.s	@notanchor
		move.b	#2,ost_frame(a1)
		move.b	#3,ost_priority(a1)
		bset	#6,ost_tile(a1)

	@notanchor:
		dbf	d1,@makechain ; repeat d1 times (chain length)

	@fail:
		move.w	a0,d5
		subi.w	#v_objspace&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,ost_angle(a0)
		move.w	#-$200,$3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1		; is object type $1X ?
		beq.s	@not1X		; if not, branch
		move.l	#Map_GBall,ost_mappings(a0) ; use GHZ ball mappings
		move.w	#tile_Nem_Ball+tile_pal3,ost_tile(a0)
		move.b	#1,ost_frame(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$81,ost_col_type(a0) ; make object hurt when touched

	@not1X:
		cmpi.b	#id_SBZ,(v_zone).w ; is zone SBZ?
		beq.s	Swing_Action	; if yes, branch

Swing_SetSolid:	; Routine 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		moveq	#0,d3
		move.b	ost_height(a0),d3
		bsr.w	Swing_Solid

Swing_Action:	; Routine $C
		bsr.w	Swing_Move
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel
; ===========================================================================

Swing_Action2:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		bsr.w	ExitPlatform
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	Swing_Move
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	ost_height(a0),d3
		addq.b	#1,d3
		bsr.w	MoveWithPlatform
		bsr.w	DisplaySprite
		bra.w	Swing_ChkDel

		rts
