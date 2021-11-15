; ---------------------------------------------------------------------------
; Special Stage
; ---------------------------------------------------------------------------

GM_Special:
		play.w	1, bsr.w, sfx_EnterSS			; play special stage entry sound
		bsr.w	PaletteWhiteOut
		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)				; line scroll mode
		move.w	#$8004,(a6)				; 8-colour mode
		move.w	#$8A00+175,(v_vdp_hint_counter).w
		move.w	#$9011,(a6)				; 64x64 cell plane size
		move.w	(v_vdp_mode_buffer).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		enable_ints
		dma_fill	0,$6FFF,$5000

	@wait_for_dma:
		move.w	(a5),d1					; read control port ($C00004)
		btst	#1,d1					; is DMA running?
		bne.s	@wait_for_dma				; if yes, branch
		move.w	#$8F02,(a5)				; set VDP increment to 2 bytes
		bsr.w	SS_BGLoad
		moveq	#id_PLC_SpecialStage,d0
		bsr.w	QuickPLC				; load special stage patterns

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear	the object RAM

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#($100/4)-1,d1
	@clear_ram1:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram1				; clear	variables $FFFFF700-$FFFFF800

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#($A0/4)-1,d1
	@clear_ram2:
		move.l	d0,(a1)+
		dbf	d1,@clear_ram2				; clear	variables $FFFFFE60-$FFFFFF00

		lea	(v_ss_bubble_x_pos).w,a1
		moveq	#0,d0
		move.w	#($200/4)-1,d1
	@clear_bubblecloud_bg:
		move.l	d0,(a1)+
		dbf	d1,@clear_bubblecloud_bg		; clear	bg x position data

		clr.b	(f_water_pal_full).w
		clr.w	(f_restart).w
		moveq	#id_Pal_Special,d0
		bsr.w	PalLoad1				; load special stage palette
		jsr	(SS_Load).l				; load SS layout data
		move.l	#0,(v_camera_x_pos).w
		move.l	#0,(v_camera_y_pos).w
		move.b	#id_SonicSpecial,(v_ost_player).w	; load special stage Sonic object
		bsr.w	PalCycle_SS
		clr.w	(v_ss_angle).w				; set stage angle to "upright"
		move.w	#$40,(v_ss_rotation_speed).w		; set stage rotation speed
		play.w	0, bsr.w, mus_SpecialStage		; play special stage BG	music
		move.w	#0,(v_demo_input_counter).w
		lea	(DemoDataPtr).l,a1
		moveq	#6,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_demo_input_time).w
		subq.b	#1,(v_demo_input_time).w
		clr.w	(v_rings).w
		clr.b	(v_ring_reward).w
		move.w	#0,(v_debug_active).w
		move.w	#1800,(v_countdown).w
		tst.b	(f_debug_cheat).w			; has debug cheat been entered?
		beq.s	SS_NoDebug				; if not, branch
		btst	#bitA,(v_joypad_hold_actual).w		; is A button pressed?
		beq.s	SS_NoDebug				; if not, branch
		move.b	#1,(f_debug_enable).w			; enable debug mode

	SS_NoDebug:
		move.w	(v_vdp_mode_buffer).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

; ---------------------------------------------------------------------------
; Main Special Stage loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame
		move.b	#$A,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
		move.w	(v_joypad_hold_actual).w,(v_joypad_hold).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(SS_ShowLayout).l
		bsr.w	SS_BGAnimate
		tst.w	(v_demo_mode).w				; is demo mode on?
		beq.s	@not_demo				; if not, branch
		tst.w	(v_countdown).w				; is there time left on the demo?
		beq.w	SS_ToSegaScreen				; if not, branch

	@not_demo:
		cmpi.b	#id_Special,(v_gamemode).w		; is game mode $10 (special stage)?
		beq.w	SS_MainLoop				; if yes, branch

		tst.w	(v_demo_mode).w				; is demo mode on?
		if Revision=0
			bne.w	SS_ToSegaScreen			; if yes, branch
		else
			bne.w	SS_ToLevel
		endc
		move.b	#id_Level,(v_gamemode).w		; set screen mode to $0C (level)
		cmpi.w	#(id_SBZ<<8)+3,(v_zone).w		; is level number higher than FZ?
		blo.s	@level_ok				; if not, branch
		clr.w	(v_zone).w				; set to GHZ1

	@level_ok:
		move.w	#60,(v_countdown).w			; set delay time to 1 second
		move.w	#$3F,(v_palfade_start).w
		clr.w	(v_palfade_time).w

SS_FinishLoop:
		move.b	#$16,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
		move.w	(v_joypad_hold_actual).w,(v_joypad_hold).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(SS_ShowLayout).l
		bsr.w	SS_BGAnimate
		subq.w	#1,(v_palfade_time).w
		bpl.s	@leave_palette				; branch if palette timer is 0 or higher
		move.w	#2,(v_palfade_time).w			; set palette update delay to 2 frames
		bsr.w	WhiteOut_ToWhite			; fade to white in increments

	@leave_palette:
		tst.w	(v_countdown).w				; has timer hit 0?
		bne.s	SS_FinishLoop				; if not, branch

		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$9001,(a6)				; 64x32 cell plane size
		bsr.w	ClearScreen
		locVRAM	vram_Nem_TitleCard			; $B000 - Pattern Load Cues.asm
		lea	(Nem_TitleCard).l,a0			; load title card patterns
		bsr.w	NemDec
		jsr	(Hud_Base).l
		enable_ints
		moveq	#id_Pal_SSResult,d0
		bsr.w	PalLoad2				; load results screen palette
		moveq	#id_PLC_Main,d0
		bsr.w	NewPLC
		moveq	#id_PLC_SSResult,d0
		bsr.w	AddPLC					; load results screen patterns
		move.b	#1,(f_hud_score_update).w		; update score counter
		move.b	#1,(f_pass_bonus_update).w		; update ring bonus counter
		move.w	(v_rings).w,d0
		mulu.w	#10,d0					; multiply rings by 10
		move.w	d0,(v_ring_bonus).w			; set rings bonus
		play.w	1, jsr, mus_GotThrough			; play end-of-level music

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#((sizeof_ost*countof_ost)/4)-1,d1
	@clear_ost:
		move.l	d0,(a1)+
		dbf	d1,@clear_ost				; clear object RAM

		move.b	#id_SSResult,(v_ost_ssresult1).w	; load results screen object

SS_NormalExit:
		bsr.w	PauseGame
		move.b	#$C,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC
		tst.w	(f_restart).w
		beq.s	SS_NormalExit
		tst.l	(v_plc_buffer).w
		bne.s	SS_NormalExit
		play.w	1, bsr.w, sfx_EnterSS			; play special stage exit sound
		bsr.w	PaletteWhiteOut
		rts	
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w			; goto Sega screen
		rts

		if Revision=0
		else
	SS_ToLevel:	cmpi.b	#id_Level,(v_gamemode).w
			beq.s	SS_ToSegaScreen
			rts
		endc

; ---------------------------------------------------------------------------
; Special stage	background mappings loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Fish/bird dimensions in cells
fish_width:	equ 8
fish_height:	equ 8
sizeof_fish:	equ fish_width*fish_height*2

SS_BGLoad:
		lea	(v_ss_enidec_buffer).l,a1		; buffer
		lea	(Eni_SSBg1).l,a0			; load	mappings for the birds and fish
		move.w	#tile_Nem_SSBgFish+tile_pal3,d0
		bsr.w	EniDec
		locVRAM	$5000,d3
		lea	(v_ss_enidec_buffer+sizeof_fish).l,a2
		moveq	#6,d7

loc_48BE:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bhs.s	loc_48CC
		moveq	#1,d4

loc_48CC:
		moveq	#7,d5

loc_48CE:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_48E2
		cmpi.w	#6,d7
		bne.s	loc_48F2
		lea	(v_ss_enidec_buffer).l,a1

loc_48E2:
		movem.l	d0-d4,-(sp)
		moveq	#fish_width-1,d1
		moveq	#fish_height-1,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_48F2:
		addi.l	#(fish_width*2)<<16,d0			; skip 8 cells ($10 bytes)
		dbf	d5,loc_48CE
		addi.l	#((fish_height-1)*$80)<<16,d0		; skip 7 rows ($380 byes)
		eori.b	#1,d4
		dbf	d6,loc_48CC
		addi.l	#$1000<<16,d3
		bpl.s	loc_491C
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_491C:
		adda.w	#sizeof_fish,a2
		dbf	d7,loc_48BE
		
		lea	(v_ss_enidec_buffer).l,a1
		lea	(Eni_SSBg2).l,a0			; load	mappings for the clouds
		move.w	#0+tile_pal3,d0
		bsr.w	EniDec
		lea	(v_ss_enidec_buffer).l,a1
		locVRAM	$C000,d0
		moveq	#$3F,d1
		moveq	#$1F,d2
		bsr.w	TilemapToVRAM
		lea	(v_ss_enidec_buffer).l,a1
		locVRAM	$D000,d0
		moveq	#$3F,d1
		moveq	#$3F,d2
		bsr.w	TilemapToVRAM
		rts	
; End of function SS_BGLoad

; ---------------------------------------------------------------------------
; Palette cycling routine - special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_SS:
		tst.w	(f_pause).w				; is game paused?
		bne.s	@exit					; if yes, branch
		subq.w	#1,(v_palcycle_ss_time).w		; decrement timer
		bpl.s	@exit					; branch if time remains
		lea	(vdp_control_port).l,a6
		move.w	(v_palcycle_ss_num).w,d0		; get cycle index counter
		addq.w	#1,(v_palcycle_ss_num).w		; increment
		andi.w	#$1F,d0					; read only bits 0-4
		lsl.w	#2,d0					; multiply by 4
		lea	(SS_Timing_Values).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0				; get time byte
		bpl.s	@use_time				; branch if not -1
		move.w	#$1FF,d0				; use $1FF if -1

	@use_time:
		move.w	d0,(v_palcycle_ss_time).w		; set time until next palette change
		moveq	#0,d0
		move.b	(a0)+,d0				; get bg mode byte
		move.w	d0,(v_ss_bg_mode).w
		lea	(SS_BG_Modes).l,a1
		lea	(a1,d0.w),a1				; jump to mode data
		move.w	#$8200,d0				; VDP register - fg nametable address
		move.b	(a1)+,d0				; apply address from mode data
		move.w	d0,(a6)					; send VDP instruction
		move.b	(a1),(v_fg_y_pos_vsram).w		; get byte to send to VSRAM
		move.w	#$8400,d0				; VDP register - bg nametable address
		move.b	(a0)+,d0				; apply address from list
		move.w	d0,(a6)					; send VDP instruction
		move.l	#$40000010,(vdp_control_port).l		; set VDP to VSRAM write mode
		move.l	(v_fg_y_pos_vsram).w,(vdp_data_port).l	; update VSRAM
		moveq	#0,d0
		move.b	(a0)+,d0				; get palette offset
		bmi.s	PalCycle_SS_2				; branch if $80+
		lea	(Pal_SSCyc1).l,a1			; use palette cycle set 1
		adda.w	d0,a1
		lea	(v_pal_dry+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+				; write palette

	@exit:
		rts	
; ===========================================================================

PalCycle_SS_2:
		move.w	(v_palcycle_ss_unused).w,d1		; this is always 0
		cmpi.w	#$8A,d0					; is offset $80-$89?
		blo.s	@offset_80_89				; if yes, branch
		addq.w	#1,d1

	@offset_80_89:
		mulu.w	#$2A,d1					; d1 = always 0 or $2A
		lea	(Pal_SSCyc2).l,a1			; use palette cycle set 2
		adda.w	d1,a1
		andi.w	#$7F,d0					; ignore bit 7
		bclr	#0,d0					; clear bit 0
		beq.s	@offset_even				; branch if already clear
		lea	(v_pal_dry+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+				; write palette

	@offset_even:
		adda.w	#$C,a1
		lea	(v_pal_dry+$5A).w,a2
		cmpi.w	#$A,d0					; is offset 0-8?
		blo.s	@offset_0_8				; if yes, branch
		subi.w	#$A,d0
		lea	(v_pal_dry+$7A).w,a2

	@offset_0_8:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; multiply d0 by 3
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+				; write palette
		rts	
; End of function PalCycle_SS

; ===========================================================================
SS_Timing_Values:
		dc.b 3,	0, $E000>>13, $92			; time until next, bg mode, bg namespace address in VRAM, palette offset
		dc.b 3, 0, $E000>>13, $90
		dc.b 3, 0, $E000>>13, $8E
		dc.b 3, 0, $E000>>13, $8C
		dc.b 3,	0, $E000>>13, $8B
		dc.b 3, 0, $E000>>13, $80
		dc.b 3, 0, $E000>>13, $82
		dc.b 3, 0, $E000>>13, $84
		dc.b 3,	0, $E000>>13, $86
		dc.b 3, 0, $E000>>13, $88
		dc.b 7, 8, $E000>>13, 0
		dc.b 7,	$A, $E000>>13, $C
		dc.b -1, $C, $E000>>13, $18
		dc.b -1, $C, $E000>>13, $18
		dc.b 7, $A, $E000>>13, $C
		dc.b 7,	8, $E000>>13, 0
		dc.b 3,	0, $C000>>13, $88
		dc.b 3, 0, $C000>>13, $86
		dc.b 3, 0, $C000>>13, $84
		dc.b 3, 0, $C000>>13, $82
		dc.b 3,	0, $C000>>13, $81
		dc.b 3, 0, $C000>>13, $8A
		dc.b 3, 0, $C000>>13, $8C
		dc.b 3, 0, $C000>>13, $8E
		dc.b 3,	0, $C000>>13, $90
		dc.b 3, 0, $C000>>13, $92
		dc.b 7, 2, $C000>>13, $24
		dc.b 7, 4, $C000>>13, $30
		dc.b -1, 6, $C000>>13, $3C
		dc.b -1, 6, $C000>>13, $3C
		dc.b 7,	4, $C000>>13, $30
		dc.b 7, 2, $C000>>13, $24
		even
SS_BG_Modes:							; fg namespace address in VRAM, VScroll value
		dc.b $4000>>10, 1				; 0 - grid
		dc.b $6000>>10, 0				; 2 - fish morph 1
		dc.b $6000>>10, 1				; 4 - fish morph 2
		dc.b $8000>>10, 0				; 6 - fish
		dc.b $8000>>10, 1				; 8 - bird morph 1
		dc.b $A000>>10, 0				; $A - bird morph 2
		dc.b $A000>>10, 1				; $C - bird
		even

; ---------------------------------------------------------------------------
; Special Stage, part 2
; ---------------------------------------------------------------------------

include_Special_2:	macro

; ---------------------------------------------------------------------------
; Subroutine to	make the special stage background animated
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_BGAnimate:
		move.w	(v_ss_bg_mode).w,d0			; get frame for fish/bird animation
		bne.s	@not_0					; branch if not 0
		move.w	#0,(v_bg1_y_pos).w
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w	; reset vertical scroll for bubble/cloud layer

	@not_0:
		cmpi.w	#8,d0
		bhs.s	SS_BGBirdCloud				; branch if d0 is 8-$C (birds and clouds)
		cmpi.w	#6,d0
		bne.s	@not_6					; branch if d0 isn't 6
		addq.w	#1,(v_bg3_x_pos).w
		addq.w	#1,(v_bg1_y_pos).w
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w	; scroll bubble layer

	@not_6:
		moveq	#0,d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		swap	d0
		lea	(SS_Bubble_WobbleData).l,a1
		lea	(v_ss_bubble_x_pos).w,a3
		moveq	#9,d3

SS_BGWobbleLoop:
		move.w	2(a3),d0				; get next value from buffer
		bsr.w	CalcSine				; convert to sine
		moveq	#0,d2
		move.b	(a1)+,d2				; read 1st byte
		muls.w	d2,d0					; multiply by sine
		asr.l	#8,d0					; divide by $10
		move.w	d0,(a3)+				; write to 1st word of buffer
		move.b	(a1)+,d2				; read 2nd byte
		ext.w	d2
		add.w	d2,(a3)+				; add to 2nd word of buffer
		dbf	d3,SS_BGWobbleLoop
		
		lea	(v_ss_bubble_x_pos).w,a3
		lea	(SS_Bubble_ScrollBlocks).l,a2
		bra.s	SS_Scroll_CloudsBubbles
; ===========================================================================

SS_BGBirdCloud:
		cmpi.w	#$C,d0
		bne.s	@not_C					; branch if d0 isn't $C
		subq.w	#1,(v_bg3_x_pos).w
		lea	(v_ss_cloud_x_pos).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

	@loop:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,@loop

	@not_C:
		lea	(v_ss_cloud_x_pos).w,a3
		lea	(SS_Cloud_ScrollBlocks).l,a2

SS_Scroll_CloudsBubbles:
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bg1_y_pos).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

	@loop_block:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

	@loop_line:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,@loop_line
		dbf	d3,@loop_block
		rts	
; End of function SS_BGAnimate

; ===========================================================================
SS_Bubble_ScrollBlocks:
		dc.b @end-@start-1
	@start:	dc.b $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
	@end:
		even
SS_Cloud_ScrollBlocks:
		dc.b @end-@start-1
	@start:	dc.b $30, $30, $30, $28, $18, $18, $18
	@end:
		even
SS_Bubble_WobbleData:
		dc.b 8, 2
		dc.b 4, -1
		dc.b 2, 3
		dc.b 8, -1
		dc.b 4, 2
		dc.b 2, 3
		dc.b 8, -3
		dc.b 4, 2
		dc.b 2, 3
		dc.b 2, -1
		even
		
		endm

; ---------------------------------------------------------------------------
; Special Stage, part 3
; ---------------------------------------------------------------------------

include_Special_3:	macro

; ---------------------------------------------------------------------------
; Subroutine to	show the special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_ShowLayout:
		bsr.w	SS_AniWallsRings
		bsr.w	SS_AniItems
		move.w	d5,-(sp)
		lea	(v_ss_sprite_grid_plot).w,a1
		move.b	(v_ss_angle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(v_camera_x_pos).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(v_camera_y_pos).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$F,d7

	@loop_gridrow:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$F,d6

	@loop_gridcell:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,@loop_gridcell

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,@loop_gridrow

		move.w	(sp)+,d5
		lea	(v_ss_layout).l,a0
		moveq	#0,d0
		move.w	(v_camera_y_pos).w,d0			; get camera y pos
		divu.w	#$18,d0					; divide by size of wall sprite (24 pixels)
		mulu.w	#$80,d0					; muliply by width of level
		adda.l	d0,a0					; jump to correct row in level
		moveq	#0,d0
		move.w	(v_camera_x_pos).w,d0			; get camera x pos
		divu.w	#$18,d0					; divide by size of wall sprite (24 pixels)
		adda.w	d0,a0					; jump to correct block in level
		lea	(v_ss_sprite_grid_plot).w,a4		; transformation grid
		move.w	#$F,d7

	@loop_spriterow:
		move.w	#$F,d6

	@loop_sprite:
		moveq	#0,d0
		move.b	(a0)+,d0				; get level block
		beq.s	@skip					; branch if 0 (blank)
		cmpi.b	#(SS_MapIndex_end-SS_MapIndex)/6,d0
		bhi.s	@skip					; branch if above $4E (invalid)
		move.w	(a4),d3					; get grid x pos
		addi.w	#$120,d3				
		cmpi.w	#$70,d3
		blo.s	@skip					; branch if off screen
		cmpi.w	#$1D0,d3
		bhs.s	@skip
		move.w	2(a4),d2				; get grid y pos
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		blo.s	@skip
		cmpi.w	#$170,d2
		bhs.s	@skip
		lea	(v_ss_sprite_info).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1				; get mappings pointer
		move.w	(a5)+,d1				; get frame id
		add.w	d1,d1
		adda.w	(a1,d1.w),a1				; apply frame id to mappings pointer
		movea.w	(a5)+,a3				; get tile id
		moveq	#0,d1
		move.b	(a1)+,d1				; get number of sprite pieces from mappings
		subq.b	#1,d1
		bmi.s	@skip					; branch if 0
		jsr	(BuildSpr_Normal).l			; build sprites from mappings

	@skip:
		addq.w	#4,a4					; next sprite
		dbf	d6,@loop_sprite

		lea	$70(a0),a0				; next row
		dbf	d7,@loop_spriterow

		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	@spritelimit
		move.l	#0,(a2)
		rts	
; ===========================================================================

@spritelimit:
		move.b	#0,-5(a2)				; set last sprite link
		rts	
; End of function SS_ShowLayout

; ---------------------------------------------------------------------------
; Subroutine to	animate	walls and rings	in the special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_AniWallsRings:
		lea	(v_ss_sprite_info+$C).l,a1		; frame id of first wall
		moveq	#0,d0
		move.b	(v_ss_angle).w,d0			; get angle
		lsr.b	#2,d0					; divide by 4
		andi.w	#$F,d0					; read only low nybble
		moveq	#((SS_MapIndex_wall_end-SS_MapIndex)/6)-1,d1 ; $23

	@wall_loop:
		move.w	d0,(a1)					; change frame id to appropriately rotated wall
		addq.w	#8,a1
		dbf	d1,@wall_loop

		lea	(v_ss_sprite_info+5).l,a1		; frame id of first sprite (it's blank, but that doesn't matter)
		subq.b	#1,(v_syncani_1_time).w			; decrement animation timer
		bpl.s	@not0_1					; branch if time remains
		move.b	#7,(v_syncani_1_time).w			; reset to 7
		addq.b	#1,(v_syncani_1_frame).w		; increment frame
		andi.b	#3,(v_syncani_1_frame).w		; there are 4 frames max

	@not0_1:
		move.b	(v_syncani_1_frame).w,((((SS_Map_Ring-SS_MapIndex)/6)+1)*8)(a1) ; $1D0(a1) ; update ring frame
		
		subq.b	#1,(v_syncani_2_time).w
		bpl.s	@not0_2
		move.b	#7,(v_syncani_2_time).w
		addq.b	#1,(v_syncani_2_frame).w
		andi.b	#1,(v_syncani_2_frame).w

	@not0_2:
		move.b	(v_syncani_2_frame).w,d0
		move.b	d0,((((SS_Map_GOAL-SS_MapIndex)/6)+1)*8)(a1) ; $138(a1)
		move.b	d0,((((SS_Map_RedWhite-SS_MapIndex)/6)+1)*8)(a1) ; $160(a1)
		move.b	d0,((((SS_Map_Up-SS_MapIndex)/6)+1)*8)(a1) ; $148(a1)
		move.b	d0,((((SS_Map_Down-SS_MapIndex)/6)+1)*8)(a1) ; $150(a1)
		move.b	d0,((((SS_Map_Em1-SS_MapIndex)/6)+1)*8)(a1) ; $1D8(a1)
		move.b	d0,((((SS_Map_Em2-SS_MapIndex)/6)+1)*8)(a1) ; $1E0(a1)
		move.b	d0,((((SS_Map_Em3-SS_MapIndex)/6)+1)*8)(a1) ; $1E8(a1)
		move.b	d0,((((SS_Map_Em4-SS_MapIndex)/6)+1)*8)(a1) ; $1F0(a1)
		move.b	d0,((((SS_Map_Em5-SS_MapIndex)/6)+1)*8)(a1) ; $1F8(a1)
		move.b	d0,((((SS_Map_Em6-SS_MapIndex)/6)+1)*8)(a1) ; $200(a1)
		
		subq.b	#1,(v_syncani_3_time).w
		bpl.s	@not0_3
		move.b	#4,(v_syncani_3_time).w
		addq.b	#1,(v_syncani_3_frame).w
		andi.b	#3,(v_syncani_3_frame).w

	@not0_3:
		move.b	(v_syncani_3_frame).w,d0
		move.b	d0,((((SS_Map_Glass1-SS_MapIndex)/6)+1)*8)(a1) ; $168(a1)
		move.b	d0,((((SS_Map_Glass2-SS_MapIndex)/6)+1)*8)(a1) ; $170(a1)
		move.b	d0,((((SS_Map_Glass3-SS_MapIndex)/6)+1)*8)(a1) ; $178(a1)
		move.b	d0,((((SS_Map_Glass4-SS_MapIndex)/6)+1)*8)(a1) ; $180(a1)
		
		subq.b	#1,(v_syncani_0_time).w
		bpl.s	@not0_0
		move.b	#7,(v_syncani_0_time).w
		subq.b	#1,(v_syncani_0_frame).w
		andi.b	#7,(v_syncani_0_frame).w

	@not0_0:
		lea	(v_ss_sprite_info+$16).l,a1
		lea	(SS_Wall_Vram_Settings).l,a0
		moveq	#0,d0
		move.b	(v_syncani_0_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		rts	
; End of function SS_AniWallsRings

; ===========================================================================
SS_Wall_Vram_Settings:
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal2
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal3
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal4
		dc.w tile_Nem_SSWalls+tile_pal3

; ---------------------------------------------------------------------------
; Subroutine to	remove items when you collect them in the special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_RemoveCollectedItem:
		lea	($FF4400).l,a2
		move.w	#$1F,d0

loc_1B4C4:
		tst.b	(a2)
		beq.s	locret_1B4CE
		addq.w	#8,a2
		dbf	d0,loc_1B4C4

locret_1B4CE:
		rts	
; End of function SS_RemoveCollectedItem

; ---------------------------------------------------------------------------
; Subroutine to	animate	special	stage items when you touch them
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_AniItems:
		lea	($FF4400).l,a0
		move.w	#$1F,d7

loc_1B4DA:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_1B4E8
		lsl.w	#2,d0
		movea.l	SS_AniIndex-4(pc,d0.w),a1
		jsr	(a1)

loc_1B4E8:
		addq.w	#8,a0

loc_1B4EA:
		dbf	d7,loc_1B4DA

		rts	
; End of function SS_AniItems

; ===========================================================================
SS_AniIndex:	dc.l SS_AniRingSparks
		dc.l SS_AniBumper
		dc.l SS_Ani1Up
		dc.l SS_AniReverse
		dc.l SS_AniEmeraldSparks
		dc.l SS_AniGlassBlock
; ===========================================================================

SS_AniRingSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_1B530
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniRingData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B530
		clr.l	(a0)
		clr.l	4(a0)

locret_1B530:
		rts	
; ===========================================================================
SS_AniRingData:	dc.b $42, $43, $44, $45, 0, 0
; ===========================================================================

SS_AniBumper:
		subq.b	#1,2(a0)
		bpl.s	locret_1B566
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniBumpData(pc,d0.w),d0
		bne.s	loc_1B564
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$25,(a1)
		rts	
; ===========================================================================

loc_1B564:
		move.b	d0,(a1)

locret_1B566:
		rts	
; ===========================================================================
SS_AniBumpData:	dc.b $32, $33, $32, $33, 0, 0
; ===========================================================================

SS_Ani1Up:
		subq.b	#1,2(a0)
		bpl.s	locret_1B596
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_Ani1UpData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B596
		clr.l	(a0)
		clr.l	4(a0)

locret_1B596:
		rts	
; ===========================================================================
SS_Ani1UpData:	dc.b $46, $47, $48, $49, 0, 0
; ===========================================================================

SS_AniReverse:
		subq.b	#1,2(a0)
		bpl.s	locret_1B5CC
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniRevData(pc,d0.w),d0
		bne.s	loc_1B5CA
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$2B,(a1)
		rts	
; ===========================================================================

loc_1B5CA:
		move.b	d0,(a1)

locret_1B5CC:
		rts	
; ===========================================================================
SS_AniRevData:	dc.b $2B, $31, $2B, $31, 0, 0
; ===========================================================================

SS_AniEmeraldSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_1B60C
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniEmerData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B60C
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#id_Obj09_ExitStage,(v_ost_player+ost_routine).w
		play.w	1, jsr, sfx_Goal			; play special stage GOAL sound

locret_1B60C:
		rts	
; ===========================================================================
SS_AniEmerData:	dc.b $46, $47, $48, $49, 0, 0
; ===========================================================================

SS_AniGlassBlock:
		subq.b	#1,2(a0)
		bpl.s	locret_1B640
		move.b	#1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniGlassData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B640
		move.b	4(a0),(a1)
		clr.l	(a0)
		clr.l	4(a0)

locret_1B640:
		rts	
; ===========================================================================
SS_AniGlassData:dc.b $4B, $4C, $4D, $4E, $4B, $4C, $4D,	$4E, 0,	0

; ---------------------------------------------------------------------------
; Special stage	layout pointers
; ---------------------------------------------------------------------------
SS_LayoutIndex:
		dc.l SS_1
		dc.l SS_2
		dc.l SS_3
		dc.l SS_4
		dc.l SS_5
		dc.l SS_6
		even

		endm


; ---------------------------------------------------------------------------
; Special Stage, part 4
; ---------------------------------------------------------------------------

include_Special_4:	macro

; ---------------------------------------------------------------------------
; Subroutine to	load special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_Load:
		moveq	#0,d0
		move.b	(v_last_ss_levelid).w,d0		; load number of last special stage entered
		addq.b	#1,(v_last_ss_levelid).w
		cmpi.b	#6,(v_last_ss_levelid).w
		blo.s	@ss_valid
		move.b	#0,(v_last_ss_levelid).w		; reset if higher than 6

	@ss_valid:
		cmpi.b	#6,(v_emeralds).w			; do you have all emeralds?
		beq.s	SS_LoadData				; if yes, branch
		moveq	#0,d1
		move.b	(v_emeralds).w,d1
		subq.b	#1,d1
		blo.s	SS_LoadData
		lea	(v_emerald_list).w,a3			; check which emeralds you have

SS_ChkEmldLoop:	
		cmp.b	(a3,d1.w),d0
		bne.s	SS_ChkEmldRepeat
		bra.s	SS_Load
; ===========================================================================

SS_ChkEmldRepeat:
		dbf	d1,SS_ChkEmldLoop

SS_LoadData:
		lsl.w	#2,d0
		lea	SS_StartLoc(pc,d0.w),a1
		move.w	(a1)+,(v_ost_player+ost_x_pos).w	; set Sonic's start position
		move.w	(a1)+,(v_ost_player+ost_y_pos).w
		movea.l	SS_LayoutIndex(pc,d0.w),a0
		lea	(v_ss_layout_buffer).l,a1		; load level layout ($FF4000)
		move.w	#0,d0
		jsr	(EniDec).l
		lea	(v_ss_layout).l,a1
		move.w	#($4000/4)-1,d0

SS_ClrRAM3:
		clr.l	(a1)+
		dbf	d0,SS_ClrRAM3				; clear RAM (0-$3FFF)

		lea	(v_ss_layout+$1020).l,a1
		lea	(v_ss_layout_buffer).l,a0
		moveq	#$40-1,d1

	@loop_row:
		moveq	#$40-1,d2

	@loop_bytes:
		move.b	(a0)+,(a1)+
		dbf	d2,@loop_bytes

		lea	$40(a1),a1
		dbf	d1,@loop_row				; copy layout to RAM in blocks of $40 bytes, with $40 blank between each block

		lea	(v_ss_sprite_info+8).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#((SS_MapIndex_end-SS_MapIndex)/6)-1,d1

	@loop_map_ptrs:
		move.l	(a0)+,(a1)+				; copy mappings pointer
		move.w	#0,(a1)+				; create blank word
		move.b	-4(a0),-1(a1)				; copy frame id to low byte of blank word
		move.w	(a0)+,(a1)+				; copy tile id
		dbf	d1,@loop_map_ptrs			; copy mappings pointers & VRAM settings to RAM

		lea	($FF4400).l,a1
		move.w	#($100/4)-1,d1

loc_1B730:

		clr.l	(a1)+
		dbf	d1,loc_1B730				; clear RAM ($4400-$44FF)

		rts	
; End of function SS_Load

		endm
