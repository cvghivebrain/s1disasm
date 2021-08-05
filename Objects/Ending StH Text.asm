; ---------------------------------------------------------------------------
; Object 89 - "SONIC THE HEDGEHOG" text	on the ending sequence
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	ESth_Index(pc,d0.w),d1
		if Revision=0
		jmp	ESth_Index(pc,d1.w)
		else
		jsr	ESth_Index(pc,d1.w)
		jmp	(DisplaySprite).l
		endc
; ===========================================================================
ESth_Index:	index *,,2
		ptr ESth_Main
		ptr ESth_Move
		ptr ESth_GotoCredits

esth_time:	equ $30		; time until exit
; ===========================================================================

ESth_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#-$20,ost_x_pos(a0)	; object starts	outside	the level boundary
		move.w	#$D8,ost_y_screen(a0)
		move.l	#Map_ESTH,ost_mappings(a0)
		move.w	#tile_Nem_EndStH,ost_tile(a0)
		move.b	#render_abs,ost_render(a0)
		move.b	#0,ost_priority(a0)

ESth_Move:	; Routine 2
		cmpi.w	#$C0,ost_x_pos(a0)	; has object reached $C0?
		beq.s	ESth_Delay		; if yes, branch
		addi.w	#$10,ost_x_pos(a0)	; move object to the right
		if Revision=0
		bra.w	DisplaySprite
		else
		rts
		endc

ESth_Delay:
		addq.b	#2,ost_routine(a0)
		if Revision=0
		move.w	#120,esth_time(a0) ; set duration for delay (2 seconds)
		else
		move.w	#300,esth_time(a0) ; set duration for delay (5 seconds)
		endc

ESth_GotoCredits:
		; Routine 4
		subq.w	#1,esth_time(a0) ; subtract 1 from duration
		bpl.s	ESth_Wait
		move.b	#id_Credits,(v_gamemode).w ; exit to credits

	ESth_Wait:
		if Revision=0
		bra.w	DisplaySprite
		else
		rts
		endc
