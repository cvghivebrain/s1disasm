	sHeaderSFX
	sHeaderVoice	Drown_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Drown_FM4, $0C, $04
	sHeaderCH	$80, tFM5, Drown_FM5, $0E, $02
	sHeaderFinish

Drown_FM5:
	sVoice		00
	sVib		$01, $01, $83, $0C

Drown_Loop2:
	sNote		nA0, $05, $05
	sVolAddFM	$03
	sLoop		$00, $0A, Drown_Loop2
	sEnd

Drown_FM4:
	sNote		nR, $06
	sVoice		00
	sVib		$01, $01, $6F, $0E

Drown_Loop1:
	sNote		nC1, $04, $05
	sVolAddFM	$03
	sLoop		$00, $0A, Drown_Loop1
	sEnd

Drown_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$01, $00, $01, $00
	sMultiple	$04, $04, $0A, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0E, $11, $10, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $03, $15, $06
	sDecay1Level	$02, $04, $02, $04
	sDecay2Rate	$16, $09, $0E, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$2F, $12, $12, $80
	sFinishVoice
	even
