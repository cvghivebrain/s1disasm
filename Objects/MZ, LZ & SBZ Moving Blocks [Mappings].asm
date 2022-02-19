; ---------------------------------------------------------------------------
; Sprite mappings - moving platform blocks (MZ, LZ, SBZ)
; ---------------------------------------------------------------------------

Map_MBlock:	index *
		ptr frame_mblock_mz1
		ptr frame_mblock_mz2
		ptr frame_mblock_sbz
		ptr frame_mblock_sbzwide
		ptr frame_mblock_mz3
		
frame_mblock_mz1:
		spritemap
		piece	-$10, -8, 4x4, 8
		endsprite
		
frame_mblock_mz2:
		spritemap
		piece	-$20, -8, 4x4, 8
		piece	0, -8, 4x4, 8
		endsprite
		
frame_mblock_sbz:
		spritemap
		piece	-$20, -8, 4x1, 0, pal2
		piece	-$20, 0, 4x2, 4
		piece	0, -8, 4x1, 0, pal2
		piece	0, 0, 4x2, 4
		endsprite
		
frame_mblock_sbzwide:
		spritemap
		piece	-$40, -8, 4x3, 0
		piece	-$20, -8, 4x3, 3
		piece	0, -8, 4x3, 3
		piece	$20, -8, 4x3, 0, xflip
		endsprite
		
frame_mblock_mz3:
		spritemap
		piece	-$30, -8, 4x4, 8
		piece	-$10, -8, 4x4, 8
		piece	$10, -8, 4x4, 8
		endsprite
		even

Map_MBlockLZ:	index *
		ptr frame_mblocklz_0
		
frame_mblocklz_0:
		spritemap
		piece	-$10, -8, 4x2, 0
		endsprite
		even
