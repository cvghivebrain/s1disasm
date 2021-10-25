	sHeaderMusic
	sHeaderVoice	Boss_Voices
	sHeaderTempo	$02, $04
	sHeaderDAC	Boss_DAC
	sHeaderFM	Boss_FM1, -$0C, $12
	sHeaderFM	Boss_FM2, -$18, $08
	sHeaderFM	Boss_FM3, -$0C, $0F
	sHeaderFM	Boss_FM4, -$0C, $12
	sHeaderFM	Boss_FM5, -$18, $0F
	sHeaderPSG	Boss_PSG1, -$30, $03, $00, 05
	sHeaderPSG	Boss_PSG2, -$30, $03, $00, 05
	sHeaderPSG	Boss_PSG3, -$24, $01, $00, 08
	sHeaderFinish

Boss_FM5:
	sVoice		05

Boss_Jump4:
	sNote		nFs7, $0C, nFs7, nFs7, nFs7
	sVolAddFM	$02
	sCall		Boss_Call4
	sNote		nA6, nFs6, nG6, nFs6, nE6, nFs6, nA6, nFs6
	sNote		nG6, nFs6, nCs7, nFs6, nE6, nFs6
	sCall		Boss_Call4
	sNote		nB6, nFs6, nA6, nFs6, nG6, nFs6, nA6, nFs6
	sNote		nB6, nFs6, nCs7, nB6, nF7, nCs7
	sVolAddFM	-$02

Boss_Loop1:
	sNote		nFs7, $03, nD7, $03, nFs7, $03, nD7, $03
	sLoop		$00, $04, Boss_Loop1
	sJump		Boss_Jump4

Boss_Call4:
	sNote		nB6, $06, nFs6, nD7, nFs6, nB6, nFs6, nE6
	sNote		nFs6, nB6, nFs6, nD7, nFs6, nB6, nFs6, nA6
	sNote		nFs6, nG6, nFs6
	sRet

Boss_FM2:
	sVoice		00

Boss_Jump2:
	sTiming		$01
	sNote		nFs4, $06, nFs5, nFs4, nFs5, nFs4, nFs5, nFs4
	sNote		nFs5
	sCall		Boss_Call2
	sNote		nB3, $06, nE4, nE4, $0C, nB3, $06
	sCall		Boss_Call2
	sNote		nE4, $06, nD4, nD4, $0C, nD4, $06, nCs4
	sNote		$30
	sTiming		$01
	sJump		Boss_Jump2

Boss_Call2:
	sNote		nB3, $06, nB3, nD4, nD4, nCs4, nCs4, nC4
	sNote		nC4, nB3, $12, nFs4, $06, nB4, $0C, nA4
	sNote		nG4, $06, nG4, $0C, nD4, $06, nG4, nG4
	sNote		$0C, nFs4, $06, nE4, nE4, $0C
	sRet

Boss_PSG2:
	sDetuneSet	$02
	sJump		Boss_Jump3

Boss_FM3:
	sVoice		01
	sPan		sPanLeft

Boss_Jump3:
	sNote		nR, $30
	sCall		Boss_Call3
	sNote		nE5, $12, nR, nD6, $03, nR, nCs6, nR
	sNote		nA5, $12
	sCall		Boss_Call3
	sNote		nE5, $0C, nB5, $03, nR, nE6, nR, nE6
	sNote		$0C, nE6, $03, nR, nF6, nR, nF6, $0C
	sNote		nF6, $03, nR, nFs6, $30
	sJump		Boss_Jump3

Boss_Call3:
	sNote		nR, $1E, nFs5, $03, nR, nB5, nR, nCs6
	sNote		nR, nD6, $30, nR, $12, nB5, $03, nR
	sNote		nG5, nR
	sRet

Boss_FM1:
	sDetuneSet	$03
	sJump		Boss_Jump1

Boss_FM4:
	sPan		sPanRight

Boss_Jump1:
	sVoice		02
	sVib		$0C, $01, $04, $06

Boss_PSG1:
	sNote		nR, $30
	sCall		Boss_Call1
	sNote		nE7
	sCall		Boss_Call1
	sNote		nE7, $18, nF7, nFs7, $30
	sJump		Boss_PSG1

Boss_Call1:
	sNote		nB6, $04, nA6, nC7, nB6, $24, nR, $0C
	sNote		nFs6, nB6, nCs7, nD7, $30
	sRet

Boss_PSG3:
	sEnd

Boss_DAC:
	sNote		dTimpaniHi, $06, dTimpaniLow, dTimpaniHi, dTimpaniLow, dTimpaniHi, dTimpaniLow, dTimpaniHi
	sNote		dTimpaniLow

Boss_Loop2:
	sNote		dSnare, $0C, dSnare, $04, dSnare, dSnare, dSnare, $06
	sNote		dSnare, $0C, dSnare, $06, dSnare, $12, dSnare, $06
	sNote		dSnare, $0C, dSnare, $0C
	sLoop		$00, $03, Boss_Loop2
	sNote		dSnare, $0C, dSnare, $04, dSnare, dSnare, dSnare, $06
	sNote		dSnare, $0C, dSnare, $06, dSnare, $06, dSnare, $0C
	sNote		dSnare, $06, dSnare, $06, dSnare, $0C, dSnare, $06
	sNote		dSnare, $01, dTimpaniHi, $05, dTimpaniLow, $06, dTimpaniHi, dTimpaniLow
	sNote		dTimpaniHi, dTimpaniLow, dTimpaniHi, dTimpaniLow
	sJump		Boss_DAC

Boss_Voices:

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

	sNewVoice	03					; voice number $03
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

	sNewVoice	04					; voice number $04
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$00, $00, $05, $00
	sMultiple	$01, $00, $01, $00
	sRateScale	$00, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $09, $11, $09
	sDecay1Level	$02, $02, $02, $01
	sDecay2Rate	$07, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$20, $20, $22, $80
	sFinishVoice

	sNewVoice	05					; voice number $05
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$04, $01, $04, $07
	sMultiple	$02, $04, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $02, $0A
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$01, $02, $01, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $19, $16, $80
	sFinishVoice
	even
