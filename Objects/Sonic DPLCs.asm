; ---------------------------------------------------------------------------
; Dynamic Pattern Load Cues for Sonic
; ---------------------------------------------------------------------------

SonicDynPLC:		mirror_index *,,,SonPLC,\sonic_frames
		
SonPLC_frame_Blank:
		dc.b (@end-SonPLC_frame_Blank-1)/2
	@end:

SonPLC_frame_Stand:
		dc.b (@end-SonPLC_frame_Stand-1)/2
		dc.w $2000, $7003, $200B, $200E
	@end:

SonPLC_frame_Wait1:
		dc.b (@end-SonPLC_frame_Wait1-1)/2
		dc.w $5011, $5017, $201D
	@end:

SonPLC_frame_Wait2:
		dc.b (@end-SonPLC_frame_Wait2-1)/2
		dc.w $5020, $5017, $201D
	@end:

SonPLC_frame_Wait3:
		dc.b (@end-SonPLC_frame_Wait3-1)/2
		dc.w $5020, $5017, $2026
	@end:

SonPLC_frame_LookUp:
		dc.b (@end-SonPLC_frame_LookUp-1)/2
		dc.w $8029, $200B, $200E
	@end:

SonPLC_frame_Walk11:
		dc.b (@end-SonPLC_frame_Walk11-1)/2
		dc.w $7032, $503A, $5040, $1046
	@end:

SonPLC_frame_Walk12:
		dc.b (@end-SonPLC_frame_Walk12-1)/2
		dc.w $7032, $B048
	@end:

SonPLC_frame_Walk13:
		dc.b (@end-SonPLC_frame_Walk13-1)/2
		dc.w $5054, $805A
	@end:

SonPLC_frame_Walk14:
		dc.b (@end-SonPLC_frame_Walk14-1)/2
		dc.w $5054, $5063, $5069, $106F
	@end:

SonPLC_frame_Walk15:
		dc.b (@end-SonPLC_frame_Walk15-1)/2
		dc.w $5054, $B071
	@end:

SonPLC_frame_Walk16:
		dc.b (@end-SonPLC_frame_Walk16-1)/2
		dc.w $7032, $307D, $5081
	@end:

SonPLC_frame_Walk21:
		dc.b (@end-SonPLC_frame_Walk21-1)/2
		dc.w $5087, $508D, $2093, $5096, $009C
	@end:

SonPLC_frame_Walk22:
		dc.b (@end-SonPLC_frame_Walk22-1)/2
		dc.w $5087, $109D, $309F, $50A3, $30A9, $00AD
	@end:

SonPLC_frame_Walk23:
		dc.b (@end-SonPLC_frame_Walk23-1)/2
		dc.w $50AE, $10B4, $70B6, $20BE
	@end:

SonPLC_frame_Walk24:
		dc.b (@end-SonPLC_frame_Walk24-1)/2
		dc.w $50C1, $30C7, $70CB, $20D3, $10D6
	@end:

SonPLC_frame_Walk25:
		dc.b (@end-SonPLC_frame_Walk25-1)/2
		dc.w $50C1, $10D8, $70DA, $20E2
	@end:

SonPLC_frame_Walk26:
		dc.b (@end-SonPLC_frame_Walk26-1)/2
		dc.w $5087, $109D, $0093, $70E5, $20ED
	@end:

SonPLC_frame_Walk31:
		dc.b (@end-SonPLC_frame_Walk31-1)/2
		dc.w $70F0, $50F8, $10FE, $5100
	@end:

SonPLC_frame_Walk32:
		dc.b (@end-SonPLC_frame_Walk32-1)/2
		dc.w $70F0, $B106
	@end:

SonPLC_frame_Walk33:
		dc.b (@end-SonPLC_frame_Walk33-1)/2
		dc.w $5112, $8118
	@end:

SonPLC_frame_Walk34:
		dc.b (@end-SonPLC_frame_Walk34-1)/2
		dc.w $5112, $5121, $1127, $5129
	@end:

SonPLC_frame_Walk35:
		dc.b (@end-SonPLC_frame_Walk35-1)/2
		dc.w $5112, $B12F
	@end:

SonPLC_frame_Walk36:
		dc.b (@end-SonPLC_frame_Walk36-1)/2
		dc.w $70F0, $0106, $813B
	@end:

SonPLC_frame_Walk41:
		dc.b (@end-SonPLC_frame_Walk41-1)/2
		dc.w $5144, $114A, $114C, $814E, $0157, $0158
	@end:

SonPLC_frame_Walk42:
		dc.b (@end-SonPLC_frame_Walk42-1)/2
		dc.w $5144, $2159, $115C, $115E, $8160, $0157
	@end:

SonPLC_frame_Walk43:
		dc.b (@end-SonPLC_frame_Walk43-1)/2
		dc.w $5169, $116F, $8171, $117A
	@end:

SonPLC_frame_Walk44:
		dc.b (@end-SonPLC_frame_Walk44-1)/2
		dc.w $517C, $2182, $1185, $7187, $218F
	@end:

SonPLC_frame_Walk45:
		dc.b (@end-SonPLC_frame_Walk45-1)/2
		dc.w $517C, $1192, $8194, $119D
	@end:

SonPLC_frame_Walk46:
		dc.b (@end-SonPLC_frame_Walk46-1)/2
		dc.w $5144, $819F, $115E, $11A8, $0157
	@end:

SonPLC_frame_Run11:
		dc.b (@end-SonPLC_frame_Run11-1)/2
		dc.w $51AA, $B1B0
	@end:

SonPLC_frame_Run12:
		dc.b (@end-SonPLC_frame_Run12-1)/2
		dc.w $5054, $B1BC
	@end:

SonPLC_frame_Run13:
		dc.b (@end-SonPLC_frame_Run13-1)/2
		dc.w $51AA, $B1C8
	@end:

SonPLC_frame_Run14:
		dc.b (@end-SonPLC_frame_Run14-1)/2
		dc.w $5054, $B1D4
	@end:

SonPLC_frame_Run21:
		dc.b (@end-SonPLC_frame_Run21-1)/2
		dc.w $51E0, $11E6, $B1E8, $01F4
	@end:

SonPLC_frame_Run22:
		dc.b (@end-SonPLC_frame_Run22-1)/2
		dc.w $51F5, $11FB, $B1FD
	@end:

SonPLC_frame_Run23:
		dc.b (@end-SonPLC_frame_Run23-1)/2
		dc.w $51E0, $1209, $B20B, $01F4
	@end:

SonPLC_frame_Run24:
		dc.b (@end-SonPLC_frame_Run24-1)/2
		dc.w $51F5, $11FB, $B217
	@end:

SonPLC_frame_Run31:
		dc.b (@end-SonPLC_frame_Run31-1)/2
		dc.w $5223, $B229
	@end:

SonPLC_frame_Run32:
		dc.b (@end-SonPLC_frame_Run32-1)/2
		dc.w $5112, $B235
	@end:

SonPLC_frame_Run33:
		dc.b (@end-SonPLC_frame_Run33-1)/2
		dc.w $5223, $B241
	@end:

SonPLC_frame_Run34:
		dc.b (@end-SonPLC_frame_Run34-1)/2
		dc.w $5112, $B24D
	@end:

SonPLC_frame_Run41:
		dc.b (@end-SonPLC_frame_Run41-1)/2
		dc.w $5259, $125F, $B261, $026D
	@end:

SonPLC_frame_Run42:
		dc.b (@end-SonPLC_frame_Run42-1)/2
		dc.w $726E, $B276
	@end:

SonPLC_frame_Run43:
		dc.b (@end-SonPLC_frame_Run43-1)/2
		dc.w $5259, $1282, $B284, $026D
	@end:

SonPLC_frame_Run44:
		dc.b (@end-SonPLC_frame_Run44-1)/2
		dc.w $726E, $B290
	@end:

SonPLC_frame_Roll1:
		dc.b (@end-SonPLC_frame_Roll1-1)/2
		dc.w $F29C
	@end:

SonPLC_frame_Roll2:
		dc.b (@end-SonPLC_frame_Roll2-1)/2
		dc.w $F2AC
	@end:

SonPLC_frame_Roll3:
		dc.b (@end-SonPLC_frame_Roll3-1)/2
		dc.w $F2BC
	@end:

SonPLC_frame_Roll4:
		dc.b (@end-SonPLC_frame_Roll4-1)/2
		dc.w $F2CC
	@end:

SonPLC_frame_Roll5:
		dc.b (@end-SonPLC_frame_Roll5-1)/2
		dc.w $F2DC
	@end:

SonPLC_frame_Warp1:
		dc.b (@end-SonPLC_frame_Warp1-1)/2
		dc.w $B2EC, $22F8
	@end:

SonPLC_frame_Warp2:
		dc.b (@end-SonPLC_frame_Warp2-1)/2
		dc.w $F2FB
	@end:

SonPLC_frame_Warp3:
		dc.b (@end-SonPLC_frame_Warp3-1)/2
		dc.w $B30B, $2317
	@end:

SonPLC_frame_Warp4:
		dc.b (@end-SonPLC_frame_Warp4-1)/2
		dc.w $F31A
	@end:

SonPLC_frame_Stop1:
		dc.b (@end-SonPLC_frame_Stop1-1)/2
		dc.w $532A, $B330
	@end:

SonPLC_frame_Stop2:
		dc.b (@end-SonPLC_frame_Stop2-1)/2
		dc.w $533C, $7342, $134A, $034C
	@end:

SonPLC_frame_Duck:
		dc.b (@end-SonPLC_frame_Duck-1)/2
		dc.w $134D, $734F, $2357, $035A
	@end:

SonPLC_frame_Balance1:
		dc.b (@end-SonPLC_frame_Balance1-1)/2
		dc.w $235B, $235E, $F361
	@end:

SonPLC_frame_Balance2:
		dc.b (@end-SonPLC_frame_Balance2-1)/2
		dc.w $B371, $737D, $0071
	@end:

SonPLC_frame_Float1:
SonPLC_frame_Float5:
		dc.b (@end-SonPLC_frame_Float5-1)/2
		dc.w $7385, $338D, $2391
	@end:

SonPLC_frame_Float2:
		dc.b (@end-SonPLC_frame_Float2-1)/2
		dc.w $8394
	@end:

SonPLC_frame_Float3:
SonPLC_frame_Float6:
		dc.b (@end-SonPLC_frame_Float6-1)/2
		dc.w $739D, $03A5, $33A6
	@end:

SonPLC_frame_Float4:
		dc.b (@end-SonPLC_frame_Float4-1)/2
		dc.w $73AA, $33B2, $23B6
	@end:

SonPLC_frame_Spring:
		dc.b (@end-SonPLC_frame_Spring-1)/2
		dc.w $B3B9, $13C5, $03C7
	@end:

SonPLC_frame_Hang1:
		dc.b (@end-SonPLC_frame_Hang1-1)/2
		dc.w $B3C8, $33D4, $03D8, $03D9
	@end:

SonPLC_frame_Hang2:
		dc.b (@end-SonPLC_frame_Hang2-1)/2
		dc.w $B3DA, $33E6, $03EA, $03EB
	@end:

SonPLC_frame_Leap1:
		dc.b (@end-SonPLC_frame_Leap1-1)/2
		dc.w $83EC, $13F5, $53F7, $13FD, $03FF
	@end:

SonPLC_frame_Leap2:
		dc.b (@end-SonPLC_frame_Leap2-1)/2
		dc.w $8400, $1409, $53F7, $13FD, $03FF
	@end:

SonPLC_frame_Push1:
		dc.b (@end-SonPLC_frame_Push1-1)/2
		dc.w $840B, $7414
	@end:

SonPLC_frame_Push2:
		dc.b (@end-SonPLC_frame_Push2-1)/2
		dc.w $841C, $2425, $1428
	@end:

SonPLC_frame_Push3:
		dc.b (@end-SonPLC_frame_Push3-1)/2
		dc.w $842A, $7433
	@end:

SonPLC_frame_Push4:
		dc.b (@end-SonPLC_frame_Push4-1)/2
		dc.w $841C, $243B, $143E
	@end:

SonPLC_frame_Surf:
		dc.b (@end-SonPLC_frame_Surf-1)/2
		dc.w $5440, $B446
	@end:

SonPLC_frame_BubStand:
		dc.b (@end-SonPLC_frame_BubStand-1)/2
		dc.w $8452, $345B, $045F
	@end:

SonPLC_frame_Burnt:
		dc.b (@end-SonPLC_frame_Burnt-1)/2
		dc.w $7460, $1468, $B46A
	@end:

SonPLC_frame_Drown:
		dc.b (@end-SonPLC_frame_Drown-1)/2
		dc.w $7476, $147E, $5480, $3486, $048A
	@end:

SonPLC_frame_Death:
		dc.b (@end-SonPLC_frame_Death-1)/2
		dc.w $748B, $147E, $5493, $3486, $048A
	@end:

SonPLC_frame_Shrink1:
		dc.b (@end-SonPLC_frame_Shrink1-1)/2
		dc.w $2499, $F49C
	@end:

SonPLC_frame_Shrink2:
		dc.b (@end-SonPLC_frame_Shrink2-1)/2
		dc.w $24AC, $B4AF, $24BB
	@end:

SonPLC_frame_Shrink3:
		dc.b (@end-SonPLC_frame_Shrink3-1)/2
		dc.w $B4BE
	@end:

SonPLC_frame_Shrink4:
		dc.b (@end-SonPLC_frame_Shrink4-1)/2
		dc.w $54CA
	@end:

SonPLC_frame_Shrink5:
		dc.b (@end-SonPLC_frame_Shrink5-1)/2
		dc.w $14D0
	@end:

SonPLC_frame_Injury:
		dc.b (@end-SonPLC_frame_Injury-1)/2
		dc.w $B4D2, $14DE, $34E0
	@end:

SonPLC_frame_GetAir:
		dc.b (@end-SonPLC_frame_GetAir-1)/2
		dc.w $54E4, $B4EA, $106D
	@end:

SonPLC_frame_WaterSlide:
		dc.b (@end-SonPLC_frame_WaterSlide-1)/2
		dc.w $F4F6, $2506
	@end:

		even
