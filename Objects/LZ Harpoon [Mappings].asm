; ---------------------------------------------------------------------------
; Sprite mappings - harpoon (LZ)
; ---------------------------------------------------------------------------
Map_Harp:	index offset(*)
		ptr frame_harp_h_retracted
		ptr frame_harp_h_middle
		ptr frame_harp_h_extended
		ptr frame_harp_v_retracted
		ptr frame_harp_v_middle
		ptr frame_harp_v_extended
		
frame_harp_h_retracted:
		spritemap
		piece	-8, -4, 2x1, 0
		endsprite
		
frame_harp_h_middle:
		spritemap
		piece	-8, -4, 4x1, 2
		endsprite
		
frame_harp_h_extended:
		spritemap
		piece	-8, -4, 3x1, 6
		piece	$10, -4, 3x1, 3
		endsprite
		
frame_harp_v_retracted:
		spritemap
		piece	-4, -8, 1x2, 9
		endsprite
		
frame_harp_v_middle:
		spritemap
		piece	-4, -$18, 1x4, $B
		endsprite
		
frame_harp_v_extended:
		spritemap
		piece	-4, -$28, 1x3, $B
		piece	-4, -$10, 1x3, $F
		endsprite
		even
