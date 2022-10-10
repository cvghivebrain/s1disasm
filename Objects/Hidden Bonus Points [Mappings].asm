; ---------------------------------------------------------------------------
; Sprite mappings - hidden points at the end of	a level
; ---------------------------------------------------------------------------
Map_Bonus:	index offset(*)
		ptr frame_bonus_blank
		ptr frame_bonus_10000
		ptr frame_bonus_1000
		ptr frame_bonus_100
		
frame_bonus_blank:
		spritemap
		endsprite
		
frame_bonus_10000:
		spritemap
		piece	-$10, -$C, 4x3, 0
		endsprite
		
frame_bonus_1000:
		spritemap
		piece	-$10, -$C, 4x3, $C
		endsprite
		
frame_bonus_100:
		spritemap
		piece	-$10, -$C, 4x3, $18
		endsprite
		even
