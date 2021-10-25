	sHeaderSFX
	sHeaderVoice	SpikeHit_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, SpikeHit_FM5, -$0E, $00
	sHeaderFinish

SpikeHit_FM5:
	sVoice		00
	sVib		$01, $01, $10, -$01
	sNote		nFs6, $05, nD7, $25
	sEnd

SpikeHit_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$03, $03, $03, $03
	sMultiple	$0C, $00, $09, $01
	sRateScale	$03, $00, $00, $03
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $05, $01
	sDecay1Level	$0F, $01, $00, $0A
	sDecay2Rate	$04, $04, $04, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$29, $0F, $20, $80
	sFinishVoice
	even
