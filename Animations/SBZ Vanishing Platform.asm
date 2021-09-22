; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------
Ani_Van:	index *
		ptr ani_vanish_vanish
		ptr ani_vanish_appear
		
ani_vanish_vanish:	dc.b 7,	id_frame_vanish_whole, id_frame_vanish_half, id_frame_vanish_quarter, id_frame_vanish_gone, afBack, 1
			even
ani_vanish_appear:	dc.b 7,	id_frame_vanish_gone, id_frame_vanish_quarter, id_frame_vanish_half, id_frame_vanish_whole, afBack, 1
			even
