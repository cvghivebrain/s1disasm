	sHeaderMusic
	sHeaderVoice	Final_Voices
	sHeaderTempo	$02, $06
	sHeaderDAC	Final_DAC
	sHeaderFM	Final_FM1, $00, $12
	sHeaderFM	Final_FM2, -$0C, $0D
	sHeaderFM	Final_FM3, -$0C, $0A
	sHeaderFM	Final_FM4, -$0C, $0F
	sHeaderFM	Final_FM5, $00, $12
	sHeaderPSG	Final_PSG1, -$30, $03, $00, 05
	sHeaderPSG	Final_PSG1, -$24, $06, $00, 05
	sHeaderPSG	Final_PSG1, -$24, $00, $00, 04
	sHeaderFinish

Final_FM5:
	sDetuneSet	$03
	sJump		Final_Jump4

Final_FM1:
	sVib		$1A, $01, $06, $04

Final_Jump4:
	sVoice		00
	sNote		nB6, $03, nR, nGs6, nR, nGs6, nR, nB6
	sNote		nB6, nR, $18

Final_Jump1:
	sNote		nR, $0C, nA5, nB5, nC6, nD6, nC6, nB5
	sNote		nC6, nE6, $60, nR, $0C, nA5, nB5, nC6
	sNote		nD6, nC6, nB5, nC6, nF6, $30, nG6, $18
	sNote		nGs6, nA5, $0C, nA5, nA5, nA5, nB5, nB5
	sNote		nB5, nB5
	sJump		Final_Jump1

Final_FM2:
	sVoice		01
	sTiming		$01
	sNote		nE4, $03, nR, nE3, nR, nE3, nR, nE4
	sNote		nE4, nR, $12, nC4, $03, nB3

Final_Jump2:
	sCall		Final_Call1
	sNote		nC4, $03, nB3
	sCall		Final_Call1
	sNote		nGs3, $06, nF3, $0C, nF3, $09, nF3, $03
	sNote		nF3, $06, nF3, $0C, nC3, $06, nG3, nG3
	sNote		$0C, nG3, $06, nE3, nE3, $0C, nC4, $03
	sNote		nB3
	sTiming		$01
	sJump		Final_Jump2

Final_Call1:
	sNote		nA3, $0C, nA3, $09, nA3, $03, nA3, $06
	sNote		nA3, $0C, nE3, $06, nA3, $03, nE3, nA3
	sNote		$0C, nE3, $06, nA3, $0C, nG3, nF3, nF3
	sNote		$09, nF3, $03, nF3, $06, nF3, $0C, nC3
	sNote		$06, nG3, nG3, $0C, nG3, $06, nGs3, nGs3
	sNote		$0C
	sRet

Final_FM3:
	sVoice		02
	sNote		nE7, $03, nR, nE6, nR, nE6, nR, nE7
	sNote		nE7, $03, nR, $18

Final_Jump3:
	sCall		Final_Call2
	sNote		nD7, $06, nR, nC7, $03, nR, nB6, nR
	sNote		nGs6, $12
	sCall		Final_Call2
	sNote		nD7, $06, nR, nC7, $03, nR, nB6, nR
	sNote		nGs6, $12, nA5, $18, nB5, $0C, nC6, nB5
	sNote		$18, nC6, $0C, nD6
	sJump		Final_Jump3

Final_Call2:
	sNote		nR, $1E, nA4, $03, nR, nC5, nR, nE5
	sNote		nR, nA5, $03, nG5, nA5, $30, nC7, $06
	sNote		nR, nA6, $03, nR, nF6, nR, nD6, $18
	sRet

Final_FM4:
	sVoice		02
	sVolAddFM	-$04
	sDetuneSet	$03
	sNote		nE7, $03, nR, nE6, nR, nE6, nR, nE7
	sNote		nE7, $03, nR, $18
	sVolAddFM	$04
	sVoice		03

Final_Loop1:
	sNote		nA4, $06, nE4, nB4, nE4, nC5, nE4, nB4
	sNote		nE4, nA4, nE4, nB4, nE4, nC5, nE4, nB4
	sNote		nE4, nA4, nE4, nB4, nE4, nC5, nE4, nA4
	sNote		nE4, nB4, nE4, nD5, nE4, nC5, nE4, nB4
	sNote		nE4
	sLoop		$00, $02, Final_Loop1

Final_Loop2:
	sNote		nC7, $03, nB6, nAs6, nA6
	sLoop		$00, $04, Final_Loop2

Final_Loop3:
	sNote		nD7, nCs7, nC7, nB6
	sLoop		$00, $04, Final_Loop3
	sJump		Final_Loop1

Final_PSG1:
	sEnd

Final_DAC:
	sNote		dTimpaniHi, $06, dTimpaniLow, dTimpaniLow, dTimpaniHi, $03, dTimpaniHi, $09
	sNote		dSnare, $03, dSnare, $03, dSnare, $03, dSnare, $03
	sNote		dTimpaniLow, dTimpaniLow

Final_Loop4:
	sNote		dSnare, $0C, $09, $03, $06, $06, dTimpaniHi, dTimpaniLow
	sNote		dSnare, dSnare, $0C, $06, $0C, $0C, $0C, $09
	sNote		$03, $06, $06, dTimpaniHi, $03, dTimpaniHi, dTimpaniLow, $06
	sNote		dSnare, $06, $0C, $06, $06, $0C, $06
	sLoop		$00, $02, Final_Loop4
	sNote		$0C, $09, $03, $06, $0C, $06, dTimpaniHi, $06
	sNote		dTimpaniLow, dTimpaniHi, dTimpaniLow, dTimpaniHi, dTimpaniLow, dTimpaniHi, dTimpaniLow
	sJump		Final_Loop4

Final_Voices:

	sNewVoice	00					; voice number $00
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
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$19, $13, $37, $80
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
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$04, $01, $04, $07
	sMultiple	$02, $04, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $02, $0A
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$01, $02, $01, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $19, $16, $80
	sFinishVoice
