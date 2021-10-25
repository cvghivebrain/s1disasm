	sHeaderSFX
	sHeaderVoice	Diamonds_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Diamonds_FM5, $00, $07
	sHeaderFinish

Diamonds_FM5:
	sVoice		00
	sNote		nA3, $08
	sEnd

Diamonds_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$03
	sDetune		$02, $00, $00, $00
	sMultiple	$0E, $0F, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$18, $14, $0F, $0E
	sDecay1Level	$0F, $0F, $0F, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$20, $1B, $80, $80
	sFinishVoice
