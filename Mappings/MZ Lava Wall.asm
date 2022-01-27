; ---------------------------------------------------------------------------
; Sprite mappings - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------
Map_LWall:	index *
		ptr frame_lavawall_0
		ptr frame_lavawall_1
		ptr frame_lavawall_2
		ptr frame_lavawall_3
		ptr frame_lavawall_back
		
frame_lavawall_0:
		spritemap
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
		
frame_lavawall_1:
		spritemap
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
		
frame_lavawall_2:
		spritemap
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
		
frame_lavawall_3:
		spritemap
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
		
frame_lavawall_back:
		spritemap
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
