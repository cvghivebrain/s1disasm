; ---------------------------------------------------------------------------
; Animation script - bubbles (LZ)
; ---------------------------------------------------------------------------
Ani_Bub:	index *
		ptr ani_bubble_small
		ptr ani_bubble_medium
		ptr ani_bubble_large
		ptr ani_bubble_incroutine
		ptr ani_bubble_incroutine
		ptr ani_bubble_burst
		ptr ani_bubble_bubmaker
		
ani_bubble_small:	dc.b $E, id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, afRoutine ; small bubble forming
			even
ani_bubble_medium:	dc.b $E, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, afRoutine ; medium bubble forming
ani_bubble_large:	dc.b $E, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_5, id_frame_bubble_full, afRoutine ; full size bubble forming
			even
ani_bubble_incroutine:	dc.b 4,	afRoutine	; increment routine counter (no animation)
ani_bubble_burst:	dc.b 4,	id_frame_bubble_full, id_frame_bubble_burst1, id_frame_bubble_burst2, afRoutine ; large bubble bursts
			even
ani_bubble_bubmaker:	dc.b $F, id_frame_bubble_bubmaker1, id_frame_bubble_bubmaker2, id_frame_bubble_bubmaker3, afEnd ; bubble maker on the floor
			even
