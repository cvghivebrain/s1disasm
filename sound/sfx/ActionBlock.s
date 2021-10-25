	sHeaderSFX
	sHeaderVoice	ActionBlock_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG2, ActionBlock_PSG2, $00, $00
	sHeaderFinish

ActionBlock_PSG2:
	sVib		$01, $01, $E6, $35
	sNote		nCs1, $06
	sEnd

ActionBlock_Patches:
