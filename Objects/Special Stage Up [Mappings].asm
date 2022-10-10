; ---------------------------------------------------------------------------
; Sprite mappings - special stage "UP" block
; ---------------------------------------------------------------------------
Map_SS_Up:	index offset(*)
		ptr frame_ss_up_0
		ptr frame_ss_up_1
		
frame_ss_up_0:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
frame_ss_up_1:	spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		even
