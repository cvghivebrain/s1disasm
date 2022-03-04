; ---------------------------------------------------------------------------
; Sprite mappings - prison capsule
; ---------------------------------------------------------------------------
Map_Pri:	index *
		ptr frame_prison_capsule
		ptr frame_prison_switch1
		ptr frame_prison_broken
		ptr frame_prison_switch2
		ptr frame_prison_unused_pod
		ptr frame_prison_unused_panel
		ptr frame_prison_blank
		
frame_prison_capsule:
		spritemap
		piece	-$10, -$20, 4x1, 0, pal2
		piece	-$20, -$18, 4x2, 4, pal2
		piece	0, -$18, 4x2, $C, pal2
		piece	-$20, -8, 4x3, $14, pal2
		piece	0, -8, 4x3, $20, pal2
		piece	-$20, $10, 4x2, $2C, pal2
		piece	0, $10, 4x2, $34, pal2
		endsprite
		
frame_prison_switch1:
		spritemap
		piece	-$C, -8, 3x2, $3C
		endsprite
		
frame_prison_broken:
		spritemap
		piece	-$20, 0, 3x1, $42, pal2
		piece	-$20, 8, 4x1, $45, pal2
		piece	$10, 0, 2x1, $49, pal2
		piece	0, 8, 4x1, $4B, pal2
		piece	-$20, $10, 4x2, $2C, pal2
		piece	0, $10, 4x2, $34, pal2
		endsprite
		
frame_prison_switch2:
		spritemap
		piece	-$C, -8, 3x2, $4F
		endsprite
		
frame_prison_unused_pod:
		spritemap
		piece	-$10, -$18, 4x3, $55, pal2
		piece	-$10, 0, 4x3, $61, pal2
		endsprite
		
frame_prison_unused_panel:
		spritemap
		piece	-8, -$10, 2x4, $6D, pal2
		endsprite
		
frame_prison_blank:
		spritemap
		endsprite
		even
