; ---------------------------------------------------------------------------
; Sprite mappings - Continue screen
; ---------------------------------------------------------------------------
		index *
		ptr @text
		ptr @Sonic1
		ptr @Sonic2
		ptr @Sonic3
		ptr @oval
		ptr @Mini1
		ptr @Mini1
		ptr @Mini2
		
@text:		spritemap			; "CONTINUE", stars and countdown
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
		
@Sonic1:	spritemap			; Sonic	on floor
		piece	-4, 4, 2x2, $15
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
@Sonic2:	spritemap			; Sonic	on floor #2
		piece	-4, 4, 2x2, $19
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
@Sonic3:	spritemap			; Sonic	on floor #3
		piece	-4, 4, 2x2, $1D
		piece	-$14, -$C, 3x3, 6
		piece	4, -$C, 2x3, $F
		endsprite
		
@oval:		spritemap			; circle on the floor
		piece	-$18, $60, 3x2, 0, pal2
		piece	0, $60, 3x2, 0, pal2, xflip
		endsprite
		
@Mini1:		spritemap			; mini Sonic
		piece	0, 0, 2x3, $12
		endsprite
		
@Mini2:		spritemap			; mini Sonic #2
		piece	0, 0, 2x3, $18
		endsprite
		
		even
