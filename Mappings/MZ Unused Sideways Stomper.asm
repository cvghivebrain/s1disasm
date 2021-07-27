; ---------------------------------------------------------------------------
; Sprite mappings - spiked metal block from beta version (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @block
		ptr @spikes
		ptr @wallbracket
		ptr @pole1
		ptr @pole2
		ptr @pole3
		ptr @pole4
		ptr @pole5
		ptr @pole5
		
@block:		spritemap		; main metal block
		piece	-$C, -$20, 3x4, $1F
		piece	-$C, 0, 3x4, $1F, yflip
		piece	$C, -$10, 1x4, $2B
		endsprite
		
@spikes:	spritemap		; three spikes
		piece	-$10, -$18, 4x1, $21B, yflip
		piece	-$10, -4, 4x1, $21B, yflip
		piece	-$10, $10, 4x1, $21B, yflip
		endsprite
		
@wallbracket:	spritemap		; thing holding it to the wall
		piece	-4, -$10, 1x4, $2B, xflip
		endsprite
		
@pole1:		spritemap		; poles of various lengths
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		endsprite
		
@pole2:		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		endsprite
		
@pole3:		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		endsprite
		
@pole4:		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		piece	$40, -8, 2x2, $41
		piece	$50, -8, 2x2, $41
		endsprite
		
@pole5:		spritemap		; Incorrect: this should be $A
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		piece	$40, -8, 2x2, $41
		piece	$50, -8, 2x2, $41
		endsprite
		piece	$60, -8, 2x2, $41
		piece	$70, -8, 2x2, $41
		; @pole6 should be here, but it isn't...
		even
