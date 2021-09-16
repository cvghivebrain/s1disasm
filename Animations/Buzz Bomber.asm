; ---------------------------------------------------------------------------
; Animation script - Buzz Bomber enemy
; ---------------------------------------------------------------------------
Ani_Buzz:	index *
		ptr ani_buzz_fly1
		ptr ani_buzz_fly2
		ptr ani_buzz_fire
		
ani_buzz_fly1:	dc.b 1,	id_frame_buzz_fly1, id_frame_buzz_fly2, afEnd
ani_buzz_fly2:	dc.b 1,	id_frame_buzz_fly3, id_frame_buzz_fly4, afEnd
ani_buzz_fire:	dc.b 1,	id_frame_buzz_fire1, id_frame_buzz_fire2, afEnd
		even
