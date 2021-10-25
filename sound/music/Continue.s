	sHeaderMusic
	sHeaderVoice	Continue_Voices
	sHeaderTempo	$01, $07
	sHeaderDAC	Continue_DAC
	sHeaderFM	Continue_FM1, -$1B, $08
	sHeaderFM	Continue_FM2, -$18, $08
	sHeaderFM	Continue_FM3, -$0C, $0F
	sHeaderFM	Continue_FM4, -$0C, $0F
	sHeaderFM	Continue_FM5, -$0C, $0A
	sHeaderPSG	Continue_FM5, -$30, $03, $00, 05
	sHeaderPSG	Continue_FM5, -$24, $06, $00, 05
	sHeaderPSG	Continue_FM5, -$24, $00, $00, 04
	sHeaderFinish

Continue_FM1:
	sVoice		00
	sNote		nR, $30

Continue_Loop1:
	sTransAdd	$01
	sNote		nR, $0C, nDs6, $12, nR, $06, nDs6, nR
	sNote		nE6, $0C, nR, $06, nCs6, $18, nR, $06
	sLoop		$00, $03, Continue_Loop1
	sNote		nF6, $06, nR, nF6, nR, nF6, nR, nC6
	sNote		nR, nAs5, $0C, nR, $06, nD6, $4E
	sEnd

Continue_FM2:
	sVoice		01
	sVolAddFM	$02
	sTransAdd	-$0C
	sTiming		$01
	sNote		nA5, $0C, nGs5, nG5, nFs5
	sVolAddFM	-$02
	sTransAdd	$0C
	sVoice		02

Continue_Loop2:
	sNote		nA4, $06, nR, nA4, nR, nE4, nR, nE4
	sNote		nR, nG4, $12, nFs4, $0C, nG4, $06, nFs4
	sNote		$0C
	sTransAdd	$01
	sLoop		$00, $03, Continue_Loop2
	sTransAdd	-$03
	sNote		nB4, $06, nR, nB4, nR, nFs4, nR, nFs4
	sNote		nR, nE5, $0C, nR, $06, nDs5, $4E
	sTiming		$01
	sEnd

Continue_FM3:
	sVoice		03
	sNote		nR, $30

Continue_Loop3:
	sNote		nE6, $06, nR, nE6, nR, nCs6, nR, nCs6
	sNote		nR, nD6, $12, nD6, $1E
	sLoop		$00, $03, Continue_Loop3
	sNote		nE6, $06, nR, nE6, nR, nCs6, nR, nCs6
	sNote		nR, nG6, $0C, nR, $06, nG6, $1E, sTie
	sNote		$30
	sEnd

Continue_FM4:
	sVoice		03
	sNote		nR, $30

Continue_Loop4:
	sNote		nCs6, $06, nR, nCs6, nR, nA5, nR, nA5
	sNote		nR, nB5, $12, nB5, $1E
	sLoop		$00, $03, Continue_Loop4
	sNote		nCs6, $06, nR, nCs6, nR, nA5, nR, nA5
	sNote		nR, nD6, $0C, nR, $06, nD6, $4E

Continue_FM5:
	sEnd

Continue_DAC:
	sNote		nR, $30

Continue_Loop5:
	sNote		dKick, $0C, dSnare
	sLoop		$00, $0E, Continue_Loop5
	sNote		dKick, $0C, dSnare, $06, dKick, $0C
	sEnd

Continue_Voices:

	sNewVoice	00					; voice number $00
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

	sNewVoice	01					; voice number $01
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$05, $03, $03, $05
	sMultiple	$02, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $12, $14, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $0D, $00, $02
	sDecay1Level	$04, $05, $00, $03
	sDecay2Rate	$00, $00, $00, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1E, $2D, $18, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
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

	sNewVoice	03					; voice number $03
	sAlgorithm	$04
	sFeedback	$03
	sDetune		$06, $02, $00, $07
	sMultiple	$0F, $01, $01, $01
	sRateScale	$02, $02, $03, $01
	sAttackRate	$1F, $1E, $1B, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $06, $07, $07
	sDecay1Level	$08, $0F, $08, $0F
	sDecay2Rate	$08, $0B, $0A, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $26, $8D, $80
	sFinishVoice
	even
