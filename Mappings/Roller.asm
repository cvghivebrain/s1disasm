; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr M_Roll_Stand
		ptr M_Roll_Fold
		ptr M_Roll_Roll1
		ptr M_Roll_Roll2
		ptr M_Roll_Roll3
		
M_Roll_Stand:	spritemap			; standing
		piece	-$10, -$22, 4x3, 0
		piece	-$10, -$A, 4x3, $C
		endsprite
		
M_Roll_Fold:	spritemap			; folding
		piece	-$10, -$1A, 4x3, 0
		piece	-$10, -2, 4x2, $18
		endsprite
		
M_Roll_Roll1:	spritemap			; rolling
		piece	-$10, -$10, 4x4, $20
		endsprite
		
M_Roll_Roll2:	spritemap			; rolling
		piece	-$10, -$10, 4x4, $30
		endsprite
		
M_Roll_Roll3:	spritemap			; rolling
		piece	-$10, -$10, 4x4, $40
		endsprite
		even
