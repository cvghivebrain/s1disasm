; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	collapsing ledge
; ---------------------------------------------------------------------------
Map_Ledge:	index *
		ptr frame_ledge_left
		ptr frame_ledge_right
		ptr frame_ledge_leftsmash
		ptr frame_ledge_rightsmash
		
frame_ledge_left:
		spritemap					; ledge facing left
		piece	$10, -$38, 4x3, $57
		piece	-$10, -$30, 4x2, $63
		piece	$10, -$20, 4x2, $6B
		piece	-$10, -$20, 4x2, $73
		piece	-$20, -$28, 2x3, $7B
		piece	-$30, -$28, 2x3, $81
		piece	$10, -$10, 4x2, $87
		piece	-$10, -$10, 4x2, $8F
		piece	-$20, -$10, 2x2, $97
		piece	-$30, -$10, 2x2, $9B
		piece	$10, 0, 4x2, $9F
		piece	0, 0, 2x2, $A7
		piece	-$20, 0, 4x2, $AB
		piece	-$30, 0, 2x2, $B3
		piece	$10, $10, 4x2, $AB
		piece	0, $10, 2x2, $B7
		endsprite
		
frame_ledge_right:
		spritemap					; ledge facing right - actually faces left but is always xflipped in the level
		piece	$10, -$38, 4x3, $57
		piece	-$10, -$30, 4x2, $63
		piece	$10, -$20, 4x2, $6B
		piece	-$10, -$20, 4x2, $73
		piece	-$20, -$28, 2x3, $7B
		piece	-$30, -$28, 2x3, $BB
		piece	$10, -$10, 4x2, $87
		piece	-$10, -$10, 4x2, $8F
		piece	-$20, -$10, 2x2, $97
		piece	-$30, -$10, 2x2, $C1
		piece	$10, 0, 4x2, $9F
		piece	0, 0, 2x2, $A7
		piece	-$20, 0, 4x2, $AB
		piece	-$30, 0, 2x2, $B7
		piece	$10, $10, 4x2, $AB
		piece	0, $10, 2x2, $B7
		endsprite
		
frame_ledge_leftsmash:
		spritemap					; ledge facing left in pieces
		piece	$20, -$38, 2x3, $5D
		piece	$10, -$38, 2x3, $57
		piece	0, -$30, 2x2, $67
		piece	-$10, -$30, 2x2, $63
		piece	$20, -$20, 2x2, $6F
		piece	$10, -$20, 2x2, $6B
		piece	0, -$20, 2x2, $77
		piece	-$10, -$20, 2x2, $73
		piece	-$20, -$28, 2x3, $7B
		piece	-$30, -$28, 2x3, $81
		piece	$20, -$10, 2x2, $8B
		piece	$10, -$10, 2x2, $87
		piece	0, -$10, 2x2, $93
		piece	-$10, -$10, 2x2, $8F
		piece	-$20, -$10, 2x2, $97
		piece	-$30, -$10, 2x2, $9B
		piece	$20, 0, 2x2, $8B
		piece	$10, 0, 2x2, $8B
		piece	0, 0, 2x2, $A7
		piece	-$10, 0, 2x2, $AB
		piece	-$20, 0, 2x2, $AB
		piece	-$30, 0, 2x2, $B3
		piece	$20, $10, 2x2, $AB
		piece	$10, $10, 2x2, $AB
		piece	0, $10, 2x2, $B7
		endsprite
		
frame_ledge_rightsmash:
		spritemap					; ledge facing right in pieces
		piece	$20, -$38, 2x3, $5D
		piece	$10, -$38, 2x3, $57
		piece	0, -$30, 2x2, $67
		piece	-$10, -$30, 2x2, $63
		piece	$20, -$20, 2x2, $6F
		piece	$10, -$20, 2x2, $6B
		piece	0, -$20, 2x2, $77
		piece	-$10, -$20, 2x2, $73
		piece	-$20, -$28, 2x3, $7B
		piece	-$30, -$28, 2x3, $BB
		piece	$20, -$10, 2x2, $8B
		piece	$10, -$10, 2x2, $87
		piece	0, -$10, 2x2, $93
		piece	-$10, -$10, 2x2, $8F
		piece	-$20, -$10, 2x2, $97
		piece	-$30, -$10, 2x2, $C1
		piece	$20, 0, 2x2, $8B
		piece	$10, 0, 2x2, $8B
		piece	0, 0, 2x2, $A7
		piece	-$10, 0, 2x2, $AB
		piece	-$20, 0, 2x2, $AB
		piece	-$30, 0, 2x2, $B7
		piece	$20, $10, 2x2, $AB
		piece	$10, $10, 2x2, $AB
		piece	0, $10, 2x2, $B7
		endsprite
		even
