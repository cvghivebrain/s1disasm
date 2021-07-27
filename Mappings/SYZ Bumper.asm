; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr @normal
		ptr @bumped1
		ptr @bumped2
		
@normal:	spritemap
		piece	-$10, -$10, 2x4, 0
		piece	0, -$10, 2x4, 0, xflip
		endsprite
		
@bumped1:	spritemap
		piece	-$C, -$C, 2x3, 8
		piece	4, -$C, 1x3, 8, xflip
		endsprite
		
@bumped2:	spritemap
		piece	-$10, -$10, 2x4, $E
		piece	0, -$10, 2x4, $E, xflip
		endsprite
		even
