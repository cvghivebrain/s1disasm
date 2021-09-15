; ---------------------------------------------------------------------------
; Add points subroutine
;
; input:
;	d0 = points to add (appears as *10 larger on the HUD)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AddPoints:
		move.b	#1,(f_scorecount).w ; set score counter to update

		if Revision=0
			lea	(v_scorecopy).w,a2
			lea	(v_score).w,a3
			add.l	d0,(a3)		; add d0*10 to the score
			move.l	#999999,d1
			cmp.l	(a3),d1		; is score below 999999?
			bhi.w	@belowmax	; if yes, branch
			move.l	d1,(a3)		; reset	score to 999999
			move.l	d1,(a2)

		@belowmax:
			move.l	(a3),d0
			cmp.l	(a2),d0
			blo.w	@locret_1C6B6
			move.l	d0,(a2)

		else

			lea     (v_score).w,a3
			add.l   d0,(a3)
			move.l  #999999,d1
			cmp.l   (a3),d1 ; is score below 999999?
			bhi.s   @belowmax ; if yes, branch
			move.l  d1,(a3) ; reset score to 999999
		@belowmax:
			move.l  (a3),d0
			cmp.l   (v_scorelife).w,d0 ; has Sonic got 50000+ points?
			blo.s   @noextralife ; if not, branch

			addi.l  #5000,(v_scorelife).w ; increase requirement by 50000
			tst.b   (v_megadrive).w
			bmi.s   @noextralife ; branch if Mega Drive is Japanese
			addq.b  #1,(v_lives).w ; give extra life
			addq.b  #1,(f_lifecount).w
			music	bgm_ExtraLife,1,0,0
		endc

@locret_1C6B6:
@noextralife:
		rts	
; End of function AddPoints
