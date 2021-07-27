; ---------------------------------------------------------------------------
; Sprite mappings - platforms that move	when you stand on them (SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @elevator
		
@elevator:	spritemap
		piece	-$28, -8, 4x4, $41
		piece	-8, -8, 4x4, $41
		piece	$18, -8, 2x4, $41
		endsprite
		even
