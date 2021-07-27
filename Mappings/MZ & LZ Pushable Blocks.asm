; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @single
		ptr @four
		
@single:	spritemap		; single block
		piece	-$10, -$10, 4x4, 8
		endsprite
		
@four:		spritemap		; row of 4 blocks
		piece	-$40, -$10, 4x4, 8
		piece	-$20, -$10, 4x4, 8
		piece	0, -$10, 4x4, 8
		piece	$20, -$10, 4x4, 8
		endsprite
		even
