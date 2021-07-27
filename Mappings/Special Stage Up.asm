; ---------------------------------------------------------------------------
; Sprite mappings - special stage "UP" block
; ---------------------------------------------------------------------------
		index *
		ptr byte_1B944
		ptr byte_1B94A
		
byte_1B944:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
byte_1B94A:	spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		even
