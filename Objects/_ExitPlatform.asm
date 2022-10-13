; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk or jump off	a platform

; input:
;	d1.w = half platform width, left side
;	d2.w = half platform width, right side (ExitPlatform2 only)

; output:
;	a1 = OST of Sonic

;	uses d0.w, d2.w

; usage:
;		moveq	#0,d1
;		move.b	ost_displaywidth(a0),d1
;		bsr.w	ExitPlatform
; ---------------------------------------------------------------------------

ExitPlatform:
		move.w	d1,d2					; platform is symmetrical

ExitPlatform2:							; jump here to use different value for d2 (only GHZ bridges use this)
		add.w	d2,d2
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	.reset					; if yes, branch
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0 = Sonic's distance from platform centre (-ve if left of centre)
		add.w	d1,d0
		bmi.s	.reset					; branch if Sonic is left of the platform
		cmp.w	d2,d0
		blo.s	.do_nothing				; branch if Sonic is not right of the platform

	.reset:
		bclr	#status_platform_bit,ost_status(a1)	; clear Sonic's platform bit
		move.b	#id_Plat_Solid,ost_routine(a0)		; set platform back to "detect mode" (all platforms use routine 2 for this)
		bclr	#status_platform_bit,ost_status(a0)	; clear platform's platform bit

	.do_nothing:
		rts
