	sHeaderSFX
	sHeaderVoice	UnkA2_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, UnkA2_PSG3, $00, $00
	sHeaderFinish

UnkA2_PSG3:
	sVib		$01, $01, $F0, $08
	sNoiseSet	snWhitePSG3
	sNote		nDs5, $04, nCs6, $04

UnkA2_Loop1:
	sNote		nDs5, $01
	sVolAddPSG	$01
	sLoop		$00, $06, UnkA2_Loop1
	sEnd

UnkA2_Patches:
	even
