; ---------------------------------------------------------------------------
; Sprite mappings - fans (SLZ)
; ---------------------------------------------------------------------------
Map_Fan:	index offset(*)
		ptr frame_fan_0
		ptr frame_fan_1
		ptr frame_fan_2
		ptr frame_fan_1
		ptr frame_fan_0
		
frame_fan_0:
		spritemap
		piece	-8, -$10, 3x2, 0
		piece	-$10, 0, 4x2, 6
		endsprite
		
frame_fan_1:
		spritemap
		piece	-$10, -$10, 4x2, $E
		piece	-$10, 0, 4x2, $16
		endsprite
		
frame_fan_2:
		spritemap
		piece	-$10, -$10, 4x2, $1E
		piece	-8, 0, 3x2, $26
		endsprite
		even
