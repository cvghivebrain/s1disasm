; ---------------------------------------------------------------------------
; Sprite mappings - flapping door (LZ)
; ---------------------------------------------------------------------------
Map_Flap:	index offset(*)
		ptr frame_flap_closed
		ptr frame_flap_halfway
		ptr frame_flap_open
		
frame_flap_closed:
		spritemap
		piece	-8, -$20, 2x4, 0
		piece	-8, 0, 2x4, 0, yflip
		endsprite
		
frame_flap_halfway:
		spritemap
		piece	-5, -$26, 4x4, 8
		piece	-5, 6, 4x4, 8, yflip
		endsprite
		
frame_flap_open:
		spritemap
		piece	0, -$28, 4x2, $18
		piece	0, $18, 4x2, $18, yflip
		endsprite
		even
