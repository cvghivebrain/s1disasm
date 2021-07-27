; ---------------------------------------------------------------------------
; Sprite mappings - spinning platforms (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @flat
		ptr @spin1
		ptr @spin2
		ptr @spin3
		ptr @spin4
		
@flat:		spritemap
		piece	-$10, -8, 2x2, 0
		piece	0, -8, 2x2, 0, xflip
		endsprite
		
@spin1:		spritemap
		piece	-$10, -$10, 4x2, $14
		piece	-$10, 0, 4x2, $1C
		endsprite
		
@spin2:		spritemap
		piece	-$10, -$10, 3x2, 4
		piece	-8, 0, 3x2, $A
		endsprite
		
@spin3:		spritemap
		piece	-$10, -$10, 3x2, $24
		piece	-8, 0, 3x2, $2A
		endsprite
		
@spin4:		spritemap
		piece	-8, -$10, 2x2, $10
		piece	-8, 0, 2x2, $10, yflip
		endsprite
		even
