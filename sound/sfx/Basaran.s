	sHeaderSFX
	sHeaderVoice	Basaran_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Basaran_FM5, $00, $03
	sHeaderFinish

Basaran_FM5:
	sVoice		00
	sNote		nG1, $05, nR, $05, nG1, $04, nR, $04
	sEnd

Basaran_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$08, $08, $08, $08
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $00, $00, $80
	sFinishVoice
