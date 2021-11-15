; ---------------------------------------------------------------------------
; Sprite mappings - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------
Map_Burro:	index *
		ptr frame_burro_walk1
		ptr frame_burro_walk2
		ptr frame_burro_dig1
		ptr frame_burro_dig2
		ptr frame_burro_fall
		ptr frame_burro_facedown
		ptr frame_burro_walk3
		
frame_burro_walk1:
		spritemap					; walking
		piece	-$10, -$14, 3x3, 0
		piece	-$C, 4, 3x2, 9
		endsprite
		
frame_burro_walk2:
		spritemap
		piece	-$10, -$14, 3x3, $F
		piece	-$C, 4, 3x2, $18
		endsprite
		
frame_burro_dig1:
		spritemap					; digging
		piece	-$C, -$18, 3x3, $1E
		piece	-$C, 0, 3x3, $27
		endsprite
		
frame_burro_dig2:
		spritemap
		piece	-$C, -$18, 3x3, $30
		piece	-$C, 0, 3x3, $39
		endsprite
		
frame_burro_fall:
		spritemap					; falling after jumping up
		piece	-$10, -$18, 3x3, $F
		piece	-$C, 0, 3x3, $42
		endsprite
		
frame_burro_facedown:
		spritemap					; facing down (unused)
		piece	-$18, -$C, 2x3, $4B
		piece	-8, -$C, 3x3, $51
		endsprite
		
frame_burro_walk3:
		spritemap
		piece	-$10, -$14, 3x3, $F
		piece	-$C, 4, 3x2, 9
		endsprite
		even
