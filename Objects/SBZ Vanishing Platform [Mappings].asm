; ---------------------------------------------------------------------------
; Sprite mappings - vanishing platforms	(SBZ)
; ---------------------------------------------------------------------------
Map_VanP:	index offset(*)
		ptr frame_vanish_whole
		ptr frame_vanish_half
		ptr frame_vanish_quarter
		ptr frame_vanish_gone
		
frame_vanish_whole:
		spritemap
		piece	-$10, -8, 4x4, 0
		endsprite
		
frame_vanish_half:
		spritemap
		piece	-8, -8, 2x4, $10
		endsprite
		
frame_vanish_quarter:
		spritemap
		piece	-4, -8, 1x4, $18
		endsprite
		
frame_vanish_gone:
		spritemap
		endsprite
		even
