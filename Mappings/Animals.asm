; ---------------------------------------------------------------------------
; Sprite mappings - animals
; ---------------------------------------------------------------------------
Map_Animal1:	index *
		ptr byte_9472
		ptr byte_9478
		ptr byte_946C
		
byte_946C:	spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
byte_9472:	spritemap
		piece	-8, -$C, 2x3, 6
		endsprite
		
byte_9478:	spritemap
		piece	-8, -$C, 2x3, $C
		endsprite
		even

Map_Animal2:	index *
		ptr byte_948A
		ptr byte_9490
		ptr byte_9484
		
byte_9484:	spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
byte_948A:	spritemap
		piece	-8, -4, 2x2, 6
		endsprite
		
byte_9490:	spritemap
		piece	-8, -4, 2x2, $A
		endsprite
		even

Map_Animal3:	index *
		ptr byte_94A2
		ptr byte_94A8
		ptr byte_949C
		
byte_949C:	spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
byte_94A2:	spritemap
		piece	-$C, -4, 3x2, 6
		endsprite
		
byte_94A8:	spritemap
		piece	-$C, -4, 3x2, $C
		endsprite
		even
