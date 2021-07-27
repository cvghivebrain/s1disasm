; ---------------------------------------------------------------------------
; Sprite mappings - lava geyser / lava that falls from the ceiling (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @bubble1
		ptr @bubble2
		ptr @bubble3
		ptr @bubble4
		ptr @bubble5
		ptr @bubble6
		ptr @end1
		ptr @end2
		ptr @medcolumn1
		ptr @medcolumn2
		ptr @medcolumn3
		ptr @shortcolumn1
		ptr @shortcolumn2
		ptr @shortcolumn3
		ptr @longcolumn1
		ptr @longcolumn2
		ptr @longcolumn3
		ptr @bubble7
		ptr @bubble8
		ptr @blank
		
@bubble1:	spritemap
		piece	-$18, -$14, 3x4, 0
		piece	0, -$14, 3x4, 0, xflip
		endsprite
		
@bubble2:	spritemap
		piece	-$18, -$14, 3x4, $18
		piece	0, -$14, 3x4, $18, xflip
		endsprite
		
@bubble3:	spritemap
		piece	-$38, -$14, 3x4, 0
		piece	-$20, -$C, 4x3, $C
		piece	0, -$C, 4x3, $C, xflip
		piece	$20, -$14, 3x4, 0, xflip
		endsprite
		
@bubble4:	spritemap
		piece	-$38, -$14, 3x4, $18
		piece	-$20, -$C, 4x3, $24
		piece	0, -$C, 4x3, $24, xflip
		piece	$20, -$14, 3x4, $18, xflip
		endsprite
		
@bubble5:	spritemap
		piece	-$38, -$14, 3x4, 0
		piece	-$20, -$C, 4x3, $C
		piece	0, -$C, 4x3, $C, xflip
		piece	$20, -$14, 3x4, 0, xflip
		piece	-$20, -$18, 4x3, $90
		piece	0, -$18, 4x3, $90, xflip
		endsprite
		
@bubble6:	spritemap
		piece	-$38, -$14, 3x4, $18
		piece	-$20, -$C, 4x3, $24
		piece	0, -$C, 4x3, $24, xflip
		piece	$20, -$14, 3x4, $18, xflip
		piece	-$20, -$18, 4x3, $90, xflip
		piece	0, -$18, 4x3, $90
		endsprite
		
@end1:		spritemap
		piece	-$20, -$20, 4x4, $30
		piece	0, -$20, 4x4, $30, xflip
		endsprite
		
@end2:		spritemap
		piece	-$20, -$20, 4x4, $30, xflip
		piece	0, -$20, 4x4, $30
		endsprite
		
@medcolumn1:	spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		piece	-$20, -$10, 4x4, $40
		piece	0, -$10, 4x4, $40, xflip
		piece	-$20, $10, 4x4, $40
		piece	0, $10, 4x4, $40, xflip
		endsprite
		
@medcolumn2:	spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		piece	-$20, -$10, 4x4, $50
		piece	0, -$10, 4x4, $50, xflip
		piece	-$20, $10, 4x4, $50
		piece	0, $10, 4x4, $50, xflip
		endsprite
		
@medcolumn3:	spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		piece	-$20, -$10, 4x4, $60
		piece	0, -$10, 4x4, $60, xflip
		piece	-$20, $10, 4x4, $60
		piece	0, $10, 4x4, $60, xflip
		endsprite
		
@shortcolumn1:	spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		endsprite
		
@shortcolumn2:	spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		endsprite
		
@shortcolumn3:	spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		endsprite
		
@longcolumn1:	spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		piece	-$20, -$10, 4x4, $40
		piece	0, -$10, 4x4, $40, xflip
		piece	-$20, $10, 4x4, $40
		piece	0, $10, 4x4, $40, xflip
		piece	-$20, $30, 4x4, $40
		piece	0, $30, 4x4, $40, xflip
		piece	-$20, $50, 4x4, $40
		piece	0, $50, 4x4, $40, xflip
		piece	-$20, $70, 4x4, $40
		piece	0, $70, 4x4, $40, xflip
		endsprite
		
@longcolumn2:	spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		piece	-$20, -$10, 4x4, $50
		piece	0, -$10, 4x4, $50, xflip
		piece	-$20, $10, 4x4, $50
		piece	0, $10, 4x4, $50, xflip
		piece	-$20, $30, 4x4, $50
		piece	0, $30, 4x4, $50, xflip
		piece	-$20, $50, 4x4, $50
		piece	0, $50, 4x4, $50, xflip
		piece	-$20, $70, 4x4, $50
		piece	0, $70, 4x4, $50, xflip
		endsprite
		
@longcolumn3:	spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		piece	-$20, -$10, 4x4, $60
		piece	0, -$10, 4x4, $60, xflip
		piece	-$20, $10, 4x4, $60
		piece	0, $10, 4x4, $60, xflip
		piece	-$20, $30, 4x4, $60
		piece	0, $30, 4x4, $60, xflip
		piece	-$20, $50, 4x4, $60
		piece	0, $50, 4x4, $60, xflip
		piece	-$20, $70, 4x4, $60
		piece	0, $70, 4x4, $60, xflip
		endsprite
		
@bubble7:	spritemap
		piece	-$38, -$20, 3x4, 0
		piece	-$20, -$18, 4x3, $C
		piece	0, -$18, 4x3, $C, xflip
		piece	$20, -$20, 3x4, 0, xflip
		piece	-$20, -$28, 4x3, $90
		piece	0, -$28, 4x3, $90, xflip
		endsprite
		
@bubble8:	spritemap
		piece	-$38, -$20, 3x4, $18
		piece	-$20, -$18, 4x3, $24
		piece	0, -$18, 4x3, $24, xflip
		piece	$20, -$20, 3x4, $18, xflip
		piece	-$20, -$28, 4x3, $90, xflip
		piece	0, -$28, 4x3, $90
		endsprite
		
@blank:		spritemap
		endsprite
		even
