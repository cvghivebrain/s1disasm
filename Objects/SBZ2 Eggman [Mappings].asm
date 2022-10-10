; ---------------------------------------------------------------------------
; Sprite mappings - Eggman (SBZ2, FZ)
; ---------------------------------------------------------------------------
Map_SEgg:	index offset(*)
		ptr frame_eggman_stand
		ptr frame_eggman_laugh1
		ptr frame_eggman_laugh2
		ptr frame_eggman_jump1
		ptr frame_eggman_jump2
		ptr frame_eggman_surprise
		ptr frame_eggman_jump
		ptr frame_eggman_running1
		ptr frame_eggman_running2
		ptr frame_eggman_intube
		ptr frame_eggman_cockpit
		
frame_eggman_stand:
		spritemap
		piece	-$18, -4, 1x1, $8F
		piece	-$10, -$18, 4x3, 0
		piece	-$10, 0, 4x4, $6F
		endsprite
		
frame_eggman_laugh1:
		spritemap
		piece	-$10, -$18, 4x2, $E
		piece	-$10, -$18, 4x3, 0
		piece	-$10, 0, 4x4, $6F
		piece	-$18, -4, 1x1, $8F
		endsprite
		dc.b 0
		
frame_eggman_laugh2:
		spritemap
		piece	-$10, -$17, 4x2, $E
		piece	-$10, -$17, 4x3, 0
		piece	-$10, 1, 4x4, $7F
		piece	-$18, -3, 1x1, $8F
		endsprite
		dc.b 0
		
frame_eggman_jump1:
		spritemap
		piece	-$10, -$C, 4x4, $20, xflip
		piece	$10, -$B, 2x1, $30, xflip
		piece	-$10, 8, 3x2, $4E, xflip
		piece	-$10, -$14, 4x3, 0
		endsprite
		dc.b 0
		
frame_eggman_jump2:
		spritemap
		piece	-$10, -$10, 4x4, $20, xflip
		piece	$10, -$F, 2x1, $30, xflip
		piece	-8, 8, 2x3, $3E, xflip
		piece	-$10, -$18, 4x3, 0
		endsprite
		dc.b 0
		
frame_eggman_surprise:
		spritemap
		piece	-$14, -$18, 4x2, $16
		piece	$C, -$18, 1x2, $1E
		piece	-$10, -$18, 4x3, 0
		piece	-$10, 0, 4x4, $6F
		endsprite
		dc.b 0
		
frame_eggman_jump:
		spritemap
		piece	-$14, -$18, 4x2, $16
		piece	$C, -$18, 1x2, $1E
		piece	0, 4, 3x2, $34, xflip
		piece	-$18, 4, 2x2, $3A, xflip
		piece	-$10, -$10, 4x4, $20, xflip
		piece	$10, -$F, 2x1, $54, xflip
		piece	-$20, -$F, 2x1, $54
		endsprite
		
frame_eggman_running1:
		spritemap
		piece	-$10, -$10, 4x4, $20, xflip
		piece	$10, -$F, 2x1, $30, xflip
		piece	0, 4, 3x2, $34, xflip
		piece	-$18, 4, 2x2, $3A, xflip
		piece	-$10, -$18, 4x3, 0
		endsprite
		
frame_eggman_running2:
		spritemap
		piece	-$10, -$12, 4x4, $20, xflip
		piece	$10, -$11, 2x1, $30, xflip
		piece	0, 9, 2x2, $44, xflip
		piece	-8, 3, 1x2, $48, xflip
		piece	-$18, $B, 2x2, $4A, xflip
		piece	-$10, -$1A, 4x3, 0
		endsprite
		dc.b 0
		
frame_eggman_intube:
		spritemap					; Eggman inside tube in Final Zone
		piece	-$14, -$18, 4x2, $16
		piece	$C, -$18, 1x2, $1E
		piece	-$10, -$18, 4x3, 0
		piece	-$10, 0, 4x4, $6F
		piece	-$10, -$20, 4x2, $6F0, xflip, yflip, pal2
		piece	-$10, -$10, 4x2, $6F0, xflip, yflip, pal2
		piece	-$10, 0, 4x2, $6F0, xflip, yflip, pal2
		piece	-$10, $10, 4x2, $6F0, xflip, yflip, pal2
		endsprite
		
frame_eggman_cockpit:
		spritemap					; empty cockpit of Eggmobile in Final Zone
		piece	-$1C, -$14, 4x2, $56
		piece	4, -$C, 3x1, $5E
		piece	-4, -$14, 4x2, $61
		endsprite
		even
