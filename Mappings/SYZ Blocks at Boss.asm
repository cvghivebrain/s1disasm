; ---------------------------------------------------------------------------
; Sprite mappings - blocks that	Robotnik picks up (SYZ)
; ---------------------------------------------------------------------------
Map_BossBlock:	index *
		ptr frame_bblock_wholeblock
		ptr frame_bblock_topleft
		ptr frame_bblock_topright
		ptr frame_bblock_bottomleft
		ptr frame_bblock_bottomright
		
frame_bblock_wholeblock:
		spritemap
		piece	-$10, -$10, 4x2, $71
		piece	-$10, 0, 4x2, $79
		endsprite
		dc.b 0
		
frame_bblock_topleft:
		spritemap
		piece	-8, -8, 2x2, $71
		endsprite
		
frame_bblock_topright:
		spritemap
		piece	-8, -8, 2x2, $75
		endsprite
		
frame_bblock_bottomleft:
		spritemap
		piece	-8, -8, 2x2, $79
		endsprite
		
frame_bblock_bottomright:
		spritemap
		piece	-8, -8, 2x2, $7D
		endsprite
		even
