; ---------------------------------------------------------------------------
; Sprite mappings - lamppost
; ---------------------------------------------------------------------------
		index *
		ptr @blue
		ptr @poleonly
		ptr @redballonly
		ptr @red
		
@blue:		spritemap
		piece	-8, -$1C, 1x2, 0
		piece	0, -$1C, 1x2, 0, xflip
		piece	-8, -$C, 1x4, 2, pal2
		piece	0, -$C, 1x4, 2, xflip, pal2
		piece	-8, -$2C, 1x2, 6
		piece	0, -$2C, 1x2, 6, xflip
		endsprite
		
@poleonly:	spritemap
		piece	-8, -$1C, 1x2, 0
		piece	0, -$1C, 1x2, 0, xflip
		piece	-8, -$C, 1x4, 2, pal2
		piece	0, -$C, 1x4, 2, xflip, pal2
		endsprite
		
@redballonly:	spritemap
		piece	-8, -8, 1x2, 8
		piece	0, -8, 1x2, 8, xflip
		endsprite
		
@red:		spritemap
		piece	-8, -$1C, 1x2, 0
		piece	0, -$1C, 1x2, 0, xflip
		piece	-8, -$C, 1x4, 2, pal2
		piece	0, -$C, 1x4, 2, xflip, pal2
		piece	-8, -$2C, 1x2, 8
		piece	0, -$2C, 1x2, 8, xflip
		endsprite
		even
