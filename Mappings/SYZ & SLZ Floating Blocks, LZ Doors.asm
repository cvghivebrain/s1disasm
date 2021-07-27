; ---------------------------------------------------------------------------
; Sprite mappings - floating blocks (SYZ/SLZ/LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @syz1x1
		ptr @syz2x2
		ptr @syz1x2
		ptr @syzrect2x2
		ptr @syzrect1x3
		ptr @slz
		ptr @lzvert
		ptr @lzhoriz
		
@syz1x1:	spritemap			; SYZ - 1x1 square block
		piece	-$10, -$10, 4x4, $61
		endsprite
		
@syz2x2:	spritemap			; SYZ - 2x2 square blocks
		piece	-$20, -$20, 4x4, $61
		piece	0, -$20, 4x4, $61
		piece	-$20, 0, 4x4, $61
		piece	0, 0, 4x4, $61
		endsprite
		
@syz1x2:	spritemap			; SYZ - 1x2 square blocks
		piece	-$10, -$20, 4x4, $61
		piece	-$10, 0, 4x4, $61
		endsprite
		
@syzrect2x2:	spritemap			; SYZ - 2x2 rectangular blocks
		piece	-$20, -$1A, 4x4, $81
		piece	0, -$1A, 4x4, $81
		piece	-$20, 0, 4x4, $81
		piece	0, 0, 4x4, $81
		endsprite
		
@syzrect1x3:	spritemap			; SYZ - 1x3 rectangular blocks
		piece	-$10, -$27, 4x4, $81
		piece	-$10, -$D, 4x4, $81
		piece	-$10, $D, 4x4, $81
		endsprite
		
@slz:		spritemap			; SLZ - 1x1 square block
		piece	-$10, -$10, 4x4, $21
		endsprite
		
@lzvert:	spritemap			; LZ - small vertical door
		piece	-8, -$20, 2x4, 0
		piece	-8, 0, 2x4, 0, yflip
		endsprite
		
@lzhoriz:	spritemap ; LZ - large horizontal door
		piece	-$40, -$10, 4x4, $22
		piece	-$20, -$10, 4x4, $22
		piece	0, -$10, 4x4, $22
		piece	$20, -$10, 4x4, $22
		endsprite
		even
