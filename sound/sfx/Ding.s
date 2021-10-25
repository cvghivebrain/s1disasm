	sHeaderSFX
	sHeaderVoice	Ding_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Ding_FM5, $0C, $08
	sHeaderFinish

Ding_FM5:
	sVoice		00
	sNote		nA4, $08, nA4, $25
	sEnd

Ding_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$02
	sDetune		$02, $03, $03, $01
	sMultiple	$05, $06, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $1C, $18, $13
	sDecay1Level	$00, $08, $09, $00
	sDecay2Rate	$0B, $0D, $08, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $0A, $05, $80
	sFinishVoice
