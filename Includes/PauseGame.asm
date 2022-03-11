; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

PauseGame:
		nop	
		tst.b	(v_lives).w				; do you have any lives	left?
		beq.s	Unpause					; if not, branch
		tst.w	(f_pause).w				; is game already paused?
		bne.s	@paused					; if yes, branch
		btst	#bitStart,(v_joypad_press_actual).w	; is Start button pressed?
		beq.s	Pause_DoNothing				; if not, branch

	@paused:
		move.w	#1,(f_pause).w				; set pause flag (also stops palette/gfx animations, time)
		move.b	#1,(v_snddriver_ram+f_pause_sound).w	; pause music

Pause_Loop:
		move.b	#id_VBlank_Pause,(v_vblank_routine).w
		bsr.w	WaitForVBlank				; wait for next frame
		tst.b	(f_slowmotion_cheat).w			; is slow-motion cheat on?
		beq.s	@chk_start				; if not, branch
		btst	#bitA,(v_joypad_press_actual).w		; is button A pressed?
		beq.s	@chk_bc					; if not, branch

		move.b	#id_Title,(v_gamemode).w		; set game mode to 4 (title screen)
		nop	
		bra.s	Unpause_Music
; ===========================================================================

	@chk_bc:
		btst	#bitB,(v_joypad_hold_actual).w		; is button B held?
		bne.s	Pause_SlowMo				; if yes, branch
		btst	#bitC,(v_joypad_press_actual).w		; is button C pressed?
		bne.s	Pause_SlowMo				; if yes, branch

	@chk_start:
		btst	#bitStart,(v_joypad_press_actual).w	; is Start button pressed?
		beq.s	Pause_Loop				; if not, branch

Unpause_Music:
		move.b	#$80,(v_snddriver_ram+f_pause_sound).w	; unpause the music

Unpause:
		move.w	#0,(f_pause).w				; unpause the game

Pause_DoNothing:
		rts	
; ===========================================================================

Pause_SlowMo:
		move.w	#1,(f_pause).w
		move.b	#$80,(v_snddriver_ram+f_pause_sound).w	; unpause the music
		rts
