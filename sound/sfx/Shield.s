	sHeaderSFX
	sHeaderVoice	Shield_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Shield_FM5, $0C, $00
	sHeaderFinish

Shield_FM5:
	sVoice		00
	sNote		nR, $01, nAs2, $05, sTie, nB2, $26
	sEnd

Shield_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$00, $00, $00, $00
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1E, $2C, $28, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay1Level	$0B, $0B, $0B, $0B
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$04, $14, $2C, $80
	sFinishVoice
	even
