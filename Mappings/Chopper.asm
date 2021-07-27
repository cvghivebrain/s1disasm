; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr @mouthshut
		ptr @mouthopen
		
@mouthshut:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
@mouthopen:	spritemap
		piece	-$10, -$10, 4x4, $10
		endsprite
		even
