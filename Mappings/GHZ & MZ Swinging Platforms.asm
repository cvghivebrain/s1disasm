; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	and MZ swinging	platforms
; ---------------------------------------------------------------------------
		index *
		ptr @block
		ptr @chain
		ptr @anchor
		
@block:		spritemap
		piece	-$18, -8, 3x2, 4
		piece	0, -8, 3x2, 4
		endsprite
		
@chain:		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
@anchor:	spritemap
		piece	-8, -8, 2x2, $A
		endsprite
		even
