	sHeaderMusic
	sHeaderVoice	SpecialStage_Voices
	sHeaderTempo	$02, $08
	sHeaderDAC	SpecialStage_DAC
	sHeaderFM	SpecialStage_FM1, -$24, $18
	sHeaderFM	SpecialStage_FM2, -$24, $0C
	sHeaderFM	SpecialStage_FM3, -$18, $18
	sHeaderFM	SpecialStage_FM4, -$18, $18
	sHeaderFM	SpecialStage_FM5, -$18, $18
	sHeaderFM	SpecialStage_FM6, -$18, $14
	sHeaderPSG	SpecialStage_PSG1, -$24, $03, $00, 04
	sHeaderPSG	SpecialStage_PSG2, -$03, $01, $00, 08
	sHeaderPSG	SpecialStage_DAC, -$24, $04, $00, 04
	sHeaderFinish

SpecialStage_FM1:
	sVoice		00

SpecialStage_Loop1:
	sNote		nE5, $18, nF5, $0C, nG5, $18, nE5, $0C
	sNote		$18, nC5, $0C, nE5, $18, nC5, $0C, nE5
	sNote		$18, nF5, $0C, nG5, $18, nE5, $0C, nC5
	sNote		$18, nD5, $0C, nC5, $24
	sLoop		$00, $02, SpecialStage_Loop1
	sNote		sTie, $03, nR, $09, nD5, $0C, nE5, nF5
	sNote		nE5, nF5, nG5, $18, nE5, $0C, nC5, $24
	sNote		nR, $0C, nD5, nE5, nF5, nE5, nF5, nG5
	sNote		$18, nA5, $0C, nG5, $21, nR, $03
	sJump		SpecialStage_Loop1

SpecialStage_FM2:
	sVoice		02
	sTiming		$01

SpecialStage_Loop2:
	sNote		nF5, $0C, nR, $18, nE5, $0C, nR, $18
	sNote		nD5, $0C, nR, $18, nC5, $0C, nD5, nE5
	sNote		nF5, $0C, nR, $18, nE5, $0C, nR, $18
	sNote		nD5, $12, nE5, $06, nD5, $0C, nC5, $24
	sLoop		$00, $02, SpecialStage_Loop2
	sNote		nAs4, $0C, nR, $18, nAs4, $0C, nR, $18
	sNote		nC5, $0C, nR, $18, nC5, $0C, nR, $18
	sNote		nAs4, $0C, nR, $18, nAs4, $0C, nR, $18
	sNote		nD5, $0C, nR, $18, nG5, $24
	sTiming		$01
	sJump		SpecialStage_Loop2

SpecialStage_FM3:
	sVoice		03
	sVib		$1A, $01, $04, $06
	sPan		sPanCenter

SpecialStage_Loop3:
	sCall		SpecialStage_Call1
	sNote		nR, nC7, $03, nR, $09, nC7, $0C, nB6
	sNote		nC7, nD7
	sCall		SpecialStage_Call1
	sNote		nC7, $12, nD7, $06, nC7, $0C, nB6, $24
	sLoop		$00, $02, SpecialStage_Loop3
	sCall		SpecialStage_Call2
	sNote		nR, nB6, $03, nR, $09, nB6, $0C, nR
	sNote		nB6, $03, nR, $09, nB6, $0C
	sCall		SpecialStage_Call2
	sNote		nR, nC7, $03, nR, $09, nC7, $0C, $24
	sJump		SpecialStage_Loop3

SpecialStage_Call1:
	sNote		nR, $0C, nE7, $03, nR, $09, nE7, $0C
	sNote		nR, nD7, $03, nR, $09, nD7, $0C
	sRet

SpecialStage_Call2:
	sNote		nR, $0C, nA6, $03, nR, $09, nA6, $0C
	sNote		nR, nA6, $03, nR, $09, nA6, $0C
	sRet

SpecialStage_FM4:
	sVoice		03
	sVib		$1A, $01, $04, $06
	sPan		sPanRight

SpecialStage_Loop4:
	sCall		SpecialStage_Call3
	sNote		nR, nA6, $03, nR, $09, nA6, $0C, nG6
	sNote		nA6, nB6
	sCall		SpecialStage_Call3
	sNote		nA6, $12, nB6, $06, nA6, $0C, nG6, $24
	sLoop		$00, $02, SpecialStage_Loop4
	sCall		SpecialStage_Call4
	sNote		nR, nG6, $03, nR, $09, nG6, $0C, nR
	sNote		nG6, $03, nR, $09, nG6, $0C
	sCall		SpecialStage_Call4
	sNote		nR, nA6, $03, nR, $09, nA6, $0C, $24
	sJump		SpecialStage_Loop4

SpecialStage_Call3:
	sNote		nR, $0C, nC7, $03, nR, $09, nC7, $0C
	sNote		nR, nB6, $03, nR, $09, nB6, $0C
	sRet

SpecialStage_Call4:
	sNote		nR, $0C, nF6, $03, nR, $09, nF6, $0C
	sNote		nR, nF6, $03, nR, $09, nF6, $0C
	sRet

SpecialStage_FM5:
	sVoice		03
	sVib		$1A, $01, $04, $06
	sPan		sPanLeft

SpecialStage_Loop5:
	sCall		SpecialStage_Call5
	sNote		nR, nF6, $03, nR, $09, nF6, $0C, nE6
	sNote		nF6, nG6
	sCall		SpecialStage_Call5
	sNote		nF6, $12, nG6, $06, nF6, $0C, nE6, $24
	sLoop		$00, $02, SpecialStage_Loop5
	sCall		SpecialStage_Call6
	sNote		nR, nE6, $03, nR, $09, nE6, $0C, nR
	sNote		nE6, $03, nR, $09, nE6, $0C
	sCall		SpecialStage_Call6
	sNote		nR, nF6, $03, nR, $09, nF6, $0C, $24
	sJump		SpecialStage_Loop5

SpecialStage_Call5:
	sNote		nR, $0C, nA6, $03, nR, $09, nA6, $0C
	sNote		nR, nG6, $03, nR, $09, nG6, $0C
	sRet

SpecialStage_Call6:
	sNote		nR, $0C, nD6, $03, nR, $09, nD6, $0C
	sNote		nR, nD6, $03, nR, $09, nD6, $0C
	sRet

SpecialStage_PSG1:
	sGate		$06

SpecialStage_Loop7:
	sCall		SpecialStage_Call7
	sNote		nC6, $06, $06, nA5, $03, nR, $09, nF5
	sNote		$03, nR, $09, nB5, $03, nR, $21
	sCall		SpecialStage_Call7
	sNote		nC6, $03, nR, $15, nD6, $03, nR, $09
	sNote		nC6, $03, nR, $21
	sLoop		$00, $02, SpecialStage_Loop7
	sCall		SpecialStage_Call8
	sNote		nB6, $06, $06, nG6, nG6, nE6, nE6, nB6
	sNote		nB6, nG6, nG6, nE6, $03, nR, $09
	sCall		SpecialStage_Call8
	sNote		nC7, $06, $06, nA6, nA6, nF6, nF6, nG6
	sNote		$09, nR, $1B
	sJump		SpecialStage_Loop7

SpecialStage_Call7:
	sNote		nE6, $06, $06, nC6, $03, nR, $09, nA5
	sNote		$03, nR, $09, nD6, $06, $06, nB5, $03
	sNote		nR, $09, nG5, $03, nR, $09
	sRet

SpecialStage_Call8:
	sNote		nA6, $06, $06, nF6, nF6, nD6, nD6, nA6
	sNote		nA6, nF6, nF6, nD6, $03, nR, $09
	sRet

SpecialStage_PSG2:
	sNote		nR, $0C, nC5, nC5, nR, nC5, nC5, nR
	sNote		nC5, nC5, nR, nC5, $06, $06, $0C, nR
	sNote		nC5, nC5, nR, nC5, nC5, nR, nC5, nC5
	sNote		nC5, $24
	sJump		SpecialStage_PSG2

SpecialStage_DAC:
	sEnd

SpecialStage_FM6:
	sVoice		01

SpecialStage_Loop6:
	sNote		nE7, $18, nF7, $0C, nG7, $18, nE7, $0C
	sNote		$18, nC7, $0C, nE7, $18, nC7, $0C, nE7
	sNote		$18, nF7, $0C, nG7, $18, nE7, $0C, nC7
	sNote		$18, nD7, $0C, nC7, $24
	sLoop		$00, $02, SpecialStage_Loop6
	sNote		nR, $0C, nD7, nE7, nF7, nE7, nF7, nG7
	sNote		$18, nE7, $0C, nC7, $24, nR, $0C, nD7
	sNote		nE7, nF7, nE7, nF7, nG7, $18, nA7, $0C
	sNote		nG7, $21, nR, $03
	sJump		SpecialStage_Loop6

SpecialStage_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $01, $01
	sReleaseRate	$00, $00, $06, $06
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$02, $04, $08, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $0A, $0A
	sDecay1Level	$00, $00, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $00, $06, $06
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$00, $00, $00, $00
	sRateScale	$02, $03, $03, $03
	sAttackRate	$1E, $1C, $18, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay1Level	$0B, $0B, $0B, $0B
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$00, $00, $00, $05
	sTotalLevel	$14, $14, $3C, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $10, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay1Level	$01, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $07, $07, $07
	sTotalLevel	$17, $80, $80, $80
	sFinishVoice
