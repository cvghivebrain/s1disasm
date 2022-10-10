		pusho						; save options
		opt	ae+					; enable auto evens
		
		
Z80_Space:			equ $1760				; space reserved for the DAC Driver. The DAC compressor may ask you to increase this value.

; ---------------------------------------------------------------------------
; Constants for track variables
; ---------------------------------------------------------------------------

			rsset 0
ch_Flags:		rs.b 1					; All tracks
ch_Type:		rs.b 1					; All tracks
ch_Tick:		rs.b 1					; All tracks
			rs.b 1					; unused
ch_Data:		rs.l 1					; All tracks (4 bytes)
			rs.w 0					; transpose and volume must come sequentially
ch_Transpose:		rs.b 1					; FM/PSG only (sometimes written to as a word, to include ch_Volume)
ch_Volume:		rs.b 1					; FM/PSG only
ch_Pan:			rs.b 1					; FM/DAC only
ch_Voice:		rs.b 0					; FM only
ch_VolEnvId:		rs.b 1					; PSG only
ch_VolEnvPos:		rs.b 1					; PSG only
ch_StackPtr:		rs.b 1					; All tracks
ch_Delay:		rs.b 1					; All tracks
ch_SavedDelay:		rs.b 1					; All tracks
ch_Sample:		rs.b 0					; DAC only
ch_Freq:		rs.w 1					; FM/PSG only (2 bytes)
ch_Gate:		rs.b 1					; FM/PSG only
ch_SavedGate:		rs.b 1					; FM/PSG only
ch_VibPtr:		rs.l 1					; FM/PSG only (4 bytes)
ch_VibDelay:		rs.b 1					; FM/PSG only
ch_VibSpeed:		rs.b 1					; FM/PSG only
ch_VibOff:		rs.b 1					; FM/PSG only
ch_VibSteps:		rs.b 1					; FM/PSG only
ch_VibFreq:		rs.w 1					; FM/PSG only (2 bytes)
ch_Detune:		rs.b 1					; FM/PSG only
ch_NoiseMode:		rs.b 0					; PSG only
ch_FeedbackAlgo:	rs.b 1					; FM only
ch_VoiceTable:		rs.l 1					; FM SFX only (4 bytes)
ch_LoopCounter:		rs.b 4					; All tracks (multiple bytes)
			rs.l 2					; stack data
ch_StackData:		rs.w 0					; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses ch_Size)
ch_Size:		rs.w 0					; the size of a single track

; ---------------------------------------------------------------------------
; Constants for channel flags (ch_Flags)
; ---------------------------------------------------------------------------

			rsset 0
chf_Pause:		rs.b 1					; if track is paused. Unused
chf_Rest:		rs.b 1					; if track is resting
chf_Mask:		rs.b 1					; if sfx is overriding channel
chf_Vib:		rs.b 1					; if vibrato is enabled
chf_Tie:		rs.b 1					; if tie flag is enabled
			rs.b 2					; unused
chf_Enable:		rs.b 1					; if channel is enabled. Must be bit 7!

; ---------------------------------------------------------------------------
; Constants for channel types (ch_Type)
; ---------------------------------------------------------------------------

tFM1:			equ 0					; FM1 channel type
tFM2:			equ 1					; FM2 channel type
tFM3:			equ 2					; FM3 channel type
tFM4:			equ 4					; FM4 channel type
tFM5:			equ 5					; FM5 channel type
tFM6:			equ 6					; FM6 channel type

tDAC:			equ 6					; DAC channel type

tPSG1:			equ $80					; PSG1 channel type
tPSG2:			equ $A0					; PSG2 channel type
tPSG3:			equ $C0					; PSG3 channel type
tPSG4:			equ $E0					; PSG4 channel type

; ---------------------------------------------------------------------------
; Constants for track variables
; ---------------------------------------------------------------------------

			rsset 0
v_backup_start:		rs.w 0
v_priority:		rs.b 1					; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
f_tempo_counter:	rs.b 1					; Counts down to zero; when zero, resets to next value and delays song by 1 frame
f_current_tempo:	rs.b 1					; Used for music only
f_pause_sound:		rs.b 1					; flag set to stop music when paused
v_fadeout_counter:	rs.b 1
			rs.b 1					; unused
v_fadeout_delay:	rs.b 1
v_timing:		rs.b 1					; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		rs.b 1					; $80 if updating DAC, $00 otherwise
v_sound_id:		rs.b 1					; sound or music copied from below
v_soundqueue_size:	equ 3					; number of sound queue slots. Slots beyond 0 and 1 are broken!
v_soundqueue:		rs.b v_soundqueue_size			; sound queue entries
			rs.b 1					; unused
v_channel_mode:		rs.b 1					; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer
			rs.b 9					; unused
v_music_voice_table:	rs.l 1					; voice data pointer (4 bytes)
			rs.b 4					; unused
v_back_voice_table:	rs.l 1					; voice data pointer for special SFX ($D0-$DF) (4 bytes)
f_fadein_flag:		rs.b 1					; Flag for fade in
v_fadein_delay:		rs.b 1
v_fadein_counter:	rs.b 1					; Timer for fade in/out
f_has_backup:		rs.b 1					; flag indicating 1-up song is playing
v_tempo_main:		rs.b 1					; music - tempo modifier
v_tempo_speed:		rs.b 1					; music - tempo modifier with speed shoes
f_speedup:		rs.b 1					; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		rs.b 1					; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		rs.b 1					; if set, prevents further push sounds from playing
			rs.b $12				; unused

v_music_ram:		rs.w 0					; Start of music RAM
v_music_FMDAC_RAM:	rs.w 0
v_music_DAC:		rs.b ch_Size
v_music_FM_RAM:		rs.w 0
v_music_FM1:		rs.b ch_Size
v_music_FM2:		rs.b ch_Size
v_music_FM3:		rs.b ch_Size
v_music_FM4:		rs.b ch_Size
v_music_FM5:		rs.b ch_Size
v_music_FM6:		rs.b ch_Size
v_music_FM_RAM_end:	rs.w 0
v_music_FMDAC_RAM_end:	rs.w 0
v_music_PSG_RAM:	rs.w 0
v_music_PSG1:		rs.b ch_Size
v_music_PSG2:		rs.b ch_Size
v_music_PSG3:		rs.b ch_Size
v_music_PSG_RAM_end:	rs.w 0
v_music_ram_end:	rs.w 0

v_sfx_ram:		rs.w 0					; Start of SFX RAM, straight after the end of music RAM
v_SFX_FM_RAM:		rs.w 0
v_SFX_FM3:		rs.b ch_Size
v_SFX_FM4:		rs.b ch_Size
v_SFX_FM5:		rs.b ch_Size
v_SFX_FM_RAM_end:	rs.w 0
v_SFX_PSG_RAM:		rs.w 0
v_SFX_PSG1:		rs.b ch_Size
v_SFX_PSG2:		rs.b ch_Size
v_SFX_PSG3:		rs.b ch_Size
v_SFX_PSG_RAM_end:	rs.w 0
v_sfx_ram_end:		rs.w 0

v_back_ram:		rs.w 0					; Start of background SFX RAM, straight after the end of SFX RAM
v_Back_FM4:		rs.b ch_Size
v_Back_PSG3:		rs.b ch_Size
v_back_ram_end:		rs.w 0

v_backup_ram:		rs.b v_music_ram_end-v_backup_start
v_snddriver_size:	rs.w 0					; size of the entire sound driver RAM

; ---------------------------------------------------------------------------
; Define FM frequency equates for a single octave
; ---------------------------------------------------------------------------

fmfq_B:		equ	606					; B
fmfq_C:		equ	644					; C
fmfq_Cs:	equ	683					; C#
fmfq_D:		equ	723					; D
fmfq_Ds:	equ	766					; D#
fmfq_E:		equ	813					; E
fmfq_F:		equ	860					; F
fmfq_Fs:	equ	911					; F#
fmfq_G:		equ	965					; G
fmfq_Gs:	equ	1023					; G#
fmfq_A:		equ	1084					; A
fmfq_As:	equ	1148					; A#
fmfq_B1:	equ	1216					; B1	; <- used in S3K, as opposed to fmfq_B. This one seems to be the correct behavior.

; ---------------------------------------------------------------------------
; Define note information
;
; Notes are tuned to where A4 = 440hz. Note that values are slightly off.
; Only sharp notes are defined; flats and sharps are often interchangeable,
; but for the sake of simplicity, only sharps are used here.
; By default, range from $80 to $DF. The first entries have lower ID.
; This special macro is used to generate constants and frequency tables.
;
; line format: \func	constant, psg frequency, fm frequency
; ---------------------------------------------------------------------------

DefineNotes:	macro	func
		\func	   ,	   , $0000|fmfq_B		; B-1 note (the fact that this entry exists seems like a bug)

		\func	nC0,	854, $0000|fmfq_C		; C0 note
		\func	nCs0,	806, $0000|fmfq_Cs		; C#0 note
		\func	nD0,	761, $0000|fmfq_D		; D0 note
		\func	nDs0,	718, $0000|fmfq_Ds		; D#0 note
		\func	nE0,	677, $0000|fmfq_E		; E0 note
		\func	nF0,	640, $0000|fmfq_F		; F0 note
		\func	nFs0,	604, $0000|fmfq_Fs		; F#0 note
		\func	nG0,	570, $0000|fmfq_G		; G0 note
		\func	nGs0,	538, $0000|fmfq_Gs		; G#0 note
		\func	nA0,	507, $0000|fmfq_A		; A0 note
		\func	nAs0,	479, $0000|fmfq_As		; A#0 note
		\func	nB0,	452, $0800|fmfq_B		; B0 note

		\func	nC1,	427, $0800|fmfq_C		; C1 note
		\func	nCs1,	403, $0800|fmfq_Cs		; C#1 note
		\func	nD1,	381, $0800|fmfq_D		; D1 note
		\func	nDs1,	359, $0800|fmfq_Ds		; D#1 note
		\func	nE1,	339, $0800|fmfq_E		; E1 note
		\func	nF1,	320, $0800|fmfq_F		; F1 note
		\func	nFs1,	302, $0800|fmfq_Fs		; F#1 note
		\func	nG1,	285, $0800|fmfq_G		; G1 note
		\func	nGs1,	269, $0800|fmfq_Gs		; G#1 note
		\func	nA1,	254, $0800|fmfq_A		; A1 note
		\func	nAs1,	239, $0800|fmfq_As		; A#1 note
		\func	nB1,	226, $1000|fmfq_B		; B1 note

		\func	nC2,	214, $1000|fmfq_C		; C2 note
		\func	nCs2,	201, $1000|fmfq_Cs		; C#2 note
		\func	nD2,	190, $1000|fmfq_D		; D2 note
		\func	nDs2,	180, $1000|fmfq_Ds		; D#2 note
		\func	nE2,	169, $1000|fmfq_E		; E2 note
		\func	nF2,	160, $1000|fmfq_F		; F2 note
		\func	nFs2,	151, $1000|fmfq_Fs		; F#2 note
		\func	nG2,	143, $1000|fmfq_G		; G2 note
		\func	nGs2,	135, $1000|fmfq_Gs		; G#2 note
		\func	nA2,	127, $1000|fmfq_A		; A2 note
		\func	nAs2,	120, $1000|fmfq_As		; A#2 note
		\func	nB2,	113, $1800|fmfq_B		; B2 note

		\func	nC3,	107, $1800|fmfq_C		; C3 note
		\func	nCs3,	101, $1800|fmfq_Cs		; C#3 note
		\func	nD3,	095, $1800|fmfq_D		; D3 note
		\func	nDs3,	090, $1800|fmfq_Ds		; D#3 note
		\func	nE3,	085, $1800|fmfq_E		; E3 note
		\func	nF3,	080, $1800|fmfq_F		; F3 note
		\func	nFs3,	075, $1800|fmfq_Fs		; F#3 note
		\func	nG3,	071, $1800|fmfq_G		; G3 note
		\func	nGs3,	067, $1800|fmfq_Gs		; G#3 note
		\func	nA3,	064, $1800|fmfq_A		; A3 note
		\func	nAs3,	060, $1800|fmfq_As		; A#3 note
		\func	nB3,	057, $2000|fmfq_B		; B3 note

		\func	nC4,	054, $2000|fmfq_C		; C4 note
		\func	nCs4,	051, $2000|fmfq_Cs		; C#4 note
		\func	nD4,	048, $2000|fmfq_D		; D4 note
		\func	nDs4,	045, $2000|fmfq_Ds		; D#4 note
		\func	nE4,	043, $2000|fmfq_E		; E4 note
		\func	nF4,	040, $2000|fmfq_F		; F4 note
		\func	nFs4,	038, $2000|fmfq_Fs		; F#4 note
		\func	nG4,	036, $2000|fmfq_G		; G4 note
		\func	nGs4,	034, $2000|fmfq_Gs		; G#4 note
		\func	nA4,	032, $2000|fmfq_A		; A4 note
		\func	nAs4,	031, $2000|fmfq_As		; A#4 note
		\func	nB4,	029, $2800|fmfq_B		; B4 note

		\func	nC5,	027, $2800|fmfq_C		; C5 note
		\func	nCs5,	026, $2800|fmfq_Cs		; C#5 note
		\func	nD5,	024, $2800|fmfq_D		; D5 note
		\func	nDs5,	023, $2800|fmfq_Ds		; D#5 note
		\func	nE5,	022, $2800|fmfq_E		; E5 note
		\func	nF5,	021, $2800|fmfq_F		; F5 note
		\func	nFs5,	019, $2800|fmfq_Fs		; F#5 note
		\func	nG5,	018, $2800|fmfq_G		; G5 note
		\func	nGs5,	017, $2800|fmfq_Gs		; G#5 note
		\func	nHiHat,    ,				; PSG hi-hat value
		\func	nA5,	000, $2800|fmfq_A		; A5 note
		\func	nAs5,	   , $2800|fmfq_As		; A#5 note
		\func	nB5,	   , $3000|fmfq_B		; B5 note

		\func	nC6,	   , $3000|fmfq_C		; C6 note
		\func	nCs6,	   , $3000|fmfq_Cs		; C#6 note
		\func	nD6,	   , $3000|fmfq_D		; D6 note
		\func	nDs6,	   , $3000|fmfq_Ds		; D#6 note
		\func	nE6,	   , $3000|fmfq_E		; E6 note
		\func	nF6,	   , $3000|fmfq_F		; F6 note
		\func	nFs6,	   , $3000|fmfq_Fs		; F#6 note
		\func	nG6,	   , $3000|fmfq_G		; G6 note
		\func	nGs6,	   , $3000|fmfq_Gs		; G#6 note
		\func	nA6,	   , $3000|fmfq_A		; A6 note
		\func	nAs6,	   , $3000|fmfq_As		; A#6 note
		\func	nB6,	   , $3800|fmfq_B		; B6 note

		\func	nC7,	   , $3800|fmfq_C		; C7 note
		\func	nCs7,	   , $3800|fmfq_Cs		; C#7 note
		\func	nD7,	   , $3800|fmfq_D		; D7 note
		\func	nDs7,	   , $3800|fmfq_Ds		; D#7 note
		\func	nE7,	   , $3800|fmfq_E		; E7 note
		\func	nF7,	   , $3800|fmfq_F		; F7 note
		\func	nFs7,	   , $3800|fmfq_Fs		; F#7 note
		\func	nG7,	   , $3800|fmfq_G		; G7 note
		\func	nGs7,	   , $3800|fmfq_Gs		; G#7 note
		\func	nA7,	   , $3800|fmfq_A		; A7 note
		\func	nAs7,	   , $3800|fmfq_As		; A#7 note
		endm

; ---------------------------------------------------------------------------
; Constants for notes in the sound driver
; ---------------------------------------------------------------------------

GenNoteConst:	macro	const, psgfq, fmfq
		if strlen("\const")>0
		if strlen("\fmfq")>0
\const:		rs.b 1						; normal equate
		else
\const:		rs.b 0						; alt name for a note
		endc
		endc
		endm
; ---------------------------------------------------------------------------

		rsset $80
nR:		rs.b 1						; rest note - stop sounds for current channel
_firstNote:	rs.b 0						; the first actual note
		DefineNotes	GenNoteConst			; generate note constants
_lastNote:	equ __rs-1					; the last note

; ---------------------------------------------------------------------------
; Define samples
;
; By default, range from $81 to $8F
; The first entries have lower ID.
; Constants for IDs are: d(name)
; This special macro is used to generate constants and jump tables
;
; line format: \func	name, alt1, alt2 [...]
; ---------------------------------------------------------------------------

DefineSamples:	macro	func
		\func	Kick					; Kick sample
		\func	Snare					; Snare sample
		\func	Timpani					; Timpani sample (DO NOT USE)
		\func	Null84					; this sample is not defined
		\func	Null85					; this sample is not defined
		\func	Null86					; this sample is not defined
		\func	Null87					; this sample is not defined
		\func	TimpaniHi				; Timpani high pitch
		\func	TimpaniMid				; Timpani middle pitch
		\func	TimpaniLow				; Timpani low pitch
		\func	TimpaniFloor				; Timpani very low pitch
		endm

; ---------------------------------------------------------------------------
; Constants for envelopes
; ---------------------------------------------------------------------------

GenSampleConst:	macro	const
		rept narg-1
d\const:	rs.b 0						; generate alt constants
		shift
		endr

d\const:	rs.b 1						; generate the main constant
		endm
; ---------------------------------------------------------------------------

		rsset	nR+1					; samples start at $81
_firstSample:	rs.b 0						; the first valid sample
		DefineSamples	GenSampleConst			; generate constants for samples
_lastSample:	equ __rs-1					; the last valid sample

; ---------------------------------------------------------------------------
; Define track commands
;
; By default, range from $E0 to $FF, and $FF can have special flags.
; The first entries have lower ID.
; Constants for IDs are: com_(name)
; This special macro is used to generate constants and jump tables
;
; line format: \func	name, alt1, alt2 [...]
; ---------------------------------------------------------------------------

TrackCommand:	macro	func
		\func	Pan					; Pan FM channel (left/right/centre)
		\func	DetuneSet				; Detune a channel (change frequency)
		\func	Timing					; External song timing
		\func	Ret					; Subroutine return
		\func	RestoreSong				; Restore previous song
		\func	ChannelTick				; Set tick multiplier for channel
		\func	VolAddFM				; FM volume add
		\func	Tie, Hold				; Do not key off. Can be used to tie two notes together (extend delay, run commands, set new note, etc)
		\func	Gate					; Set note gate timer (frames)
		\func	TransAdd				; Transposition add
		\func	TempoSet				; Set tempo (affected by tick multiplier!)
		\func	SongTick				; Set tick multiplier for song
		\func	VolAddPSG				; PSG volume add
		\func	ClearPush				; Clear special push sound effect flag
		\func	EndBack					; End background sound effect channel
		\func	Voice					; Load FM voice
		\func	Vib					; Set automatic vibrate
		\func	VibOn					; Enable automatic vibrate (without parameter set)
		\func	End					; End a song channel
		\func	NoiseSet				; Set PSG4 noise mode
		\func	VibOff					; Disable automatic vibrate (parameters preserved)
		\func	Env					; Set volume envelope (PSG only)
		\func	Jump					; Jump to song routine
		\func	Loop					; Loop song data
		\func	Call					; Call song subroutine
		\func	Release34				; Hacky command to immediately release ops 3 and 4. Used in SYZ music only
		endm

TrackExCommand:	macro	func
		; Sonic 1 has no extended commands
		endm

; ---------------------------------------------------------------------------
; Constants for tracker commands
; ---------------------------------------------------------------------------

GenComConst:	macro	const
		rept narg-1
com_\const:	rs.b 0						; generate alt constants
		shift
		endr

com_\const:	rs.b 1						; generate the main constant
		endm
; ---------------------------------------------------------------------------

		rsset	_lastNote+1				; commands come after the last note
_firstCom:	rs.b 0						; the first valid command
		TrackCommand	GenComConst			; generate constants for all main commands
_lastCom:	equ __rs-1					; the last valid command

		rsset	__rs<<8					; assume the last command is the extended command (in Sonic 1, there is no extended commands!)
_firstExCom:	equ __rs&$FF					; the first valid extended command
		TrackExCommand	GenComConst			; generate constants for all extended commands
_lastExCom:	equ (__rs-1)&$FF				; the last valid extended command

; ---------------------------------------------------------------------------
; Define envelopes
;
; By default, range from $01 to $FF
; The first entries have lower ID.
; Constants for IDs are: v(name)
; This special macro is used to generate constants and jump tables
;
; line format: \func	name, alt1, alt2 [...]
; ---------------------------------------------------------------------------

VolumeEnv:	macro	func
		\func	01					; TODO: name
		\func	02					; TODO: name
		\func	03					; TODO: name
		\func	04					; TODO: name
		\func	05					; TODO: name
		\func	06					; TODO: name
		\func	07					; TODO: name
		\func	08					; TODO: name
		\func	09					; TODO: name
		endm

; ---------------------------------------------------------------------------
; Constants for envelopes
; ---------------------------------------------------------------------------

GenEnvConst:	macro	const
		rept narg-1
env_\const:	rs.b 0						; generate alt constants
		shift
		endr

env_\const:	rs.b 1				; generate the main constant
		endm
; ---------------------------------------------------------------------------

		rsset	0					; envelopes start at 1
env_None:	rs.b 1						; null envelope
_firstVolEnv:	rs.b 0						; the first valid envelope
		VolumeEnv	GenEnvConst			; generate constants for envelopes
_lastVolEnv:	equ __rs-1					; the last valid envelope

; ---------------------------------------------------------------------------
; Define envelope commands
;
; By default, starts at $80
; The first entries have lower ID.
; Constants for IDs are: evc_(name)
; This special macro is used to generate constants and jump tables
;
; line format: \func	name, alt1, alt2 [...]
; ---------------------------------------------------------------------------

EnvelopeCmd:	macro	func
		\func	Hold					; hold envelope at the last byte
		endm

; ===========================================================================
; ---------------------------------------------------------------------------
; constants for envelope commands
; ---------------------------------------------------------------------------

GenEnvCmdConst:	macro	const
		rept narg-1
evc\const:	rs.b 0						; generate alt constants
		shift
		endr

evc\const:	rs.b 1						; generate the main constant
		endm
; ---------------------------------------------------------------------------

		rsset	$80					; envelope commands start at $80
_firstEnvCmd:	rs.b 0						; the first valid envelope command
		EnvelopeCmd	GenEnvCmdConst			; generate constants for envelope commands
_lastEnvCmd:	equ __rs-1					; the last valid envelope command

; ---------------------------------------------------------------------------
; Constants for sound IDs
; ---------------------------------------------------------------------------

; Background music
		rsset $80					; ID of the first music file
com_Null:	rs.b 1						; empty sound
_firstMusic:	rs.b 0						; constant for the first music

GenMusicConst:	macro	name
mus_\name:	rs.b 1						; use the next ID for music
		endm

		MusicFiles	GenMusicConst			; generate constants for each music file
_lastMusic:	equ __rs-1					; constant for the last music
; ---------------------------------------------------------------------------

; Sound effects
		rsset $A0					; ID of the first sfx file
_firstSfx:	rs.b 0						; constant for the first sfx

GenSfxConst:	macro	name
sfx_\name:	rs.b 1						; use the next ID for sfx
		endm

		SfxFiles	GenSfxConst			; generate constants for each sfx file
_lastSfx:	equ __rs-1					; constant for the last sfx

; ---------------------------------------------------------------------------

; Background sound effects
		rsset $D0					; ID of the first special sfx file
_firstSpecSfx:	rs.b 0						; constant for the first special sfx

		SpecSfxFiles	GenSfxConst			; generate constants for each special sfx file
_lastSpecSfx:	equ __rs-1					; constant for the last special sfx
; ---------------------------------------------------------------------------

; Sound commands
		rsset $E0					; ID of the first command
_firstCmd:	rs.b 0						; constant for the first command

GenCmdConst:	macro	name
cmd_\name:	rs.b 1						; use the next ID for command
		endm

		DriverCmdFiles	GenCmdConst			; generate constants for each command
_lastCmd:	equ __rs-1					; constant for the last command

; ---------------------------------------------------------------------------

		popo						; restore options
