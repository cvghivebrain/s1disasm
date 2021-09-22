; ---------------------------------------------------------------------------
; Animation script - shield and invincibility stars
; ---------------------------------------------------------------------------
Ani_Shield:	index *
		ptr ani_shield_0
		ptr ani_stars1
		ptr ani_stars2
		ptr ani_stars3
		ptr ani_stars4
		
ani_shield_0:	dc.b 1,	id_frame_shield_1, id_frame_shield_blank, id_frame_shield_2, id_frame_shield_blank, id_frame_shield_3, id_frame_shield_blank, afEnd
ani_stars1:	dc.b 5,	id_frame_stars1, id_frame_stars2, id_frame_stars3, id_frame_stars4, afEnd
ani_stars2:	dc.b 0,	id_frame_stars1, id_frame_stars1, id_frame_shield_blank, id_frame_stars1, id_frame_stars1, id_frame_shield_blank, id_frame_stars2
		dc.b id_frame_stars2, id_frame_shield_blank, id_frame_stars2, id_frame_stars2, id_frame_shield_blank, id_frame_stars3, id_frame_stars3, id_frame_shield_blank, id_frame_stars3
		dc.b id_frame_stars3, id_frame_shield_blank, id_frame_stars4, id_frame_stars4, id_frame_shield_blank, id_frame_stars4, id_frame_stars4, id_frame_shield_blank, afEnd
ani_stars3:	dc.b 0,	id_frame_stars1, id_frame_stars1, id_frame_shield_blank, id_frame_stars1, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars2
		dc.b id_frame_stars2, id_frame_shield_blank, id_frame_stars2, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars3, id_frame_stars3, id_frame_shield_blank, id_frame_stars3
		dc.b id_frame_shield_blank, id_frame_shield_blank, id_frame_stars4, id_frame_stars4, id_frame_shield_blank, id_frame_stars4, id_frame_shield_blank, id_frame_shield_blank, afEnd
ani_stars4:	dc.b 0,	id_frame_stars1, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars1, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars2
		dc.b id_frame_shield_blank, id_frame_shield_blank, id_frame_stars2, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars3, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars3
		dc.b id_frame_shield_blank, id_frame_shield_blank, id_frame_stars4, id_frame_shield_blank, id_frame_shield_blank, id_frame_stars4, id_frame_shield_blank, id_frame_shield_blank, afEnd
		even
