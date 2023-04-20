; ---------------------------------------------------------------------------
; Dynamic Pattern Load Cues for Sonic
; ---------------------------------------------------------------------------

dplcheader:	macro
		dc.b (.end-*-1)/2
		endm
		
dplc:		macro gfx
		ifarg \2
		dc.w ((Art_Sonic_\gfx\-Art_Sonic)/sizeof_cell)+((\2-1)<<12)
		else
		dc.w ((Art_Sonic_\gfx\-Art_Sonic)/sizeof_cell)+(((sizeof_Art_Sonic_\gfx\/sizeof_cell)-1)<<12)
		endc
		endm
		
dplcgfx:	macro gfx
	Art_Sonic_\gfx\:	incbin	"Graphics Sonic/\gfx\.bin"
	sizeof_Art_Sonic_\gfx\:	equ	filesize("Graphics Sonic/\gfx\.bin")
		endm

SonicDynPLC:	sonic_sprites dplc				; index is a macro duplicated from "Sonic [Mappings].asm"
		
dplc_Blank:
		dplcheader
	.end:

dplc_Stand:
		dplcheader
		dplc	Stand_0
		dplc	Stand_1
		dplc	Stand_2
		dplc	Stand_3
		;dc.w $2000, $7003, $200B, $200E
	.end:

dplc_Wait1:
		dplcheader
		dplc	Wait_0
		dplc	Wait_1
		dplc	Wait_2
		;dc.w $5011, $5017, $201D
	.end:

dplc_Wait2:
		dplcheader
		dplc	Wait_3
		dplc	Wait_1
		dplc	Wait_2
		;dc.w $5020, $5017, $201D
	.end:

dplc_Wait3:
		dplcheader
		dplc	Wait_3
		dplc	Wait_1
		dplc	Wait_4
		;dc.w $5020, $5017, $2026
	.end:

dplc_LookUp:
		dplcheader
		dplc	LookUp_0
		dplc	Stand_2
		dplc	Stand_3
		;dc.w $8029, $200B, $200E
	.end:

dplc_Walk11:
		dplcheader
		dplc	Walk1_0
		dplc	Walk1_1
		dplc	Walk1_2
		dplc	Walk1_3
		;dc.w $7032, $503A, $5040, $1046
	.end:

dplc_Walk12:
		dplcheader
		dplc	Walk1_0
		dplc	Walk1_4
		;dc.w $7032, $B048
	.end:

dplc_Walk13:
		dplcheader
		dplc	Walk1_5
		dplc	Walk1_6
		;dc.w $5054, $805A
	.end:

dplc_Walk14:
		dplcheader
		dplc	Walk1_5
		dplc	Walk1_7
		dplc	Walk1_8
		dplc	Walk1_9
		;dc.w $5054, $5063, $5069, $106F
	.end:

dplc_Walk15:
		dplcheader
		dplc	Walk1_5
		dplc	Walk1_10
		;dc.w $5054, $B071
	.end:

dplc_Walk16:
		dplcheader
		dplc	Walk1_0
		dplc	Walk1_11
		dplc	Walk1_12
		;dc.w $7032, $307D, $5081
	.end:

dplc_Walk21:
		dplcheader
		dplc	Walk2_0
		dplc	Walk2_1
		dplc	Walk2_2
		dplc	Walk2_3
		dplc	Walk2_4
		;dc.w $5087, $508D, $2093, $5096, $009C
	.end:

dplc_Walk22:
		dplcheader
		dplc	Walk2_0
		dplc	Walk2_5
		dplc	Walk2_6
		dplc	Walk2_7
		dplc	Walk2_8
		dplc	Walk2_9
		;dc.w $5087, $109D, $309F, $50A3, $30A9, $00AD
	.end:

dplc_Walk23:
		dplcheader
		dplc	Walk2_10
		dplc	Walk2_11
		dplc	Walk2_12
		dplc	Walk2_13
		;dc.w $50AE, $10B4, $70B6, $20BE
	.end:

dplc_Walk24:
		dplcheader
		dplc	Walk2_14
		dplc	Walk2_15
		dplc	Walk2_16
		dplc	Walk2_17
		dplc	Walk2_18
		;dc.w $50C1, $30C7, $70CB, $20D3, $10D6
	.end:

dplc_Walk25:
		dplcheader
		dplc	Walk2_14
		dplc	Walk2_19
		dplc	Walk2_20
		dplc	Walk2_21
		;dc.w $50C1, $10D8, $70DA, $20E2
	.end:

dplc_Walk26:
		dplcheader
		dplc	Walk2_0
		dplc	Walk2_5
		dplc	Walk2_2,1
		dplc	Walk2_22
		dplc	Walk2_23
		;dc.w $5087, $109D, $0093, $70E5, $20ED
	.end:

dplc_Walk31:
		dplcheader
		dplc	Walk3_0
		dplc	Walk3_1
		dplc	Walk3_2
		dplc	Walk3_3
		;dc.w $70F0, $50F8, $10FE, $5100
	.end:

dplc_Walk32:
		dplcheader
		dplc	Walk3_0
		dplc	Walk3_4
		;dc.w $70F0, $B106
	.end:

dplc_Walk33:
		dplcheader
		dplc	Walk3_5
		dplc	Walk3_6
		;dc.w $5112, $8118
	.end:

dplc_Walk34:
		dplcheader
		dplc	Walk3_5
		dplc	Walk3_7
		dplc	Walk3_8
		dplc	Walk3_9
		;dc.w $5112, $5121, $1127, $5129
	.end:

dplc_Walk35:
		dplcheader
		dplc	Walk3_5
		dplc	Walk3_10
		;dc.w $5112, $B12F
	.end:

dplc_Walk36:
		dplcheader
		dplc	Walk3_0
		dplc	Walk3_4,1
		dplc	Walk3_11
		;dc.w $70F0, $0106, $813B
	.end:

dplc_Walk41:
		dplcheader
		dplc	Walk4_0
		dplc	Walk4_1
		dplc	Walk4_2
		dplc	Walk4_3
		dplc	Walk4_4
		dplc	Walk4_5
		;dc.w $5144, $114A, $114C, $814E, $0157, $0158
	.end:

dplc_Walk42:
		dplcheader
		dplc	Walk4_0
		dplc	Walk4_6
		dplc	Walk4_7
		dplc	Walk4_8
		dplc	Walk4_9
		dplc	Walk4_4
		;dc.w $5144, $2159, $115C, $115E, $8160, $0157
	.end:

dplc_Walk43:
		dplcheader
		dplc	Walk4_10
		dplc	Walk4_11
		dplc	Walk4_12
		dplc	Walk4_13
		;dc.w $5169, $116F, $8171, $117A
	.end:

dplc_Walk44:
		dplcheader
		dplc	Walk4_14
		dplc	Walk4_15
		dplc	Walk4_16
		dplc	Walk4_17
		dplc	Walk4_18
		;dc.w $517C, $2182, $1185, $7187, $218F
	.end:

dplc_Walk45:
		dplcheader
		dplc	Walk4_14
		dplc	Walk4_19
		dplc	Walk4_20
		dplc	Walk4_21
		;dc.w $517C, $1192, $8194, $119D
	.end:

dplc_Walk46:
		dplcheader
		dplc	Walk4_0
		dplc	Walk4_22
		dplc	Walk4_8
		dplc	Walk4_23
		dplc	Walk4_4
		;dc.w $5144, $819F, $115E, $11A8, $0157
	.end:

dplc_Run11:
		dplcheader
		dplc	Run1_0
		dplc	Run1_1
		;dc.w $51AA, $B1B0
	.end:

dplc_Run12:
		dplcheader
		dplc	Walk1_5
		dplc	Run1_2
		;dc.w $5054, $B1BC
	.end:

dplc_Run13:
		dplcheader
		dplc	Run1_0
		dplc	Run1_3
		;dc.w $51AA, $B1C8
	.end:

dplc_Run14:
		dplcheader
		dplc	Walk1_5
		dplc	Run1_4
		;dc.w $5054, $B1D4
	.end:

dplc_Run21:
		dplcheader
		dplc	Run2_0
		dplc	Run2_1
		dplc	Run2_2
		dplc	Run2_3
		;dc.w $51E0, $11E6, $B1E8, $01F4
	.end:

dplc_Run22:
		dplcheader
		dplc	Run2_4
		dplc	Run2_5
		dplc	Run2_6
		;dc.w $51F5, $11FB, $B1FD
	.end:

dplc_Run23:
		dplcheader
		dplc	Run2_0
		dplc	Run2_7
		dplc	Run2_8
		dplc	Run2_3
		;dc.w $51E0, $1209, $B20B, $01F4
	.end:

dplc_Run24:
		dplcheader
		dplc	Run2_4
		dplc	Run2_5
		dplc	Run2_9
		;dc.w $51F5, $11FB, $B217
	.end:

dplc_Run31:
		dplcheader
		dplc	Run3_0
		dplc	Run3_1
		;dc.w $5223, $B229
	.end:

dplc_Run32:
		dplcheader
		dplc	Walk3_5
		dplc	Run3_2
		;dc.w $5112, $B235
	.end:

dplc_Run33:
		dplcheader
		dplc	Run3_0
		dplc	Run3_3
		;dc.w $5223, $B241
	.end:

dplc_Run34:
		dplcheader
		dplc	Walk3_5
		dplc	Run3_4
		;dc.w $5112, $B24D
	.end:

dplc_Run41:
		dplcheader
		dplc	Run4_0
		dplc	Run4_1
		dplc	Run4_2
		dplc	Run4_3
		;dc.w $5259, $125F, $B261, $026D
	.end:

dplc_Run42:
		dplcheader
		dplc	Run4_4
		dplc	Run4_5
		;dc.w $726E, $B276
	.end:

dplc_Run43:
		dplcheader
		dplc	Run4_0
		dplc	Run4_6
		dplc	Run4_7
		dplc	Run4_3
		;dc.w $5259, $1282, $B284, $026D
	.end:

dplc_Run44:
		dplcheader
		dplc	Run4_4
		dplc	Run4_8
		;dc.w $726E, $B290
	.end:

dplc_Roll1:
		dplcheader
		dplc	Roll_0
		;dc.w $F29C
	.end:

dplc_Roll2:
		dplcheader
		dplc	Roll_1
		;dc.w $F2AC
	.end:

dplc_Roll3:
		dplcheader
		dplc	Roll_2
		;dc.w $F2BC
	.end:

dplc_Roll4:
		dplcheader
		dplc	Roll_3
		;dc.w $F2CC
	.end:

dplc_Roll5:
		dplcheader
		dplc	Roll_4
		;dc.w $F2DC
	.end:

dplc_Warp1:
		dplcheader
		dplc	Warp_0
		dplc	Warp_1
		;dc.w $B2EC, $22F8
	.end:

dplc_Warp2:
		dplcheader
		dplc	Warp_2
		;dc.w $F2FB
	.end:

dplc_Warp3:
		dplcheader
		dplc	Warp_3
		dplc	Warp_4
		;dc.w $B30B, $2317
	.end:

dplc_Warp4:
		dplcheader
		dplc	Warp_5
		;dc.w $F31A
	.end:

dplc_Stop1:
		dplcheader
		dplc	Stop_0
		dplc	Stop_1
		;dc.w $532A, $B330
	.end:

dplc_Stop2:
		dplcheader
		dplc	Stop_2
		dplc	Stop_3
		dplc	Stop_4
		dplc	Stop_5
		;dc.w $533C, $7342, $134A, $034C
	.end:

dplc_Duck:
		dplcheader
		dplc	Duck_0
		dplc	Duck_1
		dplc	Duck_2
		dplc	Duck_3
		;dc.w $134D, $734F, $2357, $035A
	.end:

dplc_Balance1:
		dplcheader
		dplc	Balance_0
		dplc	Balance_1
		dplc	Balance_2
		;dc.w $235B, $235E, $F361
	.end:

dplc_Balance2:
		dplcheader
		dplc	Balance_3
		dplc	Balance_4
		dplc	Walk1_10,1
		;dc.w $B371, $737D, $0071
	.end:

dplc_Float1:
dplc_Float5:
		dplcheader
		dplc	Float_0
		dplc	Float_1
		dplc	Float_2
		;dc.w $7385, $338D, $2391
	.end:

dplc_Float2:
		dplcheader
		dplc	Float_3
		;dc.w $8394
	.end:

dplc_Float3:
dplc_Float6:
		dplcheader
		dplc	Float_4
		dplc	Float_5
		dplc	Float_6
		;dc.w $739D, $03A5, $33A6
	.end:

dplc_Float4:
		dplcheader
		dplc	Float_7
		dplc	Float_8
		dplc	Float_9
		;dc.w $73AA, $33B2, $23B6
	.end:

dplc_Spring:
		dplcheader
		dplc	Spring_0
		dplc	Spring_1
		dplc	Spring_2
		;dc.w $B3B9, $13C5, $03C7
	.end:

dplc_Hang1:
		dplcheader
		dplc	Hang_0
		dplc	Hang_1
		dplc	Hang_2
		dplc	Hang_3
		;dc.w $B3C8, $33D4, $03D8, $03D9
	.end:

dplc_Hang2:
		dplcheader
		dplc	Hang_4
		dplc	Hang_5
		dplc	Hang_6
		dplc	Hang_7
		;dc.w $B3DA, $33E6, $03EA, $03EB
	.end:

dplc_Leap1:
		dplcheader
		dplc	Leap_0
		dplc	Leap_1
		dplc	Leap_2
		dplc	Leap_3
		dplc	Leap_4
		;dc.w $83EC, $13F5, $53F7, $13FD, $03FF
	.end:

dplc_Leap2:
		dplcheader
		dplc	Leap_5
		dplc	Leap_6
		dplc	Leap_2
		dplc	Leap_3
		dplc	Leap_4
		;dc.w $8400, $1409, $53F7, $13FD, $03FF
	.end:

dplc_Push1:
		dplcheader
		dplc	Push_0
		dplc	Push_1
		;dc.w $840B, $7414
	.end:

dplc_Push2:
		dplcheader
		dplc	Push_2
		dplc	Push_3
		dplc	Push_4
		;dc.w $841C, $2425, $1428
	.end:

dplc_Push3:
		dplcheader
		dplc	Push_5
		dplc	Push_6
		;dc.w $842A, $7433
	.end:

dplc_Push4:
		dplcheader
		dplc	Push_2
		dplc	Push_7
		dplc	Push_8
		;dc.w $841C, $243B, $143E
	.end:

dplc_Surf:
		dplcheader
		dplc	Surf_0
		dplc	Surf_1
		;dc.w $5440, $B446
	.end:

dplc_BubStand:
		dplcheader
		dplc	BubStand_0
		dplc	BubStand_1
		dplc	BubStand_2
		;dc.w $8452, $345B, $045F
	.end:

dplc_Burnt:
		dplcheader
		dplc	Burnt_0
		dplc	Burnt_1
		dplc	Burnt_2
		;dc.w $7460, $1468, $B46A
	.end:

dplc_Drown:
		dplcheader
		dplc	Drown_0
		dplc	Drown_1
		dplc	Drown_2
		dplc	Drown_3
		dplc	Drown_4
		;dc.w $7476, $147E, $5480, $3486, $048A
	.end:

dplc_Death:
		dplcheader
		dplc	Death_0
		dplc	Drown_1
		dplc	Death_1
		dplc	Drown_3
		dplc	Drown_4
		;dc.w $748B, $147E, $5493, $3486, $048A
	.end:

dplc_Shrink1:
		dplcheader
		dplc	Shrink_0
		dplc	Shrink_1
		;dc.w $2499, $F49C
	.end:

dplc_Shrink2:
		dplcheader
		dplc	Shrink_2
		dplc	Shrink_3
		dplc	Shrink_4
		;dc.w $24AC, $B4AF, $24BB
	.end:

dplc_Shrink3:
		dplcheader
		dplc	Shrink_5
		;dc.w $B4BE
	.end:

dplc_Shrink4:
		dplcheader
		dplc	Shrink_6
		;dc.w $54CA
	.end:

dplc_Shrink5:
		dplcheader
		dplc	Shrink_7
		;dc.w $14D0
	.end:

dplc_Injury:
		dplcheader
		dplc	Injury_0
		dplc	Injury_1
		dplc	Injury_2
		;dc.w $B4D2, $14DE, $34E0
	.end:

dplc_GetAir:
		dplcheader
		dplc	GetAir_0
		dplc	GetAir_1
		Art_Sonic_GetAir_2: equ Art_Sonic_Walk1_8+(4*sizeof_cell)
		dplc	GetAir_2,2
		;dc.w $54E4, $B4EA, $106D
	.end:

dplc_WaterSlide:
		dplcheader
		dplc	WaterSlide_0
		dplc	WaterSlide_1
		;dc.w $F4F6, $2506
	.end:

		even

dplcgfxblock:	macro name,start,finish
		i: = \start
		rept \finish-\start+1
		dplcgfx \name\_\#i
		i: = i+1
		endr
		endm

Art_Sonic:
		dplcgfxblock Stand,0,3
		dplcgfxblock Wait,0,4
		dplcgfxblock LookUp,0,0
		dplcgfxblock Walk1,0,12
		dplcgfxblock Walk2,0,23
		dplcgfxblock Walk3,0,11
		dplcgfxblock Walk4,0,23
		dplcgfxblock Run1,0,4
		dplcgfxblock Run2,0,9
		dplcgfxblock Run3,0,4
		dplcgfxblock Run4,0,8
		dplcgfxblock Roll,0,4
		dplcgfxblock Warp,0,5
		dplcgfxblock Stop,0,5
		dplcgfxblock Duck,0,3
		dplcgfxblock Balance,0,4
		dplcgfxblock Float,0,9
		dplcgfxblock Spring,0,2
		dplcgfxblock Hang,0,7
		dplcgfxblock Leap,0,6
		dplcgfxblock Push,0,8
		dplcgfxblock Surf,0,1
		dplcgfxblock BubStand,0,2
		dplcgfxblock Burnt,0,2
		dplcgfxblock Drown,0,4
		dplcgfxblock Death,0,1
		dplcgfxblock Shrink,0,7
		dplcgfxblock Injury,0,2
		dplcgfxblock GetAir,0,1
		dplcgfxblock WaterSlide,0,1
		