; ---------------------------------------------------------------------------
; Sprite mappings - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------
Map_Moto:	index *
		ptr frame_moto_0
		ptr frame_moto_1
		ptr frame_moto_2
		ptr frame_moto_smoke1
		ptr frame_moto_smoke2
		ptr frame_moto_smoke3
		ptr frame_moto_blank
		
frame_moto_0:
		spritemap
		piece	-$14, -$10, 4x2, 0
		piece	-$14, 0, 4x1, 8
		piece	$C, -8, 1x2, $C
		piece	-$C, 8, 3x1, $E
		endsprite
		
frame_moto_1:
		spritemap
		piece	-$14, -$F, 4x2, 0
		piece	-$14, 1, 4x1, 8
		piece	$C, -7, 1x2, $C
		piece	-$C, 9, 3x1, $11
		endsprite
		
frame_moto_2:
		spritemap
		piece	-$14, -$10, 4x2, 0
		piece	-$14, 0, 4x1, $14
		piece	$C, -8, 1x2, $C
		piece	-$14, 8, 2x1, $18
		piece	-4, 8, 2x1, $12
		endsprite
		
frame_moto_smoke1:
		spritemap
		piece	$10, -6, 1x1, $1A
		endsprite
		
frame_moto_smoke2:
		spritemap
		piece	$10, -6, 1x1, $1B
		endsprite
		
frame_moto_smoke3:
		spritemap
		piece	$10, -6, 1x1, $1C
		endsprite
		
frame_moto_blank:
		spritemap
		endsprite
		even
