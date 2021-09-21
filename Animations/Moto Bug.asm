; ---------------------------------------------------------------------------
; Animation script - Motobug enemy
; ---------------------------------------------------------------------------
Ani_Moto:	index *
		ptr ani_moto_stand
		ptr ani_moto_walk
		ptr ani_moto_smoke

ani_moto_stand:		dc.b $F, id_frame_moto_2, afEnd
			even
ani_moto_walk:		dc.b 7,	id_frame_moto_0, id_frame_moto_1, id_frame_moto_0, id_frame_moto_2, afEnd
			even
ani_moto_smoke:		dc.b 1,	id_frame_moto_smoke1, id_frame_moto_blank, id_frame_moto_smoke1, id_frame_moto_blank, id_frame_moto_smoke2, id_frame_moto_blank, id_frame_moto_smoke2, id_frame_moto_blank, id_frame_moto_smoke2, id_frame_moto_blank, id_frame_moto_smoke3, afRoutine
			even
