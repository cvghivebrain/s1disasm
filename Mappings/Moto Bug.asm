; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr @moto1
		ptr @moto2
		ptr @moto3
		ptr @smoke1
		ptr @smoke2
		ptr @smoke3
		ptr @blank
		
@moto1:		spritemap
		piece	-$14, -$10, 4x2, 0
		piece	-$14, 0, 4x1, 8
		piece	$C, -8, 1x2, $C
		piece	-$C, 8, 3x1, $E
		endsprite
		
@moto2:		spritemap
		piece	-$14, -$F, 4x2, 0
		piece	-$14, 1, 4x1, 8
		piece	$C, -7, 1x2, $C
		piece	-$C, 9, 3x1, $11
		endsprite
		
@moto3:		spritemap
		piece	-$14, -$10, 4x2, 0
		piece	-$14, 0, 4x1, $14
		piece	$C, -8, 1x2, $C
		piece	-$14, 8, 2x1, $18
		piece	-4, 8, 2x1, $12
		endsprite
		
@smoke1:	spritemap
		piece	$10, -6, 1x1, $1A
		endsprite
		
@smoke2:	spritemap
		piece	$10, -6, 1x1, $1B
		endsprite
		
@smoke3:	spritemap
		piece	$10, -6, 1x1, $1C
		endsprite
		
@blank:		spritemap
		endsprite
		even
