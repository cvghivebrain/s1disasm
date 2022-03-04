; ---------------------------------------------------------------------------
; Sprite mappings - smashable green block (MZ)
; ---------------------------------------------------------------------------
Map_Smab:	index *
		ptr frame_smash_two
		ptr frame_smash_four
		
frame_smash_two:
		spritemap					; two fragments, arranged vertically
		piece	-$10, -$10, 4x2, 0
		piece	-$10, 0, 4x2, 0
		endsprite
		
frame_smash_four:
		spritemap					; four fragments
		piece	-$10, -$10, 2x2, 0, hi
		piece	-$10, 0, 2x2, 0, hi
		piece	0, -$10, 2x2, 0, hi
		piece	0, 0, 2x2, 0, hi
		endsprite
		even
