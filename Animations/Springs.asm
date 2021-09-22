; ---------------------------------------------------------------------------
; Animation script - springs
; ---------------------------------------------------------------------------
Ani_Spring:	index *
		ptr ani_spring_up
		ptr ani_spring_left
		
ani_spring_up:		dc.b 0,	id_frame_spring_upflat, id_frame_spring_up, id_frame_spring_up, id_frame_spring_upext, id_frame_spring_upext, id_frame_spring_upext, id_frame_spring_upext, id_frame_spring_upext, id_frame_spring_upext, id_frame_spring_up, afRoutine
ani_spring_left:	dc.b 0,	id_frame_spring_leftflat, id_frame_spring_left, id_frame_spring_left, id_frame_spring_leftext, id_frame_spring_leftext, id_frame_spring_leftext, id_frame_spring_leftext, id_frame_spring_leftext, id_frame_spring_leftext, id_frame_spring_left, afRoutine
			even
