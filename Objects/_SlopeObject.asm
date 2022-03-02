; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	SLZ seesaws)
;
; input:
;	d1 = platform half width
;	a2 = address of heightmap data

; output:
;	d2 = Sonic's y position
;	d3 = height of platform where Sonic is standing
;	a1 = address of OST of Sonic
;	uses d0, d1, a2
; ---------------------------------------------------------------------------

SlopeObject:
		lea	(v_ost_player).w,a1
		tst.w	ost_y_vel(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on platform
		bmi.s	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit				; branch if Sonic is right of the platform

		btst	#render_xflip_bit,ost_render(a0)
		beq.s	@noflip
		not.w	d0
		add.w	d1,d0					; reverse position if platform is xflipped

	@noflip:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3				; get byte from heightmap
		move.w	ost_y_pos(a0),d0
		sub.w	d3,d0
		bra.w	Plat_NoXCheck_AltY			; detect y collision and make Sonic stand on the platform

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges, MZ platforms, SLZ seesaws)
; Assumes Sonic is already on the platform
;
; input:
;	d1 = platform half width
;	d2 = platform x position
;	a2 = address of heightmap data

; output:
;	d0 = Sonic's y position
;	d1 = Sonic's height
;	d3 = height of platform where Sonic is standing
;	a1 = address of OST of Sonic
;	uses d2
; ---------------------------------------------------------------------------

include_SlopeObject_NoChk:	macro

SlopeObject_NoChk:
		lea	(v_ost_player).w,a1
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on a platform?
		beq.s	@noplatform				; if not, branch

		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = x pos of Sonic on platform
		lsr.w	#1,d0
		btst	#render_xflip_bit,ost_render(a0)
		beq.s	@noflip
		not.w	d0
		add.w	d1,d0					; reverse position if platform is xflipped

	@noflip:
		moveq	#0,d1
		move.b	(a2,d0.w),d1				; get byte from heightmap
		move.w	ost_y_pos(a0),d0
		sub.w	d1,d0					; d0 = y pos of point on platform Sonic is standing
		moveq	#0,d1
		move.b	ost_height(a1),d1
		sub.w	d1,d0
		move.w	d0,ost_y_pos(a1)			; update Sonic's y position
		sub.w	ost_x_pos(a0),d2
		sub.w	d2,ost_x_pos(a1)			; d2 is always 0?

	@noplatform:
		rts

		endm
		
