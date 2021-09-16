; ---------------------------------------------------------------------------
; Sprite mappings - Continue screen
; ---------------------------------------------------------------------------
Map_ContScr:	index *
		ptr frame_cont_text
		ptr frame_cont_sonic1
		ptr frame_cont_sonic2
		ptr frame_cont_sonic3
		ptr frame_cont_oval
		ptr frame_cont_mini1
		ptr frame_cont_mini1
		ptr frame_cont_mini2
		
frame_cont_text:
		spritemap			; "CONTINUE", stars and countdown
		piece	-60, -8, 2x2, $88
		piece	-$2C, -8, 2x2, $B2
		piece	-$1C, -8, 2x2, $AE
		piece	-$C, -8, 2x2, $C2
		piece	4, -8, 1x2, $A0
		piece	$C, -8, 2x2, $AE
		piece	$1C, -8, 2x2, $C6
		piece	$2C, -8, 2x2, $90
		piece	-$18, $38, 2x2, $21, pal2
		piece	8, 56, 2x2, $21, pal2
		piece	-8, $36, 2x2, $1FC
		endsprite
		
frame_cont_sonic1:
		spritemap			; Sonic	on floor
		piece	-4, 4, 2x2, $15
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
frame_cont_sonic2:
		spritemap			; Sonic	on floor #2
		piece	-4, 4, 2x2, $19
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
frame_cont_sonic3:
		spritemap			; Sonic	on floor #3
		piece	-4, 4, 2x2, $1D
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
frame_cont_oval:
		spritemap			; circle on the floor
		piece	-$18, $60, 3x2, 0, pal2
		piece	0, $60, 3x2, 0, pal2, xflip
		endsprite
		
frame_cont_mini1:
		spritemap			; mini Sonic
		piece	0, 0, 2x3, $12
		endsprite
		
frame_cont_mini2:
		spritemap			; mini Sonic #2
		piece	0, 0, 2x3, $18
		endsprite
		
		even
