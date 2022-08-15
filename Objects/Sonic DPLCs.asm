; ---------------------------------------------------------------------------
; Dynamic Pattern Load Cues for Sonic
; ---------------------------------------------------------------------------

dplcheader:	macro
		dc.b (.end-*-1)/2
		endm

SonicDynPLC:	sonic_sprites dplc				; index is a macro duplicated from "Sonic [Mappings].asm"
		
dplc_Blank:
		dplcheader
	.end:

dplc_Stand:
		dplcheader
		dc.w $2000, $7003, $200B, $200E
	.end:

dplc_Wait1:
		dplcheader
		dc.w $5011, $5017, $201D
	.end:

dplc_Wait2:
		dplcheader
		dc.w $5020, $5017, $201D
	.end:

dplc_Wait3:
		dplcheader
		dc.w $5020, $5017, $2026
	.end:

dplc_LookUp:
		dplcheader
		dc.w $8029, $200B, $200E
	.end:

dplc_Walk11:
		dplcheader
		dc.w $7032, $503A, $5040, $1046
	.end:

dplc_Walk12:
		dplcheader
		dc.w $7032, $B048
	.end:

dplc_Walk13:
		dplcheader
		dc.w $5054, $805A
	.end:

dplc_Walk14:
		dplcheader
		dc.w $5054, $5063, $5069, $106F
	.end:

dplc_Walk15:
		dplcheader
		dc.w $5054, $B071
	.end:

dplc_Walk16:
		dplcheader
		dc.w $7032, $307D, $5081
	.end:

dplc_Walk21:
		dplcheader
		dc.w $5087, $508D, $2093, $5096, $009C
	.end:

dplc_Walk22:
		dplcheader
		dc.w $5087, $109D, $309F, $50A3, $30A9, $00AD
	.end:

dplc_Walk23:
		dplcheader
		dc.w $50AE, $10B4, $70B6, $20BE
	.end:

dplc_Walk24:
		dplcheader
		dc.w $50C1, $30C7, $70CB, $20D3, $10D6
	.end:

dplc_Walk25:
		dplcheader
		dc.w $50C1, $10D8, $70DA, $20E2
	.end:

dplc_Walk26:
		dplcheader
		dc.w $5087, $109D, $0093, $70E5, $20ED
	.end:

dplc_Walk31:
		dplcheader
		dc.w $70F0, $50F8, $10FE, $5100
	.end:

dplc_Walk32:
		dplcheader
		dc.w $70F0, $B106
	.end:

dplc_Walk33:
		dplcheader
		dc.w $5112, $8118
	.end:

dplc_Walk34:
		dplcheader
		dc.w $5112, $5121, $1127, $5129
	.end:

dplc_Walk35:
		dplcheader
		dc.w $5112, $B12F
	.end:

dplc_Walk36:
		dplcheader
		dc.w $70F0, $0106, $813B
	.end:

dplc_Walk41:
		dplcheader
		dc.w $5144, $114A, $114C, $814E, $0157, $0158
	.end:

dplc_Walk42:
		dplcheader
		dc.w $5144, $2159, $115C, $115E, $8160, $0157
	.end:

dplc_Walk43:
		dplcheader
		dc.w $5169, $116F, $8171, $117A
	.end:

dplc_Walk44:
		dplcheader
		dc.w $517C, $2182, $1185, $7187, $218F
	.end:

dplc_Walk45:
		dplcheader
		dc.w $517C, $1192, $8194, $119D
	.end:

dplc_Walk46:
		dplcheader
		dc.w $5144, $819F, $115E, $11A8, $0157
	.end:

dplc_Run11:
		dplcheader
		dc.w $51AA, $B1B0
	.end:

dplc_Run12:
		dplcheader
		dc.w $5054, $B1BC
	.end:

dplc_Run13:
		dplcheader
		dc.w $51AA, $B1C8
	.end:

dplc_Run14:
		dplcheader
		dc.w $5054, $B1D4
	.end:

dplc_Run21:
		dplcheader
		dc.w $51E0, $11E6, $B1E8, $01F4
	.end:

dplc_Run22:
		dplcheader
		dc.w $51F5, $11FB, $B1FD
	.end:

dplc_Run23:
		dplcheader
		dc.w $51E0, $1209, $B20B, $01F4
	.end:

dplc_Run24:
		dplcheader
		dc.w $51F5, $11FB, $B217
	.end:

dplc_Run31:
		dplcheader
		dc.w $5223, $B229
	.end:

dplc_Run32:
		dplcheader
		dc.w $5112, $B235
	.end:

dplc_Run33:
		dplcheader
		dc.w $5223, $B241
	.end:

dplc_Run34:
		dplcheader
		dc.w $5112, $B24D
	.end:

dplc_Run41:
		dplcheader
		dc.w $5259, $125F, $B261, $026D
	.end:

dplc_Run42:
		dplcheader
		dc.w $726E, $B276
	.end:

dplc_Run43:
		dplcheader
		dc.w $5259, $1282, $B284, $026D
	.end:

dplc_Run44:
		dplcheader
		dc.w $726E, $B290
	.end:

dplc_Roll1:
		dplcheader
		dc.w $F29C
	.end:

dplc_Roll2:
		dplcheader
		dc.w $F2AC
	.end:

dplc_Roll3:
		dplcheader
		dc.w $F2BC
	.end:

dplc_Roll4:
		dplcheader
		dc.w $F2CC
	.end:

dplc_Roll5:
		dplcheader
		dc.w $F2DC
	.end:

dplc_Warp1:
		dplcheader
		dc.w $B2EC, $22F8
	.end:

dplc_Warp2:
		dplcheader
		dc.w $F2FB
	.end:

dplc_Warp3:
		dplcheader
		dc.w $B30B, $2317
	.end:

dplc_Warp4:
		dplcheader
		dc.w $F31A
	.end:

dplc_Stop1:
		dplcheader
		dc.w $532A, $B330
	.end:

dplc_Stop2:
		dplcheader
		dc.w $533C, $7342, $134A, $034C
	.end:

dplc_Duck:
		dplcheader
		dc.w $134D, $734F, $2357, $035A
	.end:

dplc_Balance1:
		dplcheader
		dc.w $235B, $235E, $F361
	.end:

dplc_Balance2:
		dplcheader
		dc.w $B371, $737D, $0071
	.end:

dplc_Float1:
dplc_Float5:
		dplcheader
		dc.w $7385, $338D, $2391
	.end:

dplc_Float2:
		dplcheader
		dc.w $8394
	.end:

dplc_Float3:
dplc_Float6:
		dplcheader
		dc.w $739D, $03A5, $33A6
	.end:

dplc_Float4:
		dplcheader
		dc.w $73AA, $33B2, $23B6
	.end:

dplc_Spring:
		dplcheader
		dc.w $B3B9, $13C5, $03C7
	.end:

dplc_Hang1:
		dplcheader
		dc.w $B3C8, $33D4, $03D8, $03D9
	.end:

dplc_Hang2:
		dplcheader
		dc.w $B3DA, $33E6, $03EA, $03EB
	.end:

dplc_Leap1:
		dplcheader
		dc.w $83EC, $13F5, $53F7, $13FD, $03FF
	.end:

dplc_Leap2:
		dplcheader
		dc.w $8400, $1409, $53F7, $13FD, $03FF
	.end:

dplc_Push1:
		dplcheader
		dc.w $840B, $7414
	.end:

dplc_Push2:
		dplcheader
		dc.w $841C, $2425, $1428
	.end:

dplc_Push3:
		dplcheader
		dc.w $842A, $7433
	.end:

dplc_Push4:
		dplcheader
		dc.w $841C, $243B, $143E
	.end:

dplc_Surf:
		dplcheader
		dc.w $5440, $B446
	.end:

dplc_BubStand:
		dplcheader
		dc.w $8452, $345B, $045F
	.end:

dplc_Burnt:
		dplcheader
		dc.w $7460, $1468, $B46A
	.end:

dplc_Drown:
		dplcheader
		dc.w $7476, $147E, $5480, $3486, $048A
	.end:

dplc_Death:
		dplcheader
		dc.w $748B, $147E, $5493, $3486, $048A
	.end:

dplc_Shrink1:
		dplcheader
		dc.w $2499, $F49C
	.end:

dplc_Shrink2:
		dplcheader
		dc.w $24AC, $B4AF, $24BB
	.end:

dplc_Shrink3:
		dplcheader
		dc.w $B4BE
	.end:

dplc_Shrink4:
		dplcheader
		dc.w $54CA
	.end:

dplc_Shrink5:
		dplcheader
		dc.w $14D0
	.end:

dplc_Injury:
		dplcheader
		dc.w $B4D2, $14DE, $34E0
	.end:

dplc_GetAir:
		dplcheader
		dc.w $54E4, $B4EA, $106D
	.end:

dplc_WaterSlide:
		dplcheader
		dc.w $F4F6, $2506
	.end:

		even
