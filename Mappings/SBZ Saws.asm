; ---------------------------------------------------------------------------
; Sprite mappings - ground saws	and pizza cutters (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @pizzacutter1
		ptr @pizzacutter2
		ptr @groundsaw1
		ptr @groundsaw2
		
@pizzacutter1:	spritemap
		piece	-4, -$3C, 1x2, $20
		piece	-4, -$2C, 1x2, $20
		piece	-4, -$1C, 1x4, $20
		piece	-$20, -$20, 4x4, 0
		piece	0, -$20, 4x4, 0, xflip
		piece	-$20, 0, 4x4, 0, yflip
		piece	0, 0, 4x4, 0, xflip, yflip
		endsprite
		
@pizzacutter2:	spritemap
		piece	-4, -$3C, 1x2, $20
		piece	-4, -$2C, 1x2, $20
		piece	-4, -$1C, 1x4, $20
		piece	-$20, -$20, 4x4, $10
		piece	0, -$20, 4x4, $10, xflip
		piece	-$20, 0, 4x4, $10, yflip
		piece	0, 0, 4x4, $10, xflip, yflip
		endsprite
		
@groundsaw1:	spritemap
		piece	-$20, -$20, 4x4, 0
		piece	0, -$20, 4x4, 0, xflip
		piece	-$20, 0, 4x4, 0, yflip
		piece	0, 0, 4x4, 0, xflip, yflip
		endsprite
		
@groundsaw2:	spritemap
		piece	-$20, -$20, 4x4, $10
		piece	0, -$20, 4x4, $10, xflip
		piece	-$20, 0, 4x4, $10, yflip
		piece	0, 0, 4x4, $10, xflip, yflip
		endsprite
		even
