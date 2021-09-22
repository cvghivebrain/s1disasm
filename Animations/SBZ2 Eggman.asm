; ---------------------------------------------------------------------------
; Animation script - Eggman (SBZ2)
; ---------------------------------------------------------------------------
Ani_SEgg:	index *
		ptr ani_eggman_stand
		ptr ani_eggman_laugh
		ptr ani_eggman_jump1
		ptr ani_eggman_intube
		ptr ani_eggman_running
		ptr ani_eggman_jump2
		ptr ani_eggman_starjump
		
ani_eggman_stand:	dc.b $7E, id_frame_eggman_stand, afEnd
			even
ani_eggman_laugh:	dc.b 6,	id_frame_eggman_laugh1, id_frame_eggman_laugh2, afEnd
ani_eggman_jump1:	dc.b $E, id_frame_eggman_jump1, id_frame_eggman_jump2, id_frame_eggman_jump2, id_frame_eggman_stand, id_frame_eggman_stand, id_frame_eggman_stand, afEnd
ani_eggman_intube:	dc.b 0,	id_frame_eggman_surprise, id_frame_eggman_intube, afEnd
ani_eggman_running:	dc.b 6,	id_frame_eggman_running1, id_frame_eggman_jump2, id_frame_eggman_running2, id_frame_eggman_jump2, afEnd
ani_eggman_jump2:	dc.b $F, id_frame_eggman_jump2, id_frame_eggman_jump1, id_frame_eggman_jump1, afEnd
			even
ani_eggman_starjump:	dc.b $7E, id_frame_eggman_starjump, afEnd
			even
