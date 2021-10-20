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
; their "correct" sped-up main tempos to the list.

SpeedUpIndex:
		dc.b 7		; GHZ
		dc.b $72	; LZ
		dc.b $73	; MZ
		dc.b $26	; SLZ
		dc.b $15	; SYZ
		dc.b 8		; SBZ
		dc.b $FF	; Invincibility
		dc.b 5		; Extra Life
		;dc.b ?		; Special Stage
		;dc.b ?		; Title Screen
		;dc.b ?		; Ending
		;dc.b ?		; Boss
		;dc.b ?		; FZ
		;dc.b ?		; Sonic Got Through
		;dc.b ?		; Game Over
		;dc.b ?		; Continue Screen
		;dc.b ?		; Credits
		;dc.b ?		; Drowning
		;dc.b ?		; Get Emerald

; ===========================================================================
; ---------------------------------------------------------------------------
; song address table
; ---------------------------------------------------------------------------

MusicIndex:
ptr_mus81:	dc.l Music81
ptr_mus82:	dc.l Music82
ptr_mus83:	dc.l Music83
ptr_mus84:	dc.l Music84
ptr_mus85:	dc.l Music85
ptr_mus86:	dc.l Music86
ptr_mus87:	dc.l Music87
ptr_mus88:	dc.l Music88
ptr_mus89:	dc.l Music89
ptr_mus8A:	dc.l Music8A
ptr_mus8B:	dc.l Music8B
ptr_mus8C:	dc.l Music8C
ptr_mus8D:	dc.l Music8D
ptr_mus8E:	dc.l Music8E
ptr_mus8F:	dc.l Music8F
ptr_mus90:	dc.l Music90
ptr_mus91:	dc.l Music91
ptr_mus92:	dc.l Music92
ptr_mus93:	dc.l Music93
ptr_musend

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

SoundPriorities:
		dc.b     $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90	; $81
		dc.b $90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90,$90	; $90
		dc.b $80,$70,$70,$70,$70,$70,$70,$70,$70,$70,$68,$70,$70,$70,$60,$70	; $A0
		dc.b $70,$60,$70,$60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$7F	; $B0
		dc.b $60,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70	; $C0
		dc.b $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80	; $D0
		dc.b $90,$90,$90,$90,$90                                            	; $E0

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

@size:		equ	filesize("\SegaPCM_File")		; calculae the size of the Sega PCM
		dc.b @size&$FF, (@size&$FF00)>>8		; ... the size of the Sega PCM (little endian)
		incbin	"sound\DAC Driver.kos", $B5, $16AB
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; music file includes
; ---------------------------------------------------------------------------

Music81:	incbin	"sound/music/Mus81 - GHZ.bin"
		even
Music82:	incbin	"sound/music/Mus82 - LZ.bin"
		even
Music83:	incbin	"sound/music/Mus83 - MZ.bin"
		even
Music84:	incbin	"sound/music/Mus84 - SLZ.bin"
		even
Music85:	incbin	"sound/music/Mus85 - SYZ.bin"
		even
Music86:	incbin	"sound/music/Mus86 - SBZ.bin"
		even
Music87:	incbin	"sound/music/Mus87 - Invincibility.bin"
		even
Music88:	incbin	"sound/music/Mus88 - Extra Life.bin"
		even
Music89:	incbin	"sound/music/Mus89 - Special Stage.bin"
		even
Music8A:	incbin	"sound/music/Mus8A - Title Screen.bin"
		even
Music8B:	incbin	"sound/music/Mus8B - Ending.bin"
		even
Music8C:	incbin	"sound/music/Mus8C - Boss.bin"
		even
Music8D:	incbin	"sound/music/Mus8D - FZ.bin"
		even
Music8E:	incbin	"sound/music/Mus8E - Sonic Got Through.bin"
		even
Music8F:	incbin	"sound/music/Mus8F - Game Over.bin"
		even
Music90:	incbin	"sound/music/Mus90 - Continue Screen.bin"
		even
Music91:	incbin	"sound/music/Mus91 - Credits.bin"
		even
Music92:	incbin	"sound/music/Mus92 - Drowning.bin"
		even
Music93:	incbin	"sound/music/Mus93 - Get Emerald.bin"
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; sfx pointer list
; ---------------------------------------------------------------------------

SoundIndex:
ptr_sndA0:	dc.l SoundA0
ptr_sndA1:	dc.l SoundA1
ptr_sndA2:	dc.l SoundA2
ptr_sndA3:	dc.l SoundA3
ptr_sndA4:	dc.l SoundA4
ptr_sndA5:	dc.l SoundA5
ptr_sndA6:	dc.l SoundA6
ptr_sndA7:	dc.l SoundA7
ptr_sndA8:	dc.l SoundA8
ptr_sndA9:	dc.l SoundA9
ptr_sndAA:	dc.l SoundAA
ptr_sndAB:	dc.l SoundAB
ptr_sndAC:	dc.l SoundAC
ptr_sndAD:	dc.l SoundAD
ptr_sndAE:	dc.l SoundAE
ptr_sndAF:	dc.l SoundAF
ptr_sndB0:	dc.l SoundB0
ptr_sndB1:	dc.l SoundB1
ptr_sndB2:	dc.l SoundB2
ptr_sndB3:	dc.l SoundB3
ptr_sndB4:	dc.l SoundB4
ptr_sndB5:	dc.l SoundB5
ptr_sndB6:	dc.l SoundB6
ptr_sndB7:	dc.l SoundB7
ptr_sndB8:	dc.l SoundB8
ptr_sndB9:	dc.l SoundB9
ptr_sndBA:	dc.l SoundBA
ptr_sndBB:	dc.l SoundBB
ptr_sndBC:	dc.l SoundBC
ptr_sndBD:	dc.l SoundBD
ptr_sndBE:	dc.l SoundBE
ptr_sndBF:	dc.l SoundBF
ptr_sndC0:	dc.l SoundC0
ptr_sndC1:	dc.l SoundC1
ptr_sndC2:	dc.l SoundC2
ptr_sndC3:	dc.l SoundC3
ptr_sndC4:	dc.l SoundC4
ptr_sndC5:	dc.l SoundC5
ptr_sndC6:	dc.l SoundC6
ptr_sndC7:	dc.l SoundC7
ptr_sndC8:	dc.l SoundC8
ptr_sndC9:	dc.l SoundC9
ptr_sndCA:	dc.l SoundCA
ptr_sndCB:	dc.l SoundCB
ptr_sndCC:	dc.l SoundCC
ptr_sndCD:	dc.l SoundCD
ptr_sndCE:	dc.l SoundCE
ptr_sndCF:	dc.l SoundCF
ptr_sndend

; ===========================================================================
; ---------------------------------------------------------------------------
; special sfx pointer list
; ---------------------------------------------------------------------------

SpecSoundIndex:
ptr_sndD0:	dc.l SoundD0
ptr_specend

; ===========================================================================
; ---------------------------------------------------------------------------
; sfx includes
; ---------------------------------------------------------------------------

SoundA0:	incbin	"sound/sfx/SndA0 - Jump.bin"
		even
SoundA1:	incbin	"sound/sfx/SndA1 - Lamppost.bin"
		even
SoundA2:	incbin	"sound/sfx/SndA2.bin"
		even
SoundA3:	incbin	"sound/sfx/SndA3 - Death.bin"
		even
SoundA4:	incbin	"sound/sfx/SndA4 - Skid.bin"
		even
SoundA5:	incbin	"sound/sfx/SndA5.bin"
		even
SoundA6:	incbin	"sound/sfx/SndA6 - Hit Spikes.bin"
		even
SoundA7:	incbin	"sound/sfx/SndA7 - Push Block.bin"
		even
SoundA8:	incbin	"sound/sfx/SndA8 - SS Goal.bin"
		even
SoundA9:	incbin	"sound/sfx/SndA9 - SS Item.bin"
		even
SoundAA:	incbin	"sound/sfx/SndAA - Splash.bin"
		even
SoundAB:	incbin	"sound/sfx/SndAB.bin"
		even
SoundAC:	incbin	"sound/sfx/SndAC - Hit Boss.bin"
		even
SoundAD:	incbin	"sound/sfx/SndAD - Get Bubble.bin"
		even
SoundAE:	incbin	"sound/sfx/SndAE - Fireball.bin"
		even
SoundAF:	incbin	"sound/sfx/SndAF - Shield.bin"
		even
SoundB0:	incbin	"sound/sfx/SndB0 - Saw.bin"
		even
SoundB1:	incbin	"sound/sfx/SndB1 - Electric.bin"
		even
SoundB2:	incbin	"sound/sfx/SndB2 - Drown Death.bin"
		even
SoundB3:	incbin	"sound/sfx/SndB3 - Flamethrower.bin"
		even
SoundB4:	incbin	"sound/sfx/SndB4 - Bumper.bin"
		even
SoundB5:	incbin	"sound/sfx/SndB5 - Ring.bin"
		even
SoundB6:	incbin	"sound/sfx/SndB6 - Spikes Move.bin"
		even
SoundB7:	incbin	"sound/sfx/SndB7 - Rumbling.bin"
		even
SoundB8:	incbin	"sound/sfx/SndB8.bin"
		even
SoundB9:	incbin	"sound/sfx/SndB9 - Collapse.bin"
		even
SoundBA:	incbin	"sound/sfx/SndBA - SS Glass.bin"
		even
SoundBB:	incbin	"sound/sfx/SndBB - Door.bin"
		even
SoundBC:	incbin	"sound/sfx/SndBC - Teleport.bin"
		even
SoundBD:	incbin	"sound/sfx/SndBD - ChainStomp.bin"
		even
SoundBE:	incbin	"sound/sfx/SndBE - Roll.bin"
		even
SoundBF:	incbin	"sound/sfx/SndBF - Get Continue.bin"
		even
SoundC0:	incbin	"sound/sfx/SndC0 - Basaran Flap.bin"
		even
SoundC1:	incbin	"sound/sfx/SndC1 - Break Item.bin"
		even
SoundC2:	incbin	"sound/sfx/SndC2 - Drown Warning.bin"
		even
SoundC3:	incbin	"sound/sfx/SndC3 - Giant Ring.bin"
		even
SoundC4:	incbin	"sound/sfx/SndC4 - Bomb.bin"
		even
SoundC5:	incbin	"sound/sfx/SndC5 - Cash Register.bin"
		even
SoundC6:	incbin	"sound/sfx/SndC6 - Ring Loss.bin"
		even
SoundC7:	incbin	"sound/sfx/SndC7 - Chain Rising.bin"
		even
SoundC8:	incbin	"sound/sfx/SndC8 - Burning.bin"
		even
SoundC9:	incbin	"sound/sfx/SndC9 - Hidden Bonus.bin"
		even
SoundCA:	incbin	"sound/sfx/SndCA - Enter SS.bin"
		even
SoundCB:	incbin	"sound/sfx/SndCB - Wall Smash.bin"
		even
SoundCC:	incbin	"sound/sfx/SndCC - Spring.bin"
		even
SoundCD:	incbin	"sound/sfx/SndCD - Switch.bin"
		even
SoundCE:	incbin	"sound/sfx/SndCE - Ring Left Speaker.bin"
		even
SoundCF:	incbin	"sound/sfx/SndCF - Signpost.bin"
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; special sfx includes
; ---------------------------------------------------------------------------

SoundD0:	incbin	"sound/sfx/SndD0 - Waterfall.bin"
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; SEGA PCM include
;
; To change the file that is included, go to "Sound Equates.asm"!
; ---------------------------------------------------------------------------

		; check that SEGA PCM is not larger than a z80 bank
		if filesize("\SegaPCM_File") > $8000
			inform 3,"Sega sound must fit within $8000 bytes, but you have a $%h byte Sega sound.",SegaPCM_End-SegaPCM
		endc

		; Don't let Sega sample cross $8000-byte boundary (DAC driver doesn't switch banks automatically)
		if (*&$7FFF) + filesize("\SegaPCM_File") > $8000
			align $8000
		endif
; ---------------------------------------------------------------------------

SegaPCM:	incbin	"\SegaPCM_File"			; include the actual Sega PCM data
		even
