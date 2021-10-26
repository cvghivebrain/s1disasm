; ---------------------------------------------------------------------------
; Animation script - platform on conveyor belt (SBZ)
; ---------------------------------------------------------------------------
Ani_SpinConvey:	index *
		ptr @spin
		ptr @still
		
@spin:		dc.b 0,	id_frame_spin_flat, id_frame_spin_1, id_frame_spin_2, id_frame_spin_3, id_frame_spin_4, id_frame_spin_3+afyflip, id_frame_spin_2+afyflip
		dc.b id_frame_spin_1+afyflip, id_frame_spin_flat+afyflip, id_frame_spin_1+afxflip+afyflip, id_frame_spin_2+afxflip+afyflip, id_frame_spin_3+afxflip+afyflip
		dc.b id_frame_spin_4+afxflip+afyflip, id_frame_spin_3+afxflip, id_frame_spin_2+afxflip, id_frame_spin_1+afxflip, id_frame_spin_flat, afEnd
		even
@still:		dc.b $F, id_frame_spin_flat, afEnd
		even
