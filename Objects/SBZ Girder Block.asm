; ---------------------------------------------------------------------------
; Object 70 - large girder block (SBZ)

; spawned by:
;	ObjPos_SBZ1
; ---------------------------------------------------------------------------

Girder:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Gird_Index(pc,d0.w),d1
		jmp	Gird_Index(pc,d1.w)
; ===========================================================================
Gird_Index:	index offset(*),,2
		ptr Gird_Main
		ptr Gird_Action

		rsobj Girder,$30
ost_girder_y_start:	rs.w 1					; $30 ; original y-axis position
ost_girder_x_start:	rs.w 1					; $32 ; original x-axis position
ost_girder_move_time:	rs.w 1					; $34 ; duration for movement in a direction
		rsset $38
ost_girder_setting:	rs.b 1					; $38 ; which movement settings to use, increments by 8
ost_girder_wait_time:	rs.w 1					; $3A ; delay for movement
		rsobjend
; ===========================================================================

Gird_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Gird_Action next
		move.l	#Map_Gird,ost_mappings(a0)
		move.w	#tile_Nem_Girder+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$60,ost_displaywidth(a0)
		move.b	#$18,ost_height(a0)
		move.w	ost_x_pos(a0),ost_girder_x_start(a0)
		move.w	ost_y_pos(a0),ost_girder_y_start(a0)
		bsr.w	Gird_ChgDir				; set initial speed & direction

Gird_Action:	; Routine 2
		pushr.w	ost_x_pos(a0)
		tst.w	ost_girder_wait_time(a0)		; has time delay hit 0?
		beq.s	.beginmove				; if yes, branch
		subq.w	#1,ost_girder_wait_time(a0)		; decrement delay timer
		bne.s	.skip_move				; skip movement update

	.beginmove:
		jsr	(SpeedToPos).l				; update position
		subq.w	#1,ost_girder_move_time(a0)		; decrement movement timer
		bne.s	.skip_chg				; if time remains, branch
		bsr.w	Gird_ChgDir				; if time is 0, set new speed & direction

	.skip_move:
	.skip_chg:
		popr.w	d4
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	.chkdel					; if not, branch
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	ost_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	.chkdel:
		out_of_range.s	.delete,ost_girder_x_start(a0)
		jmp	(DisplaySprite).l

	.delete:
		jmp	(DeleteObject).l

; ---------------------------------------------------------------------------
; Subroutine to change the speed/direction the girder is moving
; ---------------------------------------------------------------------------

Gird_ChgDir:
		move.b	ost_girder_setting(a0),d0		; get current setting
		andi.w	#$18,d0
		lea	(.settings).l,a1
		lea	(a1,d0.w),a1				; jump to relevant settings
		move.w	(a1)+,ost_x_vel(a0)			; speed/direction
		move.w	(a1)+,ost_y_vel(a0)
		move.w	(a1)+,ost_girder_move_time(a0)		; how long to move in that direction
		addq.b	#8,ost_girder_setting(a0)		; use next settings
		move.w	#7,ost_girder_wait_time(a0)		; set time until it starts moving again
		rts	
; ===========================================================================
.settings:	;   x vel,   y vel, duration
		dc.w   $100,	 0,   $60,     0		; right
		dc.w	  0,  $100,   $30,     0		; down
		dc.w  -$100,  -$40,   $60,     0		; up/left
		dc.w	  0, -$100,   $18,     0		; up
