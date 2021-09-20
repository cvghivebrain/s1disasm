; ---------------------------------------------------------------------------
; Animation script - waterfall (LZ)
; ---------------------------------------------------------------------------
Ani_WFall:	index *
		ptr ani_wfall_splash
		
ani_wfall_splash:	dc.b 5,	id_frame_wfall_splash1, id_frame_wfall_splash2, id_frame_wfall_splash3, afEnd
			even
