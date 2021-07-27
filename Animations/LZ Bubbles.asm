; ---------------------------------------------------------------------------
; Animation script - bubbles (LZ)
; ---------------------------------------------------------------------------
		index *
		ptr @small
		ptr @medium
		ptr @large
		ptr @incroutine
		ptr @incroutine
		ptr @burst
		ptr @bubmaker
		
@small:		dc.b $E, 0, 1, 2, afRoutine ; small bubble forming
		even
@medium:	dc.b $E, 1, 2, 3, 4, afRoutine ; medium bubble forming
@large:		dc.b $E, 2, 3, 4, 5, 6,	afRoutine ; full size bubble forming
		even
@incroutine:	dc.b 4,	afRoutine	; increment routine counter (no animation)
@burst:		dc.b 4,	6, 7, 8, afRoutine ; large bubble bursts
		even
@bubmaker:	dc.b $F, $13, $14, $15,	afEnd ; bubble maker on the floor
		even
