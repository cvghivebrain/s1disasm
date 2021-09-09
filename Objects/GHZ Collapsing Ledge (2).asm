
Ledge_Fragment:
		move.b	#0,ost_ledge_flag(a0)

loc_847A:
		lea	(CFlo_Data1).l,a4
		moveq	#$18,d1
		addq.b	#2,ost_frame(a0)

loc_8486:
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		add.w	d0,d0
		movea.l	ost_mappings(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#render_rawmap_bit,ost_render(a0)
		move.b	0(a0),d4
		move.b	ost_render(a0),d5
		movea.l	a0,a1
		bra.s	loc_84B2
; ===========================================================================

loc_84AA:
		bsr.w	FindFreeObj
		bne.s	loc_84F2
		addq.w	#5,a3

loc_84B2:
		move.b	#id_Ledge_Display,ost_routine(a1)
		move.b	d4,0(a1)
		move.l	a3,ost_mappings(a1)
		move.b	d5,ost_render(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.b	ost_actwidth(a0),ost_actwidth(a1)
		move.b	(a4)+,ost_ledge_wait_time(a1)
		cmpa.l	a0,a1
		bhs.s	loc_84EE
		bsr.w	DisplaySprite_a1

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		bsr.w	DisplaySprite
		sfx	sfx_Collapse,1,0,0 ; play collapsing sound