; ---------------------------------------------------------------------------
; Animation script - fire balls
; ---------------------------------------------------------------------------
		index *
		ptr @vertical
		ptr @vertcollide
		ptr @horizontal
		ptr @horicollide
		
@vertical:	dc.b 5,	0, $20,	1, $21,	afEnd
@vertcollide:	dc.b 5,	2, afRoutine
		even
@horizontal:	dc.b 5,	3, $43,	4, $44,	afEnd
@horicollide:	dc.b 5,	5, afRoutine
		even
