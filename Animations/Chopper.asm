; ---------------------------------------------------------------------------
; Animation script - Chopper enemy
; ---------------------------------------------------------------------------
Ani_Chop:	index *
		ptr ani_chopper_slow
		ptr ani_chopper_fast
		ptr ani_chopper_still
		
ani_chopper_slow:	dc.b 7,	id_frame_chopper_shut, id_frame_chopper_open, afEnd
ani_chopper_fast:	dc.b 3,	id_frame_chopper_shut, id_frame_chopper_open, afEnd
ani_chopper_still:	dc.b 7,	id_frame_chopper_shut, afEnd
			even
