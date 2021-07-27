; ---------------------------------------------------------------------------
; Animation script - signpost
; ---------------------------------------------------------------------------
		index *
		ptr @eggman
		ptr @spin1
		ptr @spin2
		ptr @sonic
		
@eggman:	dc.b $F, 0, afEnd
		even
@spin1:		dc.b 1,	0, 1, 2, 3, afEnd
@spin2:		dc.b 1,	4, 1, 2, 3, afEnd
@sonic:		dc.b $F, 4, afEnd
		even
