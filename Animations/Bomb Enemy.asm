; ---------------------------------------------------------------------------
; Animation script - Bomb enemy
; ---------------------------------------------------------------------------
		index *
		ptr @stand
		ptr @walk
		ptr @activated
		ptr @fuse
		ptr @shrapnel
		
@stand:		dc.b $13, 1, 0,	afEnd
@walk:		dc.b $13, 5, 4,	3, 2, afEnd
@activated:	dc.b $13, 7, 6,	afEnd
@fuse:		dc.b 3,	8, 9, afEnd
@shrapnel:	dc.b 3,	$A, $B,	afEnd
		even
