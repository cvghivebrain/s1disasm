; ---------------------------------------------------------------------------
; Sprite mappings - rotating disc that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @gap0
		ptr @gap1
		ptr @gap2
		ptr @gap3
		ptr @gap4
		ptr @gap5
		ptr @gap6
		ptr @gap7
		ptr @gap8
		ptr @gap9
		ptr @gapA
		ptr @gapB
		ptr @gapC
		ptr @gapD
		ptr @gapE
		ptr @gapF
		ptr @circle
		
@gap0:		spritemap
		piece	-$30, -$18, 2x2, $22
		piece	-$30, 8, 2x2, $22, yflip
		piece	-$38, -$18, 3x3, 0
		piece	-$20, -$18, 3x3, 0, xflip
		piece	-$38, 0, 3x3, 0, yflip
		piece	-$20, 0, 3x3, 0, xflip, yflip
		endsprite
		
@gap1:		spritemap
		piece	-$30, -8, 1x4, $26
		piece	-$28, $18, 2x2, $2A
		piece	-$36, -$A, 3x3, 0
		piece	-$1E, -$A, 3x3, 0, xflip
		piece	-$36, $E, 3x3, 0, yflip
		piece	-$1E, $E, 3x3, 0, xflip, yflip
		endsprite
		
@gap2:		spritemap
		piece	-$30, 0, 2x3, $2E
		piece	-$18, $20, 3x2, $34
		piece	-$30, 0, 3x3, 0
		piece	-$18, 0, 3x3, 0, xflip
		piece	-$30, $18, 3x3, 0, yflip
		piece	-$18, $18, 3x3, 0, xflip, yflip
		endsprite
		
@gap3:		spritemap
		piece	-$28, 8, 2x4, $3A
		piece	-$10, $28, 3x1, $42
		piece	-$26, 6, 3x3, 0
		piece	-$E, 6, 3x3, 0, xflip
		piece	-$26, $1E, 3x3, 0, yflip
		piece	-$E, $1E, 3x3, 0, xflip, yflip
		endsprite
		
@gap4:		spritemap
		piece	-$18, $20, 2x2, $45
		piece	8, $20, 2x2, $45, xflip
		piece	-$18, 8, 3x3, 0
		piece	0, 8, 3x3, 0, xflip
		piece	-$18, $20, 3x3, 0, yflip
		piece	0, $20, 3x3, 0, xflip, yflip
		endsprite
		
@gap5:		spritemap
		piece	-8, $28, 3x1, $42, xflip
		piece	$18, 8, 2x4, $3A, xflip
		piece	-$A, 6, 3x3, 0
		piece	$E, 6, 3x3, 0, xflip
		piece	-$A, $1E, 3x3, 0, yflip
		piece	$E, $1E, 3x3, 0, xflip, yflip
		endsprite
		
@gap6:		spritemap
		piece	0, $20, 3x2, $34, xflip
		piece	$20, 0, 2x3, $2E, xflip
		piece	0, 0, 3x3, 0
		piece	$18, 0, 3x3, 0, xflip
		piece	0, $18, 3x3, 0, yflip
		piece	$18, $18, 3x3, 0, xflip, yflip
		endsprite
		
@gap7:		spritemap
		piece	$18, $18, 2x2, $2A, xflip
		piece	$28, -8, 1x4, $26, xflip
		piece	6, -$A, 3x3, 0
		piece	$1E, -$A, 3x3, 0, xflip
		piece	6, $E, 3x3, 0, yflip
		piece	$1E, $E, 3x3, 0, xflip, yflip
		endsprite
		
@gap8:		spritemap
		piece	$20, -$18, 2x2, $22, xflip
		piece	$20, 8, 2x2, $22, xflip, yflip
		piece	8, -$18, 3x3, 0
		piece	$20, -$18, 3x3, 0, xflip
		piece	8, 0, 3x3, 0, yflip
		piece	$20, 0, 3x3, 0, xflip, yflip
		endsprite
		
@gap9:		spritemap
		piece	$18, -$28, 2x2, $2A, xflip, yflip
		piece	$28, -$18, 1x4, $26, xflip, yflip
		piece	6, -$26, 3x3, 0
		piece	$1E, -$26, 3x3, 0, xflip
		piece	6, -$E, 3x3, 0, yflip
		piece	$1E, -$E, 3x3, 0, xflip, yflip
		endsprite
		
@gapA:		spritemap
		piece	0, -$30, 3x2, $34, xflip, yflip
		piece	$20, -$18, 2x3, $2E, xflip, yflip
		piece	0, -$30, 3x3, 0
		piece	$18, -$30, 3x3, 0, xflip
		piece	0, -$18, 3x3, 0, yflip
		piece	$18, -$18, 3x3, 0, xflip, yflip
		endsprite
		
@gapB:		spritemap
		piece	-8, -$30, 3x1, $42, xflip, yflip
		piece	$18, -$28, 2x4, $3A, xflip, yflip
		piece	-$A, -$36, 3x3, 0
		piece	$E, -$36, 3x3, 0, xflip
		piece	-$A, -$1E, 3x3, 0, yflip
		piece	$E, -$1E, 3x3, 0, xflip, yflip
		endsprite
		
@gapC:		spritemap
		piece	-$18, -$30, 2x2, $45, yflip
		piece	8, -$30, 2x2, $45, xflip, yflip
		piece	-$18, -$38, 3x3, 0
		piece	0, -$38, 3x3, 0, xflip
		piece	-$18, -$20, 3x3, 0, yflip
		piece	0, -$20, 3x3, 0, xflip, yflip
		endsprite
		
@gapD:		spritemap
		piece	-$28, -$28, 2x4, $3A, yflip
		piece	-$10, -$30, 3x1, $42, yflip
		piece	-$26, -$36, 3x3, 0
		piece	-$E, -$36, 3x3, 0, xflip
		piece	-$26, -$1E, 3x3, 0, yflip
		piece	-$E, -$1E, 3x3, 0, xflip, yflip
		endsprite
		
@gapE:		spritemap
		piece	-$30, -$18, 2x3, $2E, yflip
		piece	-$18, -$30, 3x2, $34, yflip
		piece	-$30, -$30, 3x3, 0
		piece	-$18, -$30, 3x3, 0, xflip
		piece	-$30, -$18, 3x3, 0, yflip
		piece	-$18, -$18, 3x3, 0, xflip, yflip
		endsprite
		
@gapF:		spritemap
		piece	-$30, -$18, 1x4, $26, yflip
		piece	-$28, -$28, 2x2, $2A, yflip
		piece	-$36, -$26, 3x3, 0
		piece	-$1E, -$26, 3x3, 0, xflip
		piece	-$36, -$E, 3x3, 0, yflip
		piece	-$1E, -$E, 3x3, 0, xflip, yflip
		endsprite
		
@circle:	spritemap
		piece	-$20, -$38, 4x2, 9
		piece	-$30, -$30, 3x3, $11
		piece	-$38, -$20, 2x4, $1A
		piece	0, -$38, 4x2, 9, xflip
		piece	$18, -$30, 3x3, $11, xflip
		piece	$28, -$20, 2x4, $1A, xflip
		piece	-$38, 0, 2x4, $1A, yflip
		piece	-$30, $18, 3x3, $11, yflip
		piece	-$20, $28, 4x2, 9, yflip
		piece	0, $28, 4x2, 9, xflip, yflip
		piece	$18, $18, 3x3, $11, xflip, yflip
		piece	$28, 0, 2x4, $1A, xflip, yflip
		endsprite
		even
