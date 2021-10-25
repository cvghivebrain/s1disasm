	sHeaderSFX
	sHeaderVoice	Rumbling_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Rumbling_FM5, $00, $00
	sHeaderFinish

Rumbling_FM5:
	sVoice		00
	sVib		$01, $01, $20, $08

Rumbling_Loop1:
	sNote		nAs0, $0A
	sLoop		$00, $08, Rumbling_Loop1

Rumbling_Loop2:
	sNote		nAs0, $10
	sVolAddFM	$03
	sLoop		$00, $09, Rumbling_Loop2
	sEnd

Rumbling_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$06, $06, $0F, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0F, $0E, $1A, $80
	sFinishVoice
	even
