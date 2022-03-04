; ---------------------------------------------------------------------------
; Sprite mappings - walls (GHZ)
; ---------------------------------------------------------------------------
Map_Edge:	index *
		ptr frame_edge_shadow
		ptr frame_edge_light
		ptr frame_edge_dark
		
frame_edge_shadow:
		spritemap					; light with shadow
		piece	-8, -$20, 2x2, 4
		piece	-8, -$10, 2x2, 8
		piece	-8, 0, 2x2, 8
		piece	-8, $10, 2x2, 8
		endsprite
		
frame_edge_light:
		spritemap					; light with no shadow
		piece	-8, -$20, 2x2, 8
		piece	-8, -$10, 2x2, 8
		piece	-8, 0, 2x2, 8
		piece	-8, $10, 2x2, 8
		endsprite
		
frame_edge_dark:
		spritemap					; all shadow
		piece	-8, -$20, 2x2, 0
		piece	-8, -$10, 2x2, 0
		piece	-8, 0, 2x2, 0
		piece	-8, $10, 2x2, 0
		endsprite
		even
