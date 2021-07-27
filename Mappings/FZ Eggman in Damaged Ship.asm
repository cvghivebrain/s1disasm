; ---------------------------------------------------------------------------
; Sprite mappings - Eggman in broken eggmobile (FZ)
; ---------------------------------------------------------------------------
		index *
		ptr @damage1
		ptr @damage2
		
@damage1:	spritemap
		piece	-$C, -$1C, 3x1, $20
		piece	-$1C, -$14, 4x2, $23
		piece	4, -$14, 3x2, $2B
		piece	-$1C, -4, 2x2, $3A, pal2
		piece	4, -4, 4x3, $3E, pal2
		piece	4, $14, 2x1, $4A, pal2
		endsprite
		
@damage2:	spritemap
		piece	-$C, -$1C, 3x3, $31
		piece	-$1C, -$14, 2x2, $23
		piece	4, -$14, 3x2, $2B
		piece	-$1C, -4, 2x2, $3A, pal2
		piece	4, -4, 4x3, $3E, pal2
		piece	4, $14, 2x1, $4A, pal2
		endsprite
		even
