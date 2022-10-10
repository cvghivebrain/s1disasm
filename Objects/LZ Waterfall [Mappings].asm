; ---------------------------------------------------------------------------
; Sprite mappings - waterfalls (LZ)
; ---------------------------------------------------------------------------
Map_WFall:	index offset(*)
		ptr frame_wfall_vertnarrow
		ptr frame_wfall_cornerwide
		ptr frame_wfall_cornermedium
		ptr frame_wfall_cornernarrow
		ptr frame_wfall_cornermedium2
		ptr frame_wfall_cornernarrow2
		ptr frame_wfall_cornernarrow3
		ptr frame_wfall_vertwide
		ptr frame_wfall_diagonal
		ptr frame_wfall_splash1
		ptr frame_wfall_splash2
		ptr frame_wfall_splash3
		
frame_wfall_vertnarrow:
		spritemap
		piece	-8, -$10, 2x4, 0
		endsprite
		
frame_wfall_cornerwide:
		spritemap
		piece	-4, -8, 2x1, 8
		piece	-$C, 0, 3x1, $A
		endsprite
		
frame_wfall_cornermedium:
		spritemap
		piece	0, -8, 1x1, 8
		piece	-8, 0, 2x1, $D
		endsprite
		
frame_wfall_cornernarrow:
		spritemap
		piece	0, -8, 1x2, $F
		endsprite
		
frame_wfall_cornermedium2:
		spritemap
		piece	0, -8, 1x1, 8
		piece	-8, 0, 2x1, $D
		endsprite
		
frame_wfall_cornernarrow2:
		spritemap
		piece	0, -8, 1x2, $11
		endsprite
		
frame_wfall_cornernarrow3:
		spritemap
		piece	0, -8, 1x2, $13
		endsprite
		
frame_wfall_vertwide:
		spritemap
		piece	-8, -$10, 2x4, $15
		endsprite
		
frame_wfall_diagonal:
		spritemap
		piece	-$A, -8, 4x1, $1D
		piece	-$18, 0, 4x1, $21
		endsprite
		
frame_wfall_splash1:
		spritemap
		piece	-$18, -$10, 3x4, $25
		piece	0, -$10, 3x4, $31
		endsprite
		
frame_wfall_splash2:
		spritemap
		piece	-$18, -$10, 3x4, $3D
		piece	0, -$10, 3x4, $49
		endsprite
		
frame_wfall_splash3:
		spritemap
		piece	-$18, -$10, 3x4, $55
		piece	0, -$10, 3x4, $61
		endsprite
		even
