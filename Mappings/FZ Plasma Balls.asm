; ---------------------------------------------------------------------------
; Sprite mappings - energy balls (FZ)
; ---------------------------------------------------------------------------
Map_Plasma:	index *
		ptr frame_plasma_fuzzy1				; 0
		ptr frame_plasma_fuzzy2				; 1
		ptr frame_plasma_white1				; 2
		ptr frame_plasma_white2				; 3
		ptr frame_plasma_white3				; 4
		ptr frame_plasma_white4				; 5
		ptr frame_plasma_fuzzy3				; 6
		ptr frame_plasma_fuzzy4				; 7
		ptr frame_plasma_fuzzy5				; 8
		ptr frame_plasma_fuzzy6				; 9
		ptr frame_plasma_blank				; $A
		
frame_plasma_fuzzy1:
		spritemap
		piece	-$10, -$10, 4x2, $7A
		piece	-$10, 0, 4x2, $7A, xflip, yflip
		endsprite
		
frame_plasma_fuzzy2:
		spritemap
		piece	-$C, -$C, 2x3, $82
		piece	4, -$C, 1x3, $82, xflip, yflip
		endsprite
		
frame_plasma_white1:
		spritemap
		piece	-8, -8, 2x1, $88
		piece	-8, 0, 2x1, $88, yflip
		endsprite
		
frame_plasma_white2:
		spritemap
		piece	-8, -8, 2x1, $8A
		piece	-8, 0, 2x1, $8A, yflip
		endsprite
		
frame_plasma_white3:
		spritemap
		piece	-8, -8, 2x1, $8C
		piece	-8, 0, 2x1, $8C, yflip
		endsprite
		
frame_plasma_white4:
		spritemap
		piece	-$C, -$C, 2x3, $8E
		piece	4, -$C, 1x3, $8E, xflip, yflip
		endsprite
		
frame_plasma_fuzzy3:
		spritemap
		piece	-8, -8, 2x2, $94
		endsprite
		
frame_plasma_fuzzy4:
		spritemap
		piece	-8, -8, 2x2, $98
		endsprite
		
frame_plasma_fuzzy5:
		spritemap
		piece	-$10, -$10, 4x2, $7A, xflip
		piece	-$10, 0, 4x2, $7A, yflip
		endsprite
		
frame_plasma_fuzzy6:
		spritemap
		piece	-$C, -$C, 2x3, $82, yflip
		piece	4, -$C, 1x3, $82, xflip
		endsprite
		
frame_plasma_blank:
		spritemap
		endsprite
		even
