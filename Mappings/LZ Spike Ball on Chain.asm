; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball	on a chain (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @chain
		ptr @spikeball
		ptr @base
		
@chain:		spritemap			; chain link
		piece	-8, -8, 2x2, 0
		endsprite
		
@spikeball:	spritemap			; spikeball
		piece	-$10, -$10, 4x4, 4
		endsprite
		
@base:		spritemap			; wall attachment
		piece	-8, -8, 2x2, $14
		endsprite
		even
