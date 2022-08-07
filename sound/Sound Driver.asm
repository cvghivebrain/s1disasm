; ---------------------------------------------------------------------------
; Subroutine to update music more than once per frame
; (Called by horizontal & vert. interrupts)
; ---------------------------------------------------------------------------

UpdateSound:
		stopZ80
		nop
		nop
		nop
		waitZ80

		btst	#7,(z80_dac_status).l			; Is DAC accepting new samples?
		beq.s	.driverinput				; Branch if yes
		startZ80
		nop
		nop
		nop
		nop
		nop
		bra.s	UpdateSound
; ===========================================================================

.driverinput:
		lea	(v_snddriver_ram&$FFFFFF).l,a6
		clr.b	v_channel_mode(a6)
		tst.b	f_pause_sound(a6)			; is music paused?
		bne.w	PauseMusic				; if yes, branch
		subq.b	#1,f_tempo_counter(a6)			; Has main tempo timer expired?
		bne.s	.skipdelay
		jsr	TempoWait(pc)

.skipdelay:
		move.b	v_fadeout_counter(a6),d0
		beq.s	.skipfadeout
		jsr	DoFadeOut(pc)

.skipfadeout:
		tst.b	f_fadein_flag(a6)
		beq.s	.skipfadein
		jsr	DoFadeIn(pc)

.skipfadein:
		; DANGER! The following line only checks v_soundqueue and v_soundqueue+1, breaking v_soundqueue+2.
		tst.w	v_soundqueue(a6)			; is a music or sound queued for played?
		beq.s	.nosndinput				; if not, branch
		jsr	CycleSoundQueue(pc)

.nosndinput:
		cmpi.b	#com_Null,v_sound_id(a6)		; is song queue set for silence (empty)?
		beq.s	.nonewsound				; If yes, branch
		jsr	PlaySoundID(pc)

.nonewsound:
		lea	v_music_DAC(a6),a5
		tst.b	(a5)					; Is DAC track playing? (ch_Flags)
		bpl.s	.dacdone				; Branch if not
		jsr	DACUpdateTrack(pc)

.dacdone:
		clr.b	f_updating_dac(a6)
		moveq	#((v_music_FM_RAM_end-v_music_FM_RAM)/ch_Size)-1,d7 ; 6 FM tracks

.bgmfmloop:
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.bgmfmnext				; Branch if not
		jsr	FMUpdateTrack(pc)

.bgmfmnext:
		dbf	d7,.bgmfmloop

		moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d7 ; 3 PSG tracks

.bgmpsgloop:
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.bgmpsgnext				; Branch if not
		jsr	PSGUpdateTrack(pc)

.bgmpsgnext:
		dbf	d7,.bgmpsgloop

		move.b	#$80,v_channel_mode(a6)			; Now at SFX tracks
		moveq	#((v_SFX_FM_RAM_end-v_SFX_FM_RAM)/ch_Size)-1,d7 ; 3 FM tracks (SFX)

.sfxfmloop:
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.sfxfmnext				; Branch if not
		jsr	FMUpdateTrack(pc)

.sfxfmnext:
		dbf	d7,.sfxfmloop

		moveq	#((v_SFX_PSG_RAM_end-v_SFX_PSG_RAM)/ch_Size)-1,d7 ; 3 PSG tracks (SFX)

.sfxpsgloop:
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.sfxpsgnext				; Branch of not
		jsr	PSGUpdateTrack(pc)

.sfxpsgnext:
		dbf	d7,.sfxpsgloop

		move.b	#$40,v_channel_mode(a6)			; Now at special SFX tracks
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.specfmdone				; Branch if not
		jsr	FMUpdateTrack(pc)

.specfmdone:
		adda.w	#ch_Size,a5
		tst.b	(a5)					; Is track playing (ch_Flags)
		bpl.s	DoStartZ80				; Branch if not
		jsr	PSGUpdateTrack(pc)

DoStartZ80:
		startZ80
		rts

; ---------------------------------------------------------------------------
; Subroutine to update DAC sample
; ---------------------------------------------------------------------------

DACUpdateTrack:
		subq.b	#1,ch_Delay(a5)				; Has DAC sample timeout expired?
		bne.s	.locret					; Return if not
		move.b	#$80,f_updating_dac(a6)			; Set flag to indicate this is the DAC
		movea.l	ch_Data(a5),a4				; DAC track data pointer

.sampleloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; Get next SMPS unit
		cmpi.b	#_firstCom,d5				; Is it a coord. flag?
		blo.s	.notcoord				; Branch if not
		jsr	SongCommand(pc)
		bra.s	.sampleloop
; ===========================================================================

.notcoord:
		tst.b	d5					; Is it a sample?
		bpl.s	.gotduration				; Branch if not (duration)
		move.b	d5,ch_Sample(a5)			; Store new sample
		move.b	(a4)+,d5				; Get another byte
		bpl.s	.gotduration				; Branch if it is a duration
		subq.w	#1,a4					; Put byte back
		move.b	ch_SavedDelay(a5),ch_Delay(a5)		; Use last duration
		bra.s	.gotsampleduration
; ===========================================================================

.gotduration:
		jsr	SetDuration(pc)

.gotsampleduration:
		move.l	a4,ch_Data(a5)				; Save pointer
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.locret					; Return if yes
		moveq	#0,d0
		move.b	ch_Sample(a5),d0			; Get sample
		cmpi.b	#nR,d0					; Is it a rest?
		beq.s	.locret					; Return if yes
		btst	#3,d0					; Is bit 3 set (samples between $88-$8F)?
		bne.s	.timpani				; Various timpani
		move.b	d0,(z80_dac_sample).l

.locret:
		rts
; ===========================================================================

.timpani:
		subi.b	#$88,d0					; Convert into an index
		move.b	DAC_sample_rate(pc,d0.w),d0
		; Warning: this affects the raw pitch of sample $83, meaning it will
		; use this value from then on.
		move.b	d0,(z80_dac3_pitch).l
		move.b	#$83,(z80_dac_sample).l			; Use timpani
		rts

; ===========================================================================
; Note: this only defines rates for samples $88-$8D, meaning $8E-$8F are invalid.
; Also, $8C-$8D are so slow you may want to skip them.

DAC_sample_rate: dc.b 18, 21, 28, 29, $FF, $FF

; ---------------------------------------------------------------------------
; Subroutine to update FM
; ---------------------------------------------------------------------------

FMUpdateTrack:
		subq.b	#1,ch_Delay(a5)				; Update duration timeout
		bne.s	.notegoing				; Branch if it hasn't expired
		bclr	#chf_Tie,(a5)				; Clear 'do not attack next note' bit (ch_Flags)
		jsr	FMDoNext(pc)
		jsr	FMPrepareNote(pc)
		bra.w	FMNoteOn
; ===========================================================================

.notegoing:
		jsr	NoteTimeoutUpdate(pc)
		jsr	DoModulation(pc)
		bra.w	FMUpdateFreq

FMDoNext:
		movea.l	ch_Data(a5),a4				; Track data pointer
		bclr	#chf_Rest,(a5)				; Clear 'track at rest' bit (ch_Flags)

.noteloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; Get byte from track
		cmpi.b	#_firstCom,d5				; Is this a coord. flag?
		blo.s	.gotnote				; Branch if not
		jsr	SongCommand(pc)
		bra.s	.noteloop
; ===========================================================================

.gotnote:
		jsr	FMNoteOff(pc)
		tst.b	d5					; Is this a note?
		bpl.s	.gotduration				; Branch if not
		jsr	FMSetFreq(pc)
		move.b	(a4)+,d5				; Get another byte
		bpl.s	.gotduration				; Branch if it is a duration
		subq.w	#1,a4					; Otherwise, put it back
		bra.w	FinishTrackUpdate
; ===========================================================================

.gotduration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; ===========================================================================

FMSetFreq:
		subi.b	#_firstNote-1,d5			; Make it a zero-based index
		beq.s	TrackSetRest
		add.b	ch_Transpose(a5),d5			; Add track transposition
		andi.w	#$7F,d5					; Clear high byte and sign bit
		lsl.w	#1,d5
		lea	FMFrequencies(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,ch_Freq(a5)				; Store new frequency
		rts

; ---------------------------------------------------------------------------
; Subroutine to set duration of DAC/FM/PSG
; ---------------------------------------------------------------------------

SetDuration:
		move.b	d5,d0
		move.b	ch_Tick(a5),d1				; Get dividing timing

.multloop:
		subq.b	#1,d1
		beq.s	.donemult
		add.b	d5,d0
		bra.s	.multloop
; ===========================================================================

.donemult:
		move.b	d0,ch_SavedDelay(a5)			; Save duration
		move.b	d0,ch_Delay(a5)				; Save duration timeout
		rts

; ===========================================================================

TrackSetRest:
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		clr.w	ch_Freq(a5)				; Clear frequency

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

FinishTrackUpdate:
		move.l	a4,ch_Data(a5)				; Store new track position
		move.b	ch_SavedDelay(a5),ch_Delay(a5)		; Reset note timeout
		btst	#chf_Tie,(a5)				; Is track set to not attack note? (ch_Flags)
		bne.s	.locret					; If so, branch
		move.b	ch_SavedGate(a5),ch_Gate(a5)		; Reset note fill timeout
		clr.b	ch_VolEnvPos(a5)			; Reset PSG volume envelope index (even on FM tracks...)
		btst	#chf_Vib,(a5)				; Is modulation on? (ch_Flags)
		beq.s	.locret					; If not, return (ch_Flags)
		movea.l	ch_VibPtr(a5),a0			; Modulation data pointer
		move.b	(a0)+,ch_VibDelay(a5)			; Reset wait
		move.b	(a0)+,ch_VibSpeed(a5)			; Reset speed
		move.b	(a0)+,ch_VibOff(a5)			; Reset delta
		move.b	(a0)+,d0				; Get steps
		lsr.b	#1,d0					; Halve them
		move.b	d0,ch_VibSteps(a5)			; Then store
		clr.w	ch_VibFreq(a5)				; Reset frequency change

.locret:
		rts

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

NoteTimeoutUpdate:
		tst.b	ch_Gate(a5)				; Is note fill on?
		beq.s	.locret
		subq.b	#1,ch_Gate(a5)				; Update note fill timeout
		bne.s	.locret					; Return if it hasn't expired
		bset	#chf_Rest,(a5)				; Put track at rest (ch_Flags)
		tst.b	ch_Type(a5)				; Is this a psg track?
		bmi.w	.psgnoteoff				; If yes, branch
		jsr	FMNoteOff(pc)
		addq.w	#4,sp					; Do not return to caller
		rts
; ===========================================================================

.psgnoteoff:
		jsr	PSGNoteOff(pc)
		addq.w	#4,sp					; Do not return to caller

.locret:
		rts

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

DoModulation:
		addq.w	#4,sp					; Do not return to caller (but see below)
		btst	#chf_Vib,(a5)				; Is modulation active? (ch_Flags)
		beq.s	.locret					; Return if not
		tst.b	ch_VibDelay(a5)				; Has modulation wait expired?
		beq.s	.waitdone				; If yes, branch
		subq.b	#1,ch_VibDelay(a5)			; Update wait timeout
		rts
; ===========================================================================

.waitdone:
		subq.b	#1,ch_VibSpeed(a5)			; Update speed
		beq.s	.updatemodulation			; If it expired, want to update modulation
		rts
; ===========================================================================

.updatemodulation:
		movea.l	ch_VibPtr(a5),a0			; Get modulation data
		move.b	1(a0),ch_VibSpeed(a5)			; Restore modulation speed
		tst.b	ch_VibSteps(a5)				; Check number of steps
		bne.s	.calcfreq				; If nonzero, branch
		move.b	3(a0),ch_VibSteps(a5)			; Restore from modulation data
		neg.b	ch_VibOff(a5)				; Negate modulation delta
		rts
; ===========================================================================

.calcfreq:
		subq.b	#1,ch_VibSteps(a5)			; Update modulation steps
		move.b	ch_VibOff(a5),d6			; Get modulation delta
		ext.w	d6
		add.w	ch_VibFreq(a5),d6			; Add cumulative modulation change
		move.w	d6,ch_VibFreq(a5)			; Store it
		add.w	ch_Freq(a5),d6				; Add note frequency to it
		subq.w	#4,sp					; In this case, we want to return to caller after all

.locret:
		rts

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

FMPrepareNote:
		btst	#chf_Rest,(a5)				; Is track resting? (ch_Flags)
		bne.s	locret_71E48				; Return if so
		move.w	ch_Freq(a5),d6				; Get current note frequency
		beq.s	FMSetRest				; Branch if zero

FMUpdateFreq:
		move.b	ch_Detune(a5),d0			; Get detune value
		ext.w	d0
		add.w	d0,d6					; Add note frequency
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	locret_71E48				; Return if so
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0					; Register for upper 6 bits of frequency
		jsr	WriteFMIorII(pc)
		move.b	d6,d1
		move.b	#$A0,d0					; Register for lower 8 bits of frequency
		jsr	WriteFMIorII(pc)			; (It would be better if this were a jmp)

locret_71E48:
		rts
; ===========================================================================

FMSetRest:
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		rts

; ---------------------------------------------------------------------------
; Pause/unpause music
; ---------------------------------------------------------------------------

PauseMusic:
		bmi.s	.unpausemusic				; Branch if music is being unpaused
		cmpi.b	#2,f_pause_sound(a6)
		beq.w	.unpausedallfm
		move.b	#2,f_pause_sound(a6)
		moveq	#2,d3
		move.b	#$B4,d0					; Command to set AMS/FMS/panning
		moveq	#0,d1					; No panning, AMS or FMS

.killpanloop:
		jsr	WriteFMI(pc)
		jsr	WriteFMII(pc)
		addq.b	#1,d0
		dbf	d3,.killpanloop

		moveq	#2,d3
		moveq	#$28,d0					; Key on/off register

.noteoffloop:
		move.b	d3,d1					; FM1, FM2, FM3
		jsr	WriteFMI(pc)
		addq.b	#4,d1					; FM4, FM5, FM6
		jsr	WriteFMI(pc)
		dbf	d3,.noteoffloop

		jsr	PSGSilenceAll(pc)
		bra.w	DoStartZ80
; ===========================================================================

.unpausemusic:
		clr.b	f_pause_sound(a6)
		moveq	#ch_Size,d3
		lea	v_music_FMDAC_RAM(a6),a5
		moveq	#((v_music_FMDAC_RAM_end-v_music_FMDAC_RAM)/ch_Size)-1,d4 ; 6 FM + 1 DAC tracks

.bgmfmloop:
		btst	#chf_Enable,(a5)			; Is track playing? (ch_Flags)
		beq.s	.bgmfmnext				; Branch if not
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.bgmfmnext				; Branch if yes
		move.b	#$B4,d0					; Command to set AMS/FMS/panning
		move.b	ch_Pan(a5),d1				; Get value from track RAM
		jsr	WriteFMIorII(pc)

.bgmfmnext:
		adda.w	d3,a5
		dbf	d4,.bgmfmloop

		lea	v_SFX_FM_RAM(a6),a5
		moveq	#((v_SFX_FM_RAM_end-v_SFX_FM_RAM)/ch_Size)-1,d4 ; 3 FM tracks (SFX)

.sfxfmloop:
		btst	#chf_Enable,(a5)			; Is track playing? (ch_Flags)
		beq.s	.sfxfmnext				; Branch if not
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.sfxfmnext				; Branch if yes
		move.b	#$B4,d0					; Command to set AMS/FMS/panning
		move.b	ch_Pan(a5),d1				; Get value from track RAM
		jsr	WriteFMIorII(pc)

.sfxfmnext:
		adda.w	d3,a5
		dbf	d4,.sfxfmloop

		lea	v_back_ram(a6),a5
		btst	#chf_Enable,(a5)			; Is track playing? (ch_Flags)
		beq.s	.unpausedallfm				; Branch if not
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.unpausedallfm				; Branch if yes
		move.b	#$B4,d0					; Command to set AMS/FMS/panning
		move.b	ch_Pan(a5),d1				; Get value from track RAM
		jsr	WriteFMIorII(pc)

.unpausedallfm:
		bra.w	DoStartZ80

; ---------------------------------------------------------------------------
; Subroutine to	play a sound or	music track
; ---------------------------------------------------------------------------

CycleSoundQueue:
		movea.l	(Go_SoundPriorities).l,a0
		lea	v_soundqueue(a6),a1			; load music track number
		move.b	v_priority(a6),d3			; Get priority of currently playing SFX
		moveq	#v_soundqueue_size-1,d4			; size of the sound queue

.inputloop:
		move.b	(a1),d0					; move track number to d0
		move.b	d0,d1
		clr.b	(a1)+					; Clear entry
		subi.b	#_firstMusic,d0				; Make it into 0-based index
		bcs.s	.nextinput				; If negative (i.e., it was $80 or lower), branch
		cmpi.b	#com_Null,v_sound_id(a6)		; Is v_sound_id a $80 (silence/empty)?
		beq.s	.havesound				; If yes, branch
		move.b	d1,v_soundqueue(a6)			; Put sound into v_soundqueue+0
		bra.s	.nextinput
; ===========================================================================

.havesound:
		andi.w	#$7F,d0					; Clear high byte and sign bit
		move.b	(a0,d0.w),d2				; Get sound type
		cmp.b	d3,d2					; Is it a lower priority sound?
		blo.s	.nextinput				; Branch if yes
		move.b	d2,d3					; Store new priority
		move.b	d1,v_sound_id(a6)			; Queue sound for play

.nextinput:
		dbf	d4,.inputloop

		tst.b	d3					; We don't want to change sound priority if it is negative
		bmi.s	.locret
		move.b	d3,v_priority(a6)			; Set new sound priority

.locret:
		rts

; ---------------------------------------------------------------------------
; Subroutine to begin playing bgm or sfx
; ---------------------------------------------------------------------------

PlaySoundID:
		moveq	#0,d7
		move.b	v_sound_id(a6),d7
		beq.w	SoundCmd_Stop
		bpl.s	.locret					; If >= 0, return (not a valid sound, bgm or command)
		move.b	#com_Null,v_sound_id(a6)		; reset	music flag
		; DANGER! Music ends at $93, yet this checks until $9F; attempting to
		; play sounds $94-$9F will cause a crash! Remove the '+$C' to fix this.
		; See LevSel_NoCheat for more.
		cmpi.b	#_lastMusic+$C,d7			; Is this music ($81-$9F)?
		bls.w	Sound_PlayBGM				; Branch if yes
		cmpi.b	#_firstSfx,d7				; Is this after music but before sfx? (redundant check)
		blo.w	.locret					; Return if yes
		cmpi.b	#_lastSfx,d7				; Is this sfx ($A0-$CF)?
		bls.w	Sound_PlaySFX				; Branch if yes
		cmpi.b	#_firstSpecSfx,d7			; Is this after sfx but before special sfx? (redundant check)
		blo.w	.locret					; Return if yes
		; DANGER! Special SFXes end at $D0, yet this checks until $DF; attempting to
		; play sounds $D1-$DF will cause a crash! Remove the '+$10' and change the 'blo' to a 'bls'
		; and uncomment the two lines below to fix this.
		cmpi.b	#_lastSpecSfx+$10,d7			; Is this special sfx ($D0-$DF)?
		blo.w	Sound_PlaySpecial			; Branch if yes
		;cmpi.b	#_firstCmd,d7		; Is this after special sfx but before $E0?
		;blo.w	.locret			; Return if yes
		cmpi.b	#_lastCmd,d7				; Is this $E0-$E4?
		bls.s	Sound_E0toE4				; Branch if yes

.locret:
		rts
; ===========================================================================

Sound_E0toE4:
		subi.b	#_firstCmd,d7
		lsl.w	#2,d7
		jmp	Sound_ExIndex(pc,d7.w)
; ===========================================================================

GenSoundCmds	macro	name
		bra.w	SoundCmd_\name				; generate a jump for every command
		endm

Sound_ExIndex:
		DriverCmdFiles	GenSoundCmds			; generate includes for all the files

; ---------------------------------------------------------------------------
; Play "Say-gaa" PCM sound
; ---------------------------------------------------------------------------

SoundCmd_Sega:
		move.b	#$88,(z80_dac_sample).l			; Queue Sega PCM
		startZ80
		move.w	#$11,d1

.busyloop_outer:
		move.w	#-1,d0

.busyloop:
		nop
		dbf	d0,.busyloop

		dbf	d1,.busyloop_outer

		addq.w	#4,sp					; Tamper return value so we don't return to caller
		rts

; ---------------------------------------------------------------------------
; Play music track $81-$9F
; ---------------------------------------------------------------------------

Sound_PlayBGM:
		cmpi.b	#mus_ExtraLife,d7			; is the "extra life" music to be played?
		bne.s	.bgmnot1up				; if not, branch
		tst.b	f_has_backup(a6)			; Is a 1-up music playing?
		bne.w	.locdblret				; if yes, branch
		lea	v_music_ram(a6),a5
		moveq	#((v_music_ram_end-v_music_ram)/ch_Size)-1,d0 ; 1 DAC + 6 FM + 3 PSG tracks

.clearsfxloop:
		bclr	#chf_Mask,(a5)				; Clear 'SFX is overriding' bit (ch_Flags)
		adda.w	#ch_Size,a5
		dbf	d0,.clearsfxloop

		lea	v_sfx_ram(a6),a5
		moveq	#((v_sfx_ram_end-v_sfx_ram)/ch_Size)-1,d0 ; 3 FM + 3 PSG tracks (SFX)

.cleartrackplayloop:
		bclr	#chf_Enable,(a5)			; Clear 'track is playing' bit (ch_Flags)
		adda.w	#ch_Size,a5
		dbf	d0,.cleartrackplayloop

		clr.b	v_priority(a6)				; Clear priority
		movea.l	a6,a0
		lea	v_backup_ram(a6),a1
		move.w	#((v_music_ram_end-v_backup_start)/4)-1,d0 ; Backup $220 bytes: all variables and music track data

.backupramloop:
		move.l	(a0)+,(a1)+
		dbf	d0,.backupramloop

		move.b	#$80,f_has_backup(a6)
		clr.b	v_priority(a6)				; Clear priority again (?)
		bra.s	.bgm_loadMusic
; ===========================================================================

.bgmnot1up:
		clr.b	f_has_backup(a6)
		clr.b	v_fadein_counter(a6)

.bgm_loadMusic:
		jsr	InitMusicPlayback(pc)
		movea.l	(Go_SpeedUpIndex).l,a4
		subi.b	#_firstMusic,d7
		move.b	(a4,d7.w),v_tempo_speed(a6)
		movea.l	(Go_MusicIndex).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4				; a4 now points to (uncompressed) song data
		moveq	#0,d0
		move.w	(a4),d0					; load voice pointer
		add.l	a4,d0					; It is a relative pointer
		move.l	d0,v_music_voice_table(a6)
		move.b	5(a4),d0				; load tempo
		move.b	d0,v_tempo_main(a6)
		tst.b	f_speedup(a6)
		beq.s	.nospeedshoes
		move.b	v_tempo_speed(a6),d0

.nospeedshoes:
		move.b	d0,f_current_tempo(a6)
		move.b	d0,f_tempo_counter(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4					; Point past header
		moveq	#0,d7
		move.b	2(a3),d7				; load number of FM+DAC tracks
		beq.w	.bgm_fmdone				; branch if zero
		subq.b	#1,d7
		move.b	#sPanCenter,d1				; Default AMS+FMS+Panning
		move.b	4(a3),d4				; load tempo dividing timing
		moveq	#ch_Size,d6
		move.b	#1,d5					; Note duration for first "note"
		lea	v_music_FMDAC_RAM(a6),a1
		lea	FMDACInitBytes(pc),a2

.bmg_fmloadloop:
		bset	#7,(a1)					; Initial playback control: set 'track playing' bit (ch_Flags)
		move.b	(a2)+,ch_Type(a1)			; Voice control bits
		move.b	d4,ch_Tick(a1)
		move.b	d6,ch_StackPtr(a1)			; set "gosub" (coord flag F8h) stack init value
		move.b	d1,ch_Pan(a1)				; Set AMS/FMS/Panning
		move.b	d5,ch_Delay(a1)				; Set duration of first "note"
		moveq	#0,d0
		move.w	(a4)+,d0				; load DAC/FM pointer
		add.l	a3,d0					; Relative pointer
		move.l	d0,ch_Data(a1)				; Store track pointer
		move.w	(a4)+,ch_Transpose(a1)			; load FM channel modifier
		adda.w	d6,a1
		dbf	d7,.bmg_fmloadloop

		cmpi.b	#7,2(a3)				; Are 7 FM tracks defined?
		bne.s	.silencefm6
		moveq	#$2B,d0					; DAC enable/disable register
		moveq	#0,d1					; Disable DAC
		jsr	WriteFMI(pc)
		bra.w	.bgm_fmdone
; ===========================================================================

.silencefm6:
		moveq	#$28,d0					; Key on/off register
		moveq	#6,d1					; Note off on all operators of channel 6
		jsr	WriteFMI(pc)
		move.b	#$42,d0					; TL for operator 1 of FM6
		moveq	#$7F,d1					; Total silence
		jsr	WriteFMII(pc)
		move.b	#$4A,d0					; TL for operator 3 of FM6
		moveq	#$7F,d1					; Total silence
		jsr	WriteFMII(pc)
		move.b	#$46,d0					; TL for operator 2 of FM6
		moveq	#$7F,d1					; Total silence
		jsr	WriteFMII(pc)
		move.b	#$4E,d0					; TL for operator 4 of FM6
		moveq	#$7F,d1					; Total silence
		jsr	WriteFMII(pc)
		move.b	#$B6,d0					; AMS/FMS/panning of FM6
		move.b	#sPanCenter,d1				; pan to center
		jsr	WriteFMII(pc)

.bgm_fmdone:
		moveq	#0,d7
		move.b	3(a3),d7				; Load number of PSG tracks
		beq.s	.bgm_psgdone				; branch if zero
		subq.b	#1,d7
		lea	v_music_PSG_RAM(a6),a1
		lea	PSGInitBytes(pc),a2

.bgm_psgloadloop:
		bset	#7,(a1)					; Initial playback control: set 'track playing' bit (ch_Flags)
		move.b	(a2)+,ch_Type(a1)			; Voice control bits
		move.b	d4,ch_Tick(a1)
		move.b	d6,ch_StackPtr(a1)			; set "gosub" (coord flag F8h) stack init value
		move.b	d5,ch_Delay(a1)				; Set duration of first "note"
		moveq	#0,d0
		move.w	(a4)+,d0				; load PSG channel pointer
		add.l	a3,d0					; Relative pointer
		move.l	d0,ch_Data(a1)				; Store track pointer
		move.w	(a4)+,ch_Transpose(a1)			; load PSG modifier
		move.b	(a4)+,d0				; load redundant byte
		move.b	(a4)+,ch_Voice(a1)			; Initial PSG envelope
		adda.w	d6,a1
		dbf	d7,.bgm_psgloadloop

.bgm_psgdone:
		lea	v_sfx_ram(a6),a1
		moveq	#((v_sfx_ram_end-v_sfx_ram)/ch_Size)-1,d7 ; 6 SFX tracks

.sfxstoploop:
		tst.b	(a1)					; Is SFX playing? (ch_Flags)
		bpl.w	.sfxnext				; Branch if not
		moveq	#0,d0
		move.b	ch_Type(a1),d0				; Get voice control bits
		bmi.s	.sfxpsgchannel				; Branch if this is a PSG channel
		subq.b	#2,d0					; SFX can't have FM1 or FM2
		lsl.b	#2,d0					; Convert to index
		bra.s	.gotchannelindex
; ===========================================================================

.sfxpsgchannel:
		lsr.b	#3,d0					; Convert to index

.gotchannelindex:
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,(a0)					; Set 'SFX is overriding' bit (ch_Flags)

.sfxnext:
		adda.w	d6,a1
		dbf	d7,.sfxstoploop

		tst.w	v_Back_FM4+ch_Flags(a6)			; Is special SFX being played?
		bpl.s	.checkspecialpsg			; Branch if not
		bset	#2,v_music_FM4+ch_Flags(a6)		; Set 'SFX is overriding' bit

.checkspecialpsg:
		tst.w	v_Back_PSG3+ch_Flags(a6)		; Is special SFX being played?
		bpl.s	.sendfmnoteoff				; Branch if not
		bset	#2,v_music_PSG3+ch_Flags(a6)		; Set 'SFX is overriding' bit

.sendfmnoteoff:
		lea	v_music_FM_RAM(a6),a5
		moveq	#((v_music_FM_RAM_end-v_music_FM_RAM)/ch_Size)-1,d4 ; 6 FM tracks

.fmnoteoffloop:
		jsr	FMNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.fmnoteoffloop			; run all FM tracks
		moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d4 ; 3 PSG tracks

.psgnoteoffloop:
		jsr	PSGNoteOff(pc)
		adda.w	d6,a5
		dbf	d4,.psgnoteoffloop			; run all PSG tracks

.locdblret:
		addq.w	#4,sp					; Tamper with return value to not return to caller
		rts
; ===========================================================================

FMDACInitBytes:	dc.b tDAC
		dc.b tFM1, tFM2, tFM3				; port 1
		dc.b tFM4, tFM5, tFM6				; port 2
		even

PSGInitBytes:	dc.b tPSG1, tPSG2, tPSG3			; Specifically, these configure writes to the PSG port for each channel
		even

; ---------------------------------------------------------------------------
; Play normal sound effect
; ---------------------------------------------------------------------------

Sound_PlaySFX:
		tst.b	f_has_backup(a6)			; Is 1-up playing?
		bne.w	.clear_sndprio				; Exit is it is
		tst.b	v_fadeout_counter(a6)			; Is music being faded out?
		bne.w	.clear_sndprio				; Exit if it is
		tst.b	f_fadein_flag(a6)			; Is music being faded in?
		bne.w	.clear_sndprio				; Exit if it is
		cmpi.b	#sfx_Ring,d7				; is ring sound	effect played?
		bne.s	.sfx_notRing				; if not, branch
		tst.b	v_ring_speaker(a6)			; Is the ring sound playing on right speaker?
		bne.s	.gotringspeaker				; Branch if not
		move.b	#sfx_RingLeft,d7			; play ring sound in left speaker

.gotringspeaker:
		bchg	#0,v_ring_speaker(a6)			; change speaker

.sfx_notRing:
		cmpi.b	#sfx_Push,d7				; is "pushing" sound played?
		bne.s	.sfx_notPush				; if not, branch
		tst.b	f_push_playing(a6)			; Is pushing sound already playing?
		bne.w	.locret					; Return if not
		move.b	#$80,f_push_playing(a6)			; Mark it as playing

.sfx_notPush:
		movea.l	(Go_SoundIndex).l,a0
		subi.b	#_firstSfx,d7				; Make it 0-based
		lsl.w	#2,d7					; Convert sfx ID into index
		movea.l	(a0,d7.w),a3				; SFX data pointer
		movea.l	a3,a1
		moveq	#0,d1
		move.w	(a1)+,d1				; Voice pointer
		add.l	a3,d1					; Relative pointer
		move.b	(a1)+,d5				; Dividing timing
		; DANGER! there is a missing 'moveq	#0,d7' here, without which SFXes whose
		; index entry is above $3F will cause a crash. This is actually the same way that
		; this bug is fixed in Ristar's driver.
		move.b	(a1)+,d7				; Number of tracks (FM + PSG)
		subq.b	#1,d7
		moveq	#ch_Size,d6

.sfx_loadloop:
		moveq	#0,d3
		move.b	1(a1),d3				; Channel assignment bits
		move.b	d3,d4
		bmi.s	.sfxinitpsg				; Branch if PSG
		subq.w	#2,d3					; SFX can only have FM3, FM4 or FM5
		lsl.w	#2,d3
		lea	SFX_BGMChannelRAM(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#chf_Mask,(a5)				; Mark music track as being overridden (ch_Flags)
		bra.s	.sfxoverridedone
; ===========================================================================

.sfxinitpsg:
		lsr.w	#3,d3
		lea	SFX_BGMChannelRAM(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#chf_Mask,(a5)				; Mark music track as being overridden (ch_Flags)
		cmpi.b	#tPSG3,d4				; Is this PSG 3?
		bne.s	.sfxoverridedone			; Branch if not
		move.b	d4,d0
		ori.b	#$1F,d0					; Command to silence PSG 3
		move.b	d0,(psg_input).l
		bchg	#5,d0					; Command to silence noise channel
		move.b	d0,(psg_input).l

.sfxoverridedone:
		movea.l	SFX_SFXChannelRAM(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#(ch_Size/4)-1,d0			; $30 bytes

.clearsfxtrackram:
		clr.l	(a2)+
		dbf	d0,.clearsfxtrackram

		move.w	(a1)+,(a5)				; Initial playback control bits (ch_Flags)
		move.b	d5,ch_Tick(a5)				; Initial voice control bits
		moveq	#0,d0
		move.w	(a1)+,d0				; Track data pointer
		add.l	a3,d0					; Relative pointer
		move.l	d0,ch_Data(a5)				; Store track pointer
		move.w	(a1)+,ch_Transpose(a5)			; load FM/PSG channel modifier
		move.b	#1,ch_Delay(a5)				; Set duration of first "note"
		move.b	d6,ch_StackPtr(a5)			; set "gosub" (coord flag F8h) stack init value
		tst.b	d4					; Is this a PSG channel?
		bmi.s	.sfxpsginitdone				; Branch if yes
		move.b	#sPanCenter,ch_Pan(a5)			; AMS/FMS/Panning
		move.l	d1,ch_VoiceTable(a5)			; Voice pointer

.sfxpsginitdone:
		dbf	d7,.sfx_loadloop

		tst.b	v_SFX_FM4+ch_Flags(a6)			; Is special SFX being played?
		bpl.s	.doneoverride				; Branch if not
		bset	#2,v_Back_FM4+ch_Flags(a6)		; Set 'SFX is overriding' bit

.doneoverride:
		tst.b	v_SFX_PSG3+ch_Flags(a6)			; Is SFX being played?
		bpl.s	.locret					; Branch if not
		bset	#2,v_Back_PSG3+ch_Flags(a6)		; Set 'SFX is overriding' bit

.locret:
		rts
; ===========================================================================

.clear_sndprio:
		clr.b	v_priority(a6)				; Clear priority
		rts

; ---------------------------------------------------------------------------
; RAM addresses for FM and PSG channel variables used by the SFX
; ---------------------------------------------------------------------------

SFX_BGMChannelRAM:
		dc.l (v_snddriver_ram+v_music_FM3)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram+v_music_FM4)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_FM5)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_PSG1)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_PSG2)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_PSG3)&$FFFFFF	; Plain PSG3
		dc.l (v_snddriver_ram+v_music_PSG3)&$FFFFFF	; Noise

SFX_SFXChannelRAM:
		dc.l (v_snddriver_ram+v_SFX_FM3)&$FFFFFF
		dc.l 0
		dc.l (v_snddriver_ram+v_SFX_FM4)&$FFFFFF
		dc.l (v_snddriver_ram+v_SFX_FM5)&$FFFFFF
		dc.l (v_snddriver_ram+v_SFX_PSG1)&$FFFFFF
		dc.l (v_snddriver_ram+v_SFX_PSG2)&$FFFFFF
		dc.l (v_snddriver_ram+v_SFX_PSG3)&$FFFFFF	; Plain PSG3
		dc.l (v_snddriver_ram+v_SFX_PSG3)&$FFFFFF	; Noise

; ---------------------------------------------------------------------------
; Play GHZ waterfall sound
; ---------------------------------------------------------------------------

Sound_PlaySpecial:
		tst.b	f_has_backup(a6)			; Is 1-up playing?
		bne.w	.locret					; Return if so
		tst.b	v_fadeout_counter(a6)			; Is music being faded out?
		bne.w	.locret					; Exit if it is
		tst.b	f_fadein_flag(a6)			; Is music being faded in?
		bne.w	.locret					; Exit if it is
		movea.l	(Go_SpecSoundIndex).l,a0
		subi.b	#_firstSpecSfx,d7			; Make it 0-based
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0				; Voice pointer
		add.l	a3,d0					; Relative pointer
		move.l	d0,v_back_voice_table(a6)		; Store voice pointer
		move.b	(a1)+,d5				; Dividing timing
		; DANGER! there is a missing 'moveq	#0,d7' here, without which special SFXes whose
		; index entry is above $3F will cause a crash. This instance was not fixed in Ristar's driver.
		move.b	(a1)+,d7				; Number of tracks (FM + PSG)
		subq.b	#1,d7
		moveq	#ch_Size,d6

.sfxloadloop:
		move.b	1(a1),d4				; Voice control bits
		bmi.s	.sfxoverridepsg				; Branch if PSG
		bset	#2,v_music_FM4+ch_Flags(a6)		; Set 'SFX is overriding' bit
		lea	v_Back_FM4(a6),a5
		bra.s	.sfxinitpsg
; ===========================================================================

.sfxoverridepsg:
		bset	#2,v_music_PSG3+ch_Flags(a6)		; Set 'SFX is overriding' bit
		lea	v_Back_PSG3(a6),a5

.sfxinitpsg:
		movea.l	a5,a2
		moveq	#(ch_Size/4)-1,d0			; $30 bytes

.clearsfxtrackram:
		clr.l	(a2)+
		dbf	d0,.clearsfxtrackram

		move.w	(a1)+,(a5)				; Initial playback control bits & voice control bits (ch_Flags)
		move.b	d5,ch_Tick(a5)
		moveq	#0,d0
		move.w	(a1)+,d0				; Track data pointer
		add.l	a3,d0					; Relative pointer
		move.l	d0,ch_Data(a5)				; Store track pointer
		move.w	(a1)+,ch_Transpose(a5)			; load FM/PSG channel modifier
		move.b	#1,ch_Delay(a5)				; Set duration of first "note"
		move.b	d6,ch_StackPtr(a5)			; set "gosub" (coord flag F8h) stack init value
		tst.b	d4					; Is this a PSG channel?
		bmi.s	.sfxpsginitdone				; Branch if yes
		move.b	#sPanCenter,ch_Pan(a5)			; AMS/FMS/Panning

.sfxpsginitdone:
		dbf	d7,.sfxloadloop

		tst.b	v_SFX_FM4+ch_Flags(a6)			; Is track playing?
		bpl.s	.doneoverride				; Branch if not
		bset	#2,v_Back_FM4+ch_Flags(a6)		; Set 'SFX is overriding' bit

.doneoverride:
		tst.b	v_SFX_PSG3+ch_Flags(a6)			; Is track playing?
		bpl.s	.locret					; Branch if not
		bset	#2,v_Back_PSG3+ch_Flags(a6)		; Set 'SFX is overriding' bit
		ori.b	#$1F,d4					; Command to silence channel
		move.b	d4,(psg_input).l
		bchg	#5,d4					; Command to silence noise channel
		move.b	d4,(psg_input).l

.locret:
		rts

; ---------------------------------------------------------------------------
; Unused RAM addresses for FM and PSG channel variables used by the Special SFX
; ---------------------------------------------------------------------------
; The first block would have been used for overriding the music tracks
; as they have a lower priority, just as they are in Sound_PlaySFX
; The third block would be used to set up the Special SFX
; The second block, however, is for the SFX tracks, which have a higher priority
; and would be checked for if they're currently playing
; If they are, then the third block would be used again, this time to mark
; the new tracks as 'currently playing'

; These were actually used in Moonwalker's driver (and other SMPS 68k Type 1a drivers)

; BGMFM4PSG3RAM:
;SpecSFX_BGMChannelRAM:
		dc.l (v_snddriver_ram+v_music_FM4)&$FFFFFF
		dc.l (v_snddriver_ram+v_music_PSG3)&$FFFFFF
; SFXFM4PSG3RAM:
;SpecSFX_SFXChannelRAM:
		dc.l (v_snddriver_ram+v_SFX_FM4)&$FFFFFF
		dc.l (v_snddriver_ram+v_SFX_PSG3)&$FFFFFF
; SpecialSFXFM4PSG3RAM:
;SpecSFX_SpecSFXChannelRAM:
		dc.l (v_snddriver_ram+v_Back_FM4)&$FFFFFF
		dc.l (v_snddriver_ram+v_Back_PSG3)&$FFFFFF

; ---------------------------------------------------------------------------
; Subroutine to stop sfx
; ---------------------------------------------------------------------------

StopSFX:
		clr.b	v_priority(a6)				; Clear priority
		lea	v_sfx_ram(a6),a5
		moveq	#((v_sfx_ram_end-v_sfx_ram)/ch_Size)-1,d7 ; 3 FM + 3 PSG tracks (SFX)

.trackloop:
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.w	.nexttrack				; Branch if not
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		moveq	#0,d3
		move.b	ch_Type(a5),d3				; Get voice control bits
		bmi.s	.trackpsg				; Branch if PSG
		jsr	FMNoteOff(pc)
		cmpi.b	#4,d3					; Is this FM4?
		bne.s	.getfmpointer				; Branch if not
		tst.b	v_Back_FM4+ch_Flags(a6)			; Is special SFX playing?
		bpl.s	.getfmpointer				; Branch if not
		; DANGER! there is a missing 'movea.l	a5,a3' here, without which the
		; code is broken. It is dangerous to do a fade out when a GHZ waterfall
		; is playing its sound!
		lea	v_Back_FM4(a6),a5
		movea.l	v_back_voice_table(a6),a1		; Get special voice pointer
		bra.s	.gotfmpointer
; ===========================================================================

.getfmpointer:
		subq.b	#2,d3					; SFX only has FM3 and up
		lsl.b	#2,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	v_music_voice_table(a6),a1		; Get music voice pointer

.gotfmpointer:
		bclr	#chf_Mask,(a5)				; Clear 'SFX is overriding' bit (ch_Flags)
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		move.b	ch_Voice(a5),d0				; Current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5
		bra.s	.nexttrack
; ===========================================================================

.trackpsg:
		jsr	PSGNoteOff(pc)
		lea	v_Back_PSG3(a6),a0
		cmpi.b	#tPSG4,d3				; Is this a noise channel:
		beq.s	.gotpsgpointer				; Branch if yes
		cmpi.b	#tPSG3,d3				; Is this PSG 3?
		beq.s	.gotpsgpointer				; Branch if yes
		lsr.b	#3,d3
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	(a0,d3.w),a0

.gotpsgpointer:
		bclr	#2,(a0)					; Clear 'SFX is overriding' bit (ch_Flags)
		bset	#1,(a0)					; Set 'track at rest' bit (ch_Flags)
		cmpi.b	#tPSG4,ch_Type(a0)			; Is this a noise channel?
		bne.s	.nexttrack				; Branch if not
		move.b	ch_NoiseMode(a0),(psg_input).l		; Set noise type

.nexttrack:
		adda.w	#ch_Size,a5
		dbf	d7,.trackloop

		rts

; ---------------------------------------------------------------------------
; Subroutine to stop sfx
; ---------------------------------------------------------------------------

StopSpecialSFX:
		lea	v_Back_FM4(a6),a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.fadedfm				; Branch if not
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	.fadedfm				; Branch if not
		jsr	SendFMNoteOff(pc)
		lea	v_music_FM4(a6),a5
		bclr	#chf_Mask,(a5)				; Clear 'SFX is overriding' bit (ch_Flags)
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.fadedfm				; Branch if not
		movea.l	v_music_voice_table(a6),a1		; Voice pointer
		move.b	ch_Voice(a5),d0				; Current voice
		jsr	SetVoice(pc)

.fadedfm:
		lea	v_Back_PSG3(a6),a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.fadedpsg				; Branch if not
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	.fadedpsg				; Return if not
		jsr	SendPSGNoteOff(pc)
		lea	v_music_PSG3(a6),a5
		bclr	#chf_Mask,(a5)				; Clear 'SFX is overriding' bit (ch_Flags)
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.fadedpsg				; Return if not
		cmpi.b	#tPSG4,ch_Type(a5)			; Is this a noise channel?
		bne.s	.fadedpsg				; Return if not
		move.b	ch_NoiseMode(a5),(psg_input).l		; Set noise type

.fadedpsg:
		rts

; ---------------------------------------------------------------------------
; Fade out music
; ---------------------------------------------------------------------------

SoundCmd_Fade:
		jsr	StopSFX(pc)
		jsr	StopSpecialSFX(pc)
		move.b	#3,v_fadeout_delay(a6)			; Set fadeout delay to 3
		move.b	#$28,v_fadeout_counter(a6)		; Set fadeout counter
		clr.b	v_music_DAC+ch_Flags(a6)		; Stop DAC track
		clr.b	f_speedup(a6)				; Disable speed shoes tempo
		rts

; ---------------------------------------------------------------------------
; Subroutine to fade out music
; ---------------------------------------------------------------------------

DoFadeOut:
		move.b	v_fadeout_delay(a6),d0			; Has fadeout delay expired?
		beq.s	.continuefade				; Branch if yes
		subq.b	#1,v_fadeout_delay(a6)
		rts
; ===========================================================================

.continuefade:
		subq.b	#1,v_fadeout_counter(a6)		; Update fade counter
		beq.w	SoundCmd_Stop				; Branch if fade is done
		move.b	#3,v_fadeout_delay(a6)			; Reset fade delay
		lea	v_music_FM_RAM(a6),a5
		moveq	#((v_music_FM_RAM_end-v_music_FM_RAM)/ch_Size)-1,d7 ; 6 FM tracks

.fmloop:
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.nextfm					; Branch if not
		addq.b	#1,ch_Volume(a5)			; Increase volume attenuation
		bpl.s	.sendfmtl				; Branch if still positive
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		bra.s	.nextfm
; ===========================================================================

.sendfmtl:
		jsr	SendVoiceTL(pc)

.nextfm:
		adda.w	#ch_Size,a5
		dbf	d7,.fmloop

		moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d7 ; 3 PSG tracks

.psgloop:
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.nextpsg				; branch if not
		addq.b	#1,ch_Volume(a5)			; Increase volume attenuation
		cmpi.b	#$10,ch_Volume(a5)			; Is it greater than $F?
		blo.s	.sendpsgvol				; Branch if not
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		bra.s	.nextpsg
; ===========================================================================

.sendpsgvol:
		move.b	ch_Volume(a5),d6			; Store new volume attenuation
		jsr	SetPSGVolume(pc)

.nextpsg:
		adda.w	#ch_Size,a5
		dbf	d7,.psgloop

		rts

; ---------------------------------------------------------------------------
; Subroutine to stop FM channels
; ---------------------------------------------------------------------------

FMSilenceAll:
		moveq	#2,d3					; 3 FM channels for each YM2612 parts
		moveq	#$28,d0					; FM key on/off register

.noteoffloop:
		move.b	d3,d1
		jsr	WriteFMI(pc)
		addq.b	#4,d1					; Move to YM2612 part 1
		jsr	WriteFMI(pc)
		dbf	d3,.noteoffloop

		moveq	#$40,d0					; Set TL on FM channels...
		moveq	#$7F,d1					; ... to total attenuation...
		moveq	#2,d4					; ... for all 3 channels...

.channelloop:
		moveq	#3,d3					; ... for all operators on each channel...

.channeltlloop:
		jsr	WriteFMI(pc)				; ... for part 0...
		jsr	WriteFMII(pc)				; ... and part 1.
		addq.w	#4,d0					; Next TL operator
		dbf	d3,.channeltlloop

		subi.b	#$F,d0					; Move to TL operator 1 of next channel
		dbf	d4,.channelloop

		rts

; ---------------------------------------------------------------------------
; Stop music
; ---------------------------------------------------------------------------

SoundCmd_Stop:
		moveq	#$2B,d0					; Enable/disable DAC
		move.b	#$80,d1					; Enable DAC
		jsr	WriteFMI(pc)
		moveq	#$27,d0					; Timers, FM3/FM6 mode
		moveq	#0,d1					; FM3/FM6 normal mode, disable timers
		jsr	WriteFMI(pc)
		movea.l	a6,a0
		; DANGER! This should be clearing all variables and track data, but misses the last $10 bytes of v_Back_PSG3.
		; Remove the '-$10' to fix this.
		move.w	#((v_back_ram_end-v_backup_start-$10)/4)-1,d0 ; Clear $390 bytes: all variables and most track data

.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop

		move.b	#com_Null,v_sound_id(a6)		; set music to $80 (silence)
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll

; ---------------------------------------------------------------------------
; Subroutine to initialise music
; ---------------------------------------------------------------------------

InitMusicPlayback:
		movea.l	a6,a0
		; Save several values
		move.b	v_priority(a6),d1
		move.b	f_has_backup(a6),d2
		move.b	f_speedup(a6),d3
		move.b	v_fadein_counter(a6),d4
		; DANGER! Only v_soundqueue and v_soundqueue+1 are backed up, once again breaking v_soundqueue+2
		move.w	v_soundqueue(a6),d5
		move.w	#((v_music_ram_end-v_backup_start)/4)-1,d0 ; Clear $220 bytes: all variables and music track data

.clearramloop:
		clr.l	(a0)+
		dbf	d0,.clearramloop

		; Restore the values saved above
		move.b	d1,v_priority(a6)
		move.b	d2,f_has_backup(a6)
		move.b	d3,f_speedup(a6)
		move.b	d4,v_fadein_counter(a6)
		move.w	d5,v_soundqueue(a6)
		move.b	#com_Null,v_sound_id(a6)		; set music to $80 (silence)
		; DANGER! This silences ALL channels, even the ones being used
		; by SFX, and not music! .sendfmnoteoff does this already, and
		; doesn't affect SFX channels, either.
		; This should be replaced with an 'rts'.
		jsr	FMSilenceAll(pc)
		bra.w	PSGSilenceAll
		; DANGER! InitMusicPlayback, and Sound_PlayBGM for that matter,
		; don't do a very good job of setting up the music tracks.
		; Tracks that aren't defined in a music file's header don't have
		; their channels defined, meaning .sendfmnoteoff won't silence
		; hardware properly. In combination with removing the above
		; calls to FMSilenceAll/PSGSilenceAll, this will cause hanging
		; notes.
		; To fix this, I suggest using this code, instead of an 'rts':
		;lea	v_music_ram+ch_Type(a6),a1
		;lea	FMDACInitBytes(pc),a2
		;moveq	#((v_music_FMDAC_RAM_end-v_music_FMDAC_RAM)/ch_Size)-1,d1		; 7 DAC/FM tracks
		;bsr.s	.writeloop
		;lea	PSGInitBytes(pc),a2
		;moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d1	; 3 PSG tracks

;.writeloop:
		;move.b	(a2)+,(a1)		; Write track's channel byte
		;lea	ch_Size(a1),a1		; Next track
		;dbf	d1,.writeloop		; Loop for all DAC/FM/PSG tracks

		;rts

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

TempoWait:
		move.b	f_current_tempo(a6),f_tempo_counter(a6)	; Reset main tempo timeout
		lea	v_music_ram+ch_Delay(a6),a0		; note timeout
		moveq	#ch_Size,d0
		moveq	#((v_music_ram_end-v_music_ram)/ch_Size)-1,d1 ; 1 DAC + 6 FM + 3 PSG tracks

.tempoloop:
		addq.b	#1,(a0)					; Delay note by 1 frame
		adda.w	d0,a0					; Advance to next track
		dbf	d1,.tempoloop

		rts

; ---------------------------------------------------------------------------
; Speed	up music
; ---------------------------------------------------------------------------

SoundCmd_Speedup:
		tst.b	f_has_backup(a6)
		bne.s	.speedup_1up
		move.b	v_tempo_speed(a6),f_current_tempo(a6)
		move.b	v_tempo_speed(a6),f_tempo_counter(a6)
		move.b	#$80,f_speedup(a6)
		rts
; ===========================================================================

.speedup_1up:
		move.b	v_backup_ram+v_tempo_speed(a6),v_backup_ram+f_current_tempo(a6)
		move.b	v_backup_ram+v_tempo_speed(a6),v_backup_ram+f_tempo_counter(a6)
		move.b	#$80,v_backup_ram+f_speedup(a6)
		rts

; ---------------------------------------------------------------------------
; Change music back to normal speed
; ---------------------------------------------------------------------------

SoundCmd_Slowdown:
		tst.b	f_has_backup(a6)
		bne.s	.slowdown_1up
		move.b	v_tempo_main(a6),f_current_tempo(a6)
		move.b	v_tempo_main(a6),f_tempo_counter(a6)
		clr.b	f_speedup(a6)
		rts
; ===========================================================================

.slowdown_1up:
		move.b	v_backup_ram+v_tempo_main(a6),v_backup_ram+f_current_tempo(a6)
		move.b	v_backup_ram+v_tempo_main(a6),v_backup_ram+f_tempo_counter(a6)
		clr.b	v_backup_ram+f_speedup(a6)
		rts

; ---------------------------------------------------------------------------
; Subroutine to fade in music
; ---------------------------------------------------------------------------

DoFadeIn:
		tst.b	v_fadein_delay(a6)			; Has fadein delay expired?
		beq.s	.continuefade				; Branch if yes
		subq.b	#1,v_fadein_delay(a6)
		rts
; ===========================================================================

.continuefade:
		tst.b	v_fadein_counter(a6)			; Is fade done?
		beq.s	.fadedone				; Branch if yes
		subq.b	#1,v_fadein_counter(a6)			; Update fade counter
		move.b	#2,v_fadein_delay(a6)			; Reset fade delay
		lea	v_music_FM_RAM(a6),a5
		moveq	#((v_music_FM_RAM_end-v_music_FM_RAM)/ch_Size)-1,d7 ; 6 FM tracks

.fmloop:
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.nextfm					; Branch if not
		subq.b	#1,ch_Volume(a5)			; Reduce volume attenuation
		jsr	SendVoiceTL(pc)

.nextfm:
		adda.w	#ch_Size,a5
		dbf	d7,.fmloop
		moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d7 ; 3 PSG tracks

.psgloop:
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.nextpsg				; Branch if not
		subq.b	#1,ch_Volume(a5)			; Reduce volume attenuation
		move.b	ch_Volume(a5),d6			; Get value
		cmpi.b	#$10,d6					; Is it is < $10?
		blo.s	.sendpsgvol				; Branch if yes
		moveq	#$F,d6					; Limit to $F (maximum attenuation)

.sendpsgvol:
		jsr	SetPSGVolume(pc)

.nextpsg:
		adda.w	#ch_Size,a5
		dbf	d7,.psgloop
		rts
; ===========================================================================

.fadedone:
		bclr	#2,v_music_DAC+ch_Flags(a6)		; Clear 'SFX overriding' bit
		clr.b	f_fadein_flag(a6)			; Stop fadein
		rts

; ---------------------------------------------------------------------------
; Subroutine to play FM note
; ---------------------------------------------------------------------------

FMNoteOn:
		btst	#chf_Rest,(a5)				; Is track resting? (ch_Flags)
		bne.s	.locret					; Return if so
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.locret					; Return if so
		moveq	#$28,d0					; Note on/off register
		move.b	ch_Type(a5),d1				; Get channel bits
		ori.b	#$F0,d1					; Note on on all operators
		bra.w	WriteFMI
; ===========================================================================

.locret:
		rts

; ---------------------------------------------------------------------------
; Subroutine to stop FM note
; ---------------------------------------------------------------------------

FMNoteOff:
		btst	#chf_Tie,(a5)				; Is 'do not attack next note' set? (ch_Flags)
		bne.s	locret_72714				; Return if yes
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	locret_72714				; Return if yes

SendFMNoteOff:
		moveq	#$28,d0					; Note on/off register
		move.b	ch_Type(a5),d1				; Note off to this channel
		bra.w	WriteFMI
; ===========================================================================

locret_72714:
		rts

; ---------------------------------------------------------------------------
; Subroutine to write to FM channel
; ---------------------------------------------------------------------------

WriteFMIorIIMain:
		btst	#chf_Mask,(a5)				; Is track being overriden by sfx? (ch_Flags)
		bne.s	.locret					; Return if yes
		bra.w	WriteFMIorII
; ===========================================================================

.locret:
		rts

WriteFMIorII:
		btst	#2,ch_Type(a5)				; Is this bound for part I or II?
		bne.s	WriteFMIIPart				; Branch if for part II
		add.b	ch_Type(a5),d0				; Add in voice control bits

; Strangely, despite this driver being SMPS 68k Type 1b,
; WriteFMI and WriteFMII are the Type 1a versions.
; In Sonic 1's prototype, they were the Type 1b versions.
; I wonder why they were changed?

WriteFMI:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; Is FM busy?
		bne.s	WriteFMI				; Loop if so
		move.b	d0,(ym2612_a0).l
		nop
		nop
		nop

.waitloop:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; Is FM busy?
		bne.s	.waitloop				; Loop if so

		move.b	d1,(ym2612_d0).l
		rts

; ===========================================================================

WriteFMIIPart:
		move.b	ch_Type(a5),d2				; Get voice control bits
		bclr	#2,d2					; Clear chip toggle
		add.b	d2,d0					; Add in to destination register

WriteFMII:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; Is FM busy?
		bne.s	WriteFMII				; Loop if so
		move.b	d0,(ym2612_a1).l
		nop
		nop
		nop

.waitloop:
		move.b	(ym2612_a0).l,d2
		btst	#7,d2					; Is FM busy?
		bne.s	.waitloop				; Loop if so

		move.b	d1,(ym2612_d1).l
		rts

; ---------------------------------------------------------------------------
; FM Note Values: b-0 to a#8
; ---------------------------------------------------------------------------

GenNoteFM:	macro	const, psgfq, fmfq
		if strlen("\fmfq")>0
		dc.w \fmfq					; add FM note value into ROM
		endc
		endm

FMFrequencies:
		DefineNotes	GenNoteFM			; generate note constants

; ---------------------------------------------------------------------------
; Subroutine to update PSG channel
; ---------------------------------------------------------------------------

PSGUpdateTrack:
		subq.b	#1,ch_Delay(a5)				; Update note timeout
		bne.s	.notegoing
		bclr	#chf_Tie,(a5)				; Clear 'do not attack note' bit (ch_Flags)
		jsr	PSGDoNext(pc)
		jsr	PSGDoNoteOn(pc)
		bra.w	PSGDoVolFX
; ===========================================================================

.notegoing:
		jsr	NoteTimeoutUpdate(pc)
		jsr	PSGUpdateVolFX(pc)
		jsr	DoModulation(pc)
		jsr	PSGUpdateFreq(pc)			; It would be better if this were a jmp and the rts was removed
		rts
; ===========================================================================

PSGDoNext:
		bclr	#chf_Rest,(a5)				; Clear 'track at rest' bit (ch_Flags)
		movea.l	ch_Data(a5),a4				; Get track data pointer

.noteloop:
		moveq	#0,d5
		move.b	(a4)+,d5				; Get byte from track
		cmpi.b	#_firstCom,d5				; Is it a coord. flag?
		blo.s	.gotnote				; Branch if not
		jsr	SongCommand(pc)
		bra.s	.noteloop
; ===========================================================================

.gotnote:
		tst.b	d5					; Is it a note?
		bpl.s	.gotduration				; Branch if not
		jsr	PSGSetFreq(pc)
		move.b	(a4)+,d5				; Get another byte
		tst.b	d5					; Is it a duration?
		bpl.s	.gotduration				; Branch if yes
		subq.w	#1,a4					; Put byte back
		bra.w	FinishTrackUpdate
; ===========================================================================

.gotduration:
		jsr	SetDuration(pc)
		bra.w	FinishTrackUpdate
; ===========================================================================

PSGSetFreq:
		subi.b	#_firstNote,d5				; Convert to 0-based index
		bcs.s	.restpsg				; If $80, put track at rest
		add.b	ch_Transpose(a5),d5			; Add in channel transposition
		andi.w	#$7F,d5					; Clear high byte and sign bit
		lsl.w	#1,d5
		lea	PSGFrequencies(pc),a0
		move.w	(a0,d5.w),ch_Freq(a5)			; Set new frequency
		bra.w	FinishTrackUpdate
; ===========================================================================

.restpsg:
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		move.w	#-1,ch_Freq(a5)				; Invalidate note frequency
		jsr	FinishTrackUpdate(pc)
		bra.w	PSGNoteOff
; ===========================================================================

PSGDoNoteOn:
		move.w	ch_Freq(a5),d6				; Get note frequency
		bmi.s	PSGSetRest				; If invalid, branch
; ===========================================================================

PSGUpdateFreq:
		move.b	ch_Detune(a5),d0			; Get detune value
		ext.w	d0
		add.w	d0,d6					; Add to frequency
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.locret					; Return if yes
		btst	#chf_Rest,(a5)				; Is track at rest? (ch_Flags)
		bne.s	.locret					; Return if yes
		move.b	ch_Type(a5),d0				; Get channel bits
		cmpi.b	#tPSG4,d0				; Is it a noise channel?
		bne.s	.notnoise				; Branch if not
		move.b	#tPSG3,d0				; Use PSG 3 channel bits

.notnoise:
		move.w	d6,d1
		andi.b	#$F,d1					; Low nibble of frequency
		or.b	d1,d0					; Latch frequency data to channel
		lsr.w	#4,d6					; Get upper 6 bits of frequency
		andi.b	#$3F,d6					; Send to latched channel
		move.b	d0,(psg_input).l
		move.b	d6,(psg_input).l

.locret:
		rts

; ===========================================================================

PSGSetRest:
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		rts
; ===========================================================================

PSGUpdateVolFX:
		tst.b	ch_Voice(a5)				; Test envelope
		beq.w	locret_7298A				; Return if it is zero

PSGDoVolFX:	; This can actually be made a bit more efficient, see the comments for more
		move.b	ch_Volume(a5),d6			; Get volume
		moveq	#0,d0
		move.b	ch_Voice(a5),d0				; Get envelope
		beq.s	SetPSGVolume
		movea.l	(Go_Envelopes).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	ch_VolEnvPos(a5),d0			; Get volume envelope index
		move.b	(a0,d0.w),d0				; Volume envelope value
		addq.b	#1,ch_VolEnvPos(a5)			; Increment volume envelope index
		btst	#7,d0					; Is volume envelope value negative?	; note, this line and the line below are redundant
		beq.s	.gotflutter				; Branch if not				; especially because Sonic 1 only checks for 1 command
		cmpi.b	#evcHold,d0				; Is it the terminator?
		beq.s	VolEnvCmd_Hold				; If so, branch

.gotflutter:
		add.w	d0,d6					; Add volume envelope value to volume
		cmpi.b	#$10,d6					; Is volume $10 or higher?
		blo.s	SetPSGVolume				; Branch if not
		moveq	#$F,d6					; Limit to silence and fall through
; ===========================================================================

SetPSGVolume:
		btst	#chf_Rest,(a5)				; Is track at rest? (ch_Flags)
		bne.s	locret_7298A				; Return if so
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	locret_7298A				; Return if so
		btst	#chf_Tie,(a5)				; Is track set to not attack next note? (ch_Flags)
		bne.s	PSGCheckNoteTimeout			; Branch if yes

PSGSendVolume:
		or.b	ch_Type(a5),d6				; Add in track selector bits
		addi.b	#$10,d6					; Mark it as a volume command
		move.b	d6,(psg_input).l

locret_7298A:
		rts
; ===========================================================================

PSGCheckNoteTimeout:
		tst.b	ch_SavedGate(a5)			; Is note timeout on?
		beq.s	PSGSendVolume				; Branch if not
		tst.b	ch_Gate(a5)				; Has note timeout expired?
		bne.s	PSGSendVolume				; Branch if not
		rts

; ===========================================================================

VolEnvCmd_Hold:
		subq.b	#1,ch_VolEnvPos(a5)			; Decrement volume envelope index
		rts
; ===========================================================================

PSGNoteOff:
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	locret_729B4				; Return if so

SendPSGNoteOff:
		move.b	ch_Type(a5),d0				; PSG channel to change
		ori.b	#$1F,d0					; Maximum volume attenuation
		move.b	d0,(psg_input).l
		; DANGER! If InitMusicPlayback doesn't silence all channels, there's the
		; risk of music accidentally playing noise because it can't detect if
		; the PSG4/noise channel needs muting on track initialisation.
		; S&K's driver fixes it by doing this:
		;cmpi.b	#tPSG3 | $1F,d0				; Are stopping PSG3?
		;bne.s	locret_729B4
		;move.b	#tPSG4 | $1F,(psg_input).l		; If so, stop noise channel while we're at it

locret_729B4:
		rts
; ===========================================================================

PSGSilenceAll:
		lea	(psg_input).l,a0
		move.b	#tPSG1 | $1F,(a0)			; Silence PSG 1
		move.b	#tPSG2 | $1F,(a0)			; Silence PSG 2
		move.b	#tPSG3 | $1F,(a0)			; Silence PSG 3
		move.b	#tPSG4 | $1F,(a0)			; Silence noise channel
		rts

; ===========================================================================

GenNotePSG:	macro	const, psgfq, fmfq
		if strlen("\psgfq")>0
		dc.w \psgfq					; add PSG note value into ROM
		endc
		endm

PSGFrequencies:
		DefineNotes	GenNotePSG			; generate note constants

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

SongCommand:
		subi.w	#_firstCom,d5
		lsl.w	#2,d5
		jmp	SongCommandTable(pc,d5.w)

; ===========================================================================

GenComJump:	macro	name
		bra.w	SongCom_\name				; jump to the command code
		endm

SongCommandTable:
		TrackCommand	GenComJump			; generate jumps for all commands

; ===========================================================================

SongCom_Pan:
		move.b	(a4)+,d1				; New AMS/FMS/panning value
		tst.b	ch_Type(a5)				; Is this a PSG track?
		bmi.s	locret_72AEA				; Return if yes
		move.b	ch_Pan(a5),d0				; Get current AMS/FMS/panning
		andi.b	#$37,d0					; Retain bits 0-2, 3-4 if set
		or.b	d0,d1					; Mask in new value
		move.b	d1,ch_Pan(a5)				; Store value
		move.b	#$B4,d0					; Command to set AMS/FMS/panning
		bra.w	WriteFMIorIIMain
; ===========================================================================

locret_72AEA:
		rts
; ===========================================================================

SongCom_DetuneSet:
		move.b	(a4)+,ch_Detune(a5)			; Set detune value
		rts
; ===========================================================================

SongCom_Timing:
		move.b	(a4)+,v_timing(a6)			; Set otherwise unused communication byte to parameter
		rts
; ===========================================================================

SongCom_Ret:
		moveq	#0,d0
		move.b	ch_StackPtr(a5),d0			; Track stack pointer
		movea.l	(a5,d0.w),a4				; Set track return address
		move.l	#0,(a5,d0.w)				; Set 'popped' value to zero
		addq.w	#2,a4					; Skip jump target address from gosub flag
		addq.b	#4,d0					; Actually 'pop' value
		move.b	d0,ch_StackPtr(a5)			; Set new stack pointer
		rts
; ===========================================================================

SongCom_RestoreSong:
		movea.l	a6,a0
		lea	v_backup_ram(a6),a1
		move.w	#((v_music_ram_end-v_backup_start)/4)-1,d0 ; $220 bytes to restore: all variables and music track data

.restoreramloop:
		move.l	(a1)+,(a0)+
		dbf	d0,.restoreramloop

		bset	#2,v_music_DAC+ch_Flags(a6)		; Set 'SFX overriding' bit
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	v_fadein_counter(a6),d6			; If fade already in progress, this adjusts track volume accordingly
		moveq	#((v_music_FM_RAM_end-v_music_FM_RAM)/ch_Size)-1,d7 ; 6 FM tracks
		lea	v_music_FM_RAM(a6),a5

.fmloop:
		btst	#chf_Enable,(a5)			; Is track playing? (ch_Flags)
		beq.s	.nextfm					; Branch if not
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		add.b	d6,ch_Volume(a5)			; Apply current volume fade-in
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	.nextfm					; Branch if yes
		moveq	#0,d0
		move.b	ch_Voice(a5),d0				; Get voice
		movea.l	v_music_voice_table(a6),a1		; Voice pointer
		jsr	SetVoice(pc)

.nextfm:
		adda.w	#ch_Size,a5
		dbf	d7,.fmloop

		moveq	#((v_music_PSG_RAM_end-v_music_PSG_RAM)/ch_Size)-1,d7 ; 3 PSG tracks

.psgloop:
		btst	#chf_Enable,(a5)			; Is track playing? (ch_Flags)
		beq.s	.nextpsg				; Branch if not
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		jsr	PSGNoteOff(pc)
		add.b	d6,ch_Volume(a5)			; Apply current volume fade-in

.nextpsg:
		adda.w	#ch_Size,a5
		dbf	d7,.psgloop

		movea.l	a3,a5
		move.b	#$80,f_fadein_flag(a6)			; Trigger fade-in
		move.b	#$28,v_fadein_counter(a6)		; Fade-in delay
		clr.b	f_has_backup(a6)
		startZ80
		addq.w	#8,sp					; Tamper return value so we don't return to caller
		rts
; ===========================================================================

SongCom_ChannelTick:
		move.b	(a4)+,ch_Tick(a5)			; Set tempo divider on current track
		rts
; ===========================================================================

SongCom_VolAddFM:
		move.b	(a4)+,d0				; Get parameter
		add.b	d0,ch_Volume(a5)			; Add to current volume
		bra.w	SendVoiceTL
; ===========================================================================

SongCom_Tie:
		bset	#chf_Tie,(a5)				; Set 'do not attack next note' bit (ch_Flags)
		rts
; ===========================================================================

SongCom_Gate:
		move.b	(a4),ch_Gate(a5)			; Note fill timeout
		move.b	(a4)+,ch_SavedGate(a5)			; Note fill master
		rts
; ===========================================================================

SongCom_TransAdd:
		move.b	(a4)+,d0				; Get parameter
		add.b	d0,ch_Transpose(a5)			; Add to transpose value
		rts
; ===========================================================================

SongCom_TempoSet:
		move.b	(a4),f_current_tempo(a6)		; Set main tempo
		move.b	(a4)+,f_tempo_counter(a6)		; And reset timeout (!)
		rts
; ===========================================================================

SongCom_SongTick:
		lea	v_music_ram(a6),a0
		move.b	(a4)+,d0				; Get new tempo divider
		moveq	#ch_Size,d1
		moveq	#((v_music_ram_end-v_music_ram)/ch_Size)-1,d2 ; 1 DAC + 6 FM + 3 PSG tracks

.trackloop:
		move.b	d0,ch_Tick(a0)				; Set track's tempo divider
		adda.w	d1,a0
		dbf	d2,.trackloop

		rts
; ===========================================================================

SongCom_VolAddPSG:
		move.b	(a4)+,d0				; Get volume change
		add.b	d0,ch_Volume(a5)			; Apply it
		rts
; ===========================================================================

SongCom_ClearPush:
		clr.b	f_push_playing(a6)			; Allow push sound to be played once more
		rts
; ===========================================================================

SongCom_EndBack:
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		bclr	#chf_Tie,(a5)				; Clear 'do not attack next note' bit (ch_Flags)
		jsr	FMNoteOff(pc)
		tst.b	v_SFX_FM4+ch_Flags(a6)			; Is SFX using FM4?
		bmi.s	.locexit				; Branch if yes
		movea.l	a5,a3
		lea	v_music_FM4(a6),a5
		movea.l	v_music_voice_table(a6),a1		; Voice pointer
		bclr	#chf_Mask,(a5)				; Clear 'SFX is overriding' bit (ch_Flags)
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		move.b	ch_Voice(a5),d0				; Current voice
		jsr	SetVoice(pc)
		movea.l	a3,a5

.locexit:
		addq.w	#8,sp					; Tamper with return value so we don't return to caller
		rts
; ===========================================================================

SongCom_Voice:
		moveq	#0,d0
		move.b	(a4)+,d0				; Get new voice
		move.b	d0,ch_Voice(a5)				; Store it
		btst	#chf_Mask,(a5)				; Is SFX overriding this track? (ch_Flags)
		bne.w	locret_72CAA				; Return if yes
		movea.l	v_music_voice_table(a6),a1		; Music voice pointer
		tst.b	v_channel_mode(a6)			; Are we updating a music track?
		beq.s	SetVoice				; If yes, branch
		movea.l	ch_VoiceTable(a5),a1			; SFX track voice pointer
		tst.b	v_channel_mode(a6)			; Are we updating a SFX track?
		bmi.s	SetVoice				; If yes, branch
		movea.l	v_back_voice_table(a6),a1		; Special SFX voice pointer

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

SetVoice:
		subq.w	#1,d0
		bmi.s	.havevoiceptr
		move.w	#25,d1

.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply

.havevoiceptr:
		move.b	(a1)+,d1				; feedback/algorithm
		move.b	d1,ch_FeedbackAlgo(a5)			; Save it to track RAM
		move.b	d1,d4
		move.b	#$B0,d0					; Command to write feedback/algorithm
		jsr	WriteFMIorII(pc)
		lea	FMInstrumentOperatorTable(pc),a2
		moveq	#(FMInstrumentOperatorTable_End-FMInstrumentOperatorTable)-1,d3 ; Don't want to send TL yet

.sendvoiceloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	WriteFMIorII(pc)
		dbf	d3,.sendvoiceloop

		moveq	#(FMInstrumentTLTable_End-FMInstrumentTLTable)-1,d5
		andi.w	#7,d4					; Get algorithm
		move.b	FMSlotMask(pc,d4.w),d4			; Get slot mask for algorithm
		move.b	ch_Volume(a5),d3			; Track volume attenuation

.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4					; Is bit set for this operator in the mask?
		bcc.s	.sendtl					; Branch if not
		add.b	d3,d1					; Include additional attenuation

.sendtl:
		jsr	WriteFMIorII(pc)
		dbf	d5,.sendtlloop

		move.b	#$B4,d0					; Register for AMS/FMS/Panning
		move.b	ch_Pan(a5),d1				; Value to send
		jsr	WriteFMIorII(pc)			; (It would be better if this were a jmp)

locret_72CAA:
		rts

; ===========================================================================
; byte_72CAC:
FMSlotMask:	dc.b 8,	8, 8, 8, $A, $E, $E, $F

; ---------------------------------------------------------------------------
; Subroutine to 
; ---------------------------------------------------------------------------

SendVoiceTL:
		btst	#chf_Mask,(a5)				; Is SFX overriding? (ch_Flags)
		bne.s	.locret					; Return if so
		moveq	#0,d0
		move.b	ch_Voice(a5),d0				; Current voice
		movea.l	v_music_voice_table(a6),a1		; Voice pointer
		tst.b	v_channel_mode(a6)
		beq.s	.gotvoiceptr
		; DANGER! This uploads the wrong voice! It should have been a5 instead
		; of a6!
		movea.l	ch_VoiceTable(a6),a1
		tst.b	v_channel_mode(a6)
		bmi.s	.gotvoiceptr
		movea.l	v_back_voice_table(a6),a1

.gotvoiceptr:
		subq.w	#1,d0
		bmi.s	.gotvoice
		move.w	#25,d1

.voicemultiply:
		adda.w	d1,a1
		dbf	d0,.voicemultiply

.gotvoice:
		adda.w	#21,a1					; Want TL
		lea	FMInstrumentTLTable(pc),a2
		move.b	ch_FeedbackAlgo(a5),d0			; Get feedback/algorithm
		andi.w	#7,d0					; Want only algorithm
		move.b	FMSlotMask(pc,d0.w),d4			; Get slot mask
		move.b	ch_Volume(a5),d3			; Get track volume attenuation
		bmi.s	.locret					; If negative, stop
		moveq	#(FMInstrumentTLTable_End-FMInstrumentTLTable)-1,d5

.sendtlloop:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4					; Is bit set for this operator in the mask?
		bcc.s	.senttl					; Branch if not
		add.b	d3,d1					; Include additional attenuation
		bcs.s	.senttl					; Branch on overflow
		jsr	WriteFMIorII(pc)

.senttl:
		dbf	d5,.sendtlloop

.locret:
		rts

; ===========================================================================
FMInstrumentOperatorTable:
		dc.b  $30					; Detune/multiple operator 1
		dc.b  $38					; Detune/multiple operator 3
		dc.b  $34					; Detune/multiple operator 2
		dc.b  $3C					; Detune/multiple operator 4
		dc.b  $50					; Rate scalling/attack rate operator 1
		dc.b  $58					; Rate scalling/attack rate operator 3
		dc.b  $54					; Rate scalling/attack rate operator 2
		dc.b  $5C					; Rate scalling/attack rate operator 4
		dc.b  $60					; Amplitude modulation/first decay rate operator 1
		dc.b  $68					; Amplitude modulation/first decay rate operator 3
		dc.b  $64					; Amplitude modulation/first decay rate operator 2
		dc.b  $6C					; Amplitude modulation/first decay rate operator 4
		dc.b  $70					; Secondary decay rate operator 1
		dc.b  $78					; Secondary decay rate operator 3
		dc.b  $74					; Secondary decay rate operator 2
		dc.b  $7C					; Secondary decay rate operator 4
		dc.b  $80					; Secondary amplitude/release rate operator 1
		dc.b  $88					; Secondary amplitude/release rate operator 3
		dc.b  $84					; Secondary amplitude/release rate operator 2
		dc.b  $8C					; Secondary amplitude/release rate operator 4
	FMInstrumentOperatorTable_End:

FMInstrumentTLTable:
		dc.b  $40					; Total level operator 1
		dc.b  $48					; Total level operator 3
		dc.b  $44					; Total level operator 2
		dc.b  $4C					; Total level operator 4
	FMInstrumentTLTable_End:
; ===========================================================================

SongCom_Vib:
		bset	#chf_Vib,(a5)				; Turn on modulation (ch_Flags)
		move.l	a4,ch_VibPtr(a5)			; Save pointer to modulation data
		move.b	(a4)+,ch_VibDelay(a5)			; Modulation delay
		move.b	(a4)+,ch_VibSpeed(a5)			; Modulation speed
		move.b	(a4)+,ch_VibOff(a5)			; Modulation delta
		move.b	(a4)+,d0				; Modulation steps...
		lsr.b	#1,d0					; ... divided by 2...
		move.b	d0,ch_VibSteps(a5)			; ... before being stored
		clr.w	ch_VibFreq(a5)				; Total accumulated modulation frequency change
		rts
; ===========================================================================

SongCom_VibOn:
		bset	#chf_Vib,(a5)				; Turn on modulation (ch_Flags)
		rts
; ===========================================================================

SongCom_End:
		bclr	#chf_Enable,(a5)			; Stop track (ch_Flags)
		bclr	#chf_Tie,(a5)				; Clear 'do not attack next note' bit (ch_Flags)
		tst.b	ch_Type(a5)				; Is this a PSG track?
		bmi.s	.stoppsg				; Branch if yes
		tst.b	f_updating_dac(a6)			; Is this the DAC we are updating?
		bmi.w	.locexit				; Exit if yes
		jsr	FMNoteOff(pc)
		bra.s	.stoppedchannel
; ===========================================================================

.stoppsg:
		jsr	PSGNoteOff(pc)

.stoppedchannel:
		tst.b	v_channel_mode(a6)			; Are we updating SFX?
		bpl.w	.locexit				; Exit if not
		clr.b	v_priority(a6)				; Clear priority
		moveq	#0,d0
		move.b	ch_Type(a5),d0				; Get voice control bits
		bmi.s	.getpsgptr				; Branch if PSG
		lea	SFX_BGMChannelRAM(pc),a0
		movea.l	a5,a3
		cmpi.b	#4,d0					; Is this FM4?
		bne.s	.getpointer				; Branch if not
		tst.b	v_Back_FM4+ch_Flags(a6)			; Is special SFX playing?
		bpl.s	.getpointer				; Branch if not
		lea	v_Back_FM4(a6),a5
		movea.l	v_back_voice_table(a6),a1		; Get voice pointer
		bra.s	.gotpointer
; ===========================================================================

.getpointer:
		subq.b	#2,d0					; SFX can only use FM3 and up
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	(a5)					; Is track playing? (ch_Flags)
		bpl.s	.novoiceupd				; Branch if not
		movea.l	v_music_voice_table(a6),a1		; Get voice pointer

.gotpointer:
		bclr	#chf_Mask,(a5)				; Clear 'SFX overriding' bit (ch_Flags)
		bset	#chf_Rest,(a5)				; Set 'track at rest' bit (ch_Flags)
		move.b	ch_Voice(a5),d0				; Current voice
		jsr	SetVoice(pc)

.novoiceupd:
		movea.l	a3,a5
		bra.s	.locexit
; ===========================================================================

.getpsgptr:
		lea	v_Back_PSG3(a6),a0
		tst.b	(a0)					; Is track playing? (ch_Flags)
		bpl.s	.getchannelptr				; Branch if not
		cmpi.b	#tPSG4,d0				; Is it the noise channel?
		beq.s	.gotchannelptr				; Branch if yes
		cmpi.b	#tPSG3,d0				; Is it PSG 3?
		beq.s	.gotchannelptr				; Branch if yes

.getchannelptr:
		lea	SFX_BGMChannelRAM(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

.gotchannelptr:
		bclr	#2,(a0)					; Clear 'SFX overriding' bit (ch_Flags)
		bset	#1,(a0)					; Set 'track at rest' bit (ch_Flags)
		cmpi.b	#tPSG4,ch_Type(a0)			; Is this a noise pointer?
		bne.s	.locexit				; Branch if not
		move.b	ch_NoiseMode(a0),(psg_input).l		; Set noise mode

.locexit:
		addq.w	#8,sp					; Tamper with return value so we don't go back to caller
		rts
; ===========================================================================

SongCom_NoiseSet:
		move.b	#tPSG4,ch_Type(a5)			; Turn channel into noise channel
		move.b	(a4)+,ch_NoiseMode(a5)			; Save noise mode
		btst	#chf_Mask,(a5)				; Is track being overridden? (ch_Flags)
		bne.s	.locret					; Return if yes
		move.b	-1(a4),(psg_input).l			; Set mode

.locret:
		rts
; ===========================================================================

SongCom_VibOff:
		bclr	#chf_Vib,(a5)				; Disable modulation (ch_Flags)
		rts
; ===========================================================================

SongCom_Env:
		move.b	(a4)+,ch_Voice(a5)			; Set current envelope
		rts
; ===========================================================================

SongCom_Jump:
		move.b	(a4)+,d0				; High byte of offset
		lsl.w	#8,d0					; Shift it into place
		move.b	(a4)+,d0				; Low byte of offset
		adda.w	d0,a4					; Add to current position
		subq.w	#1,a4					; Put back one byte
		rts
; ===========================================================================

SongCom_Loop:
		moveq	#0,d0
		move.b	(a4)+,d0				; Loop index
		move.b	(a4)+,d1				; Repeat count
		tst.b	ch_LoopCounter(a5,d0.w)			; Has this loop already started?
		bne.s	.loopexists				; Branch if yes
		move.b	d1,ch_LoopCounter(a5,d0.w)		; Initialize repeat count

.loopexists:
		subq.b	#1,ch_LoopCounter(a5,d0.w)		; Decrease loop's repeat count
		bne.s	SongCom_Jump				; If nonzero, branch to target
		addq.w	#2,a4					; Skip target address
		rts
; ===========================================================================

SongCom_Call:
		moveq	#0,d0
		move.b	ch_StackPtr(a5),d0			; Current stack pointer
		subq.b	#4,d0					; Add space for another target
		move.l	a4,(a5,d0.w)				; Put in current address (*before* target for jump!)
		move.b	d0,ch_StackPtr(a5)			; Store new stack pointer
		bra.s	SongCom_Jump
; ===========================================================================

SongCom_Release34:
		move.b	#$88,d0					; D1L/RR of Operator 3
		move.b	#$F,d1					; Loaded with fixed value (max RR, 1TL)
		jsr	WriteFMI(pc)
		move.b	#$8C,d0					; D1L/RR of Operator 4
		move.b	#$F,d1					; Loaded with fixed value (max RR, 1TL)
		bra.w	WriteFMI
