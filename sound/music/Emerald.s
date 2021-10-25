	sHeaderMusic
	sHeaderVoice	Emerald_Voices
	sHeaderTempo	$01, $06
	sHeaderDAC	Emerald_DAC
	sHeaderFM	Emerald_FM1, -$0C, $08
	sHeaderFM	Emerald_FM2, -$0C, $08
	sHeaderFM	Emerald_FM3, -$0C, $07
	sHeaderFM	Emerald_FM4, -$0C, $16
	sHeaderFM	Emerald_FM5, -$0C, $16
	sHeaderFM	Emerald_FM6, -$0C, $16
	sHeaderPSG	Emerald_PSG1, -$0C, $02, $00, 04
	sHeaderPSG	Emerald_PSG2, -$0C, $02, $00, 05
	sHeaderPSG	Emerald_DAC, -$0C, $00, $00, 04
	sHeaderFinish

Emerald_FM3:
	sDetuneSet	$02

Emerald_FM1:
	sVoice		00
	sNote		nE5, $06, nG5, nC6, nE6, $0C, nC6, nG6
	sNote		$2A
	sEnd

Emerald_FM2:
	sVoice		00
	sNote		nC5, $06, nE5, nG5, nC6, $0C, nA5, nD6
	sNote		$2A
	sEnd

Emerald_FM4:
	sVoice		01
	sNote		nE5, $0C, nE5, $06, nG5, $06, nR, nG5
	sNote		nR, nC6, $2A
	sEnd

Emerald_FM5:
	sVoice		01
	sNote		nC6, $0C, nC6, $06, nE6, $06, nR, nE6
	sNote		nR, nG6, $2A
	sEnd

Emerald_FM6:
	sVoice		01
	sNote		nG5, $0C, nG5, $06, nC6, $06, nR, nC6
	sNote		nR, nE6, $2A
	sEnd

Emerald_PSG2:
	sNote		nR, $2D

Emerald_Loop2:
	sNote		nG5, $06, nF5, nE5, nD5
	sVolAddPSG	$03
	sLoop		$00, $04, Emerald_Loop2
	sEnd

Emerald_PSG1:
	sTiming		$01
	sNote		nR, $02, nR, $2D

Emerald_Loop1:
	sNote		nG5, $06, nF5, nE5, nD5
	sVolAddPSG	$03
	sLoop		$00, $04, Emerald_Loop1

Emerald_DAC:
	sTiming		$01
	sEnd

Emerald_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $05, $07, $04
	sMultiple	$05, $04, $02, $06
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $1D, $14, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
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
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$1A, $16, $80, $80
	sFinishVoice
