; ---------------------------------------------------------------------------
; Sprite mappings - special stage breakable glass blocks and red-white blocks
; ---------------------------------------------------------------------------
		index *
		ptr byte_1B928
		ptr byte_1B92E
		ptr byte_1B934
		ptr byte_1B93A
		
byte_1B928:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
byte_1B92E:	spritemap
		piece	-$C, -$C, 3x3, 0, xflip
		endsprite
		
byte_1B934:	spritemap
		piece	-$C, -$C, 3x3, 0, xflip, yflip
		endsprite
		
byte_1B93A:	spritemap
		piece	-$C, -$C, 3x3, 0, yflip
		endsprite
		even
