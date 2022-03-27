; ---------------------------------------------------------------------------
; Object 25 - rings

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3
;	ObjPos_SBZ1, ObjPos_SBZ2, ObjPos_SBZ3
;	Signpost - routine 6
;	Rings - routine 
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

		; x, y
Ring_Spacing:	dc.b $10, 0					; $0x - horizontal tight
		dc.b $18, 0					; $1x - horizontal normal
		dc.b $20, 0					; $2x - horizontal wide
		dc.b 0,	$10					; $3x - vertical tight
		dc.b 0,	$18					; $4x - vertical normal
		dc.b 0,	$20					; $5x - vertical wide
		dc.b $10, $10					; $6x - diagonal
		dc.b $18, $18					; $7x - unused
		dc.b $20, $20					; $8x - diagonal wide
		dc.b -$10, $10					; $9x - diagonal flipped
		dc.b -$18, $18					; $Ax - unused
		dc.b -$20, $20					; $Bx - unused
		dc.b $10, 8					; $Cx - unused
		dc.b $18, $10					; $Dx - unused
		dc.b -$10, 8					; $Ex - unused
		dc.b -$18, $10					; $Fx - unused

ost_ring_x_main:	equ $32					; x position of primary ring (2 bytes)
ost_ring_num:		equ $34					; which ring in the group of 1-7 rings it is
; ===========================================================================

Ring_Main:	; Routine 0
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4					; d4 = byte from respawn memory
		move.b	ost_subtype(a0),d1
		move.b	d1,d0
		andi.w	#7,d1					; read bits 0-2 of subtype (ring quantity minus 1)
		cmpi.w	#7,d1					; is subtype = 7 ?
		bne.s	@not_7					; if not, branch
		moveq	#6,d1					; max 6

	@not_7:
		swap	d1					; move into high word
		move.w	#0,d1					; clear low word
		lsr.b	#4,d0					; read high nybble of subtype
		add.w	d0,d0					; d0 = ring spacing index (0-$F *2)
		move.b	Ring_Spacing(pc,d0.w),d5		; load x spacing data
		ext.w	d5
		move.b	Ring_Spacing+1(pc,d0.w),d6		; load y spacing data
		ext.w	d6
		movea.l	a0,a1					; current object will be first ring
		move.w	ost_x_pos(a0),d2
		move.w	ost_y_pos(a0),d3
		lsr.b	#1,d4					; has first ring been collected previously?
		bcs.s	@skip_ring				; if yes, branch
		bclr	#7,(a2)
		bra.s	@load_first
; ===========================================================================

@loop:
		swap	d1					; swap ring counter & loop counter
		lsr.b	#1,d4					; has this ring been collected previously?
		bcs.s	@skip_ring				; if yes, branch
		bclr	#7,(a2)
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found

@load_first:
		move.b	#id_Rings,ost_id(a1)			; load ring object
		addq.b	#2,ost_routine(a1)			; goto Ring_Animate next
		move.w	d2,ost_x_pos(a1)			; set x position based on d2
		move.w	ost_x_pos(a0),ost_ring_x_main(a1)
		move.w	d3,ost_y_pos(a1)			; set y position based on d3
		move.l	#Map_Ring,ost_mappings(a1)
		move.w	#tile_Nem_Ring+tile_pal2,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#2,ost_priority(a1)
		move.b	#id_col_6x6+id_col_item,ost_col_type(a1) ; goto Ring_Collect when touched
		move.b	#8,ost_displaywidth(a1)
		move.b	ost_respawn(a0),ost_respawn(a1)
		move.b	d1,ost_ring_num(a1)			; ring remembers which one in the current batch it is 

@skip_ring:
		addq.w	#1,d1					; increment ring counter
		add.w	d5,d2					; add x spacing value to d2
		add.w	d6,d3					; add y spacing value to d3
		swap	d1					; swap ring counter & loop counter
		dbf	d1,@loop				; repeat for number of rings

@fail:
		btst	#0,(a2)
		bne.w	DeleteObject

Ring_Animate:	; Routine 2
		move.b	(v_syncani_1_frame).w,ost_frame(a0)	; set synchronised frame
		bsr.w	DisplaySprite
		out_of_range.s	Ring_Delete,ost_ring_x_main(a0)
		rts	
; ===========================================================================

Ring_Collect:	; Routine 4
		addq.b	#2,ost_routine(a0)			; goto Ring_Sparkle next
		move.b	#0,ost_col_type(a0)
		move.b	#1,ost_priority(a0)
		bsr.w	CollectRing				; add ring/extra life, play sound
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		move.b	ost_ring_num(a0),d1			; which ring is collected
		bset	d1,2(a2,d0.w)				; set bit in respawn memory

Ring_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite				; animate and goto Ring_Delete when finished
		bra.w	DisplaySprite
; ===========================================================================

Ring_Delete:	; Routine 8
		bra.w	DeleteObject

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_Rings_animation:	macro

Ani_Ring:	index *
		ptr ani_ring_sparkle
		
ani_ring_sparkle:
		dc.b 5
		dc.b id_frame_ring_sparkle1
		dc.b id_frame_ring_sparkle2
		dc.b id_frame_ring_sparkle3
		dc.b id_frame_ring_sparkle4
		dc.b afRoutine
		even

		endm
