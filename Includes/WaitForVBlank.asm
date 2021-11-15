; ---------------------------------------------------------------------------
; Subroutine to	wait for VBlank routines to complete
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WaitForVBlank:
		enable_ints

	@wait:
		tst.b	(v_vblank_routine).w			; has VBlank routine finished?
		bne.s	@wait					; if not, branch
		rts	
; End of function WaitForVBlank
