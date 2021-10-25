	sHeaderMusic
	sHeaderVoice	Drowning_Voices
	sHeaderTempo	$01, $02
	sHeaderDAC	Drowning_DAC
	sHeaderFM	Drowning_FM1, $0C, $08
	sHeaderFM	Drowning_FM2, -$18, $0E
	sHeaderFM	Drowning_FM3, -$0C, $40
	sHeaderFM	Drowning_FM4, $06, $11
	sHeaderFM	Drowning_FM5, $0C, $19
	sHeaderFinish

Drowning_FM1:
	sVoice		00
	sTiming		$01
	sGate		$05
	sCall		Drowning_Call1
	sTempoSet	$03
	sCall		Drowning_Call1
	sTempoSet	$04
	sCall		Drowning_Call1
	sTempoSet	$06
	sCall		Drowning_Call1
	sTempoSet	$0A
	sCall		Drowning_Call1
	sNote		nC5, $06
	sTiming		$01
	sEnd

Drowning_FM2:
	sVoice		01

Drowning_Loop1:
	sVolAddFM	-$01
	sCall		Drowning_Call2
	sLoop		$00, $0A, Drowning_Loop1
	sNote		nC5, $06
	sEnd

Drowning_FM3:
	sVoice		02

Drowning_Loop2:
	sVolAddFM	-$02
	sNote		sTie, nC6, $02, sTie, nCs6, sTie, nC6, sTie
	sNote		nCs6, sTie, nC6, sTie, nCs6, sTie, nC6, sTie
	sNote		nCs6
	sLoop		$00, $1E, Drowning_Loop2
	sNote		nC6, $06
	sEnd

Drowning_FM4:
	sVoice		03
	sGate		$05
	sNote		nR, $03

Drowning_Loop3:
	sPan		sPanRight
	sNote		nC4, $06, nC5
	sPan		sPanCenter
	sNote		nC4, nC5
	sPan		sPanLeft
	sNote		nCs4, nCs5
	sPan		sPanCenter
	sNote		nCs4, nCs5
	sLoop		$00, $0A, Drowning_Loop3
	sEnd

Drowning_FM5:
	sVoice		00
	sGate		$05
	sNote		nR, $04

Drowning_Loop4:
	sPan		sPanLeft
	sNote		nC4, $06, nC5
	sPan		sPanLeft
	sNote		nC4, nC5
	sPan		sPanRight
	sNote		nCs4, nCs5
	sPan		sPanRight
	sNote		nCs4, nCs5
	sLoop		$00, $0A, Drowning_Loop4
	sEnd

Drowning_DAC:
	sNote		dSnare, $0C, dSnare, dSnare, dSnare
	sLoop		$00, $0A, Drowning_DAC
	sNote		dSnare, $06
	sEnd

Drowning_Call1:
	sNote		nC4, $06, nC5, nC4, nC5, nCs4, nCs5, nCs4
	sNote		nCs5

Drowning_Call2:
	sNote		nC4, $06, nC5, nC4, nC5, nCs4, nCs5, nCs4
	sNote		nCs5
	sRet

Drowning_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $05, $05, $03
	sMultiple	$01, $00, $02, $00
	sRateScale	$01, $01, $01, $01
	sAttackRate	$12, $12, $13, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $08, $00, $00
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$04, $04, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $16, $80, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$00
	sFeedback	$03
	sDetune		$03, $03, $03, $03
	sMultiple	$07, $00, $00, $01
	sRateScale	$02, $00, $03, $02
	sAttackRate	$1E, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $04, $06, $01
	sDecay1Level	$0B, $03, $0B, $02
	sDecay2Rate	$08, $03, $0A, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$2C, $14, $22, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$05, $03, $05, $03
	sMultiple	$02, $04, $08, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $0A, $0A
	sDecay1Level	$00, $00, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$15, $14, $82, $82
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$03, $05, $03, $05
	sMultiple	$04, $04, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$14, $14, $14, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$91, $91, $91, $91
	sFinishVoice
