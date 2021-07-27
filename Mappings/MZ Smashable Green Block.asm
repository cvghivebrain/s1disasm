; ---------------------------------------------------------------------------
; Sprite mappings - smashable green block (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @two
		ptr @four
		
@two:		spritemap			; two fragments, arranged vertically
		piece	-$10, -$10, 4x2, 0
		piece	-$10, 0, 4x2, 0
		endsprite
		
@four:		spritemap			; four fragments
		piece	-$10, -$10, 2x2, 0, hi
		piece	-$10, 0, 2x2, 0, hi
		piece	0, -$10, 2x2, 0, hi
		piece	0, 0, 2x2, 0, hi
		endsprite
		even
