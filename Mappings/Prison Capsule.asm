; ---------------------------------------------------------------------------
; Sprite mappings - prison capsule
; ---------------------------------------------------------------------------
		index *
		ptr @capsule
		ptr @switch1
		ptr @broken
		ptr @switch2
		ptr @unusedthing1
		ptr @unusedthing2
		ptr @blank
		
@capsule:	spritemap
		piece	-$10, -$20, 4x1, 0, pal2
		piece	-$20, -$18, 4x2, 4, pal2
		piece	0, -$18, 4x2, $C, pal2
		piece	-$20, -8, 4x3, $14, pal2
		piece	0, -8, 4x3, $20, pal2
		piece	-$20, $10, 4x2, $2C, pal2
		piece	0, $10, 4x2, $34, pal2
		endsprite
		
@switch1:	spritemap
		piece	-$C, -8, 3x2, $3C
		endsprite
		
@broken:	spritemap
		piece	-$20, 0, 3x1, $42, pal2
		piece	-$20, 8, 4x1, $45, pal2
		piece	$10, 0, 2x1, $49, pal2
		piece	0, 8, 4x1, $4B, pal2
		piece	-$20, $10, 4x2, $2C, pal2
		piece	0, $10, 4x2, $34, pal2
		endsprite
		
@switch2:	spritemap
		piece	-$C, -8, 3x2, $4F
		endsprite
		
@unusedthing1:	spritemap
		piece	-$10, -$18, 4x3, $55, pal2
		piece	-$10, 0, 4x3, $61, pal2
		endsprite
		
@unusedthing2:	spritemap
		piece	-8, -$10, 2x4, $6D, pal2
		endsprite
		
@blank:		spritemap
		endsprite
		even
