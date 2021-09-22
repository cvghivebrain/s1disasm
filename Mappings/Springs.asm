; ---------------------------------------------------------------------------
; Sprite mappings - springs
; ---------------------------------------------------------------------------
Map_Spring:	index *
		ptr frame_spring_up
		ptr frame_spring_upflat
		ptr frame_spring_upext
		ptr frame_spring_left
		ptr frame_spring_leftflat
		ptr frame_spring_leftext
		
frame_spring_up:
		spritemap			; facing up
		piece	-$10, -8, 4x1, 0
		piece	-$10, 0, 4x1, 4
		endsprite
		
frame_spring_upflat:
		spritemap			; facing up, flattened
		piece	-$10, 0, 4x1, 0
		endsprite
		
frame_spring_upext:
		spritemap			; facing up, extended
		piece	-$10, -$18, 4x1, 0
		piece	-8, -$10, 2x2, 8
		piece	-$10, 0, 4x1, $C
		endsprite
		
frame_spring_left:
		spritemap			; facing left
		piece	-8, -$10, 2x4, 0
		endsprite
		
frame_spring_leftflat:
		spritemap			; facing left, flattened
		piece	-8, -$10, 1x4, 4
		endsprite
		
frame_spring_leftext:
		spritemap			; facing left, extended
		piece	$10, -$10, 1x4, 4
		piece	-8, -8, 3x2, 8
		piece	-8, -$10, 1x1, 0
		piece	-8, 8, 1x1, 3
		endsprite
		even
