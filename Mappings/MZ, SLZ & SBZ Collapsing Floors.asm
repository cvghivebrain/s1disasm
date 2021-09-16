; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ,	SBZ)
; ---------------------------------------------------------------------------
Map_CFlo:	index *
		ptr frame_cfloor_mz
		ptr frame_cfloor_mz_break
		ptr frame_cfloor_slz
		ptr frame_cfloor_slz_break
		
frame_cfloor_mz:
		spritemap		; MZ and SBZ blocks
		piece	-$20, -8, 4x2, 0
		piece	-$20, 8, 4x2, 0
		piece	0, -8, 4x2, 0
		piece	0, 8, 4x2, 0
		endsprite
		
frame_cfloor_mz_break:
		spritemap
		piece	-$20, -8, 2x2, 0
		piece	-$10, -8, 2x2, 0
		piece	0, -8, 2x2, 0
		piece	$10, -8, 2x2, 0
		piece	-$20, 8, 2x2, 0
		piece	-$10, 8, 2x2, 0
		piece	0, 8, 2x2, 0
		piece	$10, 8, 2x2, 0
		endsprite
		
frame_cfloor_slz:
		spritemap		; SLZ blocks
		piece	-$20, -8, 4x2, 0
		piece	-$20, 8, 4x2, 8
		piece	0, -8, 4x2, 0
		piece	0, 8, 4x2, 8
		endsprite
		
frame_cfloor_slz_break:
		spritemap
		piece	-$20, -8, 2x2, 0
		piece	-$10, -8, 2x2, 4
		piece	0, -8, 2x2, 0
		piece	$10, -8, 2x2, 4
		piece	-$20, 8, 2x2, 8
		piece	-$10, 8, 2x2, $C
		piece	0, 8, 2x2, 8
		piece	$10, 8, 2x2, $C
		endsprite
		even
