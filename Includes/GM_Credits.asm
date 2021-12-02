; ---------------------------------------------------------------------------
; Credits ending sequence
; ---------------------------------------------------------------------------

GM_Credits:
		bsr.w	ClearPLC				; clear PLC buffer
		bsr.w	PaletteFadeOut				; fade out from previous gamemode
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)				; normal colour mode
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$9001,(a6)				; 64x32 cell plane size
		move.w	#$9200,(a6)				; window vertical position
		move.w	#$8B03,(a6)				; line scroll mode
		move.w	#$8720,(a6)				; set background colour (line 3; colour 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear object RAM

		locVRAM	vram_credits
		lea	(Nem_CreditText).l,a0			; load credits alphabet graphics
		bsr.w	NemDec

		lea	(v_pal_dry_next).w,a1
		moveq	#0,d0
		move.w	#(sizeof_pal_all/4)-1,d1
	@clear_pal:
		move.l	d0,(a1)+
		dbf	d1,@clear_pal				; fill palette with black

		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad_Next				; load Sonic's palette
		move.b	#id_CreditsText,(v_ost_credits).w	; load credits object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	EndingDemoLoad				; setup for next mini-demo
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		lsl.w	#4,d0					; multiply by $10 (size of each level header)
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2				; jump to relevant level header
		moveq	#0,d0
		move.b	(a2),d0					; get 1st PLC id for level
		beq.s	@no_plc					; branch if 0
		bsr.w	AddPLC					; load level graphics over next few frames

	@no_plc:
		moveq	#id_PLC_Main2,d0
		bsr.w	AddPLC					; load graphics for monitors/shield/stars over next few frames
		move.w	#120,(v_countdown).w			; display a credit for 2 seconds
		bsr.w	PaletteFadeIn				; fade credits text in from black

Cred_WaitLoop:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	RunPLC
		tst.w	(v_countdown).w				; have 2 seconds elapsed?
		bne.s	Cred_WaitLoop				; if not, branch
		tst.l	(v_plc_buffer).w			; have level gfx finished decompressing?
		bne.s	Cred_WaitLoop				; if not, branch
		cmpi.w	#9,(v_credits_num).w			; have the credits finished?
		beq.w	TryAgainEnd				; if yes, branch
		rts	

; ---------------------------------------------------------------------------
; Ending sequence demo loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


EndingDemoLoad:
		move.w	(v_credits_num).w,d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	EndDemoLevelArray(pc,d0.w),d0		; load level array
		move.w	d0,(v_zone).w				; set level from level array
		addq.w	#1,(v_credits_num).w
		cmpi.w	#9,(v_credits_num).w			; have credits finished?
		bhs.s	EndDemo_Exit				; if yes, branch
		move.w	#$8001,(v_demo_mode).w			; set demo+ending mode
		move.b	#id_Demo,(v_gamemode).w			; set game mode to 8 (demo)
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_last_lamppost).w			; clear lamppost counter
		cmpi.w	#4,(v_credits_num).w			; is SLZ demo running?
		bne.s	EndDemo_Exit				; if not, branch
		lea	(EndDemo_LampVar).l,a1			; load lamppost variables
		lea	(v_last_lamppost).w,a2
		move.w	#8,d0

	EndDemo_LampLoad:
		move.l	(a1)+,(a2)+
		dbf	d0,EndDemo_LampLoad

EndDemo_Exit:
		rts	
; End of function EndingDemoLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending demo level array

; Lists levels used in ending demos
; ---------------------------------------------------------------------------
EndDemoLevelArray:
		dc.b id_GHZ, 0					; Green Hill Zone, act 1
		dc.b id_MZ, 1					; Marble Zone, act 2
		dc.b id_SYZ, 2					; Spring Yard Zone, act 3
		dc.b id_LZ, 2					; Labyrinth Zone, act 3
		dc.b id_SLZ, 2					; Star Light Zone, act 3
		dc.b id_SBZ, 0					; Scrap Brain Zone, act 1
		dc.b id_SBZ, 1					; Scrap Brain Zone, act 2
		dc.b id_GHZ, 0					; Green Hill Zone, act 1

; ---------------------------------------------------------------------------
; Lamppost variables in the end sequence demo (Star Light Zone)
; ---------------------------------------------------------------------------
EndDemo_LampVar:
		dc.b 1,	1					; number of the last lamppost
		dc.w $A00, $62C					; x/y-axis position
		dc.w 13						; rings
		dc.l 0						; time
		dc.b 0,	0					; dynamic level event routine counter
		dc.w $800					; level bottom boundary
		dc.w $957, $5CC					; x/y axis screen position
		dc.w $4AB, $3A6, 0, $28C, 0, 0			; scroll info
		dc.w $308					; water height
		dc.b 1,	1					; water routine and state
; ===========================================================================
; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screens
; ---------------------------------------------------------------------------

TryAgainEnd:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)				; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$9001,(a6)				; 64x32 cell plane size
		move.w	#$9200,(a6)				; window vertical position
		move.w	#$8B03,(a6)				; line scroll mode
		move.w	#$8720,(a6)				; set background colour (line 3; colour 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	TryAg_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrObjRam			; clear object RAM

		moveq	#id_PLC_TryAgain,d0
		bsr.w	QuickPLC				; load "TRY AGAIN" or "END" patterns

		lea	(v_pal_dry_next).w,a1
		moveq	#0,d0
		move.w	#$1F,d1
	TryAg_ClrPal:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrPal				; fill palette with black

		moveq	#id_Pal_Ending,d0
		bsr.w	PalLoad_Next				; load ending palette
		clr.w	(v_pal_dry_next+$40).w
		move.b	#id_EndEggman,(v_ost_endeggman).w	; load Eggman object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	#1800,(v_countdown).w			; show screen for 30 seconds
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screen main loop
; ---------------------------------------------------------------------------
TryAg_MainLoop:
		bsr.w	PauseGame
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		andi.b	#btnStart,(v_joypad_press_actual).w	; is Start button pressed?
		bne.s	TryAg_Exit				; if yes, branch
		tst.w	(v_countdown).w				; has 30 seconds elapsed?
		beq.s	TryAg_Exit				; if yes, branch
		cmpi.b	#id_Credits,(v_gamemode).w
		beq.s	TryAg_MainLoop

TryAg_Exit:
		move.b	#id_Sega,(v_gamemode).w			; goto Sega screen
		rts	
