	sHeaderMusic
	sHeaderVoice	GameOver_Voices
	sHeaderTempo	$02, $13
	sHeaderDAC	GameOver_DAC
	sHeaderFM	GameOver_FM1, -$18, $0A
	sHeaderFM	GameOver_FM2, -$0C, $0F
	sHeaderFM	GameOver_FM3, -$0C, $0F
	sHeaderFM	GameOver_FM4, -$0C, $0D
	sHeaderFM	GameOver_FM5, -$24, $16
	sHeaderPSG	GameOver_PSG1, -$30, $03, $00, 05
	sHeaderPSG	GameOver_PSG1, -$24, $06, $00, 05
	sHeaderPSG	GameOver_PSG1, -$24, $00, $00, 04
	sHeaderFinish

GameOver_FM1:
	sVoice		00
	sVib		$20, $01, $04, $05
	sNote		nR, $0C, nCs6, $12, nR, $06, nCs6, nR
	sNote		nD6, $12, nB5, $1E, nCs6, $06, nR, nCs6
	sNote		nR, nCs6, nR, nA5, nR, nG5, $12, nB5
	sNote		$0C, nR, $12, nC6, $04, nR, nC6, nB5
	sNote		$06, nR, nAs5, nR, nA5, nR
	sVib		$28, $01, $18, $05
	sNote		nGs5, $60
	sEnd

GameOver_FM2:
	sVoice		01
	sNote		nR, $01, nE7, $06, nR, nE7, nR, nCs7
	sNote		nR, nCs7, nR, nD7, $15, nD7, $1B, nE7
	sNote		$06, nR, nE7, nR, nCs7, nR, nCs7, nR
	sNote		nG7, $15, nG7, $1B
	sEnd

GameOver_FM3:
	sVoice		01
	sNote		nCs7, $0C, nCs7, nA6, nA6, nB6, $15, nB6
	sNote		$1B, nCs7, $0C, nCs7, nA6, nA6, nD7, $15
	sNote		nD7, $1B
	sEnd

GameOver_FM4:
	sVoice		02
	sTiming		$01
	sNote		nA3, $06, nR, nA3, nR, nE3, nR, nE3
	sNote		nR, nG3, $15, nFs3, $0C, nG3, $03, nFs3
	sNote		$0C, nA3, $06, nR, nA3, nR, nE3, nR
	sNote		nE3, nR, nD4, $15, nCs4, $0C, nD4, $03
	sNote		nCs4, $0C, nA3, $04, nR, nA3, nGs3, $06
	sNote		nR, nG3, nR, nFs3, nR, nFs3, $60
	sTiming		$01
	sEnd

GameOver_FM5:
	sVoice		03
	sNote		nR, $30, nD7, $12, nR, $03, nD7, $1B
	sNote		nR, $30, nG7, $12, nR, $03, nG7, $1B

GameOver_PSG1:
	sEnd

GameOver_DAC:
	sNote		nR, $18, dKick
	sLoop		$00, $04, GameOver_DAC
	sEnd

GameOver_Voices:

	sNewVoice	00					; voice number $00
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$05, $05, $00, $00
	sMultiple	$01, $01, $08, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $1E, $1E, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $0F
	sDecay1Level	$00, $00, $00, $01
	sDecay2Rate	$00, $00, $00, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $22, $24, $81
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $07, $03, $07
	sMultiple	$03, $03, $00, $00
	sRateScale	$02, $02, $02, $02
	sAttackRate	$14, $16, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $14, $00, $0F
	sDecay1Level	$02, $04, $00, $02
	sDecay2Rate	$04, $04, $0A, $0D
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$33, $1A, $80, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $07, $01
	sRateScale	$02, $02, $02, $01
	sAttackRate	$0E, $0D, $0E, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $0E, $0E, $03
	sDecay1Level	$01, $01, $0F, $00
	sDecay2Rate	$00, $00, $00, $07
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1C, $27, $28, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$07
	sFeedback	$03
	sDetune		$06, $05, $03, $02
	sMultiple	$06, $03, $01, $02
	sRateScale	$00, $00, $02, $00
	sAttackRate	$1C, $1F, $18, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0F, $0F, $0F
	sDecay1Level	$0F, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$8C, $8A, $8D, $8B
	sFinishVoice
	even
