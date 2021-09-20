; ---------------------------------------------------------------------------
; Sprite mappings - gargoyle head (LZ)
; ---------------------------------------------------------------------------
Map_Gar:	index *
		ptr frame_gargoyle_head
		ptr frame_gargoyle_head
		ptr frame_gargoyle_fireball1
		ptr frame_gargoyle_fireball2
		
frame_gargoyle_head:
		spritemap
		piece	0, -$10, 2x1, 0
		piece	-$10, -8, 4x2, 2
		piece	-8, 8, 3x1, $A
		endsprite
		
frame_gargoyle_fireball1:
		spritemap
		piece	-8, -4, 2x1, $D
		endsprite
		
frame_gargoyle_fireball2:
		spritemap
		piece	-8, -4, 2x1, $F
		endsprite
		even
