; ---------------------------------------------------------------------------
; Sprite mappings - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Map_Yad:	index *
		ptr frame_yadrin_walk0
		ptr frame_yadrin_walk1
		ptr frame_yadrin_walk2
		ptr frame_yadrin_walk3
		ptr frame_yadrin_walk4
		ptr frame_yadrin_walk5
		
frame_yadrin_walk0:
		spritemap
		piece	-$C, -$C, 3x1, 0
		piece	-$14, -4, 4x3, 3
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
frame_yadrin_walk1:
		spritemap
		piece	-$C, -$C, 3x1, $14
		piece	-$14, -4, 4x3, $17
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
frame_yadrin_walk2:
		spritemap
		piece	-$C, -$C, 3x2, $23
		piece	-$14, 4, 4x2, $29
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $31
		endsprite
		
frame_yadrin_walk3:
		spritemap
		piece	-$C, -$C, 3x1, 0
		piece	-$14, -4, 4x3, 3
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		
frame_yadrin_walk4:
		spritemap
		piece	-$C, -$C, 3x1, $14
		piece	-$14, -4, 4x3, $17
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		
frame_yadrin_walk5:
		spritemap
		piece	-$C, -$C, 3x2, $23
		piece	-$14, 4, 4x2, $29
		piece	-4, -$14, 2x1, $F
		piece	$C, -$C, 1x3, $11
		piece	-4, 4, 3x2, $37
		endsprite
		even
