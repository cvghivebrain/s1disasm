; ---------------------------------------------------------------------------
; Sprite mappings - shield and invincibility stars
; ---------------------------------------------------------------------------
		index *
		ptr @shield1
		ptr @shield2
		ptr @shield3
		ptr @shield4
		ptr @stars1
		ptr @stars2
		ptr @stars3
		ptr @stars4
		
@shield2:	spritemap
		piece	-$18, -$18, 3x3, 0
		piece	0, -$18, 3x3, 9
@shield1:	piece	-$18, 0, 3x3, 0, yflip
		piece	0, 0, 3x3, 9, yflip
		endsprite
		
@shield3:	spritemap
		piece	-$17, -$18, 3x3, $12, xflip
		piece	0, -$18, 3x3, $12
		piece	-$17, 0, 3x3, $12, xflip, yflip
		piece	0, 0, 3x3, $12, yflip
		endsprite
		
@shield4:	spritemap
		piece	-$18, -$18, 3x3, 9, xflip
		piece	0, -$18, 3x3, 0, xflip
		piece	-$18, 0, 3x3, 9, xflip, yflip
		piece	0, 0, 3x3, 0, xflip, yflip
		endsprite

@stars1:	spritemap
		piece	-$18, -$18, 3x3, 0
		piece	0, -$18, 3x3, 9
		piece	-$18, 0, 3x3, 9, xflip, yflip
		piece	0, 0, 3x3, 0, xflip, yflip
		endsprite
		
@stars2:	spritemap
		piece	-$18, -$18, 3x3, 9, xflip
		piece	0, -$18, 3x3, 0, xflip
		piece	-$18, 0, 3x3, 0, yflip
		piece	0, 0, 3x3, 9, yflip
		endsprite
		
@stars3:	spritemap
		piece	-$18, -$18, 3x3, $12
		piece	0, -$18, 3x3, $1B
		piece	-$18, 0, 3x3, $1B, xflip, yflip
		piece	0, 0, 3x3, $12, xflip, yflip
		endsprite
		
@stars4:	spritemap
		piece	-$18, -$18, 3x3, $1B, xflip
		piece	0, -$18, 3x3, $12, xflip
		piece	-$18, 0, 3x3, $12, yflip
		piece	0, 0, 3x3, $1B, yflip
		endsprite
		even
