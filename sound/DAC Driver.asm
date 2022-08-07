; ===========================================================================
;  DZ80 V3.4.1 Z80 Disassembly of z80nodata.bin
;  2007/09/18 15:48
;
;  Sonic 1 Z80 Driver disassembly by Puto.
;  Disassembly fixed, improved and integrated into SVN by Flamewing.
;  Adapted to s1disasm by Aurora Fields
; ===========================================================================

		opt	l.					; . is the local label symbol
		opt	ae-					; automatic even's are disabled by default
		opt	ws+					; allow statements to contain white-spaces
		opt	w+					; print warnings
		opt	m+					; do not expand macros - if enabled, this can break assembling

		org	0					; z80 Align, handled by the build process
		include	"Macros - More CPUs.asm"		; include language macros
		cpu	z80					; also start a new z80 program

SEGAPCM:	equ $DEADBEEF					; give Sega PCM an arbitary value. Basically, just avoid getting optimized by Kosinski
SEGAPCM_Len:	equ $AC1D					; give Sega PCM an arbitary size. Basically, just avoid getting optimized by Kosinski
SEGAPCM_Pitch:	equ 0Bh						; the pitch of the SEGA sound

		rsset 1FFCh					; extra RAM variables
z80_stack:	rs.b 1						; stack pointer
zDAC_Status:	rs.b 1						; bit 7 set if the driver is not accepting new samples, it is clear otherwise
		rs.b 1						; unused
zDAC_Sample:	rs.b 1						; sample to play, the 68K will move into this locatiton whatever sample that's supposed to be played.

YMREG1:		equ 4000h					; YM2612/YM2428 port 1 address register
zBankSelect:	equ 6000h					; ROM bank shift register
zWindow:	equ 8000h					; start of ROM window
; ===========================================================================

Z80Driver_Start:
		di						; Disable interrupts. Interrupts will never be reenabled
		di						; for the z80, so that no code will be executed on V-Int.
		di						; This means that the sample loop is all the z80 does.

		ld	sp,z80_stack				; Initialize the stack pointer (unused throughout the driver)
		ld	ix,YMREG1				; ix = Pointer to memory-mapped communication register with YM2612

		xor	a					; a=0
		ld	(zDAC_Status),a				; Disable DAC
		ld	(zDAC_Sample),a				; Clear sample
		ld	a,(SEGAPCM>>24)&$FF			; least significant bit from ROM bank ID
		ld	(zBankSelect),a				; Latch it to bank register, initializing bank switch

		ld	b,8					; Number of bits to latch to ROM bank
		ld	a,(SEGAPCM>>16)&$FF			; Bank ID without the least significant bit

.bankswitch:
		ld	(zBankSelect),a				; Latch another bit to bank register.
		rrca						; Move next bit into position
		djnz	.bankswitch				; decrement and loop if not zero
		jr	CheckForSamples

; ---------------------------------------------------------------------------
; DAC decode look-up table
; ---------------------------------------------------------------------------

zDACDecodeTbl:
		db   0,	  1,   2,   4,   8,  10h,  20h,  40h
		db 80h,	 -1,  -2,  -4,  -8, -10h, -20h, -40h

		if (*&$FF00)<>(zDACDecodeTbl&$FF00)
		inform 2,"zDACDecodeTbl was not properly aligned!"
		endc
; ---------------------------------------------------------------------------

CheckForSamples:
		ld	hl,zDAC_Sample				; Load the address of next sample.

.nullsample:
		ld	a,(hl)					; a = next sample to play.
		or	a					; Do we have a valid sample?
		jp	p,.nullsample				; Loop until we do

		sub	81h					; Make 0-based index
		ld	(hl),a					; Store it back into sample index (i.e., mark it as being played)
		cp	6					; Is the sample 87h or higher?
		jr	nc,Play_Sega				; If yes, branch

		ld	de,0					; de = 0
		ld	iy,PCM_Table				; iy = pointer to PCM Table

		sla	a					; each PCM entry has 8 bytes of data
		sla	a					; this code shifts a left by 3
		sla	a					; which is the same as multiplying sample ID by 8.

		ld	b,0					;
		ld	c,a					; bc = offset into PCM_Table for the sample data
		add	iy,bc					; iy = pointer to DAC sample entry

		ld	e,(iy+0)				;
		ld	d,(iy+1)				; de = pointer to the DAC sample
		ld	c,(iy+2)				;
		ld	b,(iy+3)				; bc = size of the DAC sample
		exx						; bc' = size of sample, de' = location of sample, hl' = pointer to zDAC_Sample

		ld	d,80h					; initialize the DPCM accumulator as 80h
		ld	hl,zDAC_Status				; hl = pointer to zDAC_Status
		ld	(hl),d					; Set flag to not accept driver input

		ld	(ix+0),2Bh				; Select enable/disable DAC register
		ld	e,2Ah					; prepare DAC data register into e
		ld	c,(iy+4)				; c = pitch of the DAC sample

		ld	(ix+1),d				; Enable DAC
		ld	(hl),0					; Set flag to accept driver input

		exx						; swap registers
		ld	h,(zDACDecodeTbl&0FF00h)>>8		; load upper byte of zDACDecodeTbl into h (l will be loaded dynamically)

; ---------------------------------------------------------------------------
; DPCM playback loop
;
; registers:
; 	bc: number of bytes left to play
;	de: pointer to the next byte to play
;	hl: zDAC_Sample
;	b': will be used for delay loops
;	c': sample pitch (copied to b')
;	d': DPCM accumulator
;	e': DAC data register value (2Ah)
;	hl': zDAC_Status
; ---------------------------------------------------------------------------

PlaySampleLoop:
		ld	a,(de)					; load the current DPCM byte into a
		and	0F0h					; get upper nibble

		rrca						; we need to shift upper nibble to lower nibble
		rrca						; the code below uses this to load the look-up table value
		rrca						; to process the next DPCM byte
		rrca						; so we shift right by 4 bits

		add	a,zDACDecodeTbl&0FFh			; add the lower byte of zDACDecodeTbl into a
		ld	l,a					; hl = the specific byte we want to read within zDACDecodeTbl
		ld	a,(hl)					; a = the accumulator offset value

		exx						; swap registers
		add	a,d					;
		ld	d,a					; add a into the accumulator

		ld	(hl),l					; Set flag to not accept driver input (l = FFh)
		ld	(ix+0),e				; select the DAC data register (2Ah)
		ld	(ix+1),d				; send DAC value to YM
		ld	(hl),h					; Set flag to accept driver input (h = 1Fh)

		ld	b,c					; b = sample pitch
		djnz	*					; delay the z80 to allow for pitch variations
; ---------------------------------------------------------------------------

		exx
		ld	a,(de)					; load the current DPCM byte into a
		and	0Fh					; get lower nibble

		add	a,zDACDecodeTbl&0FFh			; add the lower byte of zDACDecodeTbl into a
		ld	l,a					; hl = the specific byte we want to read within zDACDecodeTbl
		ld	a,(hl)					; a = the accumulator offset value

		exx						; swap registers
		add	a,d					;
		ld	d,a					; add a into the accumulator

		ld	(hl),l					; Set flag to not accept driver input (l = FFh)
		ld	(ix+0),e				; select the DAC data register (2Ah)
		ld	(ix+1),d				; send DAC value to YM
		ld	(hl),h					; Set flag to accept driver input (h = 1Fh)

		ld	b,c					; b = sample pitch
		djnz	*					; delay the z80 to allow for pitch variations
; ---------------------------------------------------------------------------

		exx						; swap registers
		ld	a,(zDAC_Sample)				; load the current sample number (could have used hl?)
		bit	7,a					; check if bit7 was set (this indicates that a new sample was loaded)
		jp	nz,CheckForSamples			; if set, load the next sample

		inc	de					; go to the next byte in the sample
		dec	bc					; decrement the number of bytes left to play

		ld	a,c					; check if bc is 0
		or	b					; this does the actual check - if not, then a will be nonzero
		jp	nz,PlaySampleLoop			; if bc is not 0, keep playing the sample
		jp	CheckForSamples				; Sample is done; wait for new samples

; ---------------------------------------------------------------------------
; Subroutine to play the SEGA PCM
; ---------------------------------------------------------------------------

Play_Sega:
		ld	de,SEGAPCM&$FFFF			; de = bank-relative location of the SEGA sound
		ld	hl,SEGAPCM_Len&$FFFF			; hl = size of the SEGA sound
		ld	c,2Ah					; c = DAC data register

.play:
		ld	a,(de)					; a = next byte of the SEGA PCM
		ld	(ix+0),c				; select the DAC data register (2Ah)
		ld	(ix+1),a				; send DAC value to YM

		ld	b,SEGAPCM_Pitch				; b = pitch of the SEGA sample
		djnz	*					; delay the z80 to allow for pitch variations

		inc	de					; go to the next byte in the sample
		dec	hl					; decrement the number of bytes left to play

		ld	a,l					; check if hl is 0
		or	h					; this does the actual check - if not, then a will be nonzero
		jp	nz,.play				; if hl is not 0, keep playing the sample
		jp	CheckForSamples				; SEGA sound is done; wait for new samples

; ---------------------------------------------------------------------------
; Table referencing the three PCM samples
;
; As documented by jman2050, first two bytes are a pointer to the sample,
; third and fourth are the sample size, fifth is the pitch, 6-8 are unused.
; ---------------------------------------------------------------------------

zsample:	macro	name, pitch
		dw \name
		dw \name\_End-\name
		dw \pitch
		dw 0000h
		endm

PCM_Table:
		zsample	dKick, 17h				; Kick sample
		zsample	dSnare, 1h				; Snare sample
		zsample	dTimpani, 1Bh				; Kick sample
Sample3_Pitch:	= *-4						; this is the location of timpani pitch

; ---------------------------------------------------------------------------
; Includes for all the samples
; ---------------------------------------------------------------------------

dKick:		incbin "sound/dac/kick.dpcm"
dKick_End:

dSnare:		incbin "sound/dac/snare.dpcm"
dSnare_End:

dTimpani:	incbin "sound/dac/timpani.dpcm"
dTimpani_End:
; ---------------------------------------------------------------------------

EndOfDriver:
		if *>z80_stack
		inform 2,"The sound driver, including samples, may at most be $\$z80_stack bytes, but is currently $\$* bytes in size."
		endc

		END
