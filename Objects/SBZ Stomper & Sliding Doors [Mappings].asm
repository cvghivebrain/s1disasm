; ---------------------------------------------------------------------------
; Sprite mappings - stomper and	sliding doors (SBZ)
; ---------------------------------------------------------------------------
Map_Stomp:	index offset(*)
		ptr frame_stomp_door
		ptr frame_stomp_stomper
		ptr frame_stomp_stomper
		ptr frame_stomp_stomper
		ptr frame_stomp_bigdoor
		
frame_stomp_door:
		spritemap					; horizontal sliding door
		piece	-$40, -$C, 4x3, $1AF, pal2
		piece	-$20, -$C, 4x3, $1B2, pal2
		piece	0, -$C, 4x3, $1B2, pal2
		piece	$20, -$C, 4x3, $1AF, pal2, xflip
		endsprite
		
frame_stomp_stomper:
		spritemap					; stomper block with yellow/black stripes
		piece	-$1C, -$20, 4x1, $C
		piece	4, -$20, 3x1, $10
		piece	-$1C, -$18, 4x3, $13, pal2
		piece	4, -$18, 3x3, $1F, pal2
		piece	-$1C, 0, 4x3, $13, pal2
		piece	4, 0, 3x3, $1F, pal2
		piece	-$1C, $18, 4x1, $C
		piece	4, $18, 3x1, $10
		endsprite
		
frame_stomp_bigdoor:
		spritemap					; huge diagonal sliding door from SBZ3
		piece	-$80, -$40, 4x4, 0
		piece	-$60, -$40, 4x4, $10
		piece	-$40, -$40, 4x4, $20
		piece	-$20, -$40, 4x4, $10
		piece	0, -$40, 4x4, $20
		piece	$20, -$40, 4x4, $10
		piece	$40, -$40, 4x4, $30
		piece	$60, -$40, 4x2, $40
		piece	-$80, -$20, 4x4, $48
		piece	-$40, -$20, 4x4, $48
		piece	0, -$20, 4x4, $58
		piece	-$80, 0, 4x4, $48
		piece	-$40, 0, 4x4, $58
		piece	-$80, $20, 4x4, $58
		endsprite
		even
