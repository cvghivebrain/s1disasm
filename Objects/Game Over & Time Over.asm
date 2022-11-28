; ---------------------------------------------------------------------------
; Object 39 - "GAME OVER" and "TIME OVER"

; spawned by:
;	SonicPlayer
; ---------------------------------------------------------------------------

GameOverCard:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Over_Index(pc,d0.w),d1
		jmp	Over_Index(pc,d1.w)
; ===========================================================================
Over_Index:	index offset(*),,2
		ptr Over_ChkPLC
		ptr Over_Move
		ptr Over_Wait
; ===========================================================================

Over_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; are the pattern load cues empty?
		beq.s	Over_Main				; if yes, branch
		rts	
; ===========================================================================

Over_Main:
		addq.b	#2,ost_routine(a0)			; goto Over_Move next
		move.w	#screen_left-48,ost_x_pos(a0)		; set x position (starts outside screen)
		btst	#0,ost_frame(a0)			; is the object "OVER"?
		beq.s	.not_over				; if not, branch
		move.w	#screen_right+48,ost_x_pos(a0)		; set x position for "OVER" (starts outside screen)

	.not_over:
		move.w	#screen_top+112,ost_y_screen(a0)
		move.l	#Map_Over,ost_mappings(a0)
		move.w	#tile_Nem_GameOver+tile_hi,ost_tile(a0)
		move.b	#render_abs,ost_render(a0)
		move.b	#0,ost_priority(a0)

Over_Move:	; Routine 2
		moveq	#16,d1					; set horizontal speed
		cmpi.w	#screen_left+160,ost_x_pos(a0)		; has object reached its target position?
		beq.s	.next					; if yes, branch
		bcs.s	.not_over				; branch if object is left of target (GAME/TIME)
		neg.w	d1					; move left instead

	.not_over:
		add.w	d1,ost_x_pos(a0)			; update x position
		bra.w	DisplaySprite

.next:
		move.w	#720,ost_anim_time(a0)			; set time delay to 12 seconds
		addq.b	#2,ost_routine(a0)			; goto Over_Wait next
		rts	
; ===========================================================================

Over_Wait:	; Routine 4
		move.b	(v_joypad_press_actual).w,d0
		andi.b	#btnABC,d0				; is button A, B or C pressed?
		bne.s	Over_ChgMode				; if yes, branch
		btst	#0,ost_frame(a0)			; is object "OVER"?
		bne.s	Over_Display				; if yes, branch
		tst.w	ost_anim_time(a0)			; has time delay reached zero?
		beq.s	Over_ChgMode				; if yes, branch
		subq.w	#1,ost_anim_time(a0)			; subtract 1 from time delay
		bra.w	DisplaySprite
; ===========================================================================

Over_ChgMode:
		tst.b	(f_time_over).w				; is time over flag set?
		bne.s	Over_ResetLvl				; if yes, branch
		move.b	#id_Continue,(v_gamemode).w		; set mode to $14 (continue screen)
		tst.b	(v_continues).w				; do you have any continues?
		bne.s	Over_Display				; if yes, branch
		move.b	#id_Sega,(v_gamemode).w			; set mode to 0 (Sega screen)
		bra.s	Over_Display
; ===========================================================================

Over_ResetLvl:
		if Revision=0
		else
			clr.l	(v_time_lampcopy).w
		endc
		move.w	#1,(f_restart).w			; restart level

Over_Display:
		bra.w	DisplaySprite
