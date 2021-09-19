; ---------------------------------------------------------------------------
; Animation script - energy balls (FZ)
; ---------------------------------------------------------------------------
Ani_Plasma:	index *
		ptr ani_plasma_full
		ptr ani_plasma_short
		
ani_plasma_full:	dc.b 1,	id_frame_plasma_fuzzy1, id_frame_plasma_blank, id_frame_plasma_fuzzy5, id_frame_plasma_blank
			dc.b id_frame_plasma_fuzzy2, id_frame_plasma_blank, id_frame_plasma_fuzzy6, id_frame_plasma_blank
			dc.b id_frame_plasma_fuzzy3, id_frame_plasma_blank, id_frame_plasma_fuzzy4, id_frame_plasma_blank
			dc.b id_frame_plasma_fuzzy1, id_frame_plasma_blank, id_frame_plasma_fuzzy5, id_frame_plasma_blank
			dc.b id_frame_plasma_fuzzy2, id_frame_plasma_blank, id_frame_plasma_fuzzy6, id_frame_plasma_blank
			dc.b id_frame_plasma_fuzzy3, id_frame_plasma_blank, id_frame_plasma_fuzzy4, id_frame_plasma_blank
			dc.b id_frame_plasma_white1, id_frame_plasma_blank, id_frame_plasma_white2, id_frame_plasma_blank
			dc.b id_frame_plasma_white3, id_frame_plasma_blank, id_frame_plasma_white4, afEnd
			even
ani_plasma_short:	dc.b 0,	id_frame_plasma_fuzzy3, id_frame_plasma_white4, id_frame_plasma_fuzzy2, id_frame_plasma_white4, id_frame_plasma_fuzzy4, id_frame_plasma_white4, id_frame_plasma_fuzzy2, id_frame_plasma_white4,	afEnd
			even
