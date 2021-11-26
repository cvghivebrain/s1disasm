; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

include_Sega:	macro

sega_bg_width:	equ $18
sega_bg_height:	equ 8
sega_fg_width:	equ $28
sega_fg_height:	equ $1C

GM_Sega:
		play.b	1, bsr.w, cmd_Stop			; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)				; use normal colour mode
		move.w	#$8200+(vram_fg>>10),(a6)		; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6)		; set background nametable address
		move.w	#$8700,(a6)				; set background colour (palette entry 0)
		move.w	#$8B00,(a6)				; full-screen vertical scrolling
		clr.b	(f_water_pal_full).w
		disable_ints
		disable_display
		bsr.w	ClearScreen
		locVRAM	0
		lea	(Nem_SegaLogo).l,a0			; load Sega logo patterns
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_SegaLogo).l,a0			; load Sega logo mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,vram_bg,8,$A,sega_bg_width,sega_bg_height
		copyTilemap	$FF0000+(sega_bg_width*sega_bg_height*2),vram_fg,0,0,sega_fg_width,sega_fg_height
								; copy mappings to fg/bg nametables in VRAM

		if Revision=0
		else
			tst.b   (v_console_region).w		; is console Japanese?
			bmi.s   @loadpal			; if not, branch
			copyTilemap	$FF0A40,vram_fg,$1D,$A,3,2 ; hide "TM" with a white 3x2 rectangle
		endc

	@loadpal:
		moveq	#id_Pal_SegaBG,d0
		bsr.w	PalLoad_Now				; load Sega logo palette
		move.w	#-$A,(v_palcycle_num).w
		move.w	#0,(v_palcycle_time).w
		move.w	#0,(v_palcycle_buffer+$12).w
		move.w	#0,(v_palcycle_buffer+$10).w
		enable_display

Sega_PaletteLoop:
		move.b	#2,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	PalCycle_Sega
		bne.s	Sega_PaletteLoop

		play.b	1, bsr.w, cmd_Sega			; play "SEGA" sound
		move.b	#$14,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		move.w	#$1E,(v_countdown).w

Sega_WaitLoop:
		move.b	#2,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		tst.w	(v_countdown).w
		beq.s	@goto_title
		andi.b	#btnStart,(v_joypad_press_actual).w	; is Start button pressed?
		beq.s	Sega_WaitLoop				; if not, branch

	@goto_title:
		move.b	#id_Title,(v_gamemode).w		; go to title screen
		rts	

		endm

; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Sega:
PalCycle_Sega_Gradient:
		tst.b	(v_palcycle_time+1).w			; is low byte of timer 0?
		bne.s	loc_206A				; if not, branch
		lea	(v_pal_dry+$20).w,a1			; address for 2nd palette line
		lea	(Pal_Sega1).l,a0
		moveq	#5,d1
		move.w	(v_palcycle_num).w,d0			; d0 = -$A (initially)

	@loop_findcolour:
		bpl.s	loc_202A				; branch if d0 = 0 
		addq.w	#2,a0					; read next colour from source
		subq.w	#1,d1
		addq.w	#2,d0					; increment d0
		bra.s	@loop_findcolour			; repeat until d0 = 0
; ===========================================================================

loc_202A:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2034
		addq.w	#2,d0

loc_2034:
		cmpi.w	#$60,d0
		bhs.s	loc_203E
		move.w	(a0)+,(a1,d0.w)

loc_203E:
		addq.w	#2,d0
		dbf	d1,loc_202A

		move.w	(v_palcycle_num).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2054
		addq.w	#2,d0

loc_2054:
		cmpi.w	#$64,d0
		blt.s	loc_2062
		move.w	#$401,(v_palcycle_time).w
		moveq	#-$C,d0

loc_2062:
		move.w	d0,(v_palcycle_num).w
		moveq	#1,d0
		rts	
; ===========================================================================

loc_206A:
		subq.b	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	loc_20BC				; branch if positive
		move.b	#4,(v_palcycle_time).w
		move.w	(v_palcycle_num).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0
		blo.s	PalCycle_Sega_Flash
		moveq	#0,d0
		rts	
; ===========================================================================

PalCycle_Sega_Flash:
		move.w	d0,(v_palcycle_num).w
		lea	(Pal_Sega2).l,a0
		lea	(a0,d0.w),a0
		lea	(v_pal_dry+$04).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	(v_pal_dry+$20).w,a1
		moveq	#0,d0
		moveq	#$2C,d1

loc_20A8:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_20B2
		addq.w	#2,d0

loc_20B2:
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_20A8

loc_20BC:
		moveq	#1,d0
		rts	
; End of function PalCycle_Sega
