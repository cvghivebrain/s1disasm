; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	bridge
; ---------------------------------------------------------------------------
		index *
		ptr @Log
		ptr @Stump
		ptr @Rope
		
@Log:		spritemap		; log
		piece	-8, -8, 2x2, 0
		endsprite
		
@Stump:		spritemap		; stump & rope
		piece	-$10, -8, 2x1, 4
		piece	-$10, 0, 4x1, 6
		endsprite
		
@Rope:		spritemap		; rope only
		piece	-8, -4, 2x1, 8
		endsprite
		even
