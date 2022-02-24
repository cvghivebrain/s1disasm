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
		
ani_boss_ship:
		dc.b $F
		dc.b id_frame_boss_ship
		dc.b afEnd
		even

ani_boss_face1:
		dc.b 5
		dc.b id_frame_boss_face1
		dc.b id_frame_boss_face2
		dc.b afEnd
		even

ani_boss_face2:
		dc.b 3
		dc.b id_frame_boss_face1
		dc.b id_frame_boss_face2
		dc.b afEnd
		even

ani_boss_face3:
		dc.b 1
		dc.b id_frame_boss_face1
		dc.b id_frame_boss_face2
		dc.b afEnd
		even

ani_boss_laugh:
		dc.b 4
		dc.b id_frame_boss_laugh1
		dc.b id_frame_boss_laugh2
		dc.b afEnd
		even

ani_boss_hit:
		dc.b $1F
		dc.b id_frame_boss_hit
		dc.b id_frame_boss_face1
		dc.b afEnd
		even

ani_boss_panic:
		dc.b 3
		dc.b id_frame_boss_panic
		dc.b id_frame_boss_face1
		dc.b afEnd
		even

ani_boss_blank:
		dc.b $F
		dc.b id_frame_boss_blank
		dc.b afEnd
		even

ani_boss_flame1:
		dc.b 3
		dc.b id_frame_boss_flame1
		dc.b id_frame_boss_flame2
		dc.b afEnd
		even

ani_boss_flame2:
		dc.b 1
		dc.b id_frame_boss_flame1
		dc.b id_frame_boss_flame2
		dc.b afEnd
		even

ani_boss_defeat:
		dc.b $F
		dc.b id_frame_boss_defeat
		dc.b afEnd
		even

ani_boss_bigflame:
		dc.b 2
		dc.b id_frame_boss_flame2
		dc.b id_frame_boss_flame1
		dc.b id_frame_boss_bigflame1
		dc.b id_frame_boss_bigflame2
		dc.b id_frame_boss_bigflame1
		dc.b id_frame_boss_bigflame2
		dc.b id_frame_boss_flame2
		dc.b id_frame_boss_flame1
		dc.b afBack, 2
		even
