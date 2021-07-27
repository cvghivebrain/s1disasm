; ---------------------------------------------------------------------------
; Animation script - Eggman (bosses)
; ---------------------------------------------------------------------------
		index *
		ptr @ship
		ptr @facenormal1
		ptr @facenormal2
		ptr @facenormal3
		ptr @facelaugh
		ptr @facehit
		ptr @facepanic
		ptr @blank
		ptr @flame1
		ptr @flame2
		ptr @facedefeat
		ptr @escapeflame
		
@ship:		dc.b $F, 0, afEnd
		even
@facenormal1:	dc.b 5,	1, 2, afEnd
		even
@facenormal2:	dc.b 3,	1, 2, afEnd
		even
@facenormal3:	dc.b 1,	1, 2, afEnd
		even
@facelaugh:	dc.b 4,	3, 4, afEnd
		even
@facehit:	dc.b $1F, 5, 1,	afEnd
		even
@facepanic:	dc.b 3,	6, 1, afEnd
		even
@blank:		dc.b $F, $A, afEnd
		even
@flame1:	dc.b 3,	8, 9, afEnd
		even
@flame2:	dc.b 1,	8, 9, afEnd
		even
@facedefeat:	dc.b $F, 7, afEnd
		even
@escapeflame:	dc.b 2,	9, 8, $B, $C, $B, $C, 9, 8, afBack, 2
		even
