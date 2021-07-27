; ---------------------------------------------------------------------------
; Sprite mappings - fire balls (MZ, SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @vertical1
		ptr @vertical2
		ptr @vertcollide
		ptr @horizontal1
		ptr @horizontal2
		ptr @horicollide
		
@vertical1:	spritemap
		piece	-8, -$18, 2x4, 0
		endsprite
		
@vertical2:	spritemap
		piece	-8, -$18, 2x4, 8
		endsprite
		
@vertcollide:	spritemap
		piece	-8, -$10, 2x3, $10
		endsprite
		
@horizontal1:	spritemap
		piece	-$18, -8, 4x2, $16
		endsprite
		
@horizontal2:	spritemap
		piece	-$18, -8, 4x2, $1E
		endsprite
		
@horicollide:	spritemap
		piece	-$10, -8, 3x2, $26
		endsprite
		even
