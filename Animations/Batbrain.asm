; ---------------------------------------------------------------------------
; Animation script - Basaran enemy
; ---------------------------------------------------------------------------
Ani_Bat:	index *
		ptr ani_bat_hang
		ptr ani_bat_drop
		ptr ani_bat_fly
		
ani_bat_hang:	dc.b $F, id_frame_bat_hanging, afEnd
		even
ani_bat_drop:	dc.b $F, id_frame_bat_fly1, afEnd
		even
ani_bat_fly:	dc.b 3,	id_frame_bat_fly1, id_frame_bat_fly2, id_frame_bat_fly3, id_frame_bat_fly2, afEnd
		even
