; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	in circles (SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @platform
		
@platform:	spritemap
		piece	-$18, -8, 3x2, $51
		piece	0, -8, 3x2, $51, xflip
		endsprite
		even
