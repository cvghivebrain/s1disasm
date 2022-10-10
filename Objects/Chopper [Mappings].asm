; ---------------------------------------------------------------------------
; Sprite mappings - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Chop:	index offset(*)
		ptr frame_chopper_shut
		ptr frame_chopper_open
		
frame_chopper_shut:
		spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
frame_chopper_open:
		spritemap
		piece	-$10, -$10, 4x4, $10
		endsprite
		even
