; ---------------------------------------------------------------------------
; Sprite mappings - Jaws enemy (LZ)
; ---------------------------------------------------------------------------
Map_Jaws:	index offset(*)
		ptr frame_jaws_open1
		ptr frame_jaws_shut1
		ptr frame_jaws_open2
		ptr frame_jaws_shut2
		
frame_jaws_open1:
		spritemap					; mouth open
		piece	-$10, -$C, 4x3, 0
		piece	$10, -$B, 2x2, $18
		endsprite
		
frame_jaws_shut1:
		spritemap					; mouth shut
		piece	-$10, -$C, 4x3, $C
		piece	$10, -$B, 2x2, $1C
		endsprite
		
frame_jaws_open2:
		spritemap
		piece	-$10, -$C, 4x3, 0
		piece	$10, -$B, 2x2, $18, yflip
		endsprite
		
frame_jaws_shut2:
		spritemap
		piece	-$10, -$C, 4x3, $C
		piece	$10, -$B, 2x2, $1C, yflip
		endsprite
		even
