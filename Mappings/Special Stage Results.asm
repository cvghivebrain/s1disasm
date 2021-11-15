; ---------------------------------------------------------------------------
; Sprite mappings - special stage results screen
; ---------------------------------------------------------------------------
Map_SSR:	index *
		ptr frame_ssr_chaos
		ptr frame_ssr_score
		ptr byte_CD0D
		ptr frame_card_oval
		ptr byte_CD31
		ptr byte_CD46
		ptr byte_CD5B
		ptr frame_ssr_specialstage
		ptr frame_ssr_gotthemall
		
frame_ssr_chaos:
		spritemap					; "CHAOS EMERALDS"
		piece -$70, -8, 2x2, 8
		piece -$60, -8, 2x2, $1C
		piece -$50, -8, 2x2, 0
		piece -$40, -8, 2x2, $32
		piece -$30, -8, 2x2, $3E
		piece -$10, -8, 2x2, $10
		piece 0, -8, 2x2, $2A
		piece $10, -8, 2x2, $10
		piece $20, -8, 2x2, $3A
		piece $30, -8, 2x2, 0
		piece $40, -8, 2x2, $26
		piece $50, -8, 2x2, $C
		piece $60, -8, 2x2, $3E
		endsprite
		
frame_ssr_score:
		spritemap					; "SCORE"
		piece -$50, -8, 4x2, $14A
		piece -$30, -8, 1x2, $162
		piece $18, -8, 3x2, $164
		piece $30, -8, 4x2, $16A
		piece -$33, -9, 2x1, $6E
		piece -$33, -1, 2x1, $6E, xflip, yflip
		endsprite
		
byte_CD0D:	spritemap
		piece -$50, -8, 4x2, $152
		piece -$27, -8, 4x2, $66
		piece -7, -8, 1x2, $14A
		piece -$A, -9, 2x1, $6E
		piece -$A, -1, 2x1, $6E, xflip, yflip
		piece $28, -8, 4x2, $FFF8
		piece $48, -8, 1x2, $170
		endsprite
		
byte_CD31:	spritemap
		piece -$50, -8, 4x2, $FFD1
		piece -$30, -8, 4x2, $FFD9
		piece -$10, -8, 1x2, $FFE1
		piece $40, -8, 2x3, $1FE3
		endsprite
		
byte_CD46:	spritemap
		piece -$50, -8, 4x2, $FFD1
		piece -$30, -8, 4x2, $FFD9
		piece -$10, -8, 1x2, $FFE1
		piece $40, -8, 2x3, $1FE9
		endsprite
		
byte_CD5B:	spritemap
		piece -$50, -8, 4x2, $FFD1
		piece -$30, -8, 4x2, $FFD9
		piece -$10, -8, 1x2, $FFE1
		endsprite
		
frame_ssr_specialstage:
		spritemap					; "SPECIAL STAGE"
		piece -$64, -8, 2x2, $3E
		piece -$54, -8, 2x2, $36
		piece -$44, -8, 2x2, $10
		piece -$34, -8, 2x2, 8
		piece -$24, -8, 1x2, $20
		piece -$1C, -8, 2x2, 0
		piece -$C, -8, 2x2, $26
		piece $14, -8, 2x2, $3E
		piece $24, -8, 2x2, $42
		piece $34, -8, 2x2, 0
		piece $44, -8, 2x2, $18
		piece $54, -8, 2x2, $10
		endsprite
		
frame_ssr_gotthemall:
		spritemap					; "SONIC GOT THEM ALL"
		piece -$78, -8, 2x2, $3E
		piece -$68, -8, 2x2, $32
		piece -$58, -8, 2x2, $2E
		piece -$48, -8, 1x2, $20
		piece -$40, -8, 2x2, 8
		piece -$28, -8, 2x2, $18
		piece -$18, -8, 2x2, $32
		piece -8, -8, 2x2, $42
		piece $10, -8, 2x2, $42
		piece $20, -8, 2x2, $1C
		piece $30, -8, 2x2, $10
		piece $40, -8, 2x2, $2A
		piece $58, -8, 2x2, 0
		piece $68, -8, 2x2, $26
		piece $78, -8, 2x2, $26
		endsprite
		even
