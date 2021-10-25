	sHeaderSFX
	sHeaderVoice	Register_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Register_FM5, $00, $00
	sHeaderCH	$80, tFM4, Register_FM4, $00, $00
	sHeaderCH	$80, tPSG3, Register_PSG3, $00, $00
	sHeaderFinish

Register_FM5:
	sVoice		00
	sNote		nA0, $08, nR, $02, nA0, $08
	sEnd

Register_FM4:
	sVoice		01
	sNote		nR, $12, nA5, $55
	sEnd

Register_PSG3:
	sEnv		02
	sNoiseSet	snWhitePSG3
	sNote		nR, $02, nF5, $05, nG5, $04, nF5, $05
	sNote		nG5, $04
	sEnd

Register_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$03, $02, $02, $06
	sRateScale	$00, $00, $00, $02
	sAttackRate	$18, $1A, $1A, $16
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$17, $0A, $0E, $10
	sDecay1Level	$0F, $0F, $0F, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$00, $39, $28, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice
	even
