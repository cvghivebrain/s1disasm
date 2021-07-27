; ---------------------------------------------------------------------------
; Animation script - Eggman (SBZ2)
; ---------------------------------------------------------------------------
		index *
		ptr @stand
		ptr @laugh
		ptr @jump1
		ptr @intube
		ptr @running
		ptr @jump2
		ptr @starjump
		
@stand:		dc.b $7E, 0, afEnd
		even
@laugh:		dc.b 6,	1, 2, afEnd
@jump1:		dc.b $E, 3, 4, 4, 0, 0,	0, afEnd
@intube:	dc.b 0,	5, 9, afEnd
@running:	dc.b 6,	7, 4, 8, 4, afEnd
@jump2:		dc.b $F, 4, 3, 3, afEnd
		even
@starjump:	dc.b $7E, 6, afEnd
		even
