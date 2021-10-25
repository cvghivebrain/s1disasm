	sHeaderSFX
	sHeaderVoice	ChainRise_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, ChainRise_FM5, $00, $00
	sHeaderFinish

ChainRise_FM5:
	sVoice		00
	sNote		nCs5, $05, nR, $04, nCs5, $04, nR, $04
	sEnd

ChainRise_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$02, $03, $05, $02
	sMultiple	$0F, $07, $0F, $0B
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $15, $15, $13
	sDecay1Level	$02, $03, $02, $02
	sDecay2Rate	$13, $0D, $0C, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $1F, $10, $80
	sFinishVoice
