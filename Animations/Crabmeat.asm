; ---------------------------------------------------------------------------
; Animation script - Crabmeat enemy
; ---------------------------------------------------------------------------
		index *
		ptr @stand
		ptr @standslope
		ptr @standsloperev
		ptr @walk
		ptr @walkslope
		ptr @walksloperev
		ptr @firing
		ptr @ball
		
@stand:		dc.b $F, 0, afEnd
		even
@standslope:	dc.b $F, 2, afEnd
		even
@standsloperev:	dc.b $F, 2+afxflip, afEnd
		even
@walk:		dc.b $F, 1, 1+afxflip, 0, afEnd
		even
@walkslope:	dc.b $F, 1+afxflip, 3, 2, afEnd
		even
@walksloperev:	dc.b $F, 1, 3+afxflip, 2+afxflip, afEnd
		even
@firing:	dc.b $F, 4, afEnd
		even
@ball:		dc.b 1,	5, 6, afEnd
		even
