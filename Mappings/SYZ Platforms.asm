; ---------------------------------------------------------------------------
; Sprite mappings - SYZ	platforms
; ---------------------------------------------------------------------------
Map_Plat_SYZ:	index *
		ptr frame_plat_syz
		
frame_plat_syz:	spritemap
		piece	-$20, -$A, 3x4, $49
		piece	-8, -$A, 2x4, $51
		piece	8, -$A, 3x4, $55
		endsprite
		even
