; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	SLZ seesaws)
;
; input:
;	d1 = platform width
;	a2 = address of heightmap data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SlopeObject:
		lea	(v_player).w,a1
		tst.w	ost_y_vel(a1)	; is Sonic moving up/jumping?
		bmi.w	Plat_Exit	; if yes, branch

		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	Plat_Exit	; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit	; branch if Sonic is right of the platform

		btst	#render_xflip_bit,ost_render(a0)
		beq.s	@noflip
		not.w	d0
		add.w	d1,d0

	@noflip:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3	; get byte from heightmap
		move.w	ost_y_pos(a0),d0
		sub.w	d3,d0
		bra.w	Plat_NoXCheck_AltY ; detect y collision and make Sonic stand on the platform
; End of function SlopeObject
