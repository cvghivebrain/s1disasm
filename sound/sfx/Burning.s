	sHeaderSFX
	sHeaderVoice	Burning_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, Burning_PSG3, $00, $00
	sHeaderFinish

Burning_PSG3:
	sEnv		None
	sNoiseSet	snWhitePSG3
	sNote		nD3, $25
	sEnd

Burning_Patches:
	even
