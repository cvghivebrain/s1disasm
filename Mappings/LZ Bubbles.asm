; ---------------------------------------------------------------------------
; Sprite mappings - bubbles (LZ)
; ---------------------------------------------------------------------------
Map_Bub:	index *
		ptr frame_bubble_0
		ptr frame_bubble_1
		ptr frame_bubble_2
		ptr frame_bubble_3
		ptr frame_bubble_4
		ptr frame_bubble_5
		ptr frame_bubble_full				; 6
		ptr frame_bubble_burst1				; 7
		ptr frame_bubble_burst2				; 8
		ptr frame_bubble_zero_small			; 9
		ptr frame_bubble_five_small			; $A
		ptr frame_bubble_three_small			; $B
		ptr frame_bubble_one_small			; $C
		ptr frame_bubble_zero				; $D
		ptr frame_bubble_five				; $E
		ptr frame_bubble_four				; $F
		ptr frame_bubble_three				; $10
		ptr frame_bubble_two				; $11
		ptr frame_bubble_one				; $12
		ptr frame_bubble_bubmaker1			; $13
		ptr frame_bubble_bubmaker2			; $14
		ptr frame_bubble_bubmaker3			; $15
		ptr frame_bubble_blank				; $16
		
frame_bubble_0:
		spritemap					; bubbles, increasing in size
		piece $FC, $FC, 1x1, 0, 0
		endsprite
		
frame_bubble_1:
		spritemap
		piece $FC, $FC, 1x1, 1, 0
		endsprite
		
frame_bubble_2:
		spritemap
		piece $FC, $FC, 1x1, 2, 0
		endsprite
		
frame_bubble_3:
		spritemap
		piece $F8, $F8, 2x2, 3, 0
		endsprite
		
frame_bubble_4:
		spritemap
		piece $F8, $F8, 2x2, 7, 0
		endsprite
		
frame_bubble_5:
		spritemap
		piece $F4, $F4, 3x3, $B, 0
		endsprite
		
frame_bubble_full:
		spritemap
		piece $F0, $F0, 4x4, $14, 0
		endsprite
		
frame_bubble_burst1:
		spritemap					; large bubble bursting
		piece $F0, $F0, 2x2, $24, 0
		piece 0, $F0, 2x2, $24, xflip
		piece $F0, 0, 2x2, $24, yflip
		piece 0, 0, 2x2, $24, xflip, yflip
		endsprite
		
frame_bubble_burst2:
		spritemap
		piece $F0, $F0, 2x2, $28, 0
		piece 0, $F0, 2x2, $28, xflip
		piece $F0, 0, 2x2, $28, yflip
		piece 0, 0, 2x2, $28, xflip, yflip
		endsprite
		
frame_bubble_zero_small:
		spritemap					; small, partially-formed countdown numbers
		piece $F8, $F4, 2x3, $2C, 0
		endsprite
		
frame_bubble_five_small:
		spritemap
		piece $F8, $F4, 2x3, $32, 0
		endsprite
		
frame_bubble_three_small:
		spritemap
		piece $F8, $F4, 2x3, $38, 0
		endsprite
		
frame_bubble_one_small:
		spritemap
		piece $F8, $F4, 2x3, $3E, 0
		endsprite
		
frame_bubble_zero:
		spritemap					; fully-formed countdown numbers
		piece $F8, $F4, 2x3, $44, pal2
		endsprite
		
frame_bubble_five:
		spritemap
		piece $F8, $F4, 2x3, $4A, pal2
		endsprite
		
frame_bubble_four:
		spritemap
		piece $F8, $F4, 2x3, $50, pal2
		endsprite
		
frame_bubble_three:
		spritemap
		piece $F8, $F4, 2x3, $56, pal2
		endsprite
		
frame_bubble_two:
		spritemap
		piece $F8, $F4, 2x3, $5C, pal2
		endsprite
		
frame_bubble_one:
		spritemap
		piece $F8, $F4, 2x3, $62, pal2
		endsprite
		
frame_bubble_bubmaker1:
		spritemap
		piece $F8, $F8, 2x2, $68, 0
		endsprite
		
frame_bubble_bubmaker2:
		spritemap
		piece $F8, $F8, 2x2, $6C, 0
		endsprite
		
frame_bubble_bubmaker3:
		spritemap
		piece $F8, $F8, 2x2, $70, 0
		endsprite
		
frame_bubble_blank:
		spritemap
		endsprite
		even
