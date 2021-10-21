; ---------------------------------------------------------------------------
; Sound (68K) By H.Kubota
; Modified to remove features and optimize some code
; (also known as SMPS 68k Type 1b)
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Address Table
; ---------------------------------------------------------------------------

Go_SoundPriorities:	dc.l SoundPriorities
Go_SpecSoundIndex:	dc.l SpecSoundIndex
Go_MusicIndex:		dc.l MusicIndex
Go_SoundIndex:		dc.l SoundIndex
Go_SpeedUpIndex:	dc.l SpeedUpIndex
Go_Envelopes:		dc.l Envelopes

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelope table
; ---------------------------------------------------------------------------

Envelopes:
		dc.l ve1, ve2, ve3, ve4
		dc.l ve5, ve6, ve7, ve8
		dc.l ve9

ve1:		incbin	"sound/psg/psg1.bin"
ve2:		incbin	"sound/psg/psg2.bin"
ve3:		incbin	"sound/psg/psg3.bin"
ve4:		incbin	"sound/psg/psg4.bin"
ve6:		incbin	"sound/psg/psg6.bin"
ve5:		incbin	"sound/psg/psg5.bin"
ve7:		incbin	"sound/psg/psg7.bin"
ve8:		incbin	"sound/psg/psg8.bin"
ve9:		incbin	"sound/psg/psg9.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Speed shoes tempo list.
; Overrides normal tempo value for the duration of speed shoes.
; ---------------------------------------------------------------------------
; DANGER! several songs will use the first few bytes of MusicIndex as their main
; tempos while speed shoes are active. If you don't want that, you should add
; their "correct" sped-up main tempos to the list, in "sound/Sounds.asm"!

GenSpeedup	macro	name, priority, tempo
	if strlen("\tempo")>0				; checks if \tempo was given a value
		dc.b \tempo
	endc
		endm

SpeedUpIndex:
		MusicFiles	GenSpeedup		; generate the speed shoes tempo list

; ===========================================================================
; ---------------------------------------------------------------------------
; song address table
; ---------------------------------------------------------------------------

GenMusicTable	macro	name
		dc.l musfile_\name			; create a pointer for every music file
		endm

MusicIndex:
		MusicFiles	GenMusicTable		; generate pointers for all the files

; ===========================================================================
; ---------------------------------------------------------------------------
; priority table
;
; New music or SFX must have a priority higher than or equal to what is
; stored in v_sndprio or it won't play. If bit 7 of new priority is set
; ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; ---------------------------------------------------------------------------

GenPriority	macro	name, priority
		dc.b \priority
		endm

SoundPriorities:
		MusicFiles	GenPriority		; generate priorities for all music
		dcb.b _firstSfx-_lastMusic-1, $90	; dummy entries for music entries that are not defined
		SfxFiles	GenPriority		; generate priorities for all sfx
		dcb.b _firstSpecSfx-_lastSfx-1, $80	; dummy entries for sfx entries that are not defined
		SpecSfxFiles	GenPriority		; generate priorities for all special sfx
		dcb.b _firstCmd-_lastSpecSfx-1, $80	; dummy entries for special sfx entries that are not defined
		DriverCmdFiles	GenPriority		; generate priorities for all commands

; ===========================================================================
; ---------------------------------------------------------------------------
; include the actual sound driver program
; ---------------------------------------------------------------------------

UpdateSound:	include "sound/Sound Driver.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; patch and include the kosinski compressed DAC driver
; ---------------------------------------------------------------------------

Kos_DacDriver:		; TODO: this is currently hardcoded to replace the dummy pointers and values with actual values. we should find a way to not hardcode this
		incbin	"sound\DAC Driver.kos", 0, $15
		dc.b ((SegaPCM&$FF8000)/$8000)&1		; Least bit of bank ID (bit 15 of address)
		incbin	"sound\DAC Driver.kos", $16, 6
		dc.b ((SegaPCM&$FF8000)/$8000)>>1		; ... the remaining bits of bank ID (bits 16-23)
		incbin	"sound\DAC Driver.kos", $1D, $93
		dc.b SegaPCM&$FF, ((SegaPCM&$7F00)>>8)|$80	; Pointer to Sega PCM, relative to start of ROM bank (little endian)
		incbin	"sound\DAC Driver.kos", $B2, 1

@size:		equ	filesize("\SegaPCM_File")		; calculate the size of the Sega PCM
		dc.b @size&$FF, (@size&$FF00)>>8		; ... the size of the Sega PCM (little endian)
		incbin	"sound\DAC Driver.kos", $B5, $16AB
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; music file includes
; ---------------------------------------------------------------------------

IncludeMusic	macro	name
musfile_\name	incbin "sound/music/\name\.dat"		; include the music file itself
		even					; next file must be aligned to word
		endm

		MusicFiles	IncludeMusic		; generate includes for all the files
; ===========================================================================
; ---------------------------------------------------------------------------
; sfx pointer list
; ---------------------------------------------------------------------------

GenSfxTable	macro	name
		dc.l sfxfile_\name			; create a pointer for every sfx file
		endm

SoundIndex:
		SfxFiles	GenSfxTable		; generate pointers for all the sfx

; ===========================================================================
; ---------------------------------------------------------------------------
; special sfx pointer list
; ---------------------------------------------------------------------------

SpecSoundIndex:
		SpecSfxFiles	GenSfxTable		; generate pointers for all the special sfx

; ===========================================================================
; ---------------------------------------------------------------------------
; sfx includes
; ---------------------------------------------------------------------------

IncludeSfx	macro	name
sfxfile_\name	incbin "sound/sfx/\name\.dat"		; include the sfx file itself
		even					; next file must be aligned to word
		endm

		SfxFiles	IncludeSfx		; generate includes for all the files

; ===========================================================================
; ---------------------------------------------------------------------------
; special sfx includes
; ---------------------------------------------------------------------------

		SpecSfxFiles	IncludeSfx		; generate includes for all the files

; ===========================================================================
; ---------------------------------------------------------------------------
; SEGA PCM include
;
; To change the file that is included, go to "Sound Equates.asm"!
; ---------------------------------------------------------------------------

		; check that SEGA PCM is not larger than a z80 bank
		if filesize("\SegaPCM_File") > $8000
			inform 3,"Sega sound must fit within $8000 bytes, but its size is $%h bytes.", filesize("\SegaPCM_File")
		endc

		; Don't let Sega sample cross $8000-byte boundary (DAC driver doesn't switch banks automatically)
		if (*&$7FFF) + filesize("\SegaPCM_File") > $8000
			align $8000
		endif
; ---------------------------------------------------------------------------

SegaPCM:	incbin	"\SegaPCM_File"			; include the actual Sega PCM data
		even
