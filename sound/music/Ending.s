	sHeaderMusic
	sHeaderVoice	Ending_Voices
	sHeaderTempo	$01, $05
	sHeaderDAC	Ending_DAC
	sHeaderFM	Ending_FM1, -$0C, $0E
	sHeaderFM	Ending_FM2, -$0C, $09
	sHeaderFM	Ending_FM3, -$0C, $0D
	sHeaderFM	Ending_FM4, -$0C, $0D
	sHeaderFM	Ending_FM5, -$0C, $17
	sHeaderPSG	Ending_PSG1, -$30, $05, $00, 05
	sHeaderPSG	Ending_PSG2, -$24, $05, $00, 05
	sHeaderPSG	Ending_PSG3, $00, $03, $00, 04
	sHeaderFinish

Ending_FM1:
	sVoice		03
	sNote		nR, $60
	sCall		Ending_Call1
	sNote		nR, $60
	sVolAddFM	-$05
	sNote		nR, $0C, nE6, $06, nR, nB6, nE6, $06
	sNote		nR, $0C, nE6, $06, nR, nB6, nE6, $06
	sNote		nR, $18
	sVolAddFM	$05
	sNote		nR, $0C, nA3, nR, nA3, nR, $24
	sDetuneSet	$02
	sVolAddFM	$08
	sNote		nA2, $6C
	sEnd

Ending_Call1:
	sNote		nR, $0C, nCs6, $15, nR, $03, nCs6, $06
	sNote		nR, nD6, $0F, nR, $03, nB5, $18, nR
	sNote		$06, nCs6, nR, nCs6, nR, nCs6, nR, nA5
	sNote		nR, nG5, $0F, nR, $03, nB5, $18, nR
	sNote		$06
	sLoop		$00, $02, Ending_Call1
	sRet

Ending_FM2:
	sVoice		01
	sTiming		$01
	sNote		nR, $60

Ending_Loop1:
	sNote		nA3, $06, nR, nA3, nR, nE3, nR, nE3
	sNote		nR, nG3, $12, nFs3, $0C, nG3, $06, nFs3
	sNote		$0C, nA3, $06, nR, nA3, nR, nE3, nR
	sNote		nE3, nR, nD4, $12, nCs4, $0C, nD4, $06
	sNote		nCs4, $0C
	sLoop		$00, $02, Ending_Loop1
	sNote		nG3, $06, nR, nE3, nR, nF3, nR, nFs3
	sNote		nR, nG3, nG3, nE3, nR, nF3, nR, nG3
	sNote		nR, nE3, nR, nE3, nR, nGs3, nR, nGs3
	sNote		nR, nB3, nR, nB3, nR, nD4, nR, nD4
	sNote		nR, nR, $0C, nA2, $12, nR, $06, nA2
	sNote		$12, nGs3, nA3, $06, nR
	sVolAddFM	-$03
	sNote		nA2, $6C
	sTiming		$01
	sEnd

Ending_FM3:
	sVoice		02
	sNote		nR, $60

Ending_Loop2:
	sNote		nE6, $06, nR, nE6, nR, nCs6, nR, nCs6
	sNote		nR, nD6, $12, nD6, $1E, nE6, $06, nR
	sNote		nE6, nR, nCs6, nR, nCs6, nR, nG6, $12
	sNote		nG6, $1E
	sLoop		$00, $02, Ending_Loop2
	sNote		nR, $0C, nD6, $12, nR, $06, nD6, nR
	sNote		nCs6, $12, nD6, nCs6, $0C, nGs5, $18, nB5
	sNote		nD6, nGs6, nR, $0C, nE6, nR, nE6, $12
	sNote		nDs6, nE6, $06, nR
	sVolAddFM	-$08
	sVoice		01
	sDetuneSet	$03
	sNote		nA2, $6C
	sEnd

Ending_FM4:
	sVoice		02
	sNote		nR, $60

Ending_Loop3:
	sNote		nCs6, $06, nR, nCs6, nR, nA5, nR, nA5
	sNote		nR, nB5, $12, nB5, $1E, nCs6, $06, nR
	sNote		nCs6, nR, nA5, nR, nA5, nR, nD6, $12
	sNote		nD6, $1E
	sLoop		$00, $02, Ending_Loop3
	sDetuneSet	$03
	sVolAddFM	$08
	sCall		Ending_Call2
	sVolAddFM	-$10
	sVoice		01
	sVib		$00, $01, $06, $04
	sNote		nA2, $6C
	sEnd

Ending_Call2:
	sVoice		00
	sNote		nR, $0C, nG6, nB6, nD7, nFs7, $0C, nR
	sNote		$06, nFs7, $0C, nG7, $06, nFs7, $0C, nGs7
	sNote		$60, nA7, $0C, nR, nA7, nR, nR, $06
	sNote		nGs7, $12, nA7, $0C
	sRet

Ending_FM5:
	sVoice		03
	sDetuneSet	$03
	sVolAddFM	-$09
	sNote		nR, $60
	sCall		Ending_Call1
	sVolAddFM	$09
	sVib		$00, $01, $06, $04
	sCall		Ending_Call2
	sEnd

Ending_PSG1:
	sNote		nR, $60, nR, nR, nR, nR, nR, $0C
	sNote		nB5, $12, nR, $06, nB5, nR, nA5, $12
	sNote		nB5, nA5, $0C, nE5, $18, nGs5, nB5, nD6
	sNote		nR, $0C, nCs6, nR, nCs6, $12, nC6, nCs6
	sNote		$06
	sEnd

Ending_PSG2:
	sDetuneSet	$01
	sNote		nR, $60, nR, nR, nR, nR, nR, nR
	sNote		$0C, nE6, $06, nR, nB6, nE6, nR, $0C
	sNote		nE6, $06, nR, nB6, nE6, nR, $18
	sEnd

Ending_PSG3:
	sNoiseSet	snWhitePSG3

Ending_Loop4:
	sGate		$03
	sNote		nA5, $0C
	sGate		$0C
	sNote		$0C
	sGate		$03
	sNote		$0C
	sGate		$0C
	sNote		$0C
	sLoop		$00, $0F, Ending_Loop4
	sGate		$03
	sNote		nA5, $06
	sGate		$0E
	sNote		$12
	sGate		$03
	sNote		$0C
	sGate		$0F
	sNote		$0C
	sEnd

Ending_DAC:
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, $0C, dSnare
	sNote		dKick, $06, nR, $02, dSnare, dSnare, dSnare, $09
	sNote		dSnare, $03

Ending_Loop5:
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, $0C, dSnare
	sNote		dKick, dSnare, dKick, $0C, dSnare, dKick, dSnare, dKick
	sNote		$0C, dSnare, dKick, $06, nR, $02, dSnare, dSnare
	sNote		dSnare, $09, dSnare, $03
	sLoop		$00, $03, Ending_Loop5
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, $06, dSnare
	sNote		$12, dSnare, $0C, dKick
	sEnd

Ending_Voices:

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
	sTotalLevel	$1A, $80, $80, $80
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
	sDetune		$05, $05, $00, $00
	sMultiple	$01, $01, $08, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $1E, $1E, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $0F
	sDecay1Level	$00, $00, $00, $01
	sDecay2Rate	$00, $00, $00, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $22, $24, $81
	sFinishVoice
