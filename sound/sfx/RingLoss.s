	sHeaderSFX
	sHeaderVoice	RingLoss_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, RingLoss_FM4, $00, $05
	sHeaderCH	$80, tFM5, RingLoss_FM5, $00, $08
	sHeaderFinish

RingLoss_FM4:
	sVoice		00
	sNote		nA5, $02, $05, $05, $05, $05, $05, $05
	sNote		$3A
	sEnd

RingLoss_FM5:
	sVoice		00
	sNote		nR, $02, nG5, $02, $05, $15, $02, $05
	sNote		$32
	sEnd

RingLoss_Patches:

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
	even
