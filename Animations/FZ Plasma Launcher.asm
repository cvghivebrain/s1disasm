; ---------------------------------------------------------------------------
; Animation script - energy ball launcher (FZ)
; ---------------------------------------------------------------------------
Ani_PLaunch:	index *
		ptr ani_plaunch_red
		ptr ani_plaunch_redsparking
		ptr ani_plaunch_whitesparking
		
ani_plaunch_red:		dc.b $7E, id_frame_plaunch_red, afEnd
				even
ani_plaunch_redsparking:	dc.b 1,	id_frame_plaunch_red, id_frame_plaunch_sparking1, id_frame_plaunch_red, id_frame_plaunch_sparking2, afEnd
				even
ani_plaunch_whitesparking:	dc.b 1,	id_frame_plaunch_white, id_frame_plaunch_sparking1, id_frame_plaunch_white, id_frame_plaunch_sparking2, afEnd
				even
