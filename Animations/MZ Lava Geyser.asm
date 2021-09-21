; ---------------------------------------------------------------------------
; Animation script - geyser of lava (MZ)
; ---------------------------------------------------------------------------
Ani_Geyser:	index *
		ptr ani_geyser_bubble1
		ptr ani_geyser_bubble2
		ptr ani_geyser_end
		ptr ani_geyser_bubble3
		ptr ani_geyser_blank
		ptr ani_geyser_bubble4
		
ani_geyser_bubble1:	dc.b 2,	id_frame_geyser_bubble1, id_frame_geyser_bubble2, id_frame_geyser_bubble1, id_frame_geyser_bubble2, id_frame_geyser_bubble5, id_frame_geyser_bubble6, id_frame_geyser_bubble5, id_frame_geyser_bubble6,	afRoutine
ani_geyser_bubble2:	dc.b 2,	id_frame_geyser_bubble3, id_frame_geyser_bubble4, afEnd
ani_geyser_end:		dc.b 2,	id_frame_geyser_end1, id_frame_geyser_end2, afEnd
ani_geyser_bubble3:	dc.b 2,	id_frame_geyser_bubble3, id_frame_geyser_bubble4, id_frame_geyser_bubble1, id_frame_geyser_bubble2, id_frame_geyser_bubble1, id_frame_geyser_bubble2, afRoutine
ani_geyser_blank:	dc.b $F, id_frame_geyser_blank, afEnd
			even
ani_geyser_bubble4:	dc.b 2,	id_frame_geyser_bubble7, id_frame_geyser_bubble8, afEnd
			even
