	sHeaderMusic
	sHeaderVoice	Credits_Voices
	sHeaderTempo	$01, $33
	sHeaderDAC	Credits_DAC
	sHeaderFM	Credits_FM1, -$0C, $12
	sHeaderFM	Credits_FM2, $00, $0B
	sHeaderFM	Credits_FM3, -$0C, $14
	sHeaderFM	Credits_FM4, -$0C, $08
	sHeaderFM	Credits_FM5, -$0C, $20
	sHeaderPSG	Credits_PSG1, -$30, $01, $00, None
	sHeaderPSG	Credits_PSG2, -$30, $03, $00, None
	sHeaderPSG	Credits_PSG3, $00, $03, $00, 04
	sHeaderFinish

Credits_FM1:
	sTiming		$01
	sNote		nR, $60
	sVoice		1C
	sVolAddFM	-$08
	sGate		$06
	sCall		Credits_Call1
	sPan		sPanCenter
	sGate		$00
	sVoice		03
	sVib		$0D, $01, $07, $04
	sNote		nR, $30
	sCall		Credits_Call3
	sNote		nE6, nD6, $18, nC6, $0C, nB5, $18, nC6
	sNote		$0C, nB5, $18, nG5, $54
	sCall		Credits_Call3
	sNote		$0C, nF5, $18, nA5, $0C, nG5, $18, nA5
	sNote		$0C, nG5, $18, nC5, $24, nR, $60, nR
	sNote		nR, nR
	sVibOff
	sTiming		$01
	sTempoSet	$0F
	sVoice		05
	sVolAddFM	$02
	sNote		nR, $06, nE5, nG5, nE5, nG5, $09, nA5
	sNote		nB5, $0C, nC6, $06, nB5, nA5, nG5, $09
	sNote		nA5, $06, nG5, $03, nE5, $06, nR, $06
	sNote		nA5, nC6, nA5, nC6, $09, nD6, nE6, $0C
	sNote		nF6, $06, nE6, nD6, nC6, $0C, nA5, $0C
	sNote		nD6, $04, nC6, nD6, nC6, $24
	sTransAdd	-$0C
	sVolAddFM	$09
	sVoice		08
	sNote		nR, $18, nA5, $06, nB5, nC6, nE6
	sCall		Credits_Call4
	sVoice		0B
	sVolAddFM	-$15
	sNote		nR, $0C, nG5, nA5, nG6
	sCall		Credits_Call5
	sNote		nE6, $1E, nE7, $06, nC7, $18, nR, $24
	sTiming		$01
	sTempoSet	$0A
	sVoice		0F
	sTransAdd	$0C
	sVolAddFM	$0B
	sCall		Credits_Call6
	sTiming		$01
	sTempoSet	$07
	sNote		nR, $60
	sTiming		$01
	sTempoSet	$03
	sNote		nR, $30
	sVoice		17
	sVolAddFM	$0E
	sNote		nR, $04, nF6, $08, nE6, $03, nR, nD6
	sNote		nR, nC6, nR, nD6, nR, nC6, $04, nA5
	sNote		nR, $02, nAs5, nR, $04, nAs5, $08, nC6
	sNote		$03, nR, nAs5, nR, nA5, $04, nAs5, nR
	sNote		$02, nC6, $0E, nR, $06, nE6, $02, nR
	sNote		$04, nE6, $0C, nF6, nE6, $0A, nD6, $02
	sTiming		$01
	sTempoSet	$04
	sVolAddFM	-$0B
	sVoice		1A
	sNote		nR, $60
	sCall		Credits_Call8
	sVolAddFM	$09
	sDetuneSet	$03
	sVoice		18
	sVib		$00, $01, $06, $04
	sCall		Credits_Call9
	sVolAddFM	-$11
	sVoice		1B
	sDetuneSet	$02
	sNote		nA1, $6C, sTie, $60
	sTiming		$01
	sEnd

Credits_Call3:
	sNote		nC6, $0C, nA5, $18, nC6, $0C, nB5, $18
	sNote		nC6, $0C, nB5, $18, nG5, $48, nA5, $0C
	sRet

Credits_Call8:
	sNote		nR, $0C, nCs6, $15, nR, $03, nCs6, $06
	sNote		nR, nD6, $0F, nR, $03, nB5, $18, nR
	sNote		$06, nCs6, $06, nR, nCs6, nR, nCs6, nR
	sNote		nA5, nR, nG5, $0F, nR, $03, nB5, $18
	sNote		nR, $06
	sLoop		$00, $02, Credits_Call8
	sRet

Credits_FM2:
	sNote		nR, $60
	sVoice		1D

Credits_Loop1:
	sNote		nD3, $0C, nD3, nB3, nB3, nG3, nG3, nA3
	sNote		nA3, nD3, nD3, nA3, nA3, nFs3, nFs3, nG3
	sNote		nG3, nC3, nC3, nG3, nG3, nFs3, nFs3, nG3
	sNote		nG3, nA2, nA2, nA2, nA2, nD3, nD3, nD3
	sNote		nE3
	sLoop		$00, $02, Credits_Loop1
	sVoice		00

Credits_Loop2:
	sGate		$05
	sNote		nF3, $0C
	sCall		Credits_Call10
	sGate		$05
	sNote		nE3, $0C, $0C, $0C, $0C, $0C
	sGate		$00
	sNote		nC3, nD3, nE3
	sLoop		$00, $02, Credits_Loop2
	sGate		$05
	sNote		nF3
	sCall		Credits_Call10
	sGate		$05
	sNote		nE3
	sCall		Credits_Call10
	sGate		$05
	sNote		nD3
	sCall		Credits_Call10
	sGate		$05
	sNote		nC3, $0C, $0C, $0C, $0C, $0C
	sGate		$00
	sNote		nG2, nA2, nB2
	sGate		$05

Credits_Loop3:
	sNote		nC3
	sLoop		$00, $18, Credits_Loop3
	sGate		$00
	sNote		nC3, $06, nR, nC3, $0C, nA2, $06, nR
	sNote		nA2, $0C, nAs2, $06, nR, nAs2, $0C, nB2
	sNote		$06, nR, nB2, $0C
	sVoice		06
	sTransAdd	-$18
	sVolAddFM	$02

Credits_Loop4:
	sNote		nC4, $0F, nR, $03, nE4, nR, nG4, $09
	sNote		nR, $03, nA4, $09, nR, $03, nB4, $0F
	sNote		nR, $03, nA4, nR, nG4, $09, nR, $03
	sNote		nE4, $09, nR, $03
	sTransAdd	$05
	sLoop		$00, $02, Credits_Loop4
	sTransAdd	-$0A
	sNote		nC4, $0F, nR, $03, nE4, nR, nG4, $09
	sNote		nR, $03, nE4, $09, nR, $03, nC4, $06
	sNote		nR, $12, nE4, $18
	sVolAddFM	$01
	sVoice		09

Credits_Loop5:
	sNote		nA3, $03, nR, nA3, $06, nE4, $03, nR
	sNote		nE4, $06, nD4, $03, nR, nD4, $06, nE4
	sNote		$03, nR, nE4, $06
	sLoop		$00, $02, Credits_Loop5

Credits_Loop6:
	sNote		nD4, $03, nR, nD4, $06, nA4, $03, nR
	sNote		nA4, $06, nF4, $03, nR, nF4, $06, nA4
	sNote		$03, nR, nA4, $06
	sLoop		$00, $02, Credits_Loop6
	sNote		nB3, $03, nR, nB3, $06, nF4, $03, nR
	sNote		nF4, $06, nD4, $03, nR, nD4, $06, nF4
	sNote		$03, nR, nF4, $06, nE4, $03, nR, nE4
	sNote		$06, nB4, $03, nR, nB4, $06, nGs4, $03
	sNote		nR, nGs4, $06, nB4, $03, nR, nB4, $06
	sNote		nA3, $03, nR, nA3, $06, nE4, $03, nR
	sNote		nE4, $06, nC4, $03, nR, nC4, $06, nE4
	sNote		$03, nR, nE4, $06, nA3, $03, nR, $09
	sNote		nR, $24
	sVolAddFM	-$08
	sNote		nC4, $06, nR, $03, nC4, nR, $06, nC4
	sNote		$12, nR, $06, nC4, $02, nR, $01, nC4
	sNote		$02, nR, $01, nAs3, $06, nR, $03, nAs3
	sNote		$03, nR, $06, nA3, $12, nR, $06, nA3
	sNote		$02, nR, $01, nA3, $02, nR, $01

Credits_Loop7:
	sNote		nD4, $06, nR, $03, nD4, $06, nR, $03
	sNote		nD4, $02, nR, $01, nD4, $02, nR, $01
	sTransAdd	-$01
	sLoop		$00, $04, Credits_Loop7
	sTransAdd	$04
	sNote		nG3, $06, nR, $03, nG3, nR, $06, nG3
	sNote		$12, nR, $06, nG3, $02, nR, $01, nG3
	sNote		$02, nR, $01, nB3, $06, nR, $03, nB3
	sNote		nR, $06, nB3, $12, nR, $06, nD4, $02
	sNote		nR, $01, nB3, $02, nR, $01, nC4, $06
	sNote		nR, $03, nC4, nR, $06, nC4, $12, nR
	sNote		$06, nE4, $02, nR, $01, nF4, $02, nR
	sNote		$01, nG4, $06, nR, nG3, $24
	sVoice		10
	sTransAdd	$0C
	sVolAddFM	$07
	sGate		$06

Credits_Loop8:
	sCall		Credits_Call11
	sTransAdd	$06
	sCall		Credits_Call11
	sTransAdd	-$01
	sCall		Credits_Call11
	sTransAdd	$02
	sCall		Credits_Call11
	sTransAdd	-$07
	sLoop		$02, $02, Credits_Loop8
	sGate		$00
	sTransAdd	-$0C
	sVolAddFM	-$04
	sVoice		14
	sNote		nR, $30, nR, $30, nA4, $03, nR, nA4
	sNote		nR, nG4, nR, nG4, nR, nF4, nR, nF4
	sNote		nR, nE4, nR, nE4, $02, nR, nAs4
	sVolAddFM	$02
	sNote		nR, $04, nAs4, $08, nC5, $03, nR, nAs4
	sNote		nR, nA4, $06, nR, nAs4, $04, nA4, nR
	sNote		$02, nG4, nR, $04, nG4, $08, nA4, $03
	sNote		nR, nG4, nR, nF4, nR, nF4, nR, nG4
	sNote		$04, nF4, nR, $02, nE4, nR, $04, nE4
	sNote		$08, nE4, $03, nR, nE4, nR, nA4, $09
	sNote		nR, $03, nA4, $0A, nD4, $02
	sTransAdd	$0C
	sVolAddFM	-$02
	sVoice		19
	sNote		nR, $60

Credits_Loop9:
	sNote		nA3, $06, nR, nA3, nR, nE3, nR, nE3
	sNote		nR, nG3, $12, nFs3, $0C, nG3, $06, nFs3
	sNote		$0C, nA3, $06, nR, nA3, nR, nE3, nR
	sNote		nE3, nR, nD4, $12, nCs4, $0C, nD4, $06
	sNote		nCs4, $0C
	sLoop		$00, $02, Credits_Loop9
	sNote		nG3, $06, nR, nE3, nR, nF3, nR, nFs3
	sNote		nR, nG3, $06, nG3, $06, nE3, $06, nR
	sNote		nF3, nR, nG3, nR, nE3, $06, nR, nE3
	sNote		nR, nGs3, nR, nGs3, nR, nB3, $06, nR
	sNote		nB3, nR, nD4, nR, nD4, nR, nR, $0C
	sNote		nA3, $12, nR, $06, nA3, $12, nGs3, $12
	sNote		nA3, $06, nR
	sVolAddFM	-$03
	sNote		nA2, $6C, sTie, $60
	sEnd

	; Unused data
	sNote		$00, $01

Credits_Call10:
	sNote		$0C, $0C, $0C, $0C, $0C, $0C
	sGate		$00
	sNote		$0C
	sRet

Credits_Call11:
	sNote		nC4, $03, nC4, nG3, nG3, nA3, nA3, nG3
	sNote		nG3
	sLoop		$00, $02, Credits_Call11
	sRet

Credits_FM3:
	sNote		nR, $60
	sLoop		$00, $08, Credits_FM3
	sVoice		1F
	sVolAddFM	$01
	sPan		sPanRight
	sNote		nD6, $06, nE6, nFs6, nG6, nE6, nFs6, nG6
	sNote		nA6, nFs6, nG6, nA6, nB6, nA6, nB6, nC7
	sNote		nD7

Credits_Loop10:
	sPan		sPanLeft
	sNote		nE7
	sPan		sPanRight
	sNote		nC7
	sVolAddFM	$02
	sLoop		$00, $0D, Credits_Loop10
	sPan		sPanCenter
	sVoice		02
	sVolAddFM	-$1B
	sTransAdd	-$18
	sNote		nG6, $06, nA6, nC7, $0C, nA6, nR, $4E
	sNote		nR, nG6, $06, nA6, nC7, $0C, nE7, nR
	sNote		$4E, nR, nG6, $06, nA6, nC7, $0C, nA6
	sNote		nR, $36, nR, nC7, $06, nR, $12, nA6
	sNote		$18, nG6, $06, nR, nA6, nR, nC7, nR
	sVibOff
	sVoice		04
	sVolAddFM	-$02

Credits_Loop11:
	sNote		nC6, $01, sTie, nB5, $1B, nR, $08, nAs5
	sNote		$01, sTie, nA5, $1B, nR, $08
	sLoop		$00, $02, Credits_Loop11
	sNote		nC6, $01, sTie, nB5, $0B, nR, $0C, nAs5
	sNote		$01, sTie, nA5, $0B, nR, $0C, nCs6, $01
	sNote		sTie, nC6, $1B, nR, $08, nC6, $01, sTie
	sNote		nB5, $24, sTie, $18, sTie, $5A, nR, $06
	sTransAdd	$18
	sNote		nR, $60, nR, nR, $30
	sTransAdd	-$18
	sVoice		08
	sTransAdd	$0C
	sVolAddFM	$03
	sDetuneSet	$02
	sNote		nR, $18, nA5, $06, nB5, nC6, nE6
	sCall		Credits_Call4
	sVoice		0D
	sTransAdd	$0C
	sVolAddFM	$0B
	sNote		nR, $0C, nG5, nA5, nG6
	sCall		Credits_Call5
	sVoice		0A
	sVolAddFM	-$14
	sNote		nR, $06
	sDetuneSet	$14
	sNote		nG5, $01, sTie
	sDetuneSet	$00
	sNote		$02, nA5, $03
	sGate		$05
	sNote		nC6, $03, nC6, $06, nA5, $03, nC6
	sGate		$00
	sNote		nC6
	sVolAddFM	-$04
	sTransAdd	$33
	sVoice		0E
	sNote		nDs4, $03
	sVolAddFM	$07
	sNote		nDs4
	sVolAddFM	$07
	sNote		nDs4
	sVolAddFM	$07
	sNote		nDs4
	sVoice		0A
	sVolAddFM	-$11
	sTransAdd	-$33
	sNote		nE6, $03, nF6, nG6, nR, $09
	sDetuneSet	-$14
	sNote		nC7, $01, sTie
	sDetuneSet	$00
	sVib		$2C, $01, $04, $04
	sNote		nC7, $23
	sVibOff
	sVoice		0F
	sVolAddFM	-$01
	sDetuneSet	$03
	sCall		Credits_Call6
	sDetuneSet	$00
	sVoice		15
	sVolAddFM	$09
	sNote		nR, $30, nR, $30, nR, $2E, nF5, $02
	sNote		nR, $04, nF5, $08, nF5, $03, nR, nF5
	sNote		nR, nE5, $03, nR, $13, nD5, $02, nR
	sNote		$04, nD5, $08, nD5, $03, nR, nD5, nR
	sNote		nC5, $03, nR, $15, nR, $04, nA6, $08
	sNote		nG6, $03, nR, nG6, nR, nF6, nR, nF6
	sNote		nR, nE6, $04, nF6, $02, nE6, $04, nD6
	sNote		$02
	sVoice		0A
	sVolAddFM	-$07
	sNote		nR, $60

Credits_Loop12:
	sNote		nE6, $06, nR, nE6, nR, nCs6, nR, nCs6
	sNote		nR, nD6, $12, nD6, $1E, nE6, $06, nR
	sNote		nE6, nR, nCs6, nR, nCs6, nR, nG6, $12
	sNote		nG6, $1E
	sLoop		$00, $02, Credits_Loop12
	sNote		nR, $0C, nD6, $12, nR, $06, nD6, nR
	sNote		nCs6, $12, nD6, nCs6, $0C, nGs5, $18, nB5
	sNote		nD6, nGs6, nR, $0C, nE6, nR, nE6, $12
	sNote		nDs6, nE6, $06, nR
	sVoice		19
	sVolAddFM	-$08
	sDetuneSet	$03
	sNote		nA2, $6C, sTie, $60
	sEnd

Credits_Call25:
	sNote		nD6, $06, nE6, nFs6, nG6, nE6, nFs6, nG6
	sNote		nA6, nFs6, nG6, nA6, nB6, nA6, nB6, nC7
	sNote		nD7
	sRet

Credits_FM4:
	sVoice		20
	sNote		nR, $60
	sVolAddFM	$08
	sCall		Credits_Call12
	sNote		nFs5, $0C, nFs5, nR, nR, nA5, nA5, nR
	sNote		nR
	sCall		Credits_Call12
	sNote		nA5, $24, $24, $18
	sPan		sPanLeft
	sCall		Credits_Call13
	sVolAddFM	-$0E

Credits_Loop14:
	sNote		nGs5, $01, sTie, nG5, $1B, nR, $08, nFs5
	sNote		$01, sTie, nF5, $1B, nR, $08
	sLoop		$00, $02, Credits_Loop14
	sNote		nGs5, $01, sTie, nG5, $0B, nR, $0C, nFs5
	sNote		$01, sTie, nF5, $0B, nR, $0C, nAs5, $01
	sNote		sTie, nA5, $1B, nR, $08, nGs5, $01, sTie
	sNote		nG5, $24, sTie, $18, sTie, $5A, nR, $06
	sTransAdd	$18
	sNote		nR, $60, nR, nR, $5A
	sPan		sPanCenter
	sVoice		0A
	sTransAdd	-$0C
	sVolAddFM	$05

Credits_Loop15:
	sNote		nB6, $09, nR, $03, nB6, nR, nC7, $06
	sNote		nR, nB6, $0C, nR, $06
	sLoop		$00, $02, Credits_Loop15
	sNote		nR, $12, nC7, $03, nR, $0F, nC7, $03
	sNote		nR, $1B, nC7, $03, nR, $0F, nC7, $03
	sNote		nR, $09, nF6, $09, nR, $03, nF6, nR
	sNote		nA6, $06, nR, nF6, $0C, nR, $06, nGs6
	sNote		$09, nR, $03, nGs6, nR, nB6, $06, nR
	sNote		nGs6, $0C, nR, $06, nR, nR, $0C, nC7
	sNote		$03, nR, $0F, nC7, $03, nR, $0F, nC7
	sNote		$03, nR, $2D
	sTransAdd	-$0C
	sVolAddFM	$03
	sVoice		0C
	sPan		sPanLeft
	sCall		Credits_Call15
	sVoice		11
	sVolAddFM	-$0A
	sTransAdd	$18
	sCall		Credits_Call16
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nA5, $02
	sDetuneSet	$00
	sNote		sTie, $0A, nR, $03, nA5, nR, nR, nA5
	sNote		nR, $09
	sCall		Credits_Call16
	sDetuneSet	-$14
	sNote		nA5, $02
	sDetuneSet	$00
	sNote		$0A, nR, $06
	sVib		$18, $01, $07, $04
	sDetuneSet	-$1E
	sNote		nA5, $02, sTie
	sDetuneSet	$00
	sNote		$1C
	sDetuneSet	$00
	sDetuneSet	$03
	sCall		Credits_Call17
	sDetuneSet	$00
	sPan		sPanCenter
	sVoice		0A
	sVolAddFM	-$0B
	sNote		nR, $60

Credits_Loop16:
	sNote		nCs6, $06, nR, nCs6, nR, nA5, nR, nA5
	sNote		nR, nB5, $12, nB5, $1E, nCs6, $06, nR
	sNote		nCs6, nR, nA5, nR, nA5, nR, nD6, $12
	sNote		nD6, $1E
	sLoop		$00, $02, Credits_Loop16
	sVoice		18
	sDetuneSet	$03
	sVolAddFM	$08
	sCall		Credits_Call9
	sVoice		19
	sVolAddFM	-$10
	sVib		$00, $01, $06, $04
	sNote		nA2, $6C, sTie, $60
	sEnd

Credits_Call12:
	sNote		nB5, $24, $24, $18, nA5, $24, $24, $18
	sNote		nG5, $24, $24, $18
	sRet

Credits_Call13:
	sVoice		02
	sTransAdd	-$18
	sVolAddFM	$0D

Credits_Loop13:
	sCall		Credits_Call14
	sNote		nD5, nD5
	sLoop		$00, $02, Credits_Loop13
	sCall		Credits_Call14
	sNote		nE4, nE4, nC5, nC5, nA4, nA4, nF4, nF4
	sNote		nD4, nD4, nB4, nB4
	sVolAddFM	$03
	sTransAdd	$0C
	sVoice		01
	sNote		nG6, $18, nA6, nB6
	sTransAdd	-$0C
	sVoice		04
	sRet

Credits_Call14:
	sNote		nE5, $0C, nE5, nC5, nC5, nA4, nA4, nF4
	sNote		nF4, nD5, nD5, nB4, nB4, nG4, nG4
	sRet

Credits_Call16:
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nG5, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nG5, $03, nR, $18
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nCs6, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nCs6, $03, nR, $18
	sNote		nR, $0C
	sDetuneSet	-$14
	sNote		nC6, $02
	sDetuneSet	$00
	sNote		sTie, $06, nR, $01, nC6, $03, nR, $18
	sRet

Credits_Call17:
	sVolAddFM	$08
	sVoice		16
	sNote		nR, $30, nR, $30
	sChannelTick	$01
	sCall		Credits_Call18
	sChannelTick	$02
	sVoice		12
	sVib		$01, $01, $01, $04
	sNote		nD6, $02, nR, $04, nD6, $08, nD6, $03
	sNote		nR, nD6, nR, nC6, nR, nA6, nR, nF6
	sNote		nR, $07, nAs5, $02, nR, $04, nAs5, $08
	sNote		nAs5, $03, nR, nAs5, nR, nA5, $03, nR
	sNote		$13, nA5, $0E, nCs6, $0C, nE6, nCs7, $0A
	sNote		nD7, $02
	sRet

Credits_Call18:
	sNote		nAs3, $01, sTie, nA3, $04, nR, $07, nAs3
	sNote		$01, sTie, nA3, $04, nR, $07, nC4, $01
	sNote		sTie, nB3, $04, nR, $07, nC4, $01, sTie
	sNote		nB3, $04, nR, $07, nCs4, $01, sTie, nC4
	sNote		$04, nR, $07, nCs4, $01, sTie, nC4, $04
	sNote		nR, $07, nD4, $01, sTie, nCs4, $04, nR
	sNote		$07, nD4, $01, sTie, nCs4, $04, nR, $03
	sRet

Credits_Call9:
	sNote		nR, $0C, nG6, nB6, nD7, nFs7, nR, $06
	sNote		nFs7, $0C, nG7, $06, nFs7, $0C, nGs7, $54
	sNote		nR, $0C, nA7, nR, nA7, nR, $12, nGs7
	sNote		nA7, $0C
	sRet

Credits_FM5:
	sVoice		20
	sNote		nR, $60
	sVolAddFM	-$10
	sCall		Credits_Call19
	sNote		nD5, $0C, $0C, nR, $18, nFs5, $0C, $0C
	sNote		nR, $18
	sCall		Credits_Call19
	sNote		nFs5, $24, $24, $18
	sPan		sPanRight
	sCall		Credits_Call13
	sVolAddFM	-$0E

Credits_Loop17:
	sNote		nF5, $01, sTie, nE5, $1B, nR, $08, nDs5
	sNote		$01, sTie, nD5, $1B, nR, $08
	sLoop		$00, $02, Credits_Loop17
	sNote		nF5, $01, sTie, nE5, $0B, nR, $0C, nDs5
	sNote		$01, sTie, nD5, $0B, nR, $0C, nFs5, $01
	sNote		sTie, nF5, $1B, nR, $08, nF5, $01, sTie
	sNote		nE5, $24, sTie, $18, sTie, $5A, nR, $06
	sTransAdd	$18
	sPan		sPanCenter
	sVolAddFM	$03
	sTransAdd	$0C
	sVoice		07
	sNote		nR, $4E, nG4, $03, nA4, nC5, nR, nA4
	sNote		nR, $51, nA5, $03, nF5, nC5, nR, nF5
	sNote		nR, $5D
	sVoice		0A
	sTransAdd	-$18
	sVolAddFM	$02

Credits_Loop18:
	sNote		nG6, $09, nR, $03, nG6, nR, nA6, $06
	sNote		nR, nG6, $0C, nR, $06
	sLoop		$00, $02, Credits_Loop18
	sNote		nR, $12, nA6, $03, nR, $0F, nA6, $03
	sNote		nR, $1B, nA6, $03, nR, $0F, nA6, $03
	sNote		nR, $09, nD6, $09, nR, $03, nD6, nR
	sNote		nF6, $06, nR, nD6, $0C, nR, $06, nE6
	sNote		$09, nR, $03, nE6, nR, nGs6, $06, nR
	sNote		nE6, $0C, nR, $18, nA6, $03, nR, $0F
	sNote		nA6, $03, nR, $0F, nA6, $03, nR, $2D
	sVoice		0C
	sPan		sPanRight
	sTransAdd	-$0C
	sVolAddFM	$03
	sCall		Credits_Call20
	sVoice		12
	sTransAdd	$24
	sVolAddFM	-$0C
	sCall		Credits_Call22
	sNote		nE6, nF6, nG6
	sCall		Credits_Call22
	sNote		nG6, nF6, nE6
	sTransAdd	-$0C
	sCall		Credits_Call17
	sPan		sPanCenter
	sVoice		1A
	sDetuneSet	$03
	sVolAddFM	-$08
	sNote		nR, $60
	sCall		Credits_Call8
	sVolAddFM	$00
	sVoice		1A
	sNote		nR, $60, nR, $0C, nE6, $06, nR, nB6
	sNote		nE6, $06, nR, $0C, nE6, $06, nR, nB6
	sNote		nE6, $06, nR, $18
	sVolAddFM	$05
	sNote		nR, $0C, nA3, nR, nA3
	sEnd

Credits_Call19:
	sNote		nG5, $24, $24, $18, nFs5, $24, $24, $18
	sNote		nE5, $24, $24, $18
	sRet

Credits_PSG1:
	sNote		nR, $60
	sEnv		08
	sVolAddPSG	$03
	sGate		$06
	sCall		Credits_Call1
	sEnv		01
	sGate		$00
	sVolAddPSG	-$03

Credits_Loop20:
	sNote		nR, $18, nC6, $06, nR, $1E, nC6, $0C
	sNote		nR, $18, nR, $18, nB5, $06, nR, $1E
	sNote		nB5, $0C, nR, $18
	sLoop		$00, $03, Credits_Loop20
	sNote		nR, $18, nA5, $06, nR, $1E, nA5, $0C
	sNote		nR, $18, nR, $18, nG5, $06, nR, $1E
	sNote		nG5, $0C, nR, $18
	sEnv		05
	sVib		$0E, $01, $01, $03
	sGate		$10
	sNote		nE5, $24, nD5, nE5, nD5, nE5, $0C, nR
	sNote		nD5, nR, nF5, $24
	sGate		$00
	sNote		nE5, $60, sTie, $3C
	sVibOff
	sEnv		09
	sVolAddPSG	$01

Credits_Loop21:
	sNote		nR, $06, nE6, $0C, nE6, nE6, nE6, $06
	sNote		nR, nE6, $0C, nE6, nE6, $03, $09, $06
	sTransAdd	$05
	sLoop		$00, $02, Credits_Loop21
	sTransAdd	-$0A
	sNote		nR, $06, nE6, $0C, nE6, nE6, nE6, $06
	sNote		nR, $30
	sEnv		08
	sVolAddPSG	$01
	sCall		Credits_Call23
	sNote		nR, $02, nR, $30
	sVolAddPSG	$03
	sTransAdd	-$0C
	sEnv		05
	sCall		Credits_Call15
	sTransAdd	$0C
	sVolAddPSG	-$04
	sEnv		None
	sCall		Credits_Call24
	sNote		nR, $0C, nF5, nR, $03, nF5, nR, nR
	sNote		nF5, nR, $09
	sCall		Credits_Call24
	sNote		nF5, $0C, nR, $06, nF5, $1E
	sEnv		06
	sVolAddPSG	$04
	sNote		nR, $30, nR, $30
	sChannelTick	$01
	sCall		Credits_Call18
	sChannelTick	$02
	sNote		nD6, $02, nR, $04, nD6, $08, nD6, $03
	sNote		nR, nD6, nR, nC6, nR, nA6, nR, nF6
	sNote		nR, $07, nAs5, $02, nR, $04, nAs5, $08
	sNote		nAs5, $03, nR, nAs5, nR, nA5, $03, nR
	sNote		$13, nA5, $0E, nCs6, $0C, nE6, nCs7, $0A
	sNote		nD7, $02, nR, $60, nR, nR, nR, nR
	sVolAddPSG	-$01
	sNote		nR, $0C, nB5, $12, nR, $06, nB5, nR
	sNote		nA5, $12, nB5, nA5, $0C, nE5, $18, nGs5
	sNote		nB5, nD6, nR, $0C, nCs6, nR, nCs6, $12
	sNote		nC6, nCs6, $06
	sEnd

Credits_Call24:
	sNote		nR, $0C, nE5, $07, nR, $02, nE5, $03
	sNote		nR, $18, nR, $0C, nAs5, $07, nR, $02
	sNote		nAs5, $03, nR, $18, nR, $0C, nA5, $07
	sNote		nR, $02, nA5, $03, nR, $18
	sRet

Credits_PSG2:
	sNote		nR, $60
	sLoop		$00, $08, Credits_PSG2
	sNote		nR, $02
	sCall		Credits_Call25
	sVolAddPSG	-$02
	sEnv		01
	sNote		nR, $16, nE6, $06, nR, $1E, nE6, $0C
	sNote		nR, $18, nR, $18, nD6, $06, nR, $1E
	sNote		nD6, $0C, nR, $18

Credits_Loop22:
	sNote		nR, $18, nE6, $06, nR, $1E, nE6, $0C
	sNote		nR, $18, nR, $18, nD6, $06, nR, $1E
	sNote		nD6, $0C, nR, $18
	sLoop		$00, $02, Credits_Loop22
	sNote		nR, $18, nC6, $06, nR, $1E, nC6, $0C
	sNote		nR, $18, nR, $18, nB5, $06, nR, $1E
	sNote		nB5, $0C, nR, $18
	sGate		$06
	sEnv		06

Credits_Loop23:
	sNote		nC7, $0C, nB6, nA6, nG6
	sLoop		$00, $08, Credits_Loop23
	sGate		$00
	sEnv		09
	sVolAddPSG	$01

Credits_Loop24:
	sNote		nR, $06, nG6, $0C, nG6, nG6, nG6, $06
	sNote		nR, nG6, $0C, nG6, nG6, $03, $09, $06
	sTransAdd	$05
	sLoop		$00, $02, Credits_Loop24
	sTransAdd	-$0A
	sNote		nR, $06, nG6, $0C, nG6, nG6, nG6, $06
	sNote		nR, $30, nR, $02
	sDetuneSet	$01
	sVolAddPSG	$03
	sCall		Credits_Call23
	sDetuneSet	$00
	sNote		nR, $30
	sVolAddPSG	$01
	sTransAdd	-$0C
	sEnv		05
	sCall		Credits_Call20
	sTransAdd	$0C
	sVolAddPSG	-$03
	sGate		$03

Credits_Loop25:
	sNote		nC7, $03, nC7, nG7, nC7, nF7, nC7, nE7
	sNote		nC7
	sLoop		$00, $02, Credits_Loop25

Credits_Loop26:
	sNote		nAs6, nAs6, nF7, nAs6, nDs7, nAs6, nCs7, nAs6
	sLoop		$00, $02, Credits_Loop26

Credits_Loop27:
	sNote		nA6, nA6, nE7, nA6, nD7, nA6, nC7, nA6
	sLoop		$00, $04, Credits_Loop27
	sLoop		$01, $02, Credits_Loop25
	sNote		nR, $60, nR, nR, nR, nR, nR, nR
	sNote		nR, nR
	sVolAddFM	$0C
	sDetuneSet	$02
	sVolAddPSG	$02
	sNote		nR, $0C, nE6, $06, nR, nB6, nE6, $06
	sNote		nR, $0C, nE6, $06, nR, nB6, nE6
	sEnd

Credits_PSG3:
	sNoiseSet	snWhitePSG3
	sGate		$04

Credits_Loop28:
	sNote		nA5, $0C
	sLoop		$00, $48, Credits_Loop28
	sGate		$06

Credits_Loop29:
	sNote		$0C
	sLoop		$00, $60, Credits_Loop29
	sVolAddPSG	-$01
	sCall		Credits_Call26
	sGate		$0E
	sNote		$0C
	sGate		$03
	sNote		$06, $06, $03, $03, $06, $03, $03, $06

Credits_Loop30:
	sCall		Credits_Call26
	sLoop		$00, $04, Credits_Loop30
	sEnv		09
	sVolAddPSG	$01
	sTransAdd	$0B

Credits_Loop31:
	sNote		nA3, $06, nA3, nE4, nE4, nD4, nD4, nE4
	sNote		nE4
	sLoop		$00, $02, Credits_Loop31

Credits_Loop32:
	sNote		nD4, nD4, nA4, nA4, nF4, nF4, nA4, nA4
	sLoop		$00, $02, Credits_Loop32
	sNote		nB3, nB3, nF4, nF4, nD4, nD4, nF4, nF4
	sNote		nE4, nE4, nB4, nB4, nGs4, nGs4, nB4, nB4
	sNote		nA3, nA3, nE4, nE4, nC4, nC4, nE4, nE4
	sNote		nA3, $06, nR, $1E
	sGate		$02
	sTransAdd	-$0B

Credits_Loop33:
	sEnv		04
	sNote		nA5, $03, $03
	sVolAddPSG	$02
	sEnv		08
	sGate		$08
	sNote		$06
	sGate		$03
	sVolAddPSG	-$02
	sLoop		$00, $1E, Credits_Loop33
	sNote		nR, $24

Credits_Loop34:
	sEnv		04
	sNote		$03, $03
	sVolAddPSG	$02
	sEnv		08
	sGate		$08
	sNote		$06
	sGate		$03
	sVolAddPSG	-$02
	sLoop		$00, $20, Credits_Loop34
	sNote		nR, $30
	sGate		$01
	sEnv		04
	sVolAddPSG	$03

Credits_Loop35:
	sNote		nA5, $02, nR, nA5
	sLoop		$00, $08, Credits_Loop35

Credits_Loop36:
	sNote		nR, $04, nA5, $02
	sLoop		$00, $08, Credits_Loop36
	sVolAddPSG	-$01

Credits_Loop37:
	sNote		nA5, $02, nR, nA5
	sLoop		$00, $18, Credits_Loop37
	sVolAddPSG	-$02

Credits_Loop38:
	sNote		nA5, $04, nR, nA5
	sLoop		$00, $08, Credits_Loop38

Credits_Loop39:
	sGate		$03
	sNote		$0C
	sGate		$0C
	sNote		$0C
	sGate		$03
	sNote		$0C
	sGate		$0C
	sNote		$0C
	sLoop		$00, $0D, Credits_Loop39
	sGate		$03
	sNote		$06
	sGate		$0E
	sNote		$12
	sGate		$03
	sNote		$0C
	sGate		$0F
	sNote		$0C
	sEnd

Credits_DAC:
	sNote		dSnare, $06, dSnare, dSnare, dSnare, dSnare, $0C, $06
	sNote		$0C, $06, $0C, $0C, $0C
	sCall		Credits_Call27
	sNote		dKick, $18, dSnare, $0C, dSnare, dKick, $18, dSnare
	sNote		$0C, dSnare
	sCall		Credits_Call27
	sNote		dKick, $0C, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare
	sNote		dSnare

Credits_Loop40:
	sNote		dKick, $18, dSnare, $0C, dKick, $18, $0C, dSnare
	sNote		$18
	sLoop		$00, $07, Credits_Loop40
	sNote		dKick, $18, dSnare, $0C, dKick, $18, dSnare, $0C
	sNote		$0C, $0C

Credits_Loop41:
	sNote		dKick, $18, dSnare, $0C, dKick, $18, $0C, dSnare
	sNote		$18
	sLoop		$00, $03, Credits_Loop41
	sNote		dKick, $18, dSnare, $0C, dKick, $18, dSnare, $0C
	sNote		dSnare, dSnare
	sSongTick	$02

Credits_Loop42:
	sNote		dKick, $12, dKick, $06, dKick, $0C, dSnare
	sLoop		$00, $05, Credits_Loop42
	sNote		dKick, $12, dKick, $06, dKick, $06, dSnare, dSnare
	sNote		dSnare

Credits_Loop43:
	sNote		dKick, $0C
	sLoop		$00, $18, Credits_Loop43
	sNote		dKick, $0C, dKick, dKick, dKick, $06, dKick, $02
	sNote		dKick, dSnare, dSnare, $0C, nR, $24

Credits_Loop44:
	sNote		dKick, $0C, dKick, dKick, dKick
	sLoop		$00, $07, Credits_Loop44
	sNote		dKick, $0C, dKick, dSnare, $03, dSnare, dSnare, dSnare
	sNote		dSnare, dSnare, dSnare, dSnare
	sCall		Credits_Call28
	sNote		dTimpaniHi, $02, dKick, $01, dTimpaniMid, $05, dSnare, $01
	sNote		dTimpaniHi, $05, dTimpaniMid, $06
	sCall		Credits_Call28
	sNote		dTimpaniMid, $02, dSnare, $01, dTimpaniHi, $05, dSnare, $01
	sNote		dTimpaniMid, $05, dSnare, $01, dTimpaniHi, $02, dSnare, $03
	sNote		dSnare, $03, dSnare, dKick, dKick, dSnare, dSnare, dKick
	sNote		dKick, dKick, dSnare, $09, dSnare, $06, $03, $03
	sNote		dKick, $09, $03, dSnare, $09, dKick, $06, $06
	sNote		$03, dSnare, $06, $03, $03, dSnare, $06, dSnare
	sNote		dSnare, dSnare, dSnare, dSnare, dSnare, $04, $02, $04
	sNote		dKick, $02

Credits_Loop45:
	sNote		nR, $04, dKick, $08, dSnare, $06, dKick, dKick
	sNote		$0C, dSnare, $0A, dKick, $02
	sLoop		$00, $03, Credits_Loop45
	sSongTick	$01
	sNote		nR, $18, dSnare, $14, dKick, $04, dSnare, $0C
	sNote		dSnare, dSnare, $0C, $08, dKick, $04

Credits_Loop46:
	sNote		dKick, $0C, dSnare, dKick, dSnare
	sLoop		$01, $03, Credits_Loop46
	sNote		dKick, $0C, dSnare, dKick, $06, nR, $02, dSnare
	sNote		dSnare, dSnare, $09, dSnare, $03
	sLoop		$00, $03, Credits_Loop46
	sNote		dKick, $0C, dSnare, dKick, dSnare, dKick, $06, dSnare
	sNote		$12, dSnare, $0C, dKick
	sEnd

Credits_Call27:
	sNote		dKick, $18, dSnare, $0C, dKick, $18, dKick, $0C
	sNote		dSnare, dKick
	sLoop		$00, $03, Credits_Call27
	sRet

Credits_Call28:
	sNote		dKick, $0C, dSnare, $09, dKick, $06, $03, dKick
	sNote		$01, dTimpaniHi, $02, dTimpaniMid, $03, dSnare, $01, dTimpaniHi
	sNote		$0B, dKick, $0C, dSnare, $09, dKick, $06, $03
	sNote		dKick, $01, dTimpaniHi, $02, dTimpaniMid, $03, dSnare, $01
	sNote		dTimpaniHi, $0B, dKick, $0C, dSnare, $09, dKick, $06
	sNote		$03, dKick, $01, dTimpaniHi, $02, dTimpaniMid, $03, dSnare
	sNote		$01, dTimpaniHi, $0B, dKick, $0C, dSnare, $09, dKick
	sNote		$06, dSnare, $01
	sRet

Credits_Call1:
	sCall		Credits_Call2
	sNote		nFs5, nD5, nE5, nFs5, nD5
	sCall		Credits_Call2
	sNote		nB5, nA5, nB5, nC6, nD6
	sRet

Credits_Call2:
	sNote		nB5, $0C, nG5, nB5, nD6, nC6, nB5, nA5
	sNote		nB5, nA5, nFs5, nA5, nC6, nB5, nA5, nG5
	sNote		nA5, nG5, nE5, nG5, nB5, nA5, nG5, nFs5
	sNote		nG5, nFs5, nG5, nA5
	sRet

	; Unused data
	sNote		nR, $0C, nG6, nB6, nD7, nFs7, $0C, nR
	sNote		$06, nFs7, $0C, nG7, $06, nFs7, $0C, nE7
	sNote		$60, nR, $0C, nG6, nB6, nD7, nFs7, $0C
	sNote		nR, $06, nFs7, $0C, nG7, $06, nFs7, $0C
	sNote		nGs7, $5D, nR, $03, nA7, $12, nR, $06
	sNote		nA7, $12, nR, $06, nR, $06, nGs7, $12
	sNote		nA7, $06, nR, $12
	sRet

Credits_Call26:
	sGate		$0E
	sNote		$0C
	sGate		$03
	sNote		$06, $06, $06, $06, $06, $06
	sRet

Credits_Call4:
	sNote		nB6, $09, nR, $03, nB6, $06, nA6
	sLoop		$00, $03, Credits_Call4
	sNote		nB6, nA6, nE6, nC6, nG6, $0C, nA6, $06
	sNote		sTie, nF6, $4D, nR, $01, nA6, $24, nB6
	sNote		$0C, nGs6, $24, nB6, $09, nR, $03, nB6
	sNote		$12, nA6, $1E
	sRet

Credits_Call23:
	sNote		nR, $30, nR, nR, nF7, $03, nD7, nA6
	sNote		nF6, nD7, nA6, nF6, nD6, nA6, nF6, nD6
	sNote		nA5, nF6, nD6, nA5, nF5, $33, nR, $5E
	sRet

Credits_Call5:
	sNote		nE6, $2A, nE6, $03, nF6, nG6, $09, nA6
	sNote		nAs6, $06, nA6, $0C, nG6, nF6, $1E, nF6
	sNote		$06, nE6, nF6, $1E, nD6, $0C, nE6, nF6
	sNote		$2A, nD6, $03, nE6, nF6, $09, nG6, nGs6
	sNote		$06, nG6, $0C, nF6
	sRet

Credits_Call20:
	sCall		Credits_Call21
	sNote		nD6, $06, nR, $03, nD6, nR, $06, nCs6
	sNote		$18, nR, $06

Credits_Loop19:
	sNote		nF6, $06, nR, $03, nE6, $06, nR, $03
	sNote		nD6, nR
	sLoop		$00, $02, Credits_Loop19
	sNote		nF6, $06, nR, $03, nE6, $06, nR, $03
	sNote		nD6, $18, nR, $06
	sTransAdd	-$02
	sCall		Credits_Call21
	sTransAdd	$03
	sCall		Credits_Call21
	sTransAdd	-$01
	sNote		nR, $06
	sGate		$08
	sNote		nG6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$00
	sNote		nR, $0C, nF6, $24
	sRet

Credits_Call21:
	sNote		nE6, $06, nR, $03, nE6, nR, $06, nE6
	sNote		$18, nR, $06
	sRet

Credits_Call15:
	sNote		nG6, $06, nR, $03, nG6, nR, $06, nG6
	sNote		$18, nR, $06, nF6, $06, nR, $03, nF6
	sNote		nR, $06, nE6, $18, nR, $06, nA6, $06
	sNote		nR, $03, nG6, $06, nR, $03, nF6, nR
	sNote		nA6, $06, nR, $03, nG6, $06, nR, $03
	sNote		nF6, nR, nA6, $06, nR, $03, nG6, $06
	sNote		nR, $03, nF6, $18, nR, $06, nF6, $06
	sNote		nR, $03, nF6, nR, $06, nF6, $18, nR
	sNote		$06, nGs6, $06, nR, $03, nGs6, nR, $06
	sNote		nGs6, $18, nR, $06, nR, $06
	sGate		$08
	sNote		nB6, $09, $09, $09, $09
	sGate		$05
	sNote		$03, $03
	sGate		$00
	sNote		nR, $0C, nA6, $24
	sRet

Credits_Call6:
	sCall		Credits_Call7
	sNote		nG6, $12, nA6, $06, nG6, $12, nE6, $0C
	sCall		Credits_Call7
	sNote		nG6, $30, nR, $06
	sRet

Credits_Call7:
	sNote		nG6, $1E, nE6, $06, nC6, nC7, nAs6, $0C
	sNote		nC7, $06, nAs6, $0C, nG6, $06, nAs6, nA6
	sNote		$24, nE6, $06, nF6
	sRet

Credits_Call22:
	sNote		nR, $03, nE6, nC6, $06, $06, nG5, nC6
	sNote		$09, nE6, $09, nR, $06, nR, $03, nF6
	sNote		nCs6, $06, $06, nAs5, nCs6, $09, nF6, $09
	sNote		nR, $06, nR, $03, nE6, nC6, $06, $06
	sNote		nA5, nC6, $09, nE6, $0F, nD6, $0C
	sRet

Credits_Voices:

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
	sReleaseRate	$00, $00, $00, $08
	sTotalLevel	$19, $13, $37, $80
	sFinishVoice

	sNewVoice	01					; voice number $01
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$02, $04, $08, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $0A, $0A
	sDecay1Level	$00, $00, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	02					; voice number $02
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	03					; voice number $03
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$07, $03, $04, $03
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $12, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $08, $08
	sDecay1Level	$00, $00, $01, $01
	sDecay2Rate	$00, $00, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	04					; voice number $04
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $07, $07
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $07, $07
	sReleaseRate	$00, $00, $08, $08
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	05					; voice number $05
	sAlgorithm	$01
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$04, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $0C, $07, $09
	sDecay1Level	$02, $01, $01, $02
	sDecay2Rate	$07, $07, $07, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $14, $32, $80
	sFinishVoice

	sNewVoice	06					; voice number $06
	sAlgorithm	$00
	sFeedback	$03
	sDetune		$03, $03, $03, $03
	sMultiple	$07, $00, $00, $01
	sRateScale	$02, $00, $03, $02
	sAttackRate	$1E, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $04, $06, $01
	sDecay1Level	$0B, $03, $0B, $02
	sDecay2Rate	$08, $03, $0A, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$2C, $14, $22, $80
	sFinishVoice

	sNewVoice	07					; voice number $07
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $05, $05, $03
	sMultiple	$01, $00, $02, $00
	sRateScale	$01, $01, $01, $01
	sAttackRate	$12, $12, $13, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $08, $00, $00
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$04, $04, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $16, $80, $80
	sFinishVoice

	sNewVoice	08					; voice number $08
	sAlgorithm	$02
	sFeedback	$04
	sDetune		$00, $00, $01, $01
	sMultiple	$0A, $05, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$03, $12, $12, $11
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $13, $13, $00
	sDecay1Level	$01, $00, $01, $00
	sDecay2Rate	$03, $02, $02, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1E, $26, $18, $81
	sFinishVoice

	sNewVoice	09					; voice number $09
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

	sNewVoice	0A					; voice number $0A
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

	sNewVoice	0B					; voice number $0B
	sAlgorithm	$04
	sFeedback	$06
	sDetune		$03, $07, $04, $07
	sMultiple	$03, $0E, $01, $04
	sRateScale	$01, $01, $02, $00
	sAttackRate	$1B, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $07, $07, $08
	sDecay1Level	$0F, $0E, $0F, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$23, $29, $90, $97
	sFinishVoice

	sNewVoice	0C					; voice number $0C
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$07, $03, $04, $03
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	0D					; voice number $0D
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $07, $07, $03
	sMultiple	$08, $06, $04, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $10, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $04, $07, $07
	sDecay1Level	$02, $02, $02, $02
	sDecay2Rate	$03, $03, $09, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1E, $1E, $80, $80
	sFinishVoice

	sNewVoice	0E					; voice number $0E
	sAlgorithm	$04
	sFeedback	$1E
	sDetune		$00, $00, $00, $00
	sMultiple	$06, $0F, $04, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0B, $00, $0B
	sDecay1Level	$00, $0F, $00, $0F
	sDecay2Rate	$00, $05, $00, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$15, $02, $85, $8A
	sFinishVoice

	sNewVoice	0F					; voice number $0F
	sAlgorithm	$01
	sFeedback	$05
	sDetune		$03, $07, $07, $03
	sMultiple	$06, $01, $04, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$04, $05, $04, $1D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $1F, $0E, $1F
	sDecay1Level	$05, $00, $06, $00
	sDecay2Rate	$04, $03, $06, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$27, $2E, $27, $80
	sFinishVoice

	sNewVoice	10					; voice number $10
	sAlgorithm	$00
	sFeedback	$01
	sDetune		$00, $03, $07, $00
	sMultiple	$0A, $00, $00, $00
	sRateScale	$00, $01, $00, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0A, $0E, $0A
	sDecay1Level	$02, $02, $02, $02
	sDecay2Rate	$00, $04, $04, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $13, $2D, $80
	sFinishVoice

	sNewVoice	11					; voice number $11
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $01
	sRateScale	$02, $00, $01, $01
	sAttackRate	$0E, $14, $12, $0C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $0E, $08, $03
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1B, $80, $80, $9B
	sFinishVoice

	sNewVoice	12					; voice number $12
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay1Level	$01, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$17, $8C, $8D, $8C
	sFinishVoice

	sNewVoice	13					; voice number $13
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $05, $05, $03
	sMultiple	$01, $00, $02, $00
	sRateScale	$01, $01, $01, $01
	sAttackRate	$12, $12, $13, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $08, $00, $00
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$04, $04, $00, $00
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$1A, $16, $80, $80
	sFinishVoice

	sNewVoice	14					; voice number $14
	sAlgorithm	$00
	sFeedback	$03
	sDetune		$03, $03, $03, $03
	sMultiple	$07, $00, $00, $01
	sRateScale	$02, $00, $03, $02
	sAttackRate	$1E, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $04, $06, $01
	sDecay1Level	$0B, $03, $0B, $02
	sDecay2Rate	$08, $03, $0A, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$32, $14, $22, $80
	sFinishVoice

	sNewVoice	15					; voice number $15
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $02
	sRateScale	$02, $00, $00, $01
	sAttackRate	$0D, $07, $07, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $00, $00, $03
	sDecay1Level	$05, $00, $00, $02
	sDecay2Rate	$01, $02, $02, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $18, $22, $80
	sFinishVoice

	sNewVoice	16					; voice number $16
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $03, $03
	sDecay2Rate	$00, $00, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$16, $17, $80, $80
	sFinishVoice

	sNewVoice	17					; voice number $17
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$00, $00, $07, $07
	sTotalLevel	$23, $23, $80, $80
	sFinishVoice

	sNewVoice	18					; voice number $18
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $02, $00, $00
	sAttackRate	$14, $0C, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $02, $05, $05
	sDecay1Level	$01, $01, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1A, $80, $80, $80
	sFinishVoice

	sNewVoice	19					; voice number $19
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
	sTotalLevel	$19, $13, $37, $80
	sFinishVoice

	sNewVoice	1A					; voice number $1A
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

	sNewVoice	1B					; voice number $1B
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $03, $05, $04
	sMultiple	$02, $02, $06, $02
	sRateScale	$02, $00, $01, $01
	sAttackRate	$0D, $15, $0F, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$06, $07, $08, $04
	sDecay1Level	$01, $02, $01, $02
	sDecay2Rate	$02, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$19, $2A, $20, $80
	sFinishVoice

	sNewVoice	1C					; voice number $1C
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

	sNewVoice	1D					; voice number $1D
	sAlgorithm	$00
	sFeedback	$01
	sDetune		$00, $03, $07, $00
	sMultiple	$0A, $00, $00, $00
	sRateScale	$00, $01, $00, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0A, $0E, $0A
	sDecay1Level	$02, $02, $02, $02
	sDecay2Rate	$00, $04, $04, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$24, $13, $2D, $80
	sFinishVoice

	sNewVoice	1E					; voice number $1E
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
	sTotalLevel	$18, $27, $28, $80
	sFinishVoice

	sNewVoice	1F					; voice number $1F
	sAlgorithm	$06
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0E, $11, $00
	sDecay1Level	$0F, $01, $00, $00
	sDecay2Rate	$00, $07, $0A, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$18, $80, $80, $80
	sFinishVoice

	sNewVoice	20					; voice number $20
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $01, $05
	sMultiple	$03, $01, $09, $03
	sRateScale	$00, $00, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $0C, $02, $05
	sDecay1Level	$01, $00, $0F, $02
	sDecay2Rate	$04, $04, $04, $07
	sReleaseRate	$0F, $0F, $0F, $0F
	sTotalLevel	$1D, $1B, $36, $80
	sFinishVoice
	even
