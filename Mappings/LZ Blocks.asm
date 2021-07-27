; ---------------------------------------------------------------------------
; Sprite mappings - blocks (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @sinkblock
		ptr @riseplatform
		ptr @cork
		ptr @block
		
@sinkblock:	spritemap			; block, sinks when stood on
		piece	-$10, -$10, 4x4, 0
		endsprite
		
@riseplatform:	spritemap			; platform, rises when stood on
		piece	-$20, -$C, 4x3, $69
		piece	0, -$C, 4x3, $75
		endsprite
		
@cork:		spritemap			; cork, floats on water
		piece	-$10, -$10, 4x4, $11A
		endsprite
		
@block:		spritemap			; block
		piece	-$10, -$10, 4x4, $FDFA
		endsprite
		even
