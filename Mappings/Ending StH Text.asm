; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC THE HEDGEHOG" text on the ending sequence
; ---------------------------------------------------------------------------
Map_ESth:	index *
		ptr frame_esth_0
		
frame_esth_0:	spritemap
		piece	-$30, -$10, 4x4, 0
		piece	-$10, -$10, 4x4, $10
		piece	$10, -$10, 4x4, $20
		endsprite
		even
