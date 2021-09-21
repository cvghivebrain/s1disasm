; ---------------------------------------------------------------------------
; Sprite mappings - solid blocks and blocks that fall from the ceiling (MZ)
; ---------------------------------------------------------------------------
Map_Brick:	index *
		ptr frame_brick_0
		
frame_brick_0:	spritemap
		piece	-$10, -$10, 4x4, 1
		endsprite
		even
