; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @normal
		ptr @zap1
		ptr @zap2
		ptr @zap3
		ptr @zap4
		ptr @zap5
		
@normal:	spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		endsprite
		
@zap1:		spritemap
		piece	-8, -8, 2x2, 8
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		endsprite
		
@zap2:		spritemap
		piece	-8, -8, 2x2, 8
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C
		piece	-$24, -$A, 4x2, $C, xflip
		endsprite
		
@zap3:		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C
		piece	-$24, -$A, 4x2, $C, xflip
		endsprite
		
@zap4:		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C, yflip
		piece	-$24, -$A, 4x2, $C, xflip, yflip
		piece	$24, -$A, 4x2, $C
		piece	-$40, -$A, 4x2, $C, xflip
		endsprite
		
@zap5:		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	$24, -$A, 4x2, $C, yflip
		piece	-$40, -$A, 4x2, $C, xflip, yflip
		endsprite
		even
