	sHeaderMusic
	sHeaderVoice	TitleScreen_Voices
	sHeaderTempo	$01, $05
	sHeaderDAC	TitleScreen_DAC
	sHeaderFM	TitleScreen_FM1, -$0C, $0C
	sHeaderFM	TitleScreen_FM2, -$0C, $09
	sHeaderFM	TitleScreen_FM3, -$0C, $0D
	sHeaderFM	TitleScreen_FM4, -$0C, $0C
	sHeaderFM	TitleScreen_FM5, -$0C, $0E
	sHeaderPSG	TitleScreen_PSG1, -$30, $03, $00, 05
	sHeaderPSG	TitleScreen_PSG1, -$24, $06, $00, 05
	sHeaderPSG	TitleScreen_PSG2, $00, $04, $00, 04
	sHeaderFinish

TitleScreen_FM5:
	sDetuneSet	$03

TitleScreen_FM1:
	sVoice		00
	sNote		nR, $3C, nCs6, $15, nR, $03, nCs6, $06
	sNote		nR, nD6, $0F, nR, $03, nB5, $18, nR
	sNote		$06, nCs6, nR, nCs6, nR, nCs6, nR, nA5
	sNote		nR, nG5, $0F, nR, $03, nB5, $0C, nR
	sNote		$12, nA5, $06, nR, nCs6, nR, nA6, nR
	sNote		nE6, $0C, nR, $06, nGs6, $12, nA6, $06
	sNote		nR, $72
	sEnd

TitleScreen_FM2:
	sVoice		01
	sTiming		$01
	sNote		nR, $30, nA3, $06, nR, nA3, nR, nE3
	sNote		nR, nE3, nR, nG3, $12, nFs3, $0C, nG3
	sNote		$06, nFs3, $0C, nA3, $06, nR, nA3, nR
	sNote		nE3, nR, nE3, nR, nD4, $12, nCs4, $0C
	sNote		nD4, $06, nCs4, $0C, nR, nA2, nR, nA2
	sNote		nR, $06, nGs3, $12, nA3, $06, nR, nA2
	sNote		$6C
	sTiming		$01
	sEnd

TitleScreen_FM3:
	sVoice		02
	sNote		nR, $30, nE6, $06, nR, nE6, nR, nCs6
	sNote		nR, nCs6, nR, nD6, $0F, nR, $03, nD6
	sNote		$18, nR, $06, nE6, nR, nE6, nR, nCs6
	sNote		nR, nCs6, nR, nG6, $0F, nR, $03, nG6
	sNote		$18, nR, $06, nE6, $0C, nR, nE6, nR
	sNote		nR, $06, nDs6, $12, nE6, $0C
	sVolAddFM	-$04
	sVoice		01
	sDetuneSet	$03
	sNote		nA2, $6C
	sEnd

TitleScreen_FM4:
	sVoice		02
	sNote		nR, $30, nCs6, $06, nR, nCs6, nR, nA5
	sNote		nR, nA5, nR, nB5, $0F, nR, $03, nB5
	sNote		$18, nR, $06, nCs6, nR, nCs6, nR, nA5
	sNote		nR, nA5, nR, nD6, $0F, nR, $03, nD6
	sNote		$18, nR, $06, nCs6, $0C, nR, nCs6, nR
	sNote		nR, $06, nC6, $12, nCs6, $0C
	sVolAddFM	-$03
	sVoice		01
	sVib		$00, $01, $06, $04
	sNote		nA2, $6C
	sEnd

TitleScreen_PSG2:
	sNoiseSet	snWhitePSG3
	sNote		nR, $30

TitleScreen_Loop1:
	sGate		$03
	sNote		nA5, $0C
	sGate		$0C
	sNote		$0C
	sGate		$03
	sNote		$0C
	sGate		$0C
	sNote		$0C
	sLoop		$00, $05, TitleScreen_Loop1
	sGate		$03
	sNote		$06
	sGate		$0E
	sNote		$12
	sGate		$03
	sNote		$0C
	sGate		$0F
	sNote		$0C
	sEnd

TitleScreen_DAC:
	sNote		nR, $0C, dSnare, dSnare, dSnare, dKick, dSnare, dKick
	sNote		dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick
	sNote		dSnare, dKick, dSnare, dKick, $06, nR, $02, dSnare
	sNote		dSnare, dSnare, $09, dSnare, $03, dKick, $0C, dSnare
	sNote		dKick, dSnare, dKick, $06, dSnare, $12, dSnare, $0C
	sNote		dKick

TitleScreen_PSG1:
	sEnd

TitleScreen_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$05, $05, $00, $00
	sMultiple	$01, $01, $08, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $1E, $1E, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $0F
	sDecay1Level	$00, $00, $00, $01
	sDecay2Rate	$00, $00, $00, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $22, $24, $81
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay1Level	$02, $01, $01, $0F
	sDecay2Rate	$07, $06, $06, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$19, $13, $37, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $07, $01
	sRateScale	$02, $02, $02, $01
	sAttackRate	$0E, $0D, $0E, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $0E, $0E, $03
	sDecay1Level	$01, $01, $0F, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $27, $28, $80
	sFinishVoice
