	sHeaderSFX
	sHeaderVoice	Dash_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Dash_FM5, -$70, $00
	sHeaderCH	$80, tPSG3, Dash_PSG3, $00, $00
	sHeaderFinish

Dash_FM5:
	sVoice		00
	sVib		$01, $01, $C5, $1A
	sNote		nE6, $07
	sEnd

Dash_PSG3:
	sEnv		07
	sNote		nR, $07
	sVib		$01, $02, $05, -$01
	sNoiseSet	snWhitePSG3
	sNote		nAs4, $4F
	sEnd

Dash_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$05
	sFeedback	$1F
	sDetune		$00, $00, $00, $00
	sMultiple	$09, $00, $03, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $0C, $0C, $0C
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$09, $92, $84, $8E
	sFinishVoice
	even
