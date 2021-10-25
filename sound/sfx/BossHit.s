	sHeaderSFX
	sHeaderVoice	BossHit_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM5, BossHit_FM5, $00, $00
	sHeaderFinish

BossHit_FM5:
	sVoice		00
	sVib		$01, $01, $0C, $01

BossHit_Loop1:
	sNote		nC0, $0A
	sVolAddFM	$10
	sLoop		$00, $04, BossHit_Loop1
	sEnd

BossHit_Patches:

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
