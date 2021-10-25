	sHeaderSFX
	sHeaderVoice	ChainStomp_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, ChainStomp_FM5, $10, $0A
	sHeaderCH	$80, tFM4, ChainStomp_FM4, $00, $00
	sHeaderFinish

ChainStomp_FM5:
	sVoice		00
	sVib		$01, $01, $60, $01
	sNote		nD3, $08
	sEnd

ChainStomp_FM4:
	sNote		nR, $08
	sVoice		01
	sNote		nDs0, $22
	sEnd

ChainStomp_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $09, $0A, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0E, $04, $07, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$03, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $05, $18, $10
	sDecay1Level	$01, $01, $02, $02
	sDecay2Rate	$0B, $10, $1F, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0D, $01, $00, $80
	sFinishVoice
	even
