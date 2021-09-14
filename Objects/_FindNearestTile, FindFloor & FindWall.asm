; ---------------------------------------------------------------------------
; Subroutine to	find which tile	the object is standing on

; input:
;	d2 = y position of object's bottom edge
;	d3 = x position of object

; output:
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindNearestTile:
		move.w	d2,d0		; get y pos. of bottom edge of object
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1		; get x pos. of object
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0		; combine
		moveq	#-1,d1
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1	; get 256x256 tile number
		beq.s	@blanktile	; branch if 0
		bmi.s	@specialtile	; branch if >$7F
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

@blanktile:
		movea.l	d1,a1
		rts	
; ===========================================================================

@specialtile:
		andi.w	#$7F,d1
		btst	#render_behind_bit,ost_render(a0) ; is object "behind a loop"?
		beq.s	@treatasnormal	; if not, branch
		addq.w	#1,d1
		cmpi.w	#$29,d1		; is 256x256 tile number $28?
		bne.s	@treatasnormal	; if not, branch
		move.w	#$51,d1		; replace with $50

	@treatasnormal:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts	
; End of function FindNearestTile

; ---------------------------------------------------------------------------
; Subroutine to	find the floor

; input:
;	d2 = y position of object's bottom edge
;	d3 = x position of object
;	d5 = bit to test for solidness: $D = top solid; $E = left/right/bottom solid
;	a3 = height of 16x16 tiles: $10 or -$10 if object is inverted
;	a4 = RAM address to write angle byte

; output:
;	d1 = distance to the floor
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFloor:
		bsr.s	FindNearestTile
		move.w	(a1),d0		; get value for solidness, orientation and 16x16 tile number
		move.w	d0,d4
		andi.w	#$7FF,d0	; ignore solid/orientation bits
		beq.s	@isblank	; branch if tile is blank
		btst	d5,d4		; is the tile solid?
		bne.s	@issolid	; if yes, branch

@isblank:
		add.w	a3,d2
		bsr.w	FindFloor2	; try tile below the nearest
		sub.w	a3,d2
		addi.w	#$10,d1		; return distance to floor
		rts	
; ===========================================================================

@issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0	; get collision block number
		andi.w	#$FF,d0
		beq.s	@isblank	; branch if 0
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)	; get collision angle value
		lsl.w	#4,d0
		move.w	d3,d1		; get x pos. of object
		btst	#$B,d4		; is block flipped horizontally?
		beq.s	@noflip		; if not, branch
		not.w	d1
		neg.b	(a4)

	@noflip:
		btst	#$C,d4		; is block flipped vertically?
		beq.s	@noflip2	; if not, branch
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	@noflip2:
		andi.w	#$F,d1
		add.w	d0,d1		; (block num. * $10) + x pos. = place in array
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0	; get collision height
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4		; is block flipped vertically?
		beq.s	@noflip3	; if not, branch
		neg.w	d0

	@noflip3:
		tst.w	d0
		beq.s	@isblank	; branch if height is 0
		bmi.s	@negfloor	; branch if height is negative
		cmpi.b	#$10,d0
		beq.s	@maxfloor	; branch if height is $10 (max)
		move.w	d2,d1		; get y pos. of object
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1		; return distance to floor
		rts	
; ===========================================================================

@negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	@isblank

@maxfloor:
		sub.w	a3,d2
		bsr.w	FindFloor2	; try tile above the nearest
		add.w	a3,d2
		subi.w	#$10,d1		; return distance to floor
		rts	
; End of function FindFloor


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFloor2:
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	@isblank2
		btst	d5,d4
		bne.s	@issolid

@isblank2:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts	
; ===========================================================================

@issolid:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	@isblank2
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	@noflip
		not.w	d1
		neg.b	(a4)

	@noflip:
		btst	#$C,d4
		beq.s	@noflip2
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

	@noflip2:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray1).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	@noflip3
		neg.w	d0

	@noflip3:
		tst.w	d0
		beq.s	@isblank2
		bmi.s	@negfloor
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

@negfloor:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	@isblank2
		not.w	d1
		rts	
; End of function FindFloor2

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindWall:
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_14B1E
		btst	d5,d4
		bne.s	loc_14B2C

loc_14B1E:
		add.w	a3,d3
		bsr.w	FindWall2
		sub.w	a3,d3
		addi.w	#$10,d1
		rts	
; ===========================================================================

loc_14B2C:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_14B1E
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_14B5A
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_14B5A:
		btst	#$B,d4
		beq.s	loc_14B62
		neg.b	(a4)

loc_14B62:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_14B7E
		neg.w	d0

loc_14B7E:
		tst.w	d0
		beq.s	loc_14B1E
		bmi.s	loc_14B9A
		cmpi.b	#$10,d0
		beq.s	loc_14BA6
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14B9A:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_14B1E

loc_14BA6:
		sub.w	a3,d3
		bsr.w	FindWall2
		add.w	a3,d3
		subi.w	#$10,d1
		rts	
; End of function FindWall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindWall2:
		bsr.w	FindNearestTile
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_14BC6
		btst	d5,d4
		bne.s	loc_14BD4

loc_14BC6:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14BD4:
		movea.l	(v_collindex).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_14BC6
		lea	(AngleMap).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_14C02
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_14C02:
		btst	#$B,d4
		beq.s	loc_14C0A
		neg.b	(a4)

loc_14C0A:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(CollArray2).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_14C26
		neg.w	d0

loc_14C26:
		tst.w	d0
		beq.s	loc_14BC6
		bmi.s	loc_14C3C
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts	
; ===========================================================================

loc_14C3C:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_14BC6
		not.w	d1
		rts	
; End of function FindWall2
