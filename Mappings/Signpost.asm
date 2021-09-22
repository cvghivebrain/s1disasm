; ---------------------------------------------------------------------------
; Sprite mappings - signpost
; ---------------------------------------------------------------------------
Map_Sign:	index *
		ptr frame_sign_eggman
		ptr frame_sign_spin1
		ptr frame_sign_spin2
		ptr frame_sign_spin3
		ptr frame_sign_sonic
		
frame_sign_eggman:
		spritemap
		piece	-$18, -$10, 3x4, 0
		piece	0, -$10, 3x4, 0, xflip
		piece	-4, $10, 1x2, $38
		endsprite
		
frame_sign_spin1:
		spritemap
		piece	-$10, -$10, 4x4, $C
		piece	-4, $10, 1x2, $38
		endsprite
		
frame_sign_spin2:
		spritemap
		piece	-4, -$10, 1x4, $1C
		piece	-4, $10, 1x2, $38, xflip
		endsprite
		
frame_sign_spin3:
		spritemap
		piece	-$10, -$10, 4x4, $C, xflip
		piece	-4, $10, 1x2, $38, xflip
		endsprite
		
frame_sign_sonic:
		spritemap
		piece	-$18, -$10, 3x4, $20
		piece	0, -$10, 3x4, $2C
		piece	-4, $10, 1x2, $38
		endsprite
		even
