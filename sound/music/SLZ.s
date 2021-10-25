	sHeaderMusic
	sHeaderVoice	StarLight_Voices
	sHeaderTempo	$02, $06
	sHeaderDAC	StarLight_DAC
	sHeaderFM	StarLight_FM1, -$18, $00
	sHeaderFM	StarLight_FM2, -$18, $06
	sHeaderFM	StarLight_FM3, -$24, $1A
	sHeaderFM	StarLight_FM4, -$24, $1A
	sHeaderFM	StarLight_FM5, -$0C, $20
	sHeaderPSG	StarLight_PSG1, -$3C, $06, $00, 05
	sHeaderPSG	StarLight_PSG2, -$3C, $06, $00, 05
	sHeaderPSG	StarLight_PSG3, $00, $04, $00, 04
	sHeaderFinish

StarLight_FM1:
	sVoice		00
	sNote		nR, $0C, nG5, nA5, nG6

StarLight_Jump1:
	sCall		StarLight_Call1
	sNote		nE6, $1E

StarLight_Loop1:
	sNote		nE7, $06, nC7, $3C, nR, $1E
	sLoop		$00, $03, StarLight_Loop1
	sNote		nE7, $06, nC7, $18, nG5, $0C, nA5, nG6
	sJump		StarLight_Jump1

StarLight_Call1:
	sCall		StarLight_Call2
	sNote		nE6, $1E, nF6, $06, nE6, nD6, $12, nG5
	sNote		$0C, nA5, nG6
	sCall		StarLight_Call2
	sRet

StarLight_Call2:
	sNote		nE6, $2A, nE6, $03, nF6, nG6, $09, nA6
	sNote		nAs6, $06, nA6, $0C, nG6, nF6, $1E, nF6
	sNote		$06, nE6, nF6, $1E, nD6, $0C, nE6, nF6
	sNote		$2A, nD6, $03, nE6, nF6, $09, nG6, nGs6
	sNote		$06, nG6, $0C, nF6
	sRet

StarLight_FM2:
	sVoice		01
	sTiming		$01
	sNote		nR, $30

StarLight_Jump2:
	sCall		StarLight_Call3
	sNote		nR, $06, nB3, $02, nR, $01, nB3, $02
	sNote		nR, $01, nC4, $06, nR, $03, nC4, nR
	sNote		$06, nC4, $12, nR, $06, nC4, $02, nR
	sNote		$01, nC4, $02, nR, $01, nD4, $06, nR
	sNote		$03, nD4, nR, $06, nG3, $12, nD4, $06
	sNote		nG3
	sCall		StarLight_Call3
	sNote		nR, $06, nD4, $02, nR, $01, nB3, $02
	sNote		nR, $01
	sCall		StarLight_Call4
	sNote		nB3, $02, nR, $01, nE4, $02, nR, $01
	sNote		nF4, $06, nR, $03, nF4, nR, $06, nF4
	sNote		$12, nR, $06, nG4, $02, nR, $01, nF4
	sNote		$02, nR, $01
	sCall		StarLight_Call4
	sNote		nE4, $02, nR, $01, nF4, $02, nR, $01
	sNote		nG4, $06, nR, nG3, $24
	sTiming		$01
	sJump		StarLight_Jump2

StarLight_Call3:
	sNote		nC4, $06, nR, $03, nC4, nR, $06, nC4
	sNote		$12, nR, $06, nC4, $02, nR, $01, nC4
	sNote		$02, nR, $01, nAs3, $06, nR, $03, nAs3
	sNote		$03, nR, $06, nA3, $12, nR, $06, nA3
	sNote		$02, nR, $01, nA3, $02, nR, $01

StarLight_Loop2:
	sNote		nD4, $06, nR, $03, nD4, $06, nR, $03
	sNote		nD4, $02, nR, $01, nD4, $02, nR, $01
	sTransAdd	-$01
	sLoop		$00, $04, StarLight_Loop2
	sTransAdd	$04
	sNote		nG3, $06, nR, $03, nG3, nR, $06, nG3
	sNote		$12, nR, $06, nG3, $02, nR, $01, nG3
	sNote		$02, nR, $01, nB3, $06, nR, $03, nB3
	sNote		nR, $06, nB3, $12
	sRet

StarLight_Call4:
	sNote		nC4, $06, nR, $03, nC4, nR, $06, nC4
	sNote		$12, nR, $06, nG3, $02, nR, $01, nC4
	sNote		$02, nR, $01, nD4, $06, nR, $03, nD4
	sNote		nR, $06, nD4, $12, nR, $06, nA3, $02
	sNote		nR, $01, nD4, $02, nR, $01, nE4, $06
	sNote		nR, $03, nE4, nR, $06, nE4, $12, nR
	sNote		$06
	sRet

StarLight_FM3:
	sVoice		02
	sPan		sPanLeft

StarLight_PSG1:
	sNote		nR, $30

StarLight_Jump3:
	sCall		StarLight_Call5
	sNote		nG6, $06, nR, $03, nG6, nR, $06, nG6
	sNote		$12, nR, $06, nB6, $09, nR, $03, nB6
	sNote		nR, nA6, $09, nR, $03, nG6, nR, nF6
	sNote		$0C, nR, $06
	sCall		StarLight_Call5
	sCall		StarLight_Call6
	sGate		$08
	sNote		nR, $06, nE7, $09, $09, $09, nD7, $09
	sNote		nC7, $06
	sCall		StarLight_Call6
	sGate		$00
	sNote		nR, $0C, nA6, $24
	sJump		StarLight_Jump3

StarLight_Call5:
	sNote		nG6, $06, nR, $03, nG6, nR, $06, nG6
	sNote		$18, nR, $06, nF6, nR, $03, nF6, nR
	sNote		$06, nE6, $18, nR, $06, nA6, nR, $03
	sNote		nG6, $06, nR, $03, nF6, nR, nA6, $06
	sNote		nR, $03, nG6, $06, nR, $03, nF6, nR
	sNote		nA6, $06, nR, $03, nG6, $06, nR, $03
	sNote		nF6, $18, nR, $06, nF6, nR, $03, nF6
	sNote		nR, $06, nF6, $18, nR, $06, nGs6, nR
	sNote		$03, nGs6, nR, $06, nGs6, $18, nR, $06
	sRet

StarLight_Call6:
	sGate		$08
	sNote		nR, $06, nB6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$08
	sNote		nR, $06, nC7, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$08
	sNote		nR, $06, nD7, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sRet

StarLight_FM4:
	sVoice		02
	sPan		sPanRight

StarLight_PSG2:
	sNote		nR, $30

StarLight_Jump4:
	sCall		StarLight_Call7
	sNote		nE6, $06, nR, $03, nE6, nR, $06, nE6
	sNote		$12, nR, $06, nG6, $09, nR, $03, nG6
	sNote		nR, nF6, $09, nR, $03, nE6, nR, nD6
	sNote		$0C, nR, $06
	sCall		StarLight_Call7
	sCall		StarLight_Call8
	sGate		$08
	sNote		nR, $06, nC7, $09, $09, $09, nB6, $09
	sNote		nA6, $06
	sGate		$08
	sCall		StarLight_Call8
	sGate		$00
	sNote		nR, $0C, nF6, $24
	sJump		StarLight_Jump4

StarLight_Call7:
	sNote		nE6, $06, nR, $03, nE6, nR, $06, nE6
	sNote		$18, nR, $06, nD6, nR, $03, nD6, nR
	sNote		$06, nCs6, $18, nR, $06, nF6, nR, $03
	sNote		nE6, $06, nR, $03, nD6, nR, nF6, $06
	sNote		nR, $03, nE6, $06, nR, $03, nD6, nR
	sNote		nF6, $06, nR, $03, nE6, $06, nR, $03
	sNote		nD6, $18, nR, $06, nD6, nR, $03, nD6
	sNote		nR, $06, nD6, $18, nR, $06, nF6, nR
	sNote		$03, nF6, nR, $06, nF6, $18, nR, $06
	sRet

StarLight_Call8:
	sGate		$08
	sNote		nR, $06, nG6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$08
	sNote		nR, $06, nA6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$08
	sNote		nR, $06, nB6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sRet

StarLight_FM5:
	sVoice		04
	sNote		nR, $0C, nG5, nA5, nG6

StarLight_Jump5:
	sVoice		04
	sCall		StarLight_Call1
	sNote		nE6, $06
	sVoice		03
	sVolAddFM	-$14
	sCall		StarLight_Call9
	sDetuneSet	$14
	sNote		nA5, $01, sTie
	sDetuneSet	$00
	sNote		nA5, $05
	sCall		StarLight_Call11
	sNote		nDs4
	sVolAddFM	$07
	sNote		nDs4
	sVoice		03
	sVolAddFM	-$18
	sTransAdd	-$33
	sNote		nR, $06
	sDetuneSet	$14
	sNote		nE6, $01, sTie
	sDetuneSet	$00
	sNote		nE6, $05, nF6, $06, nE6, nF6, nG6, nR
	sNote		nC6, nR, $06
	sCall		StarLight_Call9
	sGate		$05
	sNote		nA5, $03, $03
	sGate		$00
	sCall		StarLight_Call11
	sVoice		03
	sVolAddFM	-$11
	sTransAdd	-$33
	sNote		nE6, $03, nF6, nG6, $03, nR, $09
	sDetuneSet	-$14
	sNote		nC7, $01, sTie
	sDetuneSet	$00
	sVib		$2C, $01, $04, $04
	sNote		nC7, $23
	sVibOff
	sVolAddFM	$14
	sJump		StarLight_Jump5

StarLight_Call9:
	sCall		StarLight_Call10
	sNote		nDs4
	sVolAddFM	$07
	sNote		nDs4
	sVoice		03
	sVolAddFM	-$18
	sTransAdd	-$33
	sNote		nR, $06
	sDetuneSet	$14
	sNote		nE6, $01, sTie
	sDetuneSet	$00
	sNote		$05, nR, $06
	sDetuneSet	$14
	sNote		nC6, $01, sTie
	sDetuneSet	$00
	sNote		$05, nR, $06
	sRet

StarLight_Call11:
	sNote		nC6, $06, nA5, nR, $06

StarLight_Call10:
	sDetuneSet	$14
	sNote		nG5, $01, sTie
	sDetuneSet	$00
	sNote		$02, nA5, $03
	sGate		$05
	sNote		nC6, $03, nC6, $06, nA5, $03, nC6, $03
	sGate		$00
	sNote		nC6, nR
	sVolAddFM	-$04
	sTransAdd	$33
	sVoice		05
	sNote		nDs4, $03
	sVolAddFM	$07
	sNote		nDs4
	sVolAddFM	$07
	sNote		nDs4
	sVolAddFM	$07
	sRet

StarLight_Jump8:

	; Unused data
	sJump		StarLight_Jump8

StarLight_Jump9:
	sJump		StarLight_Jump9

StarLight_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$02
	sNote		nR, $24

StarLight_Jump6:
	sNote		nA5, $03, $03
	sVolAddPSG	$02
	sEnv		08
	sGate		$08
	sNote		$06
	sEnv		04
	sGate		$03
	sVolAddPSG	-$02
	sJump		StarLight_Jump6

StarLight_DAC:
	sNote		nR, $30

StarLight_Jump7:
	sNote		dKick, $0C
	sJump		StarLight_Jump7

StarLight_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$06
	sDetune		$03, $07, $04, $07
	sMultiple	$03, $0E, $01, $04
	sRateScale	$01, $01, $02, $00
	sAttackRate	$1B, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $07, $07, $08
	sDecay1Level	$0F, $0E, $0F, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $29, $90, $97
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
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$07, $03, $04, $03
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
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

	sNewVoice	04					; voice number $04
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $07, $07, $03
	sMultiple	$08, $06, $04, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $10, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $04, $07, $07
	sDecay1Level	$02, $02, $02, $02
	sDecay2Rate	$03, $03, $09, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1E, $1E, $80, $80
	sFinishVoice

	sNewVoice	05					; voice number $05
	sAlgorithm	$04
	sFeedback	$1E
	sDetune		$00, $00, $00, $00
	sMultiple	$06, $0F, $04, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0B, $00, $0B
	sDecay1Level	$00, $0F, $00, $0F
	sDecay2Rate	$00, $05, $00, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$15, $02, $85, $8A
	sFinishVoice
	even
