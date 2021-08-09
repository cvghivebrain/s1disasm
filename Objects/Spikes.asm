; ---------------------------------------------------------------------------
; Object 36 - spikes
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Spik_Index(pc,d0.w),d1
		jmp	Spik_Index(pc,d1.w)
; ===========================================================================
Spik_Index:	index *,,2
		ptr Spik_Main
		ptr Spik_Solid

spik_origX:	equ $30		; start X position
spik_origY:	equ $32		; start Y position

Spik_Var:	dc.b 0,	$14		; frame	number,	object width
		dc.b 1,	$10
		dc.b 2,	4
		dc.b 3,	$1C
		dc.b 4,	$40
		dc.b 5,	$10
; ===========================================================================

Spik_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Spike,ost_mappings(a0)
		move.w	#tile_Nem_Spikes,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	ost_subtype(a0),d0
		andi.b	#$F,ost_subtype(a0)
		andi.w	#$F0,d0
		lea	(Spik_Var).l,a1
		lsr.w	#3,d0
		adda.w	d0,a1
		move.b	(a1)+,ost_frame(a0)
		move.b	(a1)+,ost_actwidth(a0)
		move.w	ost_x_pos(a0),spik_origX(a0)
		move.w	ost_y_pos(a0),spik_origY(a0)

Spik_Solid:	; Routine 2
		bsr.w	Spik_Type0x	; make the object move
		move.w	#4,d2
		cmpi.b	#5,ost_frame(a0)	; is object type $5x ?
		beq.s	Spik_SideWays	; if yes, branch
		cmpi.b	#1,ost_frame(a0)	; is object type $1x ?
		bne.s	Spik_Upright	; if not, branch
		move.w	#$14,d2

; Spikes types $1x and $5x face	sideways

Spik_SideWays:
		move.w	#$1B,d1
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		btst	#3,ost_status(a0)
		bne.s	Spik_Display
		cmpi.w	#1,d4
		beq.s	Spik_Hurt
		bra.s	Spik_Display
; ===========================================================================

; Spikes types $0x, $2x, $3x and $4x face up or	down

Spik_Upright:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		btst	#3,ost_status(a0)
		bne.s	Spik_Hurt
		tst.w	d4
		bpl.s	Spik_Display

Spik_Hurt:
		tst.b	(v_invinc).w	; is Sonic invincible?
		bne.s	Spik_Display	; if yes, branch
		move.l	a0,-(sp)
		movea.l	a0,a2
		lea	(v_player).w,a0
		cmpi.b	#4,ost_routine(a0)
		bcc.s	loc_CF20
	if Revision<>2
		move.l	ost_y_pos(a0),d3
		move.w	ost_y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
	else
		; This fixes the infamous "spike bug"
		tst.w	flashtime(a0)	; Is Sonic flashing after being hurt?
		bne.s	loc_CF20	; If so, skip getting hurt
		jmp	(loc_E0).l	; This is a copy of the above code that was pushed aside for this
loc_D5A2:
	endif
		sub.l	d0,d3
		move.l	d3,ost_y_pos(a0)
		jsr	(HurtSonic).l

loc_CF20:
		movea.l	(sp)+,a0

Spik_Display:
		bsr.w	DisplaySprite
		out_of_range	DeleteObject,spik_origX(a0)
		rts	
; ===========================================================================

Spik_Type0x:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	Spik_TypeIndex(pc,d0.w),d1
		jmp	Spik_TypeIndex(pc,d1.w)
; ===========================================================================
Spik_TypeIndex:	index *
		ptr Spik_Type00
		ptr Spik_Type01
		ptr Spik_Type02
; ===========================================================================

Spik_Type00:
		rts			; don't move the object
; ===========================================================================

Spik_Type01:
		bsr.w	Spik_Wait
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	spik_origY(a0),d0
		move.w	d0,ost_y_pos(a0)	; move the object vertically
		rts	
; ===========================================================================

Spik_Type02:
		bsr.w	Spik_Wait
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	spik_origX(a0),d0
		move.w	d0,ost_x_pos(a0)	; move the object horizontally
		rts	
; ===========================================================================

Spik_Wait:
		tst.w	$38(a0)		; is time delay	= zero?
		beq.s	loc_CFA4	; if yes, branch
		subq.w	#1,$38(a0)	; subtract 1 from time delay
		bne.s	locret_CFE6
		tst.b	ost_render(a0)
		bpl.s	locret_CFE6
		sfx	sfx_SpikesMove,0,0,0	; play "spikes moving" sound
		bra.s	locret_CFE6
; ===========================================================================

loc_CFA4:
		tst.w	$36(a0)
		beq.s	loc_CFC6
		subi.w	#$800,$34(a0)
		bcc.s	locret_CFE6
		move.w	#0,$34(a0)
		move.w	#0,$36(a0)
		move.w	#60,$38(a0)	; set time delay to 1 second
		bra.s	locret_CFE6
; ===========================================================================

loc_CFC6:
		addi.w	#$800,$34(a0)
		cmpi.w	#$2000,$34(a0)
		bcs.s	locret_CFE6
		move.w	#$2000,$34(a0)
		move.w	#1,$36(a0)
		move.w	#60,$38(a0)	; set time delay to 1 second

locret_CFE6:
		rts	
