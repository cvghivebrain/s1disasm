	sHeaderSFX
	sHeaderVoice	Ring_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Ring_FM5, $00, $05
	sHeaderFinish

Ring_FM5:
	sVoice		00
	sPan		sPanRight
	sNote		nE5, $05, nG5, $05, nC6, $1B
	sEnd

Ring_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice
