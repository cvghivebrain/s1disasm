; ---------------------------------------------------------------------------
; Sprite mappings - water splash (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @splash1
		ptr @splash2
		ptr @splash3
		
@splash1:	spritemap
		piece	-8, -$E, 2x1, $6D
		piece	-$10, -6, 4x1, $6F
		endsprite
		
@splash2:	spritemap
		piece	-8, -$1E, 1x1, $73
		piece	-$10, -$16, 4x3, $74
		endsprite
		
@splash3:	spritemap
		piece	-$10, -$1E, 4x4, $80
		endsprite
		even
