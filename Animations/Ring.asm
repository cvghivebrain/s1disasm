; ---------------------------------------------------------------------------
; Animation script - ring
; ---------------------------------------------------------------------------
Ani_Ring:	index *
		ptr ani_ring_sparkle
		
ani_ring_sparkle:	dc.b 5,	id_frame_ring_sparkle1, id_frame_ring_sparkle2, id_frame_ring_sparkle3, id_frame_ring_sparkle4, afRoutine
			even
