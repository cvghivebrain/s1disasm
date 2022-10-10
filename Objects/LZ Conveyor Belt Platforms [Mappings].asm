; ---------------------------------------------------------------------------
; Sprite mappings - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------
Map_LConv:	index offset(*)
		ptr frame_lcon_wheel1
		ptr frame_lcon_wheel2
		ptr frame_lcon_wheel3
		ptr frame_lcon_wheel4
		ptr frame_lcon_platform
		
frame_lcon_wheel1:
		spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
frame_lcon_wheel2:
		spritemap
		piece	-$10, -$10, 4x4, $10
		endsprite
		
frame_lcon_wheel3:
		spritemap
		piece	-$10, -$10, 4x4, $20
		endsprite
		
frame_lcon_wheel4:
		spritemap
		piece	-$10, -$10, 4x4, $30
		endsprite
		
frame_lcon_platform:
		spritemap
		piece	-$10, -8, 4x2, $40
		endsprite
		even
