; ---------------------------------------------------------------------------
; Animation script - Sonic on the ending sequence
; ---------------------------------------------------------------------------
		index *
		ptr Holding
		ptr Confused
		ptr Leaping
Holding:	dc.b 3,	1, 0, 1, 0, 1, 0, 1, 0,	1, 0, 1, 2, af2ndRoutine
Confused:	dc.b 5,	3, 4, 3, 4, 3, 4, 3, af2ndRoutine
		even
Leaping:	dc.b 3,	5, 5, 5, 6, 7, afBack, 1
		even
