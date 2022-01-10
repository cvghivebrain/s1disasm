; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the floor

; Runs FindFloor without the need for inputs, taking inputs from local OST variables

; input:
;	d3 = x pos. of object (FindFloorObj2 only)

; output:
;	d1 = distance to the floor
;	d3 = floor angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

FindFloorObj:
		move.w	ost_x_pos(a0),d3


FindFloorObj2:
		move.w	ost_y_pos(a0),d2
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3					; height of a 16x16 tile
		move.w	#0,d6
		moveq	#$D,d5					; bit to test for solidness
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14E4E
		move.b	#0,d3

	locret_14E4E:
		rts	

; End of function FindFloorObj2

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its right

; Runs FindWall without the need for inputs, taking inputs from local OST variables

; input:
;	d3 = x radius of object, right side

; output:
;	d1 = distance to the wall
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

include_FindWallRightObj:	macro

FindWallRightObj:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14F06
		move.b	#-$40,d3

locret_14F06:
		rts	

; End of function FindWallRightObj

		endm

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the ceiling

; Runs FindFloor without the need for inputs, taking inputs from local OST variables

; output:
;	d1 = distance to the ceiling
;	d3 = ceiling angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

include_FindCeilingObj:	macro

FindCeilingObj:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14FD4
		move.b	#$80,d3

locret_14FD4:
		rts	
; End of function FindCeilingObj

		endm

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the wall to its left

; Runs FindWall without the need for inputs, taking inputs from local OST variables

; input:
;	d3 = x radius of object, left side (negative)

; output:
;	d1 = distance to the wall
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

include_FindWallLeftObj:	macro

FindWallLeftObj:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		; Engine bug: colliding with left walls is erratic with this function.
		; The cause is this: a missing instruction to flip collision on the found
		; 16x16 block; this one:
		;eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_15098
		move.b	#$40,d3

locret_15098:
		rts	
; End of function FindWallLeftObj

		endm
