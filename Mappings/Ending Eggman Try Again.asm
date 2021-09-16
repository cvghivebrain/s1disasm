; ---------------------------------------------------------------------------
; Sprite mappings - Robotnik on	the "TRY AGAIN"	and "END" screens
; ---------------------------------------------------------------------------
Map_EEgg:	index *
		ptr frame_eegg_juggle1
		ptr frame_eegg_juggle2
		ptr frame_eegg_juggle3
		ptr frame_eegg_juggle4
		ptr frame_eegg_end1
		ptr frame_eegg_end2
		ptr frame_eegg_end3
		ptr frame_eegg_end4
		
frame_eegg_juggle1:				; Eggman juggling chaos emeralds
		spritemap
		piece	-$10, -$17, 2x2, 0
		piece	-$20, -7, 4x1, 4
		piece	0, -$17, 2x1, 8
		piece	0, -$F, 4x2, $A
		piece	-$10, 1, 2x3, $23
		piece	0, 1, 2x3, $23, xflip
		piece	-$14, $18, 2x1, $29
		piece	4, $18, 2x1, $29, xflip
		endsprite
		
frame_eegg_juggle2:
		spritemap
		piece	-$20, -$18, 4x2, $12
		piece	-$18, -8, 3x1, $1A
		piece	0, -$18, 2x2, 0, xflip
		piece	0, -8, 4x1, 4, xflip
		piece	-$10, 0, 2x3, $1D
		piece	0, 0, 2x3, $1D, xflip
		piece	-$14, $18, 2x1, $29
		piece	4, $18, 2x1, $29, xflip
		endsprite
		
frame_eegg_juggle3:
		spritemap
		piece	-$10, -$17, 2x1, 8, xflip
		piece	-$20, -$F, 4x2, $A, xflip
		piece	0, -$17, 2x2, 0, xflip
		piece	0, -7, 4x1, 4, xflip
		piece	-$10, 1, 2x3, $23
		piece	0, 1, 2x3, $23, xflip
		piece	-$14, $18, 2x1, $29
		piece	4, $18, 2x1, $29, xflip
		endsprite
		
frame_eegg_juggle4:
		spritemap
		piece	-$10, -$18, 2x2, 0
		piece	-$20, -8, 4x1, 4
		piece	0, -$18, 4x2, $12, xflip
		piece	0, -8, 3x1, $1A, xflip
		piece	-$10, 0, 2x3, $1D
		piece	0, 0, 2x3, $1D, xflip
		piece	-$14, $18, 2x1, $29
		piece	4, $18, 2x1, $29, xflip
		endsprite
		
frame_eegg_end1:				; Eggman jumping on the word "end"
		spritemap
		piece	-$18, -$13, 3x3, $2B
		piece	-$20, -$B, 1x1, $34
		piece	-$10, 5, 2x1, $35
		piece	-$18, $D, 3x1, $37
		piece	0, -$13, 3x3, $2B, xflip
		piece	$18, -$B, 1x1, $34, xflip
		piece	0, 5, 2x1, $35, xflip
		piece	0, $D, 3x1, $37, xflip
		piece	-$20, $10, 4x2, $73
		piece	0, $10, 4x2, $7B
		piece	-$20, $1C, 4x1, $5B
		piece	0, $1C, 4x1, $5B, xflip
		endsprite
		
frame_eegg_end2:
		spritemap
		piece	-$10, -$2E, 2x4, $3A
		piece	-$18, -$26, 1x1, $42
		piece	-$10, -$E, 2x4, $43
		piece	0, -$2E, 2x4, $3A, xflip
		piece	$10, -$26, 1x1, $42, xflip
		piece	0, -$E, 2x4, $43, xflip
		piece	-$18, $10, 4x2, $67
		piece	8, $10, 2x2, $6F
		piece	-$20, $1C, 4x1, $5F
		piece	0, $1C, 4x1, $5F, xflip
		endsprite
		
frame_eegg_end3:
		spritemap
		piece	-$18, -$3C, 3x4, $4B
		piece	-$18, -$1C, 3x1, $57
		piece	-$10, -$14, 1x1, $5A
		piece	0, -$3C, 3x4, $4B, xflip
		piece	0, -$1C, 3x1, $57, xflip
		piece	8, -$14, 1x1, $5A, xflip
		piece	-$18, $10, 4x2, $67
		piece	8, $10, 2x2, $6F
		piece	-$20, $1C, 4x1, $63
		piece	0, $1C, 4x1, $63, xflip
		endsprite
		
frame_eegg_end4:
		spritemap
		piece	-$18, -$C, 3x3, $2B
		piece	-$20, -4, 1x1, $34
		piece	-$10, $C, 2x1, $35
		piece	-$18, $14, 3x1, $37
		piece	0, -$C, 3x3, $2B, xflip
		piece	$18, -4, 1x1, $34, xflip
		piece	0, $C, 2x1, $35, xflip
		piece	0, $14, 3x1, $37, xflip
		piece	-$20, $18, 4x1, $83
		piece	0, $18, 4x1, $87
		piece	-$20, $1C, 4x1, $5B
		piece	0, $1C, 4x1, $5B, xflip
		endsprite
		even
