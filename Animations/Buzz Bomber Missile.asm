; ---------------------------------------------------------------------------
; Animation script - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
		index *
		ptr @flare
		ptr @missile
		
@flare:		dc.b 7,	0, 1, afRoutine
@missile:	dc.b 1,	2, 3, afEnd
		even
