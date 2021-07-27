; ---------------------------------------------------------------------------
; Sprite mappings - metal stomping blocks on chains (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @wideblock
		ptr @spikes
		ptr @ceiling
		ptr @chain1
		ptr @chain2
		ptr @chain3
		ptr @chain4
		ptr @chain5
		ptr @chain5
		ptr @mediumblock
		ptr @smallblock
		
@wideblock:	spritemap
		piece	-$38, -$C, 2x3, 0
		piece	-$28, -$C, 3x3, 6
		piece	-$10, -$14, 4x4, $F
		piece	$10, -$C, 3x3, 6, xflip
		piece	$28, -$C, 2x3, 0, xflip
		endsprite
		
@spikes:	spritemap
		piece	-$2C, -$10, 1x4, $21F, yflip
		piece	-$18, -$10, 1x4, $21F, yflip
		piece	-4, -$10, 1x4, $21F, yflip
		piece	$10, -$10, 1x4, $21F, yflip
		piece	$24, -$10, 1x4, $21F, yflip
		endsprite
		
@ceiling:	spritemap
		piece	-$10, -$24, 4x4, $F, yflip
		endsprite
		
@chain1:	spritemap
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
@chain2:	spritemap
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
@chain3:	spritemap
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
@chain4:	spritemap
		piece	-4, -$60, 1x2, $3F
		piece	-4, -$50, 1x2, $3F
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
@chain5:	spritemap
		piece	-4, -$80, 1x2, $3F
		piece	-4, -$70, 1x2, $3F
		piece	-4, -$60, 1x2, $3F
		piece	-4, -$50, 1x2, $3F
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
@mediumblock:	spritemap
		piece	-$30, -$C, 2x3, 0
		piece	-$20, -$C, 3x3, 6
		piece	8, -$C, 3x3, 6, xflip
		piece	$20, -$C, 2x3, 0, xflip
		piece	-$10, -$14, 4x4, $F
		endsprite
		
@smallblock:	spritemap
		piece	-$10, -$14, 4x4, $2F
		endsprite
		even
