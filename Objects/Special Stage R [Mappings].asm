; ---------------------------------------------------------------------------
; Sprite mappings - special stage "R" block
; ---------------------------------------------------------------------------
Map_SS_R:	index offset(*)
		ptr frame_ss_r_0
		ptr frame_ss_r_1
		ptr frame_ss_ghost_switch
		
frame_ss_r_0:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
frame_ss_r_1:	spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		
frame_ss_ghost_switch:
		spritemap
		endsprite
		even
