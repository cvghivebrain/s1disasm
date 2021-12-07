; ---------------------------------------------------------------------------
; Subroutine to	scroll the level horizontally as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollHorizontal:
		move.w	(v_camera_x_pos).w,d4			; save old screen position
		bsr.s	MoveScreenHoriz
		move.w	(v_camera_x_pos).w,d0
		andi.w	#$10,d0
		move.b	(v_fg_x_redraw_flag).w,d1
		eor.b	d1,d0
		bne.s	@return
		eori.b	#$10,(v_fg_x_redraw_flag).w
		move.w	(v_camera_x_pos).w,d0
		sub.w	d4,d0					; compare new with old screen position
		bpl.s	@scrollRight

		bset	#redraw_left_bit,(v_fg_redraw_direction).w ; screen moves backward
		rts	

	@scrollRight:
		bset	#redraw_right_bit,(v_fg_redraw_direction).w ; screen moves forward

	@return:
		rts	
; End of function ScrollHorizontal


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveScreenHoriz:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	(v_camera_x_pos).w,d0			; d0 = Sonic's distance from left edge of screen
		subi.w	#144,d0					; is distance less than 144px?
		bcs.s	SH_BehindMid				; if yes, branch
		subi.w	#16,d0					; is distance more than 160px?
		bcc.s	SH_AheadOfMid				; if yes, branch
		clr.w	(v_camera_x_diff).w			; no camera movement
		rts	
; ===========================================================================

SH_AheadOfMid:
		cmpi.w	#16,d0					; is Sonic within 16px of middle area?
		bcs.s	@within_16				; if yes, branch
		move.w	#16,d0					; set to 16 if greater

	@within_16:
		add.w	(v_camera_x_pos).w,d0			; d0 = new camera x pos
		cmp.w	(v_boundary_right).w,d0			; is camera within boundary?
		blt.s	SH_SetScreen				; if yes, branch
		move.w	(v_boundary_right).w,d0			; stop camera moving outside boundary

SH_SetScreen:
		move.w	d0,d1
		sub.w	(v_camera_x_pos).w,d1			; d1 = difference since last camera x pos
		asl.w	#8,d1					; move into high byte (multiply by $100)
		move.w	d0,(v_camera_x_pos).w			; set new screen position
		move.w	d1,(v_camera_x_diff).w			; set distance for camera movement
		rts	
; ===========================================================================

SH_BehindMid:
		add.w	(v_camera_x_pos).w,d0			; d0 = new camera x pos
		cmp.w	(v_boundary_left).w,d0			; is camera within boundary?
		bgt.s	SH_SetScreen				; if yes, branch
		move.w	(v_boundary_left).w,d0			; stop camera moving outside boundary
		bra.s	SH_SetScreen
; End of function MoveScreenHoriz

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to scroll the level horizontally at a fixed rate
; ---------------------------------------------------------------------------

AutoScroll:
		tst.w	d0
		bpl.s	@forwards
		move.w	#-2,d0
		bra.s	SH_BehindMid

	@forwards:
		move.w	#2,d0
		bra.s	SH_AheadOfMid

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level vertically as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollVertical:
		moveq	#0,d1
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	(v_camera_y_pos).w,d0			; d0 = Sonic's distance from top of screen
		btst	#status_jump_bit,(v_ost_player+ost_status).w ; is Sonic jumping/rolling?
		beq.s	@not_rolling				; if not, branch
		subq.w	#5,d0

	@not_rolling:
		btst	#status_air_bit,(v_ost_player+ost_status).w ; is Sonic in the air?
		beq.s	@ground					; if not, branch

		addi.w	#32,d0					; pretend Sonic is 32px lower
		sub.w	(v_camera_y_shift).w,d0			; is Sonic within 96px of top of screen? (or other value if looked up/down recenly)
		bcs.s	SV_OutsideMid_Air			; if yes, branch
		subi.w	#64,d0					; is distance more than 160px?
		bcc.s	SV_OutsideMid_Air			; if yes, branch
		tst.b	(f_boundary_bottom_change).w		; is bottom level boundary set to change?
		bne.s	SV_BoundaryChange			; if yes, branch
		bra.s	@no_change
; ===========================================================================

@ground:
		sub.w	(v_camera_y_shift).w,d0			; is Sonic 96px from top of screen?
		bne.s	SV_OutsideMid_Ground			; if not, branch
		tst.b	(f_boundary_bottom_change).w		; is bottom level boundary set to change?
		bne.s	SV_BoundaryChange

@no_change:
		clr.w	(v_camera_y_diff).w
		rts	
; ===========================================================================

SV_OutsideMid_Ground:
		cmpi.w	#96,(v_camera_y_shift).w		; has Sonic looked up/down recently? (default y shift is 96)
		bne.s	@y_shift_different			; if yes, branch

		move.w	(v_ost_player+ost_inertia).w,d1		; get Sonic's inertia
		bpl.s	@inertia_positive			; branch if positive
		neg.w	d1					; make it positive

	@inertia_positive:
		cmpi.w	#$800,d1
		bcc.s	SV_OutsideMid_Air			; branch if inertia >= $800
		move.w	#$600,d1
		cmpi.w	#6,d0					; is Sonic more than 6px below middle area?
		bgt.s	SV_BelowMid				; if yes, branch
		cmpi.w	#-6,d0					; is Sonic more than 6px above middle area?
		blt.s	SV_AboveMid				; if yes, branch
		bra.s	loc_66AE
; ===========================================================================

@y_shift_different:
		move.w	#$200,d1
		cmpi.w	#2,d0					; is Sonic more than 2px below middle area?
		bgt.s	SV_BelowMid				; if yes, branch
		cmpi.w	#-2,d0					; is Sonic more than 2px above middle area?
		blt.s	SV_AboveMid				; if yes, branch
		bra.s	loc_66AE
; ===========================================================================

SV_OutsideMid_Air:
		move.w	#$1000,d1
		cmpi.w	#16,d0					; is Sonic more than 16px below middle area?
		bgt.s	SV_BelowMid				; if yes, branch
		cmpi.w	#-16,d0					; is Sonic more than 16px above middle area?
		blt.s	SV_AboveMid				; if yes, branch
		bra.s	loc_66AE
; ===========================================================================

SV_BoundaryChange:
		moveq	#0,d0
		move.b	d0,(f_boundary_bottom_change).w		; clear boundary change flag

loc_66AE:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(v_camera_y_pos).w,d1
		tst.w	d0
		bpl.w	loc_6700
		bra.w	loc_66CC
; ===========================================================================

SV_AboveMid:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_camera_y_pos).w,d1
		swap	d1

loc_66CC:
		cmp.w	(v_boundary_top).w,d1
		bgt.s	loc_6724
		cmpi.w	#-$100,d1
		bgt.s	loc_66F0
		andi.w	#$7FF,d1
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		andi.w	#$7FF,(v_camera_y_pos).w
		andi.w	#$3FF,(v_bg1_y_pos).w
		bra.s	loc_6724
; ===========================================================================

loc_66F0:
		move.w	(v_boundary_top).w,d1
		bra.s	loc_6724
; ===========================================================================

SV_BelowMid:
		ext.l	d1
		asl.l	#8,d1
		add.l	(v_camera_y_pos).w,d1
		swap	d1

loc_6700:
		cmp.w	(v_boundary_bottom).w,d1
		blt.s	loc_6724
		subi.w	#$800,d1
		bcs.s	loc_6720
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		subi.w	#$800,(v_camera_y_pos).w
		andi.w	#$3FF,(v_bg1_y_pos).w
		bra.s	loc_6724
; ===========================================================================

loc_6720:
		move.w	(v_boundary_bottom).w,d1

loc_6724:
		move.w	(v_camera_y_pos).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(v_camera_y_pos).w,d3
		ror.l	#8,d3
		move.w	d3,(v_camera_y_diff).w
		move.l	d1,(v_camera_y_pos).w
		move.w	(v_camera_y_pos).w,d0
		andi.w	#$10,d0
		move.b	(v_fg_y_redraw_flag).w,d1
		eor.b	d1,d0
		bne.s	@return
		eori.b	#$10,(v_fg_y_redraw_flag).w
		move.w	(v_camera_y_pos).w,d0
		sub.w	d4,d0
		bpl.s	@scrollBottom
		bset	#redraw_top_bit,(v_fg_redraw_direction).w
		rts	
; ===========================================================================

	@scrollBottom:
		bset	#redraw_bottom_bit,(v_fg_redraw_direction).w

	@return:
		rts	
; End of function ScrollVertical
