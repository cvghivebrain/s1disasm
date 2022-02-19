; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
Map_Has:	index *
		ptr frame_has_sonichas
		ptr frame_has_passed
		ptr frame_has_score
		ptr frame_has_timebonus
		ptr frame_has_ringbonus
		ptr frame_card_oval
		ptr frame_card_act1
		ptr frame_card_act2
		ptr frame_card_act3
		
frame_has_sonichas:
		spritemap					; SONIC HAS
		piece -$48, -8, 2x2, $3E
		piece -$38, -8, 2x2, $32
		piece -$28, -8, 2x2, $2E
		piece -$18, -8, 1x2, $20
		piece -$10, -8, 2x2, 8
		piece $10, -8, 2x2, $1C
		piece $20, -8, 2x2, 0
		piece $30, -8, 2x2, $3E
		endsprite
		
frame_has_passed:
		spritemap					; PASSED
		piece -$30, -8, 2x2, $36
		piece -$20, -8, 2x2, 0
		piece -$10, -8, 2x2, $3E
		piece 0, -8, 2x2, $3E
		piece $10, -8, 2x2, $10
		piece $20, -8, 2x2, $C
		endsprite
		
frame_has_score:
		spritemap					; SCORE
		piece -$50, -8, 4x2, $14A
		piece -$30, -8, 1x2, $162
		piece $18, -8, 3x2, $164
		piece $30, -8, 4x2, $16A
		piece -$33, -9, 2x1, $6E
		piece -$33, -1, 2x1, $6E, xflip, yflip
		endsprite
		
frame_has_timebonus:
		spritemap					; TIME BONUS
		piece -$50, -8, 4x2, $15A
		piece -$27, -8, 4x2, $66
		piece -7, -8, 1x2, $14A
		piece -$A, -9, 2x1, $6E
		piece -$A, -1, 2x1, $6E, xflip, yflip
		piece $28, -8, 4x2, -$10
		piece $48, -8, 1x2, $170
		endsprite
		
frame_has_ringbonus:
		spritemap					; RING BONUS
		piece -$50, -8, 4x2, $152
		piece -$27, -8, 4x2, $66
		piece -7, -8, 1x2, $14A
		piece -$A, -9, 2x1, $6E
		piece -$A, -1, 2x1, $6E, xflip, yflip
		piece $28, -8, 4x2, -8
		piece $48, -8, 1x2, $170
		endsprite
		even
