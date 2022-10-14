; ---------------------------------------------------------------------------
; Sprite mappings - water splash (LZ)
; ---------------------------------------------------------------------------
Map_Splash:	index offset(*)
		ptr frame_splash_0
		ptr frame_splash_1
		ptr frame_splash_2
		
frame_splash_0:
		spritemap
		piece	-8, -$E, 2x1, $6D
		piece	-$10, -6, 4x1, $6F
		endsprite
		
frame_splash_1:
		spritemap
		piece	-8, -$1E, 1x1, $73
		piece	-$10, -$16, 4x3, $74
		endsprite
		
frame_splash_2:
		spritemap
		piece	-$10, -$1E, 4x4, $80
		endsprite
		even
