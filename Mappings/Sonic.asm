; ---------------------------------------------------------------------------
; Sprite mappings - Sonic
; ---------------------------------------------------------------------------
Map_Sonic:	index *,,
		ptr frame_Blank,sonic_frames
		ptr frame_Stand,sonic_frames
		ptr frame_Wait1,sonic_frames
		ptr frame_Wait2,sonic_frames
		ptr frame_Wait3,sonic_frames
		ptr frame_LookUp,sonic_frames
		ptr frame_Walk11,sonic_frames
		ptr frame_Walk12,sonic_frames
		ptr frame_Walk13,sonic_frames
		ptr frame_Walk14,sonic_frames
		ptr frame_Walk15,sonic_frames
		ptr frame_Walk16,sonic_frames
		ptr frame_Walk21,sonic_frames
		ptr frame_Walk22,sonic_frames
		ptr frame_Walk23,sonic_frames
		ptr frame_Walk24,sonic_frames
		ptr frame_Walk25,sonic_frames
		ptr frame_Walk26,sonic_frames
		ptr frame_Walk31,sonic_frames
		ptr frame_Walk32,sonic_frames
		ptr frame_Walk33,sonic_frames
		ptr frame_Walk34,sonic_frames
		ptr frame_Walk35,sonic_frames
		ptr frame_Walk36,sonic_frames
		ptr frame_Walk41,sonic_frames
		ptr frame_Walk42,sonic_frames
		ptr frame_Walk43,sonic_frames
		ptr frame_Walk44,sonic_frames
		ptr frame_Walk45,sonic_frames
		ptr frame_Walk46,sonic_frames
		ptr frame_Run11,sonic_frames
		ptr frame_Run12,sonic_frames
		ptr frame_Run13,sonic_frames
		ptr frame_Run14,sonic_frames
		ptr frame_Run21,sonic_frames
		ptr frame_Run22,sonic_frames
		ptr frame_Run23,sonic_frames
		ptr frame_Run24,sonic_frames
		ptr frame_Run31,sonic_frames
		ptr frame_Run32,sonic_frames
		ptr frame_Run33,sonic_frames
		ptr frame_Run34,sonic_frames
		ptr frame_Run41,sonic_frames
		ptr frame_Run42,sonic_frames
		ptr frame_Run43,sonic_frames
		ptr frame_Run44,sonic_frames
		ptr frame_Roll1,sonic_frames
		ptr frame_Roll2,sonic_frames
		ptr frame_Roll3,sonic_frames
		ptr frame_Roll4,sonic_frames
		ptr frame_Roll5,sonic_frames
		ptr frame_Warp1,sonic_frames
		ptr frame_Warp2,sonic_frames
		ptr frame_Warp3,sonic_frames
		ptr frame_Warp4,sonic_frames
		ptr frame_Stop1,sonic_frames
		ptr frame_Stop2,sonic_frames
		ptr frame_Duck,sonic_frames
		ptr frame_Balance1,sonic_frames
		ptr frame_Balance2,sonic_frames
		ptr frame_Float1,sonic_frames
		ptr frame_Float2,sonic_frames
		ptr frame_Float3,sonic_frames
		ptr frame_Float4,sonic_frames
		ptr frame_Spring,sonic_frames
		ptr frame_Hang1,sonic_frames
		ptr frame_Hang2,sonic_frames
		ptr frame_Leap1,sonic_frames
		ptr frame_Leap2,sonic_frames
		ptr frame_Push1,sonic_frames
		ptr frame_Push2,sonic_frames
		ptr frame_Push3,sonic_frames
		ptr frame_Push4,sonic_frames
		ptr frame_Surf,sonic_frames
		ptr frame_BubStand,sonic_frames
		ptr frame_Burnt,sonic_frames
		ptr frame_Drown,sonic_frames
		ptr frame_Death,sonic_frames
		ptr frame_Shrink1,sonic_frames
		ptr frame_Shrink2,sonic_frames
		ptr frame_Shrink3,sonic_frames
		ptr frame_Shrink4,sonic_frames
		ptr frame_Shrink5,sonic_frames
		ptr frame_Float5,sonic_frames
		ptr frame_Float6,sonic_frames
		ptr frame_Injury,sonic_frames
		ptr frame_GetAir,sonic_frames
		ptr frame_WaterSlide,sonic_frames

frame_Blank:	spritemap
		endsprite

frame_Stand:	spritemap
		piece	-$10, -$14, 3x1, 0
		piece	-$10, -$C, 4x2, 3
		piece	-$10, 4, 3x1, $B
		piece	-8, $C, 3x1, $E
		endsprite

frame_Wait1:	spritemap
		piece	-$10, -$14, 3x2, 0
		piece	-$10, -4, 3x2, 6
		piece	-8, $C, 3x1, $C
		endsprite

frame_Wait2:	spritemap
		piece	-$10, -$14, 3x2, 0
		piece	-$10, -4, 3x2, 6
		piece	-8, $C, 3x1, $C
		endsprite

frame_Wait3:	spritemap
		piece	-$10, -$14, 3x2, 0
		piece	-$10, -4, 3x2, 6
		piece	-8, $C, 3x1, $C
		endsprite

frame_LookUp:	spritemap
		piece	-$10, -$14, 3x3, 0
		piece	-$10, 4, 3x1, 9
		piece	-8, $C, 3x1, $C
		endsprite

frame_Walk11:	spritemap
		piece	-$14, -$15, 4x2, 0
		piece	-$14, -5, 3x2, 8
		piece	4, -5, 2x3, $E
		piece	-$14, $B, 2x1, $14
		endsprite

frame_Walk12:	spritemap
		piece	-$13, -$14, 4x2, 0
		piece	-$B, -4, 4x3, 8
		endsprite

frame_Walk13:	spritemap
		piece	-$D, -$13, 3x2, 0
		piece	-$D, -3, 3x3, 6
		endsprite

frame_Walk14:	spritemap
		piece	-$C, -$15, 3x2, 0
		piece	-$14, -5, 3x2, 6
		piece	4, -5, 2x3, $C
		piece	-$14, $B, 2x1, $12
		endsprite

frame_Walk15:	spritemap
		piece	-$D, -$14, 3x2, 0
		piece	-$15, -4, 4x3, 6
		endsprite

frame_Walk16:	spritemap
		piece	-$14, -$13, 4x2, 0
		piece	-$C, -3, 4x1, 8
		piece	-$C, 5, 3x2, $C
		endsprite

frame_Walk21:	spritemap
		piece	-$15, -$15, 3x2, 0
		piece	3, -$15, 2x3, 6
		piece	-$15, -5, 3x1, $C
		piece	-$D, 3, 3x2, $F
		piece	-5, $13, 1x1, $15
		endsprite

frame_Walk22:	spritemap
		piece	-$14, -$14, 3x2, 0
		piece	4, -$14, 1x2, 6
		piece	-$14, -4, 4x1, 8
		piece	-$C, 4, 3x2, $C
		piece	$C, -4, 2x2, $12
		piece	$14, -$C, 1x1, $16
		endsprite

frame_Walk23:	spritemap
		piece	-$13, -$13, 3x2, 0
		piece	5, -$13, 1x2, 6
		piece	-$B, -3, 4x2, 8
		piece	-3, $D, 3x1, $10
		endsprite

frame_Walk24:	spritemap
		piece	-$15, -$15, 3x2, 0
		piece	3, -$15, 2x2, 6
		piece	-$D, -5, 4x2, $A
		piece	-$D, $B, 3x1, $12
		piece	-5, $13, 2x1, $15
		endsprite

frame_Walk25:	spritemap
		piece	-$14, -$14, 3x2, 0
		piece	4, -$14, 1x2, 6
		piece	-$C, -4, 4x2, 8
		piece	-4, $C, 3x1, $10
		endsprite

frame_Walk26:	spritemap
		piece	-$13, -$13, 3x2, 0
		piece	5, -$13, 1x2, 6
		piece	-$13, -3, 1x1, 8
		piece	-$B, -3, 4x2, 9
		piece	-3, $D, 3x1, $11
		endsprite

frame_Walk31:	spritemap
		piece	-$15, -$C, 2x4, 0
		piece	-5, -$14, 3x2, 8
		piece	-5, -4, 2x1, $E
		piece	-5, 4, 3x2, $10
		endsprite

frame_Walk32:	spritemap
		piece	-$14, -$C, 2x4, 0
		piece	-4, -$14, 3x4, 8
		endsprite

frame_Walk33:	spritemap
		piece	-$13, -$C, 2x3, 0
		piece	-3, -$C, 3x3, 6
		endsprite

frame_Walk34:	spritemap
		piece	-$15, -$C, 2x3, 0
		piece	-5, -$14, 3x2, 6
		piece	-5, -4, 2x1, $C
		piece	-5, 4, 3x2, $E
		endsprite

frame_Walk35:	spritemap
		piece	-$14, -$C, 2x3, 0
		piece	-4, -$C, 3x4, 6
		endsprite

frame_Walk36:	spritemap
		piece	-$13, -$C, 2x4, 0
		piece	-3, -$14, 1x1, 8
		piece	-3, -$C, 3x3, 9
		endsprite

frame_Walk41:	spritemap
		piece	-$15, -3, 2x3, 0
		piece	-$D, -$13, 2x1, 6
		piece	-$15, -$B, 2x1, 8
		piece	-5, -$B, 3x3, $A
		piece	-5, $D, 1x1, $13
		piece	$13, -3, 1x1, $14
		endsprite

frame_Walk42:	spritemap
		piece	-$14, -4, 2x3, 0
		piece	-$C, -$1C, 3x1, 6
		piece	-4, -$14, 2x1, 9
		piece	-$14, -$C, 2x1, $B
		piece	-4, -$C, 3x3, $D
		piece	-4, $C, 1x1, $16
		endsprite

frame_Walk43:	spritemap
		piece	-$13, -5, 2x3, 0
		piece	-$13, -$D, 2x1, 6
		piece	-3, -$15, 3x3, 8
		piece	-3, 3, 2x1, $11
		endsprite

frame_Walk44:	spritemap
		piece	-$15, -3, 2x3, 0
		piece	-$D, -$13, 3x1, 6
		piece	-$15, -$B, 2x1, 9
		piece	-5, -$B, 4x2, $B
		piece	-5, 5, 3x1, $13
		endsprite

frame_Walk45:	spritemap
		piece	-$14, -4, 2x3, 0
		piece	-$14, -$C, 2x1, 6
		piece	-4, -$14, 3x3, 8
		piece	-4, 4, 2x1, $11
		endsprite

frame_Walk46:	spritemap
		piece	-$13, -5, 2x3, 0
		piece	-3, -$15, 3x3, 6
		piece	-$13, -$D, 2x1, $F
		piece	-3, 3, 2x1, $11
		piece	-3, $B, 1x1, $13
		endsprite

frame_Run11:	spritemap
		piece	-$C, -$12, 3x2, 0
		piece	-$14, -2, 4x3, 6
		endsprite

frame_Run12:	spritemap
		piece	-$C, -$12, 3x2, 0
		piece	-$14, -2, 4x3, 6
		endsprite

frame_Run13:	spritemap
		piece	-$C, -$12, 3x2, 0
		piece	-$14, -2, 4x3, 6
		endsprite

frame_Run14:	spritemap
		piece	-$C, -$12, 3x2, 0
		piece	-$14, -2, 4x3, 6
		endsprite

frame_Run21:	spritemap
		piece	-$12, -$12, 3x2, 0
		piece	6, -$12, 1x2, 6
		piece	-$A, -2, 4x3, 8
		piece	-$12, -2, 1x1, $14
		endsprite

frame_Run22:	spritemap
		piece	-$12, -$12, 3x2, 0
		piece	6, -$12, 1x2, 6
		piece	-$A, -2, 4x3, 8
		endsprite

frame_Run23:	spritemap
		piece	-$12, -$12, 3x2, 0
		piece	6, -$12, 1x2, 6
		piece	-$A, -2, 4x3, 8
		piece	-$12, -2, 1x1, $14
		endsprite

frame_Run24:	spritemap
		piece	-$12, -$12, 3x2, 0
		piece	6, -$12, 1x2, 6
		piece	-$A, -2, 4x3, 8
		endsprite

frame_Run31:	spritemap
		piece	-$12, -$C, 2x3, 0
		piece	-2, -$C, 3x4, 6
		endsprite

frame_Run32:	spritemap
		piece	-$12, -$C, 2x3, 0
		piece	-2, -$C, 3x4, 6
		endsprite

frame_Run33:	spritemap
		piece	-$12, -$C, 2x3, 0
		piece	-2, -$C, 3x4, 6
		endsprite

frame_Run34:	spritemap
		piece	-$12, -$C, 2x3, 0
		piece	-2, -$C, 3x4, 6
		endsprite

frame_Run41:	spritemap
		piece	-$12, -6, 2x3, 0
		piece	-$12, -$E, 2x1, 6
		piece	-2, -$16, 3x4, 8
		piece	-2, $A, 1x1, $14
		endsprite

frame_Run42:	spritemap
		piece	-$12, -$E, 2x4, 0
		piece	-2, -$16, 3x4, 8
		endsprite

frame_Run43:	spritemap
		piece	-$12, -6, 2x3, 0
		piece	-$12, -$E, 2x1, 6
		piece	-2, -$16, 3x4, 8
		piece	-2, $A, 1x1, $14
		endsprite

frame_Run44:	spritemap
		piece	-$12, -$E, 2x4, 0
		piece	-2, -$16, 3x4, 8
		endsprite

frame_Roll1:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Roll2:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Roll3:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Roll4:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Roll5:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Warp1:	spritemap
		piece	-$14, -$C, 4x3, 0
		piece	$C, -$C, 1x3, $C
		endsprite

frame_Warp2:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Warp3:	spritemap
		piece	-$C, -$14, 3x4, 0
		piece	-$C, $C, 3x1, $C
		endsprite

frame_Warp4:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite

frame_Stop1:	spritemap
		piece	-$10, -$13, 3x2, 0
		piece	-$10, -3, 4x3, 6
		endsprite

frame_Stop2:	spritemap
		piece	-$10, -$13, 3x2, 0
		piece	-$10, -3, 4x2, 6
		piece	0, $D, 2x1, $E
		piece	-$18, 5, 1x1, $10
		endsprite

frame_Duck:	spritemap
		piece	-4, -$C, 2x1, 0
		piece	-$C, -4, 4x2, 2
		piece	-$C, $C, 3x1, $A
		piece	-$14, 4, 1x1, $D
		endsprite

frame_Balance1:	spritemap
		piece	-$18, -$14, 3x1, 0, xflip
		piece	0, -$C, 1x3, 3, xflip
		piece	-$20, -$C, 4x4, 6, xflip
		endsprite

frame_Balance2:	spritemap
		piece	-$18, -$14, 4x3, 0, xflip
		piece	-$20, 4, 4x2, $C, xflip
		piece	0, $C, 1x1, $14, xflip, yflip
		endsprite

frame_Float1:	spritemap
		piece	-4, -$C, 4x2, 0
		piece	-$14, -4, 2x2, 8
		piece	-4, 4, 3x1, $C
		endsprite

frame_Float2:	spritemap
		piece	-$18, -$C, 3x3, 0
		piece	0, -$C, 3x3, 0, xflip
		endsprite

frame_Float3:	spritemap
		piece	-$1C, -$C, 4x2, 0
		piece	4, -4, 1x1, 8
		piece	-$14, 4, 4x1, 9
		endsprite

frame_Float4:	spritemap
		piece	-4, -$C, 4x2, 0
		piece	-$14, -4, 2x2, 8
		piece	-4, 4, 3x1, $C
		endsprite

frame_Spring:	spritemap
		piece	-$10, -$18, 3x4, 0
		piece	-8, 8, 2x1, $C
		piece	-8, $10, 1x1, $E
		endsprite

frame_Hang1:	spritemap
		piece	-$18, -8, 4x3, 0
		piece	8, 0, 2x2, $C
		piece	8, -8, 1x1, $10
		piece	-8, -$10, 1x1, $11
		endsprite

frame_Hang2:	spritemap
		piece	-$18, -8, 4x3, 0
		piece	8, 0, 2x2, $C
		piece	8, -8, 1x1, $10
		piece	-8, -$10, 1x1, $11
		endsprite

frame_Leap1:	spritemap
		piece	-$C, -$18, 3x3, 0
		piece	$C, -$10, 1x2, 9
		piece	-$C, 0, 3x2, $B
		piece	-$C, $10, 2x1, $11
		piece	-$14, 0, 1x1, $13
		endsprite

frame_Leap2:	spritemap
		piece	-$C, -$18, 3x3, 0
		piece	$C, -$18, 1x2, 9
		piece	-$C, 0, 3x2, $B
		piece	-$C, $10, 2x1, $11
		piece	-$14, 0, 1x1, $13
		endsprite

frame_Push1:	spritemap
		piece	-$D, -$13, 3x3, 0
		piece	-$15, 5, 4x2, 9
		endsprite

frame_Push2:	spritemap
		piece	-$D, -$14, 3x3, 0
		piece	-$D, 4, 3x1, 9
		piece	-$D, $C, 2x1, $C
		endsprite

frame_Push3:	spritemap
		piece	-$D, -$13, 3x3, 0
		piece	-$15, 5, 4x2, 9
		endsprite

frame_Push4:	spritemap
		piece	-$D, -$14, 3x3, 0
		piece	-$D, 4, 3x1, 9
		piece	-$D, $C, 2x1, $C
		endsprite

frame_Surf:	spritemap
		piece	-$10, -$14, 3x2, 0
		piece	-$10, -4, 4x3, 6
		endsprite

frame_BubStand:	spritemap
		piece	-$10, -$14, 3x3, 0
		piece	-8, 4, 2x2, 9
		piece	-8, -$1C, 1x1, $D
		endsprite

frame_Burnt:	spritemap
		piece	-$14, -$18, 4x2, 0
		piece	$C, -$18, 1x2, 8
		piece	-$C, -8, 3x4, $A
		endsprite

frame_Drown:	spritemap
		piece	-$14, -$18, 4x2, 0
		piece	$C, -$18, 1x2, 8
		piece	-$C, -8, 3x2, $A
		piece	-$C, 8, 4x1, $10
		piece	-$C, $10, 1x1, $14
		endsprite

frame_Death:	spritemap
		piece	-$14, -$18, 4x2, 0
		piece	$C, -$18, 1x2, 8
		piece	-$C, -8, 3x2, $A
		piece	-$C, 8, 4x1, $10
		piece	-$C, $10, 1x1, $14
		endsprite

frame_Shrink1:	spritemap
		piece	-$10, -$14, 3x1, 0
		piece	-$10, -$C, 4x4, 3
		endsprite

frame_Shrink2:	spritemap
		piece	-$10, -$14, 3x1, 0
		piece	-$10, -$C, 4x3, 3
		piece	-8, $C, 3x1, $F
		endsprite

frame_Shrink3:	spritemap
		piece	-$C, -$10, 3x4, 0
		endsprite

frame_Shrink4:	spritemap
		piece	-8, -$C, 2x3, 0
		endsprite

frame_Shrink5:	spritemap
		piece	-4, -8, 1x2, 0
		endsprite

frame_Float5:	spritemap
		piece	-$1C, -$C, 4x2, 0, xflip
		piece	4, -4, 2x2, 8, xflip
		piece	-$14, 4, 3x1, $C, xflip
		endsprite

frame_Float6:	spritemap
		piece	-4, -$C, 4x2, 0, xflip
		piece	-$C, -4, 1x1, 8, xflip
		piece	-$C, 4, 4x1, 9, xflip
		endsprite

frame_Injury:	spritemap
		piece	-$14, -$10, 4x3, 0
		piece	$C, -8, 1x2, $C
		piece	-$C, 8, 4x1, $E
		endsprite

frame_GetAir:	spritemap
		piece	-$C, -$15, 3x2, 0
		piece	-$14, -5, 4x3, 6
		piece	$C, 3, 1x2, $12
		endsprite

frame_WaterSlide:	spritemap
		piece	-$14, -$10, 4x4, 0
		piece	$C, -8, 1x3, $10
		endsprite
