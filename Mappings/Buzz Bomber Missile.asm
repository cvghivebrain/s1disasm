; ---------------------------------------------------------------------------
; Sprite mappings - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
Map_Missile:	index *
		ptr frame_buzz_flare1
		ptr frame_buzz_flare2
		ptr frame_buzz_ball1
		ptr frame_buzz_ball2
		
frame_buzz_flare1:
		spritemap		; buzz bomber firing flare
		piece	-8, -8, 2x2, $24
		endsprite
		
frame_buzz_flare2:
		spritemap
		piece	-8, -8, 2x2, $28
		endsprite
		
frame_buzz_ball1:
		spritemap		; missile itself
		piece	-8, -8, 2x2, $2C
		endsprite
		
frame_buzz_ball2:
		spritemap
		piece	-8, -8, 2x2, $33
		endsprite
		even
