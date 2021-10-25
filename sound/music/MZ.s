	sHeaderMusic
	sHeaderVoice	Marble_Voices
	sHeaderTempo	$02, $09
	sHeaderDAC	Marble_DAC
	sHeaderFM	Marble_FM1, -$18, $15
	sHeaderFM	Marble_FM2, -$18, $0E
	sHeaderFM	Marble_FM3, -$18, $15
	sHeaderFM	Marble_FM4, -$18, $17
	sHeaderFM	Marble_FM5, -$18, $17
	sHeaderPSG	Marble_PSG1, -$30, $03, $00, 08
	sHeaderPSG	Marble_PSG2, -$30, $05, $00, 08
	sHeaderPSG	Marble_PSG3, $0B, $03, $00, 09
	sHeaderFinish

Marble_FM3:
	sDetuneSet	$02

Marble_FM1:
	sVoice		00
	sNote		nR, $24

Marble_Jump1:
	sCall		Marble_Call1
	sNote		nA6, $09, nR, $03, nA6, $06, nG6, nA6
	sNote		$09, nR, $03, nA6, $06, nG6, nA6, $09
	sNote		nR, $03, nA6, $06, nG6, nA6, $0C, nB6
	sNote		nF6, $12, nE6, $35, nR, $01
	sCall		Marble_Call1
	sNote		nA6, $24, nB6, $0C, nGs6, $24, nB6, $09
	sNote		nR, $03, nB6, $12, nA6, $4D, nR, $61
	sNote		nR, $48
	sJump		Marble_Jump1

Marble_Call1:
	sNote		nA5, $06, nB5, nC6, nE6, nB6, $09, nR
	sNote		$03, nB6, $06, nA6, nB6, $09, nR, $03
	sNote		nB6, $06, nA6, nB6, $09, nR, $03, nB6
	sNote		$06, nA6, nB6, nA6, nE6, nC6, nG6, $0C
	sNote		nA6, $06, sTie, nF6, $4D, nR, $01
	sRet

Marble_FM4:
	sVoice		03
	sVolAddFM	-$09
	sNote		nR, $06, nE5, $03, $03, $06, nR, nE4
	sNote		$1E
	sVoice		02
	sVolAddFM	$09
	sNote		nB6, $06

Marble_Jump3:
	sCall		Marble_Call3
	sNote		nA6, $09, nR, $03, nA6, nR, nB6, $06
	sNote		nR, nA6, $0C, nR, $06, nA6, $09, nR
	sNote		$03, nA6, nR, nB6, $06, nR, nA6, $0C
	sNote		nR, $18, nG6, $03, nR, $0F, nG6, $03
	sNote		nR, $39, nB6, $06
	sCall		Marble_Call3
	sNote		nF6, $09, nR, $03, nF6, nR, nA6, $06
	sNote		nR, nF6, $0C, nR, $06, nGs6, $09, nR
	sNote		$03, nGs6, nR, nB6, $06, nR, nGs6, $0C
	sNote		nR, $18, nC7, $03, nR, $0F, nC7, $03
	sNote		nR, $09, nE7, $09, nR, $03, nE7, nR
	sNote		nD7, $06, nR, nC7, $03, nR, nB6, $12
	sCall		Marble_Call4
	sJump		Marble_Jump3

Marble_Call3:
	sNote		sTie, $03, nR, nB6, nR, nC7, $06, nR
	sNote		nB6, $0C, nR, $06, nB6, $09, nR, $03
	sNote		nB6, nR, nC7, $06, nR, nB6, $0C, nR
	sNote		$18, nC7, $03, nR, $0F, nC7, $03, nR
	sNote		$1B, nC7, $03, nR, $0F, nC7, $03, nR
	sNote		$09
	sRet

Marble_FM5:
	sVoice		04
	sVolAddFM	-$04
	sTransAdd	$24
	sNote		nR, $06, nE4, $03, $03, $06, nR, nE3
	sNote		$1E
	sVoice		02
	sTransAdd	-$24
	sVolAddFM	$04
	sNote		nG6, $06

Marble_Jump4:
	sCall		Marble_Call5
	sNote		nF6, $09, nR, $03, nF6, nR, nG6, $06
	sNote		nR, nF6, $0C, nR, $06, nF6, $09, nR
	sNote		$03, nF6, nR, nG6, $06, nR, nF6, $0C
	sNote		nR, $18, nE6, $03, nR, $0F, nE6, $03
	sNote		nR, $39, nG6, $06
	sCall		Marble_Call5
	sNote		nD6, $09, nR, $03, nD6, nR, nF6, $06
	sNote		nR, nD6, $0C, nR, $06, nE6, $09, nR
	sNote		$03, nE6, nR, nGs6, $06, nR, nE6, $0C
	sNote		nR, $18, nA6, $03, nR, $0F, nA6, $03
	sNote		nR, $09, nC7, $09, nR, $03, nC7, nR
	sNote		nB6, $06, nR, nA6, $03, nR, nGs6, $12
	sDetuneSet	$03
	sCall		Marble_Call4
	sDetuneSet	$00
	sJump		Marble_Jump4

Marble_Call5:
	sNote		sTie, $03, nR, nG6, nR, nA6, $06, nR
	sNote		nG6, $0C, nR, $06, nG6, $09, nR, $03
	sNote		nG6, nR, nA6, $06, nR, nG6, $0C, nR
	sNote		$18, nA6, $03, nR, $0F, nA6, $03, nR
	sNote		$1B, nA6, $03, nR, $0F, nA6, $03, nR
	sNote		$09
	sRet

Marble_FM2:
	sVoice		01
	sNote		nR, $06, nE4, $03, nE4
	sTiming		$01
	sNote		nE4, $06, nR, nE3, $24

Marble_Jump2:
	sCall		Marble_Call2

Marble_Loop2:
	sNote		nG3, $03, nR, nG3, $06, nD4, $03, nR
	sNote		nD4, $06, nB3, $03, nR, nB3, $06, nD4
	sNote		$03, nR, nD4, $06
	sLoop		$01, $02, Marble_Loop2
	sNote		nC4, $03, nR, nC4, $06, nG4, $03, nR
	sNote		nG4, $06, nE4, $03, nR, nE4, $06, nG4
	sNote		$03, nR, nG4, $06, nB3, $03, nR, nB3
	sNote		$06, nF4, $03, nR, nF4, $06, nE4, $03
	sNote		nR, nE4, $06, nB3, $03, nR, nB3, $06
	sCall		Marble_Call2
	sNote		nB3, $03, nR, nB3, $06, nF4, $03, nR
	sNote		nF4, $06, nD4, $03, nR, nD4, $06, nF4
	sNote		$03, nR, nF4, $06, nE4, $03, nR, nE4
	sNote		$06, nB4, $03, nR, nB4, $06, nGs4, $03
	sNote		nR, nGs4, $06, nB4, $03, nR, nB4, $06
	sNote		nA3, $03, nR, nA3, $06, nE4, $03, nR
	sNote		nE4, $06, nC4, $03, nR, nC4, $06, nE4
	sNote		$03, nR, nE4, $06, nA3, $03, nR, nA3
	sNote		$06, nE4, $03, nR, nE4, $06, nD4, $03
	sNote		nR, nD4, $06, nE4, $03, nR, nE4, $06

Marble_Loop3:
	sNote		nA3, $12, nA3, $06, nG3, $12, nG3, $06
	sNote		nF3, $12, nF3, $06, nG3, $12, nG3, $06
	sLoop		$01, $02, Marble_Loop3
	sTiming		$01
	sJump		Marble_Jump2

Marble_Call2:
	sNote		nA3, $03, nR, nA3, $06, nE4, $03, nR
	sNote		nE4, $06, nD4, $03, nR, nD4, $06, nE4
	sNote		$03, nR, nE4, $06
	sLoop		$00, $02, Marble_Call2

Marble_Loop1:
	sNote		nD4, $03, nR, nD4, $06, nA4, $03, nR
	sNote		nA4, $06, nF4, $03, nR, nF4, $06, nA4
	sNote		$03, nR, nA4, $06
	sLoop		$00, $02, Marble_Loop1
	sRet

Marble_PSG1:
	sNote		nR, $3C

Marble_Jump5:
	sNote		nR, $60
	sCall		Marble_Call6
	sNote		nR, $2A, nF7, $0C, nF7, $06, nD7, $0C
	sNote		nB6, $06, nGs6, $2A, nR, $48
	sCall		Marble_Call6
	sNote		nR, $60

Marble_Loop5:
	sNote		nA6, $06, nC7, $03, nA6, nC7, $06, nA6
	sNote		nB6, nG6, nD6, nB6, nF6, nA6, $03, nF6
	sNote		nA6, $06, nF6, nG6, nA6, nB6, nG6
	sLoop		$00, $02, Marble_Loop5
	sJump		Marble_Jump5

Marble_Call6:
	sNote		nR, $30, nF7, $03, nD7, nA6, nF6, nD7
	sNote		nA6, nF6, nD6, nA6, nF6, nD6, nA5, nF6
	sNote		nD6, nA5, nF5, $27, nR, $3C
	sRet

Marble_PSG2:
	sNote		nR, $02
	sDetuneSet	$01
	sJump		Marble_PSG1

Marble_PSG3:
	sNoiseSet	snWhitePSG3
	sVolAddPSG	-$01
	sNote		nR, $06, nE5, $03, $03, $06, nR, nE4
	sNote		$24
	sVolAddPSG	$01

Marble_Jump6:
	sCall		Marble_Call7
	sNote		nG3, nG3, nD4, nD4, nB3, nB3, nD4, nD4
	sNote		nG3, nG3, nD4, nD4, nB3, nB3, nD4, nD4
	sNote		nC4, nC4, nG4, nG4, nE4, nE4, nG4, nG4
	sNote		nB3, nB3, nF4, nF4, nE4, nE4, nB3, nB3
	sCall		Marble_Call7
	sNote		nB3, nB3, nF4, nF4, nD4, nD4, nF4, nF4
	sNote		nE4, nE4, nB4, nB4, nGs4, nGs4, nB4, nB4
	sNote		nA3, nA3, nE4, nE4, nC4, nC4, nE4, nE4
	sNote		nA3, nA3, nE4, nE4, nD4, nD4, nE4, nE4
	sVolAddPSG	-$01

Marble_Loop6:
	sNote		nA4, $12, nA4, $06, nG4, $12, nG4, $06
	sNote		nF4, $12, nF4, $06, nG4, $12, nG4, $06
	sLoop		$00, $02, Marble_Loop6
	sVolAddPSG	$01
	sJump		Marble_Jump6

Marble_Call7:
	sNote		nA3, $06, nA3, nE4, nE4, nD4, nD4, nE4
	sNote		nE4, nA3, nA3, nE4, nE4, nD4, nD4, nE4
	sNote		nE4, nD4, nD4, nA4, nA4, nF4, nF4, nA4
	sNote		nA4, nD4, nD4, nA4, nA4, nF4, nF4, nA4
	sNote		nA4
	sRet

Marble_DAC:
	sNote		nR, $06, dSnare, $03, $03, $0C, dKick, $0C
	sNote		$0C, $0C

Marble_Jump7:
	sNote		dKick, $0C
	sJump		Marble_Jump7

Marble_Call4:
	sGate		$06

Marble_Loop4:
	sNote		nR, $06, nE7, nC7, nA6, $0C, nD7, $06
	sNote		nB6, nG6, nR, nC7, nA6, nF6, $0C, nD7
	sNote		$06, nB6, nG6
	sLoop		$00, $02, Marble_Loop4
	sGate		$00
	sRet

Marble_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$04
	sDetune		$00, $00, $01, $01
	sMultiple	$0A, $05, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$03, $12, $12, $11
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $13, $13, $00
	sDecay1Level	$01, $00, $01, $00
	sDecay2Rate	$03, $02, $02, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1E, $26, $18, $81
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
	sDecay1Level	$01, $00, $00, $0A
	sDecay2Rate	$03, $03, $01, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$21, $31, $47, $80
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
	sAlgorithm	$03
	sFeedback	$04
	sDetune		$07, $00, $03, $00
	sMultiple	$0C, $00, $02, $00
	sRateScale	$01, $03, $01, $03
	sAttackRate	$1F, $1C, $18, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $0B, $04
	sDecay1Level	$01, $0B, $01, $0B
	sDecay2Rate	$06, $08, $0C, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $16, $26, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
	sAlgorithm	$02
	sFeedback	$00
	sDetune		$03, $05, $03, $05
	sMultiple	$0C, $05, $02, $01
	sRateScale	$00, $00, $02, $02
	sAttackRate	$1F, $1F, $18, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0E, $11, $11
	sDecay1Level	$05, $06, $00, $00
	sDecay2Rate	$0E, $08, $05, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$2D, $2F, $2D, $80
	sFinishVoice
