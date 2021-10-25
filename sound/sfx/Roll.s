	sHeaderSFX
	sHeaderVoice	Roll_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, Roll_FM4, $0C, $05
	sHeaderFinish

Roll_FM4:
	sVoice		00
	sNote		nR, $01
	sVib		$03, $01, $09, -$01
	sNote		nCs6, $25
	sVibOff

Roll_Loop1:
	sNote		sTie
	sVolAddFM	$01
	sNote		nG6, $02
	sLoop		$00, $2A, Roll_Loop1
	sEnd

Roll_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $04, $00
	sMultiple	$00, $02, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $15
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $1F, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0D, $28, $00, $00
	sFinishVoice
