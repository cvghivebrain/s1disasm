	sHeaderSFX
	sHeaderVoice	UnkAB_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, UnkAB_PSG3, $00, $00
	sHeaderFinish

UnkAB_PSG3:
	sEnv		None
	sNoiseSet	snWhitePSG3
	sNote		nA5, $03, nR, $03, nA5, $01, sTie

UnkAB_Loop1:
	sNote		$01
	sVolAddPSG	$01
	sNote		sTie
	sLoop		$00, $15, UnkAB_Loop1
	sEnd

UnkAB_Patches:
	even
