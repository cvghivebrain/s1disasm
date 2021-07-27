; ---------------------------------------------------------------------------
; Animation script - Motobug enemy
; ---------------------------------------------------------------------------
		index *
		ptr @stand
		ptr @walk
		ptr @smoke

@stand:		dc.b $F, 2, afEnd
		even
@walk:		dc.b 7,	0, 1, 0, 2, afEnd
@smoke:		dc.b 1,	3, 6, 3, 6, 4, 6, 4, 6,	4, 6, 5, afRoutine
		even
