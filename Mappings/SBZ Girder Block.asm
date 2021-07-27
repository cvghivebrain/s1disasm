; ---------------------------------------------------------------------------
; Sprite mappings - large girder block (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @girder
		
@girder:	spritemap
		piece	-$60, -$18, 4x3, 0
		piece	-$60, 0, 4x3, 0, yflip
		piece	-$40, -$18, 4x3, 6
		piece	-$40, 0, 4x3, 6, yflip
		piece	-$20, -$18, 4x3, 6
		piece	-$20, 0, 4x3, 6, yflip
		piece	0, -$18, 4x3, 6
		piece	0, 0, 4x3, 6, yflip
		piece	$20, -$18, 4x3, 6
		piece	$20, 0, 4x3, 6, yflip
		piece	$40, -$18, 4x3, 6
		piece	$40, 0, 4x3, 6, yflip
		endsprite
		even
