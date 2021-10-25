	sHeaderSFX
	sHeaderVoice	Waterfall_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Waterfall_FM4, $00, $10
	sHeaderFinish

Waterfall_FM4:
	sVoice		00
	sNote		nG6, $02

Waterfall_Loop1:
	sNote		sTie, $01
	sLoop		$00, $40, Waterfall_Loop1

Waterfall_Loop2:
	sNote		sTie, $01
	sVolAddFM	$01
	sLoop		$00, $22, Waterfall_Loop2
	sNote		nR, $01
	sEndBack

Waterfall_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $0F, $0F, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $00, $00, $80
	sFinishVoice
