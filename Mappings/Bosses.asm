; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (boss levels)
; ---------------------------------------------------------------------------
		index *
		ptr @ship
		ptr @facenormal1
		ptr @facenormal2
		ptr @facelaugh1
		ptr @facelaugh2
		ptr @facehit
		ptr @facepanic
		ptr @facedefeat
		ptr @flame1
		ptr @flame2
		ptr @blank
		ptr @escapeflame1
		ptr @escapeflame2
		
@ship:		spritemap
		piece	-$1C, -$14, 1x2, $A
		piece	$C, -$14, 2x2, $C
		piece	-$1C, -4, 4x3, $10, pal2
		piece	4, -4, 4x3, $1C, pal2
		piece	-$14, $14, 4x1, $28, pal2
		piece	$C, $14, 1x1, $2C, pal2
		endsprite
		
@facenormal1:	spritemap
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, 2
		endsprite
		
@facenormal2:	spritemap
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, $35
		endsprite
		
@facelaugh1:	spritemap
		piece	-$C, -$1C, 3x1, $3D
		piece	-$14, -$14, 3x2, $40
		piece	4, -$14, 2x2, $46
		endsprite
		
@facelaugh2:	spritemap
		piece	-$C, -$1C, 3x1, $4A
		piece	-$14, -$14, 3x2, $4D
		piece	4, -$14, 2x2, $53
		endsprite
		
@facehit:	spritemap
		piece	-$C, -$1C, 3x1, $57
		piece	-$14, -$14, 3x2, $5A
		piece	4, -$14, 2x2, $60
		endsprite
		
@facepanic:	spritemap
		piece	4, -$1C, 2x1, $64
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, $35
		endsprite
		
@facedefeat:	spritemap
		piece	-$C, -$1C, 3x2, $66
		piece	-$C, -$1C, 3x1, $57
		piece	-$14, -$14, 3x2, $5A
		piece	4, -$14, 2x2, $60
		endsprite
		
@flame1:	spritemap
		piece	$22, 4, 2x2, $2D
		endsprite
		
@flame2:	spritemap
		piece	$22, 4, 2x2, $31
		endsprite
		
@blank:		spritemap
		endsprite
		
@escapeflame1:	spritemap
		piece	$22, 0, 3x1, $12A
		piece	$22, 8, 3x1, $12A, yflip
		endsprite
		
@escapeflame2:	spritemap
		piece	$22, -8, 3x4, $12D
		piece	$3A, 0, 1x2, $139
		endsprite
		even
