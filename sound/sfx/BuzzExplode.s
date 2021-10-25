	sHeaderSFX
	sHeaderVoice	BuzzExplode_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, BuzzExplode_FM5, $00, $00
	sHeaderFinish

BuzzExplode_FM5:
	sVoice		00
	sNote		nR, $01, nAs0, $0A, nR, $02
	sEnd

BuzzExplode_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$2F, $2F, $1F, $2F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $08, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$06, $06, $0F, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0F, $0E, $1A, $80
	sFinishVoice
