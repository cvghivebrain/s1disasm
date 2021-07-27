; ---------------------------------------------------------------------------
; Sprite mappings - signpost
; ---------------------------------------------------------------------------
		index *
		ptr @eggman
		ptr @spin1
		ptr @spin2
		ptr @spin3
		ptr @sonic
		
@eggman:	spritemap
		piece	-$18, -$10, 3x4, 0
		piece	0, -$10, 3x4, 0, xflip
		piece	-4, $10, 1x2, $38
		endsprite
		
@spin1:		spritemap
		piece	-$10, -$10, 4x4, $C
		piece	-4, $10, 1x2, $38
		endsprite
		
@spin2:		spritemap
		piece	-4, -$10, 1x4, $1C
		piece	-4, $10, 1x2, $38, xflip
		endsprite
		
@spin3:		spritemap
		piece	-$10, -$10, 4x4, $C, xflip
		piece	-4, $10, 1x2, $38, xflip
		endsprite
		
@sonic:		spritemap
		piece	-$18, -$10, 3x4, $20
		piece	0, -$10, 3x4, $2C
		piece	-4, $10, 1x2, $38
		endsprite
		even
