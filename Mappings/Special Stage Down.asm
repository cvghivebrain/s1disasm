; ---------------------------------------------------------------------------
; Sprite mappings - special stage "DOWN" block
; ---------------------------------------------------------------------------
Map_SS_Down:	index *
		ptr frame_ss_down_0
		ptr frame_ss_down_1
		
frame_ss_down_0:
		spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		
frame_ss_down_1:
		spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		even
