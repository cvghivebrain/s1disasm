; ---------------------------------------------------------------------------
; Continue screen
; ---------------------------------------------------------------------------

GM_Continue:
		bsr.w	PaletteFadeOut
		disable_ints
		disable_display
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)				; normal colour mode
		move.w	#$8700,(a6)				; background colour
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear object RAM

		locVRAM	vram_Nem_TitleCard			; $B000
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec
		locVRAM	vram_cont_sonic				; $A000
		lea	(Nem_ContSonic).l,a0			; load oval & Sonic patterns
		bsr.w	NemDec
		locVRAM	vram_cont_minisonic			; $AA20
		lea	(Nem_MiniSonic).l,a0			; load mini Sonic patterns
		bsr.w	NemDec
		moveq	#10,d1
		jsr	(ContScrCounter).l			; run countdown	(start from 10)
		moveq	#id_Pal_Continue,d0
		bsr.w	PalLoad_Next				; load continue	screen palette
		play.b	0, bsr.w, mus_Continue			; play continue	music
		move.w	#659,(v_countdown).w			; set timer to 11 seconds
		clr.l	(v_camera_x_pos).w
		move.l	#$1000000,(v_camera_y_pos).w
		move.b	#id_ContSonic,(v_ost_player).w		; load Sonic object
		move.b	#id_ContScrItem,(v_ost_cont_text).w	; load continue screen objects
		move.b	#id_ContScrItem,(v_ost_cont_oval).w
		move.b	#3,(v_ost_cont_oval+ost_priority).w
		move.b	#id_frame_cont_oval,(v_ost_cont_oval+ost_frame).w ; set frame for oval object
		move.b	#id_ContScrItem,(v_ost_cont_minisonic).w ; load mini Sonic
		move.b	#id_CSI_MakeMiniSonic,(v_ost_cont_minisonic+ost_routine).w ; set routine for mini Sonic
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		enable_display
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#id_VBlank_Continue,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		cmpi.b	#id_CSon_Run,(v_ost_player+ost_routine).w ; is Sonic running?
		bhs.s	@sonic_running				; if yes, branch
		disable_ints
		move.w	(v_countdown).w,d1			; get counter
		divu.w	#60,d1					; convert to seconds
		andi.l	#$F,d1					; read only lowest nybble
		jsr	(ContScrCounter).l			; display countdown on screen
		enable_ints

	@sonic_running:
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		cmpi.w	#$180,(v_ost_player+ost_x_pos).w	; has Sonic run off screen?
		bhs.s	@goto_level				; if yes, branch
		cmpi.b	#id_CSon_Run,(v_ost_player+ost_routine).w
		bhs.s	Cont_MainLoop
		tst.w	(v_countdown).w				; is time left on countdown?
		bne.w	Cont_MainLoop				; if yes, branch
		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts	
; ===========================================================================

@goto_level:
		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_last_lamppost).w			; clear lamppost count
		subq.b	#1,(v_continues).w			; subtract 1 from continues
		rts	
