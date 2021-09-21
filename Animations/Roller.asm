; ---------------------------------------------------------------------------
; Animation script - Roller enemy
; ---------------------------------------------------------------------------
Ani_Roll:	index *
		ptr ani_roll_unfold
		ptr ani_roll_fold
		ptr ani_roll_roll
		
ani_roll_unfold:	dc.b $F, id_frame_roll_roll1, id_frame_roll_fold, id_frame_roll_stand, afBack, 1
ani_roll_fold:		dc.b $F, id_frame_roll_fold, id_frame_roll_roll1, afChange, id_ani_roll_roll
			even
ani_roll_roll:		dc.b 3,	id_frame_roll_roll2, id_frame_roll_roll3, id_frame_roll_roll1, afEnd
			even
