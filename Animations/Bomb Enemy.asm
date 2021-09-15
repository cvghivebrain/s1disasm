; ---------------------------------------------------------------------------
; Animation script - Bomb enemy
; ---------------------------------------------------------------------------
Ani_Bomb:	index *
		ptr ani_bomb_stand
		ptr ani_bomb_walk
		ptr ani_bomb_active
		ptr ani_bomb_fuse
		ptr ani_bomb_shrapnel
		
ani_bomb_stand:		dc.b $13, id_frame_bomb_stand2, id_frame_bomb_stand1,	afEnd
ani_bomb_walk:		dc.b $13, id_frame_bomb_walk4, id_frame_bomb_walk3, id_frame_bomb_walk2, id_frame_bomb_walk1, afEnd
ani_bomb_active:	dc.b $13, id_frame_bomb_activate2, id_frame_bomb_activate1, afEnd
ani_bomb_fuse:		dc.b 3,	id_frame_bomb_fuse1, id_frame_bomb_fuse2, afEnd
ani_bomb_shrapnel:	dc.b 3,	id_frame_bomb_shrapnel1, id_frame_bomb_shrapnel2, afEnd
		even
