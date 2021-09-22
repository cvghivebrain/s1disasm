; ---------------------------------------------------------------------------
; Sprite mappings - exploding spikeys that the SLZ boss	drops
; ---------------------------------------------------------------------------
Map_BSBall:	index *
		ptr frame_bsball_fireball1
		ptr frame_bsball_fireball2

frame_bsball_fireball1:
		spritemap
		piece	-4, -4, 1x1, $27
		endsprite
frame_bsball_fireball2:
		spritemap
		piece	-4, -4, 1x1, $28
		endsprite
		even
