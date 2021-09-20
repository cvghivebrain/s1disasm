; ---------------------------------------------------------------------------
; Animation script - harpoon (LZ)
; ---------------------------------------------------------------------------
Ani_Harp:	index *
		ptr ani_harp_h_extending
		ptr ani_harp_h_retracting
		ptr ani_harp_v_extending
		ptr ani_harp_v_retracting
		
ani_harp_h_extending:	dc.b 3,	id_frame_harp_h_middle, id_frame_harp_h_extended, afRoutine
ani_harp_h_retracting:	dc.b 3,	id_frame_harp_h_middle, id_frame_harp_h_retracted, afRoutine
ani_harp_v_extending:	dc.b 3,	id_frame_harp_v_middle, id_frame_harp_v_extended, afRoutine
ani_harp_v_retracting:	dc.b 3,	id_frame_harp_v_middle, id_frame_harp_v_retracted, afRoutine
			even
