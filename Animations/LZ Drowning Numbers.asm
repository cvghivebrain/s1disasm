; ---------------------------------------------------------------------------
; Animation script - countdown numbers and bubbles (LZ)
; ---------------------------------------------------------------------------
Ani_Drown:	index *
		ptr ani_drown_zeroappear
		ptr ani_drown_oneappear
		ptr ani_drown_twoappear
		ptr ani_drown_threeappear
		ptr ani_drown_fourappear
		ptr ani_drown_fiveappear
		ptr ani_drown_smallbubble	; 6
		ptr ani_drown_zeroflash		; 7
		ptr ani_drown_oneflash		; 8
		ptr ani_drown_twoflash		; 9
		ptr ani_drown_threeflash	; $A
		ptr ani_drown_fourflash		; $B
		ptr ani_drown_fiveflash		; $C
		ptr ani_drown_blank		; $D
		ptr ani_drown_mediumbubble	; $E
		
ani_drown_zeroappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_zero_small, id_frame_bubble_zero, afRoutine
			even
ani_drown_oneappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_one_small, id_frame_bubble_one, afRoutine
			even
ani_drown_twoappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_one_small, id_frame_bubble_two, afRoutine
			even
ani_drown_threeappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_three_small, id_frame_bubble_three, afRoutine
			even
ani_drown_fourappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_zero_small, id_frame_bubble_four, afRoutine
			even
ani_drown_fiveappear:	dc.b 5,	id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, id_frame_bubble_five_small, id_frame_bubble_five, afRoutine
			even
ani_drown_smallbubble:	dc.b $E, id_frame_bubble_0, id_frame_bubble_1, id_frame_bubble_2, afRoutine
			even
ani_drown_zeroflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_zero, id_frame_bubble_blank, id_frame_bubble_zero, id_frame_bubble_blank, id_frame_bubble_zero, afRoutine
ani_drown_oneflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_one, id_frame_bubble_blank, id_frame_bubble_one, id_frame_bubble_blank, id_frame_bubble_one, afRoutine
ani_drown_twoflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_two, id_frame_bubble_blank, id_frame_bubble_two, id_frame_bubble_blank, id_frame_bubble_two, afRoutine
ani_drown_threeflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_three, id_frame_bubble_blank, id_frame_bubble_three, id_frame_bubble_blank, id_frame_bubble_three, afRoutine
ani_drown_fourflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_four, id_frame_bubble_blank, id_frame_bubble_four, id_frame_bubble_blank, id_frame_bubble_four, afRoutine
ani_drown_fiveflash:	dc.b 7,	id_frame_bubble_blank, id_frame_bubble_five, id_frame_bubble_blank, id_frame_bubble_five, id_frame_bubble_blank, id_frame_bubble_five, afRoutine
ani_drown_blank:	dc.b $E, afRoutine
ani_drown_mediumbubble:	dc.b $E, id_frame_bubble_1, id_frame_bubble_2, id_frame_bubble_3, id_frame_bubble_4, afRoutine
			even
