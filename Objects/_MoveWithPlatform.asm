; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
;
; input:
;	d2 = platform x position
;	d3 = platform height (MoveWithPlatform only)

; output:
;	d1 = Sonic's height
;	a1 = address of OST of Sonic
;	uses d0, d2
; ---------------------------------------------------------------------------

MoveWithPlatform:
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a0),d0
		sub.w	d3,d0					; d0 = y position of top of platform
		bra.s	MWP_MoveSonic


MoveWithPlatform2:						; jump here to use standard height (9)
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a0),d0
		subi.w	#9,d0					; d0 = y position of top of platform

	MWP_MoveSonic:
		tst.b	(v_lock_multi).w			; is object collision disabled?
		bmi.s	@exit					; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dying?
		bhs.s	@exit					; if yes, branch
		tst.w	(v_debug_active).w			; is debug mode in use?
		bne.s	@exit					; if yes, branch
		moveq	#0,d1
		move.b	ost_height(a1),d1
		sub.w	d1,d0
		move.w	d0,ost_y_pos(a1)			; update Sonic's y position
		sub.w	ost_x_pos(a0),d2
		sub.w	d2,ost_x_pos(a1)			; update Sonic's x position

	@exit:
		rts
