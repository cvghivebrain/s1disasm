	sHeaderMusic
	sHeaderVoice	HasPassed_Voices
	sHeaderTempo	$02, $03
	sHeaderDAC	HasPassed_DAC
	sHeaderFM	HasPassed_FM1, -$0C, $0A
	sHeaderFM	HasPassed_FM2, -$24, $0A
	sHeaderFM	HasPassed_FM3, -$0C, $15
	sHeaderFM	HasPassed_FM4, -$0C, $15
	sHeaderFM	HasPassed_FM5, -$0C, $14
	sHeaderPSG	HasPassed_PSG1, -$30, $05, $00, 05
	sHeaderPSG	HasPassed_PSG2, -$24, $07, $00, 05
	sHeaderPSG	HasPassed_PSG3, -$24, $00, $00, 04
	sHeaderFinish

HasPassed_FM1:
	sVoice		00

HasPassed_PSG1:
	sNote		nR, $06, nG4, nA4, nB4, nC5, nD5, nE5
	sNote		nF5, nG5, $0C, nB6, $02, sTie, nC7, $01
	sNote		nB6, $03, nG6
	sVib		$0C, $01, $08, $04
	sNote		nA6, $33
	sEnd

HasPassed_FM2:
	sVoice		01
	sGate		$0B
	sTiming		$01
	sNote		nG5, $03, nG5, nG4, $06, nG4, nG5, $03
	sNote		nG5, nG4, $06, nG4, nG5, $03, nG5, nR
	sNote		$06, nR, $0C, nG4, $09
	sGate		$00
	sNote		nA4, $33
	sTiming		$01
	sEnd

HasPassed_FM3:
	sPan		sPanLeft
	sVoice		02
	sGate		$06
	sNote		nC6, $03, nC6, nR, $0C, nC6, $03, nC6
	sNote		nR, $0C, nC6, $03, nC6, nR, $12
	sGate		$00
	sNote		nC6, $09, nD6, $33
	sEnd

HasPassed_FM4:
	sPan		sPanRight
	sVoice		02
	sGate		$06
	sNote		nA5, $03, nA5, nR, $0C, nA5, $03, nA5
	sNote		nR, $0C, nA5, $03, nA5, nR, $12
	sGate		$00
	sNote		nA5, $09, nB5, $33
	sEnd

HasPassed_FM5:
	sVoice		03
	sVib		$0D, $01, $02, $05

HasPassed_PSG2:
	sNote		nG5, $06, nC6, nB5, nG5, nC6, nB5, nG5
	sNote		nC6, nB5, $0C, nC6, $09, nB5, $33

HasPassed_PSG3:
	sEnd

HasPassed_DAC:
	sNote		dSnare, $03, dSnare, dKick, $06, dKick, dSnare, $03
	sNote		dSnare, dKick, $06, dKick, dSnare, $03, dSnare, dTimpaniHi
	sNote		dTimpaniHi, dTimpaniFloor, dTimpaniFloor, $03, dTimpaniFloor, dTimpaniFloor, dSnare, $09
	sNote		$33
	sEnd

HasPassed_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay1Level	$01, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $8C, $8D, $8C
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$06, $01, $03, $03
	sMultiple	$01, $04, $0C, $01
	sRateScale	$02, $02, $03, $03
	sAttackRate	$1C, $1C, $1B, $1A
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $09, $03
	sDecay1Level	$01, $00, $00, $00
	sDecay2Rate	$03, $03, $01, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$21, $31, $47, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $01
	sRateScale	$02, $00, $01, $01
	sAttackRate	$0E, $14, $12, $0C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $0E, $08, $03
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1B, $80, $80, $9B
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $01
	sRateScale	$02, $00, $01, $01
	sAttackRate	$0E, $14, $12, $0C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $0E, $08, $03
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1B, $80, $80, $9B
	sFinishVoice

	sNewVoice	04					; voice number $04
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $01, $01, $01
	sAttackRate	$10, $10, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $08, $08, $08
	sDecay1Level	$02, $01, $01, $01
	sDecay2Rate	$01, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1C, $82, $82, $82
	sFinishVoice
	even
