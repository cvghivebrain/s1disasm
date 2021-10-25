	sHeaderSFX
	sHeaderVoice	Skid_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tPSG2, Skid_PSG2, -$0C, $00
	sHeaderCH	$80, tPSG3, Skid_PSG3, -$0C, $00
	sHeaderFinish

Skid_PSG2:
	sEnv		None
	sNote		nAs3, $01, nR, nAs3, nR, $03

Skid_Loop1:
	sNote		nAs3, $01, nR, $01
	sLoop		$00, $0B, Skid_Loop1
	sEnd

Skid_PSG3:
	sEnv		None
	sNote		nR, $01, nGs3, nR, nGs3, nR, $03

Skid_Loop2:
	sNote		nGs3, $01, nR, $01
	sLoop		$00, $0B, Skid_Loop2
	sEnd

Skid_Patches:
	even
