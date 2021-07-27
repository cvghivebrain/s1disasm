; ---------------------------------------------------------------------------
; Animation script - Roller enemy
; ---------------------------------------------------------------------------
		index *
		ptr A_Roll_Unfold
		ptr A_Roll_Fold
		ptr A_Roll_Roll
		
A_Roll_Unfold:	dc.b $F, 2, 1, 0, afBack, 1
A_Roll_Fold:	dc.b $F, 1, 2, afChange, 2
		even
A_Roll_Roll:	dc.b 3,	3, 4, 2, afEnd
		even
