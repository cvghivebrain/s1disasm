; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds from	the special stage results screen
; ---------------------------------------------------------------------------
		index *
		ptr byte_CE02
		ptr byte_CE08
		ptr byte_CE0E
		ptr byte_CE14
		ptr byte_CE1A
		ptr byte_CE20
		ptr byte_CE26
		
byte_CE02:	spritemap
		piece -8, -8, 2x2, 4, pal2
		endsprite
		
byte_CE08:	spritemap
		piece -8, -8, 2x2, 0
		endsprite
		
byte_CE0E:	spritemap
		piece -8, -8, 2x2, 4, pal3
		endsprite
		
byte_CE14:	spritemap
		piece -8, -8, 2x2, 4, pal4
		endsprite
		
byte_CE1A:	spritemap
		piece -8, -8, 2x2, 8, pal2
		endsprite
		
byte_CE20:	spritemap
		piece -8, -8, 2x2, $C, pal2
		endsprite
		
byte_CE26:	spritemap			; Blank frame
		endsprite
		even
