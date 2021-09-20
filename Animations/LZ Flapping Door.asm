; ---------------------------------------------------------------------------
; Animation script - flapping door (LZ)
; ---------------------------------------------------------------------------
Ani_Flap:	index *
		ptr ani_flap_opening
		ptr ani_flap_closing
		
ani_flap_opening:	dc.b 3,	id_frame_flap_closed, id_frame_flap_halfway, id_frame_flap_open, afBack, 1
ani_flap_closing:	dc.b 3,	id_frame_flap_open, id_frame_flap_halfway, id_frame_flap_closed, afBack, 1
			even
