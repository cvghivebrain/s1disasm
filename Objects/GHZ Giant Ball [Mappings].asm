; ---------------------------------------------------------------------------
; Sprite mappings - swinging ball on a chain from GHZ boss
; ---------------------------------------------------------------------------
Map_GBall:	index offset(*)
		ptr frame_ball_shiny
		ptr frame_ball_check1
		ptr frame_ball_check2
		ptr frame_ball_check3
		
frame_ball_shiny:
		spritemap
		piece	-$10, -$10, 2x1, $24
		piece	-$10, -8, 2x1, $24, yflip
		piece	-$18, -$18, 3x3, 0
		piece	0, -$18, 3x3, 0, xflip
		piece	-$18, 0, 3x3, 0, yflip
		piece	0, 0, 3x3, 0, xflip, yflip
		endsprite
		
frame_ball_check1:
		spritemap
		piece	-$18, -$18, 3x3, 9
		piece	0, -$18, 3x3, 9, xflip
		piece	-$18, 0, 3x3, 9, yflip
		piece	0, 0, 3x3, 9, xflip, yflip
		endsprite
		
frame_ball_check2:
		spritemap
		piece	-$18, -$18, 3x3, $12
		piece	0, -$18, 3x3, $1B
		piece	-$18, 0, 3x3, $1B, xflip, yflip
		piece	0, 0, 3x3, $12, xflip, yflip
		endsprite
		
frame_ball_check3:
		spritemap
		piece	-$18, -$18, 3x3, $1B, xflip
		piece	0, -$18, 3x3, $12, xflip
		piece	-$18, 0, 3x3, $12, yflip
		piece	0, 0, 3x3, $1B, yflip
		endsprite
		even
