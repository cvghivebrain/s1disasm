	sHeaderMusic
	sHeaderVoice	ScrabBrain_Voices
	sHeaderTempo	$02, $05
	sHeaderDAC	ScrabBrain_DAC
	sHeaderFM	ScrabBrain_FM1, -$0C, $0D
	sHeaderFM	ScrabBrain_FM2, -$0C, $0D
	sHeaderFM	ScrabBrain_FM3, -$0C, $13
	sHeaderFM	ScrabBrain_FM4, -$0C, $17
	sHeaderFM	ScrabBrain_FM5, -$0C, $17
	sHeaderPSG	ScrabBrain_PSG1, -$30, $03, $00, None
	sHeaderPSG	ScrabBrain_PSG2, -$30, $03, $00, None
	sHeaderPSG	ScrabBrain_PSG3, $00, $03, $00, 04
	sHeaderFinish

ScrabBrain_FM1:
	sVoice		02
	sVolAddFM	$08
	sNote		nR, $24, nE6, $03, nD6, nC6, nB5, nF6
	sNote		nE6, nD6, nC6, nG6, nF6, nE6, nD6, nA6
	sNote		nG6, nF6, nE6, nB6, nA6, nG6, nF6
	sVolAddFM	-$08
	sVoice		03
	sVib		$0D, $01, $08, $05
	sCall		ScrabBrain_Call1
	sVoice		05
	sDetuneSet	-$02
	sPan		sPanRight
	sVolAddFM	$03
	sTransAdd	-$0C
	sCall		ScrabBrain_Call2
	sTransAdd	$0C
	sVolAddFM	-$03
	sPan		sPanCenter
	sVolAddFM	-$02
	sDetuneSet	$00
	sVoice		03

ScrabBrain_Loop1:
	sCall		ScrabBrain_Call4
	sLoop		$00, $02, ScrabBrain_Loop1
	sVolAddFM	$02
	sJump		ScrabBrain_FM1

ScrabBrain_FM2:
	sVoice		00
	sVolAddFM	-$03
	sTiming		$01
	sGate		$06
	sNote		nA3, $03, nB3, nR, nC4, nR, nD4, nE4
	sGate		$00
	sNote		nG4, $09

ScrabBrain_Loop2:
	sNote		nG3, $06, nG4
	sLoop		$00, $05, ScrabBrain_Loop2
	sNote		nG3
	sVolAddFM	$03
	sGate		$06

ScrabBrain_Loop5:
	sCall		ScrabBrain_Call5

ScrabBrain_Loop3:
	sNote		nG4, nG4, nD4, nD4, nF4, nF4, nD4, nD4
	sLoop		$00, $04, ScrabBrain_Loop3

ScrabBrain_Loop4:
	sNote		nF4, nF4, nC4, nC4, nDs4, nDs4, nC4, nC4
	sLoop		$00, $04, ScrabBrain_Loop4
	sCall		ScrabBrain_Call5
	sLoop		$01, $02, ScrabBrain_Loop5
	sPan		sPanLeft
	sCall		ScrabBrain_Call2
	sPan		sPanCenter

ScrabBrain_Loop6:
	sNote		nC4, $03, nC4, nG3, nG3, nA3, nA3, nG3
	sNote		nG3
	sLoop		$00, $02, ScrabBrain_Loop6

ScrabBrain_Loop7:
	sNote		nFs4, nFs4, nCs4, nCs4, nDs4, nDs4, nCs4, nCs4
	sLoop		$00, $02, ScrabBrain_Loop7

ScrabBrain_Loop8:
	sNote		nF4, nF4, nC4, nC4, nD4, nD4, nC4, nC4
	sLoop		$00, $02, ScrabBrain_Loop8

ScrabBrain_Loop9:
	sNote		nG4, nG4, nD4, nD4, nE4, nE4, nD4, nD4
	sLoop		$00, $02, ScrabBrain_Loop9
	sLoop		$01, $04, ScrabBrain_Loop6
	sGate		$00
	sTiming		$01
	sJump		ScrabBrain_FM2

ScrabBrain_Call5:
	sNote		nA4, $03, nA4, nE4, nE4, nG4, nG4, nE4
	sNote		nE4
	sLoop		$00, $04, ScrabBrain_Call5
	sRet

ScrabBrain_FM3:
	sVoice		01
	sGate		$06
	sNote		nA4, $03, nB4, nR, nC5, nR, nD5, nE5
	sGate		$00
	sNote		nG5, $4B
	sVoice		03
	sDetuneSet	$03
	sVolAddFM	-$06
	sCall		ScrabBrain_Call1
	sVoice		00
	sPan		sPanRight
	sGate		$06
	sCall		ScrabBrain_Call2
	sPan		sPanCenter
	sVoice		03
	sGate		$00
	sVolAddFM	-$02

ScrabBrain_Loop10:
	sCall		ScrabBrain_Call4
	sLoop		$00, $02, ScrabBrain_Loop10
	sVolAddFM	$08
	sJump		ScrabBrain_FM3

ScrabBrain_FM4:
	sVoice		04
	sPan		sPanLeft
	sVib		$5C, $01, $05, $04
	sGate		$06
	sCall		ScrabBrain_Call6
	sDetuneSet	$04
	sCall		ScrabBrain_Call7
	sVolAddFM	$06
	sVoice		05
	sDetuneSet	$02
	sVolAddFM	-$13
	sTransAdd	-$0C
	sCall		ScrabBrain_Call2
	sVolAddFM	$13
	sTransAdd	$0C
	sVolAddFM	-$0D
	sVoice		04
	sVibOff
	sVolAddFM	-$06

ScrabBrain_Loop12:
	sVibOff
	sCall		ScrabBrain_Call8
	sNote		nR, $0C, nA5, $02
	sDetuneSet	$00
	sNote		sTie, $0A, nR, $03, nA5, nR, nR, nA5
	sNote		nR, $09
	sCall		ScrabBrain_Call8
	sNote		nA5, $02
	sDetuneSet	$00
	sNote		$0A, nR, $06
	sVib		$18, $01, $07, $04
	sDetuneSet	-$1E
	sNote		nA5, $02, sTie
	sDetuneSet	$00
	sNote		$1C
	sLoop		$00, $02, ScrabBrain_Loop12
	sVolAddFM	$06
	sVolAddFM	$01
	sJump		ScrabBrain_FM4

ScrabBrain_Call6:
	sNote		nE5, $03, nE5, nR, nE5, nR, nE5, nE5
	sGate		$00
	sNote		nD5, $4B
	sRet

ScrabBrain_Call7:
	sVoice		02
	sVolAddFM	$06
	sVib		$08, $01, $08, $04

ScrabBrain_Loop11:
	sNote		nR, $60, nR, nR, nE6, $18, nFs6, nG6
	sNote		nGs6
	sLoop		$00, $02, ScrabBrain_Loop11
	sRet

ScrabBrain_Call8:
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nG5, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nG5, $03, nR, $18
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nCs6, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nCs6, $03, nR, $18
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nC6, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nC6, $03, nR, $18
	sDetuneSet	-$14
	sRet

ScrabBrain_FM5:
	sVoice		04
	sPan		sPanRight
	sVib		$5C, $01, $05, $04
	sGate		$06
	sNote		nC5, $03, nC5, nR, nC5, nR, nC5, nC5
	sGate		$00
	sNote		nB4, $4B
	sCall		ScrabBrain_Call7
	sVolAddFM	$06

ScrabBrain_Loop13:
	sNote		nR, $60
	sLoop		$00, $01, ScrabBrain_Loop13
	sVoice		06
	sVolAddFM	-$15
	sTransAdd	$0C
	sVibOff

ScrabBrain_Loop14:
	sCall		ScrabBrain_Call9
	sNote		nE6, nF6, nG6
	sCall		ScrabBrain_Call9
	sNote		nG6, nF6, nE6
	sLoop		$00, $02, ScrabBrain_Loop14
	sVolAddFM	$09
	sTransAdd	-$0C
	sJump		ScrabBrain_FM5

ScrabBrain_Call9:
	sNote		nR, $03, nE6, nC6, $06, $06, nG5, nC6
	sNote		$09, nE6, $09, nR, $06, nR, $03, nF6
	sNote		nCs6, $06, $06, nAs5, nCs6, $09, nF6, $09
	sNote		nR, $06, nR, $03, nE6, nC6, $06, $06
	sNote		nA5, nC6, $09, nE6, $0F, nD6, $0C
	sRet

ScrabBrain_PSG1:
	sVolAddPSG	$01
	sEnv		None
	sCall		ScrabBrain_Call6
	sEnv		06
	sVolAddPSG	-$01
	sCall		ScrabBrain_Loop11
	sNote		nR, $60
	sEnv		None
	sVolAddPSG	-$01

ScrabBrain_Loop15:
	sCall		ScrabBrain_Call10
	sNote		nR, $0C, nF5, nR, $03, nF5, nR, nR
	sNote		nF5, nR, $09
	sCall		ScrabBrain_Call10
	sNote		nF5, $0C, nR, $06, nF5, $1E
	sLoop		$00, $02, ScrabBrain_Loop15
	sVolAddPSG	$01
	sJump		ScrabBrain_PSG1

ScrabBrain_Call10:
	sNote		nR, $0C, nE5, $07, nR, $02, nE5, $03
	sNote		nR, $18, nR, $0C, nAs5, $07, nR, $02
	sNote		nAs5, $03, nR, $18, nR, $0C, nA5, $07
	sNote		nR, $02, nA5, $03, nR, $18
	sRet

ScrabBrain_PSG2:
	sEnv		None
	sVolAddPSG	$01
	sNote		nC5, $03, nC5, nR, nC5, nR, nC5, nC5
	sGate		$00
	sNote		nB4, $4B
	sVolAddPSG	-$01

ScrabBrain_Loop18:
	sEnv		05
	sGate		$03
	sCall		ScrabBrain_Call11

ScrabBrain_Loop16:
	sNote		nG6, nG6, nD7, nG6, nC7, nG6, nB6, nG6
	sLoop		$00, $04, ScrabBrain_Loop16

ScrabBrain_Loop17:
	sNote		nA6, nA6, nDs7, nA6, nD7, nA6, nC7, nA6
	sLoop		$00, $04, ScrabBrain_Loop17
	sCall		ScrabBrain_Call11
	sLoop		$01, $02, ScrabBrain_Loop18
	sNote		nR, $60
	sVolAddPSG	$01

ScrabBrain_Loop19:
	sNote		nC7, $03, nC7, nG7, nC7, nF7, nC7, nE7
	sNote		nC7
	sLoop		$00, $02, ScrabBrain_Loop19

ScrabBrain_Loop20:
	sNote		nAs6, nAs6, nF7, nAs6, nDs7, nAs6, nCs7, nAs6
	sLoop		$00, $02, ScrabBrain_Loop20

ScrabBrain_Loop21:
	sNote		nA6, nA6, nE7, nA6, nD7, nA6, nC7, nA6
	sLoop		$00, $04, ScrabBrain_Loop21
	sLoop		$01, $04, ScrabBrain_Loop19
	sVolAddPSG	-$01
	sJump		ScrabBrain_PSG2

ScrabBrain_Call11:
	sNote		nA6, $03, nA6, nE7, nA6, nD7, nA6, nC7
	sNote		nA6
	sLoop		$00, $04, ScrabBrain_Call11
	sRet

ScrabBrain_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$03
	sNote		nA5, $03, $06, nR, nA5, $06, $0F, $0C
	sNote		$0C, $0C, $18

ScrabBrain_Loop22:
	sNote		nA5, $03, $03
	sVolAddPSG	$02
	sEnv		08
	sGate		$08
	sNote		$06
	sEnv		04
	sGate		$03
	sVolAddPSG	-$02
	sLoop		$00, $88, ScrabBrain_Loop22
	sJump		ScrabBrain_PSG3

ScrabBrain_DAC:
	sNote		dSnare, $03, $06, $06, $03, $03, $0F, dKick
	sNote		$0C, nR, $0C, dKick, dKick, $06, dSnare, dSnare
	sNote		dSnare, $03, $03

ScrabBrain_Loop23:
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, dSnare, $01
	sNote		dTimpaniMid, $05, dTimpaniHi, $06, dKick, $01, dTimpaniMid, $05
	sNote		dTimpaniHi, $06, dSnare, $01, dTimpaniMid, $05, dTimpaniHi, $06
	sLoop		$00, $02, ScrabBrain_Loop23
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, dSnare, dKick
	sNote		dSnare, $06, dTimpaniHi, $03, dTimpaniHi, dKick, $0C, dSnare
	sNote		dKick, dSnare, dKick, $06, dTimpaniHi, dSnare, $01, dTimpaniMid
	sNote		$05, dTimpaniHi, $06, dKick, $01, dTimpaniMid, $05, dSnare
	sNote		$01, dTimpaniHi, $05, dSnare, $01, dTimpaniMid, $05, dSnare
	sNote		$03, $03
	sLoop		$01, $02, ScrabBrain_Loop23

ScrabBrain_Loop24:
	sNote		dSnare, $03, dSnare, dKick, dKick, dKick, dKick, dSnare
	sNote		dSnare, dKick, dKick, dKick, dKick, dSnare, dSnare, dSnare
	sNote		dSnare
	sLoop		$00, $02, ScrabBrain_Loop24

ScrabBrain_Loop25:
	sCall		ScrabBrain_Call12
	sNote		dTimpaniHi, $02, dKick, $01, dTimpaniMid, $05, dSnare, $01
	sNote		dTimpaniHi, $05, dTimpaniMid, $06
	sCall		ScrabBrain_Call12
	sNote		dTimpaniMid, $02, dSnare, $01, dTimpaniHi, $05, dSnare, $01
	sNote		dTimpaniMid, $05, dSnare, $01, dTimpaniHi, $02, dSnare, $03
	sLoop		$01, $02, ScrabBrain_Loop25
	sJump		ScrabBrain_DAC

ScrabBrain_Call12:
	sNote		dKick, $0C, dSnare, $09, dKick, $06, $03, dKick
	sNote		$01, dTimpaniHi, $02, dTimpaniMid, $03, dSnare, $01, dTimpaniHi
	sNote		$0B
	sLoop		$00, $03, ScrabBrain_Call12
	sNote		dKick, $0C, dSnare, $09, dKick, $06, dSnare, $01
	sRet

ScrabBrain_Call1:
	sNote		nA6, $1E, nG6, $06, nF6, nG6, nE6, $30
	sNote		nG6, $1E, nF6, $06, nE6, nF6, nD6, $30
	sNote		nF6, $1E, nDs6, $06, nD6, nDs6, nC6, $18
	sNote		nD6, nE6, $03, nF6, nE6, $5A
	sLoop		$00, $02, ScrabBrain_Call1
	sRet

ScrabBrain_Call4:
	sNote		nG6, $1E, nE6, $06, nC6, nC7, nAs6, $0C
	sNote		nC7, $06, nAs6, $0C, nG6, $06, nAs6, nA6
	sNote		$24, nE6, $06, nF6, nG6, $12, nA6, $06
	sNote		nG6, $12, nE6, $0C, nG6, $1E, nE6, $06
	sNote		nC6, nC7, nAs6, $0C, nC7, $06, nAs6, $0C
	sNote		nG6, $06, nAs6, nA6, $24, nE6, $06, nF6
	sNote		nG6, $30, nR, $06
	sRet

ScrabBrain_Call2:
	sCall		ScrabBrain_Call3
	sNote		nG4, nG4, $09
	sCall		ScrabBrain_Call3
	sNote		nR, $0C
	sRet

ScrabBrain_Call3:
	sNote		nA4, $03, nA4, nGs4, nGs4, nG4, nG4, nA4
	sNote		nA4, nGs4, nGs4, nG4, nG4
	sRet

ScrabBrain_Voices:

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
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $04, $04
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $09, $09
	sReleaseRate	$00, $00, $08, $08
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $02, $00, $00
	sAttackRate	$14, $0C, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $02, $05, $05
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $A7, $92, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$01
	sFeedback	$05
	sDetune		$03, $07, $07, $03
	sMultiple	$06, $01, $04, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$04, $05, $04, $1D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $1F, $0E, $1F
	sDecay1Level	$05, $00, $06, $00
	sDecay2Rate	$04, $03, $06, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$27, $2E, $27, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
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

	sNewVoice	05					; voice number $05
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
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$14, $14, $3C, $80
	sFinishVoice

	sNewVoice	06					; voice number $06
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
