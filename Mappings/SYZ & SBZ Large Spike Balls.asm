; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball on a chain (SBZ) and big spiked ball (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr @ball
		ptr @chain
		ptr @anchor
		
@ball:		spritemap			; big spiked ball
		piece	-8, -$18, 2x1, 0
		piece	-$10, -$10, 4x4, 2
		piece	-$18, -8, 1x2, $12
		piece	$10, -8, 1x2, $14
		piece	-8, $10, 2x1, $16
		endsprite
		
@chain:		spritemap			; chain link (SBZ)
		piece	-8, -8, 2x2, $20
		endsprite
		
@anchor:	spritemap			; anchor at base of chain (SBZ)
		piece	-$10, -8, 4x2, $18
		piece	-$10, -$18, 4x2, $18, yflip
		endsprite
		even
