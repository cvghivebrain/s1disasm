; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @h_retracted
		ptr @h_middle
		ptr @h_extended
		ptr @v_retracted
		ptr @v_middle
		ptr @v_extended
		
@h_retracted:	spritemap
		piece	-8, -4, 2x1, 0
		endsprite
		
@h_middle:	spritemap
		piece	-8, -4, 4x1, 2
		endsprite
		
@h_extended:	spritemap
		piece	-8, -4, 3x1, 6
		piece	$10, -4, 3x1, 3
		endsprite
		
@v_retracted:	spritemap
		piece	-4, -8, 1x2, 9
		endsprite
		
@v_middle:	spritemap
		piece	-4, -$18, 1x4, $B
		endsprite
		
@v_extended:	spritemap
		piece	-4, -$28, 1x3, $B
		piece	-4, -$10, 1x3, $F
		endsprite
		even
