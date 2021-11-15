; ---------------------------------------------------------------------------
; Sprite mappings - doors (SBZ)
; ---------------------------------------------------------------------------
Map_ADoor:	index *
		ptr frame_autodoor_closed
		ptr frame_autodoor_01
		ptr frame_autodoor_02
		ptr frame_autodoor_03
		ptr frame_autodoor_04
		ptr frame_autodoor_05
		ptr frame_autodoor_06
		ptr frame_autodoor_07
		ptr frame_autodoor_open
		
frame_autodoor_closed:
		spritemap					; door closed
		piece	-8, -$20, 2x4, 0, xflip
		piece	-8, 0, 2x4, 0, xflip
		endsprite
		
frame_autodoor_01:
		spritemap
		piece	-8, -$24, 2x4, 0, xflip
		piece	-8, 4, 2x4, 0, xflip
		endsprite
		
frame_autodoor_02:
		spritemap
		piece	-8, -$28, 2x4, 0, xflip
		piece	-8, 8, 2x4, 0, xflip
		endsprite
		
frame_autodoor_03:
		spritemap
		piece	-8, -$2C, 2x4, 0, xflip
		piece	-8, $C, 2x4, 0, xflip
		endsprite
		
frame_autodoor_04:
		spritemap
		piece	-8, -$30, 2x4, 0, xflip
		piece	-8, $10, 2x4, 0, xflip
		endsprite
		
frame_autodoor_05:
		spritemap
		piece	-8, -$34, 2x4, 0, xflip
		piece	-8, $14, 2x4, 0, xflip
		endsprite
		
frame_autodoor_06:
		spritemap
		piece	-8, -$38, 2x4, 0, xflip
		piece	-8, $18, 2x4, 0, xflip
		endsprite
		
frame_autodoor_07:
		spritemap
		piece	-8, -$3C, 2x4, 0, xflip
		piece	-8, $1C, 2x4, 0, xflip
		endsprite
		
frame_autodoor_open:
		spritemap					; door fully open
		piece	-8, -$40, 2x4, 0, xflip
		piece	-8, $20, 2x4, 0, xflip
		endsprite
		even
