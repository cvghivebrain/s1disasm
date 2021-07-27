; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
		index *
		ptr @blank
		ptr @10000
		ptr @1000
		ptr @100
		
@blank:		spritemap
		endsprite
		
@10000:		spritemap
		piece	-$10, -$C, 4x3, 0
		endsprite
		
@1000:		spritemap
		piece	-$10, -$C, 4x3, $C
		endsprite
		
@100:		spritemap
		piece	-$10, -$C, 4x3, $18
		endsprite
		even
