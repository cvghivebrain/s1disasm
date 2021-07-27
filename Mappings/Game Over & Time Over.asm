; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER"	and "TIME OVER"
; ---------------------------------------------------------------------------
		index *
		ptr byte_CBAC
		ptr byte_CBB7
		ptr byte_CBC2
		ptr byte_CBCD
		
byte_CBAC:	spritemap			; GAME
		piece -$48, -8, 4x2, 0
		piece -$28, -8, 4x2, 8
		endsprite
		
byte_CBB7:	spritemap			; OVER
		piece 8, -8, 4x2, $14
		piece $28, -8, 4x2, $C
		endsprite
		
byte_CBC2:	spritemap			; TIME
		piece -$3C, -8, 3x2, $1C
		piece -$24, -8, 4x2, 8
		endsprite
		
byte_CBCD:	spritemap			; OVER
		piece $C, -8, 4x2, $14
		piece $2C, -8, 4x2, $C
		endsprite
		even
