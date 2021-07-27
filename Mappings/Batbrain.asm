; ---------------------------------------------------------------------------
; Sprite mappings - Basaran enemy (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @still
		ptr @fly1
		ptr @fly2
		ptr @fly3
		
@still:		spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
@fly1:		spritemap
		piece	-$C, -$E, 4x3, 6
		piece	-4, $A, 2x1, $12
		piece	$C, 2, 1x1, $27
		endsprite
		
@fly2:		spritemap
		piece	-8, -8, 2x1, $14
		piece	-$10, 0, 4x1, $16
		piece	0, 8, 2x1, $1A
		piece	$C, 0, 1x1, $28
		endsprite
		
@fly3:		spritemap
		piece	-$B, -$A, 3x2, $1C
		piece	-$C, 6, 3x1, $22
		piece	-$C, $E, 2x1, $25
		piece	$C, -2, 1x1, $27
		endsprite
		even
