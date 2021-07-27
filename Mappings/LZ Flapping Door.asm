; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @closed
		ptr @halfway
		ptr @open
		
@closed:	spritemap
		piece	-8, -$20, 2x4, 0
		piece	-8, 0, 2x4, 0, yflip
		endsprite
		
@halfway:	spritemap
		piece	-5, -$26, 4x4, 8
		piece	-5, 6, 4x4, 8, yflip
		endsprite
		
@open:		spritemap
		piece	0, -$28, 4x2, $18
		piece	0, $18, 4x2, $18, yflip
		endsprite
		even
