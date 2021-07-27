; ---------------------------------------------------------------------------
; Sprite mappings - SLZ	swinging platforms
; ---------------------------------------------------------------------------
		index *
		ptr @block
		ptr @chain
		ptr @anchor
		
@block:		spritemap
		piece	-$20, -$10, 4x4, 4
		piece	0, -$10, 4x4, 4, xflip
		piece	-$30, -$10, 2x2, $14
		piece	$20, -$10, 2x2, $14, xflip
		piece	-$20, $10, 2x1, $18
		piece	$10, $10, 2x1, $18, xflip
		piece	-8, $10, 1x2, $1A
		piece	0, $10, 1x2, $1A, xflip
		endsprite
		
@chain:		spritemap
		piece	-8, -8, 2x2, 0, pal3
		endsprite
		
@anchor:	spritemap
		piece	-8, -8, 2x2, $1C
		endsprite
		even
