; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SYZ/SLZ), large doors (LZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3 - subtypes 0/1/2/$13/$17/$20/$37/$A0
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3, ObjPos_SBZ3 - subtypes $E0-$EA, $F0-$FA
;	ObjPos_SLZ2, ObjPos_SLZ3 - subtypes $58-$5B
; ---------------------------------------------------------------------------

FloatingBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FBlock_Index(pc,d0.w),d1
		jmp	FBlock_Index(pc,d1.w)
; ===========================================================================
FBlock_Index:	index *
		ptr FBlock_Main
		ptr FBlock_Action

FBlock_Var:	; width/2, height/2
		dc.b  $10, $10					; subtype 0x/8x
		dc.b  $20, $20					; subtype 1x/9x
		dc.b  $10, $20					; subtype 2x/Ax
		dc.b  $20, $1A					; subtype 3x/Bx
		dc.b  $10, $27					; subtype 4x/Cx - unused
		dc.b  $10, $10					; subtype 5x/Dx
		dc.b	8, $20					; subtype 6x/Ex
		dc.b  $40, $10					; subtype 7x/Fx

ost_fblock_y_start:	equ $30					; original y position (2 bytes)
ost_fblock_x_start:	equ $34					; original x position (2 bytes)
ost_fblock_move_flag:	equ $38					; 1 = block/door is moving
ost_fblock_move_dist:	equ $3A					; distance to move (2 bytes)
ost_fblock_btn_num:	equ $3C					; which button the block is linked to
; ===========================================================================

FBlock_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto FBlock_Action next
		move.l	#Map_FBlock,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	@not_lz					; if not, branch
		move.w	#tile_Nem_LzDoorV+tile_pal3,ost_tile(a0) ; LZ specific code

	@not_lz:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype
		lsr.w	#3,d0
		andi.w	#$E,d0					; read only bits 4-6 (high nybble sans high bit)
		lea	FBlock_Var(pc,d0.w),a2			; get size data
		move.b	(a2)+,ost_displaywidth(a0)
		move.b	(a2),ost_height(a0)
		lsr.w	#1,d0
		move.b	d0,ost_frame(a0)			; set frame as high nybble of subtype
		move.w	ost_x_pos(a0),ost_fblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_fblock_y_start(a0)
		moveq	#0,d0
		move.b	(a2),d0					; get height from size list
		add.w	d0,d0
		move.w	d0,ost_fblock_move_dist(a0)		; set full height
		if Revision=0
		else
			cmpi.b	#type_fblock_syzrect2x2+type_fblock_farrightbutton,ost_subtype(a0) ; is the subtype $37? (used once in SYZ3)
			bne.s	@dontdelete			; if not, branch
			cmpi.w	#$1BB8,ost_x_pos(a0)		; is object in its start position?
			bne.s	@notatpos			; if not, branch
			tst.b	(f_fblock_finish).w		; has similar object reached its destination?
			beq.s	@dontdelete			; if not, branch
			jmp	(DeleteObject).l
	@notatpos:
			clr.b	ost_subtype(a0)			; stop object moving
			tst.b	(f_fblock_finish).w
			bne.s	@dontdelete
			jmp	(DeleteObject).l
	@dontdelete:
		endc
		moveq	#0,d0
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		beq.s	@not_syzslz				; if yes, branch
		move.b	ost_subtype(a0),d0			; SYZ/SLZ specific code
		andi.w	#$F,d0					; read low nybble of subtype
		subq.w	#8,d0					; subtract 8
		bcs.s	@not_syzslz				; branch if low nybble was > 8
		lsl.w	#2,d0					; multiply by 4
		lea	(v_oscillating_0_to_40_alt+2).w,a2
		lea	(a2,d0.w),a2				; read oscillating value
		tst.w	(a2)
		bpl.s	@not_syzslz				; branch if not -ve
		bchg	#status_xflip_bit,ost_status(a0)	; xflip object

	@not_syzslz:
		move.b	ost_subtype(a0),d0			; get subtype
		bpl.s	FBlock_Action				; if subtype is 0-$7F, branch
		andi.b	#$F,d0					; read low nybble
		move.b	d0,ost_fblock_btn_num(a0)		; save to variable
		move.b	#id_FBlock_UpButton,ost_subtype(a0)	; force subtype to 5 (moves up when button is pressed)
		cmpi.b	#id_frame_fblock_lzhoriz,ost_frame(a0)	; is object a large horizontal LZ door?
		bne.s	@chkstate				; if not, branch
		move.b	#id_FBlock_LeftButton,ost_subtype(a0)	; force subtype to $C (moves left when button is pressed)
		move.w	#$80,ost_fblock_move_dist(a0)

	@chkstate:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	FBlock_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	FBlock_Action
		addq.b	#1,ost_subtype(a0)			; change subtype to 6 or $D if previously activated
		clr.w	ost_fblock_move_dist(a0)

FBlock_Action:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get object subtype (changed if original was $80+)
		andi.w	#$F,d0					; read only the	low nybble
		add.w	d0,d0
		move.w	FBlock_Types(pc,d0.w),d1
		jsr	FBlock_Types(pc,d1.w)			; update position
		move.w	(sp)+,d4
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	ost_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject				; detect collision

	@chkdel:
		if Revision=0
			out_of_range	DeleteObject,ost_fblock_x_start(a0)
			bra.w	DisplaySprite
		else
			out_of_range.s	@chkdel2,ost_fblock_x_start(a0)
		@display:
			bra.w	DisplaySprite
		@chkdel2:
			cmpi.b	#type_fblock_syzrect2x2+type_fblock_farrightbutton,ost_subtype(a0)
			bne.s	@delete
			tst.b	ost_fblock_move_flag(a0)
			bne.s	@display
		@delete:
			jmp	(DeleteObject).l
		endc
; ===========================================================================
FBlock_Types:	index *
		ptr FBlock_Still				; 0
		ptr FBlock_LeftRight				; 1
		ptr FBlock_LeftRightWide			; 2
		ptr FBlock_UpDown				; 3
		ptr FBlock_UpDownWide				; 4 - unused
		ptr FBlock_UpButton				; 5
		ptr FBlock_DownButton				; 6 - used, but never activated
		ptr FBlock_FarRightButton			; 7
		ptr FBlock_SquareSmall				; 8
		ptr FBlock_SquareMedium				; 9
		ptr FBlock_SquareBig				; $A
		ptr FBlock_SquareBiggest			; $B
		ptr FBlock_LeftButton				; $C
		ptr FBlock_RightButton				; $D - used, but never activated
; ===========================================================================

; Type 0 - doesn't move
FBlock_Still:
		rts	
; ===========================================================================

; Type 1 - moves side-to-side
FBlock_LeftRight:
		move.w	#$40,d1					; set move distance
		moveq	#0,d0
		move.b	(v_oscillating_0_to_40).w,d0
		bra.s	FBlock_LeftRight_Move
; ===========================================================================

; Type 2 - moves side-to-side
FBlock_LeftRightWide:
		move.w	#$80,d1					; set move distance
		moveq	#0,d0
		move.b	(v_oscillating_0_to_80).w,d0

FBlock_LeftRight_Move:
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d0
		add.w	d1,d0

	@noflip:
		move.w	ost_fblock_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)			; move object horizontally
		rts	
; ===========================================================================

; Type 3 - moves up/down
FBlock_UpDown:
		move.w	#$40,d1					; set move distance
		moveq	#0,d0
		move.b	(v_oscillating_0_to_40).w,d0
		bra.s	FBlock_UpDown_Move
; ===========================================================================

; Type 4 - moves up/down
FBlock_UpDownWide:
		move.w	#$80,d1					; set move distance
		moveq	#0,d0
		move.b	(v_oscillating_0_to_80).w,d0

FBlock_UpDown_Move:
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d0
		add.w	d1,d0

	@noflip:
		move.w	ost_fblock_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)			; move object vertically
		rts	
; ===========================================================================

; Type 5 - moves up when a button is pressed
FBlock_UpButton:
		tst.b	ost_fblock_move_flag(a0)		; is object moving?
		bne.s	@chk_distance				; if yes, branch
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w		; is level LZ1 ?
		bne.s	@not_lz1				; if not, branch
		cmpi.b	#3,ost_fblock_btn_num(a0)		; is object linked to button 3?
		bne.s	@not_lz1				; if not, branch
		clr.b	(f_water_tunnel_disable).w		; enable water tunnels
		move.w	(v_ost_player+ost_x_pos).w,d0
		cmp.w	ost_x_pos(a0),d0			; is Sonic to the right?
		bcc.s	@not_lz1				; if yes, branch
		move.b	#1,(f_water_tunnel_disable).w		; disable water tunnels if Sonic is to the left

	@not_lz1:
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_fblock_btn_num(a0),d0
		btst	#0,(a2,d0.w)				; check status of linked button
		beq.s	@not_pressed				; branch if not pressed
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w		; is level LZ1 ?
		bne.s	@not_lz1_again				; if not, branch
		cmpi.b	#3,d0					; is object linked to button 3?
		bne.s	@not_lz1_again				; if not, branch
		clr.b	(f_water_tunnel_disable).w		; enable water tunnels

	@not_lz1_again:
		move.b	#1,ost_fblock_move_flag(a0)		; flag object as moving

	@chk_distance:
		tst.w	ost_fblock_move_dist(a0)		; is remaining distance = 0?
		beq.s	@finish					; if yes, branch
		subq.w	#2,ost_fblock_move_dist(a0)		; decrement distance

	@not_pressed:
		move.w	ost_fblock_move_dist(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0					; invert if xflipped

	@no_xflip:
		move.w	ost_fblock_y_start(a0),d1
		add.w	d0,d1					; add distance to start position
		move.w	d1,ost_y_pos(a0)			; update y pos
		rts	
; ===========================================================================

@finish:
		addq.b	#1,ost_subtype(a0)			; convert to type 6
		clr.b	ost_fblock_move_flag(a0)		; clear movement flag
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@not_pressed
		bset	#0,2(a2,d0.w)
		bra.s	@not_pressed
; ===========================================================================

; Type 6 - moves down when button is pressed
FBlock_DownButton:
		tst.b	ost_fblock_move_flag(a0)		; is object moving?
		bne.s	@chk_distance				; if yes, branch
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_fblock_btn_num(a0),d0
		tst.b	(a2,d0.w)				; check status of linked button (unused button subtype $4x)
		bpl.s	@not_pressed				; branch if not pressed
		move.b	#1,ost_fblock_move_flag(a0)

	@chk_distance:
		moveq	#0,d0
		move.b	ost_height(a0),d0
		add.w	d0,d0
		cmp.w	ost_fblock_move_dist(a0),d0		; has object moved distance equal to its height?
		beq.s	@finish					; if yes, branch
		addq.w	#2,ost_fblock_move_dist(a0)		; increment distance

	@not_pressed:
		move.w	ost_fblock_move_dist(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0					; invert if xflipped

	@no_xflip:
		move.w	ost_fblock_y_start(a0),d1
		add.w	d0,d1					; add distance to start position
		move.w	d1,ost_y_pos(a0)			; update y pos
		rts	
; ===========================================================================

@finish:
		subq.b	#1,ost_subtype(a0)			; convert to type 5
		clr.b	ost_fblock_move_flag(a0)		; clear movement flag
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@not_pressed
		bclr	#0,2(a2,d0.w)
		bra.s	@not_pressed
; ===========================================================================

; Type 7 - moves far right when button $F is pressed
FBlock_FarRightButton:
		tst.b	ost_fblock_move_flag(a0)		; is object moving already?
		bne.s	@chk_distance				; if yes, branch
		tst.b	(v_button_state+$F).w			; has button number $F been pressed?
		beq.s	@end					; if not, branch
		move.b	#1,ost_fblock_move_flag(a0)
		clr.w	ost_fblock_move_dist(a0)

	@chk_distance:
		addq.w	#1,ost_x_pos(a0)			; move object right
		move.w	ost_x_pos(a0),ost_fblock_x_start(a0)
		addq.w	#1,ost_fblock_move_dist(a0)		; increment movement counter
		cmpi.w	#$380,ost_fblock_move_dist(a0)		; has object moved $380 pixels?
		bne.s	@end					; if not, branch
		if Revision=0
		else
			move.b	#1,(f_fblock_finish).w
			clr.b	ost_fblock_move_flag(a0)
		endc
		clr.b	ost_subtype(a0)				; stop object moving

	@end:
		rts	
; ===========================================================================

; Type $C - moves left when button is pressed
FBlock_LeftButton:
		tst.b	ost_fblock_move_flag(a0)		; is object moving?
		bne.s	@chk_distance				; if yes, branch
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_fblock_btn_num(a0),d0
		btst	#0,(a2,d0.w)				; check status of linked button
		beq.s	@not_pressed				; branch if not pressed
		move.b	#1,ost_fblock_move_flag(a0)		; flag object as moving

	@chk_distance:
		tst.w	ost_fblock_move_dist(a0)		; is remaining distance = 0?
		beq.s	@finish					; if yes, branch
		subq.w	#2,ost_fblock_move_dist(a0)		; decrement distance

	@not_pressed:
		move.w	ost_fblock_move_dist(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0					; invert if xflipped
		addi.w	#$80,d0

	@no_xflip:
		move.w	ost_fblock_x_start(a0),d1
		add.w	d0,d1					; add distance to start position
		move.w	d1,ost_x_pos(a0)			; update x pos
		rts	
; ===========================================================================

@finish:
		addq.b	#1,ost_subtype(a0)			; convert to type $D
		clr.b	ost_fblock_move_flag(a0)		; clear movement flag
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@not_pressed
		bset	#0,2(a2,d0.w)
		bra.s	@not_pressed
; ===========================================================================

; Type $D - moves right when button is pressed
FBlock_RightButton:
		tst.b	ost_fblock_move_flag(a0)		; is object moving?
		bne.s	@chk_distance				; if yes, branch
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_fblock_btn_num(a0),d0
		tst.b	(a2,d0.w)				; check status of linked button (unused button subtype $4x)
		bpl.s	@not_pressed				; branch if not pressed
		move.b	#1,ost_fblock_move_flag(a0)

	@chk_distance:
		move.w	#$80,d0
		cmp.w	ost_fblock_move_dist(a0),d0		; has object moved 128px?
		beq.s	@finish					; if yes, branch
		addq.w	#2,ost_fblock_move_dist(a0)		; increment distance

	@not_pressed:
		move.w	ost_fblock_move_dist(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0					; invert if xflipped
		addi.w	#$80,d0

	@no_xflip:
		move.w	ost_fblock_x_start(a0),d1
		add.w	d0,d1					; add distance to start position
		move.w	d1,ost_x_pos(a0)			; update x pos
		rts	
; ===========================================================================

@finish:
		subq.b	#1,ost_subtype(a0)			; convert to type $C
		clr.b	ost_fblock_move_flag(a0)		; clear movement flag
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@not_pressed
		bclr	#0,2(a2,d0.w)
		bra.s	@not_pressed
; ===========================================================================

; Type 8 - moves around in a square
FBlock_SquareSmall:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_40_alt).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillating_0_to_40_alt+2).w,d3
		bra.s	FBlock_Square_Move
; ===========================================================================

; Type 9
FBlock_SquareMedium:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_60_alt).w,d0
		move.w	(v_oscillating_0_to_60_alt+2).w,d3
		bra.s	FBlock_Square_Move
; ===========================================================================

; Type $A
FBlock_SquareBig:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_A0_fast).w,d0
		move.w	(v_oscillating_0_to_A0_fast+2).w,d3
		bra.s	FBlock_Square_Move
; ===========================================================================

; Type $B
FBlock_SquareBiggest:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_E0).w,d0
		move.w	(v_oscillating_0_to_E0+2).w,d3

FBlock_Square_Move:
		tst.w	d3					; is oscillating value rate currently 0? (i.e. at peak or nadir of oscillation)
		bne.s	@keep_going				; if not, branch
		addq.b	#status_xflip,ost_status(a0)		; change direction
		andi.b	#status_xflip+status_yflip,ost_status(a0) ; prevent bit overflow

	@keep_going:
		move.b	ost_status(a0),d2
		andi.b	#status_xflip+status_yflip,d2		; read xflip and yflip bits
		bne.s	@xflip					; branch if either are set
		sub.w	d1,d0
		add.w	ost_fblock_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)			; update position
		neg.w	d1
		add.w	ost_fblock_y_start(a0),d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@xflip:
		subq.b	#1,d2
		bne.s	@yflip					; branch if yflip bit is set
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	ost_fblock_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)			; update position
		addq.w	#1,d1
		add.w	ost_fblock_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@yflip:
		subq.b	#1,d2
		bne.s	@xflip_and_yflip			; branch if xflip and yflip bits are set
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	ost_fblock_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)			; update position
		addq.w	#1,d1
		add.w	ost_fblock_y_start(a0),d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@xflip_and_yflip:
		sub.w	d1,d0
		add.w	ost_fblock_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)			; update position
		neg.w	d1
		add.w	ost_fblock_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		rts	
