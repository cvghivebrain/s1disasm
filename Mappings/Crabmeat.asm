; ---------------------------------------------------------------------------
; Sprite mappings - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------
Map_Crab:	index *
		ptr frame_crab_stand
		ptr frame_crab_walk
		ptr frame_crab_slope1
		ptr frame_crab_slope2
		ptr frame_crab_firing
		ptr frame_crab_ball1
		ptr frame_crab_ball2
		
frame_crab_stand:
		spritemap		; standing/middle walking frame
		piece	-$18, -$10, 3x2, 0
		piece	0, -$10, 3x2, 0, xflip
		piece	-$10, 0, 2x2, 6
		piece	0, 0, 2x2, 6, xflip
		endsprite
		
frame_crab_walk:
		spritemap		; walking
		piece	-$18, -$10, 3x2, $A
		piece	0, -$10, 3x2, $10
		piece	-$10, 0, 2x2, $16
		piece	0, 0, 3x2, $1A
		endsprite
		
frame_crab_slope1:
		spritemap		; walking on slope
		piece	-$18, -$14, 3x2, 0
		piece	0, -$14, 3x2, 0, xflip
		piece	0, -4, 2x2, 6, xflip
		piece	-$10, -4, 2x3, $20
		endsprite
		
frame_crab_slope2:
		spritemap		; walking on slope
		piece	-$18, -$14, 3x2, $A
		piece	0, -$14, 3x2, $10
		piece	0, -4, 3x2, $26
		piece	-$10, -4, 2x3, $2C
		endsprite
		
frame_crab_firing:
		spritemap		; firing projectiles
		piece	-$10, -$10, 2x1, $32
		piece	0, -$10, 2x1, $32, xflip
		piece	-$18, -8, 3x2, $34
		piece	0, -8, 3x2, $34, xflip
		piece	-$10, 8, 2x1, $3A
		piece	0, 8, 2x1, $3A, xflip
		endsprite
		
frame_crab_ball1:
		spritemap		; projectile
		piece	-8, -8, 2x2, $3C
		endsprite
		
frame_crab_ball2:
		spritemap		; projectile
		piece	-8, -8, 2x2, $40
		endsprite
		even
