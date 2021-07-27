; ---------------------------------------------------------------------------
; Sprite mappings - invisible solid blocks (visible in debug mode)
; ---------------------------------------------------------------------------
		index *
		ptr @solid
		ptr @unused1
		ptr @unused2
		
@solid:		spritemap
		piece	-$10, -$10, 2x2, $18
		piece	0, -$10, 2x2, $18
		piece	-$10, 0, 2x2, $18
		piece	0, 0, 2x2, $18
		endsprite
		
@unused1:	spritemap
		piece	-$40, -$20, 2x2, $18
		piece	$30, -$20, 2x2, $18
		piece	-$40, $10, 2x2, $18
		piece	$30, $10, 2x2, $18
		endsprite
		
@unused2:	spritemap
		piece	-$80, -$20, 2x2, $18
		piece	$70, -$20, 2x2, $18
		piece	-$80, $10, 2x2, $18
		piece	$70, $10, 2x2, $18
		endsprite
		even
