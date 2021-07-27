; ---------------------------------------------------------------------------
; Sprite mappings - switches (MZ, SYZ, LZ, SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr byte_BEAC
		ptr byte_BEB7
		ptr byte_BEC2
		ptr byte_BEB7
		
byte_BEAC:	spritemap
		piece	-$10, -$B, 2x2, 0
		piece	0, -$B, 2x2, 0, xflip
		endsprite
		
byte_BEB7:	spritemap
		piece	-$10, -$B, 2x2, 4
		piece	0, -$B, 2x2, 4, xflip
		endsprite
		
byte_BEC2:	spritemap
		piece	-$10, -$B, 2x2, $FFFC
		piece	0, -$B, 2x2, $7FC
		endsprite
		piece	-8, -8, 2x2, 0
		even
