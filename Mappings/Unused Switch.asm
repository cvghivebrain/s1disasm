; ---------------------------------------------------------------------------
; Sprite mappings - Unused switch thingy
; ---------------------------------------------------------------------------
Map_Switch:	index *
		ptr frame_switch_0
		
frame_switch_0:	spritemap
		piece	-$10, -$18, 2x4, $54
		piece	-$10, 8, 2x2, $5C
		piece	0, -$18, 2x4, $54
		piece	0, 8, 2x2, $5C
		endsprite
		even
