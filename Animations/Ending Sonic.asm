; ---------------------------------------------------------------------------
; Animation script - Sonic on the ending sequence
; ---------------------------------------------------------------------------
Ani_ESon:	index *
		ptr ani_esonic_hold
		ptr ani_esonic_confused
		ptr ani_esonic_leap
ani_esonic_hold:	dc.b 3,	id_frame_esonic_hold2, id_frame_esonic_hold1, id_frame_esonic_hold2, id_frame_esonic_hold1, id_frame_esonic_hold2, id_frame_esonic_hold1
			dc.b id_frame_esonic_hold2, id_frame_esonic_hold1, id_frame_esonic_hold2, id_frame_esonic_hold1, id_frame_esonic_hold2, id_frame_esonic_up, af2ndRoutine
ani_esonic_confused:	dc.b 5,	id_frame_esonic_confused1, id_frame_esonic_confused2, id_frame_esonic_confused1, id_frame_esonic_confused2, id_frame_esonic_confused1, id_frame_esonic_confused2, id_frame_esonic_confused1, af2ndRoutine
			even
ani_esonic_leap:	dc.b 3,	id_frame_esonic_leap1, id_frame_esonic_leap1, id_frame_esonic_leap1, id_frame_esonic_leap2, id_frame_esonic_leap3, afBack, 1
			even
