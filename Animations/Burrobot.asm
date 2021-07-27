; ---------------------------------------------------------------------------
; Animation script - Burrobot enemy
; ---------------------------------------------------------------------------
		index *
		ptr @walk1
		ptr @walk2
		ptr @digging
		ptr @fall
		
@walk1:		dc.b 3,	0, 6, afEnd
@walk2:		dc.b 3,	0, 1, afEnd
@digging:	dc.b 3,	2, 3, afEnd
@fall:		dc.b 3,	4, afEnd
		even
