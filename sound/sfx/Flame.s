	sHeaderSFX
	sHeaderVoice	Flame_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Flame_FM5, $00, $00
	sHeaderCH	$80, tPSG3, Flame_PSG3, $00, $00
	sHeaderFinish

Flame_FM5:
	sVoice		00
	sNote		nR, $01
	sVib		$01, $01, $40, $48
	sNote		nD0, $06, nE0, $02
	sEnd

Flame_PSG3:
	sEnv		None
	sNote		nR, $0B
	sNoiseSet	snWhitePSG3
	sNote		nD3, $25, sTie

Flame_Loop1:
	sNote		$02
	sVolAddPSG	$01
	sNote		sTie
	sLoop		$00, $10, Flame_Loop1
	sEnd

Flame_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$1F
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $00, $03, $05
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $0F, $11, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$06, $06, $0F, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$2F, $0E, $1A, $80
	sFinishVoice
