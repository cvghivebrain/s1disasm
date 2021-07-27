; ---------------------------------------------------------------------------
; Sprite mappings - smashable walls (GHZ, SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @left
		ptr @middle
		ptr @right
		
@left:		spritemap
		piece	-$10, -$20, 2x2, 0
		piece	-$10, -$10, 2x2, 0
		piece	-$10, 0, 2x2, 0
		piece	-$10, $10, 2x2, 0
		piece	0, -$20, 2x2, 4
		piece	0, -$10, 2x2, 4
		piece	0, 0, 2x2, 4
		piece	0, $10, 2x2, 4
		endsprite
		
@middle:	spritemap
		piece	-$10, -$20, 2x2, 4
		piece	-$10, -$10, 2x2, 4
		piece	-$10, 0, 2x2, 4
		piece	-$10, $10, 2x2, 4
		piece	0, -$20, 2x2, 4
		piece	0, -$10, 2x2, 4
		piece	0, 0, 2x2, 4
		piece	0, $10, 2x2, 4
		endsprite
		
@right:		spritemap
		piece	-$10, -$20, 2x2, 4
		piece	-$10, -$10, 2x2, 4
		piece	-$10, 0, 2x2, 4
		piece	-$10, $10, 2x2, 4
		piece	0, -$20, 2x2, 8
		piece	0, -$10, 2x2, 8
		piece	0, 0, 2x2, 8
		piece	0, $10, 2x2, 8
		endsprite
		even
