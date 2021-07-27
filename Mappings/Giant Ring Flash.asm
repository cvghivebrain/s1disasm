; ---------------------------------------------------------------------------
; Sprite mappings - flash effect when you collect the giant ring
; ---------------------------------------------------------------------------
		index *
		ptr byte_A084
		ptr byte_A08F
		ptr byte_A0A4
		ptr byte_A0B9
		ptr byte_A0CE
		ptr byte_A0E3
		ptr byte_A0F8
		ptr byte_A103
		
byte_A084:	spritemap
		piece	0, -$20, 4x4, 0, 0, 0, 0, 0
		piece	0, 0, 4x4, 0, yflip
		endsprite
		
byte_A08F:	spritemap
		piece	-$10, -$20, 4x4, $10, 0, 0, 0, 0
		piece	$10, -$20, 2x4, $20, 0, 0, 0, 0
		piece	-$10, 0, 4x4, $10, yflip
		piece	$10, 0, 2x4, $20, yflip
		endsprite
		
byte_A0A4:	spritemap
		piece	-$18, -$20, 4x4, $28, 0, 0, 0, 0
		piece	8, -$20, 3x4, $38, 0, 0, 0, 0
		piece	-$18, 0, 4x4, $28, yflip
		piece	8, 0, 3x4, $38, yflip
		endsprite
		
byte_A0B9:	spritemap
		piece	-$20, -$20, 4x4, $34, xflip
		piece	0, -$20, 4x4, $34, 0, 0, 0, 0
		piece	-$20, 0, 4x4, $34, xflip, yflip
		piece	0, 0, 4x4, $34, yflip
		endsprite
		
byte_A0CE:	spritemap
		piece	-$20, -$20, 3x4, $38, xflip
		piece	-8, -$20, 4x4, $28, xflip
		piece	-$20, 0, 3x4, $38, xflip, yflip
		piece	-8, 0, 4x4, $28, xflip, yflip
		endsprite
		
byte_A0E3:	spritemap
		piece	-$20, -$20, 2x4, $20, xflip
		piece	-$10, -$20, 4x4, $10, xflip
		piece	-$20, 0, 2x4, $20, xflip, yflip
		piece	-$10, 0, 4x4, $10, xflip, yflip
		endsprite
		
byte_A0F8:	spritemap
		piece	-$20, -$20, 4x4, 0, xflip
		piece	-$20, 0, 4x4, 0, xflip, yflip
		endsprite
		
byte_A103:	spritemap
		piece	-$20, -$20, 4x4, $44, 0, 0, 0, 0
		piece	0, -$20, 4x4, $44, xflip
		piece	-$20, 0, 4x4, $44, yflip
		piece	0, 0, 4x4, $44, xflip, yflip
		endsprite
		even
