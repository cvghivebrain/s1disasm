; ---------------------------------------------------------------------------
; Sprite mappings - pole that breaks (LZ)
; ---------------------------------------------------------------------------
Map_Pole:	index *
		ptr frame_pole_normal
		ptr frame_pole_broken
		
frame_pole_normal:
		spritemap			; normal pole
		piece	-4, -$20, 1x4, 0
		piece	-4, 0, 1x4, 0, yflip
		endsprite
		
frame_pole_broken:
		spritemap			; broken pole
		piece	-4, -$20, 1x2, 0
		piece	-4, -$10, 2x2, 4
		piece	-4, 0, 2x2, 4, yflip
		piece	-4, $10, 1x2, 0, yflip
		endsprite
		even
