; ---------------------------------------------------------------------------
; Animation script - trapdoor (SBZ)
; ---------------------------------------------------------------------------
Ani_Spin:	index *
		ptr ani_spin_trapopen
		ptr ani_spin_trapclose
		ptr ani_spin_1
		ptr ani_spin_2
		
ani_spin_trapopen:	dc.b 3,	id_frame_trap_closed, id_frame_trap_half, id_frame_trap_open, afBack, 1
ani_spin_trapclose:	dc.b 3,	id_frame_trap_open, id_frame_trap_half, id_frame_trap_closed, afBack, 1
ani_spin_1:		dc.b 1,	id_frame_spin_flat, id_frame_spin_1, id_frame_spin_2, id_frame_spin_3, id_frame_spin_4, id_frame_spin_3+afyflip, id_frame_spin_2+afyflip, id_frame_spin_1+afyflip, id_frame_spin_flat+afyflip, id_frame_spin_1+afxflip+afyflip, id_frame_spin_2+afxflip+afyflip, id_frame_spin_3+afxflip+afyflip, id_frame_spin_4+afxflip+afyflip, id_frame_spin_3+afxflip, id_frame_spin_2+afxflip, id_frame_spin_1+afxflip, id_frame_spin_flat, afBack, 1
ani_spin_2:		dc.b 1,	id_frame_spin_flat, id_frame_spin_1, id_frame_spin_2, id_frame_spin_3, id_frame_spin_4, id_frame_spin_3+afyflip, id_frame_spin_2+afyflip, id_frame_spin_1+afyflip, id_frame_spin_flat+afyflip, id_frame_spin_1+afxflip+afyflip, id_frame_spin_2+afxflip+afyflip, id_frame_spin_3+afxflip+afyflip, id_frame_spin_4+afxflip+afyflip, id_frame_spin_3+afxflip, id_frame_spin_2+afxflip, id_frame_spin_1+afxflip, id_frame_spin_flat, afBack, 1
			even
