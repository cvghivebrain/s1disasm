; ---------------------------------------------------------------------------
; Sprite mappings - spiked balls on the	seesaws	(SLZ)
; ---------------------------------------------------------------------------
Map_SSawBall:	index offset(*)
		ptr frame_seesaw_red
		ptr frame_seesaw_silver
		
frame_seesaw_red:
		spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
frame_seesaw_silver:
		spritemap
		piece	-$C, -$C, 3x3, 9
		endsprite
		even
