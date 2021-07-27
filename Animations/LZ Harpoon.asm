; ---------------------------------------------------------------------------
; Animation script - harpoon (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @h_extending
		ptr @h_retracting
		ptr @v_extending
		ptr @v_retracting
		
@h_extending:	dc.b 3,	1, 2, afRoutine
@h_retracting:	dc.b 3,	1, 0, afRoutine
@v_extending:	dc.b 3,	4, 5, afRoutine
@v_retracting:	dc.b 3,	4, 3, afRoutine
		even
