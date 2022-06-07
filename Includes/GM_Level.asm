; ---------------------------------------------------------------------------
; Music playlist
; ---------------------------------------------------------------------------
MusicList:
include_MusicList:	macro
		dc.b mus_GHZ					; GHZ
		dc.b mus_LZ					; LZ
		dc.b mus_MZ					; MZ
		dc.b mus_SLZ					; SLZ
		dc.b mus_SYZ					; SYZ
		dc.b mus_SBZ					; SBZ
		endm
		include_MusicList
		zonewarning MusicList,1
		dc.b mus_FZ					; Ending/FZ
		even

; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

GM_Level:
		bset	#7,(v_gamemode).w			; add $80 to gamemode (for pre level sequence)
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bmi.s	@keep_music				; if yes, branch
		play.b	1, bsr.w, cmd_Fade			; fade out music

	@keep_music:
		bsr.w	ClearPLC				; clear PLC buffer
		bsr.w	PaletteFadeOut				; fade out from previous gamemode
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bmi.s	@skip_gfx				; if yes, branch
		disable_ints
		locVRAM	vram_Nem_TitleCard			; $B000
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec
		enable_ints
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

	@skip_gfx:
		lea	(v_ost_all).w,a1			; RAM address to start clearing
		moveq	#0,d0
		move.w	#loops_to_clear_ost,d1			; size of RAM block to clear
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear object RAM

		lea	(v_vblank_0e_counter).w,a1
		moveq	#0,d0
		move.w	#loops_to_clear_vblankstuff,d1
	@clear_ram1:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram1				; clear variables ($F628-$F67F)
		; $F680-$F6FF is preserved (PLC buffer and related variables)

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#loops_to_clear_levelinfo,d1
	@clear_ram2:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram2				; clear variables ($F700-$F7FF)
		; $F800-$FE5F is preserved (sprite buffer, palettes, stack, some game variables)

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#loops_to_clear_synctables2,d1
	@clear_ram3:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram3				; clear variables ($FE60-$FF7F)

		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)				; single pixel line horizontal scrolling
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6)		; set sprite table address
		move.w	#$9001,(a6)				; 64x32 cell plane size
		move.w	#$8004,(a6)				; normal colour mode
		move.w	#$8720,(a6)				; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_vdp_hint_counter).w	; set palette change position (for water)
		move.w	(v_vdp_hint_counter).w,(a6)
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	@skip_water				; if not, branch

		move.w	#$8014,(a6)				; enable horizontal interrupts
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		lea	(WaterHeight).l,a1			; load water height array
		move.w	(a1,d0.w),d0
		move.w	d0,(v_water_height_actual).w		; set water heights
		move.w	d0,(v_water_height_normal).w
		move.w	d0,(v_water_height_next).w
		clr.b	(v_water_routine).w			; clear water routine counter
		clr.b	(f_water_pal_full).w			; clear	water state
		move.b	#1,(v_water_direction).w		; enable water

	@skip_water:
		move.w	#air_full,(v_air).w
		enable_ints
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad_Now				; load Sonic's palette
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	@skip_waterpal				; if not, branch

		moveq	#id_Pal_LZSonWater,d0			; palette number $F (LZ)
		cmpi.b	#3,(v_act).w				; is act number 3?
		bne.s	@not_sbz3				; if not, branch
		moveq	#id_Pal_SBZ3SonWat,d0			; palette number $10 (SBZ3)

	@not_sbz3:
		bsr.w	PalLoad_Water				; load underwater palette
		tst.b	(v_last_lamppost).w			; has a lamppost been used?
		beq.s	@no_lamp				; if not, branch
		move.b	(f_water_pal_full_lampcopy).w,(f_water_pal_full).w ; retrieve flag for whole screen being underwater

	@skip_waterpal:
	@no_lamp:
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bmi.s	Level_Skip_TtlCard			; if yes, branch
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#id_SBZ_act3,(v_zone).w			; is level SBZ3?
		bne.s	@not_sbz3_bgm				; if not, branch
		moveq	#5,d0					; use 5th music (SBZ)

	@not_sbz3_bgm:
		cmpi.w	#id_FZ,(v_zone).w			; is level FZ?
		bne.s	@not_fz_bgm				; if not, branch
		moveq	#6,d0					; use 6th music (FZ)

	@not_fz_bgm:
		lea	(MusicList).l,a1			; load music playlist
		move.b	(a1,d0.w),d0
		bsr.w	PlaySound0				; play music
		move.b	#id_TitleCard,(v_ost_titlecard1).w	; load title card object

Level_TtlCardLoop:
		move.b	#id_VBlank_TitleCard,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC
		move.w	(v_ost_titlecard3+ost_x_pos).w,d0
		cmp.w	(v_ost_titlecard3+ost_card_x_stop).w,d0	; has title card sequence finished?
		bne.s	Level_TtlCardLoop			; if not, branch
		tst.l	(v_plc_buffer).w			; are there any items in the pattern load cue?
		bne.s	Level_TtlCardLoop			; if yes, branch
		jsr	(Hud_Base).l				; load basic HUD gfx

Level_Skip_TtlCard:
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad_Next				; load Sonic's palette
		bsr.w	LevelParameterLoad			; load level boundaries and start positions
		bsr.w	DeformLayers
		bset	#redraw_left_bit,(v_fg_redraw_direction).w
		bsr.w	LevelDataLoad				; load block mappings and palettes
		bsr.w	DrawTilesAtStart
		jsr	(ConvertCollisionArray).l
		bsr.w	SetColIndexPtr
		bsr.w	LZWaterFeatures
		move.b	#id_SonicPlayer,(v_ost_player).w	; load Sonic object
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bmi.s	@skip_hud				; if yes, branch
		move.b	#id_HUD,(v_ost_hud).w			; load HUD object

	@skip_hud:
		tst.b	(f_debug_cheat).w			; has debug cheat been entered?
		beq.s	@skip_debug				; if not, branch
		btst	#bitA,(v_joypad_hold_actual).w		; is A button held?
		beq.s	@skip_debug				; if not, branch
		move.b	#1,(f_debug_enable).w			; enable debug mode

	@skip_debug:
		move.w	#0,(v_joypad_hold).w
		move.w	#0,(v_joypad_hold_actual).w
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		bne.s	@skip_water_surface			; if not, branch
		move.b	#id_WaterSurface,(v_ost_watersurface1).w ; load water surface object
		move.w	#$60,(v_ost_watersurface1+ost_x_pos).w
		move.b	#id_WaterSurface,(v_ost_watersurface2).w
		move.w	#$120,(v_ost_watersurface2+ost_x_pos).w

	@skip_water_surface:
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		moveq	#0,d0
		tst.b	(v_last_lamppost).w			; are you starting from	a lamppost?
		bne.s	@skip_clear				; if yes, branch
		move.w	d0,(v_rings).w				; clear rings
		move.l	d0,(v_time).w				; clear time
		move.b	d0,(v_ring_reward).w			; clear lives counter

	@skip_clear:
		move.b	d0,(f_time_over).w
		move.b	d0,(v_shield).w				; clear shield
		move.b	d0,(v_invincibility).w			; clear invincibility
		move.b	d0,(v_shoes).w				; clear speed shoes
		move.b	d0,(v_unused_powerup).w
		move.w	d0,(v_debug_active).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_frame_counter).w
		bsr.w	OscillateNumInit
		move.b	#1,(f_hud_score_update).w		; update score counter
		move.b	#1,(v_hud_rings_update).w		; update rings counter
		move.b	#1,(f_hud_time_update).w		; update time counter

		move.w	#0,(v_demo_input_counter).w
		lea	(DemoDataPtr).l,a1			; address of pointers to demo data
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		lsl.w	#2,d0					; multiply by 4
		movea.l	(a1,d0.w),a1				; jump to demo data for that zone
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bpl.s	@skip_endingdemo			; if not, branch
		lea	(DemoEndDataPtr).l,a1			; use ending demo data instead
		move.w	(v_credits_num).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1				; jump to demo data

	@skip_endingdemo:
		move.b	1(a1),(v_demo_input_time).w		; load button press duration
		subq.b	#1,(v_demo_input_time).w		; subtract 1 from duration
		move.w	#1800,(v_countdown).w			; run demo for 30 seconds max
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bpl.s	@not_endingdemo				; if not, branch
		move.w	#540,(v_countdown).w			; run demo for 9 seconds instead
		cmpi.w	#4,(v_credits_num).w			; is this the SLZ ending demo?
		bne.s	@not_endingdemo				; if not, branch
		move.w	#510,(v_countdown).w			; run for 8.5 seconds instead

	@not_endingdemo:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ/SBZ3?
		bne.s	@not_lz					; if not, branch
		moveq	#id_Pal_LZWater,d0			; palette $B (LZ underwater)
		cmpi.b	#3,(v_act).w				; is level SBZ3?
		bne.s	@not_sbz3				; if not, branch
		moveq	#id_Pal_SBZ3Water,d0			; palette $D (SBZ3 underwater)

	@not_sbz3:
		bsr.w	PalLoad_Water_Next			; load water palette that'll be shown after fading in

	@not_lz:
		move.w	#4-1,d1

	@delayloop:
		move.b	#id_VBlank_Level,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		dbf	d1,@delayloop				; wait 4 frames for things to process

		move.w	#(palfade_line2+palfade_3),(v_palfade_start).w ; fade in 2nd, 3rd & 4th palette lines ($202F)
		bsr.w	PalFadeIn_Alt				; fade in from black
		tst.w	(v_demo_mode).w				; is this an ending demo?
		bmi.s	@skip_titlecard				; if yes, branch
		addq.b	#2,(v_ost_titlecard1+ost_routine).w	; make title card goto Card_Wait (move back and load explosion/animal gfx)
		addq.b	#4,(v_ost_titlecard2+ost_routine).w
		addq.b	#4,(v_ost_titlecard3+ost_routine).w
		addq.b	#4,(v_ost_titlecard4+ost_routine).w
		bra.s	@end_prelevel
; ===========================================================================

@skip_titlecard:
		moveq	#id_PLC_Explode,d0
		jsr	(AddPLC).l				; load explosion gfx
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#id_PLC_GHZAnimals,d0
		jsr	(AddPLC).l				; load animal gfx (level no. + $15)

@end_prelevel:
		bclr	#7,(v_gamemode).w			; subtract $80 from gamemode to end pre-level stuff

; ---------------------------------------------------------------------------
; Main level loop (when	all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame				; check for pause (enters another loop if paused)
		move.b	#id_VBlank_Level,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w			; increment level timer
		bsr.w	MoveSonicInDemo
		bsr.w	LZWaterFeatures
		jsr	(ExecuteObjects).l
		if Revision=0
		else
			tst.w	(f_restart).w			; is level restart flag set?
			bne.w	GM_Level			; if yes, branch
		endc
		tst.w	(v_debug_active).w			; is debug mode being used?
		bne.s	@skip_death				; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; has Sonic just died?
		bhs.s	@skip_scroll				; if yes, branch

	@skip_death:
		bsr.w	DeformLayers

	@skip_scroll:
		jsr	(BuildSprites).l			; create sprite table
		jsr	(ObjPosLoad).l				; load objects for level
		bsr.w	PaletteCycle
		bsr.w	RunPLC					; load graphics listed in PLC buffer
		bsr.w	OscillateNumDo				; update oscillatory values for objects
		bsr.w	SynchroAnimate				; update values for synchronised object animations
		bsr.w	SignpostArtLoad				; check for level end, and load signpost graphics if needed

		cmpi.b	#id_Demo,(v_gamemode).w			; is this a demo?
		beq.s	Level_Demo				; if yes, branch
		if Revision=0
			tst.w	(f_restart).w			; is level restart flag set?
			bne.w	GM_Level			; if yes, branch
		else
		endc
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	Level_MainLoop				; if gamemode is still $C (level), branch
		rts	
; ===========================================================================

Level_Demo:
		tst.w	(f_restart).w				; is level set to restart?
		bne.s	@end_of_demo				; if yes, branch
		tst.w	(v_countdown).w				; is there time left on the demo?
		beq.s	@end_of_demo				; if not, branch
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	Level_MainLoop				; if gamemode is 8 (demo), branch
		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		rts	
; ===========================================================================

@end_of_demo:
		cmpi.b	#id_Demo,(v_gamemode).w			; is gamemode still 8 (demo)?
		bne.s	@fade_out				; if not, branch
		move.b	#id_Sega,(v_gamemode).w			; go to Sega screen
		tst.w	(v_demo_mode).w				; is this a regular demo & not ending sequence?
		bpl.s	@fade_out				; if yes, branch
		move.b	#id_Credits,(v_gamemode).w		; go to credits

	@fade_out:
		move.w	#60,(v_countdown).w			; set timer to 1 second
		move.w	#palfade_all,(v_palfade_start).w	; fade out all 4 palette lines
		clr.w	(v_palfade_time).w

	@fade_loop:
		move.b	#id_VBlank_Level,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		subq.w	#1,(v_palfade_time).w			; decrement time until next palette update
		bpl.s	@wait					; branch if positive
		move.w	#2,(v_palfade_time).w			; set timer to 2 frames
		bsr.w	FadeOut_ToBlack				; update palette

	@wait:
		tst.w	(v_countdown).w				; has main timer hit 0?
		bne.s	@fade_loop				; if not, branch
		rts	

; ---------------------------------------------------------------------------
; Subroutine to set collision index pointer for current zone

;	uses d0
; ---------------------------------------------------------------------------

include_Level_colptrs:	macro

SetColIndexPtr:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		move.l	ColPointers(pc,d0.w),(v_collision_index_ptr).w
		rts

ColPointers:	dc.l Col_GHZ
		dc.l Col_LZ
		dc.l Col_MZ
		dc.l Col_SLZ
		dc.l Col_SYZ
		dc.l Col_SBZ
		zonewarning ColPointers,4
;		dc.l Col_GHZ					; pointer for Ending is missing by default

		endm

; ---------------------------------------------------------------------------
; Subroutine to check Sonic's position and load signpost graphics
; ---------------------------------------------------------------------------

include_Level_signpost:	macro

SignpostArtLoad:
		tst.w	(v_debug_active).w			; is debug mode	being used?
		bne.w	@exit					; if yes, branch
		cmpi.b	#2,(v_act).w				; is act number 02 (act 3)?
		beq.s	@exit					; if yes, branch

		move.w	(v_camera_x_pos).w,d0
		move.w	(v_boundary_right).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0					; has Sonic reached the	edge of	the level?
		blt.s	@exit					; if not, branch
		tst.b	(f_hud_time_update).w
		beq.s	@exit
		cmp.w	(v_boundary_left).w,d1
		beq.s	@exit
		move.w	d1,(v_boundary_left).w			; move left boundary to current screen position
		moveq	#id_PLC_Signpost,d0
		bra.w	NewPLC					; load signpost	gfx

	@exit:
		rts

		endm
