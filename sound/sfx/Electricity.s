	sHeaderSFX
	sHeaderVoice	Electricity_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Electricity_FM5, -$05, $02
	sHeaderFinish

Electricity_FM5:
	sVoice		00
	sNote		nD4, $05, nR, $01, nD4, $09
	sEnd

Electricity_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$03
	sFeedback	$10
	sDetune		$01, $01, $01, $01
	sMultiple	$02, $03, $00, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$02, $0F, $02, $03
	sDecay2Rate	$02, $02, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$05, $34, $10, $87
	sFinishVoice
