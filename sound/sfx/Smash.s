	sHeaderSFX
	sHeaderVoice	Smash_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Smash_FM5, $00, $00
	sHeaderCH	$80, tPSG3, Smash_PSG3, $00, $00
	sHeaderFinish

Smash_FM5:
	sVoice		00
	sVib		$03, $01, $20, $04

Smash_Loop1:
	sNote		nC0, $18
	sVolAddFM	$0A
	sLoop		$00, $06, Smash_Loop1
	sEnd

Smash_PSG3:
	sVib		$01, $01, $0F, $05
	sNoiseSet	snWhitePSG3

Smash_Loop2:
	sNote		nB3, $18, sTie
	sVolAddPSG	$03
	sLoop		$00, $05, Smash_Loop2
	sEnd

Smash_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$01
	sFeedback	$1F
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0E, $04, $07, $80
	sFinishVoice
