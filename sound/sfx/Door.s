	sHeaderSFX
	sHeaderVoice	Door_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Door_FM5, -$0C, $00
	sHeaderFinish

Door_FM5:
	sVoice		00
	sNote		nD2, $04, nR, nG2, $06
	sEnd

Door_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0F, $16, $0F
	sDecay1Level	$00, $0F, $0A, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $0A, $80, $80
	sFinishVoice
	even
