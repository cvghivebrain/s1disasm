; ---------------------------------------------------------------------------
; Sprite mappings - special stage breakable glass blocks and red-white blocks
; ---------------------------------------------------------------------------
Map_SS_Glass:	index *
		ptr frame_ss_glass_0
		ptr frame_ss_glass_1
		ptr frame_ss_glass_2
		ptr frame_ss_glass_3
		
frame_ss_glass_0:
		spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
frame_ss_glass_1:
		spritemap
		piece	-$C, -$C, 3x3, 0, xflip
		endsprite
		
frame_ss_glass_2:
		spritemap
		piece	-$C, -$C, 3x3, 0, xflip, yflip
		endsprite
		
frame_ss_glass_3:
		spritemap
		piece	-$C, -$C, 3x3, 0, yflip
		endsprite
		even
