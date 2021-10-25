	sHeaderSFX
	sHeaderVoice	SpikeMove_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG3, SpikeMove_PSG3, $00, $00
	sHeaderFinish

SpikeMove_PSG3:
	sVib		$01, $01, $F0, $08
	sNoiseSet	snWhitePSG3
	sNote		nE5, $07

SpikeMove_Loop1:
	sNote		nG6, $01
	sVolAddPSG	$01
	sLoop		$00, $0C, SpikeMove_Loop1
	sEnd

SpikeMove_Patches:
	even
