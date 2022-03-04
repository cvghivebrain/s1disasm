; ---------------------------------------------------------------------------
; Sprite mappings - seesaws (SLZ)
; ---------------------------------------------------------------------------
Map_Seesaw:	index *
		ptr frame_seesaw_sloping_leftup
		ptr frame_seesaw_flat
		ptr frame_seesaw_sloping_rightup
		ptr frame_seesaw_flat

frame_seesaw_sloping_leftup:					; left side raised
frame_seesaw_sloping_rightup:					; right side raised, actually the same but xflipped
		spritemap
		piece	-$2D, -$2C, 2x3, 0
		piece	-$1D, -$24, 2x3, 6
		piece	-$D, -$1C, 2x1, $C
		piece	-$D, -$14, 4x2, $E
		piece	-5, -4, 3x1, $16
		piece	$13, -$C, 2x3, 6
		piece	$23, -4, 2x2, $19
		endsprite
		
frame_seesaw_flat:
		spritemap
		piece	-$30, -$1A, 3x3, $1D
		piece	-$18, -$1A, 3x3, $23
		piece	0, -$1A, 3x3, $23, xflip
		piece	$18, -$1A, 3x3, $1D, xflip
		endsprite
		even
