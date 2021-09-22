; ---------------------------------------------------------------------------
; Animation script - flamethrower (SBZ)
; ---------------------------------------------------------------------------
Ani_Flame:	index *
		ptr ani_flame_pipe_on
		ptr ani_flame_pipe_off
		ptr ani_flame_valve_on
		ptr ani_flame_valve_off
		
ani_flame_pipe_on:	dc.b 3,	id_frame_flame_pipe1, id_frame_flame_pipe2, id_frame_flame_pipe3, id_frame_flame_pipe4, id_frame_flame_pipe5, id_frame_flame_pipe6, id_frame_flame_pipe7, id_frame_flame_pipe8,	id_frame_flame_pipe9, id_frame_flame_pipe10, id_frame_flame_pipe11, afBack, 2
ani_flame_pipe_off:	dc.b 0,	id_frame_flame_pipe10, id_frame_flame_pipe8, id_frame_flame_pipe6, id_frame_flame_pipe4, id_frame_flame_pipe2, id_frame_flame_pipe1, afBack, 1
			even
ani_flame_valve_on:	dc.b 3,	id_frame_flame_valve1, id_frame_flame_valve2,	id_frame_flame_valve3, id_frame_flame_valve4,	id_frame_flame_valve5, id_frame_flame_valve6, id_frame_flame_valve7, id_frame_flame_valve8, id_frame_flame_valve9, id_frame_flame_valve10, id_frame_flame_valve11, afBack, 2
ani_flame_valve_off:	dc.b 0,	id_frame_flame_valve10, id_frame_flame_valve8, id_frame_flame_valve7, id_frame_flame_valve5, id_frame_flame_valve3, id_frame_flame_valve1, afBack, 1
			even
