; ---------------------------------------------------------------------------
; Object 70 - large girder block (SBZ)
; ---------------------------------------------------------------------------

Girder:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Gird_Index(pc,d0.w),d1
		jmp	Gird_Index(pc,d1.w)
; ===========================================================================
Gird_Index:	index *,,2
		ptr Gird_Main
		ptr Gird_Action

ost_girder_y_start:	equ $30	; original y-axis position (2 bytes)
ost_girder_x_start:	equ $32	; original x-axis position (2 bytes)
ost_girder_move_time:	equ $34	; duration for movement in a direction (2 bytes)
ost_girder_setting:	equ $38	; which movement settings to use, increments by 8
ost_girder_wait_time:	equ $3A	; delay for movement (2 bytes)
; ===========================================================================

Gird_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Gird,ost_mappings(a0)
		move.w	#tile_Nem_Girder+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$60,ost_actwidth(a0)
		move.b	#$18,ost_height(a0)
		move.w	ost_x_pos(a0),ost_girder_x_start(a0)
		move.w	ost_y_pos(a0),ost_girder_y_start(a0)
		bsr.w	Gird_ChgMove

Gird_Action:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		tst.w	ost_girder_wait_time(a0)
		beq.s	@beginmove
		subq.w	#1,ost_girder_wait_time(a0)
		bne.s	@solid

	@beginmove:
		jsr	(SpeedToPos).l
		subq.w	#1,ost_girder_move_time(a0) ; decrement movement duration
		bne.s	@solid		; if time remains, branch
		bsr.w	Gird_ChgMove	; if time is zero, branch

	@solid:
		move.w	(sp)+,d4
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	ost_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	@chkdel:
		out_of_range.s	@delete,ost_girder_x_start(a0)
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Gird_ChgMove:
		move.b	ost_girder_setting(a0),d0
		andi.w	#$18,d0
		lea	(@settings).l,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,ost_x_vel(a0) ; speed/direction
		move.w	(a1)+,ost_y_vel(a0)
		move.w	(a1)+,ost_girder_move_time(a0) ; how long to move in that direction
		addq.b	#8,ost_girder_setting(a0) ; use next settings
		move.w	#7,ost_girder_wait_time(a0)
		rts	
; ===========================================================================
@settings:	;   x vel,   y vel, duration
		dc.w   $100,	 0,   $60,     0 ; right
		dc.w	  0,  $100,   $30,     0 ; down
		dc.w  -$100,  -$40,   $60,     0 ; up/left
		dc.w	  0, -$100,   $18,     0 ; up
