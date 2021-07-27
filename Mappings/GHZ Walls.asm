; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr M_Edge_Shadow
		ptr M_Edge_Light
		ptr M_Edge_Dark
		
M_Edge_Shadow:	spritemap			; light with shadow
		piece	-8, -$20, 2x2, 4
		piece	-8, -$10, 2x2, 8
		piece	-8, 0, 2x2, 8
		piece	-8, $10, 2x2, 8
		endsprite
		
M_Edge_Light:	spritemap			; light with no shadow
		piece	-8, -$20, 2x2, 8
		piece	-8, -$10, 2x2, 8
		piece	-8, 0, 2x2, 8
		piece	-8, $10, 2x2, 8
		endsprite
		
M_Edge_Dark:	spritemap			; all shadow
		piece	-8, -$20, 2x2, 0
		piece	-8, -$10, 2x2, 0
		piece	-8, 0, 2x2, 0
		piece	-8, $10, 2x2, 0
		endsprite
		even
