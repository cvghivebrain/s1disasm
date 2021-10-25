	sHeaderMusic
	sHeaderVoice	Labyrinth_Voices
	sHeaderTempo	$02, $06
	sHeaderDAC	Labyrinth_DAC
	sHeaderFM	Labyrinth_FM1, -$0C, $0C
	sHeaderFM	Labyrinth_FM2, -$18, $0D
	sHeaderFM	Labyrinth_FM3, -$0C, $18
	sHeaderFM	Labyrinth_FM4, -$0C, $18
	sHeaderFM	Labyrinth_FM5, $00, $12
	sHeaderPSG	Labyrinth_PSG1, -$30, $02, $00, 09
	sHeaderPSG	Labyrinth_PSG2, -$30, $02, $00, 09
	sHeaderPSG	Labyrinth_PSG3, $00, $02, $00, 04
	sHeaderFinish

Labyrinth_FM1:
	sVoice		00
	sNote		nR, $30

Labyrinth_Loop1:
	sNote		nR, $06, nE5, nG5, nE5, nG5, $09, nA5
	sNote		nB5, $0C, nC6, $06, nB5, nA5, nG5, $09
	sNote		nA5, $06, nG5, $03, nE5, $06
	sLoop		$00, $02, Labyrinth_Loop1
	sCall		Labyrinth_Call1
	sNote		nC6, $09, nD6, $06, nC6, $03, nA5, $06
	sCall		Labyrinth_Call1
	sNote		nC6, $0C, nA5, nD6, $04, nC6, nD6, nC6
	sNote		$24, nR, $30
	sCall		Labyrinth_Call2
	sNote		nC6, $0C, nC6, $06, nC6, nD6, $09, nC6
	sNote		nE6, $36
	sCall		Labyrinth_Call2
	sNote		nF6, $06, nE6, nD6, nC6, nAs5, nA5, nG5
	sNote		nF5, nE5, nC6, $12, nR, $18
	sJump		Labyrinth_Loop1

Labyrinth_Call1:
	sNote		nR, nA5, nC6, nA5, nC6, $09, nD6, nE6
	sNote		$0C, nF6, $06, nE6, nD6
	sRet

Labyrinth_Call2:
	sNote		nC6, $0C, nC6, $06, nC6, nD6, $09, nC6
	sNote		nF6, $0C, nE6, $06, nD6, nC6, nD6, $09
	sNote		nE6, $0F
	sRet

Labyrinth_FM2:
	sVoice		01
	sTiming		$01
	sNote		nR, $12, nD4, $0C, nG4, $03, nR, nG4
	sNote		nR, $09

Labyrinth_Loop2:
	sNote		nC4, $0F, nR, $03, nE4, nR, nG4, $09
	sNote		nR, $03, nA4, $09, nR, $03, nB4, $0F
	sNote		nR, $03, nA4, nR, nG4, $09, nR, $03
	sNote		nE4, $09, nR, $03
	sLoop		$00, $02, Labyrinth_Loop2

Labyrinth_Loop3:
	sNote		nF4, $0F, nR, $03, nA4, nR, nC5, $09
	sNote		nR, $03, nD5, $09, nR, $03, nE5, $0F
	sNote		nR, $03, nD5, nR, nC5, $09, nR, $03
	sNote		nA4, $09, nR, $03
	sLoop		$00, $02, Labyrinth_Loop3
	sNote		nC4, $0F, nR, $03, nE4, nR, nG4, $09
	sNote		nR, $03, nE4, $09, nR, $03, nC5, nR
	sNote		nC5, $06, nG4, nC5, nFs4, $18
	sCall		Labyrinth_Call3
	sNote		nE4, nR, nR, nE4, nA4, nR, nR, nA4
	sNote		nA4, $18
	sCall		Labyrinth_Call3
	sNote		nAs4, nR, nR, nAs4, nC5, nR, nR, nC5
	sNote		nG4, $0C, nG4
	sTiming		$01
	sJump		Labyrinth_Loop2

Labyrinth_Call3:
	sNote		nF4, $06, nR, nR, nF4, nE4, nR, nR
	sNote		nE4, nD4, nR, nR, nD4, nC4, nD4, nE4
	sNote		$0C, nF4, $06, nR, nR, nF4
	sRet

Labyrinth_FM3:
	sPan		sPanLeft
	sCall		Labyrinth_Call4
	sVib		$01, $01, $01, $04

Labyrinth_Jump1:
	sNote		nR, $60, nR, nR, nR, nR, nE6, $48
	sNote		nF6, $0C, nG6, nC6, $30, nR, nE6, $48
	sNote		nF6, $0C, nG6, nC6, $18, nD6, nE6, nG6
	sJump		Labyrinth_Jump1

Labyrinth_Call4:
	sVoice		03
	sGate		$08
	sNote		nA6, $06, nF6, nD6
	sGate		$00
	sNote		nG6, $0A, nR, $02, nG6, $03, nR, nG6
	sNote		nR, $09
	sRet

Labyrinth_FM4:
	sPan		sPanRight
	sDetuneSet	$02
	sCall		Labyrinth_Call4
	sVib		$02, $01, $02, $04
	sJump		Labyrinth_Jump1

Labyrinth_FM5:
	sVoice		02
	sGate		$08
	sNote		nC5, $06, nA4, nF4
	sGate		$00
	sNote		nC5, $09, nR, $03, nC5, nR, nC5, nR
	sNote		$09
	sVolAddFM	$03

Labyrinth_Jump2:
	sVoice		04
	sNote		nR, $4E, nG4, $03, nA4, nC5, nR, nA4
	sNote		nR, $51, nE5, $03, nC5, nA4, nR, nC5
	sNote		nR, $51, nC5, $03, nD5, nF5, nR, nD5
	sNote		nR, $51, nA5, $03, nF5, nC5, nR, nF5
	sNote		nR, $39, nG4, $06, nR, nA4, nR, nAs4
	sNote		$03, nR, nAs4, nR, nCs5, nR
	sGate		$0A
	sCall		Labyrinth_Call5
	sNote		nR, $06, nA4, nR, nB4, nR, nCs5, nCs5
	sNote		nE5
	sCall		Labyrinth_Call5
	sGate		$05
	sNote		nR, $06, nG4, $03, nA4

Labyrinth_Loop4:
	sNote		nC5, nC5, nA4, nG4
	sLoop		$00, $03, Labyrinth_Loop4
	sGate		$00
	sJump		Labyrinth_Jump2

Labyrinth_Call5:
	sNote		nE5, $12, $06, nD5, $12, $06, nC5, $12
	sNote		$06, nB4, nC5
	sGate		$14
	sNote		nD5, $0C
	sGate		$0A
	sNote		nE5, $12, $06, nD5, $12, $06
	sRet

Labyrinth_PSG1:
	sNote		nA6, $03, nA6, nF6, nF6, nD6, nD6, $21

Labyrinth_Loop5:
	sCall		Labyrinth_Call6
	sTransAdd	$05
	sLoop		$00, $02, Labyrinth_Loop5
	sTransAdd	-$0A
	sNote		nR, $06, nE6, $0C, $0C, $0C, $06, nR
	sNote		$06, nE6, $03, $09, $0C, nAs6, nAs6, $06
	sCall		Labyrinth_Call7
	sNote		nG6, $03, $09, $06, nR, $06, nB6, $0C
	sNote		$0C, $03, $09, $06
	sCall		Labyrinth_Call7
	sNote		nAs6, $03, $09, $06, nR, $06, nE6, $0C
	sNote		$06, nD6, nF6, nA6, $0C
	sJump		Labyrinth_Loop5

Labyrinth_Call6:
	sNote		nR, $06, nE6, $0C, $0C, $0C, $06, nR
	sNote		nE6, $0C, $0C, $03, $09, $06, nR, nE6
	sNote		$0C, $0C, $0C, $06, nR, nE6, $0C, $0C
	sNote		$03, $09, $06
	sRet

Labyrinth_Call7:
	sNote		nR, $06, nA6, $0C, nA6, nG6, $03, $09
	sNote		$06, nR, nF6, $0C, $0C, nE6, $03, $09
	sNote		$06, nR, nA6, $0C, $0C
	sRet

Labyrinth_PSG2:
	sNote		nC7, $03, nC7, nA6, nA6, nF6, nF6, $21

Labyrinth_Jump3:
	sTransAdd	$03

Labyrinth_Loop6:
	sCall		Labyrinth_Call6
	sTransAdd	$05
	sLoop		$00, $02, Labyrinth_Loop6
	sTransAdd	-$0D
	sNote		nR, $06, nG6, $0C, $0C, $0C, $06, nR
	sNote		$06, nG6, $03, $09, $0C, nCs7, $0C, $06
	sCall		Labyrinth_Call8
	sNote		nB6, $03, $09, $06, nR, $06, nD7, $0C
	sNote		$0C, nCs7, $03, $09, $06
	sCall		Labyrinth_Call8
	sNote		nD7, $03, $09, $06, nR, $06, nG6, $0C
	sNote		$06, nF6, $06, nA6, nC7, $0C
	sJump		Labyrinth_Jump3

Labyrinth_Call8:
	sNote		nR, $06, nC7, $0C, $0C, nB6, $03, $09
	sNote		$06, nR, nA6, $0C, $0C, nG6, $03, $09
	sNote		$06, nR, nC7, $0C, $0C
	sRet

Labyrinth_PSG3:
	sNoiseSet	snWhitePSG3
	sNote		nR, $12
	sGate		$0E
	sNote		nA5, $0C
	sGate		$03
	sNote		$06, $0C

Labyrinth_Jump4:
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call10
	sCall		Labyrinth_Call9
	sGate		$0E
	sNote		$0C
	sGate		$03
	sNote		$06, $06, $03, $03, $06, $03, $03, $06
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call10
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call9
	sCall		Labyrinth_Call11
	sNote		$03, $03
	sGate		$0E
	sNote		$06
	sGate		$03
	sNote		$03, $03
	sGate		$0E
	sNote		$06
	sCall		Labyrinth_Call11
	sVolAddPSG	-$01
	sGate		$0E
	sNote		$0C, $0C
	sVolAddPSG	$01
	sJump		Labyrinth_Jump4

Labyrinth_Call9:
	sGate		$0E
	sNote		$0C
	sGate		$03
	sNote		$06, $06, $06, $06, $06, $06
	sRet

Labyrinth_Call10:
	sGate		$0E
	sNote		$0C
	sGate		$03
	sNote		$06, $06, $06, $06, $06, $03, $03
	sRet

Labyrinth_Call11:
	sNote		nR, $03
	sGate		$03
	sNote		nA5, $06, $06, $03
	sGate		$0E
	sNote		$06
	sGate		$03
	sNote		$06, $06, $06, $06, $06, $06, $06, $06
	sGate		$03
	sNote		$06, $06, $06
	sGate		$0E
	sNote		$06
	sGate		$03
	sNote		$06, $06, $06, $06, $06, $06, $06, $06
	sNote		$06, $06, $06, $06
	sRet

Labyrinth_DAC:
	sNote		dSnare, $06, dSnare, dSnare, dKick, $0C, dSnare, $06
	sNote		$0C

Labyrinth_Loop7:
	sNote		dKick, $12, dKick, $06, dKick, $0C, dSnare
	sLoop		$00, $09, Labyrinth_Loop7
	sNote		dKick, $12, dKick, $06, dKick, dSnare, dSnare, dSnare
	sCall		Labyrinth_Call12
	sNote		dKick, $0C, dSnare, $06, dKick, dKick, $06, dSnare
	sNote		dSnare, $0C
	sCall		Labyrinth_Call12
	sNote		dKick, $0C, dSnare, $06, dKick, dKick, dSnare, dSnare
	sNote		dSnare
	sJump		Labyrinth_Loop7

Labyrinth_Call12:
	sNote		dKick, $0C, dSnare, $06, dKick, dKick, $0C, dSnare
	sNote		dKick, $0C, dSnare, $06, dKick, dKick, $0C, dSnare
	sNote		dKick, $0C, dSnare, $06, dKick, dKick, $0C, dSnare
	sRet

Labyrinth_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$01
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$04, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $0C, $07, $09
	sDecay1Level	$02, $01, $01, $02
	sDecay2Rate	$07, $07, $07, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $14, $32, $80
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
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $A7, $92, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
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
