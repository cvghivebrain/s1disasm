; ---------------------------------------------------------------------------
; Animation script - pinball bumper (SYZ)
; ---------------------------------------------------------------------------
Ani_Bump:	index *
		ptr ani_bump_normal
		ptr ani_bump_bumped
		
ani_bump_normal:	dc.b $F, id_frame_bump_normal, afEnd
			even
ani_bump_bumped:	dc.b 3,	id_frame_bump_bumped1, id_frame_bump_bumped2, id_frame_bump_bumped1, id_frame_bump_bumped2, afChange, id_ani_bump_normal
			even
