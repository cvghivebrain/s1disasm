; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------
		index *
		ptr byte_1B912
		ptr byte_1B918
		ptr byte_1B91E
		
byte_1B912:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
byte_1B918:	spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		
byte_1B91E:	spritemap
		endsprite
		even
