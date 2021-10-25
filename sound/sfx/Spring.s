	sHeaderSFX
	sHeaderVoice	Spring_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Spring_FM4, $00, $02
	sHeaderFinish

Spring_FM4:
	sVoice		00
	sNote		nR, $01
	sVib		$03, $01, $5D, $0F
	sNote		nB3, $0C
	sVibOff

Spring_Loop1:
	sNote		sTie
	sVolAddFM	$02
	sNote		nC5, $02
	sLoop		$00, $19, Spring_Loop1
	sEnd

Spring_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay1Level	$02, $01, $01, $0F
	sDecay2Rate	$07, $06, $06, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $13, $30, $80
	sFinishVoice
