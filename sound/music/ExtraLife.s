	sHeaderMusic
	sHeaderVoice	ExtraLife_Voices
	sHeaderTempo	$02, $05
	sHeaderDAC	ExtraLife_DAC
	sHeaderFM	ExtraLife_FM1, -$18, $10
	sHeaderFM	ExtraLife_FM2, -$18, $10
	sHeaderFM	ExtraLife_FM3, -$18, $10
	sHeaderFM	ExtraLife_FM4, -$18, $10
	sHeaderFM	ExtraLife_FM5, -$18, $10
	sHeaderPSG	ExtraLife_PSG1, -$30, $06, $00, 05
	sHeaderPSG	ExtraLife_PSG2, -$24, $06, $00, 05
	sHeaderPSG	ExtraLife_PSG2, -$24, $00, $00, 04
	sHeaderFinish

ExtraLife_FM4:
	sDetuneSet	$03
	sPan		sPanRight
	sJump		ExtraLife_Jump1

ExtraLife_FM1:
	sPan		sPanLeft

ExtraLife_Jump1:
	sVoice		00
	sGate		$06
	sNote		nE7, $06, $03, $03, $06, $06
	sGate		$00
	sNote		nFs7, $09, nD7, nCs7, $06, nE7, $18
	sEnd

ExtraLife_FM2:
	sVoice		01
	sGate		$06
	sTiming		$01
	sNote		nCs7, $06, $03, $03, $06, $06
	sGate		$00
	sNote		nD7, $09, nB6, nA6, $06, nCs7, $18
	sTiming		$01
	sEnd

ExtraLife_FM5:
	sDetuneSet	$03
	sPan		sPanRight
	sJump		ExtraLife_Jump2

ExtraLife_FM3:
	sPan		sPanLeft

ExtraLife_Jump2:
	sVoice		02
	sNote		nA4, $0C, nR, $06, nA4, nG4, nR, $03
	sNote		nG4, $06, nR, $03, nG4, $06, nA4, $18
	sEnd

ExtraLife_PSG1:
	sGate		$06
	sNote		nCs7, $06, $03, $03, $06, $06
	sGate		$00
	sNote		nD7, $09, nB6, nA6, $06, nCs7, $18

ExtraLife_PSG2:
	sEnd

ExtraLife_DAC:
	sNote		dTimpaniHi, $12, $06, dTimpaniFloor, $09, $09, $06, dTimpaniHi
	sNote		$06, dTimpaniLow, dTimpaniHi, dTimpaniLow, dTimpaniHi, $0C
	sRestoreSong

ExtraLife_Voices:

	sNewVoice	00					; voice number $00
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
	sTotalLevel	$18, $16, $4E, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
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
	sDecay2Rate	$00, $00, $00, $07
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $27, $28, $80
	sFinishVoice
	even
