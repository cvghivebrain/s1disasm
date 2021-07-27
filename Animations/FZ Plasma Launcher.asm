; ---------------------------------------------------------------------------
; Animation script - energy ball launcher (FZ)
; ---------------------------------------------------------------------------
		index *
		ptr @red
		ptr @redsparking
		ptr @whitesparking
		
@red:		dc.b $7E, 0, afEnd
		even
@redsparking:	dc.b 1,	0, 2, 0, 3, afEnd
		even
@whitesparking:	dc.b 1,	1, 2, 1, 3, afEnd
		even
