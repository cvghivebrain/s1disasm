; ---------------------------------------------------------------------------
; Sprite mappings - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr @walk0
		ptr @walk1
		ptr @walk2
		ptr @walk3
		ptr @walk4
		ptr @walk5
		
@walk0:		spritemap
		piece	-$C, -$C, 3x1, 0
		piece	-$14, -4, 4x3, 3
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
@walk1:		spritemap
		piece	-$C, -$C, 3x1, $14
		piece	-$14, -4, 4x3, $17
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
@walk2:		spritemap
		piece	-$C, -$C, 3x2, $23
		piece	-$14, 4, 4x2, $29
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
@walk3:		spritemap
		piece	-$C, -$C, 3x1, 0
		piece	-$14, -4, 4x3, 3
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		
@walk4:		spritemap
		piece	-$C, -$C, 3x1, $14
		piece	-$14, -4, 4x3, $17
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		
@walk5:		spritemap
		piece	-$C, -$C, 3x2, $23
		piece	-$14, 4, 4x2, $29
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		even
