; ---------------------------------------------------------------------------
; Sound (68K) By H.Kubota
; Modified to remove features and optimize some code
; (also known as SMPS 68k Type 1b)
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; include song language macros
; ---------------------------------------------------------------------------

		include "sound/Sound Language.asm"

; ---------------------------------------------------------------------------
; Address Table
; ---------------------------------------------------------------------------

Go_SoundPriorities:	dc.l SoundPriorities
Go_SpecSoundIndex:	dc.l SpecSoundIndex
Go_MusicIndex:		dc.l MusicIndex
Go_SoundIndex:		dc.l SoundIndex
Go_SpeedUpIndex:	dc.l SpeedUpIndex
Go_Envelopes:		dc.l Envelopes

; ---------------------------------------------------------------------------
; Envelope pointer list
; ---------------------------------------------------------------------------

GenEnvTable:	macro	name
		dc.l envdata_\name				; create a pointer for every envelope
		endm

Envelopes:
		VolumeEnv	GenEnvTable			; generate pointers for all the envelopes

; ---------------------------------------------------------------------------
; Envelope includes
; ---------------------------------------------------------------------------

envdata_01:
		dcb.b $03, $00
		dcb.b $03, $01
		dcb.b $03, $02
		dcb.b $03, $03
		dcb.b $03, $04
		dcb.b $03, $05
		dcb.b $03, $06
		dc.b $07, evcHold

envdata_02:
		dc.b $00, $02, $04, $06, $08, $10, evcHold

envdata_03:
		dc.b $00, $00, $01, $01, $02, $02, $03, $03
		dc.b $04, $04, $05, $05, $06, $06, $07, $07
		dc.b evcHold

envdata_04:
		dc.b $00, $00, $02, $03, $04, $04, $05, $05
		dc.b $05, $06, evcHold

envdata_06:
		dc.b $03, $03, $03, $02, $02, $02, $02, $01
		dc.b $01, $01, $00, $00, $00, $00, evcHold

envdata_05:
		dcb.b $0A, $00
		dcb.b $0E, $01
		dcb.b $08, $02
		dcb.b $08, $03
		dc.b $04, evcHold

envdata_07:
		dcb.b $06, $00
		dcb.b $05, $01
		dcb.b $05, $02
		dcb.b $03, $03
		dcb.b $03, $04
		dcb.b $03, $05
		dc.b $06, $07, evcHold

envdata_08:
		dcb.b $05, $00
		dcb.b $05, $01
		dcb.b $06, $02
		dcb.b $05, $03
		dcb.b $05, $04
		dcb.b $05, $05
		dcb.b $05, $06
		dcb.b $03, $07
		dc.b evcHold

envdata_09:
		dc.b $00, $01, $02, $03, $04, $05, $06, $07
		dc.b $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
		dc.b evcHold

		even

; ---------------------------------------------------------------------------
; Speed shoes tempo list.
; Overrides normal tempo value for the duration of speed shoes.
; ---------------------------------------------------------------------------
; DANGER! several songs will use the first few bytes of MusicIndex as their main
; tempos while speed shoes are active. If you don't want that, you should add
; their "correct" sped-up main tempos to the list, in "sound/Sounds.asm"!

GenSpeedup:	macro	name, priority, tempo
		if strlen("\tempo")>0				; checks if \tempo was given a value
		dc.b \tempo
		endc
		endm

SpeedUpIndex:
		MusicFiles	GenSpeedup			; generate the speed shoes tempo list

; ---------------------------------------------------------------------------
; Song address table
; ---------------------------------------------------------------------------

GenMusicTable:	macro	name
		dc.l musfile_\name				; create a pointer for every music file
		endm

MusicIndex:
		MusicFiles	GenMusicTable			; generate pointers for all the files

; ---------------------------------------------------------------------------
; Priority table
;
; New music or SFX must have a priority higher than or equal to what is
; stored in v_sndprio or it won't play. If bit 7 of new priority is set
; ($80 and up), the new music or SFX will not set its priority -- meaning
; any music or SFX can override it (as long as it can override whatever was
; playing before). Usually, SFX will only override SFX, special SFX ($D0-$DF)
; will only override special SFX and music will only override music.
; ---------------------------------------------------------------------------

GenPriority:	macro	name, priority
		dc.b \priority
		endm

SoundPriorities:
		MusicFiles	GenPriority			; generate priorities for all music
		dcb.b _firstSfx-_lastMusic-1, $90		; dummy entries for music entries that are not defined
		SfxFiles	GenPriority			; generate priorities for all sfx
		dcb.b _firstSpecSfx-_lastSfx-1, $80		; dummy entries for sfx entries that are not defined
		SpecSfxFiles	GenPriority			; generate priorities for all special sfx
		dcb.b _firstCmd-_lastSpecSfx-1, $80		; dummy entries for special sfx entries that are not defined
		DriverCmdFiles	GenPriority			; generate priorities for all commands

; ---------------------------------------------------------------------------
; Include the actual sound driver program
; ---------------------------------------------------------------------------

		include "sound/Sound Driver.asm"

; ---------------------------------------------------------------------------
; Patch and include the kosinski compressed DAC driver
; ---------------------------------------------------------------------------

DACDriver:
		pushs				; store section information for Main
DACZ80:	section	org(0), file("sound/DAC Driver.unc") ; create new section for the sound driver
		cpu Z80
		include "sound/DAC Driver.asm"	; include the actual DAC driver
		
		cpu 68000
		pops 							; go back to the main section
		pushs	

MergeCode:	section org(0), file("sound/DAC Driver Offset & Size.dat")	; create settings file for storing info about how to merge things
		dc.l offset(DACDriver),Z80_Space		; store info about location of file and size available
		pops									; go back to main section

		ds.b Z80_Space							; reserve space for the compressed sound driver
		even
		
; ---------------------------------------------------------------------------
; Music file includes
; ---------------------------------------------------------------------------

_song: =		-1					; used to track song stats

IncludeMusic:	macro	name
musfile_\name:	include	"sound/music/\name\.s"			; include the music file itself
		even						; next file must be aligned to word
		endm

		MusicFiles	IncludeMusic			; generate includes for all the files

; ---------------------------------------------------------------------------
; Sfx pointer list
; ---------------------------------------------------------------------------

GenSfxTable:	macro	name
		dc.l sfxfile_\name				; create a pointer for every sfx file
		endm

SoundIndex:
		SfxFiles	GenSfxTable			; generate pointers for all the sfx

; ---------------------------------------------------------------------------
; Special sfx pointer list
; ---------------------------------------------------------------------------

SpecSoundIndex:
		SpecSfxFiles	GenSfxTable			; generate pointers for all the special sfx

; ---------------------------------------------------------------------------
; Sfx includes
; ---------------------------------------------------------------------------

IncludeSfx:	macro	name
sfxfile_\name:	include	"sound/sfx/\name\.s"			; include the sfx file itself
		even						; next file must be aligned to word
		endm

		SfxFiles	IncludeSfx			; generate includes for all the files

; ---------------------------------------------------------------------------
; Special sfx includes
; ---------------------------------------------------------------------------

		SpecSfxFiles	IncludeSfx			; generate includes for all the files

; ---------------------------------------------------------------------------
; SEGA PCM include
;
; To change the file that is included, go to "Sound Equates.asm"!
; ---------------------------------------------------------------------------

		; check that SEGA PCM is not larger than a z80 bank
		if sizeof_SegaPCM > $8000
		inform 3,"Sega sound must fit within $8000 bytes, but its size is $%h bytes.", sizeof_SegaPCM
		endc

		; Don't let Sega sample cross $8000-byte boundary (DAC driver doesn't switch banks automatically)
		if (offset(*)&$7FFF) + sizeof_SegaPCM > $8000
		align $8000
		endc
; ---------------------------------------------------------------------------

		incfile	SegaPCM					; include the actual Sega PCM data
