	sHeaderSFX
	sHeaderVoice	Push_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Push_FM4, $00, $06
	sHeaderFinish

Push_FM4:
	sVoice		00
	sNote		nD1, $07, nR, $02, nD1, $06, nR, $10
	sClearPush
	sEnd

Push_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$06, $06, $0F, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0F, $0E, $0E, $80
	sFinishVoice
	even
