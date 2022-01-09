; ---------------------------------------------------------------------------
; Object 88 - chaos emeralds on	the ending sequence

; spawned by:
;	EndSonic
; ---------------------------------------------------------------------------

EndChaos:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	ECha_Index(pc,d0.w),d1
		jsr	ECha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ECha_Index:	index *,,2
		ptr ECha_Main
		ptr ECha_Move

ost_echaos_x_start:	equ $38					; x-axis centre of emerald circle (2 bytes)
ost_echaos_y_start:	equ $3A					; y-axis centre of emerald circle (2 bytes)
ost_echaos_radius:	equ $3C					; radius (2 bytes)
ost_echaos_angle:	equ $3E					; angle for rotation (2 bytes)
; ===========================================================================

ECha_Main:	; Routine 0
		cmpi.b	#id_frame_esonic_up,(v_ost_player+ost_frame).w ; is Sonic looking up?
		beq.s	ECha_CreateEms				; if yes, branch
		addq.l	#4,sp
		rts	
; ===========================================================================

ECha_CreateEms:
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a0) ; match x position with Sonic
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a0) ; match y position with Sonic
		movea.l	a0,a1
		moveq	#0,d3
		moveq	#id_frame_echaos_blue,d2
		moveq	#6-1,d1

	ECha_LoadLoop:
		move.b	#id_EndChaos,(a1)			; load chaos emerald object
		addq.b	#2,ost_routine(a1)			; goto ECha_Move next
		move.l	#Map_ECha,ost_mappings(a1)
		move.w	#tile_Nem_EndEm,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#1,ost_priority(a1)
		move.w	ost_x_pos(a0),ost_echaos_x_start(a1)
		move.w	ost_y_pos(a0),ost_echaos_y_start(a1)
		move.b	d2,ost_anim(a1)
		move.b	d2,ost_frame(a1)
		addq.b	#1,d2
		move.b	d3,ost_angle(a1)
		addi.b	#$100/6,d3				; angle between each emerald
		lea	sizeof_ost(a1),a1
		dbf	d1,ECha_LoadLoop			; repeat 5 more times

ECha_Move:	; Routine 2
		move.w	ost_echaos_angle(a0),d0
		add.w	d0,ost_angle(a0)
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	ost_echaos_radius(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	ost_echaos_x_start(a0),d1
		add.w	ost_echaos_y_start(a0),d0
		move.w	d1,ost_x_pos(a0)
		move.w	d0,ost_y_pos(a0)

	ECha_Expand:
		cmpi.w	#$2000,ost_echaos_radius(a0)
		beq.s	ECha_Rotate
		addi.w	#$20,ost_echaos_radius(a0)		; expand circle of emeralds

	ECha_Rotate:
		cmpi.w	#$2000,ost_echaos_angle(a0)
		beq.s	ECha_Rise
		addi.w	#$20,ost_echaos_angle(a0)		; move emeralds around the centre

	ECha_Rise:
		cmpi.w	#$140,ost_echaos_y_start(a0)
		beq.s	ECha_End
		subq.w	#1,ost_echaos_y_start(a0)		; make circle rise

ECha_End:
		rts	
