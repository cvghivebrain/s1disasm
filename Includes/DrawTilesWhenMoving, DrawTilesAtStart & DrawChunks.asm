; ---------------------------------------------------------------------------
; Subroutine to	draw 16x16 tiles at the edge of the screen as the camera moves

; output:
;	a5 = vdp_control_port ($C00004)
;	a6 = vdp_data_port ($C00000)
;	uses d0, d1, d2, d3, d4, d5, d6, d7, a1, a2, a3, a4
; ---------------------------------------------------------------------------

; Background only - used by title screen
DrawTilesWhenMoving_BGOnly:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_redraw_direction).w,a2
		lea	(v_bg1_x_pos).w,a3
		lea	(v_level_layout+level_max_width).w,a4	; first row of bg layout (fg/bg are stored in alternating rows)
		move.w	#draw_bg,d2				; value added to base VRAM address to get bg nametable
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_redraw_direction).w,a2
		lea	(v_bg2_x_pos).w,a3
		bra.w	DrawBGScrollBlock2

; Foreground and background - used by levels
DrawTilesWhenMoving:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6

		; Background
		lea	(v_bg1_redraw_direction_copy).w,a2
		lea	(v_bg1_x_pos_copy).w,a3
		lea	(v_level_layout+level_max_width).w,a4	; first row of bg layout
		move.w	#draw_bg,d2				; value added to base VRAM address to get bg nametable
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_redraw_direction_copy).w,a2
		lea	(v_bg2_x_pos_copy).w,a3
		bsr.w	DrawBGScrollBlock2
		if Revision=0
		else
		; REV01 added a third scroll block
			lea	(v_bg3_redraw_direction_copy).w,a2
			lea	(v_bg3_x_pos_copy).w,a3
			bsr.w	DrawBGScrollBlock3
		endc
		; Foreground
		lea	(v_fg_redraw_direction_copy).w,a2
		lea	(v_camera_x_pos_copy).w,a3
		lea	(v_level_layout).w,a4
		move.w	#draw_fg,d2				; value added to base VRAM address to get fg nametable
		tst.b	(a2)					; are any redraw flags set?
		beq.s	.exit					; if not, branch
		bclr	#redraw_top_bit,(a2)			; clear flag for redraw top
		beq.s	.chk_bottom				; branch if already clear

		; Draw new tiles at the top
		moveq	#-16,d4					; y coordinate - 16px (size of block) above top
		moveq	#-16,d5					; x coordinate - 16px outside left edge
		bsr.w	Calc_VRAM_Pos				; d0 = VDP command for fg nametable
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawRow

	.chk_bottom:
		bclr	#redraw_bottom_bit,(a2)			; clear flag for redraw bottom
		beq.s	.chk_left				; branch if already clear

		; Draw new tiles at the bottom
		move.w	#224,d4					; y coordinate - bottom of screen
		moveq	#-16,d5					; x coordinate - 16px outside left edge
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawRow

	.chk_left:
		bclr	#redraw_left_bit,(a2)			; clear flag for redraw left
		beq.s	.chk_right				; branch if already clear

		; Draw new tiles on the left
		moveq	#-16,d4					; y coordinate - 16px (size of block) above top
		moveq	#-16,d5					; x coordinate - 16px outside left edge
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawColumn

	.chk_right:
		bclr	#redraw_right_bit,(a2)			; clear flag for redraw right
		beq.s	.exit					; branch if already clear

		; Draw new tiles on the right
		moveq	#-16,d4					; y coordinate - 16px (size of block) above top
		move.w	#320,d5					; x coordinate - right edge of screen
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawColumn

.exit:
		rts

; ---------------------------------------------------------------------------
; Subroutines to draw 16x16 tiles on the background in sections

; input:
;	d2 = value added to base VRAM address to get bg nametable
;	(a2) = redraw direction flags
;	(a3) = bg x position
;	4(a3) = bg y position
;	a4 = address of bg layout
;	a5 = vdp_control_port
;	a6 = vdp_data_port

;	uses d0, d1, d3, d4, d5, d6, d7, a1, a2, a4
; ---------------------------------------------------------------------------

DrawBGScrollBlock1:
		tst.b	(a2)					; are any redraw flags set?
		beq.w	.exit					; if not, branch
		bclr	#redraw_top_bit,(a2)			; clear flag for redraw top
		beq.s	.chk_bottom				; branch if already clear

		; Draw new tiles at the top
		moveq	#-16,d4					; y coordinate - 16px (size of block) above top
		moveq	#-16,d5					; x coordinate - 16px outside left edge
		bsr.w	Calc_VRAM_Pos				; d0 = VDP command for fg nametable
		moveq	#-16,d4
		moveq	#-16,d5
		if Revision=0
			moveq	#(512/16)-1,d6			; draw entire row of plane
			bsr.w	DrawRow_Partial
		else
			bsr.w	DrawRow
		endc

	.chk_bottom:
		bclr	#redraw_bottom_bit,(a2)			; clear flag for redraw bottom
		beq.s	.chk_left				; branch if already clear

		; Draw new tiles at the bottom
		move.w	#224,d4					; y coordinate - bottom of screen
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		if Revision=0
			moveq	#(512/16)-1,d6
			bsr.w	DrawRow_Partial
		else
			bsr.w	DrawRow
		endc

	.chk_left:
		bclr	#redraw_left_bit,(a2)			; clear flag for redraw left
		beq.s	.chk_right				; branch if already clear

		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5

		if Revision=0
			move.w	(v_scroll_block_1_height).w,d6	; get bg block 1 height (GHZ = $70; others = $800)
			move.w	4(a3),d1			; get bg y position
			andi.w	#$FFF0,d1			; round down to nearest 16
			sub.w	d1,d6
			blt.s	.chk_right			; if bg block 1 is offscreen, skip loading its tiles
			lsr.w	#4,d6				; d6 = number of rows not above the screen
			cmpi.w	#((224+16+16)/16)-1,d6		; compare with height of screen + 16px either side
			blo.s	.bg_covers_partial		; branch if less
			moveq	#((224+16+16)/16)-1,d6		; limit to height of screen + 16px either side
	.bg_covers_partial:
			bsr.w	DrawColumn_Partial
		else
			bsr.w	DrawColumn
		endc

	.chk_right:
		bclr	#redraw_right_bit,(a2)			; clear flag for redraw right
		if Revision=0
			beq.s	.exit				; branch if already clear
		else
			beq.s	.chk_topall			; branch if already clear
		endc
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5					; x coordinate - right edge of screen
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5

		if Revision=0
			move.w	(v_scroll_block_1_height).w,d6
			move.w	4(a3),d1			; get bg y position
			andi.w	#$FFF0,d1			; round down to nearest 16
			sub.w	d1,d6
			blt.s	.exit
			lsr.w	#4,d6
			cmpi.w	#((224+16+16)/16)-1,d6
			blo.s	.bg_covers_partial2
			moveq	#((224+16+16)/16)-1,d6
	.bg_covers_partial2:
			bsr.w	DrawColumn_Partial
		else
			bsr.w	DrawColumn

	.chk_topall:
			bclr	#redraw_topall_bit,(a2)
			beq.s	.chk_bottomall
		; Draw entire row at the top
			moveq	#-16,d4				; y coordinate - 16px (size of block) above top
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_IgnoreX
			moveq	#-16,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawRow_IgnoreX
	.chk_bottomall:
			bclr	#redraw_bottomall_bit,(a2)
			beq.s	.exit
		; Draw entire row at the bottom
			move.w	#224,d4				; y coordinate - bottom of screen
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_IgnoreX
			move.w	#224,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawRow_IgnoreX
		endc

.exit:
		rts
; ===========================================================================

; Essentially, this draws everything that isn't scroll block 1
DrawBGScrollBlock2:
		tst.b	(a2)					; are any redraw flags set?
		beq.w	.exit					; if not, branch
		if Revision=0
			bclr	#redraw_left_bit,(a2)		; clear flag for redraw left
			beq.s	.chk_right			; branch if already clear
		; Draw new tiles on the left
			cmpi.w	#16,(a3)			; is bg block 2 within 16px of left edge?
			blo.s	.chk_right			; if yes, branch

			move.w	(v_scroll_block_1_height).w,d4	; get bg block 1 height (GHZ = $70; others = $800)
			move.w	4(a3),d1			; get bg y position
			andi.w	#$FFF0,d1			; round down to nearest 16
			sub.w	d1,d4				; d4 = height of screen that isn't bg block 1
			move.w	d4,-(sp)			; save to stack
			moveq	#-16,d5				; x coordinate
			bsr.w	Calc_VRAM_Pos			; d0 = VDP command for bg nametable
			move.w	(sp)+,d4			; retrieve y coordinate from stack
			moveq	#-16,d5
			move.w	(v_scroll_block_1_height).w,d6
			move.w	4(a3),d1
			andi.w	#$FFF0,d1
			sub.w	d1,d6				; d6 = height of screen that isn't bg block 1
			blt.s	.chk_right			; branch if bg block 1 is completely off screen
			lsr.w	#4,d6				; divide by 16
			subi.w	#((224+16)/16)-1,d6		; d6 = rows for bg block 2, minus rows for whole screen
			bhs.s	.chk_right
			neg.w	d6
			bsr.w	DrawColumn_Partial
	.chk_right:
			bclr	#redraw_right_bit,(a2)		; clear flag for redraw right
			beq.s	.exit				; branch if already clear
		; Draw new tiles on the right
			move.w	(v_scroll_block_1_height).w,d4
			move.w	4(a3),d1
			andi.w	#$FFF0,d1
			sub.w	d1,d4
			move.w	d4,-(sp)
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	(sp)+,d4
			move.w	#320,d5
			move.w	(v_scroll_block_1_height).w,d6
			move.w	4(a3),d1
			andi.w	#$FFF0,d1
			sub.w	d1,d6
			blt.s	.exit
			lsr.w	#4,d6
			subi.w	#((224+16)/16)-1,d6
			bhs.s	.exit
			neg.w	d6
			bsr.w	DrawColumn_Partial
		else
			cmpi.b	#id_SBZ,(v_zone).w		; is current zone SBZ?
			beq.w	DrawBGScrollBlock2_SBZ		; if yes, branch
			bclr	#redraw_bg2_left_bit,(a2)	; clear flag for redraw left (REV01 uses bit 0 for redraw left flag)
			beq.s	.chk_right			; branch if already clear
		; Draw new tiles on the left
			move.w	#224/2,d4			; draw the bottom half of the screen
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			moveq	#-16,d5
			moveq	#3-1,d6				; draw three 16x16 tiles... could this be a repurposed version of the unused code?
			bsr.w	DrawColumn_Partial
	.chk_right:
			bclr	#redraw_bg2_right_bit,(a2)	; clear flag for redraw right (REV01 uses bit 0 for redraw right flag)
			beq.s	.exit				; branch if already clear
		; Draw new tiles on the right
			move.w	#224/2,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawColumn_Partial
		endc
.exit:
		rts
; ===========================================================================

; Abandoned unused scroll block code.
; This would have drawn a scroll block that started at 208 pixels down, and was 48 pixels long.

DrawBGScrollBlock2_Unused:
		if Revision=0
			tst.b	(a2)
			beq.s	.exit
			bclr	#redraw_left_bit,(a2)
			beq.s	.chk_right
		; Draw new tiles on the left
			move.w	#224-16,d4			; Note that full screen coverage is normally 224+16+16. This is exactly three blocks less.
			move.w	4(a3),d1
			andi.w	#$FFF0,d1
			sub.w	d1,d4
			move.w	d4,-(sp)
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos_Unknown
			move.w	(sp)+,d4
			moveq	#-16,d5
			moveq	#3-1,d6				; Draw only three rows
			bsr.w	DrawColumn_Partial

	.chk_right:
			bclr	#redraw_right_bit,(a2)
			beq.s	.exit
		; Draw new tiles on the right
			move.w	#224-16,d4
			move.w	4(a3),d1
			andi.w	#$FFF0,d1
			sub.w	d1,d4
			move.w	d4,-(sp)
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos_Unknown
			move.w	(sp)+,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawColumn_Partial

	.exit:
			rts
		endc
;===============================================================================
		
		if Revision=0
		else
	locj_6DF4:
			dc.b $00,$00,$00,$00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04
			dc.b $04,$04,$04,$04,$04,$04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00						
;===============================================================================
DrawBGScrollBlock2_SBZ:
			moveq	#-16,d4				; draw 16px above top of screen
			bclr	#redraw_top_bit,(a2)		; clear flag for redraw top
			bne.s	.top_bottom			; branch if it was set
			bclr	#redraw_bottom_bit,(a2)		; clear flag for redraw bottom
			beq.s	.chk_other			; branch if already clear
			move.w	#224,d4				; draw at bottom of screen
	.top_bottom:
			lea	(locj_6DF4+1).l,a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0				; d0 = v_bg1_y_pos -16 or +224
			andi.w	#$1F0,d0			; round down to nearest 16
			lsr.w	#4,d0				; divide by 16
			move.b	(a0,d0.w),d0
			lea	(DrawBG_XPosCopy_Ptrs).l,a3	; dc.w v_bg1_x_pos_copy, v_bg1_x_pos_copy, v_bg2_x_pos_copy, v_bg3_x_pos_copy
			movea.w	(a3,d0.w),a3			; get pointer to bg block 1/2/3 x pos
			beq.s	.bg_x_pos_0			; branch if 0
			moveq	#-16,d5				; x coordinate
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos			; d0 = VDP command for bg nametable
			popr	d4/d5
			bsr.w	DrawRow				; draw full row on top or bottom of screen
			bra.s	.chk_other
;===============================================================================
	.bg_x_pos_0:
			moveq	#0,d5
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos_IgnoreX
			popr	d4/d5
			moveq	#(512/16)-1,d6			; draw entire row
			bsr.w	DrawRow_IgnoreX
	.chk_other:
			tst.b	(a2)				; are any redraw flags set?
			bne.s	.more				; if yes, branch
			rts
;===============================================================================			
	.more:
			moveq	#-16,d4				; y coordinate - top of screen
			moveq	#-16,d5				; x coordinate - left of screen
			move.b	(a2),d0				; get remaining redraw flag bits
			andi.b	#$A8,d0				; read bits 7, 5 and 3 only
			beq.s	locj_6E8C			; if none are set, branch
			lsr.b	#1,d0				; shift into bits 6, 4 and 2 respectively
			move.b	d0,(a2)
			move.w	#320,d5				; x coordinate - right of screen
	locj_6E8C:
			lea	(locj_6DF4).l,a0
			move.w	(v_bg1_y_pos).w,d0
			andi.w	#$1F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC
			
		endc
;===============================================================================

DrawBGScrollBlock3:
		if Revision=0
		else
			tst.b	(a2)				; are any redraw flags set?
			beq.w	.exit				; if not, branch
			cmpi.b	#id_MZ,(v_zone).w		; is current zone MZ?
			beq.w	DrawBGScrollBlock3_MZ		; if yes, branch

			bclr	#redraw_bg2_left_bit,(a2)	; clear flag for redraw left
			beq.s	.chk_right			; branch if already clear
		; Draw new tiles on the left
			move.w	#$40,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			moveq	#-16,d5
			moveq	#3-1,d6
			bsr.w	DrawColumn_Partial
	.chk_right:
			bclr	#redraw_bg2_right_bit,(a2)
			beq.s	.exit
		; Draw new tiles on the right
			move.w	#$40,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawColumn_Partial
	.exit:
			rts
	locj_6EF2:
			dc.b $00,$00,$00,$00,$00,$00,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04
			dc.b $04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00
;===============================================================================
DrawBGScrollBlock3_MZ:
			moveq	#-16,d4
			bclr	#redraw_top_bit,(a2)
			bne.s	locj_6F66
			bclr	#redraw_bottom_bit,(a2)
			beq.s	locj_6FAE
			move.w	#224,d4
	locj_6F66:
			lea	(locj_6EF2+1).l,a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	DrawBG_XPosCopy_Ptrs(pc,d0.w),a3
			beq.s	locj_6F9A
			moveq	#-16,d5
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos
			popr	d4/d5
			bsr.w	DrawRow
			bra.s	locj_6FAE
;===============================================================================
	locj_6F9A:
			moveq	#0,d5
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos_IgnoreX
			popr	d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawRow_IgnoreX
	locj_6FAE:
			tst.b	(a2)
			bne.s	locj_6FB4
			rts
;===============================================================================			
	locj_6FB4:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	locj_6FC8
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
	locj_6FC8:
			lea	(locj_6EF2).l,a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC
;===============================================================================			
	DrawBG_XPosCopy_Ptrs:
			dc.w v_bg1_x_pos_copy, v_bg1_x_pos_copy, v_bg2_x_pos_copy, v_bg3_x_pos_copy
	locj_6FEC:
			moveq	#((224+16+16)/16)-1,d6
			move.l	#$800000,d7
	locj_6FF4:			
			moveq	#0,d0
			move.b	(a0)+,d0
			btst	d0,(a2)
			beq.s	locj_701C
			movea.w	DrawBG_XPosCopy_Ptrs(pc,d0.w),a3
			pushr	d4/d5/a0
			pushr	d4/d5
			bsr.w	GetBlockData
			popr	d4/d5
			bsr.w	Calc_VRAM_Pos
			bsr.w	DrawBlock
			popr	d4/d5/a0
	locj_701C:
			addi.w	#16,d4
			dbf	d6,locj_6FF4
			clr.b	(a2)
			rts			

		endc

; ---------------------------------------------------------------------------
; Subroutine to draw a row of 16x16 tiles, left to right

; input:
;	d0 = VRAM address as VDP command (word swapped)
;	d2 = VRAM write command ($4000) + nametable start address relative to vram_fg
;	d4 = y coordinate
;	d5 = x coordinate
;	d6 = 16x16 tiles to draw minus 1 (DrawRow_Partial only)
;	a4 = address of level/bg layout
;	a5 = vdp_control_port
;	a6 = vdp_data_port

;	uses d0, d1, d3, d5, d6, d7, a1
; ---------------------------------------------------------------------------

DrawRow:
		moveq	#((320+16+16)/16)-1,d6			; draw the entire width of the screen + two extra columns
DrawRow_Partial:
		move.l	#sizeof_vram_row<<16,d7			; delta between rows of tiles (as in VDP command)
		move.l	d0,d1

	.loop:
		pushr	d4-d5
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1					; two tiles ahead
		andi.b	#$7F,d1					; wrap around row
		popr	d4-d5
		addi.w	#16,d5					; x coordinate of next block
		dbf	d6,.loop
		rts

		if Revision=0
		else
DrawRow_IgnoreX:
			move.l	#sizeof_vram_row<<16,d7
			move.l	d0,d1

	.loop:
			pushr	d4-d5
			bsr.w	GetBlockData_IgnoreX
			move.l	d1,d0
			bsr.w	DrawBlock
			addq.b	#4,d1
			andi.b	#$7F,d1
			popr	d4-d5
			addi.w	#16,d5
			dbf	d6,.loop
			rts
		endc

; ---------------------------------------------------------------------------
; Subroutine to draw a column of 16x16 tiles, top to bottom

; input:
;	d0 = VRAM address as VDP command (word swapped)
;	d2 = VRAM write command ($4000) + nametable start address relative to vram_fg
;	d4 = y coordinate
;	d5 = x coordinate
;	d6 = 16x16 tiles to draw minus 1 (DrawRow_Partial only)
;	a4 = address of level/bg layout
;	a5 = vdp_control_port
;	a6 = vdp_data_port

;	uses d0, d1, d3, d4, d6, d7, a1
; ---------------------------------------------------------------------------

DrawColumn:
		moveq	#((224+16+16)/16)-1,d6			; draw the entire height of the screen + two extra rows
DrawColumn_Partial:
		move.l	#sizeof_vram_row<<16,d7			; delta between rows of tiles (as in VDP command)
		move.l	d0,d1

	.loop:
		pushr	d4-d5
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addi.w	#$100,d1				; two rows ahead
		andi.w	#$FFF,d1				; wrap around plane
		popr	d4-d5
		addi.w	#16,d4					; x coordinate of next block
		dbf	d6,.loop
		rts

; ---------------------------------------------------------------------------
; Subroutine to draw one 16x16 tile

; input:
;	d0 = VRAM address as VDP command (word swapped)
;	d2 = VRAM write command ($4000) + nametable start address relative to vram_fg
;	d7 = delta between rows in fg/bg nametables, as in VDP command ($800000)
;	a0 = address of 16x16 tile id and x/y flip metadata from 256x256 mappings
;	a1 = address of 16x16 tile mappings
;	a5 = vdp_control_port
;	a6 = vdp_data_port

;	uses d0, d4, d5, a1
; ---------------------------------------------------------------------------

DrawBlock:
		or.w	d2,d0					; integrate VRAM write and nametable specifier into VDP command
		swap	d0					; swap high/low words so it's a standard VDP command
		btst	#4,(a0)					; is y flip bit set?
		bne.s	DrawFlipY				; if yes, branch
		btst	#3,(a0)					; is x flip bit set?
		bne.s	DrawFlipX				; if yes, branch
		move.l	d0,(a5)					; send VDP command to vdp_control_port
		move.l	(a1)+,(a6)				; write top two tiles
		add.l	d7,d0					; next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)				; write bottom two tiles
		rts

DrawFlipX:
		move.l	d0,(a5)					; send VDP command to vdp_control_port
		move.l	(a1)+,d4				; get top two tiles
		eori.l	#$8000800,d4				; invert x flip bits of each tile
		swap	d4					; swap the tiles around
		move.l	d4,(a6)					; write top two tiles
		add.l	d7,d0					; next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)					; write bottom two tiles
		rts

DrawFlipY:
		btst	#3,(a0)					; is x flip bit also set?
		bne.s	DrawFlipXY				; if yes, branch
		move.l	d0,(a5)					; send VDP command to vdp_control_port
		move.l	(a1)+,d5				; get top two tiles
		move.l	(a1)+,d4				; get bottom two tiles
		eori.l	#$10001000,d4				; invert y flip bits
		move.l	d4,(a6)					; write bottom two tiles on top
		add.l	d7,d0					; next row
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)					; write top two tiles on bottom
		rts

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts

; ---------------------------------------------------------------------------
; Unused subroutine. Draws a 16x16 tile with all its palette lines incremented
; by 1, and ignoring x/y flip flags.
; ---------------------------------------------------------------------------
		if Revision=0
			rts	
			move.l	d0,(a5)				; send VDP command to vdp_control_port
			move.w	#$2000,d5
			move.w	(a1)+,d4			; get top left tile
			add.w	d5,d4				; increment palette
			move.w	d4,(a6)				; write tile
			move.w	(a1)+,d4			; get top right tile
			add.w	d5,d4
			move.w	d4,(a6)
			add.l	d7,d0				; next row
			move.l	d0,(a5)
			move.w	(a1)+,d4			; get bottom left tile
			add.w	d5,d4
			move.w	d4,(a6)
			move.w	(a1)+,d4			; get bottom right tile
			add.w	d5,d4
			move.w	d4,(a6)
			rts
		endc

; ---------------------------------------------------------------------------
; Subroutine to get the address of a 16x16 tile at a screen coordinate

; input:
;	d4 = y coordinate
;	d5 = x coordinate
;	(a3) = camera/bg x position
;	4(a3) = camera/bg y position
;	a4 = address of level/bg layout
;	a5 = vdp_control_port
;	a6 = vdp_data_port

; output:
;	a0 = address of 16x16 tile id and x/y flip metadata from 256x256 mappings
;	a1 = address of 16x16 tile mappings
;	uses d0, d3, d4, d5
; ---------------------------------------------------------------------------

GetBlockData:
		if Revision=0
			lea	(v_16x16_tiles).w,a1
			add.w	4(a3),d4			; add camera y pos to relative coordinate
			add.w	(a3),d5				; add camera x pos to relative coordinate
		else
			add.w	(a3),d5
	GetBlockData_IgnoreX:
			add.w	4(a3),d4
			lea	(v_16x16_tiles).w,a1
		endc
		; Turn y coordinate into index into level layout
		move.w	d4,d3
		lsr.w	#1,d3					; divide y pos by 2 (because layout alternates between level and bg lines)
		andi.w	#$380,d3				; read only high byte of y pos (because each level tile is 256px tall)
		; Turn x coordinate into index into level layout
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0					; read only high byte of x pos
		; Get 256x256 tile id from level layout
		add.w	d3,d0					; combine for position within layout
		moveq	#-1,d3					; d3 = $FFFFFFFF (used to make a RAM address)
		move.b	(a4,d0.w),d3				; d3 = $FFFFFF00 + 256x256 tile id
		beq.s	.exit					; if 0, just return a pointer to the first block (expected to be empty)
		; Turn 256x256 tile id into address of 256x256 mappings
		subq.b	#1,d3					; first 256x256 tile id is 1, not 0
		andi.w	#$7F,d3					; ignore high bit
		ror.w	#7,d3					; d3 = $FFFF0000 + (256x256 tile id * 512)
		; Turn y coordinate into position within 256x256 tile
		add.w	d4,d4
		andi.w	#$1E0,d4
		; Turn x coordinate into position within 256x256 tile
		andi.w	#$1E,d5
		; Get 16x16 tile id and x/y flip metadata from 256x256 mappings
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0					; a0 = address of 16x16 tile id and metadata within 256x256 mappings
		move.w	(a0),d3					; copy 16x16 tile id to d3
		; Turn 16x16 tile id into tile mappings address
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1					; a1 = address of 16x16 tile mappings

	.exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	convert screen relative coordinates to VDP command for VRAM
; fg/bg nametable access

; input:
;	d4 = y coordinate
;	d5 = x coordinate
;	(a3) = camera x position (Calc_VRAM_Pos only)
;	4(a3) = camera y position

; output:
;	d0 = VDP command (word swapped)
;	uses d4, d5
; ---------------------------------------------------------------------------

Calc_VRAM_Pos:
		if Revision=0
			add.w	4(a3),d4			; add camera y pos
			add.w	(a3),d5				; add camera x pos
		else
			add.w	(a3),d5
	Calc_VRAM_Pos_IgnoreX:
			add.w	4(a3),d4			; add camera y pos
		endc
		andi.w	#$F0,d4					; round down to 16 (size of block) and limit to $100 (height of plane, 32*8)
		andi.w	#$1F0,d5				; round down to 16 (size of block) and limit to $200 (width of plane, 64*8)
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#draw_base>>14,d0			; bits 15 & 14 of VRAM address ($C000)
		swap	d0					; swap high/low words (swapped back later by DrawBlock)
		move.w	d4,d0					; add offset for coordinate in fg/bg nametable
		rts

; ---------------------------------------------------------------------------
; Unused subroutine. Same as Calc_VRAM_Pos, except the base address for the
; fg/bg nametable is $8000 instead of $C000.
; ---------------------------------------------------------------------------

Calc_VRAM_Pos_Unknown:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#$8000>>14,d0
		swap	d0
		move.w	d4,d0
		rts

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears

; output:
;	a5 = vdp_control_port
;	a6 = vdp_data_port
; ---------------------------------------------------------------------------

DrawTilesAtStart:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_camera_x_pos).w,a3
		lea	(v_level_layout).w,a4
		move.w	#draw_fg,d2
		bsr.s	DrawChunks
		lea	(v_bg1_x_pos).w,a3
		lea	(v_level_layout+level_max_width).w,a4
		move.w	#draw_bg,d2
		if Revision=0
		; runs directly into DrawChunks
		else
			tst.b	(v_zone).w
			beq.w	DrawTilesAtStart_GHZ		; branch if GHZ
			cmpi.b	#id_MZ,(v_zone).w
			beq.w	DrawTilesAtStart_MZ		; branch if  LZ
			cmpi.w	#id_SBZ_act1,(v_zone).w
			beq.w	DrawTilesAtStart_SBZ1		; branch if SBZ act 1
			cmpi.b	#id_EndZ,(v_zone).w
			beq.w	DrawTilesAtStart_GHZ		; branch if on ending
		; else run directly into DrawChunks
		endc

; ---------------------------------------------------------------------------
; Subroutine to draw 16x16 tiles on whole screen

; input:
;	d2 = VRAM write command ($4000) + nametable start address relative to vram_fg
;	(a3) = camera/bg x position
;	4(a3) = camera/bg y position
;	a4 = address of level/bg layout
;	a5 = vdp_control_port
;	a6 = vdp_data_port
; ---------------------------------------------------------------------------

DrawChunks:
		moveq	#-16,d4					; draw from 16px above top of screen
		moveq	#((224+16+16)/16)-1,d6			; draw entire height of screen

	.loop:
		pushr	d4-d6
		moveq	#0,d5					; draw from left edge of screen
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6				; draw full row
		bsr.w	DrawRow_Partial
		popr	d4-d6
		addi.w	#16,d4					; next row
		dbf	d6,.loop
		rts
;===============================================================================

		if Revision=0
		else
DrawTilesAtStart_GHZ:
			moveq	#0,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_7224:			
			pushr	d4-d6
			lea	(locj_724a),a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0
			andi.w	#$F0,d0
			bsr.w	locj_72Ba
			popr	d4-d6
			addi.w	#16,d4
			dbf	d6,locj_7224
			rts
	locj_724a:
			dc.b $00,$00,$00,$00,$06,$06,$06,$04,$04,$04,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------------------------------
DrawTilesAtStart_MZ:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_725E:			
			pushr	d4-d6
			lea	(locj_6EF2+1),a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			bsr.w	locj_72Ba
			popr	d4-d6
			addi.w	#16,d4
			dbf	d6,locj_725E
			rts
;-------------------------------------------------------------------------------
DrawTilesAtStart_SBZ1:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_728C:			
			pushr	d4-d6
			lea	(locj_6DF4+1),a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			bsr.w	locj_72Ba
			popr	d4-d6
			addi.w	#16,d4
			dbf	d6,locj_728C
			rts
;-------------------------------------------------------------------------------
	locj_72B2:
			dc.w v_bg1_x_pos, v_bg1_x_pos, v_bg2_x_pos, v_bg3_x_pos
locj_72Ba:
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	locj_72B2(pc,d0.w),a3
			beq.s	locj_72da
			moveq	#-16,d5
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos
			popr	d4/d5
			bsr.w	DrawRow
			bra.s	locj_72EE
	locj_72da:
			moveq	#0,d5
			pushr	d4/d5
			bsr.w	Calc_VRAM_Pos_IgnoreX
			popr	d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawRow_IgnoreX
	locj_72EE:
			rts
		endc
