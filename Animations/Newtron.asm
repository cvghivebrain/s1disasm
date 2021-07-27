; ---------------------------------------------------------------------------
; Animation script - Newtron enemy
; ---------------------------------------------------------------------------
		index *
		ptr A_Newt_Blank
		ptr A_Newt_Drop
		ptr A_Newt_Fly1
		ptr A_Newt_Fly2
		ptr A_Newt_Fires
		
A_Newt_Blank:	dc.b $F, $A, afEnd
		even
A_Newt_Drop:	dc.b $13, 0, 1,	3, 4, 5, afBack, 1
A_Newt_Fly1:	dc.b 2,	6, 7, afEnd
A_Newt_Fly2:	dc.b 2,	8, 9, afEnd
A_Newt_Fires:	dc.b $13, 0, 1,	1, 2, 1, 1, 0, afRoutine
		even
