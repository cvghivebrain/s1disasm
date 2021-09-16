; ---------------------------------------------------------------------------
; Animation script - Crabmeat enemy
; ---------------------------------------------------------------------------
Ani_Crab:	index *
		ptr ani_crab_stand
		ptr ani_crab_standslope
		ptr ani_crab_standsloperev
		ptr ani_crab_walk
		ptr ani_crab_walkslope
		ptr ani_crab_walksloperev
		ptr ani_crab_firing
		ptr ani_crab_ball
		
ani_crab_stand:		dc.b $F, id_frame_crab_stand, afEnd
			even
ani_crab_standslope:	dc.b $F, id_frame_crab_slope1, afEnd
			even
ani_crab_standsloperev:	dc.b $F, id_frame_crab_slope1+afxflip, afEnd
			even
ani_crab_walk:		dc.b $F, id_frame_crab_walk, id_frame_crab_walk+afxflip, id_frame_crab_stand, afEnd
			even
ani_crab_walkslope:	dc.b $F, id_frame_crab_walk+afxflip, id_frame_crab_slope2, id_frame_crab_slope1, afEnd
			even
ani_crab_walksloperev:	dc.b $F, id_frame_crab_walk, id_frame_crab_slope2+afxflip, id_frame_crab_slope1+afxflip, afEnd
			even
ani_crab_firing:	dc.b $F, id_frame_crab_firing, afEnd
			even
ani_crab_ball:		dc.b 1,	id_frame_crab_ball1, id_frame_crab_ball2, afEnd
			even
