; ---------------------------------------------------------------------------
; Sprite mappings - giant ring
; ---------------------------------------------------------------------------
		index *
		ptr byte_9FDA
		ptr byte_A00D
		ptr byte_A036
		ptr byte_A04B
		
byte_9FDA:	spritemap		; ring front
		piece	-$18, -$20, 3x1, 0
		piece	0, -$20, 3x1, 3
		piece	-$20, -$18, 4x1, 6
		piece	0, -$18, 4x1, $A
		piece	-$20, -$10, 2x4, $E
		piece	$10, -$10, 2x4, $16
		piece	-$20, $10, 4x1, $1E
		piece	0, $10, 4x1, $22
		piece	-$18, $18, 3x1, $26
		piece	0, $18, 3x1, $29
		endsprite
		
byte_A00D:	spritemap		; ring angle
		piece	-$10, -$20, 4x1, $2C
		piece	-$18, -$18, 3x1, $30
		piece	0, -$18, 3x2, $33
		piece	-$18, -$10, 2x4, $39
		piece	8, -8, 2x2, $41
		piece	0, 8, 3x2, $45
		piece	-$18, $10, 3x1, $4B
		piece	-$10, $18, 4x1, $4E
		endsprite
		
byte_A036:	spritemap		; ring perpendicular
		piece	-$C, -$20, 2x4, $52
		piece	4, -$20, 1x4, $52, xflip
		piece	-$C, 0, 2x4, $5A
		piece	4, 0, 1x4, $5A, xflip
		endsprite
		
byte_A04B:	spritemap		; ring angle
		piece	-$10, -$20, 4x1, $2C, xflip
		piece	0, -$18, 3x1, $30, xflip
		piece	-$18, -$18, 3x2, $33, xflip
		piece	8, -$10, 2x4, $39, xflip
		piece	-$18, -8, 2x2, $41, xflip
		piece	-$18, 8, 3x2, $45, xflip
		piece	0, $10, 3x1, $4B, xflip
		piece	-$10, $18, 4x1, $4E, xflip
		endsprite
		even
