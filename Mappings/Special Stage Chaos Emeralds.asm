; ---------------------------------------------------------------------------
; Sprite mappings - special stage chaos	emeralds
; ---------------------------------------------------------------------------
Map_SS_Chaos1:	index *
		ptr byte_1B96C
		ptr byte_1B97E
		
Map_SS_Chaos2:	index *
		ptr byte_1B972
		ptr byte_1B97E
		
Map_SS_Chaos3:	index *
		ptr byte_1B978
		ptr byte_1B97E
		
byte_1B96C:	spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
byte_1B972:	spritemap
		piece	-8, -8, 2x2, 4
		endsprite
		
byte_1B978:	spritemap
		piece	-8, -8, 2x2, 8
		endsprite
		
byte_1B97E:	spritemap
		piece	-8, -8, 2x2, $C
		endsprite
		even
