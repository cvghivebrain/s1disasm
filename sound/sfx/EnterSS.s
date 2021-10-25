	sHeaderSFX
	sHeaderVoice	EnterSS_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, EnterSS_FM5, $00, $02
	sHeaderFinish

EnterSS_FM5:
	sVoice		00
	sVib		$01, $01, $5B, $02
	sNote		nDs6, $65
	sEnd

EnterSS_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$01, $00, $01, $01
	sAttackRate	$01, $3B, $09, $0B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $09, $06, $08
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$01, $02, $03, $A9
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$29, $23, $27, $80
	sFinishVoice
	even
