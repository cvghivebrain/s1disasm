; ---------------------------------------------------------------------------
; Animation script - special stage entry effect from beta
; ---------------------------------------------------------------------------
Ani_Vanish:	index *
		ptr ani_vanish_0
		
ani_vanish_0:	dc.b 5,	id_frame_vanish_flash1, id_frame_vanish_flash2, id_frame_vanish_flash1, id_frame_vanish_flash2, id_frame_vanish_flash1, id_frame_vanish_blank, id_frame_vanish_flash2, id_frame_vanish_blank, id_frame_vanish_flash3, id_frame_vanish_blank, id_frame_vanish_sparkle1, id_frame_vanish_blank, id_frame_vanish_sparkle2, id_frame_vanish_blank, id_frame_vanish_sparkle3, id_frame_vanish_blank, id_frame_vanish_sparkle4, id_frame_vanish_blank, afRoutine
		even
