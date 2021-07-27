; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @vanish
		ptr @appear
		
@vanish:	dc.b 7,	0, 1, 2, 3, afBack, 1
		even
@appear:	dc.b 7,	3, 2, 1, 0, afBack, 1
		even
