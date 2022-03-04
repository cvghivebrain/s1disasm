; ---------------------------------------------------------------------------
; Sprite mappings - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
Map_Elec:	index *
		ptr frame_electro_normal
		ptr frame_electro_zap1
		ptr frame_electro_zap2
		ptr frame_electro_zap3
		ptr frame_electro_zap4
		ptr frame_electro_zap5
		
frame_electro_normal:
		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		endsprite
		
frame_electro_zap1:
		spritemap
		piece	-8, -8, 2x2, 8
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		endsprite
		
frame_electro_zap2:
		spritemap
		piece	-8, -8, 2x2, 8
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C
		piece	-$24, -$A, 4x2, $C, xflip
		endsprite
		
frame_electro_zap3:
		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C
		piece	-$24, -$A, 4x2, $C, xflip
		endsprite
		
frame_electro_zap4:
		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	8, -$A, 4x2, $C, yflip
		piece	-$24, -$A, 4x2, $C, xflip, yflip
		piece	$24, -$A, 4x2, $C
		piece	-$40, -$A, 4x2, $C, xflip
		endsprite
		
frame_electro_zap5:
		spritemap
		piece	-8, -8, 2x1, 0, pal4
		piece	-8, 0, 2x3, 2, pal3
		piece	$24, -$A, 4x2, $C, yflip
		piece	-$40, -$A, 4x2, $C, xflip, yflip
		endsprite
		even
