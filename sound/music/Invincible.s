	sHeaderMusic
	sHeaderVoice	Invincible_Voices
	sHeaderTempo	$01, $08
	sHeaderDAC	Invincible_DAC
	sHeaderFM	Invincible_FM1, -$0C, $11
	sHeaderFM	Invincible_FM2, -$0C, $07
	sHeaderFM	Invincible_FM3, -$18, $0F
	sHeaderFM	Invincible_FM4, -$18, $0F
	sHeaderFM	Invincible_FM5, -$0C, $11
	sHeaderPSG	Invincible_PSG1, -$30, $05, $00, 05
	sHeaderPSG	Invincible_PSG1, -$24, $05, $00, 05
	sHeaderPSG	Invincible_PSG2, $00, $03, $00, 04
	sHeaderFinish

Invincible_FM5:
	sDetuneSet	$03

Invincible_FM1:
	sVoice		00
	sNote		nR, $30

Invincible_Jump1:
	sNote		nR, $0C, nCs6, $15, nR, $03, nCs6, $06
	sNote		nR, nD6, $0F, nR, $03, nB5, $18, nR
	sNote		$06, nCs6, $06, nR, nCs6, nR, nCs6, nR
	sNote		nA5, nR, nG5, $0F, nR, $03, nB5, $18
	sNote		nR, $06, nR, $0C, nCs6, $15, nR, $03
	sNote		nCs6, $06, nR, nD6, $0F, nR, $03, nB5
	sNote		$18, nR, $06, nCs6, $06, nR, nCs6, nR
	sNote		nCs6, nR, nA5, nR, nG5, $0F, nR, $03
	sNote		nB5, $18, nR, $06
	sVolAddFM	-$03
	sNote		nR, $30, nR, nA5, $04, nB5, nCs6, nD6
	sNote		nE6, nFs6, nB5, nCs6, nDs6, nE6, nFs6, nGs6
	sNote		nCs6, nDs6, nF6, nFs6, nGs6, nAs6, nF6, nFs6
	sNote		nGs6, nAs6, nC7, nCs7
	sVolAddFM	$03
	sJump		Invincible_Jump1

Invincible_FM2:
	sTiming		$01
	sVoice		01
	sNote		nR, $30

Invincible_Loop1:
	sNote		nA3, $06, nR, nA3, nR, nE3, nR, nE3
	sNote		nR, nG3, $12, nFs3, $0C, nG3, $06, nFs3
	sNote		$0C, nA3, $06, nR, nA3, nR, nE3, nR
	sNote		nE3, nR, nD4, $12, nCs4, $0C, nD4, $06
	sNote		nCs4, $0C
	sLoop		$00, $02, Invincible_Loop1

Invincible_Loop2:
	sNote		nB2, $06, nG2, $12, nA2, $06, nR, nB2
	sNote		nR
	sLoop		$00, $02, Invincible_Loop2
	sNote		nA2, $0C, nB2, nCs3, nDs3, nB2, $06, nCs3
	sNote		nDs3, nF3, nCs3, nDs3, nF3, nFs3
	sTiming		$01
	sJump		Invincible_Loop1

Invincible_FM3:
	sVoice		00
	sNote		nR, $30

Invincible_Loop3:
	sNote		nE6, $06, nR, nE6, nR, nCs6, nR, nCs6
	sNote		nR, nD6, $12, nD6, $1E, nE6, $06, nR
	sNote		nE6, nR, nCs6, nR, nCs6, nR, nG6, $12
	sNote		nG6, $1E
	sLoop		$00, $02, Invincible_Loop3

Invincible_Loop4:
	sNote		nR, $06, nG5, $12, nA5, $06, nR, $12
	sLoop		$00, $04, Invincible_Loop4
	sJump		Invincible_Loop3

Invincible_FM4:
	sVoice		00
	sNote		nR, $30

Invincible_Loop5:
	sNote		nCs6, $06, nR, nCs6, nR, nA5, nR, nA5
	sNote		nR, nB5, $12, nB5, $1E, nCs6, $06, nR
	sNote		nCs6, nR, nA5, nR, nA5, nR, nD6, $12
	sNote		nD6, $1E
	sLoop		$00, $02, Invincible_Loop5

Invincible_Loop6:
	sNote		nR, $06, nB5, $12, nCs6, $06, nR, $12
	sLoop		$00, $04, Invincible_Loop6
	sJump		Invincible_Loop5

Invincible_PSG1:
	sEnd

Invincible_PSG2:
	sNoiseSet	snWhitePSG3
	sNote		nR, $30

Invincible_Jump2:
	sGate		$03
	sNote		nA5, $0C
	sGate		$0C
	sNote		$0C
	sGate		$03
	sNote		$0C
	sGate		$0C
	sNote		$0C
	sJump		Invincible_Jump2

Invincible_DAC:
	sNote		dSnare, $06, dSnare, dSnare, dSnare, dSnare, $02, dSnare
	sNote		$04, dKick, $12

Invincible_Loop7:
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, $0C, dSnare
	sNote		dKick, dSnare, dKick, $0C, dSnare, dKick, dSnare, dKick
	sNote		$0C, dSnare, dKick, $04, nR, dSnare, dSnare, $0C
	sLoop		$00, $02, Invincible_Loop7
	sNote		dKick, $06, dSnare, $12, dKick, $0C, dSnare, dSnare
	sNote		$06, dKick, $12, dKick, $0C, dSnare, dSnare, $06
	sNote		dKick, $12, dKick, $0C, dSnare, dSnare, $04, dSnare
	sNote		dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare
	sNote		dSnare, dSnare
	sJump		Invincible_Loop7

	; Unused data
	sEnd

Invincible_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $07, $01
	sRateScale	$02, $02, $02, $01
	sAttackRate	$0E, $0D, $0E, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $0E, $0E, $03
	sDecay1Level	$01, $01, $0F, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $27, $28, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$06, $01, $03, $03
	sMultiple	$01, $04, $0C, $01
	sRateScale	$02, $02, $03, $03
	sAttackRate	$1C, $1C, $1B, $1A
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $09, $03
	sDecay1Level	$01, $00, $00, $0A
	sDecay2Rate	$03, $03, $01, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$21, $31, $47, $80
	sFinishVoice
