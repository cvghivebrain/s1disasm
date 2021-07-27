; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	disintegrate when Eggman presses a switch
; ---------------------------------------------------------------------------
		index *
		ptr @wholeblock
		ptr @topleft
		ptr @topright
		ptr @bottomleft
		ptr @bottomright
		
@wholeblock:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
@topleft:	spritemap
		piece	-8, -8, 1x2, 0
		piece	0, -8, 1x2, 4
		endsprite
		dc.b 0
		
@topright:	spritemap
		piece	-8, -8, 1x2, 8
		piece	0, -8, 1x2, $C
		endsprite
		dc.b 0
		
@bottomleft:	spritemap
		piece	-8, -8, 1x2, 2
		piece	0, -8, 1x2, 6
		endsprite
		dc.b 0
		
@bottomright:	spritemap
		piece	-8, -8, 1x2, $A
		piece	0, -8, 1x2, $E
		endsprite
		even
