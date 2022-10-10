; ---------------------------------------------------------------------------
; Sprite mappings - lamp (SYZ)
; ---------------------------------------------------------------------------
Map_Light:	index offset(*)
		ptr frame_light_0
		ptr frame_light_1
		ptr frame_light_2
		ptr frame_light_3
		ptr frame_light_4
		ptr frame_light_5
		
frame_light_0:
		spritemap
		piece	-$10, -8, 4x1, $31
		piece	-$10, 0, 4x1, $31, yflip
		endsprite
		
frame_light_1:
		spritemap
		piece	-$10, -8, 4x1, $35
		piece	-$10, 0, 4x1, $35, yflip
		endsprite
		
frame_light_2:
		spritemap
		piece	-$10, -8, 4x1, $39
		piece	-$10, 0, 4x1, $39, yflip
		endsprite
		
frame_light_3:
		spritemap
		piece	-$10, -8, 4x1, $3D
		piece	-$10, 0, 4x1, $3D, yflip
		endsprite
		
frame_light_4:
		spritemap
		piece	-$10, -8, 4x1, $41
		piece	-$10, 0, 4x1, $41, yflip
		endsprite
		
frame_light_5:
		spritemap
		piece	-$10, -8, 4x1, $45
		piece	-$10, 0, 4x1, $45, yflip
		endsprite
		even
