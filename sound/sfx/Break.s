	sHeaderSFX
	sHeaderVoice	Break_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Break_FM5, $00, $00
	sHeaderCH	$80, tPSG3, Break_PSG3, $00, $02
	sHeaderFinish

Break_FM5:
	sVib		$03, $01, $72, $0B
	sVoice		00
	sNote		nA4, $16
	sEnd

Break_PSG3:
	sEnv		01
	sNoiseSet	snWhitePSG3
	sNote		nB3, $1B
	sEnd

Break_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $03, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$19, $19, $12, $0E
	sDecay1Level	$00, $0F, $07, $0F
	sDecay2Rate	$05, $00, $12, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $00, $80, $80
	sFinishVoice
