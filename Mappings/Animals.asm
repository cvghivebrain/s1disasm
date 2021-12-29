; ---------------------------------------------------------------------------
; Sprite mappings - animals
; ---------------------------------------------------------------------------
Map_Animal1:	index *
		ptr frame_animal1_flap1
		ptr frame_animal1_flap2
		ptr frame_animal1_drop
		
frame_animal1_drop:
		spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
frame_animal1_flap1:
		spritemap
		piece	-8, -$C, 2x3, 6
		endsprite
		
frame_animal1_flap2:
		spritemap
		piece	-8, -$C, 2x3, $C
		endsprite
		even

Map_Animal2:	index *
		ptr frame_animal2_flap1
		ptr frame_animal2_flap2
		ptr frame_animal2_drop
		
frame_animal2_drop:
		spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
frame_animal2_flap1:
		spritemap
		piece	-8, -4, 2x2, 6
		endsprite
		
frame_animal2_flap2:
		spritemap
		piece	-8, -4, 2x2, $A
		endsprite
		even

Map_Animal3:	index *
		ptr frame_animal3_flap1
		ptr frame_animal3_flap2
		ptr frame_animal3_drop
		
frame_animal3_drop:
		spritemap
		piece	-8, -$C, 2x3, 0
		endsprite
		
frame_animal3_flap1:
		spritemap
		piece	-$C, -4, 3x2, 6
		endsprite
		
frame_animal3_flap2:
		spritemap
		piece	-$C, -4, 3x2, $C
		endsprite
		even
