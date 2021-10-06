; ---------------------------------------------------------------------------
; Subroutine to	play music for LZ/SBZ3 after a countdown
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ResumeMusic:
		cmpi.w	#12,(v_air).w	; more than 12 seconds of air left?
		bhi.s	@over12		; if yes, branch
		move.w	#bgm_LZ,d0	; play LZ music
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; check if level is 0103 (SBZ3)
		bne.s	@notsbz
		move.w	#bgm_SBZ,d0	; play SBZ music

	@notsbz:
		if Revision=0
		else
			tst.b	(v_invincibility).w ; is Sonic invincible?
			beq.s	@notinvinc ; if not, branch
			move.w	#bgm_Invincible,d0
	@notinvinc:
			tst.b	(f_boss_boundary).w ; is Sonic at a boss?
			beq.s	@playselected ; if not, branch
			move.w	#bgm_Boss,d0
	@playselected:
		endc

		jsr	(PlaySound).l

	@over12:
		move.w	#30,(v_air).w	; reset air to 30 seconds
		clr.b	(v_ost_all+$340+ost_drown_disp_time).w
		rts	
; End of function ResumeMusic
