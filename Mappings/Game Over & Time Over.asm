; ---------------------------------------------------------------------------
; Sprite mappings - "GAME OVER"	and "TIME OVER"
; ---------------------------------------------------------------------------
Map_Over:	index *
		ptr frame_gameover_game
		ptr frame_gameover_over
		ptr frame_gameover_time
		ptr frame_gameover_over2
		
frame_gameover_game:
		spritemap					; GAME
		piece -$48, -8, 4x2, 0
		piece -$28, -8, 4x2, 8
		endsprite
		
frame_gameover_over:
		spritemap					; OVER
		piece 8, -8, 4x2, $14
		piece $28, -8, 4x2, $C
		endsprite
		
frame_gameover_time:
		spritemap					; TIME
		piece -$3C, -8, 3x2, $1C
		piece -$24, -8, 4x2, 8
		endsprite
		
frame_gameover_over2:
		spritemap					; OVER
		piece $C, -8, 4x2, $14
		piece $2C, -8, 4x2, $C
		endsprite
		even
