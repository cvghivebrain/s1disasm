; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy
; ---------------------------------------------------------------------------
Ani_Yad:	index *
		ptr ani_yadrin_stand
		ptr ani_yadrin_walk

ani_yadrin_stand:	dc.b 7,	id_frame_yadrin_walk0, afEnd
			even
ani_yadrin_walk:	dc.b 7,	id_frame_yadrin_walk0, id_frame_yadrin_walk3, id_frame_yadrin_walk1, id_frame_yadrin_walk4, id_frame_yadrin_walk0, id_frame_yadrin_walk3, id_frame_yadrin_walk2, id_frame_yadrin_walk5, afEnd
			even
