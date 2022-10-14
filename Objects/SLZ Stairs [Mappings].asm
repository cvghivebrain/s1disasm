; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	form a staircase (SLZ)
; ---------------------------------------------------------------------------
Map_Stair:	index offset(*)
		ptr frame_stair_block
		
frame_stair_block:
		spritemap
		piece	-$10, -$10, 4x4, $21
		endsprite
		even
