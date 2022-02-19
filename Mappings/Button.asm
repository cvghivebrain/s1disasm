; ---------------------------------------------------------------------------
; Sprite mappings - buttons (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------
Map_But:	index *
		ptr frame_button_up
		ptr frame_button_down
		ptr frame_button_unk
		ptr frame_button_down
		
frame_button_up:
		spritemap
		piece	-$10, -$B, 2x2, 0
		piece	0, -$B, 2x2, 0, xflip
		endsprite
		
frame_button_down:
		spritemap
		piece	-$10, -$B, 2x2, 4
		piece	0, -$B, 2x2, 4, xflip
		endsprite
		
frame_button_unk:
		spritemap
		piece	-$10, -$B, 2x2, $FFFC
		piece	0, -$B, 2x2, $7FC
		endsprite
		piece	-8, -8, 2x2, 0
		even
