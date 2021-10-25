	sHeaderSFX
	sHeaderVoice	Jump_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG1, Jump_PSG1, -$0C, $00
	sHeaderFinish

Jump_PSG1:
	sEnv		None
	sNote		nF2, $05
	sVib		$02, $01, $F8, $65
	sNote		nAs2, $15
	sEnd

Jump_Patches:
