; ---------------------------------------------------------------------------
; Animation script - Orbinaut enemy
; ---------------------------------------------------------------------------
Ani_Orb:	index *
		ptr ani_orb_normal
		ptr ani_orb_angry
		
ani_orb_normal:	dc.b $F, id_frame_orb_normal, afEnd
		even
ani_orb_angry:	dc.b $F, id_frame_orb_medium, id_frame_orb_angry, afBack, 1
		even
