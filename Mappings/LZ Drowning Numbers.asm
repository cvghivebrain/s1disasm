; ---------------------------------------------------------------------------
; Sprite mappings - drowning countdown numbers (LZ)
; ---------------------------------------------------------------------------
Map_Drown:	index *
		ptr frame_drown_num
		
frame_drown_num:
		spritemap
		piece	-$E, -$18, 4x3, 0
		endsprite
		even
