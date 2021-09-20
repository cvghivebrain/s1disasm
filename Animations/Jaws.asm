; ---------------------------------------------------------------------------
; Animation script - Jaws enemy
; ---------------------------------------------------------------------------
Ani_Jaws:	index *
		ptr ani_jaws_swim
		
ani_jaws_swim:	dc.b 7,	id_frame_jaws_open1, id_frame_jaws_shut1, id_frame_jaws_open2, id_frame_jaws_shut2, afEnd
		even
