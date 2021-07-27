; ---------------------------------------------------------------------------
; Sprite mappings - moving blocks (MZ, SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @mz1
		ptr @mz2
		ptr @sbz
		ptr @sbzwide
		ptr @mz3
		
@mz1:		spritemap
		piece	-$10, -8, 4x4, 8
		endsprite
		
@mz2:		spritemap
		piece	-$20, -8, 4x4, 8
		piece	0, -8, 4x4, 8
		endsprite
		
@sbz:		spritemap
		piece	-$20, -8, 4x1, 0, pal2
		piece	-$20, 0, 4x2, 4
		piece	0, -8, 4x1, 0, pal2
		piece	0, 0, 4x2, 4
		endsprite
		
@sbzwide:	spritemap
		piece	-$40, -8, 4x3, 0
		piece	-$20, -8, 4x3, 3
		piece	0, -8, 4x3, 3
		piece	$20, -8, 4x3, 0, xflip
		endsprite
		
@mz3:		spritemap
		piece	-$30, -8, 4x4, 8
		piece	-$10, -8, 4x4, 8
		piece	$10, -8, 4x4, 8
		endsprite
		even
