; ---------------------------------------------------------------------------
; Animation script - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------
Ani_Elec:	index *
		ptr ani_electro_normal
		ptr ani_electro_zap
		
ani_electro_normal:	dc.b 7,	id_frame_electro_normal, afEnd
			even
ani_electro_zap:	dc.b 0,	id_frame_electro_zap1, id_frame_electro_zap1, id_frame_electro_zap1, id_frame_electro_zap2, id_frame_electro_zap3, id_frame_electro_zap3, id_frame_electro_zap4, id_frame_electro_zap4,	id_frame_electro_zap4, id_frame_electro_zap5, id_frame_electro_zap5, id_frame_electro_zap5, id_frame_electro_normal, afChange, id_ani_electro_normal
			even
