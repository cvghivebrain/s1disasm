; ---------------------------------------------------------------------------
; Sprite mappings - energy ball	launcher (FZ)
; ---------------------------------------------------------------------------
		index *
		ptr @red
		ptr @white
		ptr @sparking1
		ptr @sparking2
		
@red:		spritemap
		piece	-8, -8, 2x2, $6E
		endsprite
		
@white:		spritemap
		piece	-8, -8, 2x2, $76
		endsprite
		
@sparking1:	spritemap
		piece	-8, -8, 2x2, $72
		endsprite
		
@sparking2:	spritemap
		piece	-8, -8, 2x2, $72, yflip
		endsprite
		even
