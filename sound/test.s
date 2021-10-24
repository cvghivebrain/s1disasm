	sHeaderMusic
	sHeaderVoice	GreenHill_Voices
	sHeaderTempo	$01, $03
	sHeaderDAC	GreenHill_DAC
	sHeaderFM	GreenHill_FM1, $F4, $12
	sHeaderFM	GreenHill_FM2, $00, $0B
	sHeaderFM	GreenHill_FM3, $F4, $14
	sHeaderFM	GreenHill_FM4, $F4, $08
	sHeaderFM	GreenHill_FM5, $F4, $20
	sHeaderPSG	GreenHill_PSG1, $D0, $01, $00, v03
	sHeaderPSG	GreenHill_PSG2, $D0, $03, $00, v06
	sHeaderPSG	GreenHill_PSG3, $00, $03, $00, v04
	sHeaderFinish

GreenHill_FM1:
	sVoice		02
	sPan		sPanRight
	sCall		GreenHill_Call1
	sPan		sPanCenter

GreenHill_Loop1:
	sPan		sPanLeft
	dc.b nE7, $04
	sPan		sPanRight
	dc.b nC7
	sVolAddFM	$01
	sLoop		$00, $0D, GreenHill_Loop1
	dc.b nE7, $04, nR, $14
	sVolAddFM	$EB
	sPan		sPanCenter
	dc.b nR, $40, nR, nR, nR, nR, nR

GreenHill_Jump1:
	sVoice		06
	sVib		$0D, $01, $07, $04
	sTransAdd	$F4
	dc.b nR, $20
	sCall		GreenHill_Call2
	dc.b nC6, $38
	sCall		GreenHill_Call2
	dc.b nC6, $08, $08, nE6
	sTransAdd	$0C
	sVoice		06
	sTransAdd	$F4
	dc.b nD6, $34, sTie, $34, nC6, $08, nD6, nE6
	dc.b $38, sTie, $38, nC6, $08, nC6, nE6, nDs6
	dc.b $34, sTie, $34, nC6, $08, nDs6, nD6, $1C
	dc.b sTie, $1C
	sVoice		05
	sTransAdd	$F4
	sVolAddFM	$0A
	dc.b nR, $08, nE7, $0C, nR, $04
	sGate		$0B
	dc.b nE7, $08, nF7, nE7, nG7
	sGate		$14
	dc.b nE7, $10
	sGate		$0B
	dc.b nC7, $08
	sGate		$00
	sVolAddFM	$F6
	sTransAdd	$18
	sJump		GreenHill_Jump1

GreenHill_Call1:
	dc.b nA6, $04, nF6, nA6, nF6, nB6, nG6, nB6
	dc.b nG6, nC7, nA6, nC7, nA6, nD7, nB6, nD7
	dc.b nB6
	sRet

GreenHill_Call2:
	dc.b nC7, $08, nA6, $10, nC7, $08, nB6, $10
	dc.b nC7, $08, nB6, $10, nG6, $30, nA6, $08
	dc.b nE7, nD7, $10, nC7, $08, nB6, $10, nC7
	dc.b $08, nB6, $10, nG6, $38, nC7, $08, nA6
	dc.b $10, nC7, $08, nB6, $10, nC7, $08, nB6
	dc.b $10, nG6, $30, nA6, $08, $08, nF6, $10
	dc.b nA6, $08, nG6, $10, nA6, $08, nG6, $10
	sRet

GreenHill_FM2:
	sVoice		00
	sTiming		$01
	dc.b nR, $08, nA2, nA3, nA2, nAs2, nAs3, nB2
	dc.b nB3
	sGate		$04
	sVoice		01

GreenHill_Loop2:
	dc.b nC3, $08
	sLoop		$00, $18, GreenHill_Loop2
	sGate		$00
	dc.b nC3, $04, nR, nC3, $08, nA2, $04, nR
	dc.b nA2, $08, nAs2, $04, nR, nAs2, $08, nB2
	dc.b $04, nR, nB2, $08
	sGate		$04

GreenHill_Loop3:
	dc.b nC3, $08
	sLoop		$00, $1D, GreenHill_Loop3
	sGate		$00
	dc.b nC3, nD3, nE3

GreenHill_Jump2:
	sVoice		01
	sCall		GreenHill_Call3
	sCall		GreenHill_Call4
	sGate		$00
	dc.b nC3, nD3, nE3
	sCall		GreenHill_Call3
	sCall		GreenHill_Call4
	dc.b nC3, nC3, nC3
	sGate		$00
	sVoice		00
	dc.b nAs2, $18, nA2, nG2, nF2, nE2, $08, nR
	dc.b nD2, nR, nA2, $18, nB2, nC3, nD3, nE3
	dc.b $08, nR, nA3, nR, nGs3, $18, nG3, nF3
	dc.b nDs3, nD3, $08, nR, nC3, nR, nG2, $18
	dc.b nD3, nG2, nG3, $08, nE2, nE3, nF2, nF3
	dc.b nG2, nG3
	sGate		$04
	sTiming		$01
	sJump		GreenHill_Jump2

GreenHill_Call3:
	sGate		$04
	dc.b nF3, $08, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	dc.b nF3
	sGate		$04
	dc.b nE3, nE3, nE3, nE3, nE3
	sGate		$00
	dc.b nC3, nD3, nE3
	sGate		$04
	dc.b nF3, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	dc.b nF3
	sGate		$04
	dc.b nE3, nE3, nE3, nE3, nE3
	sGate		$00
	dc.b nC3, nD3, nE3
	sRet

GreenHill_Call4:
	sGate		$04
	dc.b nF3, nF3, nF3, nF3, nF3, nF3, nF3
	sGate		$00
	dc.b nF3
	sGate		$04
	dc.b nE3, nE3, nE3, nE3, nE3, nE3, nE3
	sGate		$00
	dc.b nE3
	sGate		$04
	dc.b nD3, nD3, nD3, nD3, nD3, nD3, nD3
	sGate		$00
	dc.b nD3
	sGate		$04
	dc.b nC3, nC3, nC3, nC3, nC3
	sRet

GreenHill_FM3:
	sVoice		02
	sPan		sPanLeft
	sCall		GreenHill_Call1
	sVoice		08
	sPan		sPanCenter
	sTransAdd	$E8
	sVolAddFM	$FE
	dc.b nR, $01

GreenHill_Loop4:
	dc.b nC6, $01, sTie, nB5, $0F, nR, $08, nAs5
	dc.b $01, sTie, nA5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop4
	dc.b nC6, $01, sTie, nB5, $07, nR, $08, nAs5
	dc.b $01, sTie, nA5, $07, nR, $08, nCs6, $01
	dc.b sTie, nC6, $0F, nR, $08, nC6, $01, sTie
	dc.b nB5, $0F, nR, $08, nAs5, $01, sTie, nA5
	dc.b $10, sTie, $3B, nR, $04

GreenHill_Loop5:
	dc.b nAs5, $01, sTie, nA5, $0F, nR, $08, nC6
	dc.b $01, sTie, nB5, $0F, nR, $08, nCs6, $01
	dc.b sTie, nC6, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop5
	dc.b nCs6, $01, sTie, nC6, $0F, nR, $08, nC6
	dc.b $01, sTie, nB5, $28, sTie, $3E
	sVolAddFM	$02
	sTransAdd	$18

GreenHill_Jump3:
	sVoice		05
	sTransAdd	$E8
	sCall		GreenHill_Call5
	dc.b nA6
	sCall		GreenHill_Call5
	dc.b nE7
	sCall		GreenHill_Call5
	dc.b nA6, nR, $24, nR, nC7, $04, nR, $0C
	dc.b nA6, $10, nG6, $04, nR, nA6, nR, nC7
	dc.b nR
	sVibOff
	sVoice		05
	sCall		GreenHill_Call6
	dc.b nG6, $04, nA6, nC7, $08, nA6
	sCall		GreenHill_Call6
	dc.b nG6, $04, nA6, nC7, $08, nE7
	sCall		GreenHill_Call6
	dc.b nG6, $04, nA6, nC7, $08, nA6
	sVolAddFM	$06
	dc.b nC5, nA4, $04, nR, $16, nR
	sVolAddFM	$FA
	dc.b nE7, $08, nR, nC7, nR, nA6, nA6, nA6
	dc.b $04, nR, nC7, nR, nE7, nR
	sTransAdd	$18
	sVoice		07
	sPan		sPanCenter
	sGate		$1E
	sVolAddFM	$06
	dc.b nF5, $18, $18, $18, $18, $08, nR, nF5
	dc.b nR, nE5, $18, $18, $18, $18, $08, nR
	dc.b nE5, nR, nDs5, $18, $18, $18, $18, $08
	dc.b nR, nDs5, nR, nA5, $18, $18, $18, $18
	dc.b $08, nR, nA5, nR
	sVolAddFM	$FA
	sGate		$00
	sJump		GreenHill_Jump3

GreenHill_Call5:
	dc.b nR, $34, nR, nG6, $04, nA6, nC7, $08
	sRet

GreenHill_Call6:
	sVolAddFM	$06
	dc.b nE5, $08, nC5, $04, nR, $12, nR, nE5
	dc.b $08, nC5, $04, nR, nD5, $08, nB4, $04
	dc.b nR, $0E, nR
	sVolAddFM	$FA
	sRet

GreenHill_FM4:
	sVoice		08
	dc.b nR, $20, nR
	sPan		sPanLeft
	sTransAdd	$E8
	sVolAddFM	$0A

GreenHill_Loop6:
	dc.b nGs5, $01, sTie, nG5, $0F, nR, $08, nFs5
	dc.b $01, sTie, nF5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop6
	dc.b nGs5, $01, sTie, nG5, $07, nR, $08, nFs5
	dc.b $01, sTie, nF5, $07, nR, $08, nAs5, $01
	dc.b sTie, nA5, $0F, nR, $08, nGs5, $01, sTie
	dc.b nG5, $0F, nR, $08, nFs5, $01, sTie, nF5
	dc.b $10, sTie, $3C, nR, $04

GreenHill_Loop7:
	dc.b nFs5, $01, sTie, nF5, $0F, nR, $08, nGs5
	dc.b $01, sTie, nG5, $0F, nR, $08, nAs5, $01
	dc.b sTie, nA5, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop7
	dc.b nAs5, $01, sTie, nA5, $0F, nR, $08, nGs5
	dc.b $01, sTie, nG5, $28, sTie, $3F
	sVolAddFM	$F6
	sTransAdd	$18
	sVibOff

GreenHill_Jump4:
	sVoice		05
	sTransAdd	$E8
	sVolAddFM	$18
	sPan		sPanLeft
	sVolAddFM	$FD
	sCall		GreenHill_Call7
	dc.b nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4
	dc.b nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4
	dc.b nD5, nD5
	sCall		GreenHill_Call7
	dc.b nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4
	dc.b nD4, nD4, nB4, nB4
	sVolAddFM	$03
	sTransAdd	$18
	sTransAdd	$F4
	sVoice		04
	dc.b nG6, $10, nA6, nB6
	sVolAddFM	$F9
	dc.b nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	dc.b nC7, $28, sTie, $28, nB6, $10, nG6, nB6
	dc.b nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	dc.b nC7, $40, sTie, $40
	sTransAdd	$0C
	sVolAddFM	$07
	sVolAddFM	$E8
	sVoice		07
	sGate		$1E
	sPan		sPanCenter
	sVolAddFM	$12
	dc.b nD5, $18, $18, $18, $18, $08, nR, nD5
	dc.b nR, nC5, $18, $18, $18, $18, $08, nR
	dc.b nC5, nR, nC5, $18, $18, $18, $18, $08
	dc.b nR, nC5, nR, nF5, $18, $18, $18, $18
	dc.b $08, nR, nF5, nR
	sVolAddFM	$EE
	sGate		$00
	sJump		GreenHill_Jump4

GreenHill_Call7:
	dc.b nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4
	dc.b nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sRet

GreenHill_FM5:
	sVoice		03
	dc.b nR, $20, nR
	sVoice		08
	sPan		sPanRight
	sTransAdd	$E8
	sVolAddFM	$F2

GreenHill_Loop8:
	dc.b nF5, $01, sTie, nE5, $0F, nR, $08, nDs5
	dc.b $01, sTie, nD5, $0F, nR, $08
	sLoop		$00, $02, GreenHill_Loop8
	dc.b nF5, $01, sTie, nE5, $07, nR, $08, nDs5
	dc.b $01, sTie, nD5, $07, nR, $08, nFs5, $01
	dc.b sTie, nF5, $0F, nR, $08, nF5, $01, sTie
	dc.b nE5, $0F, nR, $08, nDs5, $01, sTie, nD5
	dc.b $10, sTie, $3C, nR, $04

GreenHill_Loop9:
	dc.b nDs5, $01, sTie, nD5, $0F, nR, $08, nF5
	dc.b $01, sTie, nE5, $0F, nR, $08, nFs5, $01
	dc.b sTie, nF5, $07, nR, $08
	sLoop		$00, $02, GreenHill_Loop9
	dc.b nFs5, $01, sTie, nF5, $0F, nR, $08, nF5
	dc.b $01, sTie, nE5, $28, sTie, $3F
	sTransAdd	$18
	sVolAddFM	$0E

GreenHill_Jump5:
	sVoice		05
	sTransAdd	$E8
	sPan		sPanRight
	sVolAddFM	$FD
	sCall		GreenHill_Call8
	dc.b nD5, nD5, nE5, nE5, nC5, nC5, nA4, nA4
	dc.b nF4, nF4, nD5, nD5, nB4, nB4, nG4, nG4
	dc.b nD5, nD5
	sCall		GreenHill_Call8
	dc.b nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4
	dc.b nD4, nD4, nB4, nB4
	sTransAdd	$18
	sVolAddFM	$03
	sTransAdd	$F4
	sVoice		04
	sDetuneSet	$02
	dc.b nG6, $10, nA6, nB6
	sVolAddFM	$F9
	dc.b nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	dc.b nC7, $28, sTie, $28, nB6, $10, nG6, nB6
	dc.b nC7, $28, sTie, $28, nD7, $10, nB6, nG6
	dc.b nC7, $40, sTie, $40
	sTransAdd	$0C
	sDetuneSet	$00
	sVoice		04
	sTransAdd	$F4
	sVolAddFM	$FA

GreenHill_Loop10:
	dc.b nAs6, $08, nF6, nD7, nF6, nAs6, nF6, nD7
	dc.b nF6
	sLoop		$00, $02, GreenHill_Loop10

GreenHill_Loop11:
	dc.b nA6, nE6, nC7, nE6, nA6, nE6, nC7, nE6
	sLoop		$00, $02, GreenHill_Loop11

GreenHill_Loop12:
	dc.b nGs6, nDs6, nC7, nDs6, nGs6, nDs6, nC7, nDs6
	sLoop		$00, $02, GreenHill_Loop12

GreenHill_Loop13:
	dc.b nC7, nA6, nE7, nA6, nC7, nA6, nE7, nA6
	sLoop		$00, $02, GreenHill_Loop13
	sVolAddFM	$0D
	sTransAdd	$0C
	sJump		GreenHill_Jump5

GreenHill_Call8:
	dc.b nE5, $08, nE5, nC5, nC5, nA4, nA4, nF4
	dc.b nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sRet

GreenHill_PSG1:
	sEnv		v05
	sVib		$0E, $01, $01, $03
	dc.b nR, $40
	sGate		$10
	dc.b nE5, $18, nD5, nE5, nD5, nE5, $08, nR
	dc.b nD5, nR, nF5, $18, nE5
	sGate		$00
	dc.b nD5, $28, sTie, $28
	sGate		$10
	dc.b nD5, $18, nE5, nF5, $10, nD5, $18, nE5
	dc.b nF5, $10, $18
	sGate		$00
	dc.b nE5, $34, sTie, $34
	sVibOff

GreenHill_Loop15:
	sEnv		v01

GreenHill_Loop14:
	dc.b nR, $10, nC6, $04, nR, $14, nC6, $08
	dc.b nR, $20, nB5, $04, nR, $14, nB5, $08
	dc.b nR, $10
	sLoop		$01, $03, GreenHill_Loop14
	dc.b nR, $10, nA5, $04, nR, $14, nA5, $08
	dc.b nR, $20, nG5, $04, nR, $14, nG5, $08
	dc.b nR, $10
	sLoop		$00, $02, GreenHill_Loop15
	sEnv		v05
	dc.b nAs6, $18, nA6, nG6, nF6, nE6, $08, nR
	dc.b nD6, nR, nA5, $18, nB5, nC6, nD6, nE6
	dc.b $08, nR, nA6, nR, nGs6, $18, nG6, nF6
	dc.b nDs6, nD6, $10, nC6, $08, nR, nR, $08
	dc.b nG6, nA6, nG6, $10, $08, nA6, nR, $10
	sVolAddPSG	$01
	dc.b nA5, $18, $08, nR, nA5, nR
	sVolAddPSG	$FF
	sEnv		v03
	sJump		GreenHill_Loop15

GreenHill_PSG2:
	dc.b nR, $40
	sVolAddPSG	$FE

GreenHill_Loop16:
	sGate		$06
	dc.b nC7, $08, nB6, nA6, nG6, nC7, nB6, nA6
	dc.b nG6
	sLoop		$00, $08, GreenHill_Loop16
	sGate		$00

GreenHill_Loop18:
	sEnv		v01

GreenHill_Loop17:
	dc.b nR, $10, nE6, $04, nR, $14, nE6, $08
	dc.b nR, $20, nD6, $04, nR, $14, nD6, $08
	dc.b nR, $10
	sLoop		$01, $03, GreenHill_Loop17
	dc.b nR, $10, nC6, $04, nR, $14, nC6, $08
	dc.b nR, $20, nB5, $04, nR, $14, nB5, $08
	dc.b nR, $10
	sLoop		$00, $02, GreenHill_Loop18
	dc.b nD6, $34, sTie, $34, nC6, $08, nD6, nE6
	dc.b $38, sTie, $38, nC6, $08, nC6, nE6, nDs6
	dc.b $34, sTie, $34, nC6, $08, nDs6, nD6
	sEnv		v05
	dc.b nC5, $18, $18, $18, $18, $08, nR, nC5
	dc.b nR
	sEnv		v03
	sJump		GreenHill_Loop18

GreenHill_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$06
	dc.b nA5, $10, $10, $10

GreenHill_Jump6:
	dc.b $08
	sJump		GreenHill_Jump6

GreenHill_DAC:
	dc.b nR, $08, dKick, dSnare, dKick, dKick, dSnare, dSnare
	dc.b dSnare

GreenHill_Loop19:
	dc.b dKick, $10, dSnare, $08, dKick, $10, $08, dSnare
	dc.b $10
	sLoop		$00, $07, GreenHill_Loop19
	dc.b dKick, $10, dSnare, $08, dKick, $10, dSnare, $08
	dc.b $08, $08

GreenHill_Loop20:
	dc.b dKick, $10, dSnare, $08, dKick, $10, $08, dSnare
	dc.b $10
	sLoop		$00, $07, GreenHill_Loop20
	dc.b dKick, $10, dSnare, $08, dKick, $10, dSnare, $08
	dc.b $08, $08
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
	sTotalLevel	$24, $13, $2D, $00
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
	sTotalLevel	$19, $13, $37, $00
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
	sTotalLevel	$18, $00, $00, $00
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
	sTotalLevel	$1A, $00, $00, $00
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
	sTotalLevel	$16, $17, $00, $00
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
	sTotalLevel	$16, $17, $00, $00
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
	sTotalLevel	$23, $23, $00, $00
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
	sTotalLevel	$1C, $00, $00, $00
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
	sTotalLevel	$16, $17, $00, $00
	sFinishVoice
