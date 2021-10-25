	sHeaderSFX
	sHeaderVoice	Saw_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, Saw_FM5, -$05, $05
	sHeaderFinish

Saw_FM5:
	sVoice		00
	sNote		nAs7, $7F

Saw_Loop1:
	sNote		nAs7, $02
	sVolAddFM	$01
	sLoop		$00, $1B, Saw_Loop1
	sEnd

Saw_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$03
	sFeedback	$10
	sDetune		$01, $01, $01, $01
	sMultiple	$0F, $0F, $05, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$02, $0F, $02, $03
	sDecay2Rate	$02, $02, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$0B, $01, $16, $82
	sFinishVoice
	even
