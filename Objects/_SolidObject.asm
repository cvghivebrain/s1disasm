; ---------------------------------------------------------------------------
; Solid	object subroutine (includes spikes, blocks, rocks etc)
;
; input:
;	d1 = object half width
;	d2 = object half height (initial collision)
;	d3 = object half height (when stood on object)
;	d4 = object x position (when stood on object)
;
; output:
;	d3 = y distance of Sonic from nearest top/bottom edge (-ve if on bottom)
;	d4 = collision type: 0 = none/no change; 1 = side collision; -1 = top/bottom collision
;	d5 = x distance of Sonic from nearest left/right edge
;	a1 = address of OST of Sonic
;	uses d0, d1, d2, a2
; ---------------------------------------------------------------------------

SolidObject:
		tst.b	ost_solid(a0)				; is Sonic standing on the object?
		beq.w	Solid_ChkCollision			; if not, branch
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	.leave					; if yes, branch
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on object
		bmi.s	.leave					; if Sonic moves off the left, branch
		cmp.w	d2,d0					; has Sonic moved off the right?
		bcs.s	.stand					; if not, branch

	.leave:
		bclr	#status_platform_bit,ost_status(a1)	; clear Sonic's standing flag
		bclr	#status_platform_bit,ost_status(a0)	; clear object's standing flag
		clr.b	ost_solid(a0)
		moveq	#0,d4					; clear flag for no collision
		rts	

	.stand:
		move.w	d4,d2
		bsr.w	MoveWithPlatform
		moveq	#0,d4					; clear flag for no new collision
		rts

; ---------------------------------------------------------------------------
; As above, but the object's on-screen status is not checked
; ---------------------------------------------------------------------------

SolidObject_NoRenderChk:
		tst.b	ost_solid(a0)
		beq.w	Solid_SkipRenderChk
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1)
		bne.s	.leave
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.leave
		cmp.w	d2,d0
		bcs.s	.stand

	.leave:
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)
		moveq	#0,d4
		rts	

	.stand:
		move.w	d4,d2
		bsr.w	MoveWithPlatform
		moveq	#0,d4
		rts	

; ---------------------------------------------------------------------------
; Solid	object with heightmap subroutine (MZ grass platforms)
;
; input:
;	d1 = object half width
;	d2 = object half height
;	a2 = address of heightmap data
;
; output:
;	d4 = collision type: 1 = side collision; -1 = top/bottom collision
;	d5 = x distance of Sonic from nearest left/right edge
;	a1 = address of OST of Sonic
;	uses d0, d1, d2, d3, a2
; ---------------------------------------------------------------------------

SolidObject_Heightmap:
		lea	(v_ost_player).w,a1
		tst.b	ost_render(a0)
		bpl.w	Solid_NoCollision			; branch if object is off screen
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on object
		bmi.w	Solid_NoCollision			; branch if Sonic is outside left edge
		move.w	d1,d3
		add.w	d3,d3					; d3 = full width of object
		cmp.w	d3,d0
		bhi.w	Solid_NoCollision			; branch if Sonic is outside right edge

		move.w	d0,d5
		btst	#render_xflip_bit,ost_render(a0)	; is object horizontally flipped?
		beq.s	.no_xflip				; if not, branch
		not.w	d5
		add.w	d3,d5					; d5 = x pos of Sonic on object, xflipped if needed

	.no_xflip:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3				; get heightmap value based on Sonic's position on platform
		sub.b	(a2),d3					; subtract baseline
		move.w	ost_y_pos(a0),d5
		sub.w	d3,d5					; d5 = y pos of spot where Sonic is standing
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2					; d2 = combined Sonic + object half height
		move.w	ost_y_pos(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3					; d3 = y dist of Sonic's feet from spot
		bmi.w	Solid_NoCollision			; branch if Sonic is above spot
		move.w	d2,d4
		add.w	d4,d4					; d4 = combined Sonic + object full height
		cmp.w	d4,d3
		bcc.w	Solid_NoCollision			; branch if Sonic is below object
		bra.w	Solid_Collision
; ===========================================================================

Solid_ChkCollision:
		tst.b	ost_render(a0)				; is object onscreen?
		bpl.w	Solid_NoCollision			; if not, branch

Solid_SkipRenderChk:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on object
		bmi.w	Solid_NoCollision			; branch if Sonic is outside left edge
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	Solid_NoCollision			; branch if Sonic is outside right edge
		
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2					; d2 = combined Sonic + object half height
		move.w	ost_y_pos(a1),d3
		sub.w	ost_y_pos(a0),d3			; d3 = y pos of Sonic on object (0 is centre)
		addq.w	#4,d3
		add.w	d2,d3					; d3 = y pos of Sonic's feet on object (0 is top)
		bmi.w	Solid_NoCollision			; branch if Sonic is outside upper edge
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	Solid_NoCollision			; branch if Sonic is outside lower edge

Solid_Collision:
		tst.b	(v_lock_multi).w			; are controls locked?
		bmi.w	Solid_NoCollision			; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dying?
		if Revision=0
			bcc.w	Solid_NoCollision		; if yes, branch
		else
			bcc.w	Solid_Debug
		endc
		tst.w	(v_debug_active).w			; is debug mode being used?
		bne.w	Solid_Debug				; if yes, branch
		move.w	d0,d5					; d0/d5 = x pos of Sonic on object
		cmp.w	d0,d1					; d1 = object half width
		bcc.s	.sonic_left				; branch if Sonic is on the left side
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5					; d5 = x dist of Sonic from left/right edge (nearest)

	.sonic_left:
		move.w	d3,d1					; d1/d3 = y pos of Sonic's feet on object
		cmp.w	d3,d2					; d2 = object half height
		bcc.s	.sonic_top				; branch if Sonic is on top half

		subq.w	#4,d3
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1					; d1 = y dist of Sonic from top/bottom edge (nearest)

	.sonic_top:
		cmp.w	d1,d5
		bhi.w	Solid_TopBottom				; branch if Sonic is nearer top/bottom than left/right
		cmpi.w	#4,d1
		bls.s	Solid_SideAir				; branch if Sonic is within 4px of top/bottom
		tst.w	d0					; d0 = x dist of Sonic from left/right edge (-ve if on right)
		beq.s	Solid_AlignToSide			; branch if on the edge
		bmi.s	Solid_OnRight				; branch if nearer right side

		tst.w	ost_x_vel(a1)
		bmi.s	Solid_AlignToSide			; branch if Sonic is moving left
		bra.s	Solid_StopX
; ===========================================================================

Solid_OnRight:
		tst.w	ost_x_vel(a1)
		bpl.s	Solid_AlignToSide			; branch if Sonic is moving right

Solid_StopX:
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)			; stop Sonic moving

Solid_AlignToSide:
		sub.w	d0,ost_x_pos(a1)			; correct Sonic's position
		btst	#status_air_bit,ost_status(a1)
		bne.s	Solid_SideAir				; branch if Sonic is in the air
		bset	#status_pushing_bit,ost_status(a1)	; make Sonic push object
		bset	#status_pushing_bit,ost_status(a0)	; make object be pushed
		moveq	#1,d4					; return side collision
		rts	
; ===========================================================================

Solid_SideAir:
		bsr.s	Solid_NotPushing			; don't push if Sonic is jumping or close to top/bottom edges
		moveq	#1,d4					; return side collision
		rts	
; ===========================================================================

Solid_NoCollision:
		btst	#status_pushing_bit,ost_status(a0)	; is Sonic pushing?
		beq.s	Solid_Debug				; if not, branch
		move.w	#id_Run,ost_anim(a1)			; use running animation

Solid_NotPushing:
		bclr	#status_pushing_bit,ost_status(a0)	; clear pushing flag
		bclr	#status_pushing_bit,ost_status(a1)	; clear Sonic's pushing flag

Solid_Debug:
		moveq	#0,d4					; return no collision
		rts	
; ===========================================================================

Solid_TopBottom:
		tst.w	d3					; d3 = y dist of Sonic from top/bottom edge (-ve if on bottom)
		bmi.s	Solid_Below				; branch if Sonic is nearer bottom
		cmpi.w	#$10,d3
		bcs.s	Solid_Landed				; branch if within 16px of top edge
		bra.s	Solid_NoCollision
; ===========================================================================

Solid_Below:
		tst.w	ost_y_vel(a1)
		beq.s	Solid_Squash				; branch if Sonic isn't moving up/down
		bpl.s	Solid_TopBtmAir				; branch if moving downwards
		tst.w	d3
		bpl.s	Solid_TopBtmAir				; branch if nearer top (he can't be)
		sub.w	d3,ost_y_pos(a1)			; correct Sonic's position
		move.w	#0,ost_y_vel(a1)			; stop Sonic moving

Solid_TopBtmAir:
		moveq	#-1,d4					; return top/bottom collision
		rts	
; ===========================================================================

Solid_Squash:
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	Solid_TopBtmAir				; if yes, branch
		pushr	a0					; save address of OST of current object to stack
		movea.l	a1,a0					; temporarily make Sonic the current object
		jsr	(KillSonic).l				; kill Sonic
		popr	a0					; restore address of OST of current object from stack
		moveq	#-1,d4					; return top/bottom collision
		rts	
; ===========================================================================

Solid_Landed:
		subq.w	#4,d3
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		move.w	d1,d2
		add.w	d2,d2					; d2 = full width of object
		add.w	ost_x_pos(a1),d1
		sub.w	ost_x_pos(a0),d1			; d1 = x pos of Sonic on object
		bmi.s	Solid_Miss				; branch if Sonic is outside left edge
		cmp.w	d2,d1
		bcc.s	Solid_Miss				; branch if Sonic is outside right edge
		tst.w	ost_y_vel(a1)
		bmi.s	Solid_Miss				; branch if Sonic is moving upwards
		sub.w	d3,ost_y_pos(a1)			; correct Sonic's position
		subq.w	#1,ost_y_pos(a1)			; move Sonic up 1px
		bsr.s	Solid_ResetFloor			; make Sonic stand on object
		move.b	#2,ost_solid(a0)			; set flag that Sonic is standing on the object
		bset	#status_platform_bit,ost_status(a0)	; set object's platform flag
		moveq	#-1,d4					; return top/bottom collision
		rts	
; ===========================================================================

Solid_Miss:
		moveq	#0,d4					; return no collision
		rts

; ---------------------------------------------------------------------------
; Subroutine to reset platform flags and store the OST index of the object
; being stood on
; ---------------------------------------------------------------------------

Solid_ResetFloor:
		btst	#status_platform_bit,ost_status(a1)	; is Sonic standing on something?
		beq.s	.notonobj				; if not, branch

		moveq	#0,d0
		move.b	ost_sonic_on_obj(a1),d0			; get OST index of object being stood on
		lsl.w	#6,d0
		addi.l	#(v_ost_all&$FFFFFF),d0
		movea.l	d0,a2					; a2 = address of OST of object being stood on
		bclr	#status_platform_bit,ost_status(a2)	; clear object's standing flags
		clr.b	ost_solid(a2)

	.notonobj:
		move.w	a0,d0
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0					; convert object's OST address to index
		move.b	d0,ost_sonic_on_obj(a1)			; save index of object being stood on
		move.b	#0,ost_angle(a1)			; clear Sonic's angle
		move.w	#0,ost_y_vel(a1)			; stop Sonic
		move.w	ost_x_vel(a1),ost_inertia(a1)
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		beq.s	.notinair				; if not, branch
		pushr	a0					; save address of OST of current object to stack
		movea.l	a1,a0					; temporarily make Sonic the current object
		jsr	(Sonic_ResetOnFloor).l			; reset Sonic as if on floor
		popr	a0					; restore address of OST of current object from stack

	.notinair:
		bset	#status_platform_bit,ost_status(a1)	; set object standing flag
		bset	#status_platform_bit,ost_status(a0)	; set Sonic standing on object flag
		rts
