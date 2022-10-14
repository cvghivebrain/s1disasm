; ---------------------------------------------------------------------------
; Sprite mappings - special stage chaos	emeralds
; ---------------------------------------------------------------------------
Map_SS_Chaos1:	index offset(*)
		ptr frame_ss_chaos1_0
		ptr frame_ss_chaos_flash
		
Map_SS_Chaos2:	index offset(*)
		ptr frame_ss_chaos2_0
		ptr frame_ss_chaos_flash
		
Map_SS_Chaos3:	index offset(*)
		ptr frame_ss_chaos3_0
		ptr frame_ss_chaos_flash
		
frame_ss_chaos1_0:
		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_ss_chaos2_0:
		spritemap
		piece	-8, -8, 2x2, 4
		endsprite
		
frame_ss_chaos3_0:
		spritemap
		piece	-8, -8, 2x2, 8
		endsprite
		
frame_ss_chaos_flash:
		spritemap
		piece	-8, -8, 2x2, $C
		endsprite
		even
