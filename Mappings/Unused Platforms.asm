; ---------------------------------------------------------------------------
; Sprite mappings - unused
; ---------------------------------------------------------------------------
Map_Plat_Unused:
		index *
		ptr frame_plat_unused_small
		ptr frame_plat_unused_large
		
frame_plat_unused_small:
		spritemap
		piece	-$18, -$C, 3x4, $3C
		piece	0, -$C, 3x4, $48
		endsprite
		
frame_plat_unused_large:
		spritemap
		piece	-$20, -$C, 4x4, $CA
		piece	-$20, 4, 4x4, $DA
		piece	-$20, $24, 4x4, $DA
		piece	-$20, $44, 4x4, $DA
		piece	-$20, $64, 4x4, $DA
		piece	0, -$C, 4x4, $CA, xflip
		piece	0, 4, 4x4, $DA, xflip
		piece	0, $24, 4x4, $DA, xflip
		piece	0, $44, 4x4, $DA, xflip
		piece	0, $64, 4x4, $DA, xflip
		endsprite
		even
