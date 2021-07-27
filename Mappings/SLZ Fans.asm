; ---------------------------------------------------------------------------
; Sprite mappings - fans (SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @fan1
		ptr @fan2
		ptr @fan3
		ptr @fan2
		ptr @fan1
		
@fan1:		spritemap
		piece	-8, -$10, 3x2, 0
		piece	-$10, 0, 4x2, 6
		endsprite
		
@fan2:		spritemap
		piece	-$10, -$10, 4x2, $E
		piece	-$10, 0, 4x2, $16
		endsprite
		
@fan3:		spritemap
		piece	-$10, -$10, 4x2, $1E
		piece	-8, 0, 3x2, $26
		endsprite
		even
