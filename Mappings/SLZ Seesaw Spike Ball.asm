; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the	seesaws	(SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @red
		ptr @silver
		
@red:		spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
@silver:	spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		even
