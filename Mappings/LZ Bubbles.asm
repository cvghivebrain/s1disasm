; ---------------------------------------------------------------------------
; Sprite mappings - bubbles (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @bubble1
		ptr @bubble2
		ptr @bubble3
		ptr @bubble4
		ptr @bubble5
		ptr @bubble6
		ptr @bubblefull
		ptr @burst1
		ptr @burst2
		ptr @zero_sm
		ptr @five_sm
		ptr @three_sm
		ptr @one_sm
		ptr @zero
		ptr @five
		ptr @four
		ptr @three
		ptr @two
		ptr @one
		ptr @bubmaker1
		ptr @bubmaker2
		ptr @bubmaker3
		ptr @blank
		
@bubble1:	spritemap			; bubbles, increasing in size
		piece $FC, $FC, 1x1, 0, 0
		endsprite
		
@bubble2:	spritemap
		piece $FC, $FC, 1x1, 1, 0
		endsprite
		
@bubble3:	spritemap
		piece $FC, $FC, 1x1, 2, 0
		endsprite
		
@bubble4:	spritemap
		piece $F8, $F8, 2x2, 3, 0
		endsprite
		
@bubble5:	spritemap
		piece $F8, $F8, 2x2, 7, 0
		endsprite
		
@bubble6:	spritemap
		piece $F4, $F4, 3x3, $B, 0
		endsprite
		
@bubblefull:	spritemap
		piece $F0, $F0, 4x4, $14, 0
		endsprite
		
@burst1:	spritemap			; large bubble bursting
		piece $F0, $F0, 2x2, $24, 0
		piece 0, $F0, 2x2, $24, xflip
		piece $F0, 0, 2x2, $24, yflip
		piece 0, 0, 2x2, $24, xflip, yflip
		endsprite
		
@burst2:	spritemap
		piece $F0, $F0, 2x2, $28, 0
		piece 0, $F0, 2x2, $28, xflip
		piece $F0, 0, 2x2, $28, yflip
		piece 0, 0, 2x2, $28, xflip, yflip
		endsprite
		
@zero_sm:	spritemap			; small, partially-formed countdown numbers
		piece $F8, $F4, 2x3, $2C, 0
		endsprite
		
@five_sm:	spritemap
		piece $F8, $F4, 2x3, $32, 0
		endsprite
		
@three_sm:	spritemap
		piece $F8, $F4, 2x3, $38, 0
		endsprite
		
@one_sm:	spritemap
		piece $F8, $F4, 2x3, $3E, 0
		endsprite
		
@zero:		spritemap			; fully-formed countdown numbers
		piece $F8, $F4, 2x3, $44, pal2
		endsprite
		
@five:		spritemap
		piece $F8, $F4, 2x3, $4A, pal2
		endsprite
		
@four:		spritemap
		piece $F8, $F4, 2x3, $50, pal2
		endsprite
		
@three:		spritemap
		piece $F8, $F4, 2x3, $56, pal2
		endsprite
		
@two:		spritemap
		piece $F8, $F4, 2x3, $5C, pal2
		endsprite
		
@one:		spritemap
		piece $F8, $F4, 2x3, $62, pal2
		endsprite
		
@bubmaker1:	spritemap
		piece $F8, $F8, 2x2, $68, 0
		endsprite
		
@bubmaker2:	spritemap
		piece $F8, $F8, 2x2, $6C, 0
		endsprite
		
@bubmaker3:	spritemap
		piece $F8, $F8, 2x2, $70, 0
		endsprite
		
@blank:		spritemap
		endsprite
		even
