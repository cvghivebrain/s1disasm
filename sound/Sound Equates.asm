SegaPCM_File:	equs	"sound/dac/sega.pcm"		; the actual file location of the Sega PCM file. Used a few times below
		pusho					; save options
		opt	ae+				; enable auto evens

; ===========================================================================
; ---------------------------------------------------------------------------
; Constants for track variables
; ---------------------------------------------------------------------------

		rsset 0
TrackPlaybackControl:	rs.b 1				; All tracks
TrackVoiceControl:	rs.b 1				; All tracks
TrackTempoDivider:	rs.b 1				; All tracks
			rs.b 1				; unused
TrackDataPointer:	rs.l 1				; All tracks (4 bytes)
			rs.w 0				; transpose and volume must come sequentially
TrackTranspose:		rs.b 1				; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		rs.b 1				; FM/PSG only
TrackAMSFMSPan:		rs.b 1				; FM/DAC only
TrackVoiceIndex:	rs.b 1				; FM/PSG only
TrackVolEnvIndex:	rs.b 1				; PSG only
TrackStackPointer:	rs.b 1				; All tracks
TrackDurationTimeout:	rs.b 1				; All tracks
TrackSavedDuration:	rs.b 1				; All tracks
TrackSavedDAC:		rs.b 0				; DAC only
TrackFreq:		rs.w 1				; FM/PSG only (2 bytes)
TrackNoteTimeout:	rs.b 1				; FM/PSG only
TrackNoteTimeoutMaster:	rs.b 1				; FM/PSG only
TrackModulationPtr:	rs.l 1				; FM/PSG only (4 bytes)
TrackModulationWait:	rs.b 1				; FM/PSG only
TrackModulationSpeed:	rs.b 1				; FM/PSG only
TrackModulationDelta:	rs.b 1				; FM/PSG only
TrackModulationSteps:	rs.b 1				; FM/PSG only
TrackModulationVal:	rs.w 1				; FM/PSG only (2 bytes)
TrackDetune:		rs.b 1				; FM/PSG only
TrackPSGNoise:		rs.b 0				; PSG only
TrackFeedbackAlgo:	rs.b 1				; FM only
TrackVoicePtr:		rs.l 1				; FM SFX only (4 bytes)
TrackLoopCounters:	rs.b 4				; All tracks (multiple bytes)
			rs.l 2				; stack data
TrackGoSubStack:	rs.w 0				; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses TrackSz)
TrackSz:		rs.w 0				; the size of a single track

; ===========================================================================
; ---------------------------------------------------------------------------
; constants for track variables
; ---------------------------------------------------------------------------

		rsset 0
v_startofvariables:	rs.w 0
v_sndprio:		rs.b 1				; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	rs.b 1				; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		rs.b 1				; Used for music only
f_pausemusic:		rs.b 1				; flag set to stop music when paused
v_fadeout_counter:	rs.b 1
			rs.b 1				; unused
v_fadeout_delay:	rs.b 1
v_communication_byte:	rs.b 1				; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		rs.b 1				; $80 if updating DAC, $00 otherwise
v_sound_id:		rs.b 1				; sound or music copied from below
v_soundqueue_size:	equ 3				; number of sound queue slots. Slots beyond 0 and 1 are broken!
v_soundqueue:		rs.b v_soundqueue_size		; sound queue entries
			rs.b 1				; unused
f_voice_selector:	rs.b 1				; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer
			rs.b 9				; unused
v_voice_ptr:		rs.l 1				; voice data pointer (4 bytes)
			rs.b 4				; unused
v_special_voice_ptr:	rs.l 1				; voice data pointer for special SFX ($D0-$DF) (4 bytes)
f_fadein_flag:		rs.b 1				; Flag for fade in
v_fadein_delay:		rs.b 1
v_fadein_counter:	rs.b 1				; Timer for fade in/out
f_1up_playing:		rs.b 1				; flag indicating 1-up song is playing
v_tempo_mod:		rs.b 1				; music - tempo modifier
v_speeduptempo:		rs.b 1				; music - tempo modifier with speed shoes
f_speedup:		rs.b 1				; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		rs.b 1				; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		rs.b 1				; if set, prevents further push sounds from playing
			rs.b $12			; unused

v_music_track_ram:	rs.w 0				; Start of music RAM
v_music_fmdac_tracks:	rs.w 0
v_music_dac_track:	rs.b TrackSz
v_music_fm_tracks:	rs.w 0
v_music_fm1_track:	rs.b TrackSz
v_music_fm2_track:	rs.b TrackSz
v_music_fm3_track:	rs.b TrackSz
v_music_fm4_track:	rs.b TrackSz
v_music_fm5_track:	rs.b TrackSz
v_music_fm6_track:	rs.b TrackSz
v_music_fm_tracks_end:	rs.w 0
v_music_fmdac_tracks_end: rs.w 0
v_music_psg_tracks:	rs.w 0
v_music_psg1_track:	rs.b TrackSz
v_music_psg2_track:	rs.b TrackSz
v_music_psg3_track:	rs.b TrackSz
v_music_psg_tracks_end:	rs.w 0
v_music_track_ram_end:	rs.w 0

v_sfx_track_ram:	rs.w 0				; Start of SFX RAM, straight after the end of music RAM
v_sfx_fm_tracks:	rs.w 0
v_sfx_fm3_track:	rs.b TrackSz
v_sfx_fm4_track:	rs.b TrackSz
v_sfx_fm5_track:	rs.b TrackSz
v_sfx_fm_tracks_end:	rs.w 0
v_sfx_psg_tracks:	rs.w 0
v_sfx_psg1_track:	rs.b TrackSz
v_sfx_psg2_track:	rs.b TrackSz
v_sfx_psg3_track:	rs.b TrackSz
v_sfx_psg_tracks_end:	rs.w 0
v_sfx_track_ram_end:	rs.w 0

v_spcsfx_track_ram:	rs.w 0				; Start of special SFX RAM, straight after the end of SFX RAM
v_spcsfx_fm4_track:	rs.b TrackSz
v_spcsfx_psg3_track:	rs.b TrackSz
v_spcsfx_track_ram_end:	rs.w 0

v_1up_ram_copy:		rs.b v_music_track_ram_end-v_startofvariables

; ===========================================================================
; ---------------------------------------------------------------------------
; constants for sound IDs
; ---------------------------------------------------------------------------

; Background music
		rsset $81				; ID of the first music file
_firstMusic	rs.b 0					; constant for the first music

GenMusicConst	macro	name
mus_\name	rs.b 1					; use the next ID for music
		endm

		MusicFiles	GenMusicConst		; generate constants for each music file
_lastMusic	equ __rs-1				; constant for the last music
; ---------------------------------------------------------------------------

; Sound effects
		rsset $A0				; ID of the first sfx file
_firstSfx	rs.b 0					; constant for the first sfx

GenSfxConst	macro	name
sfx_\name	rs.b 1					; use the next ID for sfx
		endm
		opt m+
		SfxFiles	GenSfxConst		; generate constants for each sfx file
_lastSfx	equ __rs-1				; constant for the last sfx
		opt m-
; ---------------------------------------------------------------------------

; Special sound effects
		rsset $D0				; ID of the first special sfx file
_firstSpecSfx	rs.b 0					; constant for the first special sfx

		SpecSfxFiles	GenSfxConst		; generate constants for each special sfx file
_lastSpecSfx	equ __rs-1				; constant for the last special sfx
; ---------------------------------------------------------------------------

; Sound commands
		rsset $E0				; ID of the first command
_firstCmd	rs.b 0					; constant for the first command

GenCmdConst	macro	name
cmd_\name	rs.b 1					; use the next ID for command
		endm

		DriverCmdFiles	GenCmdConst		; generate constants for each command
_lastCmd	equ __rs-1				; constant for the last command
; ---------------------------------------------------------------------------

		popo					; restore options
