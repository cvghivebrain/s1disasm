; ---------------------------------------------------------------------------
; Sprite mappings - invisible solid blocks (visible in debug mode)
; ---------------------------------------------------------------------------
Map_Invis:	index *
		ptr frame_invis_solid
		ptr frame_invis_unused1
		ptr frame_invis_unused2
		
frame_invis_solid:
		spritemap
		piece	-$10, -$10, 2x2, $18
		piece	0, -$10, 2x2, $18
		piece	-$10, 0, 2x2, $18
		piece	0, 0, 2x2, $18
		endsprite
		
frame_invis_unused1:
		spritemap
		piece	-$40, -$20, 2x2, $18
		piece	$30, -$20, 2x2, $18
		piece	-$40, $10, 2x2, $18
		piece	$30, $10, 2x2, $18
		endsprite
		
frame_invis_unused2:
		spritemap
		piece	-$80, -$20, 2x2, $18
		piece	$70, -$20, 2x2, $18
		piece	-$80, $10, 2x2, $18
		piece	$70, $10, 2x2, $18
		endsprite
		even
