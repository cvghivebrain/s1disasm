	sHeaderSFX
	sHeaderVoice	Splash_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, Splash_PSG3, $00, $00
	sHeaderCH	$80, tFM5, Splash_FM5, $00, $03
	sHeaderFinish

Splash_PSG3:
	sEnv		None
	sNoiseSet	snWhitePSG3
	sNote		nF5, $05, nA5, $05, sTie

Splash_Loop1:
	sNote		$07
	sVolAddPSG	$01
	sNote		sTie
	sLoop		$00, $0F, Splash_Loop1
	sEnd

Splash_FM5:
	sVoice		00
	sNote		nCs3, $14
	sEnd

Splash_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $02, $03, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$19, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $14, $11, $0F
	sDecay1Level	$0F, $0F, $0F, $0F
	sDecay2Rate	$0A, $0A, $00, $0D
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$22, $27, $07, $80
	sFinishVoice
	even
