; ---------------------------------------------------------------------------
; Animation script - Eggman on the "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
		index *
		ptr @tryagain1
		ptr @tryagain2
		ptr @end
		
@tryagain1:	dc.b 5,	0, afRoutine, 1
@tryagain2:	dc.b 5,	2, afRoutine, 3
@end:		dc.b 7,	4, 5, 6, 5, 4, 5, 6, 5,	4, 5, 6, 5, 7, 5, 6, 5,	afEnd
		even
