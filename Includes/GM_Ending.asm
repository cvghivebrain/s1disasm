; ---------------------------------------------------------------------------
; Ending sequence in Green Hill	Zone
; ---------------------------------------------------------------------------

GM_Ending:
		play.b	1, bsr.w, cmd_Stop			; stop music
		bsr.w	PaletteFadeOut				; fade out from previous gamemode

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear object RAM

		lea	(v_vblank_0e_counter).w,a1
		moveq	#0,d0
		move.w	#((v_plc_buffer-v_vblank_0e_counter)/4)-1,d1
	@clear_ram1:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram1				; clear	variables ($F628-$F67F)

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#((v_sprite_buffer-v_camera_x_pos)/4)-1,d1
	@clear_ram2:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram2				; clear	variables ($F700-$F7FF)

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#((v_levelselect_hold_delay-v_oscillating_table)/4)-1,d1
	@clear_ram3:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram3				; clear	variables ($FE60-$FF7F)

		disable_ints
		disable_display
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
		move.w	#air_full,(v_air).w
		move.w	#id_EndZ_good,(v_zone).w		; set level number to 0600 (extra flowers)
		cmpi.b	#6,(v_emeralds).w			; do you have all 6 emeralds?
		beq.s	@all_emeralds				; if yes, branch
		move.w	#id_EndZ_bad,(v_zone).w			; set level number to 0601 (no flowers)

	@all_emeralds:
		moveq	#id_PLC_Ending,d0
		bsr.w	QuickPLC				; load ending sequence graphics in 1 frame
		jsr	(Hud_Base).l				; load uncompressed portion of HUD graphics
		bsr.w	LevelParameterLoad			; load level boundaries and start positions
		bsr.w	DeformLayers
		bset	#redraw_left_bit,(v_fg_redraw_direction).w
		bsr.w	LevelDataLoad				; load block mappings and palettes
		bsr.w	DrawTilesAtStart
		move.l	#Col_GHZ,(v_collision_index_ptr).w	; set pointer to GHZ collision index
		enable_ints
		lea	(Kos_EndFlowers).l,a0			; load extra flower patterns
		lea	(v_ghz_flower_buffer).w,a1		; RAM address to buffer the patterns ($FFFF9400)
		bsr.w	KosDec
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad_Next				; load Sonic's palette
		play.w	0, bsr.w, mus_Ending			; play ending sequence music
		btst	#bitA,(v_joypad_hold_actual).w		; is button A being held?
		beq.s	@no_debug				; if not, branch
		move.b	#1,(f_debug_enable).w			; enable debug mode

	@no_debug:
		move.b	#id_SonicPlayer,(v_ost_player).w	; load Sonic object
		bset	#status_xflip_bit,(v_ost_player+ost_status).w ; make Sonic face left
		move.b	#1,(f_lock_controls).w			; lock controls
		move.w	#(btnL<<8),(v_joypad_hold).w		; hold virtual left on d-pad
		move.w	#-$800,(v_ost_player+ost_inertia).w	; set Sonic's speed
		move.b	#id_HUD,(v_ost_hud).w			; load HUD object
		jsr	(ObjPosLoad).l				; load objects for level
		jsr	(ExecuteObjects).l			; run all objects
		jsr	(BuildSprites).l			; create sprite table
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.b	d0,(v_ring_reward).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invincibility).w
		move.b	d0,(v_shoes).w
		move.b	d0,(v_unused_powerup).w
		move.w	d0,(v_debug_active).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_frame_counter).w
		bsr.w	OscillateNumInit
		move.b	#1,(f_hud_score_update).w
		move.b	#1,(v_hud_rings_update).w
		move.b	#0,(f_hud_time_update).w
		move.w	#1800,(v_countdown).w			; set timer for 30 seconds
		move.b	#id_VBlank_Ending,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		enable_display
		move.w	#palfade_all,(v_palfade_start).w	; unused - this is already in PaletteFadeIn
		bsr.w	PaletteFadeIn				; fade in from black

; ---------------------------------------------------------------------------
; Main ending sequence loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame				; check for pause (enters another loop if paused)
		move.b	#id_VBlank_Ending,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w
		bsr.w	End_MoveSonic				; auto control Sonic
		jsr	(ExecuteObjects).l			; run all objects
		bsr.w	DeformLayers				; scroll background
		jsr	(BuildSprites).l			; create sprite table
		jsr	(ObjPosLoad).l				; spawn objects
		bsr.w	PaletteCycle				; animate water in background
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		cmpi.b	#id_Ending,(v_gamemode).w		; is gamemode $18 (ending)?
		beq.s	@continue_ending			; if yes, branch

		move.b	#id_Credits,(v_gamemode).w		; goto credits
		play.b	1, bsr.w, mus_Credits			; play credits music
		move.w	#0,(v_credits_num).w			; set credits index number to 0
		rts	
; ===========================================================================

@continue_ending:
		tst.w	(f_restart).w				; has Sonic released the emeralds? (set by EndSonic object)
		beq.w	End_MainLoop				; if not, branch

		clr.w	(f_restart).w
		move.w	#palfade_all,(v_palfade_start).w
		clr.w	(v_palfade_time).w

; ---------------------------------------------------------------------------
; Emeralds have formed a circle and disappear in a flash
; ---------------------------------------------------------------------------

End_FlashLoop:
		bsr.w	PauseGame
		move.b	#id_VBlank_Ending,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w
		bsr.w	End_MoveSonic				; auto control Sonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		subq.w	#1,(v_palfade_time).w			; decrement palette timer
		bpl.s	@wait					; branch if time remains
		move.w	#2,(v_palfade_time).w			; set timer
		bsr.w	WhiteOut_ToWhite			; increase brightness of palette (up to max $EEE)

	@wait:
		tst.w	(f_restart).w				; is flash complete? (set by EndSonic object)
		beq.w	End_FlashLoop				; if not, branch

		clr.w	(f_restart).w
		move.w	#$2E2F,(v_level_layout+(sizeof_levelrow*1)+0).w ; modify level layout to include extra flowers (row 1, columns 0/1)
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_camera_x_pos).w,a3
		lea	(v_level_layout).w,a4
		move.w	#draw_fg,d2
		bsr.w	DrawChunks				; redraw level
		moveq	#id_Pal_Ending,d0
		bsr.w	PalLoad_Next				; load ending palette
		bsr.w	PaletteWhiteIn				; fade in from white
		bra.w	End_MainLoop				; return to main loop

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence

;	uses d0
; ---------------------------------------------------------------------------

End_MoveSonic:	; Routine 0
		move.b	(v_end_sonic_routine).w,d0		; get routine counter for this subroutine
		bne.s	End_Sonic_Stop				; branch if not 0
		cmpi.w	#$90,(v_ost_player+ost_x_pos).w		; has Sonic passed $90 on x axis?
		bhs.s	End_Sonic_Exit				; if not, branch

		addq.b	#2,(v_end_sonic_routine).w		; goto End_Sonic_Stop next
		move.b	#1,(f_lock_controls).w			; lock player's controls
		move.w	#(btnR<<8),(v_joypad_hold).w		; stop Sonic by virtual pressing right
		rts	
; ===========================================================================

End_Sonic_Stop:	; Routine 2
		subq.b	#2,d0					; is routine counter 2?
		bne.s	End_Sonic_Replace			; if not, branch
		cmpi.w	#$A0,(v_ost_player+ost_x_pos).w		; has Sonic reached $A0 on x axis?
		blo.s	End_Sonic_Exit				; if not, branch

		addq.b	#2,(v_end_sonic_routine).w		; goto End_Sonic_Replace next
		moveq	#0,d0
		move.b	d0,(f_lock_controls).w
		move.w	d0,(v_joypad_hold).w			; stop Sonic moving
		move.w	d0,(v_ost_player+ost_inertia).w
		move.b	#$81,(v_lock_multi).w			; lock controls & position
		move.b	#id_frame_Wait2,(v_ost_player+ost_frame).w
		move.w	#(id_Wait<<8)+id_Wait,(v_ost_player+ost_anim).w ; use "standing" animation
		move.b	#3,(v_ost_player+ost_anim_time).w
		rts	
; ===========================================================================

End_Sonic_Replace:
		; Routine 4
		subq.b	#2,d0					; is routine counter 4?
		bne.s	End_Sonic_Exit				; if not, branch
		addq.b	#2,(v_end_sonic_routine).w		; goto End_Sonic_Exit next
		move.w	#$A0,(v_ost_player+ost_x_pos).w		; centre Sonic on screen
		move.b	#id_EndSonic,(v_ost_player).w		; load Sonic ending sequence object
		clr.w	(v_ost_player+ost_routine).w		; clear Sonic object's routine counter

End_Sonic_Exit:	; Routine 6
		rts
