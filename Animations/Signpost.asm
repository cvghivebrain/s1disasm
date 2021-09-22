; ---------------------------------------------------------------------------
; Animation script - signpost
; ---------------------------------------------------------------------------
Ani_Sign:	index *
		ptr ani_sign_eggman
		ptr ani_sign_spin1
		ptr ani_sign_spin2
		ptr ani_sign_sonic
		
ani_sign_eggman:	dc.b $F, id_frame_sign_eggman, afEnd
			even
ani_sign_spin1:		dc.b 1,	id_frame_sign_eggman, id_frame_sign_spin1, id_frame_sign_spin2, id_frame_sign_spin3, afEnd
ani_sign_spin2:		dc.b 1,	id_frame_sign_sonic, id_frame_sign_spin1, id_frame_sign_spin2, id_frame_sign_spin3, afEnd
ani_sign_sonic:		dc.b $F, id_frame_sign_sonic, afEnd
			even
