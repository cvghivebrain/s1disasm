; ---------------------------------------------------------------------------
; Animation script - fire balls
; ---------------------------------------------------------------------------
Ani_Fire:	index *
		ptr ani_fire_vertical
		ptr ani_fire_vertcollide
		ptr ani_fire_horizontal
		ptr ani_fire_horicollide
		
ani_fire_vertical:	dc.b 5,	id_frame_fire_vertical1, id_frame_fire_vertical1+afxflip, id_frame_fire_vertical2, id_frame_fire_vertical2+afxflip, afEnd
ani_fire_vertcollide:	dc.b 5,	id_frame_fire_vertcollide, afRoutine
			even
ani_fire_horizontal:	dc.b 5,	id_frame_fire_horizontal1, id_frame_fire_horizontal1+afyflip, id_frame_fire_horizontal2, id_frame_fire_horizontal2+afyflip, afEnd
ani_fire_horicollide:	dc.b 5,	id_frame_fire_horicollide, afRoutine
			even
