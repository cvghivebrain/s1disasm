; ---------------------------------------------------------------------------
; Sprite mappings - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------
		index *
		ptr byte_A7CD
		ptr M_PSB_PSB
		ptr M_PSB_Limiter
		ptr M_PSB_TM
		
M_PSB_PSB:	spritemap		; "PRESS START BUTTON"
byte_A7CD:	piece	0, 0, 4x1, $F0
		piece	$20, 0, 1x1, $F3
		piece	$30, 0, 1x1, $F3
		piece	$38, 0, 4x1, $F4
		piece	$60, 0, 3x1, $F8
		piece	$78, 0, 3x1, $FB
		endsprite
		
M_PSB_Limiter:	spritemap		; sprite line limiter
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		endsprite
		
M_PSB_TM:	spritemap		; "TM"
		piece	-8, -4, 2x1, 0
		endsprite
		even
