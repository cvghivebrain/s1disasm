; ---------------------------------------------------------------------------
; Object 52 - moving platform blocks (MZ, LZ, SBZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 1/2/$41
;	ObjPos_LZ1 - subtype 7
;	ObjPos_SBZ1, ObjPos_SBZ2 - subtypes $28/$39
;	ObjPos_SBZ3 - subtype 4
; ---------------------------------------------------------------------------

MovingBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	MBlock_Index(pc,d0.w),d1
		jmp	MBlock_Index(pc,d1.w)
; ===========================================================================
MBlock_Index:	index *,,2
		ptr MBlock_Main
		ptr MBlock_Platform
		ptr MBlock_StandOn

MBlock_Var:	; object width,	frame number
MBlock_Var_0:	dc.b $10, id_frame_mblock_mz1			; $0x - single block
MBlock_Var_1:	dc.b $20, id_frame_mblock_mz2			; $1x - double block (unused)
MBlock_Var_2:	dc.b $20, id_frame_mblock_sbz			; $2x - SBZ black & yellow platform
MBlock_Var_3:	dc.b $40, id_frame_mblock_sbzwide		; $3x - SBZ red horizontal door
MBlock_Var_4:	dc.b $30, id_frame_mblock_mz3			; $4x - triple block

sizeof_MBlock_Var:	equ MBlock_Var_1-MBlock_Var

ost_mblock_x_start:	equ $30					; original x position (2 bytes)
ost_mblock_y_start:	equ $32					; original y position (2 bytes)
ost_mblock_wait_time:	equ $34					; time delay before moving platform back - subtype x9/xA only (2 bytes)
ost_mblock_move_flag:	equ $36					; 1 = move platform back to its original position - subtype x9/xA only
; ===========================================================================

MBlock_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto MBlock_Platform next
		move.l	#Map_MBlock,ost_mappings(a0)
		move.w	#tile_Nem_MzBlock+tile_pal3,ost_tile(a0)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	@not_lz

		move.l	#Map_MBlockLZ,ost_mappings(a0)		; LZ specific code
		move.w	#tile_Nem_LzBlock3+tile_pal3,ost_tile(a0)
		move.b	#7,ost_height(a0)

	@not_lz:
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ
		bne.s	@not_sbz

		move.w	#tile_Nem_Stomper+tile_pal2,ost_tile(a0) ; SBZ specific code (object 5228)
		cmpi.b	#$28,ost_subtype(a0)			; is object 5228 ?
		beq.s	@not_sbz_28				; if yes, branch
		move.w	#tile_Nem_SlideFloor+tile_pal3,ost_tile(a0) ; SBZ specific code (object 523x)

	@not_sbz:
	@not_sbz_28:
		move.b	#render_rel,ost_render(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype
		lsr.w	#3,d0
		andi.w	#$1E,d0					; read only high nybble
		lea	MBlock_Var(pc,d0.w),a2			; get variables
		move.b	(a2)+,ost_actwidth(a0)
		move.b	(a2)+,ost_frame(a0)
		move.b	#4,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_mblock_y_start(a0)
		andi.b	#$F,ost_subtype(a0)			; clear high nybble of subtype

MBlock_Platform: ; Routine 2
		bsr.w	MBlock_Move				; move & update position
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(DetectPlatform).l			; check for collision & goto MBlock_StandOn next if stood on
		bra.s	MBlock_ChkDel
; ===========================================================================

MBlock_StandOn:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	MBlock_Move
		move.w	(sp)+,d2
		jsr	(MoveWithPlatform2).l

MBlock_ChkDel:
		out_of_range	DeleteObject,ost_mblock_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================

MBlock_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	MBlock_TypeIndex(pc,d0.w),d1
		jmp	MBlock_TypeIndex(pc,d1.w)
; ===========================================================================
MBlock_TypeIndex:index *
		ptr MBlock_Still				; 0 - doesn't move
		ptr MBlock_LeftRight				; 1 - moves side to side
		ptr MBlock_Right				; 2 - moves right when stood on, stops at wall
		ptr MBlock_Right_Now				; 3 - moves right immediately, stops at wall
		ptr MBlock_RightDrop				; 4 - moves right when stood on, stops at wall and drops
		ptr MBlock_RightDrop_Now			; 5 - moves right immediately, stops at wall and drops
		ptr MBlock_Drop_Now				; 6 - drops immediately
		ptr MBlock_RightDrop_Button			; 7 - appears when button 2 is pressed; moves right when stood on, stops at wall and drops
		ptr MBlock_UpDown				; 8 - moves up and down
		ptr MBlock_Slide				; 9 - quickly slides right when stood on
		ptr MBlock_Slide_Now				; $A - slides right immediately
; ===========================================================================

; Type 0
MBlock_Still:
		rts	
; ===========================================================================

; Type 1
MBlock_LeftRight:
		move.b	(v_oscillating_table+$C).w,d0
		move.w	#$60,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0
		add.w	d1,d0

	@no_xflip:
		move.w	ost_mblock_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

; Type 2
; Type 4
; Type 9
MBlock_Right:
MBlock_RightDrop:
MBlock_Slide:
		cmpi.b	#id_MBlock_StandOn,ost_routine(a0)	; is Sonic standing on the platform?
		bne.s	@wait
		addq.b	#1,ost_subtype(a0)			; if yes, add 1 to type

	@wait:
		rts	
; ===========================================================================

; Type 3
MBlock_Right_Now:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		bsr.w	FindWallRightObj
		tst.w	d1					; has the platform hit a wall?
		bmi.s	@hit_wall				; if yes, branch
		addq.w	#1,ost_x_pos(a0)			; move platform to the right
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		rts	

@hit_wall:
		clr.b	ost_subtype(a0)				; change to type 00 (non-moving	type)
		rts	
; ===========================================================================

; Type 5
MBlock_RightDrop_Now:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		bsr.w	FindWallRightObj
		tst.w	d1					; has the platform hit a wall?
		bmi.s	@hit_wall				; if yes, branch
		addq.w	#1,ost_x_pos(a0)			; move platform to the right
		move.w	ost_x_pos(a0),ost_mblock_x_start(a0)
		rts	

@hit_wall:
		addq.b	#1,ost_subtype(a0)			; change to type 06 (falling)
		rts	
; ===========================================================================

; Type 6
MBlock_Drop_Now:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)			; make the platform fall
		bsr.w	FindFloorObj
		tst.w	d1					; has platform hit the floor?
		bpl.w	@keep_falling				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)				; stop platform	falling
		clr.b	ost_subtype(a0)				; change to type 00 (non-moving)

	@keep_falling:
		rts	
; ===========================================================================

; Type 7
MBlock_RightDrop_Button:
		tst.b	(v_button_state+2).w			; has button number 02 been pressed?
		beq.s	@not_pressed
		subq.b	#3,ost_subtype(a0)			; if yes, change object type to 04

	@not_pressed:
		addq.l	#4,sp
		out_of_range	DeleteObject,ost_mblock_x_start(a0)
		rts	
; ===========================================================================

; Type 8
MBlock_UpDown:
		move.b	(v_oscillating_table+$1C).w,d0
		move.w	#$80,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d0					; reverse vertical direction if xflip bit is set
		add.w	d1,d0

	@no_xflip:
		move.w	ost_mblock_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

; Type $A
MBlock_Slide_Now:
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		add.w	d3,d3
		moveq	#8,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		neg.w	d1
		neg.w	d3

	@no_xflip:
		tst.w	ost_mblock_move_flag(a0)		; is platform set to move back?
		bne.s	MBlock_0A_Back				; if yes, branch
		move.w	ost_x_pos(a0),d0
		sub.w	ost_mblock_x_start(a0),d0
		cmp.w	d3,d0
		beq.s	MBlock_0A_Wait
		add.w	d1,ost_x_pos(a0)			; move platform
		move.w	#300,ost_mblock_wait_time(a0)		; set time delay to 5 seconds
		rts	
; ===========================================================================

MBlock_0A_Wait:
		subq.w	#1,ost_mblock_wait_time(a0)		; subtract 1 from time delay
		bne.s	@wait					; if time remains, branch
		move.w	#1,ost_mblock_move_flag(a0)		; set platform to move back to its original position

	@wait:
		rts	
; ===========================================================================

MBlock_0A_Back:
		move.w	ost_x_pos(a0),d0
		sub.w	ost_mblock_x_start(a0),d0
		beq.s	MBlock_0A_Reset
		sub.w	d1,ost_x_pos(a0)			; return platform to its original position
		rts	
; ===========================================================================

MBlock_0A_Reset:
		clr.w	ost_mblock_move_flag(a0)
		subq.b	#1,ost_subtype(a0)			; restore subtype to 9
		rts	
