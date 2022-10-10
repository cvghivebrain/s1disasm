; ---------------------------------------------------------------------------
; Sprite mappings - energy ball	launcher (FZ)
; ---------------------------------------------------------------------------
Map_PLaunch:	index offset(*)
		ptr frame_plaunch_red
		ptr frame_plaunch_white
		ptr frame_plaunch_sparking1
		ptr frame_plaunch_sparking2
		
frame_plaunch_red:
		spritemap
		piece	-8, -8, 2x2, $6E
		endsprite
		
frame_plaunch_white:
		spritemap
		piece	-8, -8, 2x2, $76
		endsprite
		
frame_plaunch_sparking1:
		spritemap
		piece	-8, -8, 2x2, $72
		endsprite
		
frame_plaunch_sparking2:
		spritemap
		piece	-8, -8, 2x2, $72, yflip
		endsprite
		even
