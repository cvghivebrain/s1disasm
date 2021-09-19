; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	and MZ swinging	platforms
; ---------------------------------------------------------------------------
Map_Swing_GHZ:	index *
		ptr frame_swing_block
		ptr frame_swing_chain
		ptr frame_swing_anchor
		
frame_swing_block:
		spritemap
		piece	-$18, -8, 3x2, 4
		piece	0, -8, 3x2, 4
		endsprite
		
frame_swing_chain:
		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_swing_anchor:
		spritemap
		piece	-8, -8, 2x2, $A
		endsprite
		even
