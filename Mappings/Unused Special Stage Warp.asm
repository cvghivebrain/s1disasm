; ---------------------------------------------------------------------------
; Sprite mappings - special stage entry	from beta
; ---------------------------------------------------------------------------
Map_Vanish:	index *
		ptr frame_vanish_flash1
		ptr frame_vanish_flash2
		ptr frame_vanish_flash3
		ptr frame_vanish_sparkle1
		ptr frame_vanish_sparkle2
		ptr frame_vanish_sparkle3
		ptr frame_vanish_sparkle4
		ptr frame_vanish_blank
		
frame_vanish_flash1:
		spritemap
		piece	8, -8, 1x1, 0
		piece	0, 0, 2x1, 1
		piece	8, 8, 1x1, 0, yflip
		endsprite
		
frame_vanish_flash2:
		spritemap
		piece	-$10, -$10, 4x2, 3
		piece	-$10, 0, 4x1, $B
		piece	-$10, 8, 4x2, 3, yflip
		endsprite
		
frame_vanish_flash3:
		spritemap
		piece	-$C, -$1C, 4x3, $F
		piece	-$14, -$14, 1x3, $1B
		piece	-$C, -4, 4x1, $1E
		piece	-$C, 4, 4x3, $F, yflip
		piece	-$14, 4, 1x2, $1B, yflip
		endsprite
		
frame_vanish_sparkle1:
		spritemap
		piece	-8, -$10, 3x1, $22
		piece	-$10, -8, 4x3, $25
		piece	-$10, $10, 3x1, $31
		piece	$10, 0, 2x2, $34
		piece	$10, -8, 1x1, $25, xflip
		piece	$18, -$10, 1x1, $36, xflip, yflip
		piece	$20, -8, 1x1, $25, xflip, yflip
		piece	$28, 0, 1x1, $25, xflip
		piece	$30, -8, 1x1, $25
		endsprite
		
frame_vanish_sparkle2:
		spritemap
		piece	-$10, 0, 1x1, $25, xflip, yflip
		piece	-8, -8, 2x1, $38
		piece	8, -$10, 1x1, $26
		piece	0, 0, 1x1, $25
		piece	-8, 8, 1x1, $25, xflip, yflip
		piece	0, $10, 1x1, $26, yflip
		piece	8, 8, 1x1, $38, yflip
		piece	$10, -8, 1x1, $29
		piece	$10, 0, 1x1, $26
		piece	$18, 0, 1x1, $2D
		piece	$18, 8, 1x1, $26, xflip
		piece	$20, 8, 1x1, $29
		piece	$20, -8, 1x1, $26
		piece	$28, -8, 1x1, $2D
		piece	$28, 0, 1x1, $3A
		piece	$30, -8, 1x1, $26, xflip, yflip
		piece	$38, 0, 1x1, $25, yflip
		piece	$40, -8, 1x1, $25, yflip
		endsprite
		
frame_vanish_sparkle3:
		spritemap
		piece	0, -8, 1x1, $25, xflip
		piece	$10, -$10, 1x1, $38
		piece	0, $10, 1x1, $25, xflip
		piece	$10, 0, 1x1, $25, xflip, yflip
		piece	$18, 8, 1x1, $25, yflip
		piece	$20, -8, 1x1, $25, xflip, yflip
		piece	$28, 0, 1x1, $26, yflip
		piece	$30, -8, 1x1, $25, yflip
		piece	$30, 0, 1x1, $25
		piece	$30, 8, 1x1, $25, xflip
		piece	$38, 0, 1x1, $26, xflip
		piece	$38, 8, 1x1, $29
		piece	$40, -8, 1x1, $26, xflip
		piece	$40, 0, 1x1, $2D
		piece	$48, -8, 1x1, $25, xflip
		piece	$48, 0, 1x1, $25
		piece	$50, 0, 1x1, $25, yflip
		endsprite
		
frame_vanish_sparkle4:
		spritemap
		piece	$30, -4, 1x1, $26, xflip
		piece	$28, 4, 1x1, $25, xflip
		piece	$38, 4, 1x1, $27, yflip
		piece	$40, 4, 1x1, $26, xflip
		piece	$40, -4, 1x1, $25, yflip
		piece	$48, -4, 1x1, $26, yflip
		piece	$48, $C, 1x1, $27, xflip
		piece	$50, 4, 1x1, $26, xflip, yflip
frame_vanish_blank: equ	*+1
		piece	$58, 4, 1x1, $27, xflip
		endsprite
		even
