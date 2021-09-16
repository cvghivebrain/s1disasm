; ---------------------------------------------------------------------------
; Animation script - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
Ani_Missile:	index *
		ptr ani_buzz_flare
		ptr ani_buzz_missile
		
ani_buzz_flare:		dc.b 7,	id_frame_buzz_flare1, id_frame_buzz_flare2, afRoutine
ani_buzz_missile:	dc.b 1,	id_frame_buzz_ball1, id_frame_buzz_ball2, afEnd
			even
