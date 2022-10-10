; ---------------------------------------------------------------------------
; Sprite mappings - large green	glassy blocks (MZ)
; ---------------------------------------------------------------------------
Map_Glass:	index offset(*)
		ptr frame_glass_tall
		ptr frame_glass_shine
		ptr frame_glass_short
		
frame_glass_tall:
		spritemap					; tall block
		piece	-$20, -$48, 4x1, 0
		piece	0, -$48, 4x1, 0, xflip
		piece	-$20, -$40, 4x4, 4
		piece	0, -$40, 4x4, 4, xflip
		piece	-$20, -$20, 4x4, 4
		piece	0, -$20, 4x4, 4, xflip
		piece	-$20, 0, 4x4, 4
		piece	0, 0, 4x4, 4, xflip
		piece	-$20, $20, 4x4, 4
		piece	0, $20, 4x4, 4, xflip
		piece	-$20, $40, 4x1, 0, yflip
		piece	0, $40, 4x1, 0, xflip, yflip
		endsprite
		
frame_glass_shine:
		spritemap					; reflected shine on block
		piece	-$10, 8, 2x3, $14
		piece	0, 0, 2x3, $14
		endsprite
		
frame_glass_short:
		spritemap					; short block
		piece	-$20, -$38, 4x1, 0
		piece	0, -$38, 4x1, 0, xflip
		piece	-$20, -$30, 4x4, 4
		piece	0, -$30, 4x4, 4, xflip
		piece	-$20, -$10, 4x4, 4
		piece	0, -$10, 4x4, 4, xflip
		piece	-$20, $10, 4x4, 4
		piece	0, $10, 4x4, 4, xflip
		piece	-$20, $30, 4x1, 0, yflip
		piece	0, $30, 4x1, 0, xflip, yflip
		endsprite
		even
