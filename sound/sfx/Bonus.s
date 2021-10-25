	sHeaderSFX
	sHeaderVoice	Bonus_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Bonus_FM5, $0E, $00
	sHeaderFinish

Bonus_FM5:
	sVoice		00
	sVib		$01, $01, $33, $18
	sNote		nGs4, $1A
	sEnd

Bonus_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$00, $00, $03, $00
	sMultiple	$0A, $05, $01, $02
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $16, $14, $0C
	sDecay1Level	$01, $0D, $06, $0F
	sDecay2Rate	$00, $00, $04, $00
	sReleaseRate	$0F, $08, $0F, $0F
	sTotalLevel	$03, $00, $25, $80
	sFinishVoice
	even
