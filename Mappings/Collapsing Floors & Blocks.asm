; ---------------------------------------------------------------------------
; Sprite mappings - collapsing floors (MZ, SLZ,	SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr byte_874E
		ptr byte_8763
		ptr byte_878C
		ptr byte_87A1
		
byte_874E:	spritemap		; MZ and SBZ blocks
		piece	-$20, -8, 4x2, 0
		piece	-$20, 8, 4x2, 0
		piece	0, -8, 4x2, 0
		piece	0, 8, 4x2, 0
		endsprite
		
byte_8763:	spritemap
		piece	-$20, -8, 2x2, 0
		piece	-$10, -8, 2x2, 0
		piece	0, -8, 2x2, 0
		piece	$10, -8, 2x2, 0
		piece	-$20, 8, 2x2, 0
		piece	-$10, 8, 2x2, 0
		piece	0, 8, 2x2, 0
		piece	$10, 8, 2x2, 0
		endsprite
		
byte_878C:	spritemap		; SLZ blocks
		piece	-$20, -8, 4x2, 0
		piece	-$20, 8, 4x2, 8
		piece	0, -8, 4x2, 0
		piece	0, 8, 4x2, 8
		endsprite
		
byte_87A1:	spritemap
		piece	-$20, -8, 2x2, 0
		piece	-$10, -8, 2x2, 4
		piece	0, -8, 2x2, 0
		piece	$10, -8, 2x2, 4
		piece	-$20, 8, 2x2, 8
		piece	-$10, 8, 2x2, $C
		piece	0, 8, 2x2, 8
		piece	$10, 8, 2x2, $C
		endsprite
		even
