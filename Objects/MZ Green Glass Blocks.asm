; ---------------------------------------------------------------------------
; Object 30 - large green glass blocks (MZ)
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

Glass_Vars1:	dc.b id_Glass_Block012,	0, id_frame_glass_tall	; routine num, y-axis dist from	origin,	frame num
		dc.b id_Glass_Reflect012, 0, id_frame_glass_shine
Glass_Vars2:	dc.b id_Glass_Block34, 0, id_frame_glass_short
		dc.b id_Glass_Reflect34, 0, id_frame_glass_shine

ost_glass_y_start:	equ $30	; original y position (2 bytes)
ost_glass_y_dist:	equ $32	; distance block moves when switch is pressed (2 bytes)
ost_glass_move_mode:	equ $34	; 1 when block moves after switch is pressed
ost_glass_sink_dist:	equ $36	; distance to make block sink when jumped on; unused type 3 block (2 bytes)
ost_glass_sink_delay:	equ $38	; time to delay block sinking
ost_glass_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

Glass_Main:	; Routine 0
		lea	(Glass_Vars1).l,a2
		moveq	#1,d1
		move.b	#$48,ost_height(a0)
		cmpi.b	#3,ost_subtype(a0) ; is object type 0/1/2 ?
		bcs.s	@IsType012	; if yes, branch

		lea	(Glass_Vars2).l,a2
		moveq	#1,d1
		move.b	#$38,ost_height(a0)

	@IsType012:
		movea.l	a0,a1
		bra.s	@Load		; load main object
; ===========================================================================

	@Repeat:
		bsr.w	FindNextFreeObj
		bne.s	@Fail

@Load:
		move.b	(a2)+,ost_routine(a1)
		move.b	#id_GlassBlock,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_y_pos(a0),d0
		move.w	d0,ost_y_pos(a1)
		move.l	#Map_Glass,ost_mappings(a1)
		move.w	#tile_Nem_MzGlass+tile_pal3+tile_hi,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.w	ost_y_pos(a1),ost_glass_y_start(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.b	#$20,ost_actwidth(a1)
		move.b	#4,ost_priority(a1)
		move.b	(a2)+,ost_frame(a1)
		move.l	a0,ost_glass_parent(a1)
		dbf	d1,@Repeat	; repeat once to load "reflection object"

		move.b	#$10,ost_actwidth(a1)
		move.b	#3,ost_priority(a1)
		addq.b	#8,ost_subtype(a1)
		andi.b	#$F,ost_subtype(a1)

	@Fail:
		move.w	#$90,ost_glass_y_dist(a0)
		bset	#render_useheight_bit,ost_render(a0)

Glass_Block012:	; Routine 2
		bsr.w	Glass_Types
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
		bra.w	Glass_Types
; ===========================================================================

Glass_Block34:	; Routine 6
		bsr.w	Glass_Types
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
		bra.w	Glass_Types

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		ptr Glass_Type00
		ptr Glass_Type01
		ptr Glass_Type02
		ptr Glass_Type03
		ptr Glass_Type04
; ===========================================================================

Glass_Type00:
		rts	
; ===========================================================================

Glass_Type01:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		bra.s	loc_B514
; ===========================================================================

Glass_Type02:
		move.b	(v_oscillate+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0

loc_B514:
		btst	#3,ost_subtype(a0)
		beq.s	loc_B526
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0
		addi.w	#$20,d0

loc_B526:
		bra.w	loc_B5EE
; ===========================================================================

Glass_Type03:
		btst	#3,ost_subtype(a0)
		beq.s	loc_B53E
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_B5EE
; ===========================================================================

loc_B53E:
		btst	#status_platform_bit,ost_status(a0) ; is Sonic on the block?
		bne.s	loc_B54E	; if yes, branch
		bclr	#0,ost_glass_move_mode(a0)
		bra.s	loc_B582
; ===========================================================================

loc_B54E:
		tst.b	ost_glass_move_mode(a0)
		bne.s	loc_B582
		move.b	#1,ost_glass_move_mode(a0)
		bset	#0,$35(a0)
		beq.s	loc_B582
		bset	#7,ost_glass_move_mode(a0)
		move.w	#$10,ost_glass_sink_dist(a0) ; sink $10 pixels after it's jumped on
		move.b	#$A,ost_glass_sink_delay(a0)
		cmpi.w	#$40,ost_glass_y_dist(a0) ; is block within $40 of its final position?
		bne.s	loc_B582	; if not, branch
		move.w	#$40,ost_glass_sink_dist(a0) ; sink rest of the way

loc_B582:
		tst.b	ost_glass_move_mode(a0)
		bpl.s	loc_B5AA
		tst.b	ost_glass_sink_delay(a0)
		beq.s	loc_B594
		subq.b	#1,ost_glass_sink_delay(a0)
		bne.s	loc_B5AA

loc_B594:
		tst.w	ost_glass_y_dist(a0)
		beq.s	loc_B5A4
		subq.w	#1,ost_glass_y_dist(a0)
		subq.w	#1,ost_glass_sink_dist(a0)
		bne.s	loc_B5AA

loc_B5A4:
		bclr	#7,ost_glass_move_mode(a0)

loc_B5AA:
		move.w	ost_glass_y_dist(a0),d0
		bra.s	loc_B5EE
; ===========================================================================

Glass_Type04:
		btst	#3,ost_subtype(a0)
		beq.s	Glass_ChkSwitch
		move.b	(v_oscillate+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_B5EE
; ===========================================================================

Glass_ChkSwitch:
		tst.b	ost_glass_move_mode(a0)
		bne.s	loc_B5E0
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; load object type number
		lsr.w	#4,d0		; read only the	first nybble
		tst.b	(a2,d0.w)	; has switch number d0 been pressed?
		beq.s	loc_B5EA	; if not, branch
		move.b	#1,ost_glass_move_mode(a0)

loc_B5E0:
		tst.w	ost_glass_y_dist(a0)
		beq.s	loc_B5EA
		subq.w	#2,ost_glass_y_dist(a0)

loc_B5EA:
		move.w	ost_glass_y_dist(a0),d0

loc_B5EE:
		move.w	ost_glass_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
