; ---------------------------------------------------------------------------
; Animation script - Chopper enemy
; ---------------------------------------------------------------------------
		index *
		ptr @slow
		ptr @fast
		ptr @still
		
@slow:		dc.b 7,	0, 1, afEnd
@fast:		dc.b 3,	0, 1, afEnd
@still:		dc.b 7,	0, afEnd
		even
