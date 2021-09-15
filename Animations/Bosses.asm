; ---------------------------------------------------------------------------
; Animation script - Eggman (bosses)
; ---------------------------------------------------------------------------
Ani_Eggman:	index *
		ptr ani_boss_ship	; 0
		ptr ani_boss_face1	; 1
		ptr ani_boss_face2	; 2
		ptr ani_boss_face3	; 3
		ptr ani_boss_laugh	; 4
		ptr ani_boss_hit	; 5
		ptr ani_boss_panic	; 6
		ptr ani_boss_blank	; 7
		ptr ani_boss_flame1	; 8
		ptr ani_boss_flame2	; 9
		ptr ani_boss_defeat	; $A
		ptr ani_boss_bigflame	; $B
		
ani_boss_ship:		dc.b $F, id_frame_boss_ship, afEnd
			even
ani_boss_face1:		dc.b 5,	id_frame_boss_face1, id_frame_boss_face2, afEnd
			even
ani_boss_face2:		dc.b 3,	id_frame_boss_face1, id_frame_boss_face2, afEnd
			even
ani_boss_face3:		dc.b 1,	id_frame_boss_face1, id_frame_boss_face2, afEnd
			even
ani_boss_laugh:		dc.b 4,	id_frame_boss_laugh1, id_frame_boss_laugh2, afEnd
			even
ani_boss_hit:		dc.b $1F, id_frame_boss_hit, id_frame_boss_face1, afEnd
			even
ani_boss_panic:		dc.b 3,	id_frame_boss_panic, id_frame_boss_face1, afEnd
			even
ani_boss_blank:		dc.b $F, id_frame_boss_blank, afEnd
			even
ani_boss_flame1:	dc.b 3,	id_frame_boss_flame1, id_frame_boss_flame2, afEnd
			even
ani_boss_flame2:	dc.b 1,	id_frame_boss_flame1, id_frame_boss_flame2, afEnd
			even
ani_boss_defeat:	dc.b $F, id_frame_boss_defeat, afEnd
			even
ani_boss_bigflame:	dc.b 2,	id_frame_boss_flame2, id_frame_boss_flame1, id_frame_boss_bigflame1, id_frame_boss_bigflame2, id_frame_boss_bigflame1, id_frame_boss_bigflame2, id_frame_boss_flame2, id_frame_boss_flame1, afBack, 2
			even
