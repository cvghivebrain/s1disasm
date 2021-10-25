	sHeaderSFX
	sHeaderVoice	GiantRing_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM4, GiantRing_FM4, $0C, $00
	sHeaderCH	$80, tFM5, GiantRing_FM5, $00, $13
	sHeaderFinish

GiantRing_FM4:
	sVoice		01
	sNote		nR, $01, nA2, $08
	sVoice		00
	sNote		sTie, nGs3, $26
	sEnd

GiantRing_FM5:
	sVoice		02
	sVib		$06, $01, $03, -$01
	sNote		nR, $0A

GiantRing_Loop1:
	sNote		nFs5, $06
	sLoop		$00, $05, GiantRing_Loop1
	sNote		nFs5, $17
	sEnd

GiantRing_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $05, $03
	sMultiple	$00, $04, $0C, $00
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1E, $2C, $28, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay1Level	$0B, $0B, $0B, $0B
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $04, $1C, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $05, $03
	sMultiple	$00, $04, $0C, $00
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1E, $2C, $28, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay1Level	$0B, $0B, $0B, $0B
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $04, $2C, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
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
	sTotalLevel	$13, $13, $81, $88
	sFinishVoice
