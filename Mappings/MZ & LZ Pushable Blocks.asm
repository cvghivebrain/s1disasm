; ---------------------------------------------------------------------------
; Sprite mappings - pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
Map_Push:	index *
		ptr frame_pblock_single
		ptr frame_pblock_four
		
frame_pblock_single:
		spritemap		; single block
		piece	-$10, -$10, 4x4, 8
		endsprite
		
frame_pblock_four:
		spritemap		; row of 4 blocks
		piece	-$40, -$10, 4x4, 8
		piece	-$20, -$10, 4x4, 8
		piece	0, -$10, 4x4, 8
		piece	$20, -$10, 4x4, 8
		endsprite
		even
