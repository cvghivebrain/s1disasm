; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	Robotnik picks up (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr @wholeblock
		ptr @topleft
		ptr @topright
		ptr @bottomleft
		ptr @bottomright
		
@wholeblock:	spritemap
		piece	-$10, -$10, 4x2, $71
		piece	-$10, 0, 4x2, $79
		endsprite
		dc.b 0
		
@topleft:	spritemap
		piece	-8, -8, 2x2, $71
		endsprite
		
@topright:	spritemap
		piece	-8, -8, 2x2, $75
		endsprite
		
@bottomleft:	spritemap
		piece	-8, -8, 2x2, $79
		endsprite
		
@bottomright:	spritemap
		piece	-8, -8, 2x2, $7D
		endsprite
		even
