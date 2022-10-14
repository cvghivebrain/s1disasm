; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	when you stand on them (SLZ)
; ---------------------------------------------------------------------------
Map_Elev:	index offset(*)
		ptr frame_elev_0
		
frame_elev_0:	spritemap
		piece	-$28, -8, 4x4, $41
		piece	-8, -8, 4x4, $41
		piece	$18, -8, 2x4, $41
		endsprite
		even
