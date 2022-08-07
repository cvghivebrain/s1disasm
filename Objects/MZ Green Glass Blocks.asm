; ---------------------------------------------------------------------------
; Object 30 - large green glass blocks (MZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 1/2/4/$14
;	GlassBlock - subtype inherited from parent, +8
; ---------------------------------------------------------------------------

GlassBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Glass_Index(pc,d0.w),d1
		jsr	Glass_Index(pc,d1.w)
		out_of_range	Glass_Delete
		bra.w	DisplaySprite
; ===========================================================================

Glass_Delete:
		bra.w	DeleteObject
; ===========================================================================
Glass_Index:	index *,,2
		ptr Glass_Main
		ptr Glass_Block012
		ptr Glass_Reflect012
		ptr Glass_Block34
		ptr Glass_Reflect34

Glass_Vars012:	dc.b id_Glass_Block012,	0, id_frame_glass_tall	; routine num, y-axis dist from	origin,	frame num
		dc.b id_Glass_Reflect012, 0, id_frame_glass_shine
Glass_Vars34:	dc.b id_Glass_Block34, 0, id_frame_glass_short
		dc.b id_Glass_Reflect34, 0, id_frame_glass_shine

		rsobj GlassBlock,$30
ost_glass_y_start:	rs.w 1					; $30 ; original y position
ost_glass_y_dist:	rs.w 1					; $32 ; distance block moves when switch is pressed
ost_glass_move_mode:	rs.b 1					; $34 ; 1 when block moves after switch is pressed
ost_glass_jump_init:	rs.b 1					; $35 ; 1 when block has been jumped on at least once
ost_glass_sink_dist:	rs.w 1					; $36 ; distance to make block sink when jumped on; unused type 3 block
ost_glass_sink_delay:	rs.b 1					; $38 ; time to delay block sinking
		rsset $3C
ost_glass_parent:	rs.l 1					; $3C ; address of OST of parent object
		rsobjend
; ===========================================================================

Glass_Main:	; Routine 0
		lea	(Glass_Vars012).l,a2
		moveq	#1,d1
		move.b	#$48,ost_height(a0)
		cmpi.b	#3,ost_subtype(a0)			; is object type 0/1/2 ?
		bcs.s	.type012				; if yes, branch

		lea	(Glass_Vars34).l,a2
		moveq	#1,d1
		move.b	#$38,ost_height(a0)

	.type012:
		movea.l	a0,a1
		bra.s	.load					; load main object
; ===========================================================================

	.repeat:
		bsr.w	FindNextFreeObj
		bne.s	.fail

.load:
		move.b	(a2)+,ost_routine(a1)			; goto Glass_Block012/Glass_Reflect012/Glass_Block34/Glass_Reflect34 next
		move.b	#id_GlassBlock,ost_id(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.b	(a2)+,d0				; get relative y position (it's always 0)
		ext.w	d0
		add.w	ost_y_pos(a0),d0
		move.w	d0,ost_y_pos(a1)
		move.l	#Map_Glass,ost_mappings(a1)
		move.w	#tile_Nem_MzGlass+tile_pal3+tile_hi,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.w	ost_y_pos(a1),ost_glass_y_start(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#$20,ost_displaywidth(a1)
		move.b	#4,ost_priority(a1)
		move.b	(a2)+,ost_frame(a1)			; get frame
		move.l	a0,ost_glass_parent(a1)			; save address of OST of parent object
		dbf	d1,.repeat				; repeat once to load "reflection object"

		move.b	#$10,ost_displaywidth(a1)
		move.b	#3,ost_priority(a1)
		addq.b	#8,ost_subtype(a1)			; +8 to reflection object subtype
		andi.b	#$F,ost_subtype(a1)			; clear high nybble of subtype

	.fail:
		move.w	#$90,ost_glass_y_dist(a0)
		bset	#render_useheight_bit,ost_render(a0)

Glass_Block012:	; Routine 2
		bsr.w	Glass_Types				; update position
		move.w	#$2B,d1
		move.w	#$48,d2
		move.w	#$49,d3
		move.w	ost_x_pos(a0),d4
		bra.w	SolidObject
; ===========================================================================

Glass_Reflect012:
		; Routine 4
		movea.l	ost_glass_parent(a0),a1
		move.w	ost_glass_y_dist(a1),ost_glass_y_dist(a0)
		bra.w	Glass_Types				; update position
; ===========================================================================

Glass_Block34:	; Routine 6
		bsr.w	Glass_Types				; update position
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$39,d3
		move.w	ost_x_pos(a0),d4
		bra.w	SolidObject
; ===========================================================================

Glass_Reflect34:
		; Routine 8
		movea.l	ost_glass_parent(a0),a1
		move.w	ost_glass_y_dist(a1),ost_glass_y_dist(a0)
		move.w	ost_y_pos(a1),ost_glass_y_start(a0)
		bra.w	Glass_Types				; update position

; ---------------------------------------------------------------------------
; Subroutine to update block position
; ---------------------------------------------------------------------------

Glass_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Glass_TypeIndex(pc,d0.w),d1
		jmp	Glass_TypeIndex(pc,d1.w)
; End of function Glass_Types

; ===========================================================================
Glass_TypeIndex:index *
		ptr Glass_Still					; 0 - doesn't move
		ptr Glass_UpDown				; 1 - moves up and down
		ptr Glass_UpDown_Rev				; 2 - moves up and down, reversed
		ptr Glass_Drop_Jump				; 3 - drops each time it's jumped on
		ptr Glass_Drop_Button				; 4 - drops when button is pressed
; ===========================================================================

; Type 0 - doesn't move
Glass_Still:
		rts	
; ===========================================================================

; Type 1 - moves up and down
Glass_UpDown:
		move.b	(v_oscillating_0_to_40_fast).w,d0
		move.w	#$40,d1
		bra.s	Glass_UpDown_Reflect
; ===========================================================================

; Type 2 - moves up and down, reversed
Glass_UpDown_Rev:
		move.b	(v_oscillating_0_to_40_fast).w,d0
		move.w	#$40,d1
		neg.w	d0					; reverse direction of movement
		add.w	d1,d0

Glass_UpDown_Reflect:
		btst	#3,ost_subtype(a0)			; is object a reflection?
		beq.s	.not_reflection				; if not, branch
		neg.w	d0					; reverse for reflection
		add.w	d1,d0
		lsr.b	#1,d0					; divide by 2
		addi.w	#$20,d0					; move down 32px

	.not_reflection:
		bra.w	Glass_Move
; ===========================================================================

; Type 3 - drops each time it's jumped on
Glass_Drop_Jump:
		btst	#3,ost_subtype(a0)			; is object a reflection?
		beq.s	.not_reflection				; if not, branch
		move.b	(v_oscillating_0_to_40_fast).w,d0
		subi.w	#$10,d0
		bra.w	Glass_Move

	.not_reflection:
		btst	#status_platform_bit,ost_status(a0)	; is Sonic on the block?
		bne.s	.chk_move				; if yes, branch
		bclr	#0,ost_glass_move_mode(a0)
		bra.s	.skip_move
; ===========================================================================

.chk_move:
		tst.b	ost_glass_move_mode(a0)			; is block already moving?
		bne.s	.skip_move				; if yes, branch
		move.b	#1,ost_glass_move_mode(a0)		; set moving flag
		bset	#0,ost_glass_jump_init(a0)		; set first jump flag
		beq.s	.skip_move				; branch if previously 0 (i.e. not jumped on before)
		bset	#7,ost_glass_move_mode(a0)		; +$80 to moving flag
		move.w	#$10,ost_glass_sink_dist(a0)		; sink $10 pixels after it's jumped on
		move.b	#$A,ost_glass_sink_delay(a0)
		cmpi.w	#$40,ost_glass_y_dist(a0)		; is block within $40 of its final position?
		bne.s	.skip_move				; if not, branch
		move.w	#$40,ost_glass_sink_dist(a0)		; sink rest of the way

.skip_move:
		tst.b	ost_glass_move_mode(a0)
		bpl.s	.update_pos
		tst.b	ost_glass_sink_delay(a0)
		beq.s	.wait					; branch if time remains on delay timer
		subq.b	#1,ost_glass_sink_delay(a0)		; decrement timer
		bne.s	.update_pos

	.wait:
		tst.w	ost_glass_y_dist(a0)
		beq.s	.no_dist
		subq.w	#1,ost_glass_y_dist(a0)
		subq.w	#1,ost_glass_sink_dist(a0)
		bne.s	.update_pos

	.no_dist:
		bclr	#7,ost_glass_move_mode(a0)

	.update_pos:
		move.w	ost_glass_y_dist(a0),d0
		bra.s	Glass_Move
; ===========================================================================

; Type 4 - drops when button is pressed
Glass_Drop_Button:
		btst	#3,ost_subtype(a0)			; is object a reflection?
		beq.s	Glass_ChkBtn				; if not, branch
		move.b	(v_oscillating_0_to_40_fast).w,d0
		subi.w	#$10,d0
		bra.s	Glass_Move
; ===========================================================================

Glass_ChkBtn:
		tst.b	ost_glass_move_mode(a0)			; is block already moving?
		bne.s	.skip_button				; if yes, branch
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; load object type number
		lsr.w	#4,d0					; read only the	high nybble
		tst.b	(a2,d0.w)				; has button number d0 been pressed?
		beq.s	.no_dist				; if not, branch
		move.b	#1,ost_glass_move_mode(a0)		; set moving flag

	.skip_button:
		tst.w	ost_glass_y_dist(a0)			; does block still have distance to move?
		beq.s	.no_dist				; if not, branch
		subq.w	#2,ost_glass_y_dist(a0)			; decrement distance

	.no_dist:
		move.w	ost_glass_y_dist(a0),d0

Glass_Move:
		move.w	ost_glass_y_start(a0),d1		; get initial y position
		sub.w	d0,d1					; apply difference
		move.w	d1,ost_y_pos(a0)			; update y position
		rts	
