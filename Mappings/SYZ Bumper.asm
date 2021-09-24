; ---------------------------------------------------------------------------
; Sprite mappings - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
Map_Bump:	index *
		ptr frame_bump_normal
		ptr frame_bump_bumped1
		ptr frame_bump_bumped2
		
frame_bump_normal:
		spritemap
		piece	-$10, -$10, 2x4, 0
		piece	0, -$10, 2x4, 0, xflip
		endsprite
		
frame_bump_bumped1:
		spritemap
		piece	-$C, -$C, 2x3, 8
		piece	4, -$C, 1x3, 8, xflip
		endsprite
		
frame_bump_bumped2:
		spritemap
		piece	-$10, -$10, 2x4, $E
		piece	0, -$10, 2x4, $E, xflip
		endsprite
		even
