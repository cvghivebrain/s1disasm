; ---------------------------------------------------------------------------
; Animation script - "PRESS START BUTTON" on the title screen
; ---------------------------------------------------------------------------
Ani_PSB:	index *
		ptr ani_psb_flash
		
ani_psb_flash:	dc.b $1F, id_frame_psb_blank, id_frame_psb_psb, afEnd
		even
