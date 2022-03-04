; ---------------------------------------------------------------------------
; Sprite mappings - rotating disc that grabs Sonic (SBZ)
; ---------------------------------------------------------------------------
Map_Jun:	index *
		ptr frame_junc_w				; 0
		ptr frame_junc_wsw				; 1
		ptr frame_junc_sw				; 2
		ptr frame_junc_ssw				; 3
		ptr frame_junc_s				; 4
		ptr frame_junc_sse				; 5
		ptr frame_junc_se				; 6
		ptr frame_junc_ese				; 7
		ptr frame_junc_e				; 8
		ptr frame_junc_ene				; 9
		ptr frame_junc_ne				; $A
		ptr frame_junc_nne				; $B
		ptr frame_junc_n				; $C
		ptr frame_junc_nnw				; $D
		ptr frame_junc_nw				; $E
		ptr frame_junc_wnw				; $F
		ptr frame_junc_circle				; $10
		
frame_junc_w:
		spritemap
		piece	-$30, -$18, 2x2, $22
		piece	-$30, 8, 2x2, $22, yflip
		piece	-$38, -$18, 3x3, 0
		piece	-$20, -$18, 3x3, 0, xflip
		piece	-$38, 0, 3x3, 0, yflip
		piece	-$20, 0, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_wsw:
		spritemap
		piece	-$30, -8, 1x4, $26
		piece	-$28, $18, 2x2, $2A
		piece	-$36, -$A, 3x3, 0
		piece	-$1E, -$A, 3x3, 0, xflip
		piece	-$36, $E, 3x3, 0, yflip
		piece	-$1E, $E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_sw:
		spritemap
		piece	-$30, 0, 2x3, $2E
		piece	-$18, $20, 3x2, $34
		piece	-$30, 0, 3x3, 0
		piece	-$18, 0, 3x3, 0, xflip
		piece	-$30, $18, 3x3, 0, yflip
		piece	-$18, $18, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_ssw:
		spritemap
		piece	-$28, 8, 2x4, $3A
		piece	-$10, $28, 3x1, $42
		piece	-$26, 6, 3x3, 0
		piece	-$E, 6, 3x3, 0, xflip
		piece	-$26, $1E, 3x3, 0, yflip
		piece	-$E, $1E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_s:
		spritemap
		piece	-$18, $20, 2x2, $45
		piece	8, $20, 2x2, $45, xflip
		piece	-$18, 8, 3x3, 0
		piece	0, 8, 3x3, 0, xflip
		piece	-$18, $20, 3x3, 0, yflip
		piece	0, $20, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_sse:
		spritemap
		piece	-8, $28, 3x1, $42, xflip
		piece	$18, 8, 2x4, $3A, xflip
		piece	-$A, 6, 3x3, 0
		piece	$E, 6, 3x3, 0, xflip
		piece	-$A, $1E, 3x3, 0, yflip
		piece	$E, $1E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_se:
		spritemap
		piece	0, $20, 3x2, $34, xflip
		piece	$20, 0, 2x3, $2E, xflip
		piece	0, 0, 3x3, 0
		piece	$18, 0, 3x3, 0, xflip
		piece	0, $18, 3x3, 0, yflip
		piece	$18, $18, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_ese:
		spritemap
		piece	$18, $18, 2x2, $2A, xflip
		piece	$28, -8, 1x4, $26, xflip
		piece	6, -$A, 3x3, 0
		piece	$1E, -$A, 3x3, 0, xflip
		piece	6, $E, 3x3, 0, yflip
		piece	$1E, $E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_e:
		spritemap
		piece	$20, -$18, 2x2, $22, xflip
		piece	$20, 8, 2x2, $22, xflip, yflip
		piece	8, -$18, 3x3, 0
		piece	$20, -$18, 3x3, 0, xflip
		piece	8, 0, 3x3, 0, yflip
		piece	$20, 0, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_ene:
		spritemap
		piece	$18, -$28, 2x2, $2A, xflip, yflip
		piece	$28, -$18, 1x4, $26, xflip, yflip
		piece	6, -$26, 3x3, 0
		piece	$1E, -$26, 3x3, 0, xflip
		piece	6, -$E, 3x3, 0, yflip
		piece	$1E, -$E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_ne:
		spritemap
		piece	0, -$30, 3x2, $34, xflip, yflip
		piece	$20, -$18, 2x3, $2E, xflip, yflip
		piece	0, -$30, 3x3, 0
		piece	$18, -$30, 3x3, 0, xflip
		piece	0, -$18, 3x3, 0, yflip
		piece	$18, -$18, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_nne:
		spritemap
		piece	-8, -$30, 3x1, $42, xflip, yflip
		piece	$18, -$28, 2x4, $3A, xflip, yflip
		piece	-$A, -$36, 3x3, 0
		piece	$E, -$36, 3x3, 0, xflip
		piece	-$A, -$1E, 3x3, 0, yflip
		piece	$E, -$1E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_n:
		spritemap
		piece	-$18, -$30, 2x2, $45, yflip
		piece	8, -$30, 2x2, $45, xflip, yflip
		piece	-$18, -$38, 3x3, 0
		piece	0, -$38, 3x3, 0, xflip
		piece	-$18, -$20, 3x3, 0, yflip
		piece	0, -$20, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_nnw:
		spritemap
		piece	-$28, -$28, 2x4, $3A, yflip
		piece	-$10, -$30, 3x1, $42, yflip
		piece	-$26, -$36, 3x3, 0
		piece	-$E, -$36, 3x3, 0, xflip
		piece	-$26, -$1E, 3x3, 0, yflip
		piece	-$E, -$1E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_nw:
		spritemap
		piece	-$30, -$18, 2x3, $2E, yflip
		piece	-$18, -$30, 3x2, $34, yflip
		piece	-$30, -$30, 3x3, 0
		piece	-$18, -$30, 3x3, 0, xflip
		piece	-$30, -$18, 3x3, 0, yflip
		piece	-$18, -$18, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_wnw:
		spritemap
		piece	-$30, -$18, 1x4, $26, yflip
		piece	-$28, -$28, 2x2, $2A, yflip
		piece	-$36, -$26, 3x3, 0
		piece	-$1E, -$26, 3x3, 0, xflip
		piece	-$36, -$E, 3x3, 0, yflip
		piece	-$1E, -$E, 3x3, 0, xflip, yflip
		endsprite
		
frame_junc_circle:
		spritemap
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
