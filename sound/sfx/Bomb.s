	sHeaderSFX
	sHeaderVoice	Bomb_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Bomb_FM5, $00, $00
	sHeaderFinish

Bomb_FM5:
	sVoice		00
	sNote		nA0, $22
	sEnd

Bomb_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $05, $18, $10
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$0B, $10, $1F, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0D, $04, $07, $80
	sFinishVoice
