; ---------------------------------------------------------------------------
; Object 5B - blocks that form a staircase (SLZ)

; spawned by:
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes 0/2
;	Staircase
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
ost_stair_y_diff_list:	equ $38					; distance moved by each child object (4 bytes)
ost_stair_parent:	equ $3C					; address of OST of parent object (4 bytes)
; ===========================================================================

Stair_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Stair_Move next
		moveq	#ost_stair_y_diff_list,d3		; id of first stair
		moveq	#1,d4					; value to add to iterate through stairs
		btst	#status_xflip_bit,ost_status(a0)	; is object flipped?
		beq.s	@notflipped				; if not, branch
		moveq	#ost_stair_y_diff_list+3,d3		; start from final stair
		moveq	#-1,d4					; iterate backwards

	@notflipped:
		move.w	ost_x_pos(a0),d2
		movea.l	a0,a1					; replace current object with first stair
		moveq	#3,d1					; 3 additional stairs
		bra.s	@makeblocks
; ===========================================================================

	@loop:
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.w	@fail					; branch if not found
		move.b	#4,ost_routine(a1)			; goto Stair_Solid next

@makeblocks:
		move.b	#id_Staircase,ost_id(a1)		; load another stair object
		move.l	#Map_Stair,ost_mappings(a1)
		move.w	#0+tile_pal3,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#$10,ost_displaywidth(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.w	d2,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_x_pos(a0),ost_stair_x_start(a1)
		move.w	ost_y_pos(a1),ost_stair_y_start(a1)
		addi.w	#$20,d2					; next stair is 32px to the right of previous
		move.b	d3,ost_stair_child_id(a1)		; values $38-$3B (or $3B-$38 if flipped)
		move.l	a0,ost_stair_parent(a1)
		add.b	d4,d3					; next child id
		dbf	d1,@loop				; repeat sequence 3 times

	@fail:

Stair_Move:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype
		andi.w	#7,d0					; read only bits 0-2
		add.w	d0,d0
		move.w	Stair_TypeIndex(pc,d0.w),d1
		jsr	Stair_TypeIndex(pc,d1.w)

Stair_Solid:	; Routine 4
		movea.l	ost_stair_parent(a0),a2			; get address of OST of parent object
		moveq	#0,d0
		move.b	ost_stair_child_id(a0),d0		; get current stair id ($38-$3B)
		move.b	(a2,d0.w),d0				; get y distance moved for current stair
		add.w	ost_stair_y_start(a0),d0		; add to initial y position
		move.w	d0,ost_y_pos(a0)			; update position
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject				; detect collision
		tst.b	d4					; has Sonic touched top/bottom of stair?
		bpl.s	@not_topbottom				; if not, branch
		move.b	d4,ost_stair_flag(a2)			; set collision flag

	@not_topbottom:
		btst	#status_platform_bit,ost_status(a0)	; is Sonic standing on the stair?
		beq.s	@exit					; if not, branch
		move.b	#1,ost_stair_flag(a2)			; set collision flag

	@exit:
		rts	
; ===========================================================================
Stair_TypeIndex:index *
		ptr Stair_Type00				; form staircase when stood on
		ptr Stair_Type01
		ptr Stair_Type02				; form staircase when hit from below
		ptr Stair_Type01
; ===========================================================================

Stair_Type00:
		tst.w	ost_stair_wait_time(a0)			; is timer above 0?
		bne.s	@dec_timer				; if yes, branch
		cmpi.b	#1,ost_stair_flag(a0)			; has Sonic stood on the stairs?
		bne.s	@exit					; if not, branch
		move.w	#30,ost_stair_wait_time(a0)		; set time delay to half a second

	@exit:
		rts	
; ===========================================================================

@dec_timer:
		subq.w	#1,ost_stair_wait_time(a0)		; decrement timer
		bne.s	@exit					; branch if time remains
		addq.b	#1,ost_subtype(a0)			; add 1 to type
		rts	
; ===========================================================================

Stair_Type02:
		tst.w	ost_stair_wait_time(a0)			; is timer above 0?
		bne.s	@dec_timer				; if yes, branch
		tst.b	ost_stair_flag(a0)			; have stairs been hit from below?
		bpl.s	@exit					; if not, branch
		move.w	#60,ost_stair_wait_time(a0)		; set time delay to 1 second

	@exit:
		rts	
; ===========================================================================

@dec_timer:
		subq.w	#1,ost_stair_wait_time(a0)		; decrement timer
		bne.s	@jiggle					; branch if time remains
		addq.b	#1,ost_subtype(a0)			; add 1 to type
		rts	
; ===========================================================================

@jiggle:
		lea	ost_stair_y_diff_list(a0),a1		; address of list of distance moved for each stair
		move.w	ost_stair_wait_time(a0),d0		; get value from timer
		lsr.b	#2,d0
		andi.b	#1,d0					; d0 = bit 2 from timer (changes every 8 frames)
		move.b	d0,(a1)+				; set y distance as 0 or 1
		eori.b	#1,d0					; switch between 0 and 1 for each stair
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts	
; ===========================================================================

Stair_Type01:
		lea	ost_stair_y_diff_list(a0),a1		; address of list of distance moved for each stair
		cmpi.b	#$80,(a1)				; has first stair moved 128px?
		beq.s	@exit					; if yes, branch
		addq.b	#1,(a1)					; move first stair down 1px
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
		move.b	d3,(a1)+				; move other 3 stairs down smaller amounts
		move.b	d2,(a1)+
		move.b	d1,(a1)+

	@exit:
		rts	
		rts	
