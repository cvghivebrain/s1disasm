; ---------------------------------------------------------------------------
; Sprite mappings - Sonic on the ending	sequence
; ---------------------------------------------------------------------------
		index *
		ptr @Hold1
		ptr @Hold2
		ptr @Up
		ptr @Conf1
		ptr @Conf2
		ptr @Leap1
		ptr @Leap2
		ptr @Leap3
		
@Hold1:		spritemap			; holding emeralds
		piece	-8, -$14, 3x4, 0
		piece	-$10, $C, 4x1, $C
		endsprite
		
@Hold2:		spritemap 			; holding emeralds (glowing)
		piece	-$10, -4, 4x2, $10
		piece	-8, -$14, 3x4, 0
		piece	-$10, $C, 4x1, $C
		endsprite
		
@Up:		spritemap 			; looking up
		piece	-8, -$14, 3x2, $18
		piece	-$10, -4, 4x3, $1E
		endsprite
		
@Conf1:		spritemap 			; confused
		piece	-8, -$14, 3x2, $2A
		piece	-$10, -4, 4x3, $30
		endsprite
		
@Conf2:		spritemap 			; confused #2
		piece	-$10, -$14, 3x2, $2A, xflip
		piece	-$10, -4, 4x3, $30, xflip
		endsprite
		
@Leap1:		spritemap 			; leaping
		piece	-$10, -$14, 2x3, $3C
		piece	0, -$14, 2x3, $3C, xflip
		piece	-$10, 4, 4x2, $42
		endsprite
		
@Leap2:		spritemap			; leaping #2
		piece	-8, -$4E, 4x1, $4A
		piece	-$10, -$46, 4x4, $4E
		piece	$10, -$46, 2x2, $5E
		piece	$10, -$36, 1x3, $62
		piece	-$10, -$26, 4x1, $65
		piece	-8, -$1E, 3x1, $69
		piece	-8, -$16, 2x2, $6C
		endsprite
		
@Leap3:		spritemap 			; leaping #3
		piece	-8, -$80, 4x4, $70
		piece	-$20, -$70, 3x4, $80
		piece	$18, -$70, 3x4, $8C
		piece	$30, -$68, 3x4, $98
		piece	$58, -$60, 4x4, $A4
		piece	-$10, -$78, 1x1, $B4
		piece	$18, -$80, 2x2, $B5
		piece	-8, -$60, 4x4, $B9
		piece	-$20, -$50, 3x4, $C9
		piece	$38, -$48, 4x4, $D5
		piece	$48, -$58, 2x2, $E5
		piece	$58, -$40, 1x3, $E9
		piece	-8, -$40, 4x4, $EC
		piece	$18, -$48, 4x4, $FC
		piece	$18, -$50, 3x1, $10C
		piece	$30, -$28, 4x2, $10F
		piece	$18, -$28, 3x1, $117
		piece	-$28, -$28, 4x4, $11A
		piece	-8, -$20, 4x2, $12A
		piece	$28, -$20, 1x1, $132
		piece	-$20, -$30, 2x1, $133
		piece	-$38, -$18, 2x2, $135
		piece	-$38, -8, 4x1, $139
		piece	-8, -$10, 2x3, $13D
		endsprite
		even
