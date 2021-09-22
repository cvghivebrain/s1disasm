; ---------------------------------------------------------------------------
; Sprite mappings - ground saws	and pizza cutters (SBZ)
; ---------------------------------------------------------------------------
Map_Saw:	index *
		ptr frame_saw_pizzacutter1
		ptr frame_saw_pizzacutter2
		ptr frame_saw_groundsaw1
		ptr frame_saw_groundsaw2
		
frame_saw_pizzacutter1:
		spritemap
		piece	-4, -$3C, 1x2, $20
		piece	-4, -$2C, 1x2, $20
		piece	-4, -$1C, 1x4, $20
		piece	-$20, -$20, 4x4, 0
		piece	0, -$20, 4x4, 0, xflip
		piece	-$20, 0, 4x4, 0, yflip
		piece	0, 0, 4x4, 0, xflip, yflip
		endsprite
		
frame_saw_pizzacutter2:
		spritemap
		piece	-4, -$3C, 1x2, $20
		piece	-4, -$2C, 1x2, $20
		piece	-4, -$1C, 1x4, $20
		piece	-$20, -$20, 4x4, $10
		piece	0, -$20, 4x4, $10, xflip
		piece	-$20, 0, 4x4, $10, yflip
		piece	0, 0, 4x4, $10, xflip, yflip
		endsprite
		
frame_saw_groundsaw1:
		spritemap
		piece	-$20, -$20, 4x4, 0
		piece	0, -$20, 4x4, 0, xflip
		piece	-$20, 0, 4x4, 0, yflip
		piece	0, 0, 4x4, 0, xflip, yflip
		endsprite
		
frame_saw_groundsaw2:
		spritemap
		piece	-$20, -$20, 4x4, $10
		piece	0, -$20, 4x4, $10, xflip
		piece	-$20, 0, 4x4, $10, yflip
		piece	0, 0, 4x4, $10, xflip, yflip
		endsprite
		even
