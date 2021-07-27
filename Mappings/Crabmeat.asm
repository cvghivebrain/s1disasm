; ---------------------------------------------------------------------------
; Sprite mappings - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr @stand
		ptr @walk
		ptr @slope1
		ptr @slope2
		ptr @firing
		ptr @ball1
		ptr @ball2
		
@stand:		spritemap		; standing/middle walking frame
		piece	-$18, -$10, 3x2, 0
		piece	0, -$10, 3x2, 0, xflip
		piece	-$10, 0, 2x2, 6
		piece	0, 0, 2x2, 6, xflip
		endsprite
		
@walk:		spritemap		; walking
		piece	-$18, -$10, 3x2, $A
		piece	0, -$10, 3x2, $10
		piece	-$10, 0, 2x2, $16
		piece	0, 0, 3x2, $1A
		endsprite
		
@slope1:	spritemap		; walking on slope
		piece	-$18, -$14, 3x2, 0
		piece	0, -$14, 3x2, 0, xflip
		piece	0, -4, 2x2, 6, xflip
		piece	-$10, -4, 2x3, $20
		endsprite
		
@slope2:	spritemap		; walking on slope
		piece	-$18, -$14, 3x2, $A
		piece	0, -$14, 3x2, $10
		piece	0, -4, 3x2, $26
		piece	-$10, -4, 2x3, $2C
		endsprite
		
@firing:	spritemap		; firing projectiles
		piece	-$10, -$10, 2x1, $32
		piece	0, -$10, 2x1, $32, xflip
		piece	-$18, -8, 3x2, $34
		piece	0, -8, 3x2, $34, xflip
		piece	-$10, 8, 2x1, $3A
		piece	0, 8, 2x1, $3A, xflip
		endsprite
		
@ball1:		spritemap		; projectile
		piece	-8, -8, 2x2, $3C
		endsprite
		
@ball2:		spritemap		; projectile
		piece	-8, -8, 2x2, $40
		endsprite
		even
