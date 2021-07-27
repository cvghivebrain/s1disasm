; ---------------------------------------------------------------------------
; Animation script - countdown numbers and bubbles (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @zeroappear
		ptr @oneappear
		ptr @twoappear
		ptr @threeappear
		ptr @fourappear
		ptr @fiveappear
		ptr @smallbubble
		ptr @zeroflash
		ptr @oneflash
		ptr @twoflash
		ptr @threeflash
		ptr @fourflash
		ptr @fiveflash
		ptr @blank
		ptr @mediumbubble
		
@zeroappear:	dc.b 5,	0, 1, 2, 3, 4, 9, $D, afRoutine
		even
@oneappear:	dc.b 5,	0, 1, 2, 3, 4, $C, $12,	afRoutine
		even
@twoappear:	dc.b 5,	0, 1, 2, 3, 4, $C, $11,	afRoutine
		even
@threeappear:	dc.b 5,	0, 1, 2, 3, 4, $B, $10,	afRoutine
		even
@fourappear:	dc.b 5,	0, 1, 2, 3, 4, 9, $F, afRoutine
		even
@fiveappear:	dc.b 5,	0, 1, 2, 3, 4, $A, $E, afRoutine
		even
@smallbubble:	dc.b $E, 0, 1, 2, afRoutine
		even
@zeroflash:	dc.b 7,	$16, $D, $16, $D, $16, $D, afRoutine
@oneflash:	dc.b 7,	$16, $12, $16, $12, $16, $12, afRoutine
@twoflash:	dc.b 7,	$16, $11, $16, $11, $16, $11, afRoutine
@threeflash:	dc.b 7,	$16, $10, $16, $10, $16, $10, afRoutine
@fourflash:	dc.b 7,	$16, $F, $16, $F, $16, $F, afRoutine
@fiveflash:	dc.b 7,	$16, $E, $16, $E, $16, $E, afRoutine
@blank:		dc.b $E, afRoutine
@mediumbubble:	dc.b $E, 1, 2, 3, 4, afRoutine
		even
