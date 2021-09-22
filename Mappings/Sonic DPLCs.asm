; ---------------------------------------------------------------------------
; Dynamic Pattern Load Cues for Sonic
; ---------------------------------------------------------------------------
SonicDynPLC:		mirror_index *,,,SonPLC,\sonic_frames
		
SonPLC_frame_Blank:	dc.b 0
SonPLC_frame_Stand:	dc.b 4,	$20, 0,	$70, 3,	$20, $B, $20, $E
SonPLC_frame_Wait1:	dc.b 3,	$50, $11, $50, $17, $20, $1D
SonPLC_frame_Wait2:	dc.b 3,	$50, $20, $50, $17, $20, $1D
SonPLC_frame_Wait3:	dc.b 3,	$50, $20, $50, $17, $20, $26
SonPLC_frame_LookUp:	dc.b 3,	$80, $29, $20, $B, $20,	$E
SonPLC_frame_Walk11:	dc.b 4,	$70, $32, $50, $3A, $50, $40, $10, $46
SonPLC_frame_Walk12:	dc.b 2,	$70, $32, $B0, $48
SonPLC_frame_Walk13:	dc.b 2,	$50, $54, $80, $5A
SonPLC_frame_Walk14:	dc.b 4,	$50, $54, $50, $63, $50, $69, $10, $6F
SonPLC_frame_Walk15:	dc.b 2,	$50, $54, $B0, $71
SonPLC_frame_Walk16:	dc.b 3,	$70, $32, $30, $7D, $50, $81
SonPLC_frame_Walk21:	dc.b 5,	$50, $87, $50, $8D, $20, $93, $50, $96,	0, $9C
SonPLC_frame_Walk22:	dc.b 6,	$50, $87, $10, $9D, $30, $9F, $50, $A3,	$30, $A9, 0, $AD
SonPLC_frame_Walk23:	dc.b 4,	$50, $AE, $10, $B4, $70, $B6, $20, $BE
SonPLC_frame_Walk24:	dc.b 5,	$50, $C1, $30, $C7, $70, $CB, $20, $D3,	$10, $D6
SonPLC_frame_Walk25:	dc.b 4,	$50, $C1, $10, $D8, $70, $DA, $20, $E2
SonPLC_frame_Walk26:	dc.b 5,	$50, $87, $10, $9D, 0, $93, $70, $E5, $20, $ED
SonPLC_frame_Walk31:	dc.b 4,	$70, $F0, $50, $F8, $10, $FE, $51, 0
SonPLC_frame_Walk32:	dc.b 2,	$70, $F0, $B1, 6
SonPLC_frame_Walk33:	dc.b 2,	$51, $12, $81, $18
SonPLC_frame_Walk34:	dc.b 4,	$51, $12, $51, $21, $11, $27, $51, $29
SonPLC_frame_Walk35:	dc.b 2,	$51, $12, $B1, $2F
SonPLC_frame_Walk36:	dc.b 3,	$70, $F0, 1, 6,	$81, $3B
SonPLC_frame_Walk41:	dc.b 6,	$51, $44, $11, $4A, $11, $4C, $81, $4E,	1, $57,	1, $58
SonPLC_frame_Walk42:	dc.b 6,	$51, $44, $21, $59, $11, $5C, $11, $5E,	$81, $60, 1, $57
SonPLC_frame_Walk43:	dc.b 4,	$51, $69, $11, $6F, $81, $71, $11, $7A
SonPLC_frame_Walk44:	dc.b 5,	$51, $7C, $21, $82, $11, $85, $71, $87,	$21, $8F
SonPLC_frame_Walk45:	dc.b 4,	$51, $7C, $11, $92, $81, $94, $11, $9D
SonPLC_frame_Walk46:	dc.b 5,	$51, $44, $81, $9F, $11, $5E, $11, $A8,	1, $57
SonPLC_frame_Run11:	dc.b 2,	$51, $AA, $B1, $B0
SonPLC_frame_Run12:	dc.b 2,	$50, $54, $B1, $BC
SonPLC_frame_Run13:	dc.b 2,	$51, $AA, $B1, $C8
SonPLC_frame_Run14:	dc.b 2,	$50, $54, $B1, $D4
SonPLC_frame_Run21:	dc.b 4,	$51, $E0, $11, $E6, $B1, $E8, 1, $F4
SonPLC_frame_Run22:	dc.b 3,	$51, $F5, $11, $FB, $B1, $FD
SonPLC_frame_Run23:	dc.b 4,	$51, $E0, $12, 9, $B2, $B, 1, $F4
SonPLC_frame_Run24:	dc.b 3,	$51, $F5, $11, $FB, $B2, $17
SonPLC_frame_Run31:	dc.b 2,	$52, $23, $B2, $29
SonPLC_frame_Run32:	dc.b 2,	$51, $12, $B2, $35
SonPLC_frame_Run33:	dc.b 2,	$52, $23, $B2, $41
SonPLC_frame_Run34:	dc.b 2,	$51, $12, $B2, $4D
SonPLC_frame_Run41:	dc.b 4,	$52, $59, $12, $5F, $B2, $61, 2, $6D
SonPLC_frame_Run42:	dc.b 2,	$72, $6E, $B2, $76
SonPLC_frame_Run43:	dc.b 4,	$52, $59, $12, $82, $B2, $84, 2, $6D
SonPLC_frame_Run44:	dc.b 2,	$72, $6E, $B2, $90
SonPLC_frame_Roll1:	dc.b 1,	$F2, $9C
SonPLC_frame_Roll2:	dc.b 1,	$F2, $AC
SonPLC_frame_Roll3:	dc.b 1,	$F2, $BC
SonPLC_frame_Roll4:	dc.b 1,	$F2, $CC
SonPLC_frame_Roll5:	dc.b 1,	$F2, $DC
SonPLC_frame_Warp1:	dc.b 2,	$B2, $EC, $22, $F8
SonPLC_frame_Warp2:	dc.b 1,	$F2, $FB
SonPLC_frame_Warp3:	dc.b 2,	$B3, $B, $23, $17
SonPLC_frame_Warp4:	dc.b 1,	$F3, $1A
SonPLC_frame_Stop1:	dc.b 2,	$53, $2A, $B3, $30
SonPLC_frame_Stop2:	dc.b 4,	$53, $3C, $73, $42, $13, $4A, 3, $4C
SonPLC_frame_Duck:	dc.b 4,	$13, $4D, $73, $4F, $23, $57, 3, $5A
SonPLC_frame_Balance1:	dc.b 3,	$23, $5B, $23, $5E, $F3, $61
SonPLC_frame_Balance2:	dc.b 3,	$B3, $71, $73, $7D, 0, $71
SonPLC_frame_Float1:
SonPLC_frame_Float5:	dc.b 3,	$73, $85, $33, $8D, $23, $91
SonPLC_frame_Float2:	dc.b 1,	$83, $94
SonPLC_frame_Float3:
SonPLC_frame_Float6:	dc.b 3,	$73, $9D, 3, $A5, $33, $A6
SonPLC_frame_Float4:	dc.b 3,	$73, $AA, $33, $B2, $23, $B6
SonPLC_frame_Spring:	dc.b 3,	$B3, $B9, $13, $C5, 3, $C7
SonPLC_frame_Hang1:	dc.b 4,	$B3, $C8, $33, $D4, 3, $D8, 3, $D9
SonPLC_frame_Hang2:	dc.b 4,	$B3, $DA, $33, $E6, 3, $EA, 3, $EB
SonPLC_frame_Leap1:	dc.b 5,	$83, $EC, $13, $F5, $53, $F7, $13, $FD,	3, $FF
SonPLC_frame_Leap2:	dc.b 5,	$84, 0,	$14, 9,	$53, $F7, $13, $FD, 3, $FF
SonPLC_frame_Push1:	dc.b 2,	$84, $B, $74, $14
SonPLC_frame_Push2:	dc.b 3,	$84, $1C, $24, $25, $14, $28
SonPLC_frame_Push3:	dc.b 2,	$84, $2A, $74, $33
SonPLC_frame_Push4:	dc.b 3,	$84, $1C, $24, $3B, $14, $3E
SonPLC_frame_Surf:	dc.b 2,	$54, $40, $B4, $46
SonPLC_frame_BubStand:	dc.b 3,	$84, $52, $34, $5B, 4, $5F
SonPLC_frame_Burnt:	dc.b 3,	$74, $60, $14, $68, $B4, $6A
SonPLC_frame_Drown:	dc.b 5,	$74, $76, $14, $7E, $54, $80, $34, $86,	4, $8A
SonPLC_frame_Death:	dc.b 5,	$74, $8B, $14, $7E, $54, $93, $34, $86,	4, $8A
SonPLC_frame_Shrink1:	dc.b 2,	$24, $99, $F4, $9C
SonPLC_frame_Shrink2:	dc.b 3,	$24, $AC, $B4, $AF, $24, $BB
SonPLC_frame_Shrink3:	dc.b 1,	$B4, $BE
SonPLC_frame_Shrink4:	dc.b 1,	$54, $CA
SonPLC_frame_Shrink5:	dc.b 1,	$14, $D0
SonPLC_frame_Injury:	dc.b 3,	$B4, $D2, $14, $DE, $34, $E0
SonPLC_frame_GetAir:	dc.b 3,	$54, $E4, $B4, $EA, $10, $6D
SonPLC_frame_WaterSlide:dc.b 2, $F4, $F6, $25, 6
		even
