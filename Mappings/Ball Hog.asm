; ---------------------------------------------------------------------------
; Sprite mappings - Ball Hog enemy (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr M_Hog_Stand
		ptr M_Hog_Open
		ptr M_Hog_Squat
		ptr M_Hog_Leap
		ptr M_Hog_Ball1
		ptr M_Hog_Ball2
		
M_Hog_Stand:	spritemap		; Ball hog standing
		piece	-$C, -$11, 3x2, 0
		piece	-$C, -1, 3x3, 6
		endsprite
		
M_Hog_Open:	spritemap		; Ball hog with hatch open
		piece	-$C, -$11, 3x2, 0
		piece	-$C, -1, 3x3, $F
		endsprite
		
M_Hog_Squat:	spritemap		; Ball hog squatting
		piece	-$C, -$C, 3x2, 0
		piece	-$C, 4, 3x2, $18
		endsprite
		
M_Hog_Leap:	spritemap		; Ball hog leaping
		piece	-$C, -$1C, 3x2, 0
		piece	-$C, -$C, 3x3, $1E
		endsprite
		
M_Hog_Ball1:	spritemap		; Ball (black)
		piece	-8, -8, 2x2, $27
		endsprite
		
M_Hog_Ball2:	spritemap		; Ball (red)
		piece	-8, -8, 2x2, $2B
		endsprite
		even
