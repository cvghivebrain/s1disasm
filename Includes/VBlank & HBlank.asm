; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)				; save all registers to stack
		tst.b	(v_vblank_routine).w			; is routine number 0?
		beq.s	VBlank_Lag				; if yes, branch
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010+(0<<16),(vdp_control_port).l	; set write destination to VSRAM address 0
		move.l	(v_fg_y_pos_vsram).w,(vdp_data_port).l	; send screen y-axis pos. to VSRAM
		btst	#6,(v_console_region).w			; is Mega Drive PAL?
		beq.s	.notPAL					; if not, branch

		move.w	#$700,d0
	.waitPAL:
		dbf	d0,.waitPAL				; wait here in a loop doing nothing for a while...

	.notPAL:
		move.b	(v_vblank_routine).w,d0			; get routine number
		move.b	#id_VBlank_Lag,(v_vblank_routine).w	; reset to 0
		move.w	#1,(f_hblank_pal_change).w		; set flag to let HBlank know a frame has finished
		andi.w	#$3E,d0
		move.w	VBlank_Index(pc,d0.w),d0
		jsr	VBlank_Index(pc,d0.w)			; jsr to relevant VBlank routine

VBlank_Music:
		jsr	(UpdateSound).l

VBlank_Exit:
		addq.l	#1,(v_vblank_counter).w			; increment frame counter
		movem.l	(sp)+,d0-a6				; restore all registers from stack
		rte						; end of VBlank
; ===========================================================================
VBlank_Index:	index *,,2
		ptr VBlank_Lag					; 0
		ptr VBlank_Sega					; 2
		ptr VBlank_Title				; 4
		ptr VBlank_06					; 6
		ptr VBlank_Level				; 8
		ptr VBlank_Special				; $A
		ptr VBlank_TitleCard				; $C
		ptr VBlank_0E					; $E
		ptr VBlank_Pause				; $10
		ptr VBlank_Fade					; $12
		ptr VBlank_Sega_SkipLoad			; $14
		ptr VBlank_Continue				; $16
		ptr VBlank_Ending				; $18
; ===========================================================================

; 0 - runs when a frame ends before WaitForVBlank triggers (i.e. the game is lagging)
VBlank_Lag:
		cmpi.b	#$80+id_Level,(v_gamemode).w		; is game on level init sequence?
		beq.s	.islevel				; if yes, branch
		cmpi.b	#id_Level,(v_gamemode).w		; is game on a level proper?
		bne.w	VBlank_Music				; if not, branch

	.islevel:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ ?
		bne.w	VBlank_Music				; if not, branch

		move.w	(vdp_control_port).l,d0
		btst	#6,(v_console_region).w			; is Mega Drive PAL?
		beq.s	.notPAL					; if not, branch

		move.w	#$700,d0
	.waitPAL:
		dbf	d0,.waitPAL

	.notPAL:
		move.w	#1,(f_hblank_pal_change).w		; set flag to let HBlank know a frame has finished
		stopZ80
		waitZ80
		tst.b	(f_water_pal_full).w			; is water covering the whole screen?
		bne.s	.allwater				; if yes, branch

		dma	v_pal_dry,sizeof_pal_all,cram		; copy normal palette to CRAM (water palette will be copied by HBlank later)
		bra.s	.waterbelow

	.allwater:
		dma	v_pal_water,sizeof_pal_all,cram		; copy water palette to CRAM

	.waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		startZ80
		bra.w	VBlank_Music
; ===========================================================================

; 2 - GM_Sega> Sega_WaitPal, Sega_WaitEnd
VBlank_Sega:
		bsr.w	ReadPad_Palette_Sprites_HScroll		; read joypad, DMA palettes, sprites and hscroll

; $14 - GM_Sega> Sega_WaitPal (once)
VBlank_Sega_SkipLoad:
		tst.w	(v_countdown).w
		beq.w	.end
		subq.w	#1,(v_countdown).w			; decrement timer

	.end:
		rts	
; ===========================================================================

; 4 - GM_Title> Tit_MainLoop, LevelSelect, GotoDemo; GM_Credits> Cred_WaitLoop, TryAg_MainLoop
VBlank_Title:
		bsr.w	ReadPad_Palette_Sprites_HScroll		; read joypad, DMA palettes, sprites and hscroll
		bsr.w	DrawTilesWhenMoving_BGOnly		; update background
		bsr.w	ProcessPLC				; decompress up to 9 cells of Nemesis gfx if needed
		tst.w	(v_countdown).w
		beq.w	.end
		subq.w	#1,(v_countdown).w			; decrement timer

	.end:
		rts	
; ===========================================================================

; 6 - unused
VBlank_06:
		bsr.w	ReadPad_Palette_Sprites_HScroll		; read joypad, DMA palettes, sprites and hscroll
		rts	
; ===========================================================================

; $10 - PauseGame> Pause_Loop
VBlank_Pause:
		cmpi.b	#id_Special,(v_gamemode).w		; is game on special stage?
		beq.w	VBlank_Special				; if yes, branch

; 8 - GM_Level> Level_MainLoop, Level_FDLoop, Level_DelayLoop
VBlank_Level:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w			; is water covering the whole screen?
		bne.s	.allwater				; if yes, branch

		dma	v_pal_dry,sizeof_pal_all,cram		; copy normal palette to CRAM (water palette will be copied by HBlank later)
		bra.s	.waterbelow

	.allwater:
		dma	v_pal_water,sizeof_pal_all,cram		; copy water palette to CRAM

	.waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)

		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; copy new Sonic gfx to VRAM
		move.b	#0,(f_sonic_dma_gfx).w

	.nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7		; copy all camera & bg x/y positions to d0-d7
		movem.l	d0-d7,(v_camera_x_pos_copy).w		; create duplicates in RAM
		movem.l	(v_fg_redraw_direction).w,d0-d1		; copy all fg/bg redraw direction flags to d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_copy).w	; create duplicates in RAM
		cmpi.b	#96,(v_vdp_hint_line).w			; is HBlank set to run on line 96 or below? (42% of the way down the screen)
		bhs.s	DrawTiles_LevelGfx_HUD_PLC		; if yes, branch
		move.b	#1,(f_hblank_run_snd).w			; set flag to run sound driver on HBlank
		addq.l	#4,sp
		bra.w	VBlank_Exit

; ---------------------------------------------------------------------------
; Subroutine to	update fg/bg, run tile animations, HUD and and decompress up
; to 3 cells of Nemesis graphics
; ---------------------------------------------------------------------------

DrawTiles_LevelGfx_HUD_PLC:
		bsr.w	DrawTilesWhenMoving			; display new tiles if camera has moved
		jsr	(AnimateLevelGfx).l			; update animated level graphics
		jsr	(HUD_Update).l				; update HUD graphics
		bsr.w	ProcessPLC2				; decompress up to 3 cells of Nemesis gfx
		tst.w	(v_countdown).w
		beq.w	.end
		subq.w	#1,(v_countdown).w			; decrement timer

	.end:
		rts

; ===========================================================================

; $A - GM_Special> SS_MainLoop
VBlank_Special:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,sizeof_pal_all,cram		; copy palette to CRAM
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		bsr.w	PalCycle_SS				; update cycling palette
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; copy new Sonic gfx to VRAM
		move.b	#0,(f_sonic_dma_gfx).w

	.nochg:
		tst.w	(v_countdown).w
		beq.w	.end
		subq.w	#1,(v_countdown).w			; decrement timer

	.end:
		rts	
; ===========================================================================

; $C - GM_Level> Level_TtlCardLoop; GM_Special> SS_NormalExit
; $18 - GM_Ending> End_LoadSonic (once), End_MainLoop
VBlank_TitleCard:
VBlank_Ending:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w			; is water covering the whole screen?
		bne.s	.allwater				; if yes, branch

		dma	v_pal_dry,sizeof_pal_all,cram		; copy normal palette to CRAM (water palette will be copied by HBlank later)
		bra.s	.waterbelow

	.allwater:
		dma	v_pal_water,sizeof_pal_all,cram		; copy water palette to CRAM

	.waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; copy new Sonic gfx to VRAM
		move.b	#0,(f_sonic_dma_gfx).w

	.nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7		; copy all camera & bg x/y positions to d0-d7
		movem.l	d0-d7,(v_camera_x_pos_copy).w		; create duplicates in RAM
		movem.l	(v_fg_redraw_direction).w,d0-d1		; copy all fg/bg redraw direction flags to d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_copy).w	; create duplicates in RAM
		bsr.w	DrawTilesWhenMoving			; display new tiles if camera has moved
		jsr	(AnimateLevelGfx).l			; update animated level graphics
		jsr	(HUD_Update).l				; update HUD graphics
		bsr.w	ProcessPLC				; decompress up to 9 cells of Nemesis gfx
		rts	
; ===========================================================================

; $E - unused
VBlank_0E:
		bsr.w	ReadPad_Palette_Sprites_HScroll		; read joypad, DMA palettes, sprites and hscroll
		addq.b	#1,(v_vblank_0e_counter).w		; increment unused counter
		move.b	#id_VBlank_0E,(v_vblank_routine).w
		rts	
; ===========================================================================

; $12 - PaletteWhiteIn, PaletteWhiteOut, PaletteFadeIn, PaletteFadeOut
VBlank_Fade:
		bsr.w	ReadPad_Palette_Sprites_HScroll		; read joypad, DMA palettes, sprites and hscroll
		move.w	(v_vdp_hint_counter).w,(a5)		; set water palette position by sending VDP register $8Axx to control port (vdp_control_port)
		bra.w	ProcessPLC				; decompress up to 9 cells of Nemesis gfx
; ===========================================================================

; $16 - GM_Special> SS_FinLoop; GM_Continue> Cont_MainLoop
VBlank_Continue:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,sizeof_pal_all,cram		; copy palette to CRAM
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		tst.b	(f_sonic_dma_gfx).w			; has Sonic's sprite changed?
		beq.s	.nochg					; if not, branch

		dma	v_sonic_gfx_buffer,sizeof_vram_sonic,vram_sonic ; copy new Sonic gfx to VRAM
		move.b	#0,(f_sonic_dma_gfx).w

	.nochg:
		tst.w	(v_countdown).w
		beq.w	.end
		subq.w	#1,(v_countdown).w			; decrement timer

	.end:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to read joypad and DMA palettes, sprite table and hscroll table
; ---------------------------------------------------------------------------

ReadPad_Palette_Sprites_HScroll:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_water_pal_full).w			; is water covering the whole screen?
		bne.s	.allwater				; if yes, branch
		dma	v_pal_dry,sizeof_pal_all,cram		; copy normal palette to CRAM (water palette will be copied by HBlank later)
		bra.s	.waterbelow

	.allwater:
		dma	v_pal_water,sizeof_pal_all,cram		; copy water palette to CRAM

	.waterbelow:
		dma	v_sprite_buffer,sizeof_vram_sprites,vram_sprites
		dma	v_hscroll_buffer,sizeof_vram_hscroll,vram_hscroll
		startZ80
		rts

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

HBlank:
		disable_ints
		tst.w	(f_hblank_pal_change).w			; is palette set to change during HBlank?
		beq.s	.nochg					; if not, branch
		move.w	#0,(f_hblank_pal_change).w
		movem.l	a0-a1,-(sp)				; save a0-a1 to stack
		lea	(vdp_data_port).l,a1
		lea	(v_pal_water).w,a0			; get palette from RAM
		move.l	#$C0000000,4(a1)			; set VDP to CRAM write
		rept sizeof_pal_all/4
		move.l	(a0)+,(a1)				; copy palette to CRAM
		endr
		move.w	#$8A00+223,4(a1)			; reset HBlank register
		movem.l	(sp)+,a0-a1				; restore a0-a1 from stack
		tst.b	(f_hblank_run_snd).w			; is flag set to update sound & some graphics during HBlank?
		bne.s	.update_hblank				; if yes, branch

	.nochg:
		rte						; end of HBlank
; ===========================================================================

; The following only runs during a level and HBlank is set to run on line 96 or below
.update_hblank:
		clr.b	(f_hblank_run_snd).w
		movem.l	d0-a6,-(sp)				; save registers to stack
		bsr.w	DrawTiles_LevelGfx_HUD_PLC		; display new tiles, update animated gfx, update HUD, decompress 3 cells of Nemesis gfx
		jsr	(UpdateSound).l				; update audio
		movem.l	(sp)+,d0-a6				; restore registers from stack
		rte						; end of HBlank
