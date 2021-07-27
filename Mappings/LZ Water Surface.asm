; ---------------------------------------------------------------------------
; Sprite mappings - water surface (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @normal1
		ptr @normal2
		ptr @normal3
		ptr @paused1
		ptr @paused2
		ptr @paused3
		
@normal1:	spritemap
		piece	-$60, -3, 4x2, 0
		piece	-$20, -3, 4x2, 0
		piece	$20, -3, 4x2, 0
		endsprite
		
@normal2:	spritemap
		piece	-$60, -3, 4x2, 8
		piece	-$20, -3, 4x2, 8
		piece	$20, -3, 4x2, 8
		endsprite
		
@normal3:	spritemap
		piece	-$60, -3, 4x2, 0, xflip
		piece	-$20, -3, 4x2, 0, xflip
		piece	$20, -3, 4x2, 0, xflip
		endsprite
		
@paused1:	spritemap
		piece	-$60, -3, 4x2, 0
		piece	-$40, -3, 4x2, 0
		piece	-$20, -3, 4x2, 0
		piece	0, -3, 4x2, 0
		piece	$20, -3, 4x2, 0
		piece	$40, -3, 4x2, 0
		endsprite
		
@paused2:	spritemap
		piece	-$60, -3, 4x2, 8
		piece	-$40, -3, 4x2, 8
		piece	-$20, -3, 4x2, 8
		piece	0, -3, 4x2, 8
		piece	$20, -3, 4x2, 8
		piece	$40, -3, 4x2, 8
		endsprite
		
@paused3:	spritemap
		piece	-$60, -3, 4x2, 0, xflip
		piece	-$40, -3, 4x2, 0, xflip
		piece	-$20, -3, 4x2, 0, xflip
		piece	0, -3, 4x2, 0, xflip
		piece	$20, -3, 4x2, 0, xflip
		piece	$40, -3, 4x2, 0, xflip
		endsprite
		even
