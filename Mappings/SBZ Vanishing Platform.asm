; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms	(SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @whole
		ptr @half
		ptr @quarter
		ptr @gone
		
@whole:		spritemap
		piece	-$10, -8, 4x4, 0
		endsprite
		
@half:		spritemap
		piece	-8, -8, 2x4, $10
		endsprite
		
@quarter:	spritemap
		piece	-4, -8, 1x4, $18
		endsprite
		
@gone:		spritemap
		endsprite
		even
