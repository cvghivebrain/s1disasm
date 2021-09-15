; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------
Map_Hog:	index *
		ptr frame_hog_standing
		ptr frame_hog_open
		ptr frame_hog_squat
		ptr frame_hog_leap
		ptr frame_hog_ball1
		ptr frame_hog_ball2
		
frame_hog_standing:
		spritemap		; Ball hog standing
		piece	-$C, -$11, 3x2, 0
		piece	-$C, -1, 3x3, 6
		endsprite
		
frame_hog_open:
		spritemap		; Ball hog with hatch open
		piece	-$C, -$11, 3x2, 0
		piece	-$C, -1, 3x3, $F
		endsprite
		
frame_hog_squat:
		spritemap		; Ball hog squatting
		piece	-$C, -$C, 3x2, 0
		piece	-$C, 4, 3x2, $18
		endsprite
		
frame_hog_leap:
		spritemap		; Ball hog leaping
		piece	-$C, -$1C, 3x2, 0
		piece	-$C, -$C, 3x3, $1E
		endsprite
		
frame_hog_ball1:
		spritemap		; Ball (black)
		piece	-8, -8, 2x2, $27
		endsprite
		
frame_hog_ball2:
		spritemap		; Ball (red)
		piece	-8, -8, 2x2, $2B
		endsprite
		even
