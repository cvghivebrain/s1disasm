	sHeaderMusic
	sHeaderVoice	GreenHill_Voices
	sHeaderTempo	$01, $03
	sHeaderDAC	GreenHill_DAC
	sHeaderFM	GreenHill_FM1, -$0C, $12
	sHeaderFM	GreenHill_FM2, $00, $0B
	sHeaderFM	GreenHill_FM3, -$0C, $14
	sHeaderFM	GreenHill_FM4, -$0C, $08
	sHeaderFM	GreenHill_FM5, -$0C, $20
	sHeaderPSG	GreenHill_PSG1, -$30, $01, $00, 03
	sHeaderPSG	GreenHill_PSG2, -$30, $03, $00, 06
	sHeaderPSG	GreenHill_PSG3, $00, $03, $00, 04
	sHeaderFinish

GreenHill_FM1:
	sVoice		02
	sPan		sPanRight
	sCall		GreenHill_Call1
	sPan		sPanCenter

GreenHill_Loop1:
	sPan		sPanLeft
	sNote		nE7, $04
	sPan		sPanRight
	sNote		nC7
	sVolAddFM	$01
	sLoop		$00, $0D, GreenHill_Loop1
	sNote		nE7, $04, nR, $14
	sVolAddFM	-$15
	sPan		sPanCenter
	sNote		nR, $40, nR, nR, nR, nR, nR

GreenHill_Jump1:
	sVoice		06
	sVib		$0D, $01, $07, $04
	sTransAdd	-$0C
	sNote		nR, $20
	sCall		GreenHill_Call2
	sNote		nC6, $38
	sCall		GreenHill_Call2
	sNote		nC6, $08, $08, nE6
	sTransAdd	$0C
	sVoice		06
	sTransAdd	-$0C
	sNote		nD6, $34, sTie, $34, nC6, $08, nD6, nE6
	sNote		$38, sTie, $38, nC6, $08, nC6, nE6, nDs6
	sNote		$34, sTie, $34, nC6, $08, nDs6, nD6, $1C
	sNote		sTie, $1C
	sVoice		05
	sTransAdd	-$0C
	sVolAddFM	$0A
	sNote		nR, $08, nE7, $0C, nR, $04
	sGate		$0B
	sNote		nE7, $08, nF7, nE7, nG7
	sGate		$14
	sNote		nE7, $10
	sGate		$0B
	sNote		nC7, $08
	sGate		$00
	sVolAddFM	-$0A
	sTransAdd	$18
	sJump		GreenHill_Jump1

GreenHill_Call1:
	sNote		nA6, $04, nF6, nA6, nF6, nB6, nG6, nB6
	sNote		nG6, nC7, nA6, nC7, nA6, nD7, nB6, nD7
	sNote		nB6
	sRet

GreenHill_Call2:
	sNote		nC7, $08, nA6, $10, nC7, $08, nB6, $10
	sNote		nC7, $08, nB6, $10, nG6, $30, nA6, $08
	sNote		nE7, nD7, $10, nC7, $08, nB6, $10, nC7
	sNote		$08, nB6, $10, nG6, $38, nC7, $08, nA6
	sNote		$10, nC7, $08, nB6, $10, nC7, $08, nB6
	sNote		$10, nG6, $30, nA6, $08, $08, nF6, $10
	sNote		nA6, $08, nG6, $10, nA6, $08, nG6, $10
	sRet

GreenHill_FM2:
	sVoice		00
	sTiming		$01
	sNote		nR, $08, nA2, nA3, nA2, nAs2, nAs3, nB2
	sNote		nB3
	sGate		$04
	sVoice		01

GreenHill_Loop2:
	sNote		nC3, $08
	sLoop		$00, $18, GreenHill_Loop2
	sGate		$00
	sNote		nC3, $04, nR, nC3, $08, nA2, $04, nR
	sNote		nA2, $08, nAs2, $04, nR, nAs2, $08, nB2
	sNote		$04, nR, nB2, $08
	sGate		$04

GreenHill_Loop3:
	sNote		nC3, $08
	sLoop		$00, $1D, GreenHill_Loop3
	sGate		$00
	sNote		nC3, nD3, nE3

GreenHill_Jump2:
	sVoice		01
	sCall		GreenHill_Call3
	sCall		GreenHill_Call4
	sGate		$00
	sNote		nC3, nD3, nE3
	sCall		GreenHill_Call3
	sCall		GreenHill_Call4
	sNote		nC3, nC3, nC3
	sGate		$00
	sVoice		00
	sNote		nAs2, $18, nA2, nG2, nF2, nE2, $08, nR
	sNote		nD2, nR, nA2, $18, nB2, nC3, nD3, nE3
	sNote		$08, nR, nA3, nR, nGs3, $18, nG3, nF3
	sNote		nDs3, nD3, $08, nR, nC3, nR, nG2, $18
	sNote		nD3, nG2, nG3, $08, nE2, nE3, nF2, nF3
	sNote		nG2, nG3
	sGate		$04
	sTiming		$01
	sJump		GreenHill_Jump2

GreenHill_Call3:
	sGate		$04
	sNote		nF3, $08, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	sNote		nF3
	sGate		$04
	sNote		nE3, nE3, nE3, nE3, nE3
	sGate		$00
	sNote		nC3, nD3, nE3
	sGate		$04
	sNote		nF3, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	sNote		nF3
	sGate		$04
	sNote		nE3, nE3, nE3, nE3, nE3
	sGate		$00
	sNote		nC3, nD3, nE3
	sRet

GreenHill_Call4:
	sGate		$04
	sNote		nF3, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	sNote		nF3
	sGate		$04
	sNote		nE3, nE3, nE3, nE3, nE3, nE3, nE3
	sGate		$00
	sNote		nE3
	sGate		$04
	sNote		nD3, nD3, nD3, nD3, nD3, nD3, nD3
	sGate		$00
	sNote		nD3
	sGate		$04
	sNote		nC3, nC3, nC3, nC3, nC3
	sRet

GreenHill_FM3:
	sVoice		02
	sPan		sPanLeft
	sCall		GreenHill_Call1
	sVoice		08
	sPan		sPanCenter
	sTransAdd	-$18
	sVolAddFM	-$02
	sNote		nR, $01

GreenHill_Loop4:
	sNote		nC6, $01, sTie, nB5, $0F, nR, $08, nAs5
	sNote		$01, sTie, nA5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop4
	sNote		nC6, $01, sTie, nB5, $07, nR, $08, nAs5
	sNote		$01, sTie, nA5, $07, nR, $08, nCs6, $01
	sNote		sTie, nC6, $0F, nR, $08, nC6, $01, sTie
	sNote		nB5, $0F, nR, $08, nAs5, $01, sTie, nA5
	sNote		$10, sTie, $3B, nR, $04

GreenHill_Loop5:
	sNote		nAs5, $01, sTie, nA5, $0F, nR, $08, nC6
	sNote		$01, sTie, nB5, $0F, nR, $08, nCs6, $01
	sNote		sTie, nC6, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop5
	sNote		nCs6, $01, sTie, nC6, $0F, nR, $08, nC6
	sNote		$01, sTie, nB5, $28, sTie, $3E
	sVolAddFM	$02
	sTransAdd	$18

GreenHill_Jump3:
	sVoice		05
	sTransAdd	-$18
	sCall		GreenHill_Call5
	sNote		nA6
	sCall		GreenHill_Call5
	sNote		nE7
	sCall		GreenHill_Call5
	sNote		nA6, nR, $24, nR, nC7, $04, nR, $0C
	sNote		nA6, $10, nG6, $04, nR, nA6, nR, nC7
	sNote		nR
	sVibOff
	sVoice		05
	sCall		GreenHill_Call6
	sNote		nG6, $04, nA6, nC7, $08, nA6
	sCall		GreenHill_Call6
	sNote		nG6, $04, nA6, nC7, $08, nE7
	sCall		GreenHill_Call6
	sNote		nG6, $04, nA6, nC7, $08, nA6
	sVolAddFM	$06
	sNote		nC5, nA4, $04, nR, $16, nR
	sVolAddFM	-$06
	sNote		nE7, $08, nR, nC7, nR, nA6, nA6, nA6
	sNote		$04, nR, nC7, nR, nE7, nR
	sTransAdd	$18
	sVoice		07
	sPan		sPanCenter
	sGate		$1E
	sVolAddFM	$06
	sNote		nF5, $18, $18, $18, $18, $08, nR, nF5
	sNote		nR, nE5, $18, $18, $18, $18, $08, nR
	sNote		nE5, nR, nDs5, $18, $18, $18, $18, $08
	sNote		nR, nDs5, nR, nA5, $18, $18, $18, $18
	sNote		$08, nR, nA5, nR
	sVolAddFM	-$06
	sGate		$00
	sJump		GreenHill_Jump3

GreenHill_Call5:
	sNote		nR, $34, nR, nG6, $04, nA6, nC7, $08
	sRet

GreenHill_Call6:
	sVolAddFM	$06
	sNote		nE5, $08, nC5, $04, nR, $12, nR, nE5
	sNote		$08, nC5, $04, nR, nD5, $08, nB4, $04
	sNote		nR, $0E, nR
	sVolAddFM	-$06
	sRet

GreenHill_FM4:
	sVoice		08
	sNote		nR, $20, nR
	sPan		sPanLeft
	sTransAdd	-$18
	sVolAddFM	$0A

GreenHill_Loop6:
	sNote		nGs5, $01, sTie, nG5, $0F, nR, $08, nFs5
	sNote		$01, sTie, nF5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop6
	sNote		nGs5, $01, sTie, nG5, $07, nR, $08, nFs5
	sNote		$01, sTie, nF5, $07, nR, $08, nAs5, $01
	sNote		sTie, nA5, $0F, nR, $08, nGs5, $01, sTie
	sNote		nG5, $0F, nR, $08, nFs5, $01, sTie, nF5
	sNote		$10, sTie, $3C, nR, $04

GreenHill_Loop7:
	sNote		nFs5, $01, sTie, nF5, $0F, nR, $08, nGs5
	sNote		$01, sTie, nG5, $0F, nR, $08, nAs5, $01
	sNote		sTie, nA5, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop7
	sNote		nAs5, $01, sTie, nA5, $0F, nR, $08, nGs5
	sNote		$01, sTie, nG5, $28, sTie, $3F
	sVolAddFM	-$0A
	sTransAdd	$18
	sVibOff

GreenHill_Jump4:
	sVoice		05
	sTransAdd	-$18
	sVolAddFM	$18
	sPan		sPanLeft
	sVolAddFM	-$03
	sCall		GreenHill_Call7
	sNote		nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4
	sNote		nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sNote		nD5, nD5
	sCall		GreenHill_Call7
	sNote		nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4
	sNote		nD4, nD4, nB4, nB4
	sVolAddFM	$03
	sTransAdd	$18
	sTransAdd	-$0C
	sVoice		04
	sNote		nG6, $10, nA6, nB6
	sVolAddFM	-$07
	sNote		nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	sNote		nC7, $28, sTie, $28, nB6, $10, nG6, nB6
	sNote		nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	sNote		nC7, $40, sTie, $40
	sTransAdd	$0C
	sVolAddFM	$07
	sVolAddFM	-$18
	sVoice		07
	sGate		$1E
	sPan		sPanCenter
	sVolAddFM	$12
	sNote		nD5, $18, $18, $18, $18, $08, nR, nD5
	sNote		nR, nC5, $18, $18, $18, $18, $08, nR
	sNote		nC5, nR, nC5, $18, $18, $18, $18, $08
	sNote		nR, nC5, nR, nF5, $18, $18, $18, $18
	sNote		$08, nR, nF5, nR
	sVolAddFM	-$12
	sGate		$00
	sJump		GreenHill_Jump4

GreenHill_Call7:
	sNote		nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4
	sNote		nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sRet

GreenHill_FM5:
	sVoice		03
	sNote		nR, $20, nR
	sVoice		08
	sPan		sPanRight
	sTransAdd	-$18
	sVolAddFM	-$0E

GreenHill_Loop8:
	sNote		nF5, $01, sTie, nE5, $0F, nR, $08, nDs5
	sNote		$01, sTie, nD5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop8
	sNote		nF5, $01, sTie, nE5, $07, nR, $08, nDs5
	sNote		$01, sTie, nD5, $07, nR, $08, nFs5, $01
	sNote		sTie, nF5, $0F, nR, $08, nF5, $01, sTie
	sNote		nE5, $0F, nR, $08, nDs5, $01, sTie, nD5
	sNote		$10, sTie, $3C, nR, $04

GreenHill_Loop9:
	sNote		nDs5, $01, sTie, nD5, $0F, nR, $08, nF5
	sNote		$01, sTie, nE5, $0F, nR, $08, nFs5, $01
	sNote		sTie, nF5, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop9
	sNote		nFs5, $01, sTie, nF5, $0F, nR, $08, nF5
	sNote		$01, sTie, nE5, $28, sTie, $3F
	sTransAdd	$18
	sVolAddFM	$0E

GreenHill_Jump5:
	sVoice		05
	sTransAdd	-$18
	sPan		sPanRight
	sVolAddFM	-$03
	sCall		GreenHill_Call8
	sNote		nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4
	sNote		nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sNote		nD5, nD5
	sCall		GreenHill_Call8
	sNote		nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4
	sNote		nD4, nD4, nB4, nB4
	sTransAdd	$18
	sVolAddFM	$03
	sTransAdd	-$0C
	sVoice		04
	sDetuneSet	$02
	sNote		nG6, $10, nA6, nB6
	sVolAddFM	-$07
	sNote		nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	sNote		nC7, $28, sTie, $28, nB6, $10, nG6, nB6
	sNote		nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	sNote		nC7, $40, sTie, $40
	sTransAdd	$0C
	sDetuneSet	$00
	sVoice		04
	sTransAdd	-$0C
	sVolAddFM	-$06

GreenHill_Loop10:
	sNote		nAs6, $08, nF6, nD7, nF6, nAs6, nF6, nD7
	sNote		nF6
	sLoop		$00, $02, GreenHill_Loop10

GreenHill_Loop11:
	sNote		nA6, nE6, nC7, nE6, nA6, nE6, nC7, nE6
	sLoop		$00, $02, GreenHill_Loop11

GreenHill_Loop12:
	sNote		nGs6, nDs6, nC7, nDs6, nGs6, nDs6, nC7, nDs6
	sLoop		$00, $02, GreenHill_Loop12

GreenHill_Loop13:
	sNote		nC7, nA6, nE7, nA6, nC7, nA6, nE7, nA6
	sLoop		$00, $02, GreenHill_Loop13
	sVolAddFM	$0D
	sTransAdd	$0C
	sJump		GreenHill_Jump5

GreenHill_Call8:
	sNote		nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4
	sNote		nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sRet

GreenHill_PSG1:
	sEnv		05
	sVib		$0E, $01, $01, $03
	sNote		nR, $40
	sGate		$10
	sNote		nE5, $18, nD5, nE5, nD5, nE5, $08, nR
	sNote		nD5, nR, nF5, $18, nE5
	sGate		$00
	sNote		nD5, $28, sTie, $28
	sGate		$10
	sNote		nD5, $18, nE5, nF5, $10, nD5, $18, nE5
	sNote		nF5, $10, $18
	sGate		$00
	sNote		nE5, $34, sTie, $34
	sVibOff

GreenHill_Loop15:
	sEnv		01

GreenHill_Loop14:
	sNote		nR, $10, nC6, $04, nR, $14, nC6, $08
	sNote		nR, $20, nB5, $04, nR, $14, nB5, $08
	sNote		nR, $10
	sLoop		$01, $03, GreenHill_Loop14
	sNote		nR, $10, nA5, $04, nR, $14, nA5, $08
	sNote		nR, $20, nG5, $04, nR, $14, nG5, $08
	sNote		nR, $10
	sLoop		$00, $02, GreenHill_Loop15
	sEnv		05
	sNote		nAs6, $18, nA6, nG6, nF6, nE6, $08, nR
	sNote		nD6, nR, nA5, $18, nB5, nC6, nD6, nE6
	sNote		$08, nR, nA6, nR, nGs6, $18, nG6, nF6
	sNote		nDs6, nD6, $10, nC6, $08, nR, nR, $08
	sNote		nG6, nA6, nG6, $10, $08, nA6, nR, $10
	sVolAddPSG	$01
	sNote		nA5, $18, $08, nR, nA5, nR
	sVolAddPSG	-$01
	sEnv		03
	sJump		GreenHill_Loop15

GreenHill_PSG2:
	sNote		nR, $40
	sVolAddPSG	-$02

GreenHill_Loop16:
	sGate		$06
	sNote		nC7, $08, nB6, nA6, nG6, nC7, nB6, nA6
	sNote		nG6
	sLoop		$00, $08, GreenHill_Loop16
	sGate		$00

GreenHill_Loop18:
	sEnv		01

GreenHill_Loop17:
	sNote		nR, $10, nE6, $04, nR, $14, nE6, $08
	sNote		nR, $20, nD6, $04, nR, $14, nD6, $08
	sNote		nR, $10
	sLoop		$01, $03, GreenHill_Loop17
	sNote		nR, $10, nC6, $04, nR, $14, nC6, $08
	sNote		nR, $20, nB5, $04, nR, $14, nB5, $08
	sNote		nR, $10
	sLoop		$00, $02, GreenHill_Loop18
	sNote		nD6, $34, sTie, $34, nC6, $08, nD6, nE6
	sNote		$38, sTie, $38, nC6, $08, nC6, nE6, nDs6
	sNote		$34, sTie, $34, nC6, $08, nDs6, nD6
	sEnv		05
	sNote		nC5, $18, $18, $18, $18, $08, nR, nC5
	sNote		nR
	sEnv		03
	sJump		GreenHill_Loop18

GreenHill_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$06
	sNote		nA5, $10, $10, $10

GreenHill_Jump6:
	sNote		$08
	sJump		GreenHill_Jump6

GreenHill_DAC:
	sNote		nR, $08, dKick, dSnare, dKick, dKick, dSnare, dSnare
	sNote		dSnare

GreenHill_Loop19:
	sNote		dKick, $10, dSnare, $08, dKick, $10, $08, dSnare
	sNote		$10
	sLoop		$00, $07, GreenHill_Loop19
	sNote		dKick, $10, dSnare, $08, dKick, $10, dSnare, $08
	sNote		$08, $08

GreenHill_Loop20:
	sNote		dKick, $10, dSnare, $08, dKick, $10, $08, dSnare
	sNote		$10
	sLoop		$00, $07, GreenHill_Loop20
	sNote		dKick, $10, dSnare, $08, dKick, $10, dSnare, $08
	sNote		$08, $08
	sLoop		$01, $02, GreenHill_Loop20
	sJump		GreenHill_Loop20

GreenHill_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$01
	sDetune		$00, $03, $07, $00
	sMultiple	$0A, $00, $00, $00
	sRateScale	$00, $01, $00, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0A, $0E, $0A
	sDecay1Level	$02, $02, $02, $02
	sDecay2Rate	$00, $04, $04, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $13, $2D, $80
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
	sReleaseRate	$00, $00, $00, $08
	sTotalLevel	$19, $13, $37, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$06
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0E, $11, $00
	sDecay1Level	$0F, $01, $00, $00
	sDecay2Rate	$00, $07, $0A, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $80, $80, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $02, $00, $00
	sAttackRate	$14, $0C, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $02, $05, $05
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $0D, $0D, $0D
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $80, $80, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
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
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	05					; voice number $05
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
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	06					; voice number $06
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$07, $03, $04, $03
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $12, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $08, $08
	sDecay1Level	$00, $00, $01, $01
	sDecay2Rate	$00, $00, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	07					; voice number $07
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
	sReleaseRate	$00, $07, $07, $07
	sTotalLevel	$1C, $80, $80, $80
	sFinishVoice

	sNewVoice	08					; voice number $08
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $07, $07
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $07, $07
	sReleaseRate	$00, $00, $08, $08
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice
