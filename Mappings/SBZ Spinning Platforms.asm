; ---------------------------------------------------------------------------
; Sprite mappings - spinning platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Spin:	index *
		ptr frame_spin_flat
		ptr frame_spin_1
		ptr frame_spin_2
		ptr frame_spin_3
		ptr frame_spin_4
		
frame_spin_flat:
		spritemap
		piece	-$10, -8, 2x2, 0
		piece	0, -8, 2x2, 0, xflip
		endsprite
		
frame_spin_1:
		spritemap
		piece	-$10, -$10, 4x2, $14
		piece	-$10, 0, 4x2, $1C
		endsprite
		
frame_spin_2:
		spritemap
		piece	-$10, -$10, 3x2, 4
		piece	-8, 0, 3x2, $A
		endsprite
		
frame_spin_3:
		spritemap
		piece	-$10, -$10, 3x2, $24
		piece	-8, 0, 3x2, $2A
		endsprite
		
frame_spin_4:
		spritemap
		piece	-8, -$10, 2x2, $10
		piece	-8, 0, 2x2, $10, yflip
		endsprite
		even
