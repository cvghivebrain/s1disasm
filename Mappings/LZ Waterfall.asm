; ---------------------------------------------------------------------------
; Sprite mappings - waterfalls (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @vertnarrow
		ptr @cornerwide
		ptr @cornermedium
		ptr @cornernarrow
		ptr @cornermedium2
		ptr @cornernarrow2
		ptr @cornernarrow3
		ptr @vertwide
		ptr @diagonal
		ptr @splash1
		ptr @splash2
		ptr @splash3
		
@vertnarrow:	spritemap
		piece	-8, -$10, 2x4, 0
		endsprite
		
@cornerwide:	spritemap
		piece	-4, -8, 2x1, 8
		piece	-$C, 0, 3x1, $A
		endsprite
		
@cornermedium:	spritemap
		piece	0, -8, 1x1, 8
		piece	-8, 0, 2x1, $D
		endsprite
		
@cornernarrow:	spritemap
		piece	0, -8, 1x2, $F
		endsprite
		
@cornermedium2:	spritemap
		piece	0, -8, 1x1, 8
		piece	-8, 0, 2x1, $D
		endsprite
		
@cornernarrow2:	spritemap
		piece	0, -8, 1x2, $11
		endsprite
		
@cornernarrow3:	spritemap
		piece	0, -8, 1x2, $13
		endsprite
		
@vertwide:	spritemap
		piece	-8, -$10, 2x4, $15
		endsprite
		
@diagonal:	spritemap
		piece	-$A, -8, 4x1, $1D
		piece	-$18, 0, 4x1, $21
		endsprite
		
@splash1:	spritemap
		piece	-$18, -$10, 3x4, $25
		piece	0, -$10, 3x4, $31
		endsprite
		
@splash2:	spritemap
		piece	-$18, -$10, 3x4, $3D
		piece	0, -$10, 3x4, $49
		endsprite
		
@splash3:	spritemap
		piece	-$18, -$10, 3x4, $55
		piece	0, -$10, 3x4, $61
		endsprite
		even
