; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------
		index *
		ptr @Emerald1
		ptr @Emerald2
		ptr @Emerald3
		ptr @Emerald4
		ptr @Emerald5
		ptr @Emerald6
		ptr @Emerald7
		
@Emerald1:	spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
@Emerald2:	spritemap
		piece	-8, -8, 2x2, 4
		endsprite
		
@Emerald3:	spritemap
		piece	-8, -8, 2x2, $10, pal3
		endsprite
		
@Emerald4:	spritemap
		piece	-8, -8, 2x2, $18, pal2
		endsprite
		
@Emerald5:	spritemap
		piece	-8, -8, 2x2, $14, pal3
		endsprite
		
@Emerald6:	spritemap
		piece	-8, -8, 2x2, 8
		endsprite
		
@Emerald7:	spritemap
		piece	-8, -8, 2x2, $C
		endsprite
		even
