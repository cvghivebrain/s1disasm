; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	disintegrate when Eggman presses a switch
; ---------------------------------------------------------------------------
Map_FFloor:	index offset(*)
		ptr frame_ffloor_wholeblock
		ptr frame_ffloor_topleft
		ptr frame_ffloor_topright
		ptr frame_ffloor_bottomleft
		ptr frame_ffloor_bottomright
		
frame_ffloor_wholeblock:
		spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
frame_ffloor_topleft:
		spritemap
		piece	-8, -8, 1x2, 0
		piece	0, -8, 1x2, 4
		endsprite
		dc.b 0
		
frame_ffloor_topright:
		spritemap
		piece	-8, -8, 1x2, 8
		piece	0, -8, 1x2, $C
		endsprite
		dc.b 0
		
frame_ffloor_bottomleft:
		spritemap
		piece	-8, -8, 1x2, 2
		piece	0, -8, 1x2, 6
		endsprite
		dc.b 0
		
frame_ffloor_bottomright:
		spritemap
		piece	-8, -8, 1x2, $A
		piece	0, -8, 1x2, $E
		endsprite
		even
