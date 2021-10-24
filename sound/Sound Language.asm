; ===========================================================================
; ---------------------------------------------------------------------------
; Equates for various commands
; ---------------------------------------------------------------------------

	if def(com_Tie)
sTie		equ com_Tie				; define the tie command
	endc

	if def(com_Hold)
sHold		equ com_Hold				; define the hold command
	endc

; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for defining the command values
; ---------------------------------------------------------------------------

PutTrackCom	macro name
	if ~def(com_\name)
		inform 2, "Song uses command s\name\, but it was not defined!"
	endc

	if com_\name > $FF				; check for multi-byte commands
		dc.b com_\name >> 8
	endc

	dc.b com_\name & $FF
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Macros for song commands
; ---------------------------------------------------------------------------

sPanNone	equ $00					; set panning to no speaker
sPanRight	equ $40					; set panning to the right speaker
sPanLeft	equ $80					; set panning to the left speaker
sPanCenter	equ $C0					; set panning to both speakers

sPan		macro value
		PutTrackCom	Pan			; add the command byte
		dc.b \value				; add the panning value
	endm
; ---------------------------------------------------------------------------

sDetuneSet	macro value
		PutTrackCom	DetuneSet		; add the command byte
		dc.b \value				; add the detune value
	endm
; ---------------------------------------------------------------------------

sTiming		macro value
		PutTrackCom	Timing			; add the command byte
		dc.b \value				; add the timing value
	endm
; ---------------------------------------------------------------------------

sRet		macro
		PutTrackCom	Ret			; add the command byte
	endm
; ---------------------------------------------------------------------------

sRestoreSong	macro
		PutTrackCom	RestoreSong		; add the command byte
	endm
; ---------------------------------------------------------------------------

sChannelTick	macro value
		PutTrackCom	ChannelTick		; add the command byte
		dc.b \value				; add the tick value
	endm
; ---------------------------------------------------------------------------

sVolAddFM	macro value
		PutTrackCom	VolAddFM		; add the command byte
		dc.b \value				; add the volume
	endm
; ---------------------------------------------------------------------------

sGate		macro value
		PutTrackCom	Gate			; add the command byte
		dc.b \value				; add the value
	endm
; ---------------------------------------------------------------------------

sTransAdd	macro value
		PutTrackCom	TransAdd		; add the command byte
		dc.b \value				; add the transposition
	endm
; ---------------------------------------------------------------------------

sTempoSet	macro value
		PutTrackCom	TempoSet		; add the command byte
		dc.b \value				; add the tempo
	endm
; ---------------------------------------------------------------------------

sSongTick	macro value
		PutTrackCom	SongTick		; add the command byte
		dc.b \value				; add the tick value
	endm
; ---------------------------------------------------------------------------

sVolAddPSG	macro value
		PutTrackCom	VolAddPSG		; add the command byte
		dc.b \value				; add the volume
	endm
; ---------------------------------------------------------------------------

sClearPush	macro value
		PutTrackCom	TempoSet		; add the command byte
	endm
; ---------------------------------------------------------------------------

sEndBack	macro value
		PutTrackCom	EndBack			; add the command byte
	endm
; ---------------------------------------------------------------------------

sVoice		macro value
		PutTrackCom	Voice			; add the command byte
		dc.b pat\_songName\_\value		; add the voice
	endm
; ---------------------------------------------------------------------------

sVib		macro wait, speed, step, count
		PutTrackCom	Vib			; add the command byte
		dc.b \wait, \speed, \step, \count	; add the arguments
	endm
; ---------------------------------------------------------------------------

sVibOn		macro
		PutTrackCom	VibOn			; add the command byte
	endm
; ---------------------------------------------------------------------------

sEnd		macro
		PutTrackCom	End			; add the command byte
	endm
; ---------------------------------------------------------------------------

		rsset $E0				; PSG4 noise mode commands
snPeriodic10	rs.b 1					; periodic noise at frequency $10
snPeriodic20	rs.b 1					; periodic noise at frequency $20
snPeriodic40	rs.b 1					; periodic noise at frequency $40
snPeriodicPSG3	rs.b 1					; periodic noise at frequency of PSG3
snWhite10	rs.b 1					; white noise at frequency $10
snWhite20	rs.b 1					; white noise at frequency $20
snWhite40	rs.b 1					; white noise at frequency $40
snWhitePSG3	rs.b 1					; white noise at frequency of PSG3

sNoiseSet	macro mode
		PutTrackCom	NoiseSet		; add the command byte
		dc.b \mode				; add the noise mode
	endm
; ---------------------------------------------------------------------------

sVibOff		macro
		PutTrackCom	VibOff			; add the command byte
	endm
; ---------------------------------------------------------------------------

sEnv		macro num
		PutTrackCom	Env			; add the command byte
		dc.b \num				; add the envelope number
	endm
; ---------------------------------------------------------------------------

sJump		macro loc
		PutTrackCom	Jump			; add the command byte
		dc.w \loc-*-2				; add the target
	endm
; ---------------------------------------------------------------------------

sLoop		macro index, loops, loc
		PutTrackCom	Loop			; add the command byte
		dc.b \index, \loops			; add the arguments
		dc.w \loc-*-2				; add the target
	endm
; ---------------------------------------------------------------------------

sCall		macro loc
		PutTrackCom	Call			; add the command byte
		dc.w \loc-*-2				; add the target
	endm
; ---------------------------------------------------------------------------

sRelease34		macro
		PutTrackCom	Release34		; add the command byte
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Macros for music header
; ---------------------------------------------------------------------------

sHeaderMusic		macro
_patchNum =		0				; initialize patch num
_songAddr =		*				; song base address
_songName		equs "\#_song"			; initialize song name
_f\_songName =		0				; initialize fm count
_p\_songName =		0				; initialize psg count
	endm
; ---------------------------------------------------------------------------

sHeaderVoice		macro addr
		dc.w \addr-_songAddr			; initialize voice address
	endm
; ---------------------------------------------------------------------------

sHeaderTempo		macro tick, tempo
		dc.b _fx\_songName, _px\_songName	; initialize channel counts
		dc.b \tick, \tempo			; initialize tick and tempo
	endm
; ---------------------------------------------------------------------------

sHeaderDAC		macro addr
		dc.w \addr-_songAddr, 0			; initialize DAC address
	endm
; ---------------------------------------------------------------------------

sHeaderFM		macro addr, trans, volume
		dc.w \addr-_songAddr			; initialize FM address
		dc.b \trans, \volume			; initialize transposition and volume
_f\_songName set		1 + _f\_songName		; increment channel count
	endm
; ---------------------------------------------------------------------------

sHeaderPSG		macro addr, trans, volume, null, env
		dc.w \addr-_songAddr			; initialize FM address
		dc.b \trans, \volume, \null, \env	; initialize transposition, volume and envelope
_p\_songName =		1 + _p\_songName		; increment channel count
	endm
; ---------------------------------------------------------------------------

sHeaderFinish		macro
_px\_songName =		_p\_songName			; finished counting channels
_fx\_songName =		1 + _f\_songName		; +1 for DAC
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Macros for sfx header
; ---------------------------------------------------------------------------

sHeaderSfx		macro
_patchNum =		0				; initialize patch num
_songAddr =		*				; song base address
_songName		equs "\_song"			; initialize song name
_c\_songName =		0				; initialize channel count
	endm
; ---------------------------------------------------------------------------

sHeaderTick		macro tick
		dc.b \tick, _c\_songName		; initialize channel count and tick count
	endm
; ---------------------------------------------------------------------------

sHeaderSFX		macro flags, type, addr, trans, volume
		dc.b \flags, \type			; initialize flags and type
		dc.w \addr-_songAddr			; initialize FM address
		dc.b \trans, \volume			; initialize transposition and volume
_c\_songName =		1 + _c\_songName		; increment channel count
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Macros for voices
; ---------------------------------------------------------------------------

sNewVoice		macro	name
pat\_songName\_\name =	_patchNum			; generate equate for the macro
_patchNum =		1 + _patchNum			; increment patch number
	endm
; ---------------------------------------------------------------------------

sAlgorithm		macro	val
_algo =			\val
	endm
; ---------------------------------------------------------------------------

sFeedback		macro	val
_fb =			\val
	endm
; ---------------------------------------------------------------------------

sDetune			macro	op1, op2, op3, op4
_det1 =			\op1
_det2 =			\op2
_det3 =			\op3
_det4 =			\op4
	endm
; ---------------------------------------------------------------------------

sMultiple		macro	op1, op2, op3, op4
_mul1 =			\op1
_mul2 =			\op2
_mul3 =			\op3
_mul4 =			\op4
	endm
; ---------------------------------------------------------------------------

sRateScale		macro	op1, op2, op3, op4
_rs1 =			\op1
_rs2 =			\op2
_rs3 =			\op3
_rs4 =			\op4
	endm
; ---------------------------------------------------------------------------

sAttackRate		macro	op1, op2, op3, op4
_ar1 =			\op1
_ar2 =			\op2
_ar3 =			\op3
_ar4 =			\op4
	endm
; ---------------------------------------------------------------------------

sAmpMod			macro	op1, op2, op3, op4
_am1 =			\op1
_am2 =			\op2
_am3 =			\op3
_am4 =			\op4
	endm
; ---------------------------------------------------------------------------

sDecay1Rate		macro	op1, op2, op3, op4
_d1r1 =			\op1
_d1r2 =			\op2
_d1r3 =			\op3
_d1r4 =			\op4
	endm
; ---------------------------------------------------------------------------

sDecay1Level		macro	op1, op2, op3, op4
_d1l1 =			\op1
_d1l2 =			\op2
_d1l3 =			\op3
_d1l4 =			\op4
	endm
; ---------------------------------------------------------------------------

sDecay2Rate		macro	op1, op2, op3, op4
_d2r1 =			\op1
_d2r2 =			\op2
_d2r3 =			\op3
_d2r4 =			\op4
	endm
; ---------------------------------------------------------------------------

sReleaseRate		macro	op1, op2, op3, op4
_rr1 =			\op1
_rr2 =			\op2
_rr3 =			\op3
_rr4 =			\op4
	endm
; ---------------------------------------------------------------------------

sTotalLevel		macro	op1, op2, op3, op4
_tl1 =			\op1
_tl2 =			\op2
_tl3 =			\op3
_tl4 =			\op4
	endm
; ---------------------------------------------------------------------------

sFinishVoice		macro	notl
	if narg > 0 & \notl<>0
_tlb1 =			0
_tlb2 =			0
_tlb3 =			0
_tlb4 =			0
	else
;   0     1     2     3     4     5     6     7
; %1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
_tlb4 =			$80
_tlb3 =			((_algo >= 4) << 7)
_tlb2 =			((_algo >= 5) << 7)
_tlb1 =			((_algo = 7) << 7)
	endif

		dc.b (_fb<<3)|_algo
		dc.b (_det1<<4)|_mul1, (_det3<<4)|_mul3, (_det2<<4)|_mul2, (_det4<<4)|_mul4
		dc.b (_rs1<<6)|_ar1,   (_rs3<<6)|_ar3,   (_rs2<<6)|_ar2,   (_rs4<<6)|_ar4
		dc.b (_am1<<7)|_d1r1,  (_am3<<7)|_d1r3,  (_am2<<7)|_d1r2,  (_am4<<7)|_d1r4
		dc.b _d2r1,            _d2r3,            _d2r2,            _d2r4
		dc.b (_d1l1<<4)|_rr1,  (_d1l3<<4)|_rr3,  (_d1l2<<4)|_rr2,  (_d1l4<<4)|_rr4
		dc.b _tl1|_tlb1,       _tl3|_tlb3,       _tl2|_tlb2,       _tl4|_tlb4
	endm
; ---------------------------------------------------------------------------
