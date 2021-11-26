; ---------------------------------------------------------------------------
; Title	screen
; ---------------------------------------------------------------------------

GM_Title:
		play.b	1, bsr.w, cmd_Stop			; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut				; fade from previous gamemode to black
		disable_ints
		bsr.w	DacDriverLoad
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)				; normal colour mode
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$9001,(a6)				; 64x32 cell plane size
		move.w	#$9200,(a6)				; window vertical position 0 (i.e. disabled)
		move.w	#$8B03,(a6)				; single pixel line horizontal scrolling
		move.w	#$8720,(a6)				; set background colour (palette line 2, entry 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1

	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; fill OST ($D000-$EFFF) with 0

		locVRAM	0
		lea	(Nem_JapNames).l,a0			; load Japanese credits
		bsr.w	NemDec
		locVRAM	$14C0
		lea	(Nem_CreditText).l,a0			; load alphabet
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_JapNames).l,a0			; load mappings for Japanese credits
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,vram_fg,0,0,$28,$1C	; copy Japanese credits mappings to fg nametable in VRAM

		lea	(v_pal_dry_next).w,a1
		moveq	#cBlack,d0
		move.w	#$1F,d1

	@clear_pal:
		move.l	d0,(a1)+
		dbf	d1,@clear_pal				; fill palette with 0 (black)

		moveq	#id_Pal_Sonic,d0			; load Sonic's palette
		bsr.w	PalLoad_Next				; palette will be shown after fading in
		move.b	#id_CreditsText,(v_ost_credits).w	; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	PaletteFadeIn
		disable_ints

vram_title:		equ $4000
vram_title_sonic:	equ $6000
vram_title_tm:		equ $A200
vram_text:		equ $D000

		locVRAM	vram_title
		lea	(Nem_TitleFg).l,a0			; load title screen patterns
		bsr.w	NemDec
		locVRAM	vram_title_sonic
		lea	(Nem_TitleSonic).l,a0			; load Sonic title screen patterns
		bsr.w	NemDec
		locVRAM	vram_title_tm
		lea	(Nem_TitleTM).l,a0			; load "TM" patterns
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM	vram_text,4(a6)
		lea	(Art_Text).l,a5				; load level select font
		move.w	#(sizeof_art_text/2)-1,d1

	@load_text:
		move.w	(a5)+,(a6)
		dbf	d1,@load_text				; load level select font

		move.b	#0,(v_last_lamppost).w			; clear lamppost counter
		move.w	#0,(v_debug_active).w			; disable debug item placement mode
		move.w	#0,(v_demo_mode).w			; disable debug mode
		move.w	#0,(v_title_unused).w			; unused variable
		move.w	#(id_GHZ<<8),(v_zone).w			; set level to GHZ act 1 (0000)
		move.w	#0,(v_palcycle_time).w			; disable palette cycling
		bsr.w	LevelSizeLoad				; set level boundaries and Sonic's start position
		bsr.w	DeformLayers
		lea	(v_16x16_tiles).w,a1
		lea	(Blk16_GHZ).l,a0			; load GHZ 16x16 mappings
		move.w	#0,d0
		bsr.w	EniDec
		lea	(Blk256_GHZ).l,a0			; load GHZ 256x256 mappings
		lea	(v_256x256_tiles).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		bsr.w	PaletteFadeOut
		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_x_pos).w,a3
		lea	(v_level_layout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	DrawChunks				; draw background
		lea	($FF0000).l,a1
		lea	(Eni_Title).l,a0			; load title screen mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,vram_fg,3,4,$22,$16

		locVRAM	0
		lea	(Nem_GHZ_1st).l,a0			; load GHZ patterns
		bsr.w	NemDec
		moveq	#id_Pal_Title,d0			; load title screen palette
		bsr.w	PalLoad_Next
		play.b	1, bsr.w, mus_TitleScreen		; play title screen music
		move.b	#0,(f_debug_enable).w			; disable debug mode
		move.w	#$178,(v_countdown).w			; run title screen for $178 frames
		lea	(v_ost_psb).w,a1
		moveq	#0,d0
		move.w	#7,d1					; should be $F; 7 only clears half the OST

	@clear_ost_psb:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost_psb

		move.b	#id_TitleSonic,(v_ost_titlesonic).w	; load big Sonic object
		move.b	#id_PSBTM,(v_ost_psb).w			; load "PRESS START BUTTON" object
		;clr.b	(v_ost_psb+ost_routine).w ; The 'Mega Games 10' version of Sonic 1 added this line, to fix the 'PRESS START BUTTON' object not appearing

		if Revision=0
		else
			tst.b   (v_console_region).w		; is console Japanese?
			bpl.s   @isjap				; if yes, branch
		endc

		move.b	#id_PSBTM,(v_ost_tm).w			; load "TM" object
		move.b	#id_frame_psb_tm,(v_ost_tm+ost_frame).w
	@isjap:
		move.b	#id_PSBTM,(v_ost_titlemask).w		; load object which hides part of Sonic
		move.b	#id_frame_psb_mask,(v_ost_titlemask+ost_frame).w
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		moveq	#id_PLC_Main,d0				; load lamppost, HUD, lives, ring & points graphics
		bsr.w	NewPLC					; do it over the next few frames
		move.w	#0,(v_title_d_count).w			; reset d-pad counter
		move.w	#0,(v_title_c_count).w			; reset C button counter
		enable_display
		bsr.w	PaletteFadeIn

Title_MainLoop:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		bsr.w	PCycle_Title
		bsr.w	RunPLC
		move.w	(v_ost_player+ost_x_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(v_ost_player+ost_x_pos).w		; move dummy to the right
		cmpi.w	#$1C00,d0				; has dummy object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion				; if not, branch

		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts	
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_console_region).w			; check	if the machine is US or	Japanese
		bpl.s	@japanese				; if Japanese, branch

		lea	(LevSelCode_US).l,a0			; load US code
		bra.s	Tit_EnterCheat

	@japanese:
		lea	(LevSelCode_J).l,a0			; load J code

Tit_EnterCheat:
		move.w	(v_title_d_count).w,d0
		adda.w	d0,a0
		move.b	(v_joypad_press_actual).w,d0		; get button press
		andi.b	#btnDir,d0				; read only UDLR buttons
		cmp.b	(a0),d0					; does button press match the cheat code?
		bne.s	Tit_ResetCheat				; if not, branch
		addq.w	#1,(v_title_d_count).w			; next button press
		tst.b	d0
		bne.s	Tit_CountC
		lea	(f_levelselect_cheat).w,a0
		move.w	(v_title_c_count).w,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Tit_PlayRing
		tst.b	(v_console_region).w
		bpl.s	Tit_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)				; cheat depends on how many times C is pressed

	Tit_PlayRing:
		move.b	#1,(a0,d1.w)				; activate cheat
		play.b	1, bsr.w, sfx_Ring			; play ring sound when code is entered
		bra.s	Tit_CountC
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0
		beq.s	Tit_CountC
		cmpi.w	#9,(v_title_d_count).w
		beq.s	Tit_CountC
		move.w	#0,(v_title_d_count).w			; reset UDLR counter

Tit_CountC:
		move.b	(v_joypad_press_actual).w,d0
		andi.b	#btnC,d0				; is C button pressed?
		beq.s	loc_3230				; if not, branch
		addq.w	#1,(v_title_c_count).w			; increment C counter

loc_3230:
		tst.w	(v_countdown).w
		beq.w	GotoDemo
		andi.b	#btnStart,(v_joypad_press_actual).w	; check if Start is pressed
		beq.w	Title_MainLoop				; if not, branch

Tit_ChkLevSel:
		tst.b	(f_levelselect_cheat).w			; check if level select code is on
		beq.w	PlayLevel				; if not, play level
		btst	#bitA,(v_joypad_hold_actual).w		; check if A is pressed
		beq.w	PlayLevel				; if not, play level

		moveq	#id_Pal_LevelSel,d0
		bsr.w	PalLoad_Now				; load level select palette
		lea	(v_hscroll_buffer).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

	Tit_ClrScroll1:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrScroll1			; clear scroll data (in RAM)

		move.l	d0,(v_fg_y_pos_vsram).w
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	$E000
		move.w	#$3FF,d1

	Tit_ClrScroll2:
		move.l	d0,(a6)
		dbf	d1,Tit_ClrScroll2			; clear scroll data (in VRAM)

		bsr.w	LevSelTextLoad

; ---------------------------------------------------------------------------
; Level	Select
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	LevSelControls
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_joypad_press_actual).w ; is A, B, C, or Start pressed?
		beq.s	LevelSelect				; if not, branch
		move.w	(v_levelselect_item).w,d0
		cmpi.w	#$14,d0					; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS				; if not, go to	Level/SS subroutine
		move.w	(v_levelselect_sound).w,d0
		addi.w	#$80,d0
		tst.b	(f_credits_cheat).w			; is Japanese Credits cheat on?
		beq.s	LevSel_NoCheat				; if not, branch
		cmpi.w	#$9F,d0					; is sound $9F being played?
		beq.s	LevSel_Ending				; if yes, branch
		cmpi.w	#$9E,d0					; is sound $9E being played?
		beq.s	LevSel_Credits				; if yes, branch

LevSel_NoCheat:
		; This is a workaround for a bug, see Sound_ChkValue for more.
		; Once you've fixed the bugs there, comment these four instructions out
		cmpi.w	#_lastMusic+1,d0			; is sound $80-$93 being played?
		blo.s	LevSel_PlaySnd				; if yes, branch
		cmpi.w	#_firstSfx,d0				; is sound $94-$9F being played?
		blo.s	LevelSelect				; if yes, branch

LevSel_PlaySnd:
		bsr.w	PlaySound1
		bra.s	LevelSelect
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w		; set screen mode to $18 (Ending)
		move.w	#(id_EndZ<<8),(v_zone).w		; set level to 0600 (Ending)
		rts	
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w		; set screen mode to $1C (Credits)
		play.b	1, bsr.w, mus_Credits			; play credits music
		move.w	#0,(v_credits_num).w
		rts	
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0
		move.w	LevSel_Ptrs(pc,d0.w),d0			; load level number
		bmi.w	LevelSelect
		cmpi.w	#id_SS*$100,d0				; check	if level is 0700 (Special Stage)
		bne.s	LevSel_Level				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w				; clear	level
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		if Revision=0
		else
			move.l	#5000,(v_score_next_life).w	; extra life is awarded at 50000 points
		endc
		rts	
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0
		move.w	d0,(v_zone).w				; set level number

PlayLevel:
		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		move.b	#3,(v_lives).w				; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.l	d0,(v_score).w				; clear score
		move.b	d0,(v_last_ss_levelid).w		; clear special stage number
		move.b	d0,(v_emeralds).w			; clear emeralds
		move.l	d0,(v_emerald_list).w			; clear emeralds
		move.l	d0,(v_emerald_list+4).w			; clear emeralds
		move.b	d0,(v_continues).w			; clear continues
		if Revision=0
		else
			move.l	#5000,(v_score_next_life).w	; extra life is awarded at 50000 points
		endc
		play.b	1, bsr.w, cmd_Fade			; fade out music
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select - level pointers
; ---------------------------------------------------------------------------
LevSel_Ptrs:	if Revision=0
		; old level order
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3					; Scrap Brain Zone 3
		dc.b id_SBZ, 2					; Final Zone
		else
		; correct level order
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3
		dc.b id_SBZ, 2
		endc
		dc.b id_SS, 0					; Special Stage
		dc.w $8000					; Sound Test
		even
; ---------------------------------------------------------------------------
; Level	select codes
; ---------------------------------------------------------------------------
LevSelCode_J:	if Revision=0
		dc.b btnUp,btnDn,btnL,btnR,0,$FF
		else
		dc.b btnUp,btnDn,btnDn,btnDn,btnL,btnR,0,$FF
		endc
		even

LevSelCode_US:	dc.b btnUp,btnDn,btnL,btnR,0,$FF
		even
