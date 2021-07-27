; ---------------------------------------------------------------------------
; Sprite mappings - points that	appear when you	destroy	something
; ---------------------------------------------------------------------------
		index *
		ptr byte_94BC
		ptr byte_94C2
		ptr byte_94C8
		ptr byte_94CE
		ptr byte_94D4
		ptr byte_94DA
		ptr byte_94E5
		
byte_94BC:	spritemap		; 100 points
		piece	-8, -4, 2x1, 0
		endsprite
		
byte_94C2:	spritemap		; 200 points
		piece	-8, -4, 2x1, 2
		endsprite
		
byte_94C8:	spritemap		; 500 points
		piece	-8, -4, 2x1, 4
		endsprite
		
byte_94CE:	spritemap		; 1000 points
		piece	-8, -4, 3x1, 6
		endsprite
		
byte_94D4:	spritemap		; 10 points
		piece	-4, -4, 1x1, 6
		endsprite
		
byte_94DA:	spritemap		; 10,000 points
		piece	-$C, -4, 3x1, 6
		piece	1, -4, 2x1, 7
		endsprite
		
byte_94E5:	spritemap		; 100,000 points
		piece	-$C, -4, 3x1, 6
		piece	6, -4, 2x1, 7
		endsprite
		even
