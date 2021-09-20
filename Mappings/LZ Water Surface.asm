; ---------------------------------------------------------------------------
; Sprite mappings - water surface (LZ)
; ---------------------------------------------------------------------------
Map_Surf:	index *
		ptr frame_surf_normal1
		ptr frame_surf_normal2
		ptr frame_surf_normal3
		ptr frame_surf_paused1
		ptr frame_surf_paused2
		ptr frame_surf_paused3
		
frame_surf_normal1:
		spritemap
		piece	-$60, -3, 4x2, 0
		piece	-$20, -3, 4x2, 0
		piece	$20, -3, 4x2, 0
		endsprite
		
frame_surf_normal2:
		spritemap
		piece	-$60, -3, 4x2, 8
		piece	-$20, -3, 4x2, 8
		piece	$20, -3, 4x2, 8
		endsprite
		
frame_surf_normal3:
		spritemap
		piece	-$60, -3, 4x2, 0, xflip
		piece	-$20, -3, 4x2, 0, xflip
		piece	$20, -3, 4x2, 0, xflip
		endsprite
		
frame_surf_paused1:
		spritemap
		piece	-$60, -3, 4x2, 0
		piece	-$40, -3, 4x2, 0
		piece	-$20, -3, 4x2, 0
		piece	0, -3, 4x2, 0
		piece	$20, -3, 4x2, 0
		piece	$40, -3, 4x2, 0
		endsprite
		
frame_surf_paused2:
		spritemap
		piece	-$60, -3, 4x2, 8
		piece	-$40, -3, 4x2, 8
		piece	-$20, -3, 4x2, 8
		piece	0, -3, 4x2, 8
		piece	$20, -3, 4x2, 8
		piece	$40, -3, 4x2, 8
		endsprite
		
frame_surf_paused3:
		spritemap
		piece	-$60, -3, 4x2, 0, xflip
		piece	-$40, -3, 4x2, 0, xflip
		piece	-$20, -3, 4x2, 0, xflip
		piece	0, -3, 4x2, 0, xflip
		piece	$20, -3, 4x2, 0, xflip
		piece	$40, -3, 4x2, 0, xflip
		endsprite
		even
