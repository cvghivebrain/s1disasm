; ---------------------------------------------------------------------------
; Subroutine to	load a level's objects

;	uses d0, d1, d2, d6, a0, a1, a2
; ---------------------------------------------------------------------------

ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)

; ===========================================================================
OPL_Index:	index *
		ptr OPL_Init
		ptr OPL_Main
; ===========================================================================

OPL_Init:
		addq.b	#2,(v_opl_routine).w			; goto OPL_Main next
		move.w	(v_zone).w,d0				; get zone/act numbers
		lsl.b	#6,d0
		lsr.w	#4,d0					; combine zone/act into single number, times 4
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1					; copy index pointer to a1
		adda.w	(a0,d0.w),a0				; jump to objpos data
		move.l	a0,(v_opl_ptr_right).w			; copy objpos data address
		move.l	a0,(v_opl_ptr_left).w
		adda.w	2(a1,d0.w),a1				; jump to secondary objpos data (this is always blank)
		move.l	a1,(v_opl_ptr_alt_right).w		; copy objpos data address
		move.l	a1,(v_opl_ptr_alt_left).w
		lea	(v_respawn_list).w,a2
		move.w	#$101,(a2)+
		move.w	#($17C/4)-1,d0				; deletes half the stack as well; should be $100

	@clear_respawn_list:
		clr.l	(a2)+
		dbf	d0,@clear_respawn_list			; clear object respawn list

		lea	(v_respawn_list).w,a2
		moveq	#0,d2
		move.w	(v_camera_x_pos).w,d6
		subi.w	#128,d6					; d6 = 128px to left of screen
		bcc.s	@use_screen_x				; branch if camera is > 128px from left boundary
		moveq	#0,d6					; assume 0 if camera is close to left boundary

	@use_screen_x:
		andi.w	#$FF80,d6				; round down to nearest $80
		movea.l	(v_opl_ptr_right).w,a0			; get objpos data pointer

@loop_find_first:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = edge of object window
		bls.s	@found_near				; branch if object is within object window
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	@no_respawn				; branch if no remember flag found
		move.b	(a2),d2					; d2 = respawn state
		addq.b	#1,(a2)					; increment respawn list counter

	@no_respawn:
		addq.w	#6,a0					; goto next object in objpos list
		bra.s	@loop_find_first			; loop until object is found within window
; ===========================================================================

@found_near:
		move.l	a0,(v_opl_ptr_right).w			; save pointer for objpos, 128px left of screen
		movea.l	(v_opl_ptr_left).w,a0			; get first objpos again
		subi.w	#128,d6					; d6 = 256px to left of screen
		bcs.s	@found_far				; branch if camera is close to left boundary

@loop_find_far:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = edge of object window
		bls.s	@found_far				; branch if object is within object window
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	@no_respawn2				; branch if no remember flag found
		addq.b	#1,1(a2)				; increment second respawn list counter

	@no_respawn2:
		addq.w	#6,a0					; goto next object in objpos list
		bra.s	@loop_find_far				; loop until object is found within window
; ===========================================================================

@found_far:
		move.l	a0,(v_opl_ptr_left).w			; save pointer for objpos, 256px left of screen
		move.w	#-1,(v_opl_screen_x_pos).w		; initial screen position

OPL_Main:
		lea	(v_respawn_list).w,a2
		moveq	#0,d2
		move.w	(v_camera_x_pos).w,d6
		andi.w	#$FF80,d6				; d6 = camera x pos rounded down to nearest $80
		cmp.w	(v_opl_screen_x_pos).w,d6		; compare to previous screen position
		beq.w	OPL_NoMove				; branch if screen hasn't moved
		bge.s	OPL_MovedRight				; branch if screen is right of previous position

OPL_MovedLeft:
		move.w	d6,(v_opl_screen_x_pos).w		; update screen position
		movea.l	(v_opl_ptr_left).w,a0			; jump to objpos on left side of window
		subi.w	#128,d6					; d6 = 128px to left of screen
		bcs.s	@found_left				; branch if camera is close to left boundary

@loop_find_left:
		cmp.w	-6(a0),d6				; read objpos backwards
		bge.s	@found_left				; branch if object is within object window
		subq.w	#6,a0					; update pointer
		tst.b	4(a0)					; 4(a0) = object id and remember state flag
		bpl.s	@no_respawn				; branch if no remember flag found
		subq.b	#1,1(a2)				; decrement second respawn list counter
		move.b	1(a2),d2				; get respawn counter

	@no_respawn:
		bsr.w	OPL_SpawnObj				; check respawn flag and spawn object
		bne.s	@fail					; branch if spawn fails
		subq.w	#6,a0					; goto previous object in objpos list
		bra.s	@loop_find_left				; loop until object is found within window
; ===========================================================================

@fail:
		tst.b	4(a0)
		bpl.s	@no_respawn2
		addq.b	#1,1(a2)

	@no_respawn2:
		addq.w	#6,a0

@found_left:
		move.l	a0,(v_opl_ptr_left).w			; save pointer for objpos
		movea.l	(v_opl_ptr_right).w,a0			; jump to objpos on right side of window
		addi.w	#128+320+320,d6				; d6 = 320px to right of screen

@loop_find_right:
		cmp.w	-6(a0),d6				; read objpos backwards
		bgt.s	@found_right				; branch if object is within object window
		tst.b	-2(a0)					; -2(a0) = object id and remember state flag
		bpl.s	@no_respawn3				; branch if no remember flag found
		subq.b	#1,(a2)					; decrement respawn list counter

	@no_respawn3:
		subq.w	#6,a0					; goto previous object in objpos list
		bra.s	@loop_find_right
; ===========================================================================

@found_right:
		move.l	a0,(v_opl_ptr_right).w			; save pointer for objpos
		rts	
; ===========================================================================

OPL_MovedRight:
		move.w	d6,(v_opl_screen_x_pos).w		; update screen position
		movea.l	(v_opl_ptr_right).w,a0			; jump to objpos on right side of window
		addi.w	#320+320,d6				; d6 = 320px to right of screen

@loop_find_right:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = right edge of object window
		bls.s	@found_right				; branch if object is outside object window
		tst.b	4(a0)
		bpl.s	@no_respawn
		move.b	(a2),d2
		addq.b	#1,(a2)

	@no_respawn:
		bsr.w	OPL_SpawnObj				; check respawn flag and spawn object
		beq.s	@loop_find_right			; loop until object is found outside window

	@found_right:
		move.l	a0,(v_opl_ptr_right).w			; save pointer for objpos
		movea.l	(v_opl_ptr_left).w,a0			; jump to objpos on left side of window
		subi.w	#320+320+128,d6				; d6 = 128px to left of screen
		bcs.s	@found_left

@loop_find_left:
		cmp.w	(a0),d6					; (a0) = x pos of object; d6 = left edge of object window
		bls.s	@found_left				; branch if object is inside object window
		tst.b	4(a0)
		bpl.s	@no_respawn2
		addq.b	#1,1(a2)

	@no_respawn2:
		addq.w	#6,a0
		bra.s	@loop_find_left
; ===========================================================================

@found_left:
		move.l	a0,(v_opl_ptr_left).w

OPL_NoMove:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	load an object

; input:
;	d2 = position in respawn list
;	a0 = pointer to specific object in objpos list
;	a2 = v_respawn_list

; output:
;	d0 = 0 if object is spawned (or skipped because it was broken)
;	a1 = address of OST of spawned object
;	uses d1, a0
; ---------------------------------------------------------------------------

OPL_SpawnObj:
		tst.b	4(a0)					; is remember respawn flag set?
		bpl.s	OPL_MakeItem				; if not, branch
		bset	#7,2(a2,d2.w)				; set flag so it isn't loaded more than once
		beq.s	OPL_MakeItem				; branch if object hasn't already been destroyed
		addq.w	#6,a0					; goto next object in objpos list
		moveq	#0,d0
		rts	
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.w	(a0)+,ost_x_pos(a1)			; set x pos
		move.w	(a0)+,d0				; get y pos and x/yflip flags
		move.w	d0,d1
		andi.w	#$FFF,d0				; ignore x/yflip bits
		move.w	d0,ost_y_pos(a1)			; set y pos
		rol.w	#2,d1
		andi.b	#render_xflip+render_yflip,d1		; read only x/yflip bits
		move.b	d1,ost_render(a1)			; apply x/yflip
		move.b	d1,ost_status(a1)
		move.b	(a0)+,d0				; get object id
		bpl.s	@no_respawn_bit				; branch if remember respawn bit is not set
		andi.b	#$7F,d0					; ignore respawn bit
		move.b	d2,ost_respawn(a1)			; give object its place in the respawn table

	@no_respawn_bit:
		move.b	d0,ost_id(a1)				; load object
		move.b	(a0)+,ost_subtype(a1)			; set subtype
		moveq	#0,d0

	@fail:
		rts	
