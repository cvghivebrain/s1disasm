; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------
		index *
		ptr byte_F538
		ptr byte_F566
		ptr byte_F594
		ptr byte_F5C2
		ptr byte_F5F0
		
byte_F538:	spritemap
		piece	$20, -$20, 4x4, $60
		piece	$3C, 0, 4x4, $70
		piece	$20, 0, 4x4, $FF2A
		piece	0, -$20, 4x4, $FF2A
		piece	0, 0, 4x4, $FF2A
		piece	-$20, -$20, 4x4, $FF2A
		piece	-$20, 0, 4x4, $FF2A
		piece	-$40, -$20, 4x4, $FF2A
		piece	-$40, 0, 4x4, $FF2A
		endsprite
		
byte_F566:	spritemap
		piece	$20, -$20, 4x4, $70
		piece	$3C, 0, 4x4, $80
		piece	$20, 0, 4x4, $FF2A
		piece	0, -$20, 4x4, $FF2A
		piece	0, 0, 4x4, $FF2A
		piece	-$20, -$20, 4x4, $FF2A
		piece	-$20, 0, 4x4, $FF2A
		piece	-$40, -$20, 4x4, $FF2A
		piece	-$40, 0, 4x4, $FF2A
		endsprite
		
byte_F594:	spritemap
		piece	$20, -$20, 4x4, $80
		piece	$3C, 0, 4x4, $70
		piece	$20, 0, 4x4, $FF2A
		piece	0, -$20, 4x4, $FF2A
		piece	0, 0, 4x4, $FF2A
		piece	-$20, -$20, 4x4, $FF2A
		piece	-$20, 0, 4x4, $FF2A
		piece	-$40, -$20, 4x4, $FF2A
		piece	-$40, 0, 4x4, $FF2A
		endsprite
		
byte_F5C2:	spritemap
		piece	$20, -$20, 4x4, $70
		piece	$3C, 0, 4x4, $60
		piece	$20, 0, 4x4, $FF2A
		piece	0, -$20, 4x4, $FF2A
		piece	0, 0, 4x4, $FF2A
		piece	-$20, -$20, 4x4, $FF2A
		piece	-$20, 0, 4x4, $FF2A
		piece	-$40, -$20, 4x4, $FF2A
		piece	-$40, 0, 4x4, $FF2A
		endsprite
		
byte_F5F0:	spritemap
		piece	$20, -$20, 4x4, $FF2A
		piece	$20, 0, 4x4, $FF2A
		piece	0, -$20, 4x4, $FF2A
		piece	0, 0, 4x4, $FF2A
		piece	-$20, -$20, 4x4, $FF2A
		piece	-$20, 0, 4x4, $FF2A
		piece	-$40, -$20, 4x4, $FF2A
		piece	-$40, 0, 4x4, $FF2A
		endsprite
		even
