; ---------------------------------------------------------------------------
; Animation script - doors (SBZ)
; ---------------------------------------------------------------------------
Ani_ADoor:	index *
		ptr ani_autodoor_close
		ptr ani_autodoor_open
		
ani_autodoor_close:	dc.b 0,	id_frame_autodoor_open, id_frame_autodoor_07, id_frame_autodoor_06, id_frame_autodoor_05, id_frame_autodoor_04, id_frame_autodoor_03, id_frame_autodoor_02, id_frame_autodoor_01, id_frame_autodoor_closed, afBack, 1
ani_autodoor_open:	dc.b 0,	id_frame_autodoor_closed, id_frame_autodoor_01, id_frame_autodoor_02, id_frame_autodoor_03, id_frame_autodoor_04, id_frame_autodoor_05, id_frame_autodoor_06, id_frame_autodoor_07, id_frame_autodoor_open, afBack, 1
			even
