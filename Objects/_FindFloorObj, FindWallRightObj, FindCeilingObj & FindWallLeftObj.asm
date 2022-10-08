; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the floor

; Runs FindFloor without the need for inputs, taking inputs from local OST variables

; input:
;	d3.w = x position of object (FindFloorObj2 only)

; output:
;	d1.w = distance to the floor
;	d3.b = floor angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = floor angle

;	uses d0.w, d2.w, d4.w, d5.l, d6.w
; ---------------------------------------------------------------------------

FindFloorObj:
		move.w	ost_x_pos(a0),d3


FindFloorObj2:
		move.w	ost_y_pos(a0),d2
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of bottom edge
		lea	(v_angle_right).w,a4			; write angle here
		move.b	#0,(a4)
		movea.w	#$10,a3					; height of a 16x16 tile
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#0,d3					; snap to flat floor

	.no_snap:
		rts

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its right

; Runs FindWall without the need for inputs, taking inputs from local OST variables

; input:
;	d3.w = x radius of object, right side

; output:
;	d1.w = distance to the wall
;	d3.b = wall angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = wall angle

;	uses d0.w, d3.w, d4.w, d5.l, d6.w
; ---------------------------------------------------------------------------

include_FindWallRightObj:	macro

FindWallRightObj:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		lea	(v_angle_right).w,a4			; write angle here
		move.b	#0,(a4)
		movea.w	#$10,a3					; width of a 16x16 tile
		move.w	#0,d6
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$C0,d3					; snap to flat right wall

	.no_snap:
		rts

		endm

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the ceiling

; Runs FindFloor without the need for inputs, taking inputs from local OST variables

; output:
;	d1.w = distance to the ceiling
;	d3.b = ceiling angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = ceiling angle

;	uses d0.w, d2.w, d4.w, d5.l, d6.w
; ---------------------------------------------------------------------------

include_FindCeilingObj:	macro

FindCeilingObj:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; height of a 16x16 tile
		move.w	#tilemap_yflip,d6			; eor mask
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$80,d3					; snap to flat ceiling

	.no_snap:
		rts

		endm

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its left

; Runs FindWall without the need for inputs, taking inputs from local OST variables

; input:
;	d3.w = x radius of object, left side (negative)

; output:
;	d1.w = distance to the wall
;	d3.b = wall angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1).w = 16x16 tile number, x/yflip, solidness
;	(a4).b = wall angle

;	uses d0.w, d3.w, d4.w, d5.l, d6.w
; ---------------------------------------------------------------------------

include_FindWallLeftObj:	macro

FindWallLeftObj:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		; Engine bug: colliding with left walls is erratic with this function.
		; Caused by a missing instruction to flip collision on the 16x16 block.
		;eori.w	#$F,d3					; enable this line to fix bug
		lea	(v_angle_right).w,a4			; write angle here
		move.b	#0,(a4)
		movea.w	#-$10,a3				; width of a 16x16 tile
		move.w	#tilemap_xflip,d6			; eor mask
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3					; is angle snap bit set?
		beq.s	.no_snap
		move.b	#$40,d3					; snap to flat left wall

	.no_snap:
		rts

		endm
