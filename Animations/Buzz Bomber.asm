; ---------------------------------------------------------------------------
; Animation script - Buzz Bomber enemy
; ---------------------------------------------------------------------------
		index *
		ptr @fly1
		ptr @fly2
		ptr @fires
		
@fly1:		dc.b 1,	0, 1, afEnd
@fly2:		dc.b 1,	2, 3, afEnd
@fires:		dc.b 1,	4, 5, afEnd
		even
