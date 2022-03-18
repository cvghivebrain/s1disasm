; ---------------------------------------------------------------------------
; Object 44 - edge walls (GHZ)

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtypes 0/1/2/$10/$11/$12
; ---------------------------------------------------------------------------

include_EdgeWalls_1:	macro

EdgeWalls:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Edge_Index(pc,d0.w),d1
		jmp	Edge_Index(pc,d1.w)
; ===========================================================================
Edge_Index:	index *,,2
		ptr Edge_Main
		ptr Edge_Solid
		ptr Edge_Display
; ===========================================================================

Edge_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Edge_Solid next
		move.l	#Map_Edge,ost_mappings(a0)
		move.w	#tile_Nem_GhzWall2+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#8,ost_displaywidth(a0)
		move.b	#6,ost_priority(a0)
		move.b	ost_subtype(a0),ost_frame(a0)		; copy object type number to frame number
		bclr	#4,ost_frame(a0)			; clear 4th bit (deduct $10)
		beq.s	Edge_Solid				; branch if already clear (subtype 0/1/2 is solid)

		addq.b	#2,ost_routine(a0)			; goto Edge_Display next
		bra.s	Edge_Display				; bit 4 was already set (subtype $10/$11/$12 is not solid)
; ===========================================================================

Edge_Solid:	; Routine 2
		move.w	#$13,d1					; width
		move.w	#$28,d2					; height
		bsr.w	Edge_SolidWall

Edge_Display:	; Routine 4
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
		
		endm

; ---------------------------------------------------------------------------
; Object 44 - edge walls (GHZ), part 2
; ---------------------------------------------------------------------------

include_EdgeWalls_2:	macro

; ---------------------------------------------------------------------------
; Solid	object subroutine
;
; input:
;	d1 = width
;	d2 = height / 2
;
; output:
;	d4 = collision type: 0 = none; 1 = side collision; -1 = top/bottom collision
; ---------------------------------------------------------------------------

Edge_SolidWall:
		bsr.w	Edge_ChkCollision
		beq.s	@no_collision				; branch if no collision
		bmi.w	@topbottom				; branch if top/bottom collision
		tst.w	d0					; where is Sonic?
		beq.w	@centre					; if inside the object, branch
		bmi.s	@right					; if right of the object, branch
		tst.w	ost_x_vel(a1)				; is Sonic moving left?
		bmi.s	@centre					; if yes, branch
		bra.s	@left
; ===========================================================================

@right:
		tst.w	ost_x_vel(a1)				; is Sonic moving right?
		bpl.s	@centre					; if yes, branch

@left:
		sub.w	d0,ost_x_pos(a1)
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)			; stop Sonic moving

@centre:
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	@air					; if yes, branch
		bset	#status_pushing_bit,ost_status(a1)	; make Sonic push object
		bset	#status_pushing_bit,ost_status(a0)	; make object be pushed
		rts	
; ===========================================================================

@no_collision:
		btst	#status_pushing_bit,ost_status(a0)	; is Sonic pushing?
		beq.s	@exit					; if not, branch
		move.w	#id_Run,ost_anim(a1)			; use running animation

@air:
		bclr	#status_pushing_bit,ost_status(a0)	; clear pushing flag
		bclr	#status_pushing_bit,ost_status(a1)	; clear Sonic's pushing flag

	@exit:
		rts	
; ===========================================================================

@topbottom:
		tst.w	ost_y_vel(a1)				; is Sonic moving downwards?
		bpl.s	@exit2					; if yes, branch
		tst.w	d3					; is Sonic above the object?
		bpl.s	@exit2					; if yes, branch
		sub.w	d3,ost_y_pos(a1)			; correct Sonic's position
		move.w	#0,ost_y_vel(a1)			; stop Sonic moving

	@exit2:
		rts	
; End of function Edge_SolidWall

Edge_ChkCollision:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0: +ve if Sonic is right; -ve if Sonic is left
		add.w	d1,d0					; add width of object
		bmi.s	Edge_Ignore				; branch if Sonic is outside left boundary
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	Edge_Ignore				; branch if Sonic is outside right boundary

		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2					; add ost_height to stated height
		move.w	ost_y_pos(a1),d3
		sub.w	ost_y_pos(a0),d3			; d3: +ve if Sonic is below; -ve if Sonic is above
		add.w	d2,d3					; add total height of object
		bmi.s	Edge_Ignore				; branch if Sonic is outside upper boundary
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	Edge_Ignore				; branch if Sonic is outside lower boundary

		tst.b	(v_lock_multi).w			; are controls locked?
		bmi.s	Edge_Ignore				; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dying?
		bhs.s	Edge_Ignore				; if yes, branch
		tst.w	(v_debug_active).w			; is debug mode being used?
		bne.s	Edge_Ignore				; if yes, branch
		move.w	d0,d5
		cmp.w	d0,d1					; is Sonic right of centre of object?
		bhs.s	@isright				; if yes, branch
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

	@isright:
		move.w	d3,d1
		cmp.w	d3,d2					; is Sonic below centre of object?
		bhs.s	@isbelow				; if yes, branch
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

	@isbelow:
		cmp.w	d1,d5
		bhi.s	Edge_TopBottom
		moveq	#1,d4
		rts	
; ===========================================================================

Edge_TopBottom:
		moveq	#-1,d4
		rts	
; ===========================================================================

Edge_Ignore:
		moveq	#0,d4
		rts	
; End of function Edge_ChkCollision

		endm
		
