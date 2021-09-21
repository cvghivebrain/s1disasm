; ---------------------------------------------------------------------------
; Animation script - prison capsule
; ---------------------------------------------------------------------------
Ani_Pri:	index *
		ptr ani_prison_switchflash
		ptr ani_prison_switchflash
		
ani_prison_switchflash:	dc.b 2,	id_frame_prison_switch1, id_frame_prison_switch2, afEnd
			even
