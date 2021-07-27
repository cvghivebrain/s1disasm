; ---------------------------------------------------------------------------
; Sprite mappings - large moving grass-covered platforms (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr @wide
		ptr @sloped
		ptr @narrow
		
@wide:		spritemap		; wide platform
		piece	-$40, -$28, 2x3, $57
		piece	-$40, -$10, 2x2, $53
		piece	-$40, 0, 4x4, 1
		piece	-$30, -$30, 4x4, $27
		piece	-$30, -$10, 4x2, $37
		piece	-$20, -$10, 4x4, 1
		piece	-$10, -$30, 4x4, $11
		piece	$10, -$30, 4x4, $3F
		piece	$10, -$10, 4x2, $4F
		piece	0, -$10, 4x4, 1
		piece	$20, 0, 4x4, 1
		piece	$30, -$28, 2x3, $57
		piece	$30, -$10, 2x2, $53
		endsprite
		
@sloped:	spritemap		; sloped platform (catches fire)
		piece	-$40, -$30, 4x4, $27
		piece	-$40, -$10, 4x2, $37
		piece	-$40, 0, 4x4, 1
		piece	-$20, -$40, 4x4, $27
		piece	-$20, -$20, 4x2, $37
		piece	-$20, -$10, 4x4, 1
		piece	0, -$40, 4x4, $11
		piece	0, -$20, 4x4, 1
		piece	$20, -$40, 4x4, $3F
		piece	$20, -$20, 4x2, $4F
		endsprite
		
@narrow:	spritemap		; narrow platform
		piece	-$20, -$30, 4x4, $11
		piece	-$20, -$10, 4x4, 1
		piece	-$20, $10, 4x4, 1
		piece	0, -$30, 4x4, $11
		piece	0, -$10, 4x4, 1
		piece	0, $10, 4x4, 1
		endsprite
		even
