	sHeaderSFX
	sHeaderVoice	Bumper_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Bumper_FM5, $00, $00
	sHeaderCH	$80, tFM4, Bumper_FM4, $00, $00
	sHeaderCH	$80, tFM3, Bumper_FM3, $00, $02
	sHeaderFinish

Bumper_FM5:
	sVoice		00
	sJump		Bumper_Jump1

Bumper_FM4:
	sVoice		00
	sDetuneSet	$07
	sNote		nR, $01

Bumper_Jump1:
	sNote		nA4, $20
	sEnd

Bumper_FM3:
	sVoice		01
	sNote		nCs2, $03
	sEnd

Bumper_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $0A, $01, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$16, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $11, $11, $11
	sDecay1Level	$04, $03, $03, $03
	sDecay2Rate	$09, $06, $0A, $0A
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1F, $2B, $80, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$05
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0C, $0C, $0C
	sDecay1Level	$01, $05, $05, $05
	sDecay2Rate	$12, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$07, $80, $80, $80
	sFinishVoice
	even
