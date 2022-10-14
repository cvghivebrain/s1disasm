; ---------------------------------------------------------------------------
; Sprite mappings - Sonic's face when drowning (LZ) (unused)
; ---------------------------------------------------------------------------
Map_Drown:	index offset(*)
		ptr frame_drown_face
		
frame_drown_face:
		spritemap
		piece	-$E, -$18, 4x3, 0
		endsprite
		even
