; ---------------------------------------------------------------------------
; Sprite mappings - lava geyser / lava that falls from the ceiling (MZ)
; ---------------------------------------------------------------------------
Map_Geyser:	index offset(*)
		ptr frame_geyser_bubble1			; 0
		ptr frame_geyser_bubble2			; 1
		ptr frame_geyser_bubble3			; 2
		ptr frame_geyser_bubble4			; 3
		ptr frame_geyser_bubble5			; 4
		ptr frame_geyser_bubble6			; 5
		ptr frame_geyser_end1				; 6
		ptr frame_geyser_end2				; 7
		ptr frame_geyser_medcolumn1			; 8
		ptr frame_geyser_medcolumn2			; 9
		ptr frame_geyser_medcolumn3			; $A
		ptr frame_geyser_shortcolumn1			; $B
		ptr frame_geyser_shortcolumn2			; $C
		ptr frame_geyser_shortcolumn3			; $D
		ptr frame_geyser_longcolumn1			; $E
		ptr frame_geyser_longcolumn2			; $F
		ptr frame_geyser_longcolumn3			; $10
		ptr frame_geyser_bubble7			; $11
		ptr frame_geyser_bubble8			; $12
		ptr frame_geyser_blank				; $13
		
frame_geyser_bubble1:
		spritemap
		piece	-$18, -$14, 3x4, 0
		piece	0, -$14, 3x4, 0, xflip
		endsprite
		
frame_geyser_bubble2:
		spritemap
		piece	-$18, -$14, 3x4, $18
		piece	0, -$14, 3x4, $18, xflip
		endsprite
		
frame_geyser_bubble3:
		spritemap
		piece	-$38, -$14, 3x4, 0
		piece	-$20, -$C, 4x3, $C
		piece	0, -$C, 4x3, $C, xflip
		piece	$20, -$14, 3x4, 0, xflip
		endsprite
		
frame_geyser_bubble4:
		spritemap
		piece	-$38, -$14, 3x4, $18
		piece	-$20, -$C, 4x3, $24
		piece	0, -$C, 4x3, $24, xflip
		piece	$20, -$14, 3x4, $18, xflip
		endsprite
		
frame_geyser_bubble5:
		spritemap
		piece	-$38, -$14, 3x4, 0
		piece	-$20, -$C, 4x3, $C
		piece	0, -$C, 4x3, $C, xflip
		piece	$20, -$14, 3x4, 0, xflip
		piece	-$20, -$18, 4x3, $90
		piece	0, -$18, 4x3, $90, xflip
		endsprite
		
frame_geyser_bubble6:
		spritemap
		piece	-$38, -$14, 3x4, $18
		piece	-$20, -$C, 4x3, $24
		piece	0, -$C, 4x3, $24, xflip
		piece	$20, -$14, 3x4, $18, xflip
		piece	-$20, -$18, 4x3, $90, xflip
		piece	0, -$18, 4x3, $90
		endsprite
		
frame_geyser_end1:
		spritemap
		piece	-$20, -$20, 4x4, $30
		piece	0, -$20, 4x4, $30, xflip
		endsprite
		
frame_geyser_end2:
		spritemap
		piece	-$20, -$20, 4x4, $30, xflip
		piece	0, -$20, 4x4, $30
		endsprite
		
frame_geyser_medcolumn1:
		spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		piece	-$20, -$10, 4x4, $40
		piece	0, -$10, 4x4, $40, xflip
		piece	-$20, $10, 4x4, $40
		piece	0, $10, 4x4, $40, xflip
		endsprite
		
frame_geyser_medcolumn2:
		spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		piece	-$20, -$10, 4x4, $50
		piece	0, -$10, 4x4, $50, xflip
		piece	-$20, $10, 4x4, $50
		piece	0, $10, 4x4, $50, xflip
		endsprite
		
frame_geyser_medcolumn3:
		spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		piece	-$20, -$10, 4x4, $60
		piece	0, -$10, 4x4, $60, xflip
		piece	-$20, $10, 4x4, $60
		piece	0, $10, 4x4, $60, xflip
		endsprite
		
frame_geyser_shortcolumn1:
		spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		endsprite
		
frame_geyser_shortcolumn2:
		spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		endsprite
		
frame_geyser_shortcolumn3:
		spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		endsprite
		
frame_geyser_longcolumn1:
		spritemap
		piece	-$20, -$70, 4x4, $40
		piece	0, -$70, 4x4, $40, xflip
		piece	-$20, -$50, 4x4, $40
		piece	0, -$50, 4x4, $40, xflip
		piece	-$20, -$30, 4x4, $40
		piece	0, -$30, 4x4, $40, xflip
		piece	-$20, -$10, 4x4, $40
		piece	0, -$10, 4x4, $40, xflip
		piece	-$20, $10, 4x4, $40
		piece	0, $10, 4x4, $40, xflip
		piece	-$20, $30, 4x4, $40
		piece	0, $30, 4x4, $40, xflip
		piece	-$20, $50, 4x4, $40
		piece	0, $50, 4x4, $40, xflip
		piece	-$20, $70, 4x4, $40
		piece	0, $70, 4x4, $40, xflip
		endsprite
		
frame_geyser_longcolumn2:
		spritemap
		piece	-$20, -$70, 4x4, $50
		piece	0, -$70, 4x4, $50, xflip
		piece	-$20, -$50, 4x4, $50
		piece	0, -$50, 4x4, $50, xflip
		piece	-$20, -$30, 4x4, $50
		piece	0, -$30, 4x4, $50, xflip
		piece	-$20, -$10, 4x4, $50
		piece	0, -$10, 4x4, $50, xflip
		piece	-$20, $10, 4x4, $50
		piece	0, $10, 4x4, $50, xflip
		piece	-$20, $30, 4x4, $50
		piece	0, $30, 4x4, $50, xflip
		piece	-$20, $50, 4x4, $50
		piece	0, $50, 4x4, $50, xflip
		piece	-$20, $70, 4x4, $50
		piece	0, $70, 4x4, $50, xflip
		endsprite
		
frame_geyser_longcolumn3:
		spritemap
		piece	-$20, -$70, 4x4, $60
		piece	0, -$70, 4x4, $60, xflip
		piece	-$20, -$50, 4x4, $60
		piece	0, -$50, 4x4, $60, xflip
		piece	-$20, -$30, 4x4, $60
		piece	0, -$30, 4x4, $60, xflip
		piece	-$20, -$10, 4x4, $60
		piece	0, -$10, 4x4, $60, xflip
		piece	-$20, $10, 4x4, $60
		piece	0, $10, 4x4, $60, xflip
		piece	-$20, $30, 4x4, $60
		piece	0, $30, 4x4, $60, xflip
		piece	-$20, $50, 4x4, $60
		piece	0, $50, 4x4, $60, xflip
		piece	-$20, $70, 4x4, $60
		piece	0, $70, 4x4, $60, xflip
		endsprite
		
frame_geyser_bubble7:
		spritemap
		piece	-$38, -$20, 3x4, 0
		piece	-$20, -$18, 4x3, $C
		piece	0, -$18, 4x3, $C, xflip
		piece	$20, -$20, 3x4, 0, xflip
		piece	-$20, -$28, 4x3, $90
		piece	0, -$28, 4x3, $90, xflip
		endsprite
		
frame_geyser_bubble8:
		spritemap
		piece	-$38, -$20, 3x4, $18
		piece	-$20, -$18, 4x3, $24
		piece	0, -$18, 4x3, $24, xflip
		piece	$20, -$20, 3x4, $18, xflip
		piece	-$20, -$28, 4x3, $90, xflip
		piece	0, -$28, 4x3, $90
		endsprite
		
frame_geyser_blank:
		spritemap
		endsprite
		even
