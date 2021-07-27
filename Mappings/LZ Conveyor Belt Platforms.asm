; ---------------------------------------------------------------------------
; Sprite mappings - platforms on a conveyor belt (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @wheel1
		ptr @wheel2
		ptr @wheel3
		ptr @wheel4
		ptr @platform
		
@wheel1:	spritemap
		piece	-$10, -$10, 4x4, 0
		endsprite
		
@wheel2:	spritemap
		piece	-$10, -$10, 4x4, $10
		endsprite
		
@wheel3:	spritemap
		piece	-$10, -$10, 4x4, $20
		endsprite
		
@wheel4:	spritemap
		piece	-$10, -$10, 4x4, $30
		endsprite
		
@platform:	spritemap
		piece	-$10, -8, 4x2, $40
		endsprite
		even
