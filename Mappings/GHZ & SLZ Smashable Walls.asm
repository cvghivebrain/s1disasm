; ---------------------------------------------------------------------------
; Sprite mappings - smashable walls (GHZ, SLZ)
; ---------------------------------------------------------------------------
Map_Smash:	index *
		ptr frame_smash_left
		ptr frame_smash_middle
		ptr frame_smash_right
		
frame_smash_left:
		spritemap
		piece	-$10, -$20, 2x2, 0
		piece	-$10, -$10, 2x2, 0
		piece	-$10, 0, 2x2, 0
		piece	-$10, $10, 2x2, 0
		piece	0, -$20, 2x2, 4
		piece	0, -$10, 2x2, 4
		piece	0, 0, 2x2, 4
		piece	0, $10, 2x2, 4
		endsprite
		
frame_smash_middle:
		spritemap
		piece	-$10, -$20, 2x2, 4
		piece	-$10, -$10, 2x2, 4
		piece	-$10, 0, 2x2, 4
		piece	-$10, $10, 2x2, 4
		piece	0, -$20, 2x2, 4
		piece	0, -$10, 2x2, 4
		piece	0, 0, 2x2, 4
		piece	0, $10, 2x2, 4
		endsprite
		
frame_smash_right:
		spritemap
		piece	-$10, -$20, 2x2, 4
		piece	-$10, -$10, 2x2, 4
		piece	-$10, 0, 2x2, 4
		piece	-$10, $10, 2x2, 4
		piece	0, -$20, 2x2, 8
		piece	0, -$10, 2x2, 8
		piece	0, 0, 2x2, 8
		piece	0, $10, 2x2, 8
		endsprite
		even
