	sHeaderMusic
	sHeaderVoice	SpringYard_Voices
	sHeaderTempo	$02, $03
	sHeaderDAC	SpringYard_DAC
	sHeaderFM	SpringYard_FM1, -$0C, $11
	sHeaderFM	SpringYard_FM2, -$18, $0B
	sHeaderFM	SpringYard_FM3, -$0C, $14
	sHeaderFM	SpringYard_FM4, -$0C, $18
	sHeaderFM	SpringYard_FM5, -$0C, $18
	sHeaderPSG	SpringYard_PSG1, -$30, $06, $00, 06
	sHeaderPSG	SpringYard_PSG2, -$18, $07, $00, None
	sHeaderPSG	SpringYard_PSG3, $00, $05, $00, 04
	sHeaderFinish

SpringYard_FM1:
	sNote		nR, $2A

SpringYard_Jump1:
	sVoice		00
	sVib		$08, $01, $06, $04
	sCall		SpringYard_Call1
	sNote		nD6, $0A, nF6, $2C
	sCall		SpringYard_Call1
	sNote		nD6, nF6, $02, nR, $04, nF6, $02, nR
	sNote		$04, nG6, $04, nF6, $02, nG6, $04, nR
	sNote		$02, nA6, $06
	sRelease34
	sNote		nR, $12
	sVoice		04
	sVibOff
	sVolAddFM	$08
	sCall		SpringYard_Call2
	sCall		SpringYard_Call3
	sNote		nA5, $08, nC6, $0C, nG6, $0A, nA6, $02
	sNote		nR, $04, nA6, $02, nG6, $03, nR, nF6
	sNote		$0C
	sCall		SpringYard_Call2
	sNote		nR, $06, nE6, $02, nR, $04, nE6, $0C
	sNote		nF6, nE6, $0A, nD6, $02, nR, $2A
	sVolAddFM	-$08
	sJump		SpringYard_Jump1

SpringYard_Call1:
	sNote		nR, $04, nE6, $02, nR, $04, nE6, $08
	sNote		nC6, $02, nR, $04, nA5, $02, nR, $04
	sNote		nE6, $0A, nC6, $02, nR, $0C, nR, $2E
	sNote		nFs6, $02, nR, $04, nFs6, $08, nD6, $02
	sNote		nR, $04, nB5, $02, nR, $04, nFs6, $0C
	sRet

SpringYard_Call2:
	sCall		SpringYard_Call3
	sNote		nA5, nR, $02, nAs5, nR, $04, nAs5, $08
	sNote		nC6, $03, nR, nAs5, nR, nA5, $04, nAs5
	sNote		nR, $02, nC6, $0E
	sRet

SpringYard_Call3:
	sNote		nR, $04, nF6, $08, nE6, $03, nR, nD6
	sNote		nR, nC6, nR, nD6, nR, nC6, $04
	sRet

SpringYard_FM2:
	sVoice		01
	sVolAddFM	-$02
	sTiming		$01
	sNote		nA4, $03, nR, nA4, nR, nG4, nR, nG4
	sNote		nR, nF4, nR, nF4, nR, nE4, nR, nE4
	sNote		$02, nR, nD4
	sVolAddFM	$02

SpringYard_Jump2:
	sCall		SpringYard_Call4
	sNote		nAs4, nR, $02, nA4, nR, $04, nA4, $08
	sNote		nG4, $03, nR, nG4, nR, nF4, nR, nF4
	sNote		nR, nE4, $0A, nD4, $02
	sCall		SpringYard_Call4
	sNote		nAs4, $08, nA4, $03, nR, nA4, nR, nA4
	sNote		nR, nA4, nR, nA4, nR, $13, nAs4, $02

SpringYard_Loop1:
	sCall		SpringYard_Call5
	sNote		nAs4
	sLoop		$00, $02, SpringYard_Loop1
	sCall		SpringYard_Call5
	sNote		nE4, nR, $04, nE4, $08, nE4, $03, nR
	sNote		nE4, nR, nA4, $09, nR, $03, nA4, $0A
	sNote		nD4, $02, nR, $2E, nD4, $02
	sTiming		$01
	sJump		SpringYard_Jump2

SpringYard_Call4:
	sNote		nR, $04, nD4, $08, nE4, $03, nR, nD4
	sNote		nR, nE4, nR, nD4, nR, nF4, $04, nA4
	sNote		nR, $02, nA4, nR, $04, nE5, $08, nC5
	sNote		$03, nR, nC5, nR, nA4, nR, nA4, nR
	sNote		nF4, $0A, nE4, $02, nR, $04, nE4, $08
	sNote		nFs4, $03, nR, nE4, nR, nFs4, nR, nE4
	sNote		nR, nG4, $04
	sRet

SpringYard_Call5:
	sNote		nR, $04, nAs4, $08, nC5, $03, nR, nAs4
	sNote		nR, nA4, $06, nR, nAs4, $04, nA4, nR
	sNote		$02, nG4, nR, $04, nG4, $08, nA4, $03
	sNote		nR, nG4, nR, nF4, nR, nF4, nR, nG4
	sNote		$04, nA4, nR, $02
	sRet

SpringYard_FM3:
	sNote		nR, $30
	sVoice		05
	sCall		SpringYard_Call6
	sNote		nR, $06, nA6, $02, nR, $0A, nG6, $02
	sNote		nR, $0A, nF6, $02, nR, $04, nE6, $02
	sNote		nR, nF6, nE6, nR, $04
	sCall		SpringYard_Call6
	sNote		nA5, $02, nR, nA5, nCs6, nR, nCs6, nE6
	sNote		nR, nE6, nG6, nR, nG6, nA6, nR, $10
	sNote		nR, $04, nF5, $02
	sCall		SpringYard_Call7
	sNote		nR, $13, nF5, $02
	sCall		SpringYard_Call7
	sNote		nR, nC5, nR, nD5, $04, nE5, nR, $02
	sNote		nF5
	sCall		SpringYard_Call7
	sNote		nR, $15, nR, $04, nA6, $08, nG6, $03
	sNote		nR, nG6, nR, nF6, nR, nF6, nR, nE6
	sNote		$04, nF6, $02, nE6, $04, nD6, $02
	sJump		SpringYard_FM3

SpringYard_Call6:
	sNote		nR, $36, nA5, $04, nC6, $02, nD6, $04
	sNote		nF6, $02, nR, $06, nA5, $04, nC6, $02
	sNote		nD6, $04, nF6, $02, nR, $3C
	sRet

SpringYard_Call7:
	sNote		nR, $04, nF5, $08, nF5, $03, nR, nF5
	sNote		nR, nE5, nR, $13, nD5, $02, nR, $04
	sNote		nD5, $08, nD5, $03, nR, nD5, nR, nC5
	sRet

SpringYard_FM4:
	sPan		sPanLeft
	sDetuneSet	$03
	sCall		SpringYard_Call8
	sDetuneSet	$00

SpringYard_Jump3:
	sVib		$01, $01, $01, $04
	sVoice		02
	sCall		SpringYard_Call10
	sVolAddFM	-$04
	sNote		nD6, $02
	sCall		SpringYard_Call12
	sVolAddFM	$04
	sJump		SpringYard_Jump3

SpringYard_Call10:
	sCall		SpringYard_Call11
	sNote		nA6, $30
	sCall		SpringYard_Call11
	sNote		nCs7, $03, nR, nCs7, nR, nCs7, nR, nCs7
	sNote		nR, nCs7, $03, nR, $13
	sRet

SpringYard_Call11:
	sNote		nE6, $24, nF6, $06, nG6, nE6, $24, nC6
	sNote		$06, nD6, nE6, $24, nF6, $06, nG6
	sRet

SpringYard_Call12:
	sCall		SpringYard_Call13
	sNote		nR, $13, nD6, $02
	sCall		SpringYard_Call13
	sNote		nR, nA5, nR, nAs5, $04, nC6, nR, $02
	sNote		nD6
	sCall		SpringYard_Call13
	sNote		nR, $13, nA5, $0E, nCs6, $0C, nE6, nCs7
	sNote		$0A, nD7, $02, nR, $30
	sRet

SpringYard_Call13:
	sNote		nR, $04, nD6, $08, nD6, $03, nR, nD6
	sNote		nR, nC6, nR, nA6, nR, nF6, nR, $07
	sNote		nAs5, $02, nR, $04, nAs5, $08, nAs5, $03
	sNote		nR, nAs5, nR, nA5
	sRet

SpringYard_Call8:
	sVoice		03
	sVolAddFM	-$02
	sCall		SpringYard_Call9
	sVolAddFM	$06
	sRet

SpringYard_Call9:
	sChannelTick	$01
	sNote		nAs3, $01, sTie, nA3, $04, nR, $07, nAs3
	sNote		$01, sTie, nA3, $04, nR, $07, nC4, $01
	sNote		sTie, nB3, $04, nR, $07, nC4, $01, sTie
	sNote		nB3, $04, nR, $07, nCs4, $01, sTie, nC4
	sNote		$04, nR, $07, nCs4, $01, sTie, nC4, $04
	sNote		nR, $07, nD4, $01, sTie, nCs4, $04, nR
	sNote		$07, nD4, $01, sTie, nCs4, $04, nR, $07
	sChannelTick	$02
	sRet

SpringYard_FM5:
	sPan		sPanRight
	sCall		SpringYard_Call8
	sVib		$02, $01, $02, $04
	sDetuneSet	$02
	sJump		SpringYard_Jump3

SpringYard_PSG1:
	sCall		SpringYard_Call9

SpringYard_Jump4:
	sCall		SpringYard_Call10
	sNote		nD6, $02
	sCall		SpringYard_Call12
	sJump		SpringYard_Jump4

SpringYard_PSG2:
	sEnd

SpringYard_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$01
	sVolAddPSG	$01

SpringYard_Loop2:
	sNote		nR, $04, nA5, $02
	sLoop		$00, $08, SpringYard_Loop2
	sVolAddPSG	-$01

SpringYard_Jump5:
	sNote		$02, nR, nA5
	sJump		SpringYard_Jump5

SpringYard_DAC:
	sNote		dSnare, $06, $06, $06, $06, $06, $06, $04
	sNote		$02, $04, dKick, $02

SpringYard_Loop3:
	sCall		SpringYard_Call14
	sLoop		$00, $03, SpringYard_Loop3
	sNote		nR, $04, dKick, $08, dSnare, $06, dKick, dKick
	sNote		$06, dSnare, dSnare, dSnare, $04, dKick, $02

SpringYard_Loop4:
	sCall		SpringYard_Call14
	sLoop		$00, $02, SpringYard_Loop4
	sNote		nR, $04, dKick, $08, dSnare, $06, dKick, dKick
	sNote		$0C, dSnare, dSnare, $06, $06, $06, $06, $10
	sNote		$02, $04, dKick, $02

SpringYard_Loop5:
	sCall		SpringYard_Call14
	sLoop		$00, $03, SpringYard_Loop5
	sNote		nR, $04, dKick, $08, dSnare, $06, dKick, dKick
	sNote		$06, dSnare, dSnare, dSnare, $04, dKick, $02

SpringYard_Loop6:
	sCall		SpringYard_Call14
	sLoop		$00, $03, SpringYard_Loop6
	sNote		nR, $0C, dSnare, $0A, dKick, $02, dSnare, $06
	sNote		dSnare, dSnare, $06, $04, dKick, $02
	sJump		SpringYard_Loop3

SpringYard_Call14:
	sNote		nR, $04, dKick, $08, dSnare, $06, dKick, dKick
	sNote		$0C, dSnare, $0A, dKick, $02
	sRet

SpringYard_Voices:

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
	sReleaseRate	$00, $00, $07, $07
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
	sTotalLevel	$32, $14, $22, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $10, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay1Level	$01, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $8C, $8D, $8C
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	05					; voice number $05
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $02
	sRateScale	$02, $00, $00, $01
	sAttackRate	$0D, $07, $07, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $00, $00, $03
	sDecay1Level	$05, $00, $00, $02
	sDecay2Rate	$01, $02, $02, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $18, $22, $80
	sFinishVoice
	even
