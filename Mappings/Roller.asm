; ---------------------------------------------------------------------------
; Sprite mappings - Roller enemy (SYZ)
; ---------------------------------------------------------------------------
Map_Roll:	index *
		ptr frame_roll_stand
		ptr frame_roll_fold
		ptr frame_roll_roll1
		ptr frame_roll_roll2
		ptr frame_roll_roll3
		
frame_roll_stand:
		spritemap			; standing
		piece	-$10, -$22, 4x3, 0
		piece	-$10, -$A, 4x3, $C
		endsprite
		
frame_roll_fold:
		spritemap			; folding
		piece	-$10, -$1A, 4x3, 0
		piece	-$10, -2, 4x2, $18
		endsprite
		
frame_roll_roll1:
		spritemap			; rolling
		piece	-$10, -$10, 4x4, $20
		endsprite
		
frame_roll_roll2:
		spritemap			; rolling
		piece	-$10, -$10, 4x4, $30
		endsprite
		
frame_roll_roll3:
		spritemap			; rolling
		piece	-$10, -$10, 4x4, $40
		endsprite
		even
