;  =========================================================================
; |           Sonic the Hedgehog Disassembly for Sega Mega Drive            |
;  =========================================================================
;
; Disassembly created by Hivebrain
; thanks to drx, Stealth, Esrael L.G. Neto and the Sonic Retro Github

; ===========================================================================

		opt	l@				; @ is the local label symbol
		opt	ae-				; automatic even's are disabled by default
		opt	ws+				; allow statements to contain white-spaces
		opt	w+				; print warnings
		opt	m+				; do not expand macros - if enabled, this can break assembling

		include "Mega Drive.asm"
		include "Macros - More CPUs.asm"
		include "Macros - 68k Extended.asm"
		include "Constants.asm"
		include "sound/Sounds.asm"
		include "sound/Sound Equates.asm"
		include "RAM Addresses.asm"
		include "Macros - General.asm"
		include "Macros - Sonic.asm"

		cpu	68000

EnableSRAM:	equ 0					; change to 1 to enable SRAM
BackupSRAM:	equ 1
AddressSRAM:	equ 3					; 0 = odd+even; 2 = even only; 3 = odd only

; Change to 0 to build the original version of the game, dubbed REV00
; Change to 1 to build the later vesion, dubbed REV01, which includes various bugfixes and enhancements
; Change to 2 to build the version from Sonic Mega Collection, dubbed REVXB, which fixes the infamous "spike bug"
	if ~def(Revision)				; bit-perfect check will automatically set this variable
Revision:	equ 1
	endc

ZoneCount:	equ 6					; discrete zones are: GHZ, MZ, SYZ, LZ, SLZ, and SBZ
; ===========================================================================

StartOfRom:
Vectors:	dc.l v_stack_pointer&$FFFFFF	; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace			; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l HBlank			; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l VBlank			; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		if Revision<>2
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
			dc.l ErrorTrap			; Unused (reserved)
		else
	loc_E0:
			; Relocated code from Spik_Hurt. REVXB was a nasty hex-edit.
			move.l	ost_y_pos(a0),d3
			move.w	ost_y_vel(a0),d0
			ext.l	d0
			asl.l	#8,d0
			jmp	(loc_D5A2).l

			dc.w ErrorTrap
			dc.l ErrorTrap
			dc.l ErrorTrap
			dc.l ErrorTrap
		endc
Console:	dc.b "SEGA MEGA DRIVE " ; Hardware system ID (Console name)
Date:		dc.b "(C)SEGA 1991.APR" ; Copyright holder and release date (generally year)
Title_Local:	dc.b "SONIC THE               HEDGEHOG                " ; Domestic name
Title_Int:	dc.b "SONIC THE               HEDGEHOG                " ; International name

Serial:
	if Revision=0
		dc.b "GM 00001009-00"   ; Serial/version number (Rev 0)
	else
		dc.b "GM 00004049-01"	; Serial/version number (Rev non-0)
	endc

Checksum: 	dc.w $0
		dc.b "J               " ; I/O support
RomStartLoc:	dc.l StartOfRom		; Start address of ROM
RomEndLoc:	dc.l EndOfRom-1		; End address of ROM
RamStartLoc:	dc.l $FF0000		; Start address of RAM
RamEndLoc:	dc.l $FFFFFF		; End address of RAM

SRAMSupport:
	if EnableSRAM=1
		dc.b "RA", $A0+(BackupSRAM<<6)+(AddressSRAM<<3), $20
		dc.l $200001		; SRAM start
		dc.l $200FFF		; SRAM end
	else
		dc.l $20202020		; dummy values (SRAM disabled)
		dc.l $20202020		; SRAM start
		dc.l $20202020		; SRAM end
	endc

Notes:		dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
Region:		dc.b "JUE             " ; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
		tst.l	(port_1_control_hi).l					; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(port_e_control_hi).l					; test port C control register

PortA_Ok:
		bne.s	SkipSetup						; Skip the VDP and Z80 setup code if port A, B or C is ok...?
		lea	SetupValues(pc),a5					; Load setup values array address.
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	console_version-z80_bus_request(a1),d0			; get hardware version (from $A10001)
		andi.b	#$F,d0
		beq.s	SkipSecurity						; If the console has no TMSS, skip the security stuff.
		move.l	#'SEGA',tmss_sega-z80_bus_request(a1)			; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0							; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0							; clear d0
		movea.l	d0,a6							; clear a6
		move.l	a6,usp							; set usp to $0

		moveq	#$17,d1
VDPInitLoop:
		move.b	(a5)+,d5						; add $8000 to value
		move.w	d5,(a4)							; move value to	VDP register
		add.w	d7,d5							; next register
		dbf	d1,VDPInitLoop

		move.l	(a5)+,(a4)
		move.w	d0,(a3)							; clear	the VRAM
		move.w	d7,(a1)							; stop the Z80
		move.w	d7,(a2)							; reset	the Z80

@waitz80
		btst	d0,(a1)							; has the Z80 stopped?
		bne.s	@waitz80						; if not, branch
		moveq	#Z80_Startup_size-1,d2					; load the number of bytes in Z80_Startup program into d2

@loadz80
		move.b	(a5)+,(a0)+						; load the Z80_Startup program byte by byte to Z80 RAM
		dbf	d2,@loadz80

		move.w	d0,(a2)
		move.w	d0,(a1)							; start	the Z80
		move.w	d7,(a2)							; reset	the Z80

ClrRAMLoop:
		move.l	d0,-(a6)						; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop						; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)						; set VDP display mode and increment mode
		move.l	(a5)+,(a4)						; set VDP to CRAM write

		moveq	#$1F,d3							; set repeat times
ClrCRAMLoop:
		move.l	d0,(a3)							; clear 2 palettes
		dbf	d3,ClrCRAMLoop						; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)						; set VDP to VSRAM write

		moveq	#$13,d4
ClrVSRAMLoop:
		move.l	d0,(a3)							; clear 4 bytes of VSRAM.
		dbf	d4,ClrVSRAMLoop						; repeat until the entire VSRAM is clear
		moveq	#3,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)						; reset	the PSG
		dbf	d5,PSGInitLoop						; repeat for other channels
		move.w	d0,(a2)
		movem.l	(a6),d0-a6						; clear all registers
		disable_ints

SkipSetup:
		bra.s	GameProgram	; begin game

; ===========================================================================
SetupValues:	dc.w $8000		; VDP register start number
		dc.w $3FFF		; size of RAM/4
		dc.w $100		; VDP register diff

		dc.l z80_ram		; start	of Z80 RAM
		dc.l z80_bus_request	; Z80 bus request
		dc.l z80_reset		; Z80 reset
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	; VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b ($C000>>10)	; VDP $82 - foreground nametable address
		dc.b ($F000>>10)	; VDP $83 - window nametable address
		dc.b ($E000>>13)	; VDP $84 - background nametable address
		dc.b ($D800>>9)		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HBlank register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b ($DC00>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

Z80_Startup:
		cpu	z80
		phase 	0

	; fill the Z80 RAM with 00's (with the exception of this program)
		xor	a							; a = 00h
		ld	bc,2000h-(@end+1)					; load the number of bytes to fill
		ld	de,@end+1						; load the destination address of the RAM fill (1 byte after end of program)
		ld	hl,@end							; load the source address of the RAM fill (a single 00 byte)
		ld	sp,hl							; set stack pointer to end of program(?)
		ld	(hl),a							; clear the first byte after the program code
		ldir								; fill the rest of the Z80 RAM with 00's

	; clear all registers
		pop	ix
		pop	iy
		ld	i,a
		ld	r,a
		pop	de
		pop	hl
		pop	af

		ex	af,af							; swap af with af'
		exx								; swap bc, de, and hl
		pop	bc
		pop	de
		pop	hl
		pop	af
		ld	sp,hl							; clear stack pointer

	; put z80 into an infinite loop
		di								; disable interrupts
		im	1							; set interrupt mode to 1 (the only officially supported interrupt mode on the MD)
		ld	(hl),0E9h						; set the first byte into a jp	(hl) instruction
		jp	(hl)							; jump to the first byte, causing an infinite loop to occur.

	@end:									; the space from here til end of Z80 RAM will be filled with 00's
		even								; align the Z80 start up code to the next even byte. Values below require alignment

Z80_Startup_size:
		cpu	68000
		dephase

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

GameProgram:
		tst.w	(vdp_control_port).l
		btst	#6,(port_e_control).l
		beq.s	CheckSumCheck
		cmpi.l	#'init',(v_init).w ; has checksum routine already run?
		beq.w	GameInit	; if yes, branch

CheckSumCheck:
		movea.l	#EndOfHeader,a0	; start	checking bytes after the header	($200)
		movea.l	#RomEndLoc,a1	; stop at end of ROM
		move.l	(a1),d0
		moveq	#0,d1

	@loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	@loop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare checksum in header to ROM
		bne.w	CheckSumError	; if they don't match, branch

	CheckSumOk:
		lea	($FFFFFE00).w,a6
		moveq	#0,d7
		move.w	#$7F,d6
	@clearRAM:
		move.l	d7,(a6)+
		dbf	d6,@clearRAM	; clear RAM ($FE00-$FFFF)

		move.b	(console_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w ; get region setting
		move.l	#'init',(v_init).w ; set flag so checksum won't run again

GameInit:
		lea	($FF0000).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6
	@clearRAM:
		move.l	d7,(a6)+
		dbf	d6,@clearRAM	; clear RAM ($0000-$FDFF)

		bsr.w	VDPSetupGame
		bsr.w	DacDriverLoad
		bsr.w	JoypadInit
		move.b	#id_Sega,(v_gamemode).w ; set Game Mode to Sega Screen

MainGameLoop:
		move.b	(v_gamemode).w,d0 ; load Game Mode
		andi.w	#$1C,d0		; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		jsr	GameModeArray(pc,d0.w) ; jump to apt location in ROM
		bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------
gmptr:		macro
		id_\1:	equ *-GameModeArray
		if narg=1
		bra.w	GM_\1
		else
		bra.w	GM_\2
		endc
		endm

GameModeArray:
		gmptr Sega		; Sega Screen ($00)
		gmptr Title		; Title	Screen ($04)
		gmptr Demo, Level	; Demo Mode ($08)
		gmptr Level		; Normal Level ($0C)
		gmptr Special		; Special Stage	($10)
		gmptr Continue		; Continue Screen ($14)
		gmptr Ending		; End of game sequence ($18)
		gmptr Credits		; Credits ($1C)
		rts
; ===========================================================================

CheckSumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
		moveq	#$3F,d7

	@fillred:
		move.w	#cRed,(vdp_data_port).l ; fill palette with red
		dbf	d7,@fillred	; repeat $3F more times

	@endlessloop:
		bra.s	@endlessloop
; ===========================================================================

BusError:
		move.b	#2,(v_error_type).w
		bra.s	loc_43A

AddressError:
		move.b	#4,(v_error_type).w
		bra.s	loc_43A

IllegalInstr:
		move.b	#6,(v_error_type).w
		addq.l	#2,2(sp)
		bra.s	loc_462

ZeroDivide:
		move.b	#8,(v_error_type).w
		bra.s	loc_462

ChkInstr:
		move.b	#$A,(v_error_type).w
		bra.s	loc_462

TrapvInstr:
		move.b	#$C,(v_error_type).w
		bra.s	loc_462

PrivilegeViol:
		move.b	#$E,(v_error_type).w
		bra.s	loc_462

Trace:
		move.b	#$10,(v_error_type).w
		bra.s	loc_462

Line1010Emu:
		move.b	#$12,(v_error_type).w
		addq.l	#2,2(sp)
		bra.s	loc_462

Line1111Emu:
		move.b	#$14,(v_error_type).w
		addq.l	#2,2(sp)
		bra.s	loc_462

ErrorExcept:
		move.b	#0,(v_error_type).w
		bra.s	loc_462
; ===========================================================================

loc_43A:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_sp_buffer).w
		addq.w	#2,sp
		movem.l	d0-a7,(v_reg_buffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue
		move.l	(v_sp_buffer).w,d0
		bsr.w	ShowErrorValue
		bra.s	loc_478
; ===========================================================================

loc_462:
		disable_ints
		movem.l	d0-a7,(v_reg_buffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue

loc_478:
		bsr.w	ErrorWaitForC
		movem.l	(v_reg_buffer).w,d0-a7
		enable_ints
		rte	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorMessage:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(Art_Text).l,a0
		move.w	#$27F,d1
	@loadgfx:
		move.w	(a0)+,(a6)
		dbf	d1,@loadgfx

		moveq	#0,d0		; clear	d0
		move.b	(v_error_type).w,d0 ; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM	(vram_fg+$604)
		moveq	#$12,d1		; number of characters (minus 1)

	@showchars:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,@showchars	; repeat for number of characters
		rts	
; End of function ShowErrorMessage

; ===========================================================================
ErrorText:	index *
		ptr @exception
		ptr @bus
		ptr @address
		ptr @illinstruct
		ptr @zerodivide
		ptr @chkinstruct
		ptr @trapv
		ptr @privilege
		ptr @trace
		ptr @line1010
		ptr @line1111
@exception:	dc.b "ERROR EXCEPTION    "
@bus:		dc.b "BUS ERROR          "
@address:	dc.b "ADDRESS ERROR      "
@illinstruct:	dc.b "ILLEGAL INSTRUCTION"
@zerodivide:	dc.b "@ERO DIVIDE        "
@chkinstruct:	dc.b "CHK INSTRUCTION    "
@trapv:		dc.b "TRAPV INSTRUCTION  "
@privilege:	dc.b "PRIVILEGE VIOLATION"
@trace:		dc.b "TRACE              "
@line1010:	dc.b "LINE 1010 EMULATOR "
@line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorValue:
		move.w	#$7CA,(a6)	; display "$" symbol
		moveq	#7,d2

	@loop:
		rol.l	#4,d0
		bsr.s	@shownumber	; display 8 numbers
		dbf	d2,@loop
		rts	
; End of function ShowErrorValue


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


@shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s	@chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

	@chars0to9:
		addi.w	#$7C0,d1
		move.w	d1,(a6)
		rts	
; End of function sub_5CA


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ErrorWaitForC:
		bsr.w	ReadJoypads
		cmpi.b	#btnC,(v_joypad_press_actual).w ; is button C pressed?
		bne.w	ErrorWaitForC	; if not, branch
		rts	
; End of function ErrorWaitForC

; ===========================================================================

Art_Text:	incbin	"Graphics\Level Select & Debug Text.bin" ; text used in level select and debug mode
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vblank_routine).w
		beq.s	VBla_00
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_fg_y_pos_vsram).w,(vdp_data_port).l ; send screen y-axis pos. to VSRAM
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	@notPAL		; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL ; wait here in a loop doing nothing for a while...

	@notPAL:
		move.b	(v_vblank_routine).w,d0
		move.b	#0,(v_vblank_routine).w
		move.w	#1,(f_hblank_pal_change).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Music:
		jsr	(UpdateSound).l

VBla_Exit:
		addq.l	#1,(v_vblank_counter).w
		movem.l	(sp)+,d0-a6
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

VBla_00:
		cmpi.b	#$80+id_Level,(v_gamemode).w
		beq.s	@islevel
		cmpi.b	#id_Level,(v_gamemode).w ; is game on a level?
		bne.w	VBla_Music	; if not, branch

	@islevel:
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ ?
		bne.w	VBla_Music	; if not, branch

		move.w	(vdp_control_port).l,d0
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	@notPAL		; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL

	@notPAL:
		move.w	#1,(f_hblank_pal_change).w ; set HBlank flag
		stopZ80
		waitZ80
		tst.b	(f_water_pal_full).w	; is water above top of screen?
		bne.s	@waterabove 	; if yes, branch

		dma	v_pal_dry,$80,cram
		bra.s	@waterbelow

@waterabove:
		dma	v_pal_water,$80,cram

	@waterbelow:
		move.w	(v_vdp_hint_counter).w,(a5)
		startZ80
		bra.w	VBla_Music
; ===========================================================================

VBla_02:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll

VBla_14:
		tst.w	(v_countdown).w
		beq.w	@end
		subq.w	#1,(v_countdown).w

	@end:
		rts	
; ===========================================================================

VBla_04:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	sub_1642
		tst.w	(v_countdown).w
		beq.w	@end
		subq.w	#1,(v_countdown).w

	@end:
		rts	
; ===========================================================================

VBla_06:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		rts	
; ===========================================================================

VBla_10:
		cmpi.b	#id_Special,(v_gamemode).w ; is game on special stage?
		beq.w	VBla_0A		; if yes, branch

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
		move.w	(v_vdp_hint_counter).w,(a5)

		dma	v_hscroll_buffer,$380,vram_hscroll
		dma	v_sprite_buffer,$280,vram_sprites
		tst.b	(f_sonic_dma_gfx).w ; has Sonic's sprite changed?
		beq.s	@nochg		; if not, branch

		dma	v_sonic_gfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7
		movem.l	d0-d7,(v_camera_x_pos_dup).w
		movem.l	(v_fg_redraw_direction).w,d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_dup).w
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
		bsr.w	ProcessDPLC2
		tst.w	(v_countdown).w ; is there time left on the demo?
		beq.w	@end		; if not, branch
		subq.w	#1,(v_countdown).w ; subtract 1 from time left

	@end:
		rts	
; End of function Demo_Time

; ===========================================================================

VBla_0A:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,$80,cram
		dma	v_sprite_buffer,$280,vram_sprites
		dma	v_hscroll_buffer,$380,vram_hscroll
		startZ80
		bsr.w	PalCycle_SS
		tst.b	(f_sonic_dma_gfx).w ; has Sonic's sprite changed?
		beq.s	@nochg		; if not, branch

		dma	v_sonic_gfx_buffer,$2E0,vram_sonic ; load new Sonic gfx
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		tst.w	(v_countdown).w ; is there time left on the demo?
		beq.w	@end	; if not, return
		subq.w	#1,(v_countdown).w ; subtract 1 from time left in demo

	@end:
		rts	
; ===========================================================================

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
		move.w	(v_vdp_hint_counter).w,(a5)
		dma	v_hscroll_buffer,$380,vram_hscroll
		dma	v_sprite_buffer,$280,vram_sprites
		tst.b	(f_sonic_dma_gfx).w
		beq.s	@nochg
		dma	v_sonic_gfx_buffer,$2E0,vram_sonic
		move.b	#0,(f_sonic_dma_gfx).w

	@nochg:
		startZ80
		movem.l	(v_camera_x_pos).w,d0-d7
		movem.l	d0-d7,(v_camera_x_pos_dup).w
		movem.l	(v_fg_redraw_direction).w,d0-d1
		movem.l	d0-d1,(v_fg_redraw_direction_dup).w
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bsr.w	sub_1642
		rts	
; ===========================================================================

VBla_0E:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		addq.b	#1,(v_vblank_0e_counter).w
		move.b	#$E,(v_vblank_routine).w
		rts	
; ===========================================================================

VBla_12:
		bsr.w	ReadPad_WaterPal_Sprites_HScroll
		move.w	(v_vdp_hint_counter).w,(a5)
		bra.w	sub_1642
; ===========================================================================

VBla_16:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		dma	v_pal_dry,$80,cram
		dma	v_sprite_buffer,$280,vram_sprites
		dma	v_hscroll_buffer,$380,vram_hscroll
		startZ80
		tst.b	(f_sonic_dma_gfx).w
		beq.s	@nochg
		dma	v_sonic_gfx_buffer,$2E0,vram_sonic
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
		tst.b	(f_water_pal_full).w ; is water above top of screen?
		bne.s	@waterabove	; if yes, branch
		dma	v_pal_dry,$80,cram
		bra.s	@waterbelow

	@waterabove:
		dma	v_pal_water,$80,cram

	@waterbelow:
		dma	v_sprite_buffer,$280,vram_sprites
		dma	v_hscroll_buffer,$380,vram_hscroll
		startZ80
		rts	
; End of function ReadPad_WaterPal_Sprites_HScroll

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HBlank:
		disable_ints
		tst.w	(f_hblank_pal_change).w	; is palette set to change?
		beq.s	@nochg		; if not, branch
		move.w	#0,(f_hblank_pal_change).w
		movem.l	a0-a1,-(sp)
		lea	(vdp_data_port).l,a1
		lea	(v_pal_water).w,a0 ; get palette from RAM
		move.l	#$C0000000,4(a1) ; set VDP to CRAM write
		move.l	(a0)+,(a1)	; move palette to CRAM
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
		move.w	#$8A00+223,4(a1) ; reset HBlank register
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

; ---------------------------------------------------------------------------
; Subroutine to	initialise joypads
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


JoypadInit:
		stopZ80
		waitZ80
		moveq	#$40,d0
		move.b	d0,(port_1_control).l	; init port 1 (joypad 1)
		move.b	d0,(port_2_control).l	; init port 2 (joypad 2)
		move.b	d0,(port_e_control).l	; init port 3 (expansion/extra)
		startZ80
		rts	
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to	read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReadJoypads:
		lea	(v_joypad_hold_actual).w,a0 ; address where joypad states are written
		lea	(port_1_data).l,a1 ; first joypad port
		bsr.s	@read		; do the first joypad
		addq.w	#2,a1		; do the second	joypad

	@read:
		move.b	#0,(a1)		; set port to read 00SA00DU
		nop	
		nop	
		move.b	(a1),d0		; d0 = 00SA00DU
		lsl.b	#2,d0		; d0 = SA00DU00
		andi.b	#$C0,d0		; d0 = SA000000
		move.b	#$40,(a1)	; set port to read 00CBRLDU
		nop	
		nop	
		move.b	(a1),d1		; d1 = 00CBRLDU
		andi.b	#$3F,d1		; d1 = 00CBRLDU
		or.b	d1,d0		; d0 = SACBRLDU
		not.b	d0		; invert bits
		move.b	(a0),d1		; d1 = previous joypad state
		eor.b	d0,d1
		move.b	d0,(a0)+	; v_joypad_hold_actual = SACBRLDU
		and.b	d0,d1		; d1 = new joypad inputs only
		move.b	d1,(a0)+	; v_joypad_press_actual = SACBRLDU (new only)
		rts	
; End of function ReadJoypads


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#$12,d7

	@setreg:
		move.w	(a2)+,(a0)
		dbf	d7,@setreg	; set the VDP registers

		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_mode_buffer).w
		move.w	#$8A00+223,(v_vdp_hint_counter).w ; H-INT every 224th scanline
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
		move.w	#$3F,d7

	@clrCRAM:
		move.w	d0,(a1)
		dbf	d7,@clrCRAM	; clear	the CRAM

		clr.l	(v_fg_y_pos_vsram).w
		clr.l	(v_fg_x_pos_hscroll).w
		move.l	d1,-(sp)
		dma_fill	0,$FFFF,0

	@waitforDMA:
		move.w	(a5),d1
		btst	#1,d1		; is dma_fill still running?
		bne.s	@waitforDMA	; if yes, branch

		move.w	#$8F02,(a5)	; set VDP increment size
		move.l	(sp)+,d1
		rts	
; End of function VDPSetupGame

; ===========================================================================
VDPSetupArray:	dc.w $8004		; 8-colour mode
		dc.w $8134		; enable V.interrupts, enable DMA
		dc.w $8200+(vram_fg>>10) ; set foreground nametable address
		dc.w $8300+(vram_window>>10) ; set window nametable address
		dc.w $8400+(vram_bg>>13) ; set background nametable address
		dc.w $8500+(vram_sprites>>9) ; set sprite table address
		dc.w $8600		; unused
		dc.w $8700		; set background colour (palette entry 0)
		dc.w $8800		; unused
		dc.w $8900		; unused
		dc.w $8A00		; default H.interrupt register
		dc.w $8B00		; full-screen vertical scrolling
		dc.w $8C81		; 40-cell display mode
		dc.w $8D00+(vram_hscroll>>10) ; set background hscroll address
		dc.w $8E00		; unused
		dc.w $8F02		; set VDP increment size
		dc.w $9001		; 64-cell hscroll size
		dc.w $9100		; window horizontal position
		dc.w $9200		; window vertical position

; ---------------------------------------------------------------------------
; Subroutine to	clear the screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ClearScreen:
		dma_fill	0,$FFF,vram_fg ; clear foreground namespace

	@wait1:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@wait1

		move.w	#$8F02,(a5)
		dma_fill	0,$FFF,vram_bg ; clear background namespace

	@wait2:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@wait2

		move.w	#$8F02,(a5)
		if Revision=0
		move.l	#0,(v_fg_y_pos_vsram).w
		move.l	#0,(v_fg_x_pos_hscroll).w
		else
		clr.l	(v_fg_y_pos_vsram).w
		clr.l	(v_fg_x_pos_hscroll).w
		endc

		lea	(v_sprite_buffer).w,a1
		moveq	#0,d0
		move.w	#($280/4),d1	; This should be ($280/4)-1, leading to a slight bug (first bit of v_pal_water is cleared)

	@clearsprites:
		move.l	d0,(a1)+
		dbf	d1,@clearsprites ; clear sprite table (in RAM)

		lea	(v_hscroll_buffer).w,a1
		moveq	#0,d0
		move.w	#($400/4),d1	; This should be ($400/4)-1, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

	@clearhscroll:
		move.l	d0,(a1)+
		dbf	d1,@clearhscroll ; clear hscroll table (in RAM)
		rts	
; End of function ClearScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Functions for loading the DAC driver and playing sounds
; ---------------------------------------------------------------------------

	include "sound/PlaySound + DacDriverLoad.asm"

; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		nop	
		tst.b	(v_lives).w	; do you have any lives	left?
		beq.s	Unpause		; if not, branch
		tst.w	(f_pause).w	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		btst	#bitStart,(v_joypad_press_actual).w ; is Start button pressed?
		beq.s	Pause_DoNothing	; if not, branch

Pause_StopGame:
		move.w	#1,(f_pause).w	; freeze time
		move.b	#1,(v_snddriver_ram+f_pause_sound).w ; pause music

Pause_Loop:
		move.b	#$10,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		tst.b	(f_slomocheat).w ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_joypad_press_actual).w ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.b	#id_Title,(v_gamemode).w ; set game mode to 4 (title screen)
		nop	
		bra.s	Pause_EndMusic
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_joypad_hold_actual).w ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_joypad_press_actual).w ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		btst	#bitStart,(v_joypad_press_actual).w ; is Start button pressed?
		beq.s	Pause_Loop	; if not, branch

Pause_EndMusic:
		move.b	#$80,(v_snddriver_ram+f_pause_sound).w	; unpause the music

Unpause:
		move.w	#0,(f_pause).w	; unpause the game

Pause_DoNothing:
		rts	
; ===========================================================================

Pause_SlowMo:
		move.w	#1,(f_pause).w
		move.b	#$80,(v_snddriver_ram+f_pause_sound).w	; Unpause the music
		rts	
; End of function PauseGame

; ---------------------------------------------------------------------------
; Subroutine to	copy a tile map from RAM to VRAM namespace

; input:
;	a1 = tile map address
;	d0 = VRAM address
;	d1 = width (cells)
;	d2 = height (cells)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

	Tilemap_Line:
		move.l	d0,4(a6)	; move d0 to VDP_control_port
		move.w	d1,d3

	Tilemap_Cell:
		move.w	(a1)+,(a6)	; write value to namespace
		dbf	d3,Tilemap_Cell	; next tile
		add.l	d4,d0		; goto next line
		dbf	d2,Tilemap_Line	; next line
		rts	
; End of function TilemapToVRAM

NemDec:		include "Includes\Nemesis Decompression.asm"

; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; LoadPLC:
AddPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1		; jump to relevant PLC
		lea	(v_plc_buffer).w,a2 ; PLC buffer space

	@findspace:
		tst.l	(a2)		; is space available in RAM?
		beq.s	@copytoRAM	; if yes, branch
		addq.w	#6,a2		; if not, try next space
		bra.s	@findspace
; ===========================================================================

@copytoRAM:
		move.w	(a1)+,d0	; get length of PLC
		bmi.s	@skip

	@loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+	; copy PLC to RAM
		dbf	d0,@loop	; repeat for length of PLC

	@skip:
		movem.l	(sp)+,a1-a2 ; a1=object
		rts	
; End of function AddPLC


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;	  _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1	; jump to relevant PLC
		bsr.s	ClearPLC	; erase any data in PLC buffer space
		lea	(v_plc_buffer).w,a2
		move.w	(a1)+,d0	; get length of PLC
		bmi.s	@skip		; if it's negative, skip the next loop

	@loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+	; copy PLC to RAM
		dbf	d0,@loop		; repeat for length of PLC

	@skip:
		movem.l	(sp)+,a1-a2
		rts	
; End of function NewPLC

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to	clear the pattern load cues
; ---------------------------------------------------------------------------

; Clear the pattern load queue ($FFF680 - $FFF700)


ClearPLC:
		lea	(v_plc_buffer).w,a2 ; PLC buffer space in RAM
		moveq	#$1F,d0	; bytesToLcnt(v_plc_buffer_end-v_plc_buffer)

	@loop:
		clr.l	(a2)+
		dbf	d0,@loop
		rts	
; End of function ClearPLC

; ---------------------------------------------------------------------------
; Subroutine to	use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


RunPLC:
		tst.l	(v_plc_buffer).w
		beq.s	Rplc_Exit
		tst.w	(f_plc_execute).w
		bne.s	Rplc_Exit
		movea.l	(v_plc_buffer).w,a0
		lea	(NemPCD_WriteRowToVDP).l,a3
		lea	(v_nem_gfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_160E
		adda.w	#$A,a3

loc_160E:
		andi.w	#$7FFF,d2
		move.w	d2,(f_plc_execute).w
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_nemdec_ptr).w
		move.l	d0,($FFFFF6E4).w
		move.l	d0,($FFFFF6E8).w
		move.l	d0,($FFFFF6EC).w
		move.l	d5,($FFFFF6F0).w
		move.l	d6,($FFFFF6F4).w

Rplc_Exit:
		rts	
; End of function RunPLC


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1642:
		tst.w	(f_plc_execute).w
		beq.w	locret_16DA
		move.w	#9,($FFFFF6FA).w
		moveq	#0,d0
		move.w	($FFFFF684).w,d0
		addi.w	#$120,($FFFFF684).w
		bra.s	loc_1676
; End of function sub_1642


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


; sub_165E:
ProcessDPLC2:
		tst.w	(f_plc_execute).w
		beq.s	locret_16DA
		move.w	#3,($FFFFF6FA).w
		moveq	#0,d0
		move.w	($FFFFF684).w,d0
		addi.w	#$60,($FFFFF684).w

loc_1676:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(v_plc_buffer).w,a0
		movea.l	(v_nemdec_ptr).w,a3
		move.l	($FFFFF6E4).w,d0
		move.l	($FFFFF6E8).w,d1
		move.l	($FFFFF6EC).w,d2
		move.l	($FFFFF6F0).w,d5
		move.l	($FFFFF6F4).w,d6
		lea	(v_nem_gfx_buffer).w,a1

loc_16AA:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(f_plc_execute).w
		beq.s	loc_16DC
		subq.w	#1,($FFFFF6FA).w
		bne.s	loc_16AA
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_nemdec_ptr).w
		move.l	d0,($FFFFF6E4).w
		move.l	d1,($FFFFF6E8).w
		move.l	d2,($FFFFF6EC).w
		move.l	d5,($FFFFF6F0).w
		move.l	d6,($FFFFF6F4).w

locret_16DA:
		rts	
; ===========================================================================

loc_16DC:
		lea	(v_plc_buffer).w,a0
		moveq	#$15,d0

loc_16E2:
		move.l	6(a0),(a0)+
		dbf	d0,loc_16E2
		rts	
; End of function ProcessDPLC2

; ---------------------------------------------------------------------------
; Subroutine to	execute	the pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


QuickPLC:
		lea	(ArtLoadCues).l,a1 ; load the PLC index
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1	; get length of PLC

	Qplc_Loop:
		movea.l	(a1)+,a0	; get art pointer
		moveq	#0,d0
		move.w	(a1)+,d0	; get VRAM address
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l ; converted VRAM address to VDP format
		bsr.w	NemDec		; decompress
		dbf	d1,Qplc_Loop	; repeat for length of PLC
		rts	
; End of function QuickPLC

EniDec:		include "Includes\Enigma Decompression.asm"
KosDec:		include "Includes\Kosinski Decompression.asm"

PaletteCycle:	include "Includes\PaletteCycle.asm"
Pal_TitleCyc:	incbin	"Palettes\Cycle - Title Screen Water.bin"
Pal_GHZCyc:	incbin	"Palettes\Cycle - GHZ.bin"
Pal_LZCyc1:	incbin	"Palettes\Cycle - LZ Waterfall.bin"
Pal_LZCyc2:	incbin	"Palettes\Cycle - LZ Conveyor Belt.bin"
Pal_LZCyc3:	incbin	"Palettes\Cycle - LZ Conveyor Belt Underwater.bin"
Pal_SBZ3Cyc1:	incbin	"Palettes\Cycle - SBZ3 Waterfall.bin"
Pal_SLZCyc:	incbin	"Palettes\Cycle - SLZ.bin"
Pal_SYZCyc1:	incbin	"Palettes\Cycle - SYZ1.bin"
Pal_SYZCyc2:	incbin	"Palettes\Cycle - SYZ2.bin"

; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------

mSBZp:	macro duration,colours,paladdress,ramaddress
	dc.b duration, colours
	dc.w paladdress, ramaddress
	endm

; duration in frames, number of colours, palette address, RAM address

Pal_SBZCycList1:
	dc.w ((end_SBZCycList1-Pal_SBZCycList1-2)/6)-1
	mSBZp	7,8,Pal_SBZCyc1,v_pal_dry+$50
	mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry+$52
	mSBZp	$E,8,Pal_SBZCyc3,v_pal_dry+$6E
	mSBZp	$B,8,Pal_SBZCyc5,v_pal_dry+$70
	mSBZp	7,8,Pal_SBZCyc6,v_pal_dry+$72
	mSBZp	$1C,$10,Pal_SBZCyc7,v_pal_dry+$7E
	mSBZp	3,3,Pal_SBZCyc8,v_pal_dry+$78
	mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry+$7A
	mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry+$7C
end_SBZCycList1:
	even

Pal_SBZCycList2:
	dc.w ((end_SBZCycList2-Pal_SBZCycList2-2)/6)-1
	mSBZp	7,8,Pal_SBZCyc1,v_pal_dry+$50
	mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry+$52
	mSBZp	9,8,Pal_SBZCyc9,v_pal_dry+$70
	mSBZp	7,8,Pal_SBZCyc6,v_pal_dry+$72
	mSBZp	3,3,Pal_SBZCyc8,v_pal_dry+$78
	mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry+$7A
	mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry+$7C
end_SBZCycList2:
	even

Pal_SBZCyc1:	incbin	"Palettes\Cycle - SBZ 1.bin"
Pal_SBZCyc2:	incbin	"Palettes\Cycle - SBZ 2.bin"
Pal_SBZCyc3:	incbin	"Palettes\Cycle - SBZ 3.bin"
Pal_SBZCyc4:	incbin	"Palettes\Cycle - SBZ 4.bin"
Pal_SBZCyc5:	incbin	"Palettes\Cycle - SBZ 5.bin"
Pal_SBZCyc6:	incbin	"Palettes\Cycle - SBZ 6.bin"
Pal_SBZCyc7:	incbin	"Palettes\Cycle - SBZ 7.bin"
Pal_SBZCyc8:	incbin	"Palettes\Cycle - SBZ 8.bin"
Pal_SBZCyc9:	incbin	"Palettes\Cycle - SBZ 9.bin"
Pal_SBZCyc10:	incbin	"Palettes\Cycle - SBZ 10.bin"

		include	"Includes\PaletteFadeIn, PaletteFadeOut, PaletteWhiteIn & PaletteWhiteOut.asm"
		include	"Includes\PalCycle_Sega.asm"
Pal_Sega1:	incbin	"Palettes\Sega1.bin"
Pal_Sega2:	incbin	"Palettes\Sega2.bin"

; ---------------------------------------------------------------------------
; Subroutines to load palettes

; input:
;	d0 = index number for palette
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad1:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		adda.w	#v_pal_dry_dup-v_pal_dry,a3		; skip to "main" RAM address
		move.w	(a1)+,d7	; get length of palette data

	@loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,@loop
		rts	
; End of function PalLoad1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad2:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		move.w	(a1)+,d7	; get length of palette

	@loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,@loop
		rts	
; End of function PalLoad2

; ---------------------------------------------------------------------------
; Underwater palette loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad3_Water:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		suba.w	#v_pal_dry-v_pal_water,a3		; skip to "main" RAM address
		move.w	(a1)+,d7	; get length of palette data

	@loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,@loop
		rts	
; End of function PalLoad3_Water


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalLoad4_Water:
		lea	(PalPointers).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2	; get palette data address
		movea.w	(a1)+,a3	; get target RAM address
		suba.w	#v_pal_dry-v_pal_water_dup,a3
		move.w	(a1)+,d7	; get length of palette data

	@loop:
		move.l	(a2)+,(a3)+	; move data to RAM
		dbf	d7,@loop
		rts	
; End of function PalLoad4_Water

; ===========================================================================

; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro paladdress,ramaddress,colours
	id_\paladdress:	equ (*-PalPointers)/8
	dc.l paladdress
	dc.w ramaddress, (colours>>1)-1
	endm

PalPointers:

; palette address, RAM address, number of colours

		palp	Pal_SegaBG,v_pal_dry,$40	; 0 - Sega logo
		palp	Pal_Title,v_pal_dry,$40		; 1 - title screen
		palp	Pal_LevelSel,v_pal_dry,$40	; 2 - level select
		palp	Pal_Sonic,v_pal_dry,$10		; 3 - Sonic
Pal_Levels:
		palp	Pal_GHZ,v_pal_dry+$20, $30	; 4 - GHZ
		palp	Pal_LZ,v_pal_dry+$20,$30	; 5 - LZ
		palp	Pal_MZ,v_pal_dry+$20,$30	; 6 - MZ
		palp	Pal_SLZ,v_pal_dry+$20,$30	; 7 - SLZ
		palp	Pal_SYZ,v_pal_dry+$20,$30	; 8 - SYZ
		palp	Pal_SBZ1,v_pal_dry+$20,$30	; 9 - SBZ1
			zonewarning Pal_Levels,8
		palp	Pal_Special,v_pal_dry,$40	; $A (10) - special stage
		palp	Pal_LZWater,v_pal_dry,$40	; $B (11) - LZ underwater
		palp	Pal_SBZ3,v_pal_dry+$20,$30	; $C (12) - SBZ3
		palp	Pal_SBZ3Water,v_pal_dry,$40	; $D (13) - SBZ3 underwater
		palp	Pal_SBZ2,v_pal_dry+$20,$30	; $E (14) - SBZ2
		palp	Pal_LZSonWater,v_pal_dry,$10	; $F (15) - LZ Sonic underwater
		palp	Pal_SBZ3SonWat,v_pal_dry,$10	; $10 (16) - SBZ3 Sonic underwater
		palp	Pal_SSResult,v_pal_dry,$40	; $11 (17) - special stage results
		palp	Pal_Continue,v_pal_dry,$20	; $12 (18) - special stage results continue
		palp	Pal_Ending,v_pal_dry,$40	; $13 (19) - ending sequence
			even

; ---------------------------------------------------------------------------
; Palette data
; ---------------------------------------------------------------------------

Pal_SegaBG:	incbin	"Palettes\Sega Background.bin"
Pal_Title:	incbin	"Palettes\Title Screen.bin"
Pal_LevelSel:	incbin	"Palettes\Level Select.bin"
Pal_Sonic:	incbin	"Palettes\Sonic.bin"
Pal_GHZ:	incbin	"Palettes\Green Hill Zone.bin"
Pal_LZ:		incbin	"Palettes\Labyrinth Zone.bin"
Pal_LZWater:	incbin	"Palettes\Labyrinth Zone Underwater.bin"
Pal_MZ:		incbin	"Palettes\Marble Zone.bin"
Pal_SLZ:	incbin	"Palettes\Star Light Zone.bin"
Pal_SYZ:	incbin	"Palettes\Spring Yard Zone.bin"
Pal_SBZ1:	incbin	"Palettes\SBZ Act 1.bin"
Pal_SBZ2:	incbin	"Palettes\SBZ Act 2.bin"
Pal_Special:	incbin	"Palettes\Special Stage.bin"
Pal_SBZ3:	incbin	"Palettes\SBZ Act 3.bin"
Pal_SBZ3Water:	incbin	"Palettes\SBZ Act 3 Underwater.bin"
Pal_LZSonWater:	incbin	"Palettes\Sonic - LZ Underwater.bin"
Pal_SBZ3SonWat:	incbin	"Palettes\Sonic - SBZ3 Underwater.bin"
Pal_SSResult:	incbin	"Palettes\Special Stage Results.bin"
Pal_Continue:	incbin	"Palettes\Special Stage Continue Bonus.bin"
Pal_Ending:	incbin	"Palettes\Ending.bin"

		include "Includes\WaitForVBlank.asm"
		include "Objects\_RandomNumber.asm"
		include "Objects\_CalcSine & CalcAngle.asm"

; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

GM_Sega:
		play.b	1, bsr.w, cmd_Stop		; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8700,(a6)	; set background colour (palette entry 0)
		move.w	#$8B00,(a6)	; full-screen vertical scrolling
		clr.b	(f_water_pal_full).w
		disable_ints
		move.w	(v_vdp_mode_buffer).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		locVRAM	0
		lea	(Nem_SegaLogo).l,a0 ; load Sega	logo patterns
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_SegaLogo).l,a0 ; load Sega	logo mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$E510,$17,7
		copyTilemap	$FF0180,$C000,$27,$1B

		if Revision=0
		else
			tst.b   (v_megadrive).w	; is console Japanese?
			bmi.s   @loadpal
			copyTilemap	$FF0A40,$C53A,2,1 ; hide "TM" with a white rectangle
		endc

	@loadpal:
		moveq	#id_Pal_SegaBG,d0
		bsr.w	PalLoad2	; load Sega logo palette
		move.w	#-$A,(v_palcycle_num).w
		move.w	#0,(v_palcycle_time).w
		move.w	#0,(v_palcycle_buffer+$12).w
		move.w	#0,(v_palcycle_buffer+$10).w
		move.w	(v_vdp_mode_buffer).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

Sega_WaitPal:
		move.b	#2,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	PalCycle_Sega
		bne.s	Sega_WaitPal

		play.b	1, bsr.w, cmd_Sega		; play "SEGA" sound
		move.b	#$14,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		move.w	#$1E,(v_countdown).w

Sega_WaitEnd:
		move.b	#2,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		tst.w	(v_countdown).w
		beq.s	Sega_GotoTitle
		andi.b	#btnStart,(v_joypad_press_actual).w ; is Start button pressed?
		beq.s	Sega_WaitEnd	; if not, branch

Sega_GotoTitle:
		move.b	#id_Title,(v_gamemode).w ; go to title screen
		rts	
; ===========================================================================

; ---------------------------------------------------------------------------
; Title	screen
; ---------------------------------------------------------------------------

GM_Title:
		play.b	1, bsr.w, cmd_Stop		; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		disable_ints
		bsr.w	DacDriverLoad
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)	; set background colour (palette line 2, entry 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

	Tit_ClrObj1:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrObj1	; fill object space ($D000-$EFFF) with 0

		locVRAM	0
		lea	(Nem_JapNames).l,a0 ; load Japanese credits
		bsr.w	NemDec
		locVRAM	$14C0
		lea	(Nem_CreditText).l,a0 ;	load alphabet
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_JapNames).l,a0 ; load mappings for	Japanese credits
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$C000,$27,$1B

		lea	(v_pal_dry_dup).w,a1
		moveq	#cBlack,d0
		move.w	#$1F,d1

	Tit_ClrPal:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrPal	; fill palette with 0 (black)

		moveq	#id_Pal_Sonic,d0 ; load Sonic's palette
		bsr.w	PalLoad1
		move.b	#id_CreditsText,(v_ost_credits).w ; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	PaletteFadeIn
		disable_ints
		locVRAM	$4000
		lea	(Nem_TitleFg).l,a0 ; load title	screen patterns
		bsr.w	NemDec
		locVRAM	$6000
		lea	(Nem_TitleSonic).l,a0 ;	load Sonic title screen	patterns
		bsr.w	NemDec
		locVRAM	$A200
		lea	(Nem_TitleTM).l,a0 ; load "TM" patterns
		bsr.w	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM	$D000,4(a6)
		lea	(Art_Text).l,a5	; load level select font
		move.w	#$28F,d1

	Tit_LoadText:
		move.w	(a5)+,(a6)
		dbf	d1,Tit_LoadText	; load level select font

		move.b	#0,(v_last_lamppost).w ; clear lamppost counter
		move.w	#0,(v_debug_active).w ; disable debug item placement mode
		move.w	#0,(f_demo).w	; disable debug mode
		move.w	#0,($FFFFFFEA).w ; unused variable
		move.w	#(id_GHZ<<8),(v_zone).w	; set level to GHZ (00)
		move.w	#0,(v_palcycle_time).w ; disable palette cycling
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		lea	(v_16x16_tiles).w,a1
		lea	(Blk16_GHZ).l,a0 ; load	GHZ 16x16 mappings
		move.w	#0,d0
		bsr.w	EniDec
		lea	(Blk256_GHZ).l,a0 ; load GHZ 256x256 mappings
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
		bsr.w	DrawChunks
		lea	($FF0000).l,a1
		lea	(Eni_Title).l,a0 ; load	title screen mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$C206,$21,$15

		locVRAM	0
		lea	(Nem_GHZ_1st).l,a0 ; load GHZ patterns
		bsr.w	NemDec
		moveq	#id_Pal_Title,d0 ; load title screen palette
		bsr.w	PalLoad1
		play.b	1, bsr.w, mus_TitleScreen	; play title screen music
		move.b	#0,(f_debugmode).w ; disable debug mode
		move.w	#$178,(v_countdown).w ; run title screen for $178 frames
		lea	(v_ost_all+(sizeof_ost*2)).w,a1
		moveq	#0,d0
		move.w	#7,d1

	Tit_ClrObj2:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrObj2

		move.b	#id_TitleSonic,(v_ost_titlesonic).w ; load big Sonic object
		move.b	#id_PSBTM,(v_ost_psb).w ; load "PRESS START BUTTON" object
		;clr.b	(v_ost_psb+ost_routine).w ; The 'Mega Games 10' version of Sonic 1 added this line, to fix the 'PRESS START BUTTON' object not appearing

		if Revision=0
		else
			tst.b   (v_megadrive).w	; is console Japanese?
			bpl.s   @isjap		; if yes, branch
		endc

		move.b	#id_PSBTM,(v_ost_tm).w ; load "TM" object
		move.b	#3,(v_ost_tm+ost_frame).w
	@isjap:
		move.b	#id_PSBTM,(v_ost_titlemask).w ; load object which hides part of Sonic
		move.b	#2,(v_ost_titlemask+ost_frame).w
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		moveq	#id_PLC_Main,d0
		bsr.w	NewPLC
		move.w	#0,(v_title_dcount).w
		move.w	#0,(v_title_ccount).w
		move.w	(v_vdp_mode_buffer).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteFadeIn

Tit_MainLoop:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		bsr.w	PCycle_Title
		bsr.w	RunPLC
		move.w	(v_ost_all+ost_x_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(v_ost_all+ost_x_pos).w ; move Sonic to the right
		cmpi.w	#$1C00,d0	; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion	; if not, branch

		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_megadrive).w	; check	if the machine is US or	Japanese
		bpl.s	Tit_RegionJap	; if Japanese, branch

		lea	(LevSelCode_US).l,a0 ; load US code
		bra.s	Tit_EnterCheat

	Tit_RegionJap:
		lea	(LevSelCode_J).l,a0 ; load J code

Tit_EnterCheat:
		move.w	(v_title_dcount).w,d0
		adda.w	d0,a0
		move.b	(v_joypad_press_actual).w,d0 ; get button press
		andi.b	#btnDir,d0	; read only UDLR buttons
		cmp.b	(a0),d0		; does button press match the cheat code?
		bne.s	Tit_ResetCheat	; if not, branch
		addq.w	#1,(v_title_dcount).w ; next button press
		tst.b	d0
		bne.s	Tit_CountC
		lea	(f_levselcheat).w,a0
		move.w	(v_title_ccount).w,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Tit_PlayRing
		tst.b	(v_megadrive).w
		bpl.s	Tit_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)	; cheat depends on how many times C is pressed

	Tit_PlayRing:
		move.b	#1,(a0,d1.w)	; activate cheat
		play.b	1, bsr.w, sfx_Ring		; play ring sound when code is entered
		bra.s	Tit_CountC
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0
		beq.s	Tit_CountC
		cmpi.w	#9,(v_title_dcount).w
		beq.s	Tit_CountC
		move.w	#0,(v_title_dcount).w ; reset UDLR counter

Tit_CountC:
		move.b	(v_joypad_press_actual).w,d0
		andi.b	#btnC,d0	; is C button pressed?
		beq.s	loc_3230	; if not, branch
		addq.w	#1,(v_title_ccount).w ; increment C counter

loc_3230:
		tst.w	(v_countdown).w
		beq.w	GotoDemo
		andi.b	#btnStart,(v_joypad_press_actual).w ; check if Start is pressed
		beq.w	Tit_MainLoop	; if not, branch

Tit_ChkLevSel:
		tst.b	(f_levselcheat).w ; check if level select code is on
		beq.w	PlayLevel	; if not, play level
		btst	#bitA,(v_joypad_hold_actual).w ; check if A is pressed
		beq.w	PlayLevel	; if not, play level

		moveq	#id_Pal_LevelSel,d0
		bsr.w	PalLoad2	; load level select palette
		lea	(v_hscroll_buffer).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

	Tit_ClrScroll1:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrScroll1 ; clear scroll data (in RAM)

		move.l	d0,(v_fg_y_pos_vsram).w
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	$E000
		move.w	#$3FF,d1

	Tit_ClrScroll2:
		move.l	d0,(a6)
		dbf	d1,Tit_ClrScroll2 ; clear scroll data (in VRAM)

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
		beq.s	LevelSelect	; if not, branch
		move.w	(v_levselitem).w,d0
		cmpi.w	#$14,d0		; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS	; if not, go to	Level/SS subroutine
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		tst.b	(f_creditscheat).w ; is Japanese Credits cheat on?
		beq.s	LevSel_NoCheat	; if not, branch
		cmpi.w	#$9F,d0		; is sound $9F being played?
		beq.s	LevSel_Ending	; if yes, branch
		cmpi.w	#$9E,d0		; is sound $9E being played?
		beq.s	LevSel_Credits	; if yes, branch

LevSel_NoCheat:
		; This is a workaround for a bug, see Sound_ChkValue for more.
		; Once you've fixed the bugs there, comment these four instructions out
		cmpi.w	#_lastMusic+1,d0	; is sound $80-$93 being played?
		blo.s	LevSel_PlaySnd	; if yes, branch
		cmpi.w	#_firstSfx,d0	; is sound $94-$9F being played?
		blo.s	LevelSelect	; if yes, branch

LevSel_PlaySnd:
		bsr.w	PlaySound1
		bra.s	LevelSelect
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w ; set screen mode to $18 (Ending)
		move.w	#(id_EndZ<<8),(v_zone).w ; set level to 0600 (Ending)
		rts	
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w ; set screen mode to $1C (Credits)
		play.b	1, bsr.w, mus_Credits		; play credits music
		move.w	#0,(v_creditsnum).w
		rts	
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0
		move.w	LevSel_Ptrs(pc,d0.w),d0 ; load level number
		bmi.w	LevelSelect
		cmpi.w	#id_SS*$100,d0	; check	if level is 0700 (Special Stage)
		bne.s	LevSel_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).w ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w	; clear	level
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		if Revision=0
		else
			move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		endc
		rts	
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0
		move.w	d0,(v_zone).w	; set level number

PlayLevel:
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		move.b	d0,(v_last_ss_levelid).w ; clear special stage number
		move.b	d0,(v_emeralds).w ; clear emeralds
		move.l	d0,(v_emerald_list).w ; clear emeralds
		move.l	d0,(v_emerald_list+4).w ; clear emeralds
		move.b	d0,(v_continues).w ; clear continues
		if Revision=0
		else
			move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		endc
		play.b	1, bsr.w, cmd_Fade		; fade out music
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
		dc.b id_LZ, 3		; Scrap Brain Zone 3
		dc.b id_SBZ, 2		; Final Zone
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
		dc.b id_SS, 0		; Special Stage
		dc.w $8000		; Sound Test
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
; ===========================================================================

; ---------------------------------------------------------------------------
; Demo mode
; ---------------------------------------------------------------------------

GotoDemo:
		move.w	#$1E,(v_countdown).w

loc_33B6:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_ost_all+ost_x_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(v_ost_all+ost_x_pos).w
		cmpi.w	#$1C00,d0
		blo.s	loc_33E4
		move.b	#id_Sega,(v_gamemode).w
		rts	
; ===========================================================================

loc_33E4:
		andi.b	#btnStart,(v_joypad_press_actual).w ; is Start button pressed?
		bne.w	Tit_ChkLevSel	; if yes, branch
		tst.w	(v_countdown).w
		bne.w	loc_33B6
		play.b	1, bsr.w, cmd_Fade		; fade out music
		move.w	(v_demonum).w,d0 ; load	demo number
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Demo_Levels(pc,d0.w),d0	; load level number for	demo
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demonum).w ; add 1 to demo number
		cmpi.w	#4,(v_demonum).w ; is demo number less than 4?
		blo.s	loc_3422	; if yes, branch
		move.w	#0,(v_demonum).w ; reset demo number to	0

loc_3422:
		move.w	#1,(f_demo).w	; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w ; set screen mode to 08 (demo)
		cmpi.w	#$600,d0	; is level number 0600 (special	stage)?
		bne.s	Demo_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).w ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w	; clear	level number
		clr.b	(v_last_ss_levelid).w ; clear special stage number

Demo_Level:
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		if Revision=0
		else
			move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		endc
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Levels used in demos
; ---------------------------------------------------------------------------
Demo_Levels:	incbin	"Misc Data\Demo Level Order - Intro.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	change what you're selecting in the level select
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelControls:
		move.b	(v_joypad_press_actual).w,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed and held?
		bne.s	LevSel_UpDown	; if yes, branch
		subq.w	#1,(v_levseldelay).w ; subtract 1 from time to next move
		bpl.s	LevSel_SndTest	; if time remains, branch

LevSel_UpDown:
		move.w	#$B,(v_levseldelay).w ; reset time delay
		move.b	(v_joypad_hold_actual).w,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed?
		beq.s	LevSel_SndTest	; if not, branch
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1	; is up	pressed?
		beq.s	LevSel_Down	; if not, branch
		subq.w	#1,d0		; move up 1 selection
		bhs.s	LevSel_Down
		moveq	#$14,d0		; if selection moves below 0, jump to selection	$14

LevSel_Down:
		btst	#bitDn,d1	; is down pressed?
		beq.s	LevSel_Refresh	; if not, branch
		addq.w	#1,d0		; move down 1 selection
		cmpi.w	#$15,d0
		blo.s	LevSel_Refresh
		moveq	#0,d0		; if selection moves above $14,	jump to	selection 0

LevSel_Refresh:
		move.w	d0,(v_levselitem).w ; set new selection
		bsr.w	LevSelTextLoad	; refresh text
		rts	
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#$14,(v_levselitem).w ; is item $14 selected?
		bne.s	LevSel_NoMove	; if not, branch
		move.b	(v_joypad_press_actual).w,d1
		andi.b	#btnR+btnL,d1	; is left/right	pressed?
		beq.s	LevSel_NoMove	; if not, branch
		move.w	(v_levselsound).w,d0
		btst	#bitL,d1	; is left pressed?
		beq.s	LevSel_Right	; if not, branch
		subq.w	#1,d0		; subtract 1 from sound	test
		bhs.s	LevSel_Right
		moveq	#$4F,d0		; if sound test	moves below 0, set to $4F

LevSel_Right:
		btst	#bitR,d1	; is right pressed?
		beq.s	LevSel_Refresh2	; if not, branch
		addq.w	#1,d0		; add 1	to sound test
		cmpi.w	#$50,d0
		blo.s	LevSel_Refresh2
		moveq	#0,d0		; if sound test	moves above $4F, set to	0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).w ; set sound test number
		bsr.w	LevSelTextLoad	; refresh text

LevSel_NoMove:
		rts	
; End of function LevSelControls

; ---------------------------------------------------------------------------
; Subroutine to load level select text
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelTextLoad:

	textpos:	= ($40000000+(($E210&$3FFF)<<16)+(($E210&$C000)>>14))
					; $E210 is a VRAM address

		lea	(LevelMenuText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#textpos,d4	; text position on screen
		move.w	#$E680,d3	; VRAM setting (4th palette, $680th tile)
		moveq	#$14,d1		; number of lines of text

	LevSel_DrawAll:
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; draw line of text
		addi.l	#$800000,d4	; jump to next line
		dbf	d1,LevSel_DrawAll

		moveq	#0,d0
		move.w	(v_levselitem).w,d0
		move.w	d0,d1
		move.l	#textpos,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelMenuText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3	; VRAM setting (3rd palette, $680th tile)
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; recolour selected line
		move.w	#$E680,d3
		cmpi.w	#$14,(v_levselitem).w
		bne.s	LevSel_DrawSnd
		move.w	#$C680,d3

LevSel_DrawSnd:
		locVRAM	$EC30		; sound test position on screen
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	LevSel_ChgSnd	; draw 1st digit
		move.b	d2,d0
		bsr.w	LevSel_ChgSnd	; draw 2nd digit
		rts	
; End of function LevSelTextLoad


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgSnd:
		andi.w	#$F,d0
		cmpi.b	#$A,d0		; is digit $A-$F?
		blo.s	LevSel_Numb	; if not, branch
		addi.b	#7,d0		; use alpha characters

	LevSel_Numb:
		add.w	d3,d0
		move.w	d0,(a6)
		rts	
; End of function LevSel_ChgSnd


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgLine:
		moveq	#$17,d2		; number of characters per line

	LevSel_LineLoop:
		moveq	#0,d0
		move.b	(a1)+,d0	; get character
		bpl.s	LevSel_CharOk	; branch if valid
		move.w	#0,(a6)		; use blank character
		dbf	d2,LevSel_LineLoop
		rts	


	LevSel_CharOk:
		add.w	d3,d0		; combine char with VRAM setting
		move.w	d0,(a6)		; send to VRAM
		dbf	d2,LevSel_LineLoop
		rts	
; End of function LevSel_ChgLine

; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select menu text
; ---------------------------------------------------------------------------
LevelMenuText:	if Revision=0
		incbin	"Misc Data\Level Select Text.bin"
		else
		incbin	"Misc Data\Level Select Text (JP1).bin"
		endc
		even
; ---------------------------------------------------------------------------
; Music playlist
; ---------------------------------------------------------------------------
MusicList:
		dc.b mus_GHZ	; GHZ
		dc.b mus_LZ	; LZ
		dc.b mus_MZ	; MZ
		dc.b mus_SLZ	; SLZ
		dc.b mus_SYZ	; SYZ
		dc.b mus_SBZ	; SBZ
		zonewarning MusicList,1
		dc.b mus_FZ	; Ending
		even
; ===========================================================================

; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

GM_Level:
		bset	#7,(v_gamemode).w ; add $80 to screen mode (for pre level sequence)
		tst.w	(f_demo).w
		bmi.s	Level_NoMusicFade
		play.b	1, bsr.w, cmd_Fade		; fade out music

	Level_NoMusicFade:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		tst.w	(f_demo).w	; is an ending sequence demo running?
		bmi.s	Level_ClrRam	; if yes, branch
		disable_ints
		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		enable_ints
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_37FC
		bsr.w	AddPLC		; load level patterns

loc_37FC:
		moveq	#id_PLC_Main2,d0
		bsr.w	AddPLC		; load standard	patterns

Level_ClrRam:
		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

	Level_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrObjRam ; clear object RAM

		lea	(v_vblank_0e_counter).w,a1
		moveq	#0,d0
		move.w	#$15,d1

	Level_ClrVars1:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars1 ; clear misc variables

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

	Level_ClrVars2:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars2 ; clear misc variables

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#$47,d1

	Level_ClrVars3:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars3 ; clear object variables

		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_vdp_hint_counter).w ; set palette change position (for water)
		move.w	(v_vdp_hint_counter).w,(a6)
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
		bne.s	Level_LoadPal	; if not, branch

		move.w	#$8014,(a6)	; enable H-interrupts
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		lea	(WaterHeight).l,a1 ; load water	height array
		move.w	(a1,d0.w),d0
		move.w	d0,(v_water_height_actual).w ; set water heights
		move.w	d0,(v_water_height_normal).w
		move.w	d0,(v_water_height_next).w
		clr.b	(v_water_routine).w ; clear water routine counter
		clr.b	(f_water_pal_full).w	; clear	water state
		move.b	#1,(v_water_direction).w ; enable water

Level_LoadPal:
		move.w	#30,(v_air).w
		enable_ints
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad2	; load Sonic's palette
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
		bne.s	Level_GetBgm	; if not, branch

		moveq	#id_Pal_LZSonWater,d0 ; palette number $F (LZ)
		cmpi.b	#3,(v_act).w	; is act number 3?
		bne.s	Level_WaterPal	; if not, branch
		moveq	#id_Pal_SBZ3SonWat,d0 ; palette number $10 (SBZ3)

	Level_WaterPal:
		bsr.w	PalLoad3_Water	; load underwater palette
		tst.b	(v_last_lamppost).w
		beq.s	Level_GetBgm
		move.b	($FFFFFE53).w,(f_water_pal_full).w

Level_GetBgm:
		tst.w	(f_demo).w
		bmi.s	Level_SkipTtlCard
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; is level SBZ3?
		bne.s	Level_BgmNotLZ4	; if not, branch
		moveq	#5,d0		; use 5th music (SBZ)

	Level_BgmNotLZ4:
		cmpi.w	#(id_SBZ<<8)+2,(v_zone).w ; is level FZ?
		bne.s	Level_PlayBgm	; if not, branch
		moveq	#6,d0		; use 6th music (FZ)

	Level_PlayBgm:
		lea	(MusicList).l,a1 ; load	music playlist
		move.b	(a1,d0.w),d0
		bsr.w	PlaySound0	; play music
		move.b	#id_TitleCard,(v_ost_titlecard1).w ; load title card object

Level_TtlCardLoop:
		move.b	#$C,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC
		move.w	(v_ost_titlecard3+ost_x_pos).w,d0
		cmp.w	(v_ost_titlecard3+ost_card_x_stop).w,d0 ; has title card sequence finished?
		bne.s	Level_TtlCardLoop ; if not, branch
		tst.l	(v_plc_buffer).w ; are there any items in the pattern load cue?
		bne.s	Level_TtlCardLoop ; if yes, branch
		jsr	(Hud_Base).l	; load basic HUD gfx

	Level_SkipTtlCard:
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad1	; load Sonic's palette
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#redraw_left_bit,(v_fg_redraw_direction).w
		bsr.w	LevelDataLoad ; load block mappings and palettes
		bsr.w	LoadTilesFromStart
		jsr	(ConvertCollisionArray).l
		bsr.w	ColIndexLoad
		bsr.w	LZWaterFeatures
		move.b	#id_SonicPlayer,(v_ost_player).w ; load Sonic object
		tst.w	(f_demo).w
		bmi.s	Level_ChkDebug
		move.b	#id_HUD,(v_ost_hud).w ; load HUD object

Level_ChkDebug:
		tst.b	(f_debugcheat).w ; has debug cheat been entered?
		beq.s	Level_ChkWater	; if not, branch
		btst	#bitA,(v_joypad_hold_actual).w ; is A button held?
		beq.s	Level_ChkWater	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

Level_ChkWater:
		move.w	#0,(v_joypad_hold).w
		move.w	#0,(v_joypad_hold_actual).w
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
		bne.s	Level_LoadObj	; if not, branch
		move.b	#id_WaterSurface,(v_ost_watersurface1).w ; load water surface object
		move.w	#$60,(v_ost_watersurface1+ost_x_pos).w
		move.b	#id_WaterSurface,(v_ost_watersurface2).w
		move.w	#$120,(v_ost_watersurface2+ost_x_pos).w

Level_LoadObj:
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		moveq	#0,d0
		tst.b	(v_last_lamppost).w	; are you starting from	a lamppost?
		bne.s	Level_SkipClr	; if yes, branch
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.b	d0,(v_ring_reward).w ; clear lives counter

	Level_SkipClr:
		move.b	d0,(f_time_over).w
		move.b	d0,(v_shield).w	; clear shield
		move.b	d0,(v_invincibility).w	; clear invincibility
		move.b	d0,(v_shoes).w	; clear speed shoes
		move.b	d0,(v_unused_powerup).w
		move.w	d0,(v_debug_active).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_frame_counter).w
		bsr.w	OscillateNumInit
		move.b	#1,(f_hud_score_update).w ; update score counter
		move.b	#1,(v_hud_rings_update).w ; update rings counter
		move.b	#1,(f_hud_time_update).w ; update time counter
		move.w	#0,(v_demo_input_counter).w
		lea	(DemoDataPtr).l,a1 ; load demo data
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		tst.w	(f_demo).w	; is demo mode on?
		bpl.s	Level_Demo	; if yes, branch
		lea	(DemoEndDataPtr).l,a1 ; load ending demo data
		move.w	(v_creditsnum).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1

Level_Demo:
		move.b	1(a1),(v_demo_input_time).w ; load key press duration
		subq.b	#1,(v_demo_input_time).w ; subtract 1 from duration
		move.w	#1800,(v_countdown).w
		tst.w	(f_demo).w
		bpl.s	Level_ChkWaterPal
		move.w	#540,(v_countdown).w
		cmpi.w	#4,(v_creditsnum).w
		bne.s	Level_ChkWaterPal
		move.w	#510,(v_countdown).w

Level_ChkWaterPal:
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ/SBZ3?
		bne.s	Level_Delay	; if not, branch
		moveq	#id_Pal_LZWater,d0 ; palette $B (LZ underwater)
		cmpi.b	#3,(v_act).w	; is level SBZ3?
		bne.s	Level_WtrNotSbz	; if not, branch
		moveq	#id_Pal_SBZ3Water,d0 ; palette $D (SBZ3 underwater)

	Level_WtrNotSbz:
		bsr.w	PalLoad4_Water

Level_Delay:
		move.w	#3,d1

	Level_DelayLoop:
		move.b	#8,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		dbf	d1,Level_DelayLoop

		move.w	#$202F,(v_palfade_start).w ; fade in 2nd, 3rd & 4th palette lines
		bsr.w	PalFadeIn_Alt
		tst.w	(f_demo).w	; is an ending sequence demo running?
		bmi.s	Level_ClrCardArt ; if yes, branch
		addq.b	#2,(v_ost_titlecard1+ost_routine).w ; make title card move
		addq.b	#4,(v_ost_titlecard2+ost_routine).w
		addq.b	#4,(v_ost_titlecard3+ost_routine).w
		addq.b	#4,(v_ost_titlecard4+ost_routine).w
		bra.s	Level_StartGame
; ===========================================================================

Level_ClrCardArt:
		moveq	#id_PLC_Explode,d0
		jsr	(AddPLC).l	; load explosion gfx
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#id_PLC_GHZAnimals,d0
		jsr	(AddPLC).l	; load animal gfx (level no. + $15)

Level_StartGame:
		bclr	#7,(v_gamemode).w ; subtract $80 from mode to end pre-level stuff

; ---------------------------------------------------------------------------
; Main level loop (when	all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame
		move.b	#8,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w ; add 1 to level timer
		bsr.w	MoveSonicInDemo
		bsr.w	LZWaterFeatures
		jsr	(ExecuteObjects).l
		if Revision=0
		else
			tst.w   (f_restart).w
			bne     GM_Level
		endc
		tst.w	(v_debug_active).w	; is debug mode being used?
		bne.s	Level_DoScroll	; if yes, branch
		cmpi.b	#6,(v_ost_player+ost_routine).w ; has Sonic just died?
		bhs.s	Level_SkipScroll ; if yes, branch

	Level_DoScroll:
		bsr.w	DeformLayers

	Level_SkipScroll:
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		bsr.w	SignpostArtLoad

		cmpi.b	#id_Demo,(v_gamemode).w
		beq.s	Level_ChkDemo	; if mode is 8 (demo), branch
		if Revision=0
		tst.w	(f_restart).w	; is the level set to restart?
		bne.w	GM_Level	; if yes, branch
		else
		endc
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	Level_MainLoop	; if mode is $C (level), branch
		rts	
; ===========================================================================

Level_ChkDemo:
		tst.w	(f_restart).w	; is level set to restart?
		bne.s	Level_EndDemo	; if yes, branch
		tst.w	(v_countdown).w ; is there time left on the demo?
		beq.s	Level_EndDemo	; if not, branch
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	Level_MainLoop	; if mode is 8 (demo), branch
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Level_EndDemo:
		cmpi.b	#id_Demo,(v_gamemode).w
		bne.s	Level_FadeDemo	; if mode is 8 (demo), branch
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		tst.w	(f_demo).w	; is demo mode on & not ending sequence?
		bpl.s	Level_FadeDemo	; if yes, branch
		move.b	#id_Credits,(v_gamemode).w ; go to credits

Level_FadeDemo:
		move.w	#$3C,(v_countdown).w
		move.w	#$3F,(v_palfade_start).w
		clr.w	(v_palfade_time).w

	Level_FDLoop:
		move.b	#8,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		subq.w	#1,(v_palfade_time).w
		bpl.s	loc_3BC8
		move.w	#2,(v_palfade_time).w
		bsr.w	FadeOut_ToBlack

loc_3BC8:
		tst.w	(v_countdown).w
		bne.s	Level_FDLoop
		rts	
; ===========================================================================

		include "Includes\LZWaterFeatures.asm"

; ---------------------------------------------------------------------------
; Subroutine to	move Sonic in demo mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveSonicInDemo:
		tst.w	(f_demo).w	; is demo mode on?
		bne.s	MDemo_On	; if yes, branch
		rts	
; ===========================================================================

; This is an unused subroutine for recording a demo

DemoRecorder:
		lea	($80000).l,a1
		move.w	(v_demo_input_counter).w,d0
		adda.w	d0,a1
		move.b	(v_joypad_hold_actual).w,d0
		cmp.b	(a1),d0
		bne.s	@next
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	@next
		rts	

	@next:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(v_demo_input_counter).w
		andi.w	#$3FF,(v_demo_input_counter).w
		rts	
; ===========================================================================

MDemo_On:
		tst.b	(v_joypad_hold_actual).w	; is start button pressed?
		bpl.s	@dontquit	; if not, branch
		tst.w	(f_demo).w	; is this an ending sequence demo?
		bmi.s	@dontquit	; if yes, branch
		move.b	#id_Title,(v_gamemode).w ; go to title screen

	@dontquit:
		lea	(DemoDataPtr).l,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.b	#id_Special,(v_gamemode).w ; is this a special stage?
		bne.s	@notspecial	; if not, branch
		moveq	#6,d0		; use demo #6

	@notspecial:
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1	; fetch address for demo data
		tst.w	(f_demo).w	; is this an ending sequence demo?
		bpl.s	@notcredits	; if not, branch
		lea	(DemoEndDataPtr).l,a1
		move.w	(v_creditsnum).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1	; fetch address for credits demo

	@notcredits:
		move.w	(v_demo_input_counter).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(v_joypad_hold_actual).w,a0
		move.b	d0,d1
		if Revision=0
		move.b	(a0),d2
		else
			moveq	#0,d2
		endc
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_demo_input_time).w
		bcc.s	@end
		move.b	3(a1),(v_demo_input_time).w
		addq.w	#2,(v_demo_input_counter).w

	@end:
		rts	
; End of function MoveSonicInDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; Demo sequence	pointers
; ---------------------------------------------------------------------------
DemoDataPtr:	dc.l Demo_GHZ		; demos run after the title screen
		dc.l Demo_GHZ
		dc.l Demo_MZ
		dc.l Demo_MZ
		dc.l Demo_SYZ
		dc.l Demo_SYZ
		dc.l Demo_SS
		dc.l Demo_SS

DemoEndDataPtr:	dc.l Demo_EndGHZ1	; demos run during the credits
		dc.l Demo_EndMZ
		dc.l Demo_EndSYZ
		dc.l Demo_EndLZ
		dc.l Demo_EndSLZ
		dc.l Demo_EndSBZ1
		dc.l Demo_EndSBZ2
		dc.l Demo_EndGHZ2

		dc.b 0,	$8B, 8,	$37, 0,	$42, 8,	$5C, 0,	$6A, 8,	$5F, 0,	$2F, 8,	$2C
		dc.b 0,	$21, 8,	3, $28,	$30, 8,	8, 0, $2E, 8, $15, 0, $F, 8, $46
		dc.b 0,	$1A, 8,	$FF, 8,	$CA, 0,	0, 0, 0, 0, 0, 0, 0, 0,	0
		even

; ---------------------------------------------------------------------------
; Collision index pointer loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ColIndexLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		move.l	ColPointers(pc,d0.w),(v_collision_index_ptr).w
		rts	
; End of function ColIndexLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision index pointers
; ---------------------------------------------------------------------------
ColPointers:	dc.l Col_GHZ
		dc.l Col_LZ
		dc.l Col_MZ
		dc.l Col_SLZ
		dc.l Col_SYZ
		dc.l Col_SBZ
		zonewarning ColPointers,4
;		dc.l Col_GHZ ; Pointer for Ending is missing by default.

		include "Includes\OscillateNumInit & OscillateNumDo.asm"
		include "Includes\SynchroAnimate.asm"

; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SignpostArtLoad:
		tst.w	(v_debug_active).w	; is debug mode	being used?
		bne.w	@exit		; if yes, branch
		cmpi.b	#2,(v_act).w	; is act number 02 (act 3)?
		beq.s	@exit		; if yes, branch

		move.w	(v_camera_x_pos).w,d0
		move.w	(v_boundary_right).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0		; has Sonic reached the	edge of	the level?
		blt.s	@exit		; if not, branch
		tst.b	(f_hud_time_update).w
		beq.s	@exit
		cmp.w	(v_boundary_left).w,d1
		beq.s	@exit
		move.w	d1,(v_boundary_left).w ; move left boundary to current screen position
		moveq	#id_PLC_Signpost,d0
		bra.w	NewPLC		; load signpost	patterns

	@exit:
		rts	
; End of function SignpostArtLoad

; ===========================================================================
Demo_GHZ:	incbin	"demodata\Intro - GHZ.bin"
Demo_MZ:	incbin	"demodata\Intro - MZ.bin"
Demo_SYZ:	incbin	"demodata\Intro - SYZ.bin"
Demo_SS:	incbin	"demodata\Intro - Special Stage.bin"
; ===========================================================================

; ---------------------------------------------------------------------------
; Special Stage
; ---------------------------------------------------------------------------

GM_Special:
		play.w	1, bsr.w, sfx_EnterSS		; play special stage entry sound
		bsr.w	PaletteWhiteOut
		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8A00+175,(v_vdp_hint_counter).w
		move.w	#$9011,(a6)	; 128-cell hscroll size
		move.w	(v_vdp_mode_buffer).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		enable_ints
		dma_fill	0,$6FFF,$5000

	SS_WaitForDMA:
		move.w	(a5),d1		; read control port ($C00004)
		btst	#1,d1		; is DMA running?
		bne.s	SS_WaitForDMA	; if yes, branch
		move.w	#$8F02,(a5)	; set VDP increment to 2 bytes
		bsr.w	SS_BGLoad
		moveq	#id_PLC_SpecialStage,d0
		bsr.w	QuickPLC	; load special stage patterns

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	SS_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrObjRam	; clear	the object RAM

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#$3F,d1
	SS_ClrRam1:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrRam1	; clear	variables

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#$27,d1
	SS_ClrRam2:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrRam2	; clear	variables

		lea	(v_nem_gfx_buffer).w,a1
		moveq	#0,d0
		move.w	#$7F,d1
	SS_ClrNemRam:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrNemRam	; clear	Nemesis	buffer

		clr.b	(f_water_pal_full).w
		clr.w	(f_restart).w
		moveq	#id_Pal_Special,d0
		bsr.w	PalLoad1	; load special stage palette
		jsr	(SS_Load).l	; load SS layout data
		move.l	#0,(v_camera_x_pos).w
		move.l	#0,(v_camera_y_pos).w
		move.b	#id_SonicSpecial,(v_ost_player).w ; load special stage Sonic object
		bsr.w	PalCycle_SS
		clr.w	(v_ss_angle).w	; set stage angle to "upright"
		move.w	#$40,(v_ss_rotation_speed).w ; set stage rotation speed
		play.w	0, bsr.w, mus_SpecialStage	; play special stage BG	music
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
		tst.b	(f_debugcheat).w ; has debug cheat been entered?
		beq.s	SS_NoDebug	; if not, branch
		btst	#bitA,(v_joypad_hold_actual).w ; is A button pressed?
		beq.s	SS_NoDebug	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

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
		tst.w	(f_demo).w	; is demo mode on?
		beq.s	SS_ChkEnd	; if not, branch
		tst.w	(v_countdown).w ; is there time left on the demo?
		beq.w	SS_ToSegaScreen	; if not, branch

	SS_ChkEnd:
		cmpi.b	#id_Special,(v_gamemode).w ; is game mode $10 (special stage)?
		beq.w	SS_MainLoop	; if yes, branch

		tst.w	(f_demo).w	; is demo mode on?
		if Revision=0
		bne.w	SS_ToSegaScreen	; if yes, branch
		else
		bne.w	SS_ToLevel
		endc
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		cmpi.w	#(id_SBZ<<8)+3,(v_zone).w ; is level number higher than FZ?
		blo.s	SS_Finish	; if not, branch
		clr.w	(v_zone).w	; set to GHZ1

SS_Finish:
		move.w	#60,(v_countdown).w ; set delay time to 1 second
		move.w	#$3F,(v_palfade_start).w
		clr.w	(v_palfade_time).w

	SS_FinLoop:
		move.b	#$16,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	MoveSonicInDemo
		move.w	(v_joypad_hold_actual).w,(v_joypad_hold).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(SS_ShowLayout).l
		bsr.w	SS_BGAnimate
		subq.w	#1,(v_palfade_time).w
		bpl.s	loc_47D4
		move.w	#2,(v_palfade_time).w
		bsr.w	WhiteOut_ToWhite

loc_47D4:
		tst.w	(v_countdown).w
		bne.s	SS_FinLoop

		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		bsr.w	ClearScreen
		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		jsr	(Hud_Base).l
		enable_ints
		moveq	#id_Pal_SSResult,d0
		bsr.w	PalLoad2	; load results screen palette
		moveq	#id_PLC_Main,d0
		bsr.w	NewPLC
		moveq	#id_PLC_SSResult,d0
		bsr.w	AddPLC		; load results screen patterns
		move.b	#1,(f_hud_score_update).w ; update score counter
		move.b	#1,(f_pass_bonus_update).w ; update ring bonus counter
		move.w	(v_rings).w,d0
		mulu.w	#10,d0		; multiply rings by 10
		move.w	d0,(v_ring_bonus).w ; set rings bonus
		play.w	1, jsr, mus_GotThrough		; play end-of-level music

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	SS_EndClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,SS_EndClrObjRam ; clear object RAM

		move.b	#id_SSResult,(v_ost_ssresult1).w ; load results screen object

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
		play.w	1, bsr.w, sfx_EnterSS		; play special stage exit sound
		bsr.w	PaletteWhiteOut
		rts	
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w ; goto Sega screen
		rts

		if Revision=0
		else
SS_ToLevel:	cmpi.b	#id_Level,(v_gamemode).w
		beq.s	SS_ToSegaScreen
		rts
		endc

; ---------------------------------------------------------------------------
; Special stage	background loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_BGLoad:
		lea	($FF0000).l,a1
		lea	(Eni_SSBg1).l,a0 ; load	mappings for the birds and fish
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	($FF0080).l,a2
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
		lea	($FF0000).l,a1

loc_48E2:
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_48F2:
		addi.l	#$100000,d0
		dbf	d5,loc_48CE
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_48CC
		addi.l	#$10000000,d3
		bpl.s	loc_491C
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_491C:
		adda.w	#$80,a2
		dbf	d7,loc_48BE
		lea	($FF0000).l,a1
		lea	(Eni_SSBg2).l,a0 ; load	mappings for the clouds
		move.w	#$4000,d0
		bsr.w	EniDec
		lea	($FF0000).l,a1
		move.l	#$40000003,d0
		moveq	#$3F,d1
		moveq	#$1F,d2
		bsr.w	TilemapToVRAM
		lea	($FF0000).l,a1
		move.l	#$50000003,d0
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
		tst.w	(f_pause).w	; is game paused?
		bne.s	@exit		; if yes, branch
		subq.w	#1,(v_palcycle_ss_time).w ; decrement timer
		bpl.s	@exit		; branch if time remains
		lea	(vdp_control_port).l,a6
		move.w	(v_palcycle_ss_num).w,d0 ; get cycle index counter
		addq.w	#1,(v_palcycle_ss_num).w ; increment
		andi.w	#$1F,d0		; read only bits 0-4
		lsl.w	#2,d0		; multiply by 4
		lea	(SS_Timing_Values).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0	; get time byte
		bpl.s	@use_time	; branch if not -1
		move.w	#$1FF,d0	; use $1FF if -1

	@use_time:
		move.w	d0,(v_palcycle_ss_time).w ; set time until next palette change
		moveq	#0,d0
		move.b	(a0)+,d0	; get bg mode byte
		move.w	d0,(v_ss_bg_mode).w
		lea	(SS_BG_Modes).l,a1
		lea	(a1,d0.w),a1	; jump to mode data
		move.w	#$8200,d0	; VDP register - fg nametable address
		move.b	(a1)+,d0	; apply address from mode data
		move.w	d0,(a6)		; send VDP instruction
		move.b	(a1),(v_fg_y_pos_vsram).w ; get byte to send to VSRAM
		move.w	#$8400,d0	; VDP register - bg nametable address
		move.b	(a0)+,d0	; apply address from list
		move.w	d0,(a6)		; send VDP instruction
		move.l	#$40000010,(vdp_control_port).l ; set VDP to VSRAM write mode
		move.l	(v_fg_y_pos_vsram).w,(vdp_data_port).l ; update VSRAM
		moveq	#0,d0
		move.b	(a0)+,d0	; get palette offset
		bmi.s	PalCycle_SS_2	; branch if $80+
		lea	(Pal_SSCyc1).l,a1 ; use palette cycle set 1
		adda.w	d0,a1
		lea	(v_pal_dry+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+	; write palette

	@exit:
		rts	
; ===========================================================================

PalCycle_SS_2:
		move.w	(v_palcycle_ss_unused).w,d1 ; this is always 0
		cmpi.w	#$8A,d0		; is offset $80-$89?
		blo.s	@offset_80_89	; if yes, branch
		addq.w	#1,d1

	@offset_80_89:
		mulu.w	#$2A,d1		; d1 = always 0 or $2A
		lea	(Pal_SSCyc2).l,a1 ; use palette cycle set 2
		adda.w	d1,a1
		andi.w	#$7F,d0		; ignore bit 7
		bclr	#0,d0		; clear bit 0
		beq.s	@offset_even	; branch if already clear
		lea	(v_pal_dry+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+	; write palette

	@offset_even:
		adda.w	#$C,a1
		lea	(v_pal_dry+$5A).w,a2
		cmpi.w	#$A,d0		; is offset 0-8?
		blo.s	@offset_0_8	; if yes, branch
		subi.w	#$A,d0
		lea	(v_pal_dry+$7A).w,a2

	@offset_0_8:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0		; multiply d0 by 3
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+	; write palette
		rts	
; End of function PalCycle_SS

; ===========================================================================
SS_Timing_Values:
		dc.b 3,	0, $E000>>13, $92	; time until next, bg mode, bg namespace address in VRAM, palette offset
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
SS_BG_Modes:				; fg namespace address in VRAM, VScroll value
		dc.b $4000>>10, 1	; 0 - grid
		dc.b $6000>>10, 0	; 2 - fish morph 1
		dc.b $6000>>10, 1	; 4 - fish morph 2
		dc.b $8000>>10, 0	; 6 - fish
		dc.b $8000>>10, 1	; 8 - bird morph 1
		dc.b $A000>>10, 0	; $A - bird morph 2
		dc.b $A000>>10, 1	; $C - bird
		even

Pal_SSCyc1:	incbin	"Palettes\Cycle - Special Stage 1.bin"
		even
Pal_SSCyc2:	incbin	"Palettes\Cycle - Special Stage 2.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	make the special stage background animated
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_BGAnimate:
		move.w	(v_ss_bg_mode).w,d0 ; get frame for fish/bird animation
		bne.s	@not_0		; branch if not 0
		move.w	#0,(v_bg1_y_pos).w
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w ; reset vertical scroll for bubble/cloud layer

	@not_0:
		cmpi.w	#8,d0
		bhs.s	loc_4C4E	; branch if d0 is 8-$C
		cmpi.w	#6,d0
		bne.s	@not_6		; branch if d0 isn't 6
		addq.w	#1,(v_bg3_x_pos).w
		addq.w	#1,(v_bg1_y_pos).w
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w ; scroll bubble layer

	@not_6:
		moveq	#0,d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_4CCC).l,a1
		lea	(v_nem_gfx_buffer).w,a3
		moveq	#9,d3

loc_4C26:
		move.w	2(a3),d0
		bsr.w	CalcSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_4C26
		lea	(v_nem_gfx_buffer).w,a3
		lea	(byte_4CB8).l,a2
		bra.s	loc_4C7E
; ===========================================================================

loc_4C4E:
		cmpi.w	#$C,d0
		bne.s	@not_C		; branch if d0 isn't $C
		subq.w	#1,(v_bg3_x_pos).w
		lea	($FFFFAB00).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

	@loop:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,@loop

	@not_C:
		lea	($FFFFAB00).w,a3
		lea	(SS_Bubble_ScrollBlocks).l,a2

loc_4C7E:
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

loc_4C9A:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_4CA4:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_4CA4
		dbf	d3,loc_4C9A
		rts	
; End of function SS_BGAnimate

; ===========================================================================
byte_4CB8:	dc.b 9,	$28, $18, $10, $28, $18, $10, $30, $18,	8, $10,	0
		even
SS_Bubble_ScrollBlocks:
		dc.b @end-@start-1
	@start:	dc.b $30, $30, $30, $28, $18, $18, $18
	@end:
		even
byte_4CCC:	dc.b 8,	2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8,	$FD, 4,	2, 2, 3, 2, $FF
		even

; ===========================================================================

; ---------------------------------------------------------------------------
; Continue screen
; ---------------------------------------------------------------------------

GM_Continue:
		bsr.w	PaletteFadeOut
		disable_ints
		move.w	(v_vdp_mode_buffer).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8 colour mode
		move.w	#$8700,(a6)	; background colour
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	Cont_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,Cont_ClrObjRam ; clear object RAM

		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		locVRAM	$A000
		lea	(Nem_ContSonic).l,a0 ; load Sonic patterns
		bsr.w	NemDec
		locVRAM	$AA20
		lea	(Nem_MiniSonic).l,a0 ; load continue screen patterns
		bsr.w	NemDec
		moveq	#10,d1
		jsr	(ContScrCounter).l	; run countdown	(start from 10)
		moveq	#id_Pal_Continue,d0
		bsr.w	PalLoad1	; load continue	screen palette
		play.b	0, bsr.w, mus_Continue	; play continue	music
		move.w	#659,(v_countdown).w ; set time delay to 11 seconds
		clr.l	(v_camera_x_pos).w
		move.l	#$1000000,(v_camera_y_pos).w
		move.b	#id_ContSonic,(v_ost_player).w ; load Sonic object
		move.b	#id_ContScrItem,(v_ost_cont_text).w ; load continue screen objects
		move.b	#id_ContScrItem,(v_ost_cont_oval).w
		move.b	#3,(v_ost_cont_oval+ost_priority).w
		move.b	#4,(v_ost_cont_oval+ost_frame).w
		move.b	#id_ContScrItem,(v_ost_cont_minisonic).w
		move.b	#id_CSI_MakeMiniSonic,(v_ost_cont_minisonic+ost_routine).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	(v_vdp_mode_buffer).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#$16,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		cmpi.b	#6,(v_ost_player+ost_routine).w
		bhs.s	loc_4DF2
		disable_ints
		move.w	(v_countdown).w,d1
		divu.w	#$3C,d1
		andi.l	#$F,d1
		jsr	(ContScrCounter).l
		enable_ints

loc_4DF2:
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		cmpi.w	#$180,(v_ost_player+ost_x_pos).w ; has Sonic run off screen?
		bhs.s	Cont_GotoLevel	; if yes, branch
		cmpi.b	#6,(v_ost_player+ost_routine).w
		bhs.s	Cont_MainLoop
		tst.w	(v_countdown).w
		bne.w	Cont_MainLoop
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Cont_GotoLevel:
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		move.b	d0,(v_last_lamppost).w ; clear lamppost count
		subq.b	#1,(v_continues).w ; subtract 1 from continues
		rts	
; ===========================================================================

		include "Objects\Continue Screen Items.asm" ; ContScrItem
		include "Objects\Continue Screen Sonic.asm" ; ContSonic
		include "Animations\Continue Screen Sonic.asm" ; Ani_CSon
		include "Mappings\Continue Screen.asm" ; Map_ContScr

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence in Green Hill	Zone
; ---------------------------------------------------------------------------

GM_Ending:
		play.b	1, bsr.w, cmd_Stop		; stop music
		bsr.w	PaletteFadeOut

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	End_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,End_ClrObjRam ; clear object	RAM

		lea	(v_vblank_0e_counter).w,a1
		moveq	#0,d0
		move.w	#$15,d1
	End_ClrRam1:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam1	; clear	variables

		lea	(v_camera_x_pos).w,a1
		moveq	#0,d0
		move.w	#$3F,d1
	End_ClrRam2:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam2	; clear	variables

		lea	(v_oscillating_table).w,a1
		moveq	#0,d0
		move.w	#$47,d1
	End_ClrRam3:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam3	; clear	variables

		disable_ints
		move.w	(v_vdp_mode_buffer).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_vdp_hint_counter).w ; set palette change position (for water)
		move.w	(v_vdp_hint_counter).w,(a6)
		move.w	#30,(v_air).w
		move.w	#id_EndZ<<8,(v_zone).w ; set level number to 0600 (extra flowers)
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	End_LoadData	; if yes, branch
		move.w	#(id_EndZ<<8)+1,(v_zone).w ; set level number to 0601 (no flowers)

End_LoadData:
		moveq	#id_PLC_Ending,d0
		bsr.w	QuickPLC	; load ending sequence patterns
		jsr	(Hud_Base).l
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#redraw_left_bit,(v_fg_redraw_direction).w
		bsr.w	LevelDataLoad
		bsr.w	LoadTilesFromStart
		move.l	#Col_GHZ,(v_collision_index_ptr).w ; load collision index
		enable_ints
		lea	(Kos_EndFlowers).l,a0 ;	load extra flower patterns
		lea	($FFFF9400).w,a1 ; RAM address to buffer the patterns
		bsr.w	KosDec
		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad1	; load Sonic's palette
		play.w	0, bsr.w, mus_Ending	; play ending sequence music
		btst	#bitA,(v_joypad_hold_actual).w ; is button A pressed?
		beq.s	End_LoadSonic	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

End_LoadSonic:
		move.b	#id_SonicPlayer,(v_ost_player).w ; load Sonic object
		bset	#0,(v_ost_player+ost_status).w ; make Sonic face left
		move.b	#1,(f_lock_controls).w ; lock controls
		move.w	#(btnL<<8),(v_joypad_hold).w ; move Sonic to the left
		move.w	#$F800,(v_ost_player+ost_inertia).w ; set Sonic's speed
		move.b	#id_HUD,(v_ost_hud).w ; load HUD object
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
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
		move.w	#1800,(v_countdown).w
		move.b	#$18,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		move.w	(v_vdp_mode_buffer).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		move.w	#$3F,(v_palfade_start).w
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Main ending sequence loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame
		move.b	#$18,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	PaletteCycle
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		cmpi.b	#id_Ending,(v_gamemode).w ; is game mode $18 (ending)?
		beq.s	End_ChkEmerald	; if yes, branch

		move.b	#id_Credits,(v_gamemode).w ; goto credits
		play.b	1, bsr.w, mus_Credits		; play credits music
		move.w	#0,(v_creditsnum).w ; set credits index number to 0
		rts	
; ===========================================================================

End_ChkEmerald:
		tst.w	(f_restart).w	; has Sonic released the emeralds?
		beq.w	End_MainLoop	; if not, branch

		clr.w	(f_restart).w
		move.w	#$3F,(v_palfade_start).w
		clr.w	(v_palfade_time).w

	End_AllEmlds:
		bsr.w	PauseGame
		move.b	#$18,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		addq.w	#1,(v_frame_counter).w
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		subq.w	#1,(v_palfade_time).w
		bpl.s	End_SlowFade
		move.w	#2,(v_palfade_time).w
		bsr.w	WhiteOut_ToWhite

	End_SlowFade:
		tst.w	(f_restart).w
		beq.w	End_AllEmlds
		clr.w	(f_restart).w
		move.w	#$2E2F,(v_level_layout+$80).w ; modify level layout
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_camera_x_pos).w,a3
		lea	(v_level_layout).w,a4
		move.w	#$4000,d2
		bsr.w	DrawChunks
		moveq	#id_Pal_Ending,d0
		bsr.w	PalLoad1	; load ending palette
		bsr.w	PaletteWhiteIn
		bra.w	End_MainLoop

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


End_MoveSonic:
		move.b	(v_end_sonic_routine).w,d0
		bne.s	End_MoveSon2
		cmpi.w	#$90,(v_ost_player+ost_x_pos).w ; has Sonic passed $90 on x-axis?
		bhs.s	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_end_sonic_routine).w
		move.b	#1,(f_lock_controls).w ; lock player's controls
		move.w	#(btnR<<8),(v_joypad_hold).w ; move Sonic to the right
		rts	
; ===========================================================================

End_MoveSon2:
		subq.b	#2,d0
		bne.s	End_MoveSon3
		cmpi.w	#$A0,(v_ost_player+ost_x_pos).w ; has Sonic passed $A0 on x-axis?
		blo.s	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_end_sonic_routine).w
		moveq	#0,d0
		move.b	d0,(f_lock_controls).w
		move.w	d0,(v_joypad_hold).w ; stop Sonic moving
		move.w	d0,(v_ost_player+ost_inertia).w
		move.b	#$81,(v_lock_multi).w ; lock controls & position
		move.b	#id_frame_Wait2,(v_ost_player+ost_frame).w
		move.w	#(id_Wait<<8)+id_Wait,(v_ost_player+ost_anim).w ; use "standing" animation
		move.b	#3,(v_ost_player+ost_anim_time).w
		rts	
; ===========================================================================

End_MoveSon3:
		subq.b	#2,d0
		bne.s	End_MoveSonExit
		addq.b	#2,(v_end_sonic_routine).w
		move.w	#$A0,(v_ost_player+ost_x_pos).w
		move.b	#id_EndSonic,(v_ost_player).w ; load Sonic ending sequence object
		clr.w	(v_ost_player+ost_routine).w

End_MoveSonExit:
		rts	
; End of function End_MoveSonic

; ===========================================================================
		include "Objects\Ending Sonic.asm" ; EndSonic
		include "Animations\Ending Sonic.asm" ; Ani_ESon

		include "Objects\Ending Chaos Emeralds.asm" ; EndChaos
		include "Objects\Ending StH Text.asm" ; EndSTH
		
		include "Mappings\Ending Sonic.asm" ; Map_ESon
		include "Mappings\Ending Chaos Emeralds.asm" ; Map_ECha
		include "Mappings\Ending StH Text.asm" ; Map_ESth

; ===========================================================================
; ---------------------------------------------------------------------------
; Credits ending sequence
; ---------------------------------------------------------------------------

GM_Credits:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$9200,(a6)		; window vertical position
		move.w	#$8B03,(a6)		; line scroll mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	Cred_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,Cred_ClrObjRam ; clear object RAM

		locVRAM	$B400
		lea	(Nem_CreditText).l,a0 ;	load credits alphabet patterns
		bsr.w	NemDec

		lea	(v_pal_dry_dup).w,a1
		moveq	#0,d0
		move.w	#$1F,d1
	Cred_ClrPal:
		move.l	d0,(a1)+
		dbf	d1,Cred_ClrPal ; fill palette with black

		moveq	#id_Pal_Sonic,d0
		bsr.w	PalLoad1	; load Sonic's palette
		move.b	#id_CreditsText,(v_ost_credits).w ; load credits object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	EndingDemoLoad
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	Cred_SkipObjGfx
		bsr.w	AddPLC		; load object graphics

	Cred_SkipObjGfx:
		moveq	#id_PLC_Main2,d0
		bsr.w	AddPLC		; load standard	level graphics
		move.w	#120,(v_countdown).w ; display a credit for 2 seconds
		bsr.w	PaletteFadeIn

Cred_WaitLoop:
		move.b	#4,(v_vblank_routine).w
		bsr.w	WaitForVBlank
		bsr.w	RunPLC
		tst.w	(v_countdown).w ; have 2 seconds elapsed?
		bne.s	Cred_WaitLoop	; if not, branch
		tst.l	(v_plc_buffer).w ; have level gfx finished decompressing?
		bne.s	Cred_WaitLoop	; if not, branch
		cmpi.w	#9,(v_creditsnum).w ; have the credits finished?
		beq.w	TryAgainEnd	; if yes, branch
		rts	

; ---------------------------------------------------------------------------
; Ending sequence demo loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


EndingDemoLoad:
		move.w	(v_creditsnum).w,d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	EndDemo_Levels(pc,d0.w),d0 ; load level	array
		move.w	d0,(v_zone).w	; set level from level array
		addq.w	#1,(v_creditsnum).w
		cmpi.w	#9,(v_creditsnum).w ; have credits finished?
		bhs.s	EndDemo_Exit	; if yes, branch
		move.w	#$8001,(f_demo).w ; set demo+ending mode
		move.b	#id_Demo,(v_gamemode).w ; set game mode to 8 (demo)
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		move.b	d0,(v_last_lamppost).w ; clear lamppost counter
		cmpi.w	#4,(v_creditsnum).w ; is SLZ demo running?
		bne.s	EndDemo_Exit	; if not, branch
		lea	(EndDemo_LampVar).l,a1 ; load lamppost variables
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
; Levels used in the end sequence demos
; ---------------------------------------------------------------------------
EndDemo_Levels:	incbin	"Misc Data\Demo Level Order - Ending.bin"

; ---------------------------------------------------------------------------
; Lamppost variables in the end sequence demo (Star Light Zone)
; ---------------------------------------------------------------------------
EndDemo_LampVar:
		dc.b 1,	1		; number of the last lamppost
		dc.w $A00, $62C		; x/y-axis position
		dc.w 13			; rings
		dc.l 0			; time
		dc.b 0,	0		; dynamic level event routine counter
		dc.w $800		; level bottom boundary
		dc.w $957, $5CC		; x/y axis screen position
		dc.w $4AB, $3A6, 0, $28C, 0, 0 ; scroll info
		dc.w $308		; water height
		dc.b 1,	1		; water routine and state
; ===========================================================================
; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screens
; ---------------------------------------------------------------------------

TryAgainEnd:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8720,(a6)	; set background colour (line 3; colour 0)
		clr.b	(f_water_pal_full).w
		bsr.w	ClearScreen

		lea	(v_ost_all).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	TryAg_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrObjRam ; clear object RAM

		moveq	#id_PLC_TryAgain,d0
		bsr.w	QuickPLC	; load "TRY AGAIN" or "END" patterns

		lea	(v_pal_dry_dup).w,a1
		moveq	#0,d0
		move.w	#$1F,d1
	TryAg_ClrPal:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrPal ; fill palette with black

		moveq	#id_Pal_Ending,d0
		bsr.w	PalLoad1	; load ending palette
		clr.w	(v_pal_dry_dup+$40).w
		move.b	#id_EndEggman,(v_ost_endeggman).w ; load Eggman object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	#1800,(v_countdown).w ; show screen for 30 seconds
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
		andi.b	#btnStart,(v_joypad_press_actual).w ; is Start button pressed?
		bne.s	TryAg_Exit	; if yes, branch
		tst.w	(v_countdown).w ; has 30 seconds elapsed?
		beq.s	TryAg_Exit	; if yes, branch
		cmpi.b	#id_Credits,(v_gamemode).w
		beq.s	TryAg_MainLoop

TryAg_Exit:
		move.b	#id_Sega,(v_gamemode).w ; goto Sega screen
		rts	

; ===========================================================================

		include "Objects\Ending Eggman Try Again.asm" ; EndEggman
		include "Animations\Ending Eggman Try Again.asm" ; Ani_EEgg

		include "Objects\Ending Chaos Emeralds Try Again.asm" ; TryChaos

		include "Mappings\Ending Eggman Try Again.asm" ; Map_EEgg

; ---------------------------------------------------------------------------
; Ending sequence demos
; ---------------------------------------------------------------------------
Demo_EndGHZ1:	incbin	"demodata\Ending - GHZ1.bin"
		even
Demo_EndMZ:	incbin	"demodata\Ending - MZ.bin"
		even
Demo_EndSYZ:	incbin	"demodata\Ending - SYZ.bin"
		even
Demo_EndLZ:	incbin	"demodata\Ending - LZ.bin"
		even
Demo_EndSLZ:	incbin	"demodata\Ending - SLZ.bin"
		even
Demo_EndSBZ1:	incbin	"demodata\Ending - SBZ1.bin"
		even
Demo_EndSBZ2:	incbin	"demodata\Ending - SBZ2.bin"
		even
Demo_EndGHZ2:	incbin	"demodata\Ending - GHZ2.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	load level boundaries and start	locations
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelSizeLoad:
		moveq	#0,d0
		move.b	d0,(v_levelsizeload_unused_1).w
		move.b	d0,(v_levelsizeload_unused_2).w
		move.b	d0,(v_levelsizeload_unused_3).w
		move.b	d0,(v_levelsizeload_unused_4).w
		move.b	d0,(v_dle_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelSizeArray(pc,d0.w),a0 ; load level	boundaries
		move.w	(a0)+,d0
		move.w	d0,(v_boundary_unused).w
		move.l	(a0)+,d0
		move.l	d0,(v_boundary_left).w
		move.l	d0,(v_boundary_left_next).w
		move.l	(a0)+,d0
		move.l	d0,(v_boundary_top).w
		move.l	d0,(v_boundary_top_next).w
		move.w	(v_boundary_left).w,d0
		addi.w	#$240,d0
		move.w	d0,(v_boundary_left_unused).w
		move.w	#$1010,(v_fg_x_redraw_flag).w
		move.w	(a0)+,d0
		move.w	d0,(v_camera_y_shift).w
		bra.w	LevSz_ChkLamp
; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------
LevelSizeArray:
		; GHZ
		dc.w $0004, $0000, $24BF, $0000, $0300, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0300, $0060
		dc.w $0004, $0000, $2960, $0000, $0300, $0060
		dc.w $0004, $0000, $2ABF, $0000, $0300, $0060
		; LZ
		dc.w $0004, $0000, $19BF, $0000, $0530, $0060
		dc.w $0004, $0000, $10AF, $0000, $0720, $0060
		dc.w $0004, $0000, $202F, $FF00, $0800, $0060
		dc.w $0004, $0000, $20BF, $0000, $0720, $0060
		; MZ
		dc.w $0004, $0000, $17BF, $0000, $01D0, $0060
		dc.w $0004, $0000, $17BF, $0000, $0520, $0060
		dc.w $0004, $0000, $1800, $0000, $0720, $0060
		dc.w $0004, $0000, $16BF, $0000, $0720, $0060
		; SLZ
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $2000, $0000, $06C0, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		; SYZ
		dc.w $0004, $0000, $22C0, $0000, $0420, $0060
		dc.w $0004, $0000, $28C0, $0000, $0520, $0060
		dc.w $0004, $0000, $2C00, $0000, $0620, $0060
		dc.w $0004, $0000, $2EC0, $0000, $0620, $0060
		; SBZ
		dc.w $0004, $0000, $21C0, $0000, $0720, $0060
		dc.w $0004, $0000, $1E40, $FF00, $0800, $0060
		dc.w $0004, $2080, $2460, $0510, $0510, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		zonewarning LevelSizeArray,$30
		; Ending
		dc.w $0004, $0000, $0500, $0110, $0110, $0060
		dc.w $0004, $0000, $0DC0, $0110, $0110, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060

; ---------------------------------------------------------------------------
; Ending start location array
; ---------------------------------------------------------------------------
EndingStLocArray:

		incbin	"startpos\ghz1 (Credits demo 1).bin"
		incbin	"startpos\mz2 (Credits demo).bin"
		incbin	"startpos\syz3 (Credits demo).bin"
		incbin	"startpos\lz3 (Credits demo).bin"
		incbin	"startpos\slz3 (Credits demo).bin"
		incbin	"startpos\sbz1 (Credits demo).bin"
		incbin	"startpos\sbz2 (Credits demo).bin"
		incbin	"startpos\ghz1 (Credits demo 2).bin"
		even

; ===========================================================================

LevSz_ChkLamp:
		tst.b	(v_last_lamppost).w	; have any lampposts been hit?
		beq.s	LevSz_StartLoc	; if not, branch

		jsr	(Lamp_LoadInfo).l
		move.w	(v_ost_player+ost_x_pos).w,d1
		move.w	(v_ost_player+ost_y_pos).w,d0
		bra.s	LevSz_SkipStartPos
; ===========================================================================

LevSz_StartLoc:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartLocArray(pc,d0.w),a1 ; load Sonic's start location
		tst.w	(f_demo).w	; is ending demo mode on?
		bpl.s	LevSz_SonicPos	; if not, branch

		move.w	(v_creditsnum).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	EndingStLocArray(pc,d0.w),a1 ; load Sonic's start location

LevSz_SonicPos:
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(v_ost_player+ost_x_pos).w ; set Sonic's position on x-axis
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(v_ost_player+ost_y_pos).w ; set Sonic's position on y-axis

SetScreen:
	LevSz_SkipStartPos:
		subi.w	#160,d1		; is Sonic more than 160px from left edge?
		bcc.s	SetScr_WithinLeft ; if yes, branch
		moveq	#0,d1

	SetScr_WithinLeft:
		move.w	(v_boundary_right).w,d2
		cmp.w	d2,d1		; is Sonic inside the right edge?
		bcs.s	SetScr_WithinRight ; if yes, branch
		move.w	d2,d1

	SetScr_WithinRight:
		move.w	d1,(v_camera_x_pos).w ; set horizontal screen position

		subi.w	#96,d0		; is Sonic within 96px of upper edge?
		bcc.s	SetScr_WithinTop ; if yes, branch
		moveq	#0,d0

	SetScr_WithinTop:
		cmp.w	(v_boundary_bottom).w,d0 ; is Sonic above the bottom edge?
		blt.s	SetScr_WithinBottom ; if yes, branch
		move.w	(v_boundary_bottom).w,d0

	SetScr_WithinBottom:
		move.w	d0,(v_camera_y_pos).w ; set vertical screen position
		bsr.w	BgScrollSpeed
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.b	#2,d0
		move.l	LoopTileNums(pc,d0.w),(v_256x256_with_loop_1).w
		if revision=0
		bra.w	LevSz_LoadScrollBlockSize
		else
		rts
		endc
; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------
StartLocArray:

		incbin	"startpos\ghz1.bin"
		incbin	"startpos\ghz2.bin"
		incbin	"startpos\ghz3.bin"
		dc.w	$80,$A8

		incbin	"startpos\lz1.bin"
		incbin	"startpos\lz2.bin"
		incbin	"startpos\lz3.bin"
		incbin	"startpos\sbz3.bin"

		incbin	"startpos\mz1.bin"
		incbin	"startpos\mz2.bin"
		incbin	"startpos\mz3.bin"
		dc.w	$80,$A8

		incbin	"startpos\slz1.bin"
		incbin	"startpos\slz2.bin"
		incbin	"startpos\slz3.bin"
		dc.w	$80,$A8

		incbin	"startpos\syz1.bin"
		incbin	"startpos\syz2.bin"
		incbin	"startpos\syz3.bin"
		dc.w	$80,$A8

		incbin	"startpos\sbz1.bin"
		incbin	"startpos\sbz2.bin"
		incbin	"startpos\fz.bin"
		dc.w	$80,$A8

		zonewarning StartLocArray,$10

		incbin	"startpos\end1.bin"
		incbin	"startpos\end2.bin"
		dc.w	$80,$A8
		dc.w	$80,$A8

		even

; ---------------------------------------------------------------------------
; Which	256x256	tiles contain loops or roll-tunnels
; ---------------------------------------------------------------------------

LoopTileNums:

; 		loop	loop	tunnel	tunnel

	dc.b	$B5,	$7F,	$1F,	$20	; Green Hill
	dc.b	$7F,	$7F,	$7F,	$7F	; Labyrinth
	dc.b	$7F,	$7F,	$7F,	$7F	; Marble
	dc.b	$AA,	$B4,	$7F,	$7F	; Star Light
	dc.b	$7F,	$7F,	$7F,	$7F	; Spring Yard
	dc.b	$7F,	$7F,	$7F,	$7F	; Scrap Brain
	zonewarning LoopTileNums,4
	dc.b	$7F,	$7F,	$7F,	$7F	; Ending (Green Hill)

		even

; ===========================================================================

		if revision=0

; LevSz_Unk:
LevSz_LoadScrollBlockSize:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#3,d0
		lea	BGScrollBlockSizes(pc,d0.w),a1
		lea	(v_scroll_block_1_height).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		rts	
; End of function LevelSizeLoad

; ===========================================================================
; dword_61B4:
BGScrollBlockSizes:
		; GHZ
		dc.w $70
		dc.w $100	; I guess these used to be per act?
		dc.w $100	; Or maybe each scroll block got its own size?
		dc.w $100	; Either way, these are unused now.
		; LZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; MZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; SLZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; SYZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		; SBZ
		dc.w $800
		dc.w $100
		dc.w $100
		dc.w 0
		zonewarning BGScrollBlockSizes,8
		; Ending
		dc.w $70
		dc.w $100
		dc.w $100
		dc.w $100
		
		endc

; ---------------------------------------------------------------------------
; Subroutine to	set scroll speed of some backgrounds
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BgScrollSpeed:
		tst.b	(v_last_lamppost).w
		bne.s	loc_6206
		move.w	d0,(v_bg1_y_pos).w
		move.w	d0,(v_bg2_y_pos).w
		move.w	d1,(v_bg1_x_pos).w
		move.w	d1,(v_bg2_x_pos).w
		move.w	d1,(v_bg3_x_pos).w

loc_6206:
		moveq	#0,d2
		move.b	(v_zone).w,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; End of function BgScrollSpeed

; ===========================================================================
BgScroll_Index:	index *
		ptr BgScroll_GHZ
		ptr BgScroll_LZ
		ptr BgScroll_MZ
		ptr BgScroll_SLZ
		ptr BgScroll_SYZ
		ptr BgScroll_SBZ
		zonewarning BgScroll_Index,2
		ptr BgScroll_End
; ===========================================================================

BgScroll_GHZ:
		if revision=0
		bra.w	Deform_GHZ
		else
		clr.l	(v_bg1_x_pos).w
		clr.l	(v_bg1_y_pos).w
		clr.l	(v_bg2_y_pos).w
		clr.l	(v_bg3_y_pos).w
		lea	($FFFFA800).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
		endc
; ===========================================================================

BgScroll_LZ:
		asr.l	#1,d0
		move.w	d0,(v_bg1_y_pos).w
		rts	
; ===========================================================================

BgScroll_MZ:
		rts	
; ===========================================================================

BgScroll_SLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,(v_bg1_y_pos).w
		if revision=0
		else
		clr.l	(v_bg1_x_pos).w
		endc
		rts	
; ===========================================================================

BgScroll_SYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		if revision=0
		move.w	d0,(v_bg1_y_pos).w
		move.w	d0,(v_bg2_y_pos).w
		else
		addq.w	#1,d0
		move.w	d0,(v_bg1_y_pos).w
		clr.l	(v_bg1_x_pos).w
		endc
		rts	
; ===========================================================================

BgScroll_SBZ:
		if revision=0
		asl.l	#4,d0
		asl.l	#1,d0
		asr.l	#8,d0
		else
		andi.w	#$7F8,d0
		asr.w	#3,d0
		addq.w	#1,d0
		endc
		move.w	d0,(v_bg1_y_pos).w
		rts	
; ===========================================================================

BgScroll_End:
		if revision=0
		move.w	#$1E,(v_bg1_y_pos).w
		move.w	#$1E,(v_bg2_y_pos).w
		rts	
; ===========================================================================
		move.w	#$A8,(v_bg1_x_pos).w
		move.w	#$1E,(v_bg1_y_pos).w
		move.w	#-$40,(v_bg2_x_pos).w
		move.w	#$1E,(v_bg2_y_pos).w
		rts
		else
		move.w	(v_camera_x_pos).w,d0
		asr.w	#1,d0
		move.w	d0,(v_bg1_x_pos).w
		move.w	d0,(v_bg2_x_pos).w
		asr.w	#2,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,(v_bg3_x_pos).w
		clr.l	(v_bg1_y_pos).w
		clr.l	(v_bg2_y_pos).w
		clr.l	(v_bg3_y_pos).w
		lea	($FFFFA800).w,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
		endc

		if revision=0
		include	"Includes\DeformLayers.asm"
		else
		include	"Includes\DeformLayers (JP1).asm"
		endc
		include	"Includes\ScrollHorizontal & ScrollVertical.asm"


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Scrolls background and sets redraw flags.
; d4 - background x offset * $10000
; d5 - background y offset * $10000

BGScroll_XY:
		move.l	(v_bg1_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg1_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	BGScroll_YRelative	; no change in Y
		eori.b	#$10,(v_bg1_x_redraw_flag).w
		sub.l	d2,d0	; new - old
		bpl.s	@scrollRight
		bset	#redraw_left_bit,(v_bg1_redraw_direction).w
		bra.s	BGScroll_YRelative
	@scrollRight:
		bset	#redraw_right_bit,(v_bg1_redraw_direction).w
BGScroll_YRelative:
		move.l	(v_bg1_y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bg1_y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	@return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.l	d3,d0
		bpl.s	@scrollBottom
		bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		rts
	@scrollBottom:
		bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
	@return:
		rts
; End of function BGScroll_XY

Bg_Scroll_Y:
		if revision=0
		move.l	(v_bg1_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg1_x_pos).w
		endc
		move.l	(v_bg1_y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bg1_y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	@return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.l	d3,d0
		bpl.s	@scrollBottom
		if revision=0
		bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		else
		bset	#redraw_topall_bit,(v_bg1_redraw_direction).w
		endc
		rts
	@scrollBottom:
		if revision=0
		bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
		else
		bset	#redraw_bottomall_bit,(v_bg1_redraw_direction).w
		endc
	@return:
		rts


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_YAbsolute:
		move.w	(v_bg1_y_pos).w,d3
		move.w	d0,(v_bg1_y_pos).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	@return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.w	d3,d0
		bpl.s	@scrollBottom
		bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		rts
	@scrollBottom:
		bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
	@return:
		rts
; End of function BGScroll_YAbsolute


		if revision=0
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock4:
		move.w	(v_bg2_x_pos).w,d2
		move.w	(v_bg2_y_pos).w,d3
		move.w	(v_camera_x_diff).w,d0
		ext.l	d0
		asl.l	#7,d0
		add.l	d0,(v_bg2_x_pos).w
		move.w	(v_bg2_x_pos).w,d0
		andi.w	#$10,d0
		move.b	($FFFFF74E).w,d1
		eor.b	d1,d0
		bne.s	locret_6884
		eori.b	#$10,($FFFFF74E).w
		move.w	(v_bg2_x_pos).w,d0
		sub.w	d2,d0
		bpl.s	loc_687E
		bset	#redraw_left_bit,(v_bg2_redraw_direction).w
		bra.s	locret_6884
; ===========================================================================

loc_687E:
		bset	#redraw_right_bit,(v_bg2_redraw_direction).w

locret_6884:
		rts	
; End of function ScrollBlock4
		else


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; d6 - bit to set for redraw

BGScroll_Block1:
		move.l	(v_bg1_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg1_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	@return
		eori.b	#$10,(v_bg1_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	@scrollRight
		bset	d6,(v_bg1_redraw_direction).w
		bra.s	@return
	@scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg1_redraw_direction).w
	@return:
		rts
; End of function BGScroll_Block1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_Block2:
		move.l	(v_bg2_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg2_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg2_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	@return
		eori.b	#$10,(v_bg2_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	@scrollRight
		bset	d6,(v_bg2_redraw_direction).w
		bra.s	@return
	@scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg2_redraw_direction).w
	@return:
		rts
;-------------------------------------------------------------------------------
BGScroll_Block3:
		move.l	(v_bg3_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg3_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg3_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	@return
		eori.b	#$10,(v_bg3_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	@scrollRight
		bset	d6,(v_bg3_redraw_direction).w
		bra.s	@return
	@scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg3_redraw_direction).w
	@return:
		rts
		endc


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6886:
LoadTilesAsYouMove_BGOnly:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_redraw_direction).w,a2
		lea	(v_bg1_x_pos).w,a3
		lea	(v_level_layout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_redraw_direction).w,a2
		lea	(v_bg2_x_pos).w,a3
		bra.w	DrawBGScrollBlock2
; End of function sub_6886

; ---------------------------------------------------------------------------
; Subroutine to	display	correct	tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesAsYouMove:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		; First, update the background
		lea	(v_bg1_redraw_direction_dup).w,a2	; Scroll block 1 scroll flags
		lea	(v_bg1_x_pos_dup).w,a3	; Scroll block 1 X coordinate
		lea	(v_level_layout+$40).w,a4
		move.w	#$6000,d2			; VRAM thing for selecting Plane B
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_redraw_direction_dup).w,a2	; Scroll block 2 scroll flags
		lea	(v_bg2_x_pos_dup).w,a3	; Scroll block 2 X coordinate
		bsr.w	DrawBGScrollBlock2
		if Revision>=1
		; REV01 added a third scroll block, though, technically,
		; the RAM for it was already there in REV00
		lea	(v_bg3_redraw_direction_dup).w,a2	; Scroll block 3 scroll flags
		lea	(v_bg3_x_pos_dup).w,a3	; Scroll block 3 X coordinate
		bsr.w	DrawBGScrollBlock3
		endc
		; Then, update the foreground
		lea	(v_fg_redraw_direction_dup).w,a2	; Foreground scroll flags
		lea	(v_camera_x_pos_dup).w,a3		; Foreground X coordinate
		lea	(v_level_layout).w,a4
		move.w	#$4000,d2			; VRAM thing for selecting Plane A
		; The FG's update function is inlined here
		tst.b	(a2)
		beq.s	locret_6952	; If there are no flags set, nothing needs updating
		bclr	#0,(a2)
		beq.s	loc_6908
		; Draw new tiles at the top
		moveq	#-16,d4	; Y coordinate. Note that 16 is the size of a block in pixels
		moveq	#-16,d5 ; X coordinate
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4 ; Y coordinate
		moveq	#-16,d5 ; X coordinate
		bsr.w	DrawBlocks_LR

loc_6908:
		bclr	#1,(a2)
		beq.s	loc_6922
		; Draw new tiles at the bottom
		move.w	#224,d4	; Start at bottom of the screen. Since this draws from top to bottom, we don't need 224+16
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6922:
		bclr	#2,(a2)
		beq.s	loc_6938
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB

loc_6938:
		bclr	#3,(a2)
		beq.s	locret_6952
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB

locret_6952:
		rts	
; End of function LoadTilesAsYouMove


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6954:
DrawBGScrollBlock1:
		tst.b	(a2)
		beq.w	locret_69F2
		bclr	#redraw_top_bit,(a2)
		beq.s	loc_6972
		; Draw new tiles at the top
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		if Revision=0
			moveq	#(512/16)-1,d6	 ; Draw entire row of plane
			bsr.w	DrawBlocks_LR_2
		else
			bsr.w	DrawBlocks_LR
		endc

loc_6972:
		bclr	#redraw_bottom_bit,(a2)
		beq.s	loc_698E
		; Draw new tiles at the top
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		if Revision=0
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_2
		else
			bsr.w	DrawBlocks_LR
		endc

loc_698E:
		bclr	#redraw_left_bit,(a2)

		if Revision=0
			beq.s	loc_69BE
			; Draw new tiles on the left
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			moveq	#-16,d5
			move.w	(v_scroll_block_1_height).w,d6
			move.w	4(a3),d1
			andi.w	#-16,d1		; Floor camera Y coordinate to the nearest block
			sub.w	d1,d6
			blt.s	loc_69BE	; If scroll block 1 is offscreen, skip loading its tiles
			lsr.w	#4,d6		; Get number of rows not above the screen
			cmpi.w	#((224+16+16)/16)-1,d6
			blo.s	loc_69BA
			moveq	#((224+16+16)/16)-1,d6	; Cap at height of screen

	loc_69BA:
			bsr.w	DrawBlocks_TB_2

	loc_69BE:
			bclr	#redraw_right_bit,(a2)
			beq.s	locret_69F2
			; Draw new tiles on the right
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			move.w	#320,d5
			move.w	(v_scroll_block_1_height).w,d6
			move.w	4(a3),d1
			andi.w	#-16,d1
			sub.w	d1,d6
			blt.s	locret_69F2
			lsr.w	#4,d6
			cmpi.w	#((224+16+16)/16)-1,d6
			blo.s	loc_69EE
			moveq	#((224+16+16)/16)-1,d6

	loc_69EE:
			bsr.w	DrawBlocks_TB_2

		else

			beq.s	locj_6D56
			; Draw new tiles on the left
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	DrawBlocks_TB
	locj_6D56:

			bclr	#redraw_right_bit,(a2)
			beq.s	locj_6D70
			; Draw new tiles on the right
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	DrawBlocks_TB
	locj_6D70:

			bclr	#redraw_topall_bit,(a2)
			beq.s	locj_6D88
			; Draw entire row at the top
			moveq	#-16,d4
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_2
			moveq	#-16,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6D88:

			bclr	#redraw_bottomall_bit,(a2)
			beq.s	locret_69F2
			; Draw entire row at the bottom
			move.w	#224,d4
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_2
			move.w	#224,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
		endc

locret_69F2:
		rts	
; End of function DrawBGScrollBlock1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Essentially, this draws everything that isn't scroll block 1
; sub_69F4:
DrawBGScrollBlock2:
		if Revision=0

		tst.b	(a2)
		beq.w	locret_6A80
		bclr	#redraw_left_bit,(a2)
		beq.s	loc_6A3E
		; Draw new tiles on the left
		cmpi.w	#16,(a3)
		blo.s	loc_6A3E
		move.w	(v_scroll_block_1_height).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4	; Get remaining coverage of screen that isn't scroll block 1
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		moveq	#-16,d5
		move.w	(v_scroll_block_1_height).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	loc_6A3E	; If scroll block 1 is completely offscreen, branch?
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6	; Get however many of the rows on screen are not scroll block 1
		bhs.s	loc_6A3E
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

loc_6A3E:
		bclr	#redraw_right_bit,(a2)
		beq.s	locret_6A80
		; Draw new tiles on the right
		move.w	(v_scroll_block_1_height).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		move.w	#320,d5
		move.w	(v_scroll_block_1_height).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	locret_6A80
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6
		bhs.s	locret_6A80
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

locret_6A80:
		rts	
; End of function DrawBGScrollBlock2

; ===========================================================================

; Abandoned unused scroll block code.
; This would have drawn a scroll block that started at 208 pixels down, and was 48 pixels long.
		tst.b	(a2)
		beq.s	locret_6AD6
		bclr	#redraw_left_bit,(a2)
		beq.s	loc_6AAC
		; Draw new tiles on the left
		move.w	#224-16,d4	; Note that full screen coverage is normally 224+16+16. This is exactly three blocks less.
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		moveq	#-16,d5
		moveq	#3-1,d6	; Draw only three rows
		bsr.w	DrawBlocks_TB_2

loc_6AAC:
		bclr	#redraw_right_bit,(a2)
		beq.s	locret_6AD6
		; Draw new tiles on the right
		move.w	#224-16,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2

locret_6AD6:
		rts	

		else

			tst.b	(a2)
			beq.w	locj_6DF2
			cmpi.b	#id_SBZ,(v_zone).w
			beq.w	Draw_SBz
			bclr	#redraw_top_bit,(a2)
			beq.s	locj_6DD2
			; Draw new tiles on the left
			move.w	#224/2,d4	; Draw the bottom half of the screen
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			moveq	#-16,d5
			moveq	#3-1,d6		; Draw three rows... could this be a repurposed version of the above unused code?
			bsr.w	DrawBlocks_TB_2
	locj_6DD2:
			bclr	#redraw_bottom_bit,(a2)
			beq.s	locj_6DF2
			; Draw new tiles on the right
			move.w	#224/2,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6DF2:
			rts
;===============================================================================
	locj_6DF4:
			dc.b $00,$00,$00,$00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04
			dc.b $04,$04,$04,$04,$04,$04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00						
;===============================================================================
	Draw_SBz:
			moveq	#-16,d4
			bclr	#redraw_top_bit,(a2)
			bne.s	locj_6E28
			bclr	#redraw_bottom_bit,(a2)
			beq.s	locj_6E72
			move.w	#224,d4
	locj_6E28:
			lea	(locj_6DF4+1).l,a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			lea	(locj_6FE4).l,a3
			movea.w	(a3,d0.w),a3
			beq.s	locj_6E5E
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_6E72
;===============================================================================
	locj_6E5E:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6E72:
			tst.b	(a2)
			bne.s	locj_6E78
			rts
;===============================================================================			
	locj_6E78:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	locj_6E8C
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
	locj_6E8C:
			lea	(locj_6DF4).l,a0
			move.w	(v_bg1_y_pos).w,d0
			andi.w	#$1F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC						
;===============================================================================


	; locj_6EA4:
	DrawBGScrollBlock3:
			tst.b	(a2)
			beq.w	locj_6EF0
			cmpi.b	#id_MZ,(v_zone).w
			beq.w	Draw_Mz
			bclr	#redraw_top_bit,(a2)
			beq.s	locj_6ED0
			; Draw new tiles on the left
			move.w	#$40,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			moveq	#-16,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6ED0:
			bclr	#redraw_bottom_bit,(a2)
			beq.s	locj_6EF0
			; Draw new tiles on the right
			move.w	#$40,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6EF0:
			rts
	locj_6EF2:
			dc.b $00,$00,$00,$00,$00,$00,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04
			dc.b $04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00
;===============================================================================
	Draw_Mz:
			moveq	#-16,d4
			bclr	#redraw_top_bit,(a2)
			bne.s	locj_6F66
			bclr	#redraw_bottom_bit,(a2)
			beq.s	locj_6FAE
			move.w	#224,d4
	locj_6F66:
			lea	(locj_6EF2+1).l,a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	locj_6FE4(pc,d0.w),a3
			beq.s	locj_6F9A
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_6FAE
;===============================================================================
	locj_6F9A:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6FAE:
			tst.b	(a2)
			bne.s	locj_6FB4
			rts
;===============================================================================			
	locj_6FB4:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	locj_6FC8
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
	locj_6FC8:
			lea	(locj_6EF2).l,a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC
;===============================================================================			
	locj_6FE4:
			dc.w v_bg1_x_pos_dup, v_bg1_x_pos_dup, v_bg2_x_pos_dup, v_bg3_x_pos_dup
	locj_6FEC:
			moveq	#((224+16+16)/16)-1,d6
			move.l	#$800000,d7
	locj_6FF4:			
			moveq	#0,d0
			move.b	(a0)+,d0
			btst	d0,(a2)
			beq.s	locj_701C
			move.w	locj_6FE4(pc,d0.w),a3
			movem.l	d4/d5/a0,-(sp)
			movem.l	d4/d5,-(sp)
			bsr.w	GetBlockData
			movem.l	(sp)+,d4/d5
			bsr.w	Calc_VRAM_Pos
			bsr.w	DrawBlock
			movem.l	(sp)+,d4/d5/a0
	locj_701C:
			addi.w	#16,d4
			dbf	d6,locj_6FF4
			clr.b	(a2)
			rts			

		endc

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down
; DrawTiles_LR:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6	; Draw the entire width of the screen + two extra columns
; DrawTiles_LR_2:
DrawBlocks_LR_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1		; Two tiles ahead
		andi.b	#$7F,d1		; Wrap around row
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5		; Move X coordinate one block ahead
		dbf	d6,@loop
		rts
; End of function DrawBlocks_LR

		if Revision>=1
; DrawTiles_LR_3:
DrawBlocks_LR_3:
		move.l	#$800000,d7
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData_2
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5
		dbf	d6,@loop
		rts	
; End of function DrawBlocks_LR_3
		endc


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right
; DrawTiles_TB:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6	; Draw the entire height of the screen + two extra rows
; DrawTiles_TB_2:
DrawBlocks_TB_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addi.w	#$100,d1	; Two rows ahead
		andi.w	#$FFF,d1	; Wrap around plane
		movem.l	(sp)+,d4-d5
		addi.w	#16,d4		; Move X coordinate one block ahead
		dbf	d6,@loop
		rts	
; End of function DrawBlocks_TB_2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Draws a block's worth of tiles
; Parameters:
; a0 = Pointer to block metadata (block index and X/Y flip)
; a1 = Pointer to block
; a5 = Pointer to VDP command port
; a6 = Pointer to VDP data port
; d0 = VRAM command to access plane
; d2 = VRAM plane A/B specifier
; d7 = Plane row delta
; DrawTiles:
DrawBlock:
		or.w	d2,d0	; OR in that plane A/B specifier to the VRAM command
		swap	d0
		btst	#4,(a0)	; Check Y-flip bit
		bne.s	DrawFlipY
		btst	#3,(a0)	; Check X-flip bit
		bne.s	DrawFlipX
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipX:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4	; Invert X-flip bits of each tile
		swap	d4		; Swap the tiles around
		move.l	d4,(a6)		; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)		; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipY:
		btst	#3,(a0)
		bne.s	DrawFlipXY
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts	
; ===========================================================================

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts	
; End of function DrawBlocks

; ===========================================================================
; unused garbage
		if Revision=0
; This is interesting. It draws a block, but not before
; incrementing its palette lines by 1. This may have been
; a debug function to discolour mirrored tiles, to test
; if they're loading properly.
		rts	
		move.l	d0,(a5)
		move.w	#$2000,d5
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		rts
		endc

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Gets address of block at a certain coordinate
; Parameters:
; a4 = Pointer to level layout
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns:
; a0 = Address of block metadata
; a1 = Address of block
; DrawBlocks:
GetBlockData:
		if Revision=0
		lea	(v_16x16_tiles).w,a1
		add.w	4(a3),d4	; Add camera Y coordinate to relative coordinate
		add.w	(a3),d5		; Add camera X coordinate to relative coordinate
		else
			add.w	(a3),d5
	GetBlockData_2:
			add.w	4(a3),d4
			lea	(v_16x16_tiles).w,a1
		endc
		; Turn Y coordinate into index into level layout
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		; Turn X coordinate into index into level layout
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		; Get chunk from level layout
		add.w	d3,d0
		moveq	#-1,d3
		move.b	(a4,d0.w),d3
		beq.s	locret_6C1E	; If chunk 00, just return a pointer to the first block (expected to be empty)
		; Turn chunk ID into index into chunk table
		subq.b	#1,d3
		andi.w	#$7F,d3
		ror.w	#7,d3
		; Turn Y coordinate into index into chunk
		add.w	d4,d4
		andi.w	#$1E0,d4
		; Turn X coordinate into index into chunk
		andi.w	#$1E,d5
		; Get block metadata from chunk
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		; Turn block ID into address
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_6C1E:
		rts	
; End of function GetBlockData


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Produces a VRAM plane access command from coordinates
; Parameters:
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns VDP command in d0
Calc_VRAM_Pos:
		if Revision=0
		add.w	4(a3),d4	; Add camera Y coordinate
		add.w	(a3),d5		; Add camera X coordinate
		else
			add.w	(a3),d5
	Calc_VRAM_Pos_2:
			add.w	4(a3),d4
		endc
		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0	; Highest bits of plane VRAM address
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; not used

; This is just like Calc_VRAM_Pos, but seemingly for an earlier
; VRAM layout: the only difference is the high bits of the
; plane's VRAM address, which are 10 instead of 11.
; Both the foreground and background are at $C000 and $E000
; respectively, so this one starting at $8000 makes no sense.
; sub_6C3C:
Calc_VRAM_Pos_Unknown:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos_Unknown

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_camera_x_pos).w,a3
		lea	(v_level_layout).w,a4
		move.w	#$4000,d2
		bsr.s	DrawChunks
		lea	(v_bg1_x_pos).w,a3
		lea	(v_level_layout+$40).w,a4
		move.w	#$6000,d2
		if Revision=0
		else
			tst.b	(v_zone).w
			beq.w	Draw_GHz_Bg
			cmpi.b	#id_MZ,(v_zone).w
			beq.w	Draw_Mz_Bg
			cmpi.w	#(id_SBZ<<8)+0,(v_zone).w
			beq.w	Draw_SBz_Bg
			cmpi.b	#id_EndZ,(v_zone).w
			beq.w	Draw_GHz_Bg
		endc
; End of function LoadTilesFromStart


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DrawChunks:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6

	@loop:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,@loop
		rts	
; End of function DrawChunks

		if Revision>=1
	Draw_GHz_Bg:
			moveq	#0,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_7224:			
			movem.l	d4-d6,-(sp)
			lea	(locj_724a),a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0
			andi.w	#$F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_7224
			rts
	locj_724a:
			dc.b $00,$00,$00,$00,$06,$06,$06,$04,$04,$04,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------------------------------
	Draw_Mz_Bg:;locj_725a:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_725E:			
			movem.l	d4-d6,-(sp)
			lea	(locj_6EF2+1),a0
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_725E
			rts
;-------------------------------------------------------------------------------
	Draw_SBz_Bg:;locj_7288:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_728C:			
			movem.l	d4-d6,-(sp)
			lea	(locj_6DF4+1),a0
			move.w	(v_bg1_y_pos).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_728C
			rts
;-------------------------------------------------------------------------------
	locj_72B2:
			dc.w v_bg1_x_pos, v_bg1_x_pos, v_bg2_x_pos, v_bg3_x_pos
	locj_72Ba:
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	locj_72B2(pc,d0.w),a3
			beq.s	locj_72da
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_72EE
	locj_72da:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_72EE:
			rts
		endc

; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16_tiles).w,a1	; RAM address for 16x16 mappings
		move.w	#0,d0
		bsr.w	EniDec
		movea.l	(a2)+,a0
		lea	(v_256x256_tiles).l,a1 ; RAM address for 256x256 mappings
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; is level SBZ3 (LZ4) ?
		bne.s	@notSBZ3	; if not, branch
		moveq	#id_Pal_SBZ3,d0	; use SB3 palette

	@notSBZ3:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2?
		beq.s	@isSBZorFZ	; if yes, branch
		cmpi.w	#(id_SBZ<<8)+2,(v_zone).w ; is level FZ?
		bne.s	@normalpal	; if not, branch

	@isSBZorFZ:
		moveq	#id_Pal_SBZ2,d0	; use SBZ2/FZ palette

	@normalpal:
		bsr.w	PalLoad1	; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	@skipPLC	; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bsr.w	AddPLC		; load pattern load cues

	@skipPLC:
		rts	
; End of function LevelDataLoad

; ---------------------------------------------------------------------------
; Level	layout loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad:
		lea	(v_level_layout).w,a3
		move.w	#$1FF,d1
		moveq	#0,d0

LevLoad_ClrRam:
		move.l	d0,(a3)+
		dbf	d1,LevLoad_ClrRam ; clear the RAM ($A400-A7FF)

		lea	(v_level_layout).w,a3 ; RAM address for level layout
		moveq	#0,d1
		bsr.w	LevelLayoutLoad2 ; load	level layout into RAM
		lea	(v_level_layout+$40).w,a3 ; RAM address for background layout
		moveq	#2,d1
; End of function LevelLayoutLoad

; "LevelLayoutLoad2" is	run twice - for	the level and the background

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad2:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in	tiles)

LevLoad_NumRows:
		move.w	d1,d0
		movea.l	a3,a0

LevLoad_Row:
		move.b	(a1)+,(a0)+
		dbf	d0,LevLoad_Row	; load 1 row
		lea	$80(a3),a3	; do next row
		dbf	d2,LevLoad_NumRows ; repeat for	number of rows
		rts	
; End of function LevelLayoutLoad2

		include "Includes\DynamicLevelEvents.asm"

		include "Objects\GHZ Bridge.asm" ; Bridge

		include "Objects\_DetectPlatform.asm"
		include "Objects\_SlopeObject.asm"

		include "Objects\GHZ, MZ & SLZ Swinging Platforms, SBZ Ball on Chain.asm" ; SwingingPlatform
		
		include_Bridge_2 ; Objects\GHZ Bridge.asm

		include "Objects\_ExitPlatform.asm"

		include_Bridge_3 ; Objects\GHZ Bridge.asm
		include "Mappings\GHZ Bridge.asm" ; Map_Bri

		include_SwingingPlatform_1 ; Objects\GHZ, MZ & SLZ Swinging Platforms, SBZ Ball on Chain.asm

		include "Objects\_MoveWithPlatform.asm"

		include_SwingingPlatform_2 ; Objects\GHZ, MZ & SLZ Swinging Platforms, SBZ Ball on Chain.asm

		include "Objects\GHZ Boss Ball.asm" ; BossBall
		include_BossBall_2

		include_SwingingPlatform_3 ; Objects\GHZ, MZ & SLZ Swinging Platforms, SBZ Ball on Chain.asm
		
		include "Mappings\GHZ & MZ Swinging Platforms.asm" ; Map_Swing_GHZ
		include "Mappings\SLZ Swinging Platforms.asm" ; Map_Swing_SLZ

		include "Objects\GHZ Spiked Helix Pole.asm" ; Helix
		include "Mappings\GHZ Spiked Helix Pole.asm" ; Map_Hel

		include "Objects\Platforms.asm" ; BasicPlatform
		include "Mappings\Unused Platforms.asm" ; Map_Plat_Unused
		include "Mappings\GHZ Platforms.asm" ; Map_Plat_GHZ
		include "Mappings\SYZ Platforms.asm" ; Map_Plat_SYZ
		include "Mappings\SLZ Platforms.asm" ; Map_Plat_SLZ

; ---------------------------------------------------------------------------
; Object 19 - blank
; ---------------------------------------------------------------------------

Obj19:
		rts	
		
		include "Mappings\GHZ Giant Ball.asm" ; Map_GBall

		include "Objects\GHZ Collapsing Ledge.asm" ; CollapseLedge
		include "Objects\MZ, SLZ & SBZ Collapsing Floors.asm" ; CollapseFloor
		include_CollapseLedge_2 ; Objects\GHZ Collapsing Ledge.asm

; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2

		include_SlopeObject_NoChk ; Objects\_SlopeObject.asm

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for GHZ collapsing ledge
; ---------------------------------------------------------------------------
Ledge_SlopeData:
		incbin	"Misc Data\GHZ Collapsing Ledge Heightmap.bin"
		even

		include "Mappings\GHZ Collapsing Ledge.asm" ; Map_Ledge
		include "Mappings\MZ, SLZ & SBZ Collapsing Floors.asm" ; Map_CFlo

		include "Objects\GHZ Bridge Stump & SLZ Fireball Launcher.asm" ; Scenery
		include "Mappings\SLZ Fireball Launcher.asm" ; Map_Scen

		include "Objects\Unused Switch.asm" ; MagicSwitch
		include "Mappings\Unused Switch.asm" ; Map_Switch

		include "Objects\SBZ Door.asm" ; AutoDoor
		include "Animations\SBZ Door.asm" ; Ani_ADoor
		include "Mappings\SBZ Door.asm" ; Map_ADoor

		include "Objects\GHZ Walls.asm" ; EdgeWalls
		include_EdgeWalls_2

		include "Objects\Ball Hog.asm" ; BallHog
		include "Objects\Ball Hog Cannonball.asm" ; Cannonball

		include "Objects\Buzz Bomber Missile Vanishing.asm" ; MissileDissolve

		include "Objects\Explosions.asm" ; ExplosionItem & ExplosionBomb
		include "Animations\Ball Hog.asm" ; Ani_Hog
		include "Mappings\Ball Hog.asm" ; Map_Hog
		include "Mappings\Buzz Bomber Missile Vanishing.asm" ; Map_MisDissolve
		include "Mappings\Explosions.asm" ; Map_ExplodeItem & Map_ExplodeBomb

		include "Objects\Animals.asm" ; Animals
		include "Objects\Points.asm" ; Points
		include "Mappings\Animals.asm" ; Map_Animal1, Map_Animal2 & Map_Animal3
		include "Mappings\Points.asm" ; Map_Points

		include "Objects\Crabmeat.asm" ; Crabmeat
		include "Animations\Crabmeat.asm" ; Ani_Crab
		include "Mappings\Crabmeat.asm" ; Map_Crab

		include "Objects\Buzz Bomber.asm" ; BuzzBomber
		include "Objects\Buzz Bomber Missile.asm" ; Missile
		include "Animations\Buzz Bomber.asm" ; Ani_Buzz
		include "Animations\Buzz Bomber Missile.asm" ; Ani_Missile
		include "Mappings\Buzz Bomber.asm" ; Map_Buzz
		include "Mappings\Buzz Bomber Missile.asm" ; Map_Missile

		include "Objects\Rings.asm" ; Rings
		include "Objects\_CollectRing.asm"
		include "Objects\Ring Loss.asm" ; RingLoss
		include "Objects\Giant Ring.asm" ; GiantRing
		include "Objects\Giant Ring Flash.asm" ; RingFlash
		include "Animations\Ring.asm" ; Ani_Ring
		include "Mappings\Ring.asm" ; Map_Ring
		include "Mappings\Giant Ring.asm" ; Map_GRing
		include "Mappings\Giant Ring Flash.asm" ; Map_Flash

		include "Objects\Monitors.asm" ; Monitor
		include "Objects\Monitor Contents.asm" ; PowerUp
		include_Monitor_2 ; Objects\Monitors.asm

		include "Animations\Monitors.asm" ; Ani_Monitor
		include "Mappings\Monitors.asm" ; Map_Monitor

		include "Objects\Title Screen Sonic.asm" ; TitleSonic
		include "Objects\Title Screen Press Start & TM.asm" ; PSBTM

		include "Animations\Title Screen Sonic.asm" ; Ani_TSon
		include "Animations\Title Screen Press Start.asm" ; Ani_PSB

		include "Objects\_AnimateSprite.asm"

		include "Mappings\Title Screen Press Start & TM.asm" ; Map_PSB
		include "Mappings\Title Screen Sonic.asm" ; Map_TSon

		include "Objects\Chopper.asm" ; Chopper
		include "Animations\Chopper.asm" ; Ani_Chop
		include "Mappings\Chopper.asm" ; Map_Chop

		include "Objects\Jaws.asm" ; Jaws
		include "Animations\Jaws.asm" ; Ani_Jaws
		include "Mappings\Jaws.asm" ; Map_Jaws

		include "Objects\Burrobot.asm" ; Burrobot
		include "Animations\Burrobot.asm" ; Ani_Burro
		include "Mappings\Burrobot.asm" ; Map_Burro

		include "Objects\MZ Grass Platforms.asm" ; LargeGrass
		include "Objects\MZ Burning Grass.asm" ; GrassFire
		include "Animations\MZ Burning Grass.asm" ; Ani_GFire
		include "Mappings\MZ Grass Platforms.asm" ; Map_LGrass
		include "Mappings\Fireballs.asm" ; Map_Fire

		include "Objects\MZ Green Glass Blocks.asm" ; GlassBlock
		include "Mappings\MZ Green Glass Blocks.asm" ; Map_Glass

		include "Objects\MZ Chain Stompers.asm" ; ChainStomp
		include "Objects\MZ Unused Sideways Stomper.asm" ; SideStomp
		include "Mappings\MZ Chain Stompers.asm" ; Map_CStom
		include "Mappings\MZ Unused Sideways Stomper.asm" ; Map_SStom

		include "Objects\Button.asm" ; Button
		include "Mappings\Button.asm" ; Map_But

		include "Objects\MZ & LZ Pushable Blocks.asm" ; PushBlock
		include "Mappings\MZ & LZ Pushable Blocks.asm" ; Map_Push

		include "Objects\Title Cards.asm" ; TitleCard
		include "Objects\Game Over & Time Over.asm" ; GameOverCard
		include "Objects\Sonic Got Through Title Card.asm" ; GotThroughCard

		include "Objects\Special Stage Results.asm" ; SSResult
		include "Objects\Special Stage Results Chaos Emeralds.asm" ; SSRChaos
		include "Mappings\Title Cards.asm" ; Map_Card
		include "Mappings\Game Over & Time Over.asm" ; Map_Over
		include "Mappings\Title Cards Sonic Has Passed.asm" ; Map_Got
		include "Mappings\Special Stage Results.asm" ; Map_SSR
		include "Mappings\Special Stage Results Chaos Emeralds.asm" ; Map_SSRC

		include "Objects\Spikes.asm" ; Spikes
		include "Mappings\Spikes.asm" ; Map_Spike

		include "Objects\GHZ Purple Rock.asm" ; PurpleRock
		include "Objects\GHZ Waterfall Sound.asm" ; WaterSound
		include "Mappings\GHZ Purple Rock.asm" ; Map_PRock

		include "Objects\GHZ & SLZ Smashable Walls & SmashObject.asm" ; SmashWall
		include "Mappings\GHZ & SLZ Smashable Walls.asm" ; Map_Smash

ExecuteObjects:	include "Includes\ExecuteObjects & Object Pointers.asm"

NullObject:
		;jmp	(DeleteObject).l ; It would be safer to have this instruction here, but instead it just falls through to ObjectFall

		include "Objects\_ObjectFall & SpeedToPos.asm"

		include "Objects\_DisplaySprite.asm"
		include "Objects\_DeleteObject & DeleteChild.asm"

		include "Includes\BuildSprites.asm"

		include "Objects\_CheckOffScreen.asm"

		include "Includes\ObjPosLoad.asm"
		include "Objects\_FindFreeObj & FindNextFreeObj.asm"

		include "Objects\Springs.asm" ; Springs
		include "Animations\Springs.asm" ; Ani_Spring
		include "Mappings\Springs.asm" ; Map_Spring

		include "Objects\Newtron.asm" ; Newtron
		include "Animations\Newtron.asm" ; Ani_Newt
		include "Mappings\Newtron.asm" ; Map_Newt

		include "Objects\Roller.asm" ; Roller
		include "Animations\Roller.asm" ; Ani_Roll
		include "Mappings\Roller.asm" ; Map_Roll

		include_EdgeWalls_1 ; Objects\GHZ Walls.asm
		include "Mappings\GHZ Walls.asm" ; Map_Edge

		include "Objects\MZ & SLZ Fireball Launchers.asm"
		include "Objects\Fireballs.asm" ; LavaBall
		include "Animations\Fireballs.asm" ; Ani_Fire

		include "Objects\SBZ Flamethrower.asm" ; Flamethrower
		include "Animations\SBZ Flamethrower.asm" ; Ani_Flame
		include "Mappings\SBZ Flamethrower.asm" ; Map_Flame

		include "Objects\MZ Purple Brick Block.asm" ; MarbleBrick
		include "Mappings\MZ Purple Brick Block.asm" ; Map_Brick

		include "Objects\SYZ Lamp.asm" ; SpinningLight
		include "Mappings\SYZ Lamp.asm" ; Map_Light

		include "Objects\SYZ Bumper.asm" ; Bumper
		include "Animations\SYZ Bumper.asm" ; Ani_Bump
		include "Mappings\SYZ Bumper.asm" ; Map_Bump

		include "Objects\Signpost & GotThroughAct.asm" ; Signpost & GotThroughAct
		include "Animations\Signpost.asm" ; Ani_Sign
		include "Mappings\Signpost.asm" ; Map_Sign

		include "Objects\MZ Lava Geyser Maker.asm" ; GeyserMaker
		include "Objects\MZ Lava Geyser.asm" ; LavaGeyser
		include "Objects\MZ Lava Wall.asm" ; LavaWall
		include "Objects\MZ Invisible Lava Tag.asm" ; LavaTag
		include "Mappings\MZ Invisible Lava Tag.asm" ; Map_LTag
		include "Animations\MZ Lava Geyser.asm" ; Ani_Geyser
		include "Animations\MZ Lava Wall.asm" ; Ani_LWall
		include "Mappings\MZ Lava Geyser.asm" ; Map_Geyser
		include "Mappings\MZ Lava Wall.asm" ; Map_LWall

		include "Objects\Moto Bug & RememberState.asm" ; MotoBug
		include "Animations\Moto Bug.asm" ; Ani_Moto
		include "Mappings\Moto Bug.asm" ; Map_Moto

; ---------------------------------------------------------------------------
; Object 4F - blank
; ---------------------------------------------------------------------------

Obj4F:
		rts	

		include "Objects\Yadrin.asm" ;Yadrin
		include "Animations\Yadrin.asm" ; Ani_Yad
		include "Mappings\Yadrin.asm" ; Map_Yad

		include "Objects\_SolidObject.asm"

		include "Objects\MZ Smashable Green Block.asm" ; SmashBlock
		include "Mappings\MZ Smashable Green Block.asm" ; Map_Smab

		include "Objects\MZ, LZ & SBZ Moving Blocks.asm" ; MovingBlock
		include "Mappings\MZ & SBZ Moving Blocks.asm" ; Map_MBlock
		include "Mappings\LZ Moving Block.asm" ; Map_MBlockLZ

		include "Objects\Batbrain.asm" ; Batbrain
		include "Animations\Batbrain.asm" ; Ani_Bat
		include "Mappings\Batbrain.asm" ; Map_Bat

		include "Objects\SYZ & SLZ Floating Blocks, LZ Doors.asm" ; FloatingBlock
		include "Mappings\SYZ & SLZ Floating Blocks, LZ Doors.asm" ; Map_FBlock

		include "Objects\SYZ & LZ Spike Ball Chain.asm" ; SpikeBall
		include "Mappings\SYZ Spike Ball Chain.asm" ; Map_SBall
		include "Mappings\LZ Spike Ball on Chain.asm" ; Map_SBall2

		include "Objects\SYZ Large Spike Balls.asm" ; BigSpikeBall
		include "Mappings\SYZ & SBZ Large Spike Balls.asm" ; Map_BBall

		include "Objects\SLZ Elevator.asm" ; Elevator
		include "Mappings\SLZ Elevator.asm" ; Map_Elev

		include "Objects\SLZ Circling Platform.asm" ; CirclingPlatform
		include "Mappings\SLZ Circling Platform.asm" ; Map_Circ

		include "Objects\SLZ Stairs.asm" ; Staircase
		include "Mappings\SLZ Stairs.asm" ; Map_Stair

		include "Objects\SLZ Pylon.asm" ; Pylon
		include "Mappings\SLZ Pylon.asm" ; Map_Pylon

		include "Objects\LZ Water Surface.asm" ; WaterSurface
		include "Mappings\LZ Water Surface.asm" ; Map_Surf

		include "Objects\LZ Pole.asm" ; Pole
		include "Mappings\LZ Pole.asm" ; Map_Pole

		include "Objects\LZ Flapping Door.asm" ; FlapDoor
		include "Animations\LZ Flapping Door.asm" ; Ani_Flap
		include "Mappings\LZ Flapping Door.asm" ; Map_Flap

		include "Objects\Invisible Solid Blocks.asm" ; Invisibarrier
		include "Mappings\Invisible Solid Blocks.asm" ; Map_Invis

		include "Objects\SLZ Fans.asm" ; Fan
		include "Mappings\SLZ Fans.asm" ; Map_Fan

		include "Objects\SLZ Seesaw.asm" ; Seesaw
		include "Mappings\SLZ Seesaw.asm" ; Map_Seesaw
		include "Mappings\SLZ Seesaw Spike Ball.asm" ; Map_SSawBall

		include "Objects\Bomb Enemy.asm" ; Bomb
		include "Animations\Bomb Enemy.asm" ; Ani_Bomb
		include "Mappings\Bomb Enemy.asm" ; Map_Bomb

		include "Objects\Orbinaut.asm" ; Orbinaut
		include "Animations\Orbinaut.asm" ; Ani_Orb
		include "Mappings\Orbinaut.asm" ; Map_Orb

		include "Objects\LZ Harpoon.asm" ; Harpoon
		include "Animations\LZ Harpoon.asm" ; Ani_Harp
		include "Mappings\LZ Harpoon.asm" ; Map_Harp

		include "Objects\LZ Blocks.asm" ; LabyrinthBlock
		include "Mappings\LZ Blocks.asm" ; Map_LBlock

		include "Objects\LZ Gargoyle Head.asm" ; Gargoyle
		include "Mappings\LZ Gargoyle Head.asm" ; Map_Gar

		include "Objects\LZ Conveyor Belt Platforms.asm" ; LabyrinthConvey
		include "Mappings\LZ Conveyor Belt Platforms.asm" ; Map_LConv

		include "Objects\LZ Bubbles.asm" ; Bubble
		include "Animations\LZ Bubbles.asm" ; Ani_Bub
		include "Mappings\LZ Bubbles.asm" ; Map_Bub

		include "Objects\LZ Waterfall.asm" ; Waterfall
		include "Animations\LZ Waterfall.asm" ; Ani_WFall
		include "Mappings\LZ Waterfall.asm" ; Map_WFall

		include "Objects\Sonic (1).asm" ; SonicPlayer

		include "Objects\LZ Drowning Numbers.asm" ; DrownCount
		include "Objects\_ResumeMusic.asm"

		include "Animations\LZ Drowning Numbers.asm" ; Ani_Drown
		include "Mappings\LZ Drowning Numbers.asm" ; Map_Drown

		include "Objects\Shield & Invincibility.asm" ; ShieldItem
		include "Objects\Unused Special Stage Warp.asm" ; VanishSonic
		include "Objects\LZ Water Splash.asm" ; Splash
		include "Animations\Shield & Invincibility.asm" ; Ani_Shield
		include "Mappings\Shield & Invincibility.asm" ; Map_Shield
		include "Animations\Unused Special Stage Warp.asm" ; Ani_Vanish
		include "Mappings\Unused Special Stage Warp.asm" ; Map_Vanish
		include "Animations\LZ Water Splash.asm" ; Ani_Splash
		include "Mappings\LZ Water Splash.asm" ; Map_Splash

		include "Objects\Sonic (2).asm"
		include "Objects\_FindNearestTile, FindFloor & FindWall.asm"

		include	"Includes\ConvertCollisionArray.asm"

		include "Objects\Sonic (3).asm"

; ---------------------------------------------------------------------------
; Subroutine to find the distance of an object to the floor

; Runs FindFloor without the need for inputs, taking inputs from local OST variables

; input:
;	d3 = x pos. of object (FindFloorObj2 only)

; output:
;	d1 = distance to the floor
;	d3 = floor angle
;	a1 = address within 256x256 mappings where object is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindFloorObj:
		move.w	ost_x_pos(a0),d3


FindFloorObj2:
		move.w	ost_y_pos(a0),d2
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3		; height of a 16x16 tile
		move.w	#0,d6
		moveq	#$D,d5		; bit to test for solidness
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14E4E
		move.b	#0,d3

	locret_14E4E:
		rts	

; End of function FindFloorObj2

; ---------------------------------------------------------------------------
; Subroutine to	find walls either side of Sonic

; output:
;	d0 = distance to left wall
;	d1 = distance to right wall
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14E50:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2		; d2 = x pos. of Sonic's left edge
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3		; d3 = y pos. of Sonic's bottom edge
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)	; save distance to left wall in stack
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2		; d2 = x pos. of Sonic's right edge
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3		; d3 = y pos. of Sonic's bottom edge
		lea	(v_angle_left).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0	; retrieve distance to left wall from stack
		move.b	#-$40,d2
		bra.w	loc_14DD0

; End of function sub_14E50


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14EB4:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

loc_14EBC:
		addi.w	#$A,d3
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	loc_14E0A

; End of function sub_14EB4

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallRight:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14F06
		move.b	#-$40,d3

locret_14F06:
		rts	

; End of function ObjHitWallRight

; ---------------------------------------------------------------------------
; Subroutine preventing	Sonic from running on walls and	ceilings when he
; touches them
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_DontRunOnWalls:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#-$80,d2
		bra.w	loc_14DD0
; End of function Sonic_DontRunOnWalls

; ===========================================================================
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

loc_14F7C:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#-$80,d2
		bra.w	loc_14E0A

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitCeiling:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14FD4
		move.b	#-$80,d3

locret_14FD4:
		rts	
; End of function ObjHitCeiling

; ===========================================================================

loc_14FD6:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_14DD0

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic when	he jumps at a wall
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HitWall:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

loc_1504A:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	loc_14E0A
; End of function Sonic_HitWall

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallLeft:
		add.w	ost_x_pos(a0),d3
		move.w	ost_y_pos(a0),d2
		; Engine bug: colliding with left walls is erratic with this function.
		; The cause is this: a missing instruction to flip collision on the found
		; 16x16 block; this one:
		;eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_15098
		move.b	#$40,d3

locret_15098:
		rts	
; End of function ObjHitWallLeft

; ===========================================================================

		include "Objects\SBZ Rotating Disc Junction.asm" ; Junction
		include "Mappings\SBZ Rotating Disc Junction.asm" ; Map_Jun

		include "Objects\SBZ Running Disc.asm" ; RunningDisc
		include "Mappings\SBZ Running Disc.asm" ; Map_Disc

		include "Objects\SBZ Conveyor Belt.asm" ; Conveyor
		include "Objects\SBZ Trapdoor & Spinning Platforms.asm" ; SpinPlatform
		include "Animations\SBZ Trapdoor & Spinning Platforms.asm" ; Ani_Spin
		include "Mappings\SBZ Trapdoor.asm" ; Map_Trap
		include "Mappings\SBZ Spinning Platforms.asm" ; Map_Spin

		include "Objects\SBZ Saws.asm" ; Saws
		include "Mappings\SBZ Saws.asm" ; Map_Saw

		include "Objects\SBZ Stomper & Sliding Doors.asm" ; ScrapStomp
		include "Mappings\SBZ Stomper & Sliding Doors.asm" ; Map_Stomp

		include "Objects\SBZ Vanishing Platform.asm" ; VanishPlatform
		include "Animations\SBZ Vanishing Platform.asm" ; Ani_Van
		include "Mappings\SBZ Vanishing Platform.asm" ; Map_VanP

		include "Objects\SBZ Electric Orb.asm" ; Electro
		include "Animations\SBZ Electric Orb.asm" ; Ani_Elec
		include "Mappings\SBZ Electric Orb.asm" ; Map_Elec

		include "Objects\SBZ Conveyor Belt Platforms.asm" ; SpinConvey
		include "Animations\SBZ Conveyor Belt Platforms.asm" ; Ani_SpinConvey

SpinC_Data:	index *
		ptr word_164B2
		ptr word_164C6
		ptr word_164DA
		ptr word_164EE
		ptr word_16502
		ptr word_16516
word_164B2:	dc.w $10, $E80
		dc.w $E14, $370
		dc.w $EEF, $302
		dc.w $EEF, $340
		dc.w $E14, $3AE
word_164C6:	dc.w $10, $F80
		dc.w $F14, $2E0
		dc.w $FEF, $272
		dc.w $FEF, $2B0
		dc.w $F14, $31E
word_164DA:	dc.w $10, $1080
		dc.w $1014, $270
		dc.w $10EF, $202
		dc.w $10EF, $240
		dc.w $1014, $2AE
word_164EE:	dc.w $10, $F80
		dc.w $F14, $570
		dc.w $FEF, $502
		dc.w $FEF, $540
		dc.w $F14, $5AE
word_16502:	dc.w $10, $1B80
		dc.w $1B14, $670
		dc.w $1BEF, $602
		dc.w $1BEF, $640
		dc.w $1B14, $6AE
word_16516:	dc.w $10, $1C80
		dc.w $1C14, $5E0
		dc.w $1CEF, $572
		dc.w $1CEF, $5B0
		dc.w $1C14, $61E
; ===========================================================================

		include "Objects\SBZ Girder Block.asm" ; Girder
		include "Mappings\SBZ Girder Block.asm" ; Map_Gird

		include "Objects\SBZ Teleporter.asm" ; Teleport

		include "Objects\Caterkiller.asm" ; Caterkiller
		include "Animations\Caterkiller.asm" ; Ani_Cat
		include "Mappings\Caterkiller.asm" ; Map_Cat

		include "Objects\Lamppost.asm" ; Lamppost
		include "Mappings\Lamppost.asm" ; Map_Lamp

		include "Objects\Hidden Bonus Points.asm" ; HiddenBonus
		include "Mappings\Hidden Bonus Points.asm" ; Map_Bonus

		include "Objects\Credits & Sonic Team Presents.asm" ; CreditsText
		include "Mappings\Credits & Sonic Team Presents.asm" ; Map_Cred

		include "Objects\GHZ Boss, BossDefeated & BossMove.asm" ; BossGreenHill
		include_BossBall_1	; Objects\GHZ Boss Ball.asm; BossBall
		include "Animations\Bosses.asm" ; Ani_Eggman
		include "Mappings\Bosses.asm" ; Map_Eggman
		include "Mappings\Boss Extras.asm" ; Map_BossItems

		include "Objects\LZ Boss.asm" ; BossLabyrinth
		include "Objects\MZ Boss.asm" ; BossMarble
		include "Objects\MZ Boss Fire.asm" ; BossFire
		include "Objects\SLZ Boss.asm" ; BossStarLight
		include "Objects\SLZ Boss Spikeballs.asm" ; BossSpikeball
		include "Mappings\SLZ Boss Spikeballs.asm" ; Map_BSBall
		include "Objects\SYZ Boss.asm" ; BossSpringYard
		include "Objects\SYZ Blocks at Boss.asm" ; BossBlock
		include "Mappings\SYZ Blocks at Boss.asm" ; Map_BossBlock

		include "Objects\SBZ2 Blocks That Eggman Breaks.asm" ; FalseFloor
		include "Objects\SBZ2 Eggman.asm" ; ScrapEggman
		include "Animations\SBZ2 Eggman.asm" ; Ani_SEgg
		include "Mappings\SBZ2 Eggman.asm" ; Map_SEgg
		include_FalseFloor_1 ; Objects\SBZ2 Blocks That Eggman Breaks.asm
		include "Mappings\SBZ2 Blocks That Eggman Breaks.asm" ; Map_FFloor

		include "Objects\FZ Boss.asm" ; BossFinal
		include "Animations\FZ Eggman.asm" ; Ani_FZEgg
		include "Mappings\FZ Eggman in Damaged Ship.asm" ; Map_FZDamaged
		include "Mappings\FZ Eggman Ship Legs.asm" ; Map_FZLegs

		include "Objects\FZ Cylinders.asm" ; EggmanCylinder
		include "Mappings\FZ Cylinders.asm" ; Map_EggCyl

		include "Objects\FZ Plasma Balls.asm" ; BossPlasma
		include "Animations\FZ Plasma Launcher.asm" ; Ani_PLaunch
		include "Mappings\FZ Plasma Launcher.asm" ; Map_PLaunch
		include "Animations\FZ Plasma Balls.asm" ; Ani_Plasma
		include "Mappings\FZ Plasma Balls.asm" ; Map_Plasma

		include "Objects\Prison Capsule.asm" ; Prison
		include "Animations\Prison Capsule.asm" ; Ani_Pri
		include "Mappings\Prison Capsule.asm" ; Map_Pri

		include "Objects\_ReactToItem, HurtSonic & KillSonic.asm"

; ---------------------------------------------------------------------------
; Subroutine to	show the special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_ShowLayout:
		bsr.w	SS_AniWallsRings
		bsr.w	SS_AniItems
		move.w	d5,-(sp)
		lea	($FFFF8000).w,a1
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

loc_1B19E:
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

loc_1B1C0:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_1B1C0

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_1B19E

		move.w	(sp)+,d5
		lea	($FF0000).l,a0
		moveq	#0,d0
		move.w	(v_camera_y_pos).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_camera_x_pos).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	($FFFF8000).w,a4
		move.w	#$F,d7

loc_1B20C:
		move.w	#$F,d6

loc_1B210:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_1B268
		cmpi.b	#$4E,d0
		bhi.s	loc_1B268
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		blo.s	loc_1B268
		cmpi.w	#$1D0,d3
		bhs.s	loc_1B268
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		blo.s	loc_1B268
		cmpi.w	#$170,d2
		bhs.s	loc_1B268
		lea	($FF4000).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_1B268
		jsr	(BuildSpr_Normal).l

loc_1B268:
		addq.w	#4,a4
		dbf	d6,loc_1B210

		lea	$70(a0),a0
		dbf	d7,loc_1B20C

		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	loc_1B288
		move.l	#0,(a2)
		rts	
; ===========================================================================

loc_1B288:
		move.b	#0,-5(a2)
		rts	
; End of function SS_ShowLayout

; ---------------------------------------------------------------------------
; Subroutine to	animate	walls and rings	in the special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_AniWallsRings:
		lea	($FF400C).l,a1
		moveq	#0,d0
		move.b	(v_ss_angle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$23,d1

loc_1B2A4:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_1B2A4

		lea	($FF4005).l,a1
		subq.b	#1,(v_syncani_1_time).w
		bpl.s	loc_1B2C8
		move.b	#7,(v_syncani_1_time).w
		addq.b	#1,(v_syncani_1_frame).w
		andi.b	#3,(v_syncani_1_frame).w

loc_1B2C8:
		move.b	(v_syncani_1_frame).w,$1D0(a1)
		subq.b	#1,(v_syncani_2_time).w
		bpl.s	loc_1B2E4
		move.b	#7,(v_syncani_2_time).w
		addq.b	#1,(v_syncani_2_frame).w
		andi.b	#1,(v_syncani_2_frame).w

loc_1B2E4:
		move.b	(v_syncani_2_frame).w,d0
		move.b	d0,$138(a1)
		move.b	d0,$160(a1)
		move.b	d0,$148(a1)
		move.b	d0,$150(a1)
		move.b	d0,$1D8(a1)
		move.b	d0,$1E0(a1)
		move.b	d0,$1E8(a1)
		move.b	d0,$1F0(a1)
		move.b	d0,$1F8(a1)
		move.b	d0,$200(a1)
		subq.b	#1,(v_syncani_3_time).w
		bpl.s	loc_1B326
		move.b	#4,(v_syncani_3_time).w
		addq.b	#1,(v_syncani_3_frame).w
		andi.b	#3,(v_syncani_3_frame).w

loc_1B326:
		move.b	(v_syncani_3_frame).w,d0
		move.b	d0,$168(a1)
		move.b	d0,$170(a1)
		move.b	d0,$178(a1)
		move.b	d0,$180(a1)
		subq.b	#1,(v_syncani_0_time).w
		bpl.s	loc_1B350
		move.b	#7,(v_syncani_0_time).w
		subq.b	#1,(v_syncani_0_frame).w
		andi.b	#7,(v_syncani_0_frame).w

loc_1B350:
		lea	($FF4016).l,a1
		lea	(SS_WaRiVramSet).l,a0
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
SS_WaRiVramSet:	dc.w $142, $6142, $142,	$142, $142, $142, $142,	$6142
		dc.w $142, $6142, $142,	$142, $142, $142, $142,	$6142
		dc.w $2142, $142, $2142, $2142,	$2142, $2142, $2142, $142
		dc.w $2142, $142, $2142, $2142,	$2142, $2142, $2142, $142
		dc.w $4142, $2142, $4142, $4142, $4142,	$4142, $4142, $2142
		dc.w $4142, $2142, $4142, $4142, $4142,	$4142, $4142, $2142
		dc.w $6142, $4142, $6142, $6142, $6142,	$6142, $6142, $4142
		dc.w $6142, $4142, $6142, $6142, $6142,	$6142, $6142, $4142
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
		move.b	#4,($FFFFD024).w
		play.w	1, jsr, sfx_Goal		; play special stage GOAL sound

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

; ---------------------------------------------------------------------------
; Special stage start locations
; ---------------------------------------------------------------------------
SS_StartLoc:

		incbin	"startpos\ss1.bin"
		incbin	"startpos\ss2.bin"
		incbin	"startpos\ss3.bin"
		incbin	"startpos\ss4.bin"
		incbin	"startpos\ss5.bin"
		incbin	"startpos\ss6.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	load special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_Load:
		moveq	#0,d0
		move.b	(v_last_ss_levelid).w,d0 ; load number of last special stage entered
		addq.b	#1,(v_last_ss_levelid).w
		cmpi.b	#6,(v_last_ss_levelid).w
		blo.s	SS_ChkEmldNum
		move.b	#0,(v_last_ss_levelid).w ; reset if higher than 6

SS_ChkEmldNum:
		cmpi.b	#6,(v_emeralds).w ; do you have all emeralds?
		beq.s	SS_LoadData	; if yes, branch
		moveq	#0,d1
		move.b	(v_emeralds).w,d1
		subq.b	#1,d1
		blo.s	SS_LoadData
		lea	(v_emerald_list).w,a3 ; check which emeralds you have

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
		move.w	(a1)+,(v_ost_player+ost_x_pos).w
		move.w	(a1)+,(v_ost_player+ost_y_pos).w
		movea.l	SS_LayoutIndex(pc,d0.w),a0
		lea	($FF4000).l,a1
		move.w	#0,d0
		jsr	(EniDec).l
		lea	($FF0000).l,a1
		move.w	#$FFF,d0

SS_ClrRAM3:
		clr.l	(a1)+
		dbf	d0,SS_ClrRAM3

		lea	($FF1020).l,a1
		lea	($FF4000).l,a0
		moveq	#$3F,d1

loc_1B6F6:
		moveq	#$3F,d2

loc_1B6F8:
		move.b	(a0)+,(a1)+
		dbf	d2,loc_1B6F8

		lea	$40(a1),a1
		dbf	d1,loc_1B6F6

		lea	($FF4008).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#$4D,d1

loc_1B714:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_1B714

		lea	($FF4400).l,a1
		move.w	#$3F,d1

loc_1B730:

		clr.l	(a1)+
		dbf	d1,loc_1B730

		rts	
; End of function SS_Load

; ===========================================================================

; ---------------------------------------------------------------------------
; Special stage	mappings and VRAM pointers
; ---------------------------------------------------------------------------

ss_sprite:	macro map,tile,frame
		dc.l map+(frame*$1000000)
		dc.w tile
		endm
		
SS_MapIndex:
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal2,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal3,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_SSWalls,tile_Nem_SSWalls+tile_pal4,0
		ss_sprite Map_Bump,tile_Nem_Bumper_SS,0
		ss_sprite Map_SS_R,tile_Nem_SSWBlock,0
		ss_sprite Map_SS_R,tile_Nem_SSGOAL,0
		ss_sprite Map_SS_R,tile_Nem_SS1UpBlock,0
		ss_sprite Map_SS_Up,tile_Nem_SSUpDown,0
		ss_sprite Map_SS_Down,tile_Nem_SSUpDown,0
		ss_sprite Map_SS_R,tile_Nem_SSRBlock+tile_pal2,0
		ss_sprite Map_SS_Glass,tile_Nem_SSRedWhite,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal4,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal2,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal3,0
		ss_sprite Map_SS_R,tile_Nem_SSRBlock,0
		ss_sprite Map_Bump,tile_Nem_Bumper_SS,id_frame_bump_bumped1
		ss_sprite Map_Bump,tile_Nem_Bumper_SS,id_frame_bump_bumped2
		ss_sprite Map_SS_R,tile_Nem_SSZone1,0
		ss_sprite Map_SS_R,tile_Nem_SSZone2,0
		ss_sprite Map_SS_R,tile_Nem_SSZone3,0
		ss_sprite Map_SS_R,tile_Nem_SSZone1,0
		ss_sprite Map_SS_R,tile_Nem_SSZone2,0
		ss_sprite Map_SS_R,tile_Nem_SSZone3,0
		ss_sprite Map_Ring,tile_Nem_Ring+tile_pal2,0
		ss_sprite Map_SS_Chaos3,tile_Nem_SSEmerald,0
		ss_sprite Map_SS_Chaos3,tile_Nem_SSEmerald+tile_pal2,0
		ss_sprite Map_SS_Chaos3,tile_Nem_SSEmerald+tile_pal3,0
		ss_sprite Map_SS_Chaos3,tile_Nem_SSEmerald+tile_pal4,0
		ss_sprite Map_SS_Chaos1,tile_Nem_SSEmerald,0
		ss_sprite Map_SS_Chaos2,tile_Nem_SSEmerald,0
		ss_sprite Map_SS_R,tile_Nem_SSGhost,0
		ss_sprite Map_Ring,tile_Nem_Ring+tile_pal2,id_frame_ring_sparkle1
		ss_sprite Map_Ring,tile_Nem_Ring+tile_pal2,id_frame_ring_sparkle2
		ss_sprite Map_Ring,tile_Nem_Ring+tile_pal2,id_frame_ring_sparkle3
		ss_sprite Map_Ring,tile_Nem_Ring+tile_pal2,id_frame_ring_sparkle4
		ss_sprite Map_SS_Glass,tile_Nem_SSEmStars+tile_pal2,0
		ss_sprite Map_SS_Glass,tile_Nem_SSEmStars+tile_pal2,1
		ss_sprite Map_SS_Glass,tile_Nem_SSEmStars+tile_pal2,2
		ss_sprite Map_SS_Glass,tile_Nem_SSEmStars+tile_pal2,3
		ss_sprite Map_SS_R,tile_Nem_SSGhost,2
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal4,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal2,0
		ss_sprite Map_SS_Glass,tile_Nem_SSGlass+tile_pal3,0

		include "Mappings\Special Stage R.asm" ; Map_SS_R
		include "Mappings\Special Stage Breakable & Red-White Blocks.asm" ; Map_SS_Glass
		include "Mappings\Special Stage Up.asm" ; Map_SS_Up
		include "Mappings\Special Stage Down.asm" ; Map_SS_Down
		include "Mappings\Special Stage Chaos Emeralds.asm" ; Map_SS_Chaos1, Map_SS_Chaos2 & Map_SS_Chaos3

		include "Objects\Special Stage Sonic.asm" ; SonicSpecial
; ---------------------------------------------------------------------------
; Object 10 - blank
; ---------------------------------------------------------------------------

Obj10:
		rts	

		include "Includes\AnimateLevelGfx.asm"

		include "Objects\HUD.asm" ; HUD
		include "Mappings\HUD Score, Time & Rings.asm" ; Map_HUD

		include "Objects\_AddPoints.asm"

		include "Includes\HUD_Update, HUD_Base & ContScrCounter.asm"

Art_Hud:	incbin	"Graphics\HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	incbin	"Graphics\Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even

		include "Objects\_DebugMode.asm"

; ---------------------------------------------------------------------------
; Level Headers
; ---------------------------------------------------------------------------

LevelHeaders:

lhead:	macro plc1,lvlgfx,plc2,sixteen,twofivesix,music,pal
	dc.l (plc1<<24)+lvlgfx
	dc.l (plc2<<24)+sixteen
	dc.l twofivesix
	dc.b 0, music, pal, pal
	endm

; 1st PLC, level gfx (unused), 2nd PLC, 16x16 data, 256x256 data,
; music (unused), palette (unused), palette

;		1st PLC				2nd PLC				256x256 data			palette
;				level gfx*			16x16 data			music*

	lhead	id_PLC_GHZ,	Nem_GHZ_2nd,	id_PLC_GHZ2,	Blk16_GHZ,	Blk256_GHZ,	mus_GHZ,	id_Pal_GHZ	; Green Hill
	lhead	id_PLC_LZ,	Nem_LZ,		id_PLC_LZ2,	Blk16_LZ,	Blk256_LZ,	mus_LZ,		id_Pal_LZ	; Labyrinth
	lhead	id_PLC_MZ,	Nem_MZ,		id_PLC_MZ2,	Blk16_MZ,	Blk256_MZ,	mus_MZ,		id_Pal_MZ	; Marble
	lhead	id_PLC_SLZ,	Nem_SLZ,	id_PLC_SLZ2,	Blk16_SLZ,	Blk256_SLZ,	mus_SLZ,	id_Pal_SLZ	; Star Light
	lhead	id_PLC_SYZ,	Nem_SYZ,	id_PLC_SYZ2,	Blk16_SYZ,	Blk256_SYZ,	mus_SYZ,	id_Pal_SYZ	; Spring Yard
	lhead	id_PLC_SBZ,	Nem_SBZ,	id_PLC_SBZ2,	Blk16_SBZ,	Blk256_SBZ,	mus_SBZ,	id_Pal_SBZ1	; Scrap Brain
	zonewarning LevelHeaders,$10
	lhead	0,		Nem_GHZ_2nd,	0,		Blk16_GHZ,	Blk256_GHZ,	mus_SBZ,	id_Pal_Ending	; Ending
	even

;	* music and level gfx are actually set elsewhere, so these values are useless

		include "Nemesis File List.asm"
ArtLoadCues:	include "Pattern Load Cues.asm"


		align	$200,$FF
		if Revision=0
		nemfile	Nem_SegaLogo
Eni_SegaLogo:	incbin	"tilemaps\Sega Logo.bin" ; large Sega logo (mappings)
		even
		else
			dcb.b	$300,$FF
			nemfile	Nem_SegaLogo
	Eni_SegaLogo:	incbin	"tilemaps\Sega Logo (JP1).bin" ; large Sega logo (mappings)
			even
		endc
Eni_Title:	incbin	"tilemaps\Title Screen.bin" ; title screen foreground (mappings)
		even
		nemfile	Nem_TitleFg
		nemfile	Nem_TitleSonic
		nemfile	Nem_TitleTM
Eni_JapNames:	incbin	"tilemaps\Hidden Japanese Credits.bin" ; Japanese credits (mappings)
		even
		nemfile	Nem_JapNames

		include "Mappings\Sonic.asm" ; Map_Sonic
		include "Mappings\Sonic DPLCs.asm" ; SonicDynPLC

; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	incbin	"Graphics\Sonic.bin" ; Sonic
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
		if Revision=0
		nemfile	Nem_Smoke
		nemfile	Nem_SyzSparkle
		endc
		nemfile	Nem_Shield
		nemfile	Nem_Stars
		if Revision=0
		nemfile	Nem_LzSonic
		nemfile	Nem_UnkFire
		nemfile	Nem_Warp
		nemfile	Nem_Goggle
		endc

		include "Mappings\Special Stage Walls.asm" ; Map_SSWalls

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
		nemfile	Nem_SSWalls
Eni_SSBg1:	incbin	"tilemaps\SS Background 1.bin" ; special stage background (mappings)
		even
		nemfile	Nem_SSBgFish
Eni_SSBg2:	incbin	"tilemaps\SS Background 2.bin" ; special stage background (mappings)
		even
		nemfile	Nem_SSBgCloud
		nemfile	Nem_SSGOAL
		nemfile	Nem_SSRBlock
		nemfile	Nem_SS1UpBlock
		nemfile	Nem_SSEmStars
		nemfile	Nem_SSRedWhite
		nemfile	Nem_SSZone1
		nemfile	Nem_SSZone2
		nemfile	Nem_SSZone3
		nemfile	Nem_SSZone4
		nemfile	Nem_SSZone5
		nemfile	Nem_SSZone6
		nemfile	Nem_SSUpDown
		nemfile	Nem_SSEmerald
		nemfile	Nem_SSGhost
		nemfile	Nem_SSWBlock
		nemfile	Nem_SSGlass
		nemfile	Nem_ResultEm
; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_Stalk
		nemfile	Nem_Swing
		nemfile	Nem_Bridge
		nemfile	Nem_GhzUnkBlock
		nemfile	Nem_Ball
		nemfile	Nem_Spikes
		nemfile	Nem_GhzLog
		nemfile	Nem_SpikePole
		nemfile	Nem_PplRock
		nemfile	Nem_GhzWall1
		nemfile	Nem_GhzWall2
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_Water
		nemfile	Nem_Splash
		nemfile	Nem_LzSpikeBall
		nemfile	Nem_FlapDoor
		nemfile	Nem_Bubbles
		nemfile	Nem_LzBlock3
		nemfile	Nem_LzDoor1
		nemfile	Nem_Harpoon
		nemfile	Nem_LzPole
		nemfile	Nem_LzDoor2
		nemfile	Nem_LzWheel
		nemfile	Nem_Gargoyle
		nemfile	Nem_LzBlock2
		nemfile	Nem_LzPlatfm
		nemfile	Nem_Cork
		nemfile	Nem_LzBlock1
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_MzMetal
		nemfile	Nem_MzSwitch
		nemfile	Nem_MzGlass
		nemfile	Nem_UnkGrass
		nemfile	Nem_Fireball
		nemfile	Nem_Lava
		nemfile	Nem_MzBlock
		nemfile	Nem_MzUnkBlock
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_Seesaw
		nemfile	Nem_SlzSpike
		nemfile	Nem_Fan
		nemfile	Nem_SlzWall
		nemfile	Nem_Pylon
		nemfile	Nem_SlzSwing
		nemfile	Nem_SlzBlock
		nemfile	Nem_SlzCannon
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_Bumper
		nemfile	Nem_SmallSpike
		nemfile	Nem_LzSwitch
		nemfile	Nem_BigSpike
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
		nemfile	Nem_SbzWheel1
		nemfile	Nem_SbzWheel2
		nemfile	Nem_Cutter
		nemfile	Nem_Stomper
		nemfile	Nem_SpinPform
		nemfile	Nem_TrapDoor
		nemfile	Nem_SbzFloor
		nemfile	Nem_Electric
		nemfile	Nem_SbzBlock
		nemfile	Nem_FlamePipe
		nemfile	Nem_SbzDoor1
		nemfile	Nem_SlideFloor
		nemfile	Nem_SbzDoor2
		nemfile	Nem_Girder
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
		nemfile	Nem_BallHog
		nemfile	Nem_Crabmeat
		nemfile	Nem_Buzz
		nemfile	Nem_UnkExplode
		nemfile	Nem_Burrobot
		nemfile	Nem_Chopper
		nemfile	Nem_Jaws
		nemfile	Nem_Roller
		nemfile	Nem_Motobug
		nemfile	Nem_Newtron
		nemfile	Nem_Yadrin
		nemfile	Nem_Batbrain
		nemfile	Nem_Splats
		nemfile	Nem_Bomb
		nemfile	Nem_Orbinaut
		nemfile	Nem_Cater
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
		nemfile	Nem_TitleCard
		nemfile	Nem_Hud,"HUD"	; HUD (rings, time
		nemfile	Nem_Lives
		nemfile	Nem_Ring
		nemfile	Nem_Monitors
		nemfile	Nem_Explode
		nemfile	Nem_Points
		nemfile	Nem_GameOver
		nemfile	Nem_HSpring
		nemfile	Nem_VSpring
		nemfile	Nem_SignPost
		nemfile	Nem_Lamp
		nemfile	Nem_BigFlash
		nemfile	Nem_Bonus
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
		nemfile	Nem_ContSonic
		nemfile	Nem_MiniSonic
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
		nemfile	Nem_Rabbit
		nemfile	Nem_Chicken
		nemfile	Nem_BlackBird
		nemfile	Nem_Seal
		nemfile	Nem_Pig
		nemfile	Nem_Flicky
		nemfile	Nem_Squirrel
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	incbin	"map16\GHZ.bin"
		even
		nemfile	Nem_GHZ_1st
		nemfile	Nem_GHZ_2nd
Blk256_GHZ:	incbin	"256x256 Mappings\GHZ.kos"
		even
Blk16_LZ:	incbin	"map16\LZ.bin"
		even
		nemfile	Nem_LZ
Blk256_LZ:	incbin	"256x256 Mappings\LZ.kos"
		even
Blk16_MZ:	incbin	"map16\MZ.bin"
		even
		nemfile	Nem_MZ
Blk256_MZ:	if Revision=0
			incbin	"256x256 Mappings\MZ.kos"
		else
			incbin	"256x256 Mappings\MZ (JP1).kos"
		endc
		even
Blk16_SLZ:	incbin	"map16\SLZ.bin"
		even
		nemfile	Nem_SLZ
Blk256_SLZ:	incbin	"256x256 Mappings\SLZ.kos"
		even
Blk16_SYZ:	incbin	"map16\SYZ.bin"
		even
		nemfile	Nem_SYZ
Blk256_SYZ:	incbin	"256x256 Mappings\SYZ.kos"
		even
Blk16_SBZ:	incbin	"map16\SBZ.bin"
		even
		nemfile	Nem_SBZ
Blk256_SBZ:	if Revision=0
			incbin	"256x256 Mappings\SBZ.kos"
		else
			incbin	"256x256 Mappings\SBZ (JP1).kos"
		endc
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
		nemfile	Nem_Eggman
		nemfile	Nem_Weapons
		nemfile	Nem_Prison
		nemfile	Nem_Sbz2Eggman
		nemfile	Nem_FzBoss
		nemfile	Nem_FzEggman
		nemfile	Nem_Exhaust
		nemfile	Nem_EndEm
		nemfile	Nem_EndSonic
		nemfile	Nem_TryAgain
		if Revision=0
			nemfile	Nem_EndEggman
		endc
Kos_EndFlowers:	incbin	"Graphics - Compressed\Ending Flowers.kos" ; ending sequence animated flowers
		even
		nemfile	Nem_EndFlower
		nemfile	Nem_CreditText
		nemfile	Nem_EndStH

		if Revision=0
		dcb.b $104,$FF		; why?
		else
		dcb.b $40,$FF
		endc
; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
AngleMap:	incbin	"collide\Angle Map.bin"
		even
CollArray1:	incbin	"collide\Collision Array (Normal).bin"
		even
CollArray2:	incbin	"collide\Collision Array (Rotated).bin"
		even
Col_GHZ:	incbin	"collide\GHZ.bin"	; GHZ index
		even
Col_LZ:		incbin	"collide\LZ.bin"	; LZ index
		even
Col_MZ:		incbin	"collide\MZ.bin"	; MZ index
		even
Col_SLZ:	incbin	"collide\SLZ.bin"	; SLZ index
		even
Col_SYZ:	incbin	"collide\SYZ.bin"	; SYZ index
		even
Col_SBZ:	incbin	"collide\SBZ.bin"	; SBZ index
		even
; ---------------------------------------------------------------------------
; Special Stage layouts
; ---------------------------------------------------------------------------
SS_1:		incbin	"sslayout\1.bin"
		even
SS_2:		incbin	"sslayout\2.bin"
		even
SS_3:		incbin	"sslayout\3.bin"
		even
SS_4:		incbin	"sslayout\4.bin"
		even
		if Revision=0
SS_5:		incbin	"sslayout\5.bin"
		even
SS_6:		incbin	"sslayout\6.bin"
		else
	SS_5:		incbin	"sslayout\5 (JP1).bin"
			even
	SS_6:		incbin	"sslayout\6 (JP1).bin"
		endc
		even
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	incbin	"Graphics\GHZ Waterfall.bin"
		even
Art_GhzFlower1:	incbin	"Graphics\GHZ Flower Large.bin"
		even
Art_GhzFlower2:	incbin	"Graphics\GHZ Flower Small.bin"
		even
Art_MzLava1:	incbin	"Graphics\MZ Lava Surface.bin"
		even
Art_MzLava2:	incbin	"Graphics\MZ Lava.bin"
		even
Art_MzTorch:	incbin	"Graphics\MZ Background Torch.bin"
		even
Art_SbzSmoke:	incbin	"Graphics\SBZ Background Smoke.bin"
		even

; ---------------------------------------------------------------------------
; Level	layout index
; ---------------------------------------------------------------------------
Level_Index:	index *
		; GHZ
		ptr Level_GHZ1
		ptr Level_GHZbg
		ptr byte_68D70
		
		ptr Level_GHZ2
		ptr Level_GHZbg
		ptr byte_68E3C
		
		ptr Level_GHZ3
		ptr Level_GHZbg
		ptr byte_68F84
		
		ptr byte_68F88
		ptr byte_68F88
		ptr byte_68F88
		
		; LZ
		ptr Level_LZ1
		ptr Level_LZbg
		ptr byte_69190
		
		ptr Level_LZ2
		ptr Level_LZbg
		ptr byte_6922E
		
		ptr Level_LZ3
		ptr Level_LZbg
		ptr byte_6934C
		
		ptr Level_SBZ3
		ptr Level_LZbg
		ptr byte_6940A
		
		; MZ
		ptr Level_MZ1
		ptr Level_MZ1bg
		ptr Level_MZ1
		
		ptr Level_MZ2
		ptr Level_MZ2bg
		ptr byte_6965C
		
		ptr Level_MZ3
		ptr Level_MZ3bg
		ptr byte_697E6
		
		ptr byte_697EA
		ptr byte_697EA
		ptr byte_697EA
		
		; SLZ
		ptr Level_SLZ1
		ptr Level_SLZbg
		ptr byte_69B84
		
		ptr Level_SLZ2
		ptr Level_SLZbg
		ptr byte_69B84
		
		ptr Level_SLZ3
		ptr Level_SLZbg
		ptr byte_69B84
		
		ptr byte_69B84
		ptr byte_69B84
		ptr byte_69B84
		
		; SYZ
		ptr Level_SYZ1
		ptr Level_SYZbg
		ptr byte_69C7E
		
		ptr Level_SYZ2
		ptr Level_SYZbg
		ptr byte_69D86
		
		ptr Level_SYZ3
		ptr Level_SYZbg
		ptr byte_69EE4
		
		ptr byte_69EE8
		ptr byte_69EE8
		ptr byte_69EE8
		
		; SBZ
		ptr Level_SBZ1
		ptr Level_SBZ1bg
		ptr Level_SBZ1bg
		
		ptr Level_SBZ2
		ptr Level_SBZ2bg
		ptr Level_SBZ2bg
		
		ptr Level_SBZ2
		ptr Level_SBZ2bg
		ptr byte_6A2F8
		
		ptr byte_6A2FC
		ptr byte_6A2FC
		ptr byte_6A2FC
		zonewarning Level_Index,24
		
		; Ending
		ptr Level_End
		ptr Level_GHZbg
		ptr byte_6A320
		
		ptr Level_End
		ptr Level_GHZbg
		ptr byte_6A320
		
		ptr byte_6A320
		ptr byte_6A320
		ptr byte_6A320
		
		ptr byte_6A320
		ptr byte_6A320
		ptr byte_6A320

Level_GHZ1:	incbin	"levels\ghz1.bin"
		even
byte_68D70:	dc.b 0,	0, 0, 0
Level_GHZ2:	incbin	"levels\ghz2.bin"
		even
byte_68E3C:	dc.b 0,	0, 0, 0
Level_GHZ3:	incbin	"levels\ghz3.bin"
		even
Level_GHZbg:	incbin	"levels\ghzbg.bin"
		even
byte_68F84:	dc.b 0,	0, 0, 0
byte_68F88:	dc.b 0,	0, 0, 0

Level_LZ1:	incbin	"levels\lz1.bin"
		even
Level_LZbg:	incbin	"levels\lzbg.bin"
		even
byte_69190:	dc.b 0,	0, 0, 0
Level_LZ2:	incbin	"levels\lz2.bin"
		even
byte_6922E:	dc.b 0,	0, 0, 0
Level_LZ3:	incbin	"levels\lz3.bin"
		even
byte_6934C:	dc.b 0,	0, 0, 0
Level_SBZ3:	incbin	"levels\sbz3.bin"
		even
byte_6940A:	dc.b 0,	0, 0, 0

Level_MZ1:	incbin	"levels\mz1.bin"
		even
Level_MZ1bg:	incbin	"levels\mz1bg.bin"
		even
Level_MZ2:	incbin	"levels\mz2.bin"
		even
Level_MZ2bg:	incbin	"levels\mz2bg.bin"
		even
byte_6965C:	dc.b 0,	0, 0, 0
Level_MZ3:	incbin	"levels\mz3.bin"
		even
Level_MZ3bg:	incbin	"levels\mz3bg.bin"
		even
byte_697E6:	dc.b 0,	0, 0, 0
byte_697EA:	dc.b 0,	0, 0, 0

Level_SLZ1:	incbin	"levels\slz1.bin"
		even
Level_SLZbg:	incbin	"levels\slzbg.bin"
		even
Level_SLZ2:	incbin	"levels\slz2.bin"
		even
Level_SLZ3:	incbin	"levels\slz3.bin"
		even
byte_69B84:	dc.b 0,	0, 0, 0

Level_SYZ1:	incbin	"levels\syz1.bin"
		even
Level_SYZbg:	if Revision=0
		incbin	"levels\syzbg.bin"
		else
		incbin	"levels\syzbg (JP1).bin"
		endc
		even
byte_69C7E:	dc.b 0,	0, 0, 0
Level_SYZ2:	incbin	"levels\syz2.bin"
		even
byte_69D86:	dc.b 0,	0, 0, 0
Level_SYZ3:	incbin	"levels\syz3.bin"
		even
byte_69EE4:	dc.b 0,	0, 0, 0
byte_69EE8:	dc.b 0,	0, 0, 0

Level_SBZ1:	incbin	"levels\sbz1.bin"
		even
Level_SBZ1bg:	incbin	"levels\sbz1bg.bin"
		even
Level_SBZ2:	incbin	"levels\sbz2.bin"
		even
Level_SBZ2bg:	incbin	"levels\sbz2bg.bin"
		even
byte_6A2F8:	dc.b 0,	0, 0, 0
byte_6A2FC:	dc.b 0,	0, 0, 0
Level_End:	incbin	"levels\ending.bin"
		even
byte_6A320:	dc.b 0,	0, 0, 0


Art_BigRing:	incbin	"Graphics\Giant Ring.bin"
		even

		align	$100,$FF

; ---------------------------------------------------------------------------
; Sprite locations index
; ---------------------------------------------------------------------------
ObjPos_Index:	index *
		; GHZ
		ptr ObjPos_GHZ1
		ptr ObjPos_Null
		ptr ObjPos_GHZ2
		ptr ObjPos_Null
		ptr ObjPos_GHZ3
		ptr ObjPos_Null
		ptr ObjPos_GHZ1
		ptr ObjPos_Null
		; LZ
		ptr ObjPos_LZ1
		ptr ObjPos_Null
		ptr ObjPos_LZ2
		ptr ObjPos_Null
		ptr ObjPos_LZ3
		ptr ObjPos_Null
		ptr ObjPos_SBZ3
		ptr ObjPos_Null
		; MZ
		ptr ObjPos_MZ1
		ptr ObjPos_Null
		ptr ObjPos_MZ2
		ptr ObjPos_Null
		ptr ObjPos_MZ3
		ptr ObjPos_Null
		ptr ObjPos_MZ1
		ptr ObjPos_Null
		; SLZ
		ptr ObjPos_SLZ1
		ptr ObjPos_Null
		ptr ObjPos_SLZ2
		ptr ObjPos_Null
		ptr ObjPos_SLZ3
		ptr ObjPos_Null
		ptr ObjPos_SLZ1
		ptr ObjPos_Null
		; SYZ
		ptr ObjPos_SYZ1
		ptr ObjPos_Null
		ptr ObjPos_SYZ2
		ptr ObjPos_Null
		ptr ObjPos_SYZ3
		ptr ObjPos_Null
		ptr ObjPos_SYZ1
		ptr ObjPos_Null
		; SBZ
		ptr ObjPos_SBZ1
		ptr ObjPos_Null
		ptr ObjPos_SBZ2
		ptr ObjPos_Null
		ptr ObjPos_FZ
		ptr ObjPos_Null
		ptr ObjPos_SBZ1
		ptr ObjPos_Null
		zonewarning ObjPos_Index,$10
		; Ending
		ptr ObjPos_End
		ptr ObjPos_Null
		ptr ObjPos_End
		ptr ObjPos_Null
		ptr ObjPos_End
		ptr ObjPos_Null
		ptr ObjPos_End
		ptr ObjPos_Null
		; --- Put extra object data here. ---
ObjPosLZPlatform_Index:
		ptr ObjPos_LZ1pf1
		ptr ObjPos_LZ1pf2
		ptr ObjPos_LZ2pf1
		ptr ObjPos_LZ2pf2
		ptr ObjPos_LZ3pf1
		ptr ObjPos_LZ3pf2
		ptr ObjPos_LZ1pf1
		ptr ObjPos_LZ1pf2
ObjPosSBZPlatform_Index:
		ptr ObjPos_SBZ1pf1
		ptr ObjPos_SBZ1pf2
		ptr ObjPos_SBZ1pf3
		ptr ObjPos_SBZ1pf4
		ptr ObjPos_SBZ1pf5
		ptr ObjPos_SBZ1pf6
		ptr ObjPos_SBZ1pf1
		ptr ObjPos_SBZ1pf2
		endobj
		
		include "Object Subtypes.asm"
		include	"Object Placement\GHZ1.asm"
		include	"Object Placement\GHZ2.asm"
		include	"Object Placement\GHZ3.asm"
		include	"Object Placement\LZ1.asm"
		include	"Object Placement\LZ2.asm"
		include	"Object Placement\LZ3.asm"
		include	"Object Placement\SBZ3.asm"
		include	"Object Placement\LZ Platforms.asm"
		include	"Object Placement\MZ1.asm"
		include	"Object Placement\MZ2.asm"
		include	"Object Placement\MZ3.asm"
		include	"Object Placement\SLZ1.asm"
		include	"Object Placement\SLZ2.asm"
		include	"Object Placement\SLZ3.asm"
		include	"Object Placement\SYZ1.asm"
		include	"Object Placement\SYZ2.asm"
		include	"Object Placement\SYZ3.asm"
		include	"Object Placement\SBZ1.asm"
		include	"Object Placement\SBZ2.asm"
		include	"Object Placement\FZ.asm"
		include	"Object Placement\SBZ Platforms.asm"
		include	"Object Placement\Ending.asm"
ObjPos_Null:	endobj

		if Revision=0
		dcb.b $62A,$FF
		else
		dcb.b $63C,$FF
		endc
		;dcb.b ($10000-(*%$10000))-(EndOfRom-SoundDriver),$FF

; ===========================================================================
; ---------------------------------------------------------------------------
; Include sound driver data
; ---------------------------------------------------------------------------

		include "sound/Sound Data.asm"

EndOfRom:
		END
