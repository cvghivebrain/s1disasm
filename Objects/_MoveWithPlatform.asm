; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
;
; input:
;	d2 = platform x position
;	d3 = platform height
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveWithPlatform:
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a0),d0
		sub.w	d3,d0
		bra.s	MWP_MoveSonic


MoveWithPlatform2:			; jump here to use standard height (9)
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a0),d0
		subi.w	#9,d0

	MWP_MoveSonic:
		tst.b	(v_lock_multi).w
		bmi.s	MWP_End
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dying?
		bhs.s	MWP_End		; if yes, branch
		tst.w	(v_debug_active).w	; is debug mode in use?
		bne.s	MWP_End		; if yes, branch
		moveq	#0,d1
		move.b	ost_height(a1),d1
		sub.w	d1,d0
		move.w	d0,ost_y_pos(a1)
		sub.w	ost_x_pos(a0),d2
		sub.w	d2,ost_x_pos(a1)

	MWP_End:
		rts	
; End of function MoveWithPlatform2
