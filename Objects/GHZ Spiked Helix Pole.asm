; ---------------------------------------------------------------------------
; Object 17 - helix of spikes on a pole	(GHZ)

; spawned by:
;	ObjPos_GHZ3 - subtype $10
; ---------------------------------------------------------------------------

Helix:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Hel_Index(pc,d0.w),d1
		jmp	Hel_Index(pc,d1.w)
; ===========================================================================
Hel_Index:	index *,,2
		ptr Hel_Main
		ptr Hel_Action
		ptr Hel_Action
		ptr Hel_Delete
		ptr Hel_Display

ost_helix_frame:	equ $3E					; start frame (different for each spike)
ost_helix_child_list:	equ ost_subtype+1			; $29 ; list of child OST indices (up to 21 bytes)
; ===========================================================================

Hel_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Hel_Action next
		move.l	#Map_Hel,ost_mappings(a0)
		move.w	#tile_Nem_SpikePole+tile_pal3,ost_tile(a0)
		move.b	#status_xflip+status_yflip+status_jump,ost_status(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_displaywidth(a0)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		move.b	ost_id(a0),d4
		lea	ost_subtype(a0),a2			; (a2) = subtype, followed by child list
		moveq	#0,d1
		move.b	(a2),d1					; move helix length to d1
		move.b	#0,(a2)+				; clear subtype
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3					; d3 is x-axis position of leftmost spike
		subq.b	#2,d1					; d1 = number of spikes, minus 1 for parent, minus 1 for first loop
		bcs.s	Hel_Action				; skip to action if length is only 1
		moveq	#0,d6

@loop:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	Hel_Action				; branch if not found
		addq.b	#1,ost_subtype(a0)			; keep track of number of child objects
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+				; copy child OST index to byte list in parent OST
		move.b	#id_Hel_Display,ost_routine(a1)
		move.b	d4,ost_id(a1)
		move.w	d2,ost_y_pos(a1)
		move.w	d3,ost_x_pos(a1)
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	#tile_Nem_SpikePole+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#8,ost_displaywidth(a1)
		move.b	d6,ost_helix_frame(a1)			; set frame for current spike
		addq.b	#1,d6					; use next frame on next spike
		andi.b	#7,d6					; there are only 8 frames
		addi.w	#$10,d3					; x position of next spike
		cmp.w	ost_x_pos(a0),d3			; is this spike in the centre?
		bne.s	@not_centre				; if not, branch

		move.b	d6,ost_helix_frame(a0)			; set parent spike frame
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3					; skip to next spike
		addq.b	#1,ost_subtype(a0)

	@not_centre:
		dbf	d1,@loop				; repeat d1 times (helix length)

Hel_Action:	; Routine 2, 4
		bsr.w	Hel_RotateSpikes
		bsr.w	DisplaySprite
		bra.w	Hel_ChkDel

; ---------------------------------------------------------------------------
; Subroutine to animate the spikes and set their harmfulness
; ---------------------------------------------------------------------------

Hel_RotateSpikes:
		move.b	(v_syncani_0_frame).w,d0		; get synchronised frame value
		move.b	#0,ost_col_type(a0)			; make object harmless
		add.b	ost_helix_frame(a0),d0			; add initial frame
		andi.b	#7,d0					; there are 8 frames max
		move.b	d0,ost_frame(a0)			; change current frame
		bne.s	@harmless				; branch if not 0
		move.b	#id_col_4x16+id_col_hurt,ost_col_type(a0) ; make object harmful

	@harmless:
		rts	
; End of function Hel_RotateSpikes

; ===========================================================================

Hel_ChkDel:
		out_of_range	Hel_DelAll
		rts	
; ===========================================================================

Hel_DelAll:
		moveq	#0,d2
		lea	ost_subtype(a0),a2
		move.b	(a2)+,d2				; d2 = helix length
		subq.b	#2,d2					; minus 1 for parent, minus 1 for first loop
		bcs.s	Hel_Delete

	@loop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1					; get child address
		bsr.w	DeleteChild				; delete object
		dbf	d2,@loop				; repeat d2 times (helix length)

Hel_Delete:	; Routine 6
		bsr.w	DeleteObject
		rts	
; ===========================================================================

Hel_Display:	; Routine 8
		bsr.w	Hel_RotateSpikes
		bra.w	DisplaySprite
