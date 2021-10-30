; ---------------------------------------------------------------------------
; Object 25 - rings
; ---------------------------------------------------------------------------

Rings:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Ring_Index(pc,d0.w),d1
		jmp	Ring_Index(pc,d1.w)
; ===========================================================================
Ring_Index:	index *,,2
		ptr Ring_Main
		ptr Ring_Animate
		ptr Ring_Collect
		ptr Ring_Sparkle
		ptr Ring_Delete
; ---------------------------------------------------------------------------
; Distances between rings (format: horizontal, vertical)
; ---------------------------------------------------------------------------
Ring_PosData:	dc.b $10, 0		; horizontal tight
		dc.b $18, 0		; horizontal normal
		dc.b $20, 0		; horizontal wide
		dc.b 0,	$10		; vertical tight
		dc.b 0,	$18		; vertical normal
		dc.b 0,	$20		; vertical wide
		dc.b $10, $10		; diagonal
		dc.b $18, $18
		dc.b $20, $20
		dc.b $F0, $10
		dc.b $E8, $18
		dc.b $E0, $20
		dc.b $10, 8
		dc.b $18, $10
		dc.b $F0, 8
		dc.b $E8, $10

ost_ring_x_main:	equ $32	; x position of primary ring (2 bytes)
ost_ring_num:		equ $34	; which ring in the group of 1-7 rings it is
; ===========================================================================

Ring_Main:	; Routine 0
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4		; d4 = byte from respawn memory
		move.b	ost_subtype(a0),d1
		move.b	d1,d0
		andi.w	#7,d1
		cmpi.w	#7,d1
		bne.s	loc_9B80
		moveq	#6,d1		; d1 = ring quantity (0-6)

	loc_9B80:
		swap	d1
		move.w	#0,d1
		lsr.b	#4,d0
		add.w	d0,d0		; d0 = ring spacing value (0-$F *2)
		move.b	Ring_PosData(pc,d0.w),d5 ; load x spacing data
		ext.w	d5
		move.b	Ring_PosData+1(pc,d0.w),d6 ; load y spacing data
		ext.w	d6
		movea.l	a0,a1
		move.w	ost_x_pos(a0),d2
		move.w	ost_y_pos(a0),d3
		lsr.b	#1,d4
		bcs.s	loc_9C02
		bclr	#7,(a2)
		bra.s	loc_9BBA
; ===========================================================================

Ring_MakeRings:
		swap	d1
		lsr.b	#1,d4
		bcs.s	loc_9C02
		bclr	#7,(a2)
		bsr.w	FindFreeObj
		bne.s	loc_9C0E

loc_9BBA:
		move.b	#id_Rings,0(a1)	; load ring object
		addq.b	#2,ost_routine(a1)
		move.w	d2,ost_x_pos(a1) ; set x-axis position based on d2
		move.w	ost_x_pos(a0),ost_ring_x_main(a1)
		move.w	d3,ost_y_pos(a1) ; set y-axis position based on d3
		move.l	#Map_Ring,ost_mappings(a1)
		move.w	#tile_Nem_Ring+tile_pal2,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#2,ost_priority(a1)
		move.b	#$47,ost_col_type(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	ost_respawn(a0),ost_respawn(a1)
		move.b	d1,ost_ring_num(a1)

loc_9C02:
		addq.w	#1,d1
		add.w	d5,d2		; add x spacing value to d2
		add.w	d6,d3		; add y spacing value to d3
		swap	d1
		dbf	d1,Ring_MakeRings ; repeat for number of rings

loc_9C0E:
		btst	#0,(a2)
		bne.w	DeleteObject

Ring_Animate:	; Routine 2
		move.b	(v_ani1_frame).w,ost_frame(a0) ; set frame
		bsr.w	DisplaySprite
		out_of_range.s	Ring_Delete,ost_ring_x_main(a0)
		rts	
; ===========================================================================

Ring_Collect:	; Routine 4
		addq.b	#2,ost_routine(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#1,ost_priority(a0)
		bsr.w	CollectRing
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		move.b	ost_ring_num(a0),d1 ; which ring is collected
		bset	d1,2(a2,d0.w)	; set bit in respawn memory

Ring_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

Ring_Delete:	; Routine 8
		bra.w	DeleteObject
