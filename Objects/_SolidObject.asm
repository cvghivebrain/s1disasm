; ---------------------------------------------------------------------------
; Solid	object subroutine (includes spikes, blocks, rocks etc)
;
; input:
;	d1 = width
;	d2 = height / 2 (when jumping)
;	d3 = height / 2 (when walking)
;	d4 = x-axis position
;
; output:
;	d4 = collision type: 1 = side collision; -1 = top/bottom collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SolidObject:
		tst.b	ost_solid(a0)	; is Sonic standing on the object?
		beq.w	Solid_ChkEnter	; if not, branch
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1) ; is Sonic in the air?
		bne.s	@leave		; if yes, branch
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	@leave		; if Sonic moves off the left, branch
		cmp.w	d2,d0		; has Sonic moved off the right?
		bcs.s	@stand		; if not, branch

	@leave:
		bclr	#status_platform_bit,ost_status(a1) ; clear Sonic's standing flag
		bclr	#status_platform_bit,ost_status(a0) ; clear object's standing flag
		clr.b	ost_solid(a0)
		moveq	#0,d4
		rts	

	@stand:
		move.w	d4,d2
		bsr.w	MoveWithPlatform
		moveq	#0,d4
		rts	
; ===========================================================================

SolidObject71:
		tst.b	ost_solid(a0)
		beq.w	Solid_ChkEnter2
		move.w	d1,d2
		add.w	d2,d2
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1)
		bne.s	@leave
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	@leave
		cmp.w	d2,d0
		bcs.s	@stand

	@leave:
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)
		moveq	#0,d4
		rts	

	@stand:
		move.w	d4,d2
		bsr.w	MoveWithPlatform
		moveq	#0,d4
		rts	
; ===========================================================================

SolidObject2F:
		lea	(v_ost_player).w,a1
		tst.b	ost_render(a0)
		bpl.w	Solid_Ignore
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.w	Solid_Ignore
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	Solid_Ignore
		move.w	d0,d5
		btst	#render_xflip_bit,ost_render(a0) ; is object horizontally flipped?
		beq.s	@notflipped	; if not, branch
		not.w	d5
		add.w	d3,d5

	@notflipped:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		move.w	ost_y_pos(a0),d5
		sub.w	d3,d5
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ost_y_pos(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	Solid_Ignore
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	Solid_Ignore
		bra.w	loc_FB0E
; ===========================================================================

Solid_ChkEnter:
		tst.b	ost_render(a0)	; is object onscreen?
		bpl.w	Solid_Ignore	; if not, branch

Solid_ChkEnter2:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0 ; d0: +ve if Sonic is right; -ve if Sonic is left
		add.w	d1,d0		; add width of object
		bmi.w	Solid_Ignore	; branch if Sonic is outside left boundary
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	Solid_Ignore	; branch if Sonic is outside right boundary
		
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2		; add ost_height to stated height
		move.w	ost_y_pos(a1),d3
		sub.w	ost_y_pos(a0),d3 ; d3: +ve if Sonic is below; -ve if Sonic is above
		addq.w	#4,d3
		add.w	d2,d3		; add total height of object
		bmi.w	Solid_Ignore	; branch if Sonic is outside upper boundary
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	Solid_Ignore	; branch if Sonic is outside lower boundary

loc_FB0E:
		tst.b	(f_lockmulti).w	; are controls locked?
		bmi.w	Solid_Ignore	; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dying?
		if Revision=0
			bcc.w	Solid_Ignore ; if yes, branch
		else
			bcc.w	Solid_Debug
		endc
		tst.w	(v_debuguse).w	; is debug mode being used?
		bne.w	Solid_Debug	; if yes, branch
		move.w	d0,d5
		cmp.w	d0,d1		; is Sonic right of centre of object?
		bcc.s	@isright	; if yes, branch
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

	@isright:
		move.w	d3,d1
		cmp.w	d3,d2		; is Sonic below centre of object?
		bcc.s	@isbelow	; if yes, branch

		subq.w	#4,d3
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

	@isbelow:
		cmp.w	d1,d5
		bhi.w	Solid_TopBottom	; if Sonic hits top or bottom, branch
		cmpi.w	#4,d1
		bls.s	Solid_SideAir
		tst.w	d0		; where is Sonic?
		beq.s	Solid_Centre	; if inside the object, branch
		bmi.s	Solid_Right	; if right of the object, branch
		tst.w	ost_x_vel(a1)	; is Sonic moving left?
		bmi.s	Solid_Centre	; if yes, branch
		bra.s	Solid_Left
; ===========================================================================

Solid_Right:
		tst.w	ost_x_vel(a1)	; is Sonic moving right?
		bpl.s	Solid_Centre	; if yes, branch

Solid_Left:
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1) ; stop Sonic moving

Solid_Centre:
		sub.w	d0,ost_x_pos(a1) ; correct Sonic's position
		btst	#status_air_bit,ost_status(a1) ; is Sonic in the air?
		bne.s	Solid_SideAir	; if yes, branch
		bset	#status_pushing_bit,ost_status(a1) ; make Sonic push object
		bset	#status_pushing_bit,ost_status(a0) ; make object be pushed
		moveq	#1,d4		; return side collision
		rts	
; ===========================================================================

Solid_SideAir:
		bsr.s	Solid_NotPushing
		moveq	#1,d4		; return side collision
		rts	
; ===========================================================================

Solid_Ignore:
		btst	#status_pushing_bit,ost_status(a0) ; is Sonic pushing?
		beq.s	Solid_Debug	; if not, branch
		move.w	#id_Run,ost_anim(a1) ; use running animation

Solid_NotPushing:
		bclr	#status_pushing_bit,ost_status(a0) ; clear pushing flag
		bclr	#status_pushing_bit,ost_status(a1) ; clear Sonic's pushing flag

Solid_Debug:
		moveq	#0,d4		; return no collision
		rts	
; ===========================================================================

Solid_TopBottom:
		tst.w	d3		; is Sonic below the object?
		bmi.s	Solid_Below	; if yes, branch
		cmpi.w	#$10,d3		; has Sonic landed on the object?
		bcs.s	Solid_Landed	; if yes, branch
		bra.s	Solid_Ignore
; ===========================================================================

Solid_Below:
		tst.w	ost_y_vel(a1)	; is Sonic moving vertically?
		beq.s	Solid_Squash	; if not, branch
		bpl.s	Solid_TopBtmAir	; if moving downwards, branch
		tst.w	d3		; is Sonic above the object?
		bpl.s	Solid_TopBtmAir	; if yes, branch
		sub.w	d3,ost_y_pos(a1) ; correct Sonic's position
		move.w	#0,ost_y_vel(a1) ; stop Sonic moving

Solid_TopBtmAir:
		moveq	#-1,d4
		rts	
; ===========================================================================

Solid_Squash:
		btst	#status_air_bit,ost_status(a1) ; is Sonic in the air?
		bne.s	Solid_TopBtmAir	; if yes, branch
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(KillSonic).l	; kill Sonic
		movea.l	(sp)+,a0
		moveq	#-1,d4
		rts	
; ===========================================================================

Solid_Landed:
		subq.w	#4,d3
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	ost_x_pos(a1),d1
		sub.w	ost_x_pos(a0),d1
		bmi.s	Solid_Miss	; if Sonic is right of object, branch
		cmp.w	d2,d1		; is Sonic left of object?
		bcc.s	Solid_Miss	; if yes, branch
		tst.w	ost_y_vel(a1)	; is Sonic moving upwards?
		bmi.s	Solid_Miss	; if yes, branch
		sub.w	d3,ost_y_pos(a1) ; correct Sonic's position
		subq.w	#1,ost_y_pos(a1)
		bsr.s	Solid_ResetFloor
		move.b	#2,ost_solid(a0) ; set standing flags
		bset	#status_platform_bit,ost_status(a0)
		moveq	#-1,d4		; return top/bottom collision
		rts	
; ===========================================================================

Solid_Miss:
		moveq	#0,d4
		rts	
; End of function SolidObject


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Solid_ResetFloor:
		btst	#status_platform_bit,ost_status(a1) ; is Sonic standing on something?
		beq.s	@notonobj	; if not, branch

		moveq	#0,d0
		move.b	ost_sonic_on_obj(a1),d0	; get OST index of object being stood on
		lsl.w	#6,d0
		addi.l	#(v_ost_all&$FFFFFF),d0
		movea.l	d0,a2
		bclr	#status_platform_bit,ost_status(a2) ; clear object's standing flags
		clr.b	ost_solid(a2)

	@notonobj:
		move.w	a0,d0
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,ost_sonic_on_obj(a1)	; set object being stood on
		move.b	#0,ost_angle(a1) ; clear Sonic's angle
		move.w	#0,ost_y_vel(a1) ; stop Sonic
		move.w	ost_x_vel(a1),ost_inertia(a1)
		btst	#status_air_bit,ost_status(a1) ; is Sonic in the air?
		beq.s	@notinair	; if not, branch
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l ; reset Sonic as if on floor
		movea.l	(sp)+,a0

	@notinair:
		bset	#status_platform_bit,ost_status(a1) ; set object standing flag
		bset	#status_platform_bit,ost_status(a0) ; set Sonic standing on object flag
		rts	
; End of function Solid_ResetFloor
