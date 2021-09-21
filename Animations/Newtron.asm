; ---------------------------------------------------------------------------
; Animation script - Newtron enemy
; ---------------------------------------------------------------------------
Ani_Newt:	index *
		ptr ani_newt_blank
		ptr ani_newt_drop
		ptr ani_newt_fly1
		ptr ani_newt_fly2
		ptr ani_newt_firing
		
ani_newt_blank:		dc.b $F, id_frame_newt_blank, afEnd
			even
ani_newt_drop:		dc.b $13, id_frame_newt_trans, id_frame_newt_norm, id_frame_newt_drop1, id_frame_newt_drop2, id_frame_newt_drop3, afBack, 1
ani_newt_fly1:		dc.b 2,	id_frame_newt_fly1a, id_frame_newt_fly1b, afEnd
ani_newt_fly2:		dc.b 2,	id_frame_newt_fly2a, id_frame_newt_fly2b, afEnd
ani_newt_firing:	dc.b $13, id_frame_newt_trans, id_frame_newt_norm, id_frame_newt_norm, id_frame_newt_firing, id_frame_newt_norm, id_frame_newt_norm, id_frame_newt_trans, afRoutine
			even
