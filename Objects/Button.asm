; ---------------------------------------------------------------------------
; Object 32 - buttons (MZ, SYZ, LZ, SBZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3
;	ObjPos_SYZ1, ObjPos_SYZ3
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3
;	ObjPos_SBZ1, ObjPos_SBZ2, ObjPos_SBZ3
; ---------------------------------------------------------------------------

Button:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	But_Index(pc,d0.w),d1
		jmp	But_Index(pc,d1.w)
; ===========================================================================
But_Index:	index *,,2
		ptr But_Main
		ptr But_Action
; ===========================================================================

But_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto But_Action next
		move.l	#Map_But,ost_mappings(a0)
		move.w	#tile_Nem_MzButton+tile_pal3,ost_tile(a0) ; MZ specific code
		cmpi.b	#id_MZ,(v_zone).w			; is level Marble Zone?
		beq.s	@is_marble				; if yes, branch

		move.w	#tile_Nem_Button+4,ost_tile(a0)		; SYZ, LZ and SBZ specific code

	@is_marble:
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#4,ost_priority(a0)
		addq.w	#3,ost_y_pos(a0)

But_Action:	; Routine 2
		tst.b	ost_render(a0)				; is button on screen?
		bpl.s	But_Display				; if not, branch
		move.w	#$1B,d1					; width
		move.w	#5,d2					; height
		move.w	#5,d3					; height
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		bclr	#0,ost_frame(a0)			; use "unpressed" frame
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0					; get low nybble of subtype
		lea	(v_button_state).w,a3
		lea	(a3,d0.w),a3				; (a3) = button status
		moveq	#0,d3
		btst	#6,ost_subtype(a0)			; is subtype $4x or $Cx? (unused)
		beq.s	@not_secondary				; if not, branch
		moveq	#7,d3					; d3 = bit to set/clear in button status

	@not_secondary:
		tst.b	ost_subtype(a0)				; is subtype +$80?
		bpl.s	@subtype_0x				; if not, branch
		bsr.w	But_PBlock_Chk				; check collision with MZ pushable block
		bne.s	But_Press				; branch if found

	@subtype_0x:
		tst.b	ost_solid(a0)				; is Sonic standing on the button?
		bne.s	But_Press				; if yes, branch
		bclr	d3,(a3)					; clear button status
		bra.s	But_Flash
; ===========================================================================

But_Press:
		tst.b	(a3)					; is button already pressed?
		bne.s	@already_pressed			; if yes, branch
		play.w	1, jsr, sfx_Switch			; play "blip" sound

	@already_pressed:
		bset	d3,(a3)
		bset	#0,ost_frame(a0)			; use "pressed" frame

But_Flash:
		btst	#5,ost_subtype(a0)			; is subtype +$20?
		beq.s	But_Display				; if not, branch
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bpl.s	But_Display				; branch if time remains
		move.b	#7,ost_anim_time(a0)			; set timer to 7 frames
		bchg	#1,ost_frame(a0)			; use frame 2/3

But_Display:
		bsr.w	DisplaySprite
		out_of_range	But_Delete
		rts	
; ===========================================================================

But_Delete:
		bsr.w	DeleteObject
		rts	

; ---------------------------------------------------------------------------
; Subroutine to detect collision with MZ pushable green block

; output:
;	d0 = 0 if not found; 1 if found
; ---------------------------------------------------------------------------

But_PBlock_Chk:
		move.w	d3,-(sp)
		move.w	ost_x_pos(a0),d2
		move.w	ost_y_pos(a0),d3
		subi.w	#$10,d2					; d2 = x pos. of button left edge
		subq.w	#8,d3					; d3 = y pos. of button top edge
		move.w	#$20,d4					; d4 = x detection range
		move.w	#$10,d5					; d5 = y detection range
		lea	(v_ost_level_obj).w,a1			; begin checking object RAM
		move.w	#countof_ost_ert-1,d6

@loop:
		tst.b	ost_render(a1)				; is object on screen?
		bpl.s	@next					; if not, branch
		cmpi.b	#id_PushBlock,(a1)			; is the object a green MZ block?
		beq.s	@is_pblock				; if yes, branch

	@next:
		lea	sizeof_ost(a1),a1			; check next object
		dbf	d6,@loop				; repeat $5F times

		move.w	(sp)+,d3
		moveq	#0,d0
		rts	
; ===========================================================================
@xy_radius:	dc.b $10, $10					; x and y radius of pushable block
; ===========================================================================

@is_pblock:
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0					; d0 = 2
		lea	@xy_radius-2(pc,d0.w),a2
		move.b	(a2)+,d1
		ext.w	d1					; d1 = $10
		move.w	ost_x_pos(a1),d0			; d0 = x pos. of pblock
		sub.w	d1,d0
		sub.w	d2,d0					; d0 = pblock-button
		bcc.s	@pblock_right				; branch if pblock is right of button
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	@pblock_x_ok				; branch if pblock is within $20 pixels of button
		bra.s	@next
; ===========================================================================

@pblock_right:
		cmp.w	d4,d0					; are pblock and button within $20 pixels?
		bhi.s	@next					; if not, branch

@pblock_x_ok:
		move.b	(a2)+,d1
		ext.w	d1					; d1 = $10
		move.w	ost_y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	@pblock_above
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	@pblock_y_ok
		bra.s	@next
; ===========================================================================

@pblock_above:
		cmp.w	d5,d0
		bhi.s	@next

@pblock_y_ok:
		move.w	(sp)+,d3
		moveq	#1,d0
		rts
