	sHeaderSFX
	sHeaderVoice	ContinueGet_Patches
	sHeaderTick	$01
	sHeaderCH	$80, tFM3, ContinueGet_FM3, -$0C, $06
	sHeaderCH	$80, tFM4, ContinueGet_FM4, -$0C, $06
	sHeaderCH	$80, tFM5, ContinueGet_FM5, -$0C, $06
	sHeaderFinish

ContinueGet_FM3:
	sVoice		00
	sNote		nC6, $07, nE6, nG6, nD6, nF6, nA6, nE6
	sNote		nG6, nB6, nF6, nA6, nC7

ContinueGet_Loop1:
	sNote		nG6, $07, nB6, nD7
	sVolAddFM	$05
	sLoop		$00, $08, ContinueGet_Loop1
	sEnd

ContinueGet_FM4:
	sVoice		00
	sDetuneSet	$01
	sNote		nR, $07, nE6, $15, nF6, nG6, nA6

ContinueGet_Loop2:
	sNote		nB6, $15
	sVolAddFM	$05
	sLoop		$00, $08, ContinueGet_Loop2
	sEnd

ContinueGet_FM5:
	sVoice		00
	sDetuneSet	$01
	sNote		nC6, $15, nD6, nE6, nF6

ContinueGet_Loop3:
	sNote		nG6, $15
	sVolAddFM	$05
	sLoop		$00, $08, ContinueGet_Loop3
	sEnd

ContinueGet_Patches:

	sNewVoice	00					; voice number $00
	sAlgorithm	$04
	sFeedback	$02
	sDetune		$02, $03, $03, $01
	sMultiple	$05, $06, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $1C, $18, $13
	sDecay1Level	$00, $08, $09, $00
	sDecay2Rate	$0B, $0D, $08, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $0A, $05, $80
	sFinishVoice
