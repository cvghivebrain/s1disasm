; ---------------------------------------------------------------------------
; Animation script - water splash (LZ)
; ---------------------------------------------------------------------------
Ani_Splash:	index *
		ptr ani_splash_0
		
ani_splash_0:	dc.b 4,	id_frame_splash_0, id_frame_splash_1, id_frame_splash_2, afRoutine
		even
