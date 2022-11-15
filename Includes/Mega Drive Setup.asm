; ---------------------------------------------------------------------------
; Mega Drive setup/initialisation
; ---------------------------------------------------------------------------

EntryPoint:
		tst.l	(port_1_control_hi).l			; test port 1 & 2 control registers
		bne.s	.skip					; branch if not 0
		tst.w	(port_e_control_hi).l			; test ext port control register
	.skip:
		bne.s	SkipSetup				; branch if not 0

		lea	SetupValues(pc),a5			; load setup values array address
		movem.w	(a5)+,d5-d7				; d5 = VDP reg baseline; d6 = RAM size; d7 = VDP reg diff
		movem.l	(a5)+,a0-a4				; a0 = z80_ram ; a1 = z80_bus_request; a2 = z80_reset; a3 = vdp_data_port; a4 = vdp_control_port
		move.b	console_version-z80_bus_request(a1),d0	; get hardware version (from $A10001)
		andi.b	#console_revision,d0
		beq.s	.no_tmss				; if the console has no TMSS, skip the security stuff
		move.l	#'SEGA',tmss_sega-z80_bus_request(a1)	; move "SEGA" to TMSS register ($A14000)

	.no_tmss:
		move.w	(a4),d0					; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0					; clear d0
		movea.l	d0,a6					; clear a6
		move.l	a6,usp					; set usp to $0

		moveq	#SetupVDP_end-SetupVDP-1,d1
	.loop_vdp:
		move.b	(a5)+,d5				; add $8000 to value
		move.w	d5,(a4)					; move value to	VDP register
		add.w	d7,d5					; next register
		dbf	d1,.loop_vdp

		move.l	(a5)+,(a4)
		move.w	d0,(a3)					; clear	the VRAM
		move.w	d7,(a1)					; stop the Z80
		move.w	d7,(a2)					; reset	the Z80

	.waitz80:
		btst	d0,(a1)					; has the Z80 stopped?
		bne.s	.waitz80				; if not, branch
		moveq	#Z80_Startup_size-1,d2			; load the number of bytes in Z80_Startup program into d2

	.loadz80:
		move.b	(a5)+,(a0)+				; load the Z80_Startup program byte by byte to Z80 RAM
		dbf	d2,.loadz80

		move.w	d0,(a2)
		move.w	d0,(a1)					; start	the Z80
		move.w	d7,(a2)					; reset	the Z80

	.loop_ram:
		move.l	d0,-(a6)				; clear 4 bytes of RAM
		dbf	d6,.loop_ram				; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)				; set VDP display mode and increment mode
		move.l	(a5)+,(a4)				; set VDP to CRAM write

		moveq	#(sizeof_pal_all/4)-1,d3		; set repeat times
	.loop_cram:
		move.l	d0,(a3)					; clear 2 palette colours
		dbf	d3,.loop_cram				; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)				; set VDP to VSRAM write

		moveq	#$13,d4
	.loop_vsram:
		move.l	d0,(a3)					; clear 4 bytes of VSRAM.
		dbf	d4,.loop_vsram				; repeat until the entire VSRAM is clear

		moveq	#3,d5
	.loop_psg:
		move.b	(a5)+,psg_input-vdp_data_port(a3)	; reset	the PSG
		dbf	d5,.loop_psg				; repeat for other channels

		move.w	d0,(a2)
		movem.l	(a6),d0-a6				; clear all registers
		disable_ints

SkipSetup:
		bra.s	GameProgram				; begin game

; ===========================================================================
SetupValues:	dc.w vdp_mode_register1				; VDP register start number ($8000)
		dc.w (sizeof_ram/4)-1				; loops to clear RAM
		dc.w vdp_mode_register2-vdp_mode_register1	; VDP register diff ($100)

		dc.l z80_ram					; start	of Z80 RAM
		dc.l z80_bus_request				; Z80 bus request
		dc.l z80_reset					; Z80 reset
		dc.l vdp_data_port				; VDP data
		dc.l vdp_control_port				; VDP control

; The following values are overwritten by VDPSetupGame (and later by game modes), so end up basically unused.
SetupVDP:	dc.b vdp_md_color&$FF				; VDP $80 - normal colour mode
		dc.b (vdp_enable_dma|vdp_md_display)&$FF	; VDP $81 - Mega Drive mode, DMA enable
		dc.b ($C000>>10)				; VDP $82 - foreground nametable address
		dc.b ($F000>>10)				; VDP $83 - window nametable address
		dc.b ($E000>>13)				; VDP $84 - background nametable address
		dc.b ($D800>>9)					; VDP $85 - sprite table address
		dc.b 0						; VDP $86 - unused
		dc.b 0						; VDP $87 - background colour
		dc.b 0						; VDP $88 - unused
		dc.b 0						; VDP $89 - unused
		dc.b 255					; VDP $8A - HBlank register
		dc.b vdp_full_hscroll&$FF			; VDP $8B - full screen scroll
		dc.b vdp_320px_screen_width&$FF			; VDP $8C - 40 cell display
		dc.b ($DC00>>10)				; VDP $8D - hscroll table address
		dc.b 0						; VDP $8E - unused
		dc.b 1						; VDP $8F - VDP increment
		dc.b (vdp_plane_width_64|vdp_plane_height_32)&$FF ; VDP $90 - 64x32 cell plane size
		dc.b 0						; VDP $91 - window h position
		dc.b 0						; VDP $92 - window v position
		dc.w $FFFF					; VDP $93/94 - DMA length
		dc.w 0						; VDP $95/96 - DMA source
		dc.b vdp_dma_vram_fill&$FF			; VDP $97 - DMA fill VRAM
SetupVDP_end:
		dc.l $40000080					; VRAM DMA write address 0

Z80_Startup:
		cpu	z80
		phase 	0

	; fill the Z80 RAM with 00s (with the exception of this program)
		xor	a					; a = 00h
		ld	bc,2000h-(.end+1)			; load the number of bytes to fill
		ld	de,.end+1				; load the destination address of the RAM fill (1 byte after end of program)
		ld	hl,.end					; load the source address of the RAM fill (a single 00 byte)
		ld	sp,hl					; set stack pointer to end of program(?)
		ld	(hl),a					; clear the first byte after the program code
		ldir						; fill the rest of the Z80 RAM with 00's

	; clear all registers
		pop	ix
		pop	iy
		ld	i,a
		ld	r,a
		pop	de
		pop	hl
		pop	af

		ex	af,af					; swap af with af'
		exx						; swap bc, de, and hl
		pop	bc
		pop	de
		pop	hl
		pop	af
		ld	sp,hl					; clear stack pointer

	; put z80 into an infinite loop
		di						; disable interrupts
		im	1					; set interrupt mode to 1 (the only officially supported interrupt mode on the MD)
		ld	(hl),0E9h				; set the first byte into a jp	(hl) instruction
		jp	(hl)					; jump to the first byte, causing an infinite loop to occur.

	.end:							; the space from here til end of Z80 RAM will be filled with 00s
		even						; align the Z80 start up code to the next even byte. Values below require alignment

Z80_Startup_size:
		cpu	68000
		dephase

		dc.w vdp_md_display				; VDP display mode
		dc.w vdp_auto_inc+2				; VDP increment
		dc.l $C0000000					; CRAM write address 0
		dc.l $40000010					; VSRAM write address 0

		dc.b $9F, $BF, $DF, $FF				; values for PSG channel volumes
