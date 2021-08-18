; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_SegaPCM:		equ $6978

; Sound driver constants
TrackPlaybackControl:	equ 0		; All tracks
TrackVoiceControl:	equ 1		; All tracks
TrackTempoDivider:	equ 2		; All tracks
TrackDataPointer:	equ 4		; All tracks (4 bytes)
TrackTranspose:		equ 8		; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		equ 9		; FM/PSG only
TrackAMSFMSPan:		equ $A		; FM/DAC only
TrackVoiceIndex:	equ $B		; FM/PSG only
TrackVolEnvIndex:	equ $C		; PSG only
TrackStackPointer:	equ $D		; All tracks
TrackDurationTimeout:	equ $E		; All tracks
TrackSavedDuration:	equ $F		; All tracks
TrackSavedDAC:		equ $10		; DAC only
TrackFreq:		equ $10		; FM/PSG only (2 bytes)
TrackNoteTimeout:	equ $12		; FM/PSG only
TrackNoteTimeoutMaster:equ $13		; FM/PSG only
TrackModulationPtr:	equ $14		; FM/PSG only (4 bytes)
TrackModulationWait:	equ $18		; FM/PSG only
TrackModulationSpeed:	equ $19		; FM/PSG only
TrackModulationDelta:	equ $1A		; FM/PSG only
TrackModulationSteps:	equ $1B		; FM/PSG only
TrackModulationVal:	equ $1C		; FM/PSG only (2 bytes)
TrackDetune:		equ $1E		; FM/PSG only
TrackPSGNoise:		equ $1F		; PSG only
TrackFeedbackAlgo:	equ $1F		; FM only
TrackVoicePtr:		equ $20		; FM SFX only (4 bytes)
TrackLoopCounters:	equ $24		; All tracks (multiple bytes)
TrackGoSubStack:	equ TrackSz	; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses zTrackSz)

TrackSz:	equ $30

; VRAM data
vram_window:	equ $A000	; window namespace
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sonic:	equ $F000	; Sonic graphics
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
ost_render:		equ 1	; bitfield for x/y flip, display mode
	render_xflip:		equ 1
	render_yflip:		equ 2
	render_rel:		equ 4
	render_abs:		equ 0
	render_rawmap:		equ $20
	render_xflip_bit:	equ 0
	render_yflip_bit:	equ 1
	render_rel_bit:		equ 2
	render_rawmap_bit:	equ 5
	render_bg_bit:		equ 6
	render_onscreen_bit:	equ 7
ost_tile:		equ 2	; palette line & VRAM setting (2 bytes)
	tile_xflip:	equ $800
	tile_yflip:	equ $1000
	tile_pal1:	equ 0
	tile_pal2:	equ $2000
	tile_pal3:	equ $4000
	tile_pal4:	equ $6000
	tile_hi:	equ $8000
ost_mappings:		equ 4	; mappings address (4 bytes)
ost_x_pos:		equ 8	; x-axis position (2 bytes)
ost_x_sub:		equ $A	; x-axis subpixel position (2 bytes)
ost_y_screen:		equ $A	; y-axis position for screen-fixed items (2 bytes)
ost_y_pos:		equ $C	; y-axis position (2 bytes)
ost_y_sub:		equ $E	; y-axis subpixel position (2 bytes)
ost_x_vel:		equ $10	; x-axis velocity (2 bytes)
ost_y_vel:		equ $12	; y-axis velocity (2 bytes)
ost_inertia:		equ $14	; potential speed (2 bytes)
ost_height:		equ $16	; height/2
ost_width:		equ $17	; width/2
ost_priority:		equ $18	; sprite stack priority -- 0 is front
ost_actwidth:		equ $19	; action width/2
ost_frame:		equ $1A	; current frame displayed
ost_anim_frame:		equ $1B	; current frame in animation script
ost_anim:		equ $1C	; current animation
ost_anim_next:		equ $1D	; next animation
ost_anim_time:		equ $1E	; time to next frame
ost_anim_delay:		equ $1F	; time to delay animation
ost_col_type:		equ $20	; collision response type
ost_col_property:	equ $21	; collision extra property
ost_status:		equ $22	; orientation or mode
	status_xflip:		equ 1	; xflip
	status_yflip:		equ 2	; yflip (objects only)
	status_air:		equ 2	; Sonic is in the air (Sonic only)
	status_jump:		equ 4	; jumping or rolling (Sonic only)
	status_platform:	equ 8	; Sonic is standing on this (objects) / Sonic is standing on object (Sonic)
	status_rolljump:	equ $10	; Sonic is jumping after rolling (Sonic only)
	status_pushing:		equ $20	; Sonic is pushing this (objects) / Sonic is pushing an object (Sonic)
	status_underwater:	equ $40	; Sonic is underwater (Sonic only)
	status_xflip_bit:	equ 0
	status_yflip_bit:	equ 1
	status_air_bit:		equ 1
	status_jump_bit:	equ 2
	status_platform_bit:	equ 3
	status_rolljump_bit:	equ 4
	status_pushing_bit:	equ 5
	status_underwater_bit:	equ 6
ost_respawn:		equ $23	; respawn list index number
ost_routine:		equ $24	; routine number
ost_routine2:		equ $25	; secondary routine number
ost_solid:		equ $25 ; solid status flag
ost_angle:		equ $26	; angle
ost_subtype:		equ $28	; object subtype

; Object variables used by Sonic
ost_sonic_flash_time:	equ $30	; time Sonic flashes for after getting hit (2 bytes)
ost_sonic_inv_time:	equ $32	; time left for invincibility (2 bytes)
ost_sonic_shoe_time:	equ $34	; time left for speed shoes (2 bytes)
ost_sonic_angle_right:	equ $36 ; angle of floor on Sonic's right side
ost_sonic_angle_left:	equ $37 ; angle of floor on Sonic's left side
ost_sonic_sbz_disc:	equ $38 ; 1 if Sonic is stuck to SBZ disc

ost_sonic_restart_time:	equ $3A ; time until level restarts (2 bytes)
ost_sonic_jump:		equ $3C ; 1 if Sonic is jumping
ost_sonic_on_obj:	equ $3D	; OST index of object Sonic stands on
ost_sonic_lock_time:	equ $3E	; time left for locked controls, e.g. after hitting a spring (2 bytes)

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter
afxflip:	equ $20
afyflip:	equ $40

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
