; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ,	SLZ, SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @normal
		ptr @medium
		ptr @angry
		ptr @spikeball
		
@normal:	spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
@medium:	spritemap
		piece	-$C, -$C, 3x3, 9, pal2
		endsprite
		
@angry:		spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		
@spikeball:	spritemap
		piece	-8, -8, 2x2, $1B
		endsprite
		even
