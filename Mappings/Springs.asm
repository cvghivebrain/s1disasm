; ---------------------------------------------------------------------------
; Sprite mappings - springs
; ---------------------------------------------------------------------------
		index *
		ptr M_Spg_Up
		ptr M_Spg_UpFlat
		ptr M_Spg_UpExt
		ptr M_Spg_Left
		ptr M_Spg_LeftFlat
		ptr M_Spg_LeftExt
		
M_Spg_Up:	spritemap			; facing up
		piece	-$10, -8, 4x1, 0
		piece	-$10, 0, 4x1, 4
		endsprite
		
M_Spg_UpFlat:	spritemap			; facing up, flattened
		piece	-$10, 0, 4x1, 0
		endsprite
		
M_Spg_UpExt:	spritemap			; facing up, extended
		piece	-$10, -$18, 4x1, 0
		piece	-8, -$10, 2x2, 8
		piece	-$10, 0, 4x1, $C
		endsprite
		
M_Spg_Left:	spritemap			; facing left
		piece	-8, -$10, 2x4, 0
		endsprite
		
M_Spg_LeftFlat:	spritemap			; facing left, flattened
		piece	-8, -$10, 1x4, 4
		endsprite
		
M_Spg_LeftExt:	spritemap			; facing left, extended
		piece	$10, -$10, 1x4, 4
		piece	-8, -8, 3x2, 8
		piece	-8, -$10, 1x1, 0
		piece	-8, 8, 1x1, 3
		endsprite
		even
