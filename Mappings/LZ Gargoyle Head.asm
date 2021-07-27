; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @head
		ptr @head
		ptr @fireball1
		ptr @fireball2
		
@head:		spritemap
		piece	0, -$10, 2x1, 0
		piece	-$10, -8, 4x2, 2
		piece	-8, 8, 3x1, $A
		endsprite
		
@fireball1:	spritemap
		piece	-8, -4, 2x1, $D
		endsprite
		
@fireball2:	spritemap
		piece	-8, -4, 2x1, $F
		endsprite
		even
