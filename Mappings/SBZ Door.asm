; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @closed
		ptr @01
		ptr @02
		ptr @03
		ptr @04
		ptr @05
		ptr @06
		ptr @07
		ptr @open
		
@closed:	spritemap			; door closed
		piece	-8, -$20, 2x4, 0, xflip
		piece	-8, 0, 2x4, 0, xflip
		endsprite
		
@01:		spritemap
		piece	-8, -$24, 2x4, 0, xflip
		piece	-8, 4, 2x4, 0, xflip
		endsprite
		
@02:		spritemap
		piece	-8, -$28, 2x4, 0, xflip
		piece	-8, 8, 2x4, 0, xflip
		endsprite
		
@03:		spritemap
		piece	-8, -$2C, 2x4, 0, xflip
		piece	-8, $C, 2x4, 0, xflip
		endsprite
		
@04:		spritemap
		piece	-8, -$30, 2x4, 0, xflip
		piece	-8, $10, 2x4, 0, xflip
		endsprite
		
@05:		spritemap
		piece	-8, -$34, 2x4, 0, xflip
		piece	-8, $14, 2x4, 0, xflip
		endsprite
		
@06:		spritemap
		piece	-8, -$38, 2x4, 0, xflip
		piece	-8, $18, 2x4, 0, xflip
		endsprite
		
@07:		spritemap
		piece	-8, -$3C, 2x4, 0, xflip
		piece	-8, $1C, 2x4, 0, xflip
		endsprite
		
@open:		spritemap			; door fully open
		piece	-8, -$40, 2x4, 0, xflip
		piece	-8, $20, 2x4, 0, xflip
		endsprite
		even
