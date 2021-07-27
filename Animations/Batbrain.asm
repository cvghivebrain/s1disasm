; ---------------------------------------------------------------------------
; Animation script - Basaran enemy
; ---------------------------------------------------------------------------
		index *
		ptr @still
		ptr @fall
		ptr @fly
		
@still:		dc.b $F, 0, afEnd
		even
@fall:		dc.b $F, 1, afEnd
		even
@fly:		dc.b 3,	1, 2, 3, 2, afEnd
		even
