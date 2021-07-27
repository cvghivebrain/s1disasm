; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @open1
		ptr @shut1
		ptr @open2
		ptr @shut2
		
@open1:		spritemap		; mouth open
		piece	-$10, -$C, 4x3, 0
		piece	$10, -$B, 2x2, $18
		endsprite
		
@shut1:		spritemap		; mouth shut
		piece	-$10, -$C, 4x3, $C
		piece	$10, -$B, 2x2, $1C
		endsprite
		
@open2:		spritemap
		piece	-$10, -$C, 4x3, 0
		piece	$10, -$B, 2x2, $18, yflip
		endsprite
		
@shut2:		spritemap
		piece	-$10, -$C, 4x3, $C
		piece	$10, -$B, 2x2, $1C, yflip
		endsprite
		even
