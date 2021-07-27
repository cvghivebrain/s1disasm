; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------
		index *
		ptr byte_CFF4
		ptr byte_D004
		ptr byte_D014
		ptr byte_D01A
		ptr byte_D02A
		ptr byte_D049
		
byte_CFF4:	spritemap			; 3 spikes
		piece	-$14, -$10, 1x4, 4
		piece	-4, -$10, 1x4, 4
		piece	$C, -$10, 1x4, 4
		endsprite
		
byte_D004:	spritemap			; 3 spikes facing sideways
		piece	-$10, -$14, 4x1, 0
		piece	-$10, -4, 4x1, 0
		piece	-$10, $C, 4x1, 0
		endsprite
		
byte_D014:	spritemap			; 1 spike
		piece	-4, -$10, 1x4, 4
		endsprite
		
byte_D01A:	spritemap			; 3 spikes widely spaced
		piece	-$1C, -$10, 1x4, 4
		piece	-4, -$10, 1x4, 4
		piece	$14, -$10, 1x4, 4
		endsprite
		
byte_D02A:	spritemap			; 6 spikes
		piece	-$40, -$10, 1x4, 4
		piece	-$28, -$10, 1x4, 4
		piece	-$10, -$10, 1x4, 4
		piece	8, -$10, 1x4, 4
		piece	$20, -$10, 1x4, 4
		piece	$38, -$10, 1x4, 4
		endsprite
		
byte_D049:	spritemap			; 1 spike facing sideways
		piece	-$10, -4, 4x1, 0
		endsprite
		even
