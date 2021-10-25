	sHeaderSFX
	sHeaderVoice	Bubble_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Bubble_FM5, $0E, $00
	sHeaderFinish

Bubble_FM5:
	sVoice		00
	sVib		$01, $01, $21, $6E
	sNote		nCs3, $07, nR, $06
	sVib		$01, $01, $44, $1E
	sNote		nGs3, $08
	sEnd

Bubble_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $08, $09, $07
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $0D, $0D, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $03, $15, $06
	sDecay1Level	$02, $01, $02, $01
	sDecay2Rate	$16, $09, $0E, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$15, $12, $12, $80
	sFinishVoice
