; ---------------------------------------------------------------------------
; Animation script - advancing wall of lava (MZ)
; ---------------------------------------------------------------------------
Ani_LWall:	index *
		ptr ani_lavawall_0
		
ani_lavawall_0:		dc.b 9,	id_frame_lavawall_0, id_frame_lavawall_1, id_frame_lavawall_2, id_frame_lavawall_3, afEnd
			even
