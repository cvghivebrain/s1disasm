; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @walk1
		ptr @walk2
		ptr @digging1
		ptr @digging2
		ptr @fall
		ptr @facedown
		ptr @walk3
		
@walk1:		spritemap		; walking
		piece	-$10, -$14, 3x3, 0
		piece	-$C, 4, 3x2, 9
		endsprite
		
@walk2:		spritemap
		piece	-$10, -$14, 3x3, $F
		piece	-$C, 4, 3x2, $18
		endsprite
		
@digging1:	spritemap		; digging
		piece	-$C, -$18, 3x3, $1E
		piece	-$C, 0, 3x3, $27
		endsprite
		
@digging2:	spritemap
		piece	-$C, -$18, 3x3, $30
		piece	-$C, 0, 3x3, $39
		endsprite
		
@fall:		spritemap		; falling after jumping up
		piece	-$10, -$18, 3x3, $F
		piece	-$C, 0, 3x3, $42
		endsprite
		
@facedown:	spritemap		; facing down (unused)
		piece	-$18, -$C, 2x3, $4B
		piece	-8, -$C, 3x3, $51
		endsprite
		
@walk3:		spritemap
		piece	-$10, -$14, 3x3, $F
		piece	-$C, 4, 3x2, 9
		endsprite
		even
