	sHeaderSFX
	sHeaderVoice	Lamppost_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Lamppost_FM5, $00, $01
	sHeaderFinish

Lamppost_FM5:
	sVoice		00
	sNote		nC5, $06, nA4, $16
	sEnd

Lamppost_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $0A, $01, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$16, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $11, $11, $11
	sDecay1Level	$04, $03, $03, $03
	sDecay2Rate	$09, $06, $0A, $0A
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $20, $80, $80
	sFinishVoice
