; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
		index *
		ptr M_Got_SonicHas
		ptr M_Got_Passed
		ptr M_Got_Score
		ptr M_Got_TBonus
		ptr M_Got_RBonus
		ptr M_Card_Oval
		ptr M_Card_Act1
		ptr M_Card_Act2
		ptr M_Card_Act3
		
M_Got_SonicHas:	spritemap			; SONIC HAS
		piece -$48, -8, 2x2, $3E
		piece -$38, -8, 2x2, $32
		piece -$28, -8, 2x2, $2E
		piece -$18, -8, 1x2, $20
		piece -$10, -8, 2x2, 8
		piece $10, -8, 2x2, $1C
		piece $20, -8, 2x2, 0
		piece $30, -8, 2x2, $3E
		endsprite
		
M_Got_Passed:	spritemap			; PASSED
		piece -$30, -8, 2x2, $36
		piece -$20, -8, 2x2, 0
		piece -$10, -8, 2x2, $3E
		piece 0, -8, 2x2, $3E
		piece $10, -8, 2x2, $10
		piece $20, -8, 2x2, $C
		endsprite
		
M_Got_Score:	spritemap			; SCORE
		piece -$50, -8, 4x2, $14A
		piece -$30, -8, 1x2, $162
		piece $18, -8, 3x2, $164
		piece $30, -8, 4x2, $16A
		piece -$33, -9, 2x1, $6E
		piece -$33, -1, 2x1, $6E, xflip, yflip
		endsprite
		
M_Got_TBonus:	spritemap			; TIME BONUS
		piece -$50, -8, 4x2, $15A
		piece -$27, -8, 4x2, $66
		piece -7, -8, 1x2, $14A
		piece -$A, -9, 2x1, $6E
		piece -$A, -1, 2x1, $6E, xflip, yflip
		piece $28, -8, 4x2, $FFF0
		piece $48, -8, 1x2, $170
		endsprite
		
M_Got_RBonus:	spritemap			; RING BONUS
		piece -$50, -8, 4x2, $152
		piece -$27, -8, 4x2, $66
		piece -7, -8, 1x2, $14A
		piece -$A, -9, 2x1, $6E
		piece -$A, -1, 2x1, $6E, xflip, yflip
		piece $28, -8, 4x2, $FFF8
		piece $48, -8, 1x2, $170
		endsprite
		even
