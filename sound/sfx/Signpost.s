	sHeaderSFX
	sHeaderVoice	Signpost_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Signpost_FM4, $27, $03
	sHeaderCH	$80, tFM5, Signpost_FM5, $27, $00
	sHeaderFinish

Signpost_FM4:
	sNote		nR, $04

Signpost_FM5:
	sVoice		00

Signpost_Loop1:
	sNote		nDs4, $05
	sVolAddFM	$02
	sLoop		$00, $15, Signpost_Loop1
	sEnd

Signpost_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$1E
	sDetune		$00, $00, $00, $00
	sMultiple	$06, $0F, $04, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0B, $00, $0B
	sDecay1Level	$00, $0F, $00, $0F
	sDecay2Rate	$00, $05, $00, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0C, $03, $8B, $80
	sFinishVoice
	even
