; ---------------------------------------------------------------------------
; Sprite mappings - fire balls (MZ, SLZ)
; ---------------------------------------------------------------------------
Map_Fire:	index offset(*)
		ptr frame_fire_vertical1
		ptr frame_fire_vertical2
		ptr frame_fire_vertcollide
		ptr frame_fire_horizontal1
		ptr frame_fire_horizontal2
		ptr frame_fire_horicollide
		
frame_fire_vertical1:
		spritemap
		piece	-8, -$18, 2x4, 0
		endsprite
		
frame_fire_vertical2:
		spritemap
		piece	-8, -$18, 2x4, 8
		endsprite
		
frame_fire_vertcollide:
		spritemap
		piece	-8, -$10, 2x3, $10
		endsprite
		
frame_fire_horizontal1:
		spritemap
		piece	-$18, -8, 4x2, $16
		endsprite
		
frame_fire_horizontal2:
		spritemap
		piece	-$18, -8, 4x2, $1E
		endsprite
		
frame_fire_horicollide:
		spritemap
		piece	-$10, -8, 3x2, $26
		endsprite
		even
