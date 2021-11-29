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
		lea	(v_level_layout+level_max_width).w,a4	; background layout start address ($FFFFA440)
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
		blo.s	Title_Cheat				; if not, branch

		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts	
; ===========================================================================

Title_Cheat:
		tst.b	(v_console_region).w			; check	if the machine is US/EU or Japanese
		bpl.s	@japanese				; if Japanese, branch

		lea	(LevSelCode_US).l,a0			; load US/EU code
		bra.s	@overseas

	@japanese:
		lea	(LevSelCode_J).l,a0			; load JP code

	@overseas:
		move.w	(v_title_d_count).w,d0			; get number of times d-pad has been pressed in correct order
		adda.w	d0,a0					; jump to relevant position in sequence
		move.b	(v_joypad_press_actual).w,d0		; get button press
		andi.b	#btnDir,d0				; read only UDLR buttons
		cmp.b	(a0),d0					; does button press match the cheat code?
		bne.s	@reset_cheat				; if not, branch
		addq.w	#1,(v_title_d_count).w			; next button press
		tst.b	d0					; is d-pad currently pressed?
		bne.s	@count_c				; if yes, branch

		lea	(f_levelselect_cheat).w,a0		; cheat flag array
		move.w	(v_title_c_count).w,d1			; d1 = number of times C was pressed
		lsr.w	#1,d1					; divide by 2
		andi.w	#3,d1					; read only bits 0/1
		beq.s	@levelselect_only			; branch if 0
		tst.b	(v_console_region).w
		bpl.s	@levelselect_only			; branch if region is Japanese
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)				; enable debug mode (C is pressed 2 or more times)

	@levelselect_only:
		move.b	#1,(a0,d1.w)				; activate cheat: no C = level select; CC+ = slowmo (US/EU); CC = slowmo (JP); CCCC = debug (JP); CCCCCC = hidden credits (JP)
		play.b	1, bsr.w, sfx_Ring			; play ring sound when code is entered
		bra.s	@count_c
; ===========================================================================

@reset_cheat:
		tst.b	d0					; is d-pad currently pressed?
		beq.s	@count_c				; if not, branch
		cmpi.w	#9,(v_title_d_count).w
		beq.s	@count_c
		move.w	#0,(v_title_d_count).w			; reset UDLR counter

@count_c:
		move.b	(v_joypad_press_actual).w,d0
		andi.b	#btnC,d0				; is C button pressed?
		beq.s	@c_not_pressed				; if not, branch
		addq.w	#1,(v_title_c_count).w			; increment C counter

	@c_not_pressed:
		tst.w	(v_countdown).w				; has counter hit 0? (started at $178)
		beq.w	PlayDemo				; if yes, branch
		andi.b	#btnStart,(v_joypad_press_actual).w	; check if Start is pressed
		beq.w	Title_MainLoop				; if not, branch

Title_PressedStart:
		tst.b	(f_levelselect_cheat).w			; check if level select code is on
		beq.w	PlayLevel				; if not, play level
		btst	#bitA,(v_joypad_hold_actual).w		; check if A is pressed
		beq.w	PlayLevel				; if not, play level

		moveq	#id_Pal_LevelSel,d0
		bsr.w	PalLoad_Now				; load level select palette
		lea	(v_hscroll_buffer).w,a1
		moveq	#0,d0
		move.w	#(sizeof_vram_hscroll/4)-1,d1

	@clear_hscroll:
		move.l	d0,(a1)+
		dbf	d1,@clear_hscroll			; clear hscroll buffer (in RAM)

		move.l	d0,(v_fg_y_pos_vsram).w
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	vram_bg
		move.w	#(sizeof_vram_bg/4)-1,d1

	@clear_bg:
		move.l	d0,(a6)
		dbf	d1,@clear_bg				; clear bg nametable (in VRAM)

		bsr.w	LevSel_ShowText

; ---------------------------------------------------------------------------
; Level	Select loop
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	LevSel_Navigate				; detect d-pad usage and change selection accordingly
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_joypad_press_actual).w ; is A, B, C, or Start pressed?
		beq.s	LevelSelect				; if not, branch
		move.w	(v_levelselect_item).w,d0
		cmpi.w	#(LevSel_Ptr_ST-LevSel_Ptrs)/2,d0	; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS				; if not, go to	Level/SS subroutine

		move.w	(v_levelselect_sound).w,d0
		addi.w	#$80,d0
		tst.b	(f_credits_cheat).w			; is Japanese credits cheat on?
		beq.s	@nocheat				; if not, branch
		cmpi.w	#$9F,d0					; is sound $9F being played?
		beq.s	LevSel_Ending				; if yes, branch
		cmpi.w	#$9E,d0					; is sound $9E being played?
		beq.s	LevSel_Credits				; if yes, branch

	@nocheat:
		; This is a workaround for a bug, see Sound_ChkValue for more.
		; Once you've fixed the bugs there, comment these four instructions out
		cmpi.w	#_lastMusic+1,d0			; is sound $80-$93 being played?
		blo.s	@play					; if yes, branch
		cmpi.w	#_firstSfx,d0				; is sound $94-$9F being played?
		blo.s	LevelSelect				; if yes, branch

	@play:
		bsr.w	PlaySound1
		bra.s	LevelSelect
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w		; set gamemode to $18 (Ending)
		move.w	#(id_EndZ<<8),(v_zone).w		; set level to 0600 (Ending)
		rts	
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w		; set gamemode to $1C (Credits)
		play.b	1, bsr.w, mus_Credits			; play credits music
		move.w	#0,(v_credits_num).w
		rts	
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0
		move.w	LevSel_Ptrs(pc,d0.w),d0			; load zone/act number
		bmi.w	LevelSelect				; branch if it's $8000+ (sound test)
		cmpi.w	#id_SS*$100,d0				; check	if level is 0700 (Special Stage)
		bne.s	LevSel_Level				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set gamemode to $10 (Special Stage)
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
		move.b	#id_Level,(v_gamemode).w		; set gamemode to $0C (level)
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
LevSel_Ptr_SS:	dc.b id_SS, 0					; Special Stage ($13)
LevSel_Ptr_ST:	dc.w $8000					; Sound Test ($14)
LevSel_Ptr_End:
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

; ---------------------------------------------------------------------------
; Demo mode
; ---------------------------------------------------------------------------

PlayDemo:
		move.w	#30,(v_countdown).w			; set delay to half a second

@loop_delay:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_ost_player+ost_x_pos).w,d0		; dummy object x pos
		addq.w	#2,d0					; increment
		move.w	d0,(v_ost_player+ost_x_pos).w		; update
		cmpi.w	#$1C00,d0				; has dummy object reached $1C00?
		blo.s	@chk_start				; if not, branch
		move.b	#id_Sega,(v_gamemode).w			; goto Sega screen
		rts	
; ===========================================================================

@chk_start:
		andi.b	#btnStart,(v_joypad_press_actual).w	; is Start button pressed?
		bne.w	Title_PressedStart			; if yes, branch
		tst.w	(v_countdown).w				; has delay timer hit 0?
		bne.w	@loop_delay				; if not, branch

		play.b	1, bsr.w, cmd_Fade			; fade out music
		move.w	(v_demo_num).w,d0			; load demo number
		andi.w	#7,d0
		add.w	d0,d0
		move.w	DemoLevelArray(pc,d0.w),d0		; load level number for	demo
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demo_num).w			; add 1 to demo number
		cmpi.w	#4,(v_demo_num).w			; is demo number less than 4?
		blo.s	@demo_0_to_3				; if yes, branch
		move.w	#0,(v_demo_num).w			; reset demo number to	0

	@demo_0_to_3:
		move.w	#1,(v_demo_mode).w			; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w			; set screen mode to 08 (demo)
		cmpi.w	#$600,d0				; is level number 0600 (special	stage)?
		bne.s	@demo_level				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w				; clear	level number
		clr.b	(v_last_ss_levelid).w			; clear special stage number

	@demo_level:
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

; ---------------------------------------------------------------------------
; Demo level array

; Lists levels used in demos
; ---------------------------------------------------------------------------
DemoLevelArray:
		dc.b id_GHZ, 0					; Green Hill Zone, act 1
		dc.b id_MZ, 0					; Marble Zone, act 1
		dc.b id_SYZ, 0					; Spring Yard Zone, act 1
		dc.w $600					; Special Stage

; ---------------------------------------------------------------------------
; Subroutine to	change what you're selecting in the level select
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_Navigate:
		move.b	(v_joypad_press_actual).w,d1
		andi.b	#btnUp+btnDn,d1				; is up/down currently pressed?
		bne.s	@updown					; if yes, branch
		subq.w	#1,(v_levelselect_hold_delay).w		; decrement cooldown timer
		bpl.s	LevSel_SndTest				; if time remains, branch

	@updown:
		move.w	#11,(v_levelselect_hold_delay).w	; reset time delay to 1/5th of a second
		move.b	(v_joypad_hold_actual).w,d1
		andi.b	#btnUp+btnDn,d1				; is up/down pressed?
		beq.s	LevSel_SndTest				; if not, branch
		move.w	(v_levelselect_item).w,d0
		btst	#bitUp,d1				; is up	pressed?
		beq.s	@down					; if not, branch
		subq.w	#1,d0					; move up 1 selection
		bhs.s	@down
		moveq	#(LevSel_Ptr_ST-LevSel_Ptrs)/2,d0	; if selection moves below 0, jump to selection	$14

	@down:
		btst	#bitDn,d1				; is down pressed?
		beq.s	@set_item				; if not, branch
		addq.w	#1,d0					; move down 1 selection
		cmpi.w	#(LevSel_Ptr_End-LevSel_Ptrs)/2,d0
		blo.s	@set_item
		moveq	#0,d0					; if selection moves above $14,	jump to	selection 0

	@set_item:
		move.w	d0,(v_levelselect_item).w		; set new selection
		bsr.w	LevSel_ShowText				; refresh text
		rts	
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#(LevSel_Ptr_ST-LevSel_Ptrs)/2,(v_levelselect_item).w ; is item $14 selected?
		bne.s	@exit					; if not, branch
		move.b	(v_joypad_press_actual).w,d1
		andi.b	#btnR+btnL,d1				; is left/right	pressed?
		beq.s	@exit					; if not, branch
		move.w	(v_levelselect_sound).w,d0
		btst	#bitL,d1				; is left pressed?
		beq.s	@right					; if not, branch
		subq.w	#1,d0					; subtract 1 from sound	test
		bhs.s	@right
		moveq	#$4F,d0					; if sound test	moves below 0, set to $4F

	@right:
		btst	#bitR,d1				; is right pressed?
		beq.s	@refresh_text				; if not, branch
		addq.w	#1,d0					; add 1	to sound test
		cmpi.w	#$50,d0
		blo.s	@refresh_text
		moveq	#0,d0					; if sound test	moves above $4F, set to	0

	@refresh_text:
		move.w	d0,(v_levelselect_sound).w		; set sound test number
		bsr.w	LevSel_ShowText				; refresh text

	@exit:
		rts	
; End of function LevSel_Navigate

; ---------------------------------------------------------------------------
; Subroutine to load level select text
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ShowText:

text_x:		= 8
text_y:		= 4
text_pos:	= (sizeof_vram_row*text_y)+(text_x*2)		; position to draw text (in 8x8 cells)
soundtest_pos:	= (sizeof_vram_row*$18)+($18*2)

		lea	(LevSel_Strings).l,a1
		lea	(vdp_data_port).l,a6
		locVRAM	vram_bg+text_pos,d4			; $E210
		move.w	#(vram_text/$20)+tile_pal4+tile_hi,d3	; VRAM setting ($E680: 4th palette, $680th tile)
		moveq	#$14,d1					; number of lines of text

	@loop_lines:
		move.l	d4,4(a6)
		bsr.w	LevSel_DrawLine				; draw line of text
		addi.l	#sizeof_vram_row<<16,d4			; jump to next line
		dbf	d1,@loop_lines

		moveq	#0,d0
		move.w	(v_levelselect_item).w,d0		; get number of line currently highlighted
		move.w	d0,d1					; copy to d1
		locVRAM	vram_bg+text_pos,d4			; $E210
		lsl.w	#7,d0					; multiply by $80
		swap	d0					; convert to VDP format
		add.l	d0,d4					; d4 = VDP address of highlighted line
		lea	(LevSel_Strings).l,a1			; get strings
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1					; d1 = line number * 24
		adda.w	d1,a1					; jump to string for highlighted line
		move.w	#(vram_text/$20)+tile_pal3+tile_hi,d3	; VRAM setting ($C680: 3rd palette, $680th tile)
		move.l	d4,4(a6)
		bsr.w	LevSel_DrawLine				; recolour selected line

		move.w	#(vram_text/$20)+tile_pal4+tile_hi,d3	; white text for sound test
		cmpi.w	#(LevSel_Ptr_ST-LevSel_Ptrs)/2,(v_levelselect_item).w ; is highlighted line the sound test? ($14)
		bne.s	@soundtest				; if not, branch
		move.w	#(vram_text/$20)+tile_pal3+tile_hi,d3	; yellow text for sound test

	@soundtest:
		locVRAM	vram_bg+soundtest_pos			; $EC30	- sound test position on screen
		move.w	(v_levelselect_sound).w,d0		; get sound test number
		addi.w	#$80,d0					; add $80
		move.b	d0,d2					; copy to d2
		lsr.b	#4,d0					; divide by $10
		bsr.w	LevSel_DrawSound			; draw low digit
		move.b	d2,d0					; retrieve from d2
		bsr.w	LevSel_DrawSound			; draw high digit
		rts	
; End of function LevSel_ShowText


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_DrawSound:
		andi.w	#$F,d0					; read only low nybble
		cmpi.b	#$A,d0					; is digit $A-$F?
		blo.s	@is_0_9					; if not, branch
		addi.b	#7,d0					; graphics for A-F start 7 cells later

	@is_0_9:
		add.w	d3,d0					; d0 = character + VRAM setting ($EC30)
		move.w	d0,(a6)					; write to nametable in VRAM
		rts	
; End of function LevSel_DrawSound


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_DrawLine:
		moveq	#$17,d2					; number of characters per line

	@loop:
		moveq	#0,d0
		move.b	(a1)+,d0				; get character
		bpl.s	@isvalid				; branch if valid (0-$7F)
		move.w	#0,(a6)					; use blank character instead
		dbf	d2,@loop
		rts	


	@isvalid:
		add.w	d3,d0					; combine char with VRAM setting
		move.w	d0,(a6)					; send to VRAM
		dbf	d2,@loop
		rts	
; End of function LevSel_DrawLine

; ---------------------------------------------------------------------------
; Level	select menu text strings
; ---------------------------------------------------------------------------
lsline:		macro
		ls_str:	equs \1
		rept strlen(\1)
		ls_chr:	substr ,1,"\ls_str"
		ls_str:	substr 2,,"\ls_str"
		if instr("YZ","\ls_chr")
			dc.b "\ls_chr"-$4A			; Y and Z gfx are stored before A
		elseif instr(" ","\ls_chr")
			dc.b $FF				; space = $FF
		else
			dc.b "\ls_chr"-$30
		endc
		endr
		endm

LevSel_Strings:	lsline "GREEN HILL ZONE  STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		if Revision=0
		lsline "LABYRINTH ZONE   STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "MARBLE ZONE      STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "STAR LIGHT ZONE  STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "SPRING YARD ZONE STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		else
		lsline "MARBLE ZONE      STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "SPRING YARD ZONE STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "LABYRINTH ZONE   STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "STAR LIGHT ZONE  STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		endc
		lsline "SCRAP BRAIN ZONE STAGE 1"
		lsline "                 STAGE 2"
		lsline "                 STAGE 3"
		lsline "FINAL ZONE              "
		lsline "SPECIAL STAGE           "
		lsline "SOUND SELECT            "
		even