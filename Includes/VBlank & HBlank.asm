; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)				; save all registers to stack
		tst.b	(v_vblank_routine).w			; is routine number 0?
		beq.s	VBla_00					; if yes, branch
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010+(0<<16),(vdp_control_port).l	; write to VSRAM address 0
		move.l	(v_fg_y_pos_vsram).w,(vdp_data_port).l	; send screen y-axis pos. to VSRAM
		btst	#6,(v_console_region).w			; is Mega Drive PAL?
		beq.s	@notPAL					; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL				; wait here in a loop doing nothing for a while...

	@notPAL:
		move.b	(v_vblank_routine).w,d0			; get routine number
		move.b	#0,(v_vblank_routine).w			; reset to 0
		move.w	#1,(f_hblank_pal_change).w		; set flag to let HBlank know a frame has finished
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)			; jsr to relevant VBlank routine

VBla_Music:
		jsr	(UpdateSound).l

VBla_Exit:
		addq.l	#1,(v_vblank_counter).w			; increment frame counter
		movem.l	(sp)+,d0-a6				; restore all registers from stack
		rte	
; ===========================================================================
VBla_Index:	index *,,2
		ptr VBla_00
		ptr VBla_02
		ptr VBla_04
		ptr VBla_06
		ptr VBla_08
		ptr VBla_0A
		ptr VBla_0C
		ptr VBla_0E
		ptr VBla_10
		ptr VBla_12
		ptr VBla_14
		ptr VBla_16
		ptr VBla_0C
; ===========================================================================

; 0 - runs by default
VBla_00:
		cmpi.b	#$80+id_Level,(v_gamemode).w		; is game on level init sequence?
		beq.s	@islevel				; if yes, branch
		cmpi.b	#id_Level,(v_gamemode).w		; is game on a level proper?
		bne.w	VBla_Music				; if not, branch

	@islevel:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ ?
		bne.w	VBla_Music				; if not, branch

		move.w	(vdp_control_port).l,d0
		btst	#6,(v_console_region).w			; is Mega Drive PAL?
		beq.s	@notPAL					; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL

	@notPAL:
		move.w	#1,(f_hblank_pal_change).w		; set flag to let HBlank know a frame has finished
		stopZ80
		waitZ80
		tst.b	(f_water_pal_full).w			; is water covering the whole screen?
		bne.s	@allwater				; if yes, branch

		dma	v_pal_dry,sizeof_pal_all,cram		; copy normal palette to CRAM (water palette will be copied by HBlank later)
		bra.s	@waterbelow

	@allwater:
		dma	v_pal_water,sizeof_pal_all,cram		; copy water palette to CRAM

	@waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		startZ80
		bra.w	VBla_Music
; ===========================================================================

; 2 - GM_Sega> Sega_WaitPal, Sega_WaitEnd
VBla_02:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll

; $14 - GM_Sega> Sega_WaitPal (once)
VBla_14:
		tst.w	(v_countdown).w
		beq.w	@end
		subq.w	#1,(v_countdown).w

	@end:
		rts	
; ===========================================================================

; 4 - GM_Title> Tit_MainLoop, LevelSelect, GotoDemo; GM_Credits> Cred_WaitLoop, TryAg_MainLoop
VBla_04:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	ProcessPLC
		tst.w	(v_countdown).w
		beq.w	@end
		subq.w	#1,(v_countdown).w

	@end:
		rts	
; ===========================================================================

; 6 - unused
VBla_06:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		rts	
; ===========================================================================

; $10 - PauseGame> Pause_Loop
VBla_10:
		cmpi.b	#id_Special,(v_gamemode).w		; is game on special stage?
		beq.w	VBla_0A					; if yes, branch

; 8 - GM_Level> Level_MainLoop, Level_FDLoop, Level_DelayLoop
VBla_08:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w
		bne.s	@waterabove

		dma	v_pal_dry,$80,cram
		bra.s	@waterbelow

@waterabove:
		dma	v_pal_water,$80,cram

	@waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)

		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	@nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7
		movem.l	d0-d7,(v_camera_x_pos_copy).w
		movem.l	(v_fg_redraw_direction).w,d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_copy).w
		cmpi.b	#96,(v_vdp_hint_line).w
		bhs.s	Demo_Time
		move.b	#1,(f_hblank_run_snd).w
		addq.l	#4,sp
		bra.w	VBla_Exit

; ---------------------------------------------------------------------------
; Subroutine to	run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Demo_Time:
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bsr.w	ProcessPLC2
		tst.w	(v_countdown).w				; is there time left on the demo?
		beq.w	@end					; if not, branch
		subq.w	#1,(v_countdown).w			; subtract 1 from time left

	@end:
		rts	
; End of function Demo_Time

; ===========================================================================

; $A - GM_Special> SS_MainLoop
VBla_0A:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,$80,cram
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		bsr.w	PalCycle_SS
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	@nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		tst.w	(v_countdown).w				; is there time left on the demo?
		beq.w	@end					; if not, return
		subq.w	#1,(v_countdown).w			; subtract 1 from time left in demo

	@end:
		rts	
; ===========================================================================

; $C - GM_Level> Level_TtlCardLoop; GM_Special> SS_NormalExit
; $18 - GM_Ending> End_LoadSonic (once), End_MainLoop
VBla_0C:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w
		bne.s	@waterabove

		dma	v_pal_dry,$80,cram
		bra.s	@waterbelow

@waterabove:
		dma	v_pal_water,$80,cram

	@waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		tst.b	(f_sonic_dma_gfx).w
		beq.s	@nochg
		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7
		movem.l	d0-d7,(v_camera_x_pos_copy).w
		movem.l	(v_fg_redraw_direction).w,d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_copy).w
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bsr.w	ProcessPLC
		rts	
; ===========================================================================

; $E - unused
VBla_0E:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		addq.b	#1,(v_vblank_0e_counter).w
		move.b	#$E,(v_vblank_routine).w
		rts	
; ===========================================================================

; $12 - PaletteWhiteIn, PaletteWhiteOut, PaletteFadeIn, PaletteFadeOut
VBla_12:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		bra.w	ProcessPLC
; ===========================================================================

; $16 - GM_Special> SS_FinLoop; GM_Continue> Cont_MainLoop
VBla_16:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,$80,cram
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		tst.b	(f_sonic_dma_gfx).w
		beq.s	@nochg
		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		tst.w	(v_countdown).w
		beq.w	@end
		subq.w	#1,(v_countdown).w

	@end:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReadPad_WaterPal_Sprites_HScroll:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w			; is water above top of screen?
		bne.s	@waterabove				; if yes, branch
		dma	v_pal_dry,$80,cram
		bra.s	@waterbelow

	@waterabove:
		dma	v_pal_water,$80,cram

	@waterbelow:
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		rts	
; End of function ReadPad_WaterPal_Sprites_HScroll

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HBlank:
		disable_ints
		tst.w	(f_hblank_pal_change).w			; is palette set to change?
		beq.s	@nochg					; if not, branch
		move.w	#0,(f_hblank_pal_change).w
		movem.l	a0-a1,-(sp)
		lea	(vdp_data_port).l,a1
		lea	(v_pal_water).w,a0			; get palette from RAM
		move.l	#$C0000000,4(a1)			; set VDP to CRAM write
		move.l	(a0)+,(a1)				; move palette to CRAM
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.w	#$8A00+223,4(a1)			; reset HBlank register
		movem.l	(sp)+,a0-a1
		tst.b	(f_hblank_run_snd).w
		bne.s	loc_119E

	@nochg:
		rte	
; ===========================================================================

loc_119E:
		clr.b	(f_hblank_run_snd).w
		movem.l	d0-a6,-(sp)
		bsr.w	Demo_Time
		jsr	(UpdateSound).l
		movem.l	(sp)+,d0-a6
		rte	
; End of function HBlank
