; ---------------------------------------------------------------------------
; Sprite mappings - energy balls (FZ)
; ---------------------------------------------------------------------------
		index *
		ptr @fuzzy1
		ptr @fuzzy2
		ptr @white1
		ptr @white2
		ptr @white3
		ptr @white4
		ptr @fuzzy3
		ptr @fuzzy4
		ptr @fuzzy5
		ptr @fuzzy6
		ptr @blank
		
@fuzzy1:	spritemap
		piece	-$10, -$10, 4x2, $7A
		piece	-$10, 0, 4x2, $7A, xflip, yflip
		endsprite
		
@fuzzy2:	spritemap
		piece	-$C, -$C, 2x3, $82
		piece	4, -$C, 1x3, $82, xflip, yflip
		endsprite
		
@white1:	spritemap
		piece	-8, -8, 2x1, $88
		piece	-8, 0, 2x1, $88, yflip
		endsprite
		
@white2:	spritemap
		piece	-8, -8, 2x1, $8A
		piece	-8, 0, 2x1, $8A, yflip
		endsprite
		
@white3:	spritemap
		piece	-8, -8, 2x1, $8C
		piece	-8, 0, 2x1, $8C, yflip
		endsprite
		
@white4:	spritemap
		piece	-$C, -$C, 2x3, $8E
		piece	4, -$C, 1x3, $8E, xflip, yflip
		endsprite
		
@fuzzy3:	spritemap
		piece	-8, -8, 2x2, $94
		endsprite
		
@fuzzy4:	spritemap
		piece	-8, -8, 2x2, $98
		endsprite
		
@fuzzy5:	spritemap
		piece	-$10, -$10, 4x2, $7A, xflip
		piece	-$10, 0, 4x2, $7A, yflip
		endsprite
		
@fuzzy6:	spritemap
		piece	-$C, -$C, 2x3, $82, yflip
		piece	4, -$C, 1x3, $82, xflip
		endsprite
		
@blank:		spritemap
		endsprite
		even
