; ---------------------------------------------------------------------------
; Animation script - Burrobot enemy
; ---------------------------------------------------------------------------
Ani_Burro:	index *
		ptr ani_burro_walk1
		ptr ani_burro_walk2
		ptr ani_burro_digging
		ptr ani_burro_fall
		
ani_burro_walk1:	dc.b 3,	id_frame_burro_walk1, id_frame_burro_walk3, afEnd
ani_burro_walk2:	dc.b 3,	id_frame_burro_walk1, id_frame_burro_walk2, afEnd
ani_burro_digging:	dc.b 3,	id_frame_burro_dig1, id_frame_burro_dig2, afEnd
ani_burro_fall:		dc.b 3,	id_frame_burro_fall, afEnd
			even
