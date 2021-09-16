; ---------------------------------------------------------------------------
; Animation script - Eggman on the "TRY AGAIN" and "END" screens
; ---------------------------------------------------------------------------
Ani_EEgg:	index *
		ptr ani_eegg_juggle1
		ptr ani_eegg_juggle2
		ptr ani_eegg_end
		
ani_eegg_juggle1:	dc.b 5,	id_frame_eegg_juggle1, afRoutine, 1
ani_eegg_juggle2:	dc.b 5,	id_frame_eegg_juggle3, afRoutine, 3
ani_eegg_end:		dc.b 7,	id_frame_eegg_end1, id_frame_eegg_end2, id_frame_eegg_end3, id_frame_eegg_end2, id_frame_eegg_end1, id_frame_eegg_end2, id_frame_eegg_end3, id_frame_eegg_end2
			dc.b id_frame_eegg_end1, id_frame_eegg_end2, id_frame_eegg_end3, id_frame_eegg_end2, id_frame_eegg_end4, id_frame_eegg_end2, id_frame_eegg_end3, id_frame_eegg_end2, afEnd
			even
