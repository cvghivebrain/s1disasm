	sHeaderSFX
	sHeaderVoice	UnkB8_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, UnkB8_PSG3, $00, $00
	sHeaderFinish

UnkB8_PSG3:
	sVib		$01, $01, $F0, $08
	sNoiseSet	snWhitePSG3
	sNote		nDs4, $08

UnkB8_Loop1:
	sNote		nB3, $02
	sVolAddPSG	$01
	sLoop		$00, $03, UnkB8_Loop1
	sEnd

UnkB8_Patches:
	even
