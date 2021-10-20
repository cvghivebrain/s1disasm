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
bgm__First:	equ $81
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SYZ:	equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_SBZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm_Drowning:	equ ((ptr_mus92-MusicIndex)/4)+bgm__First
bgm_Emerald:	equ ((ptr_mus93-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	equ $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_A5:		equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_AB:		equ ((ptr_sndAB-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	equ $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

flg__First:	equ $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
sfx_Sega:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First
; ---------------------------------------------------------------------------

		popo					; restore options
