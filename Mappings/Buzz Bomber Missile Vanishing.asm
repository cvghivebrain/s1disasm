; ---------------------------------------------------------------------------
; Sprite mappings - buzz bomber missile vanishing
; ---------------------------------------------------------------------------
Map_MisDissolve:
		index *
		ptr byte_8EAE
		ptr byte_8EB4
		ptr byte_8EBA
		ptr byte_8EC0
		
byte_8EAE:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
byte_8EB4:	spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		
byte_8EBA:	spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		
byte_8EC0:	spritemap
		piece	-$C, -$C, 3x3, $1B
		endsprite
		even
