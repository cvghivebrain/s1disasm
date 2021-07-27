; ---------------------------------------------------------------------------
; Sprite mappings - extra boss items (e.g. swinging ball on a chain in GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr @chainanchor1
		ptr @chainanchor2
		ptr @cross
		ptr @widepipe
		ptr @pipe
		ptr @spike
		ptr @legmask
		ptr @legs
		
@chainanchor1:	spritemap			; GHZ boss
		piece	-8, -8, 2x2, 0
		endsprite
		
@chainanchor2:	spritemap			; GHZ boss
		piece	-8, -4, 2x1, 4
		piece	-8, -8, 2x2, 0
		endsprite
		even
		
@cross:		spritemap			; unknown
		piece	-4, -4, 1x1, 6
		endsprite
		
@widepipe:	spritemap			; SLZ boss
		piece	-$C, $14, 3x2, 7
		endsprite
		
@pipe:		spritemap			; MZ boss
		piece	-8, $14, 2x2, $D
		endsprite
		
@spike:		spritemap			; SYZ boss
		piece	-8, -$10, 2x1, $11
		piece	-8, -8, 1x2, $13
		piece	0, -8, 1x2, $13, xflip
		piece	-8, 8, 2x1, $15
		endsprite
		even
		
@legmask:	spritemap			; FZ post-boss: sprite covering part of legs
		piece	0, 0, 2x2, $17
		piece	$10, 0, 1x1, $1B
		endsprite
		even
		
@legs:		spritemap			; FZ post-boss
		piece	0, $18, 2x1, $1C
		piece	$10, 0, 3x4, $1E
		endsprite
		even
