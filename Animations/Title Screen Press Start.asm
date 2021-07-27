; ---------------------------------------------------------------------------
; Animation script - "PRESS START BUTTON" on the title screen
; ---------------------------------------------------------------------------
		index *
		ptr @flash
		
@flash:		dc.b $1F, 0, 1,	afEnd
		even
