	sHeaderSFX
	sHeaderVoice	Death_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Death_FM5, -$0C, $00
	sHeaderFinish

Death_FM5:
	sVoice		00
	sNote		nB3, $07, sTie, nGs3

Death_Loop1:
	sNote		$01
	sVolAddFM	$01
	sLoop		$00, $2F, Death_Loop1
	sEnd

Death_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$00, $00, $00, $00
	sRateScale	$02, $03, $03, $03
	sAttackRate	$1E, $1C, $18, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay1Level	$0B, $0B, $0B, $0B
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$14, $14, $3C, $80
	sFinishVoice
