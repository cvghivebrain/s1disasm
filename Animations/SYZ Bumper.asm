; ---------------------------------------------------------------------------
; Animation script - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
		index *
		ptr byte_EAF4
		ptr byte_EAF8
		
byte_EAF4:	dc.b $F, 0, afEnd
		even
byte_EAF8:	dc.b 3,	1, 2, 1, 2, afChange, 0
		even
