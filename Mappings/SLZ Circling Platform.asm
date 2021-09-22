; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	in circles (SLZ)
; ---------------------------------------------------------------------------
Map_Circ:	index *
		ptr frame_circ_platform
		
frame_circ_platform:
		spritemap
		piece	-$18, -8, 3x2, $51
		piece	0, -8, 3x2, $51, xflip
		endsprite
		even
