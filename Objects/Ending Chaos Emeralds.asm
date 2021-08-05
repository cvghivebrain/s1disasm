; ---------------------------------------------------------------------------
; Object 88 - chaos emeralds on	the ending sequence
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	ECha_Index(pc,d0.w),d1
		jsr	ECha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ECha_Index:	index *,,2
		ptr ECha_Main
		ptr ECha_Move

echa_origX:	equ $38	; x-axis centre of emerald circle (2 bytes)
echa_origY:	equ $3A	; y-axis centre of emerald circle (2 bytes)
echa_radius:	equ $3C	; radius (2 bytes)
echa_angle:	equ $3E	; angle for rotation (2 bytes)
; ===========================================================================

ECha_Main:	; Routine 0
		cmpi.b	#2,(v_player+ost_frame).w ; this isn't `id_frame_Wait1`: `v_player` is Object 88, which has its own frames
		beq.s	ECha_CreateEms
		addq.l	#4,sp
		rts	
; ===========================================================================

ECha_CreateEms:
		move.w	(v_player+ost_x_pos).w,ost_x_pos(a0) ; match X position with Sonic
		move.w	(v_player+ost_y_pos).w,ost_y_pos(a0) ; match Y position with Sonic
		movea.l	a0,a1
		moveq	#0,d3
		moveq	#1,d2
		moveq	#5,d1

	ECha_LoadLoop:
		move.b	#id_EndChaos,(a1) ; load chaos emerald object
		addq.b	#2,ost_routine(a1)
		move.l	#Map_ECha,ost_mappings(a1)
		move.w	#tile_Nem_EndEm,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#1,ost_priority(a1)
		move.w	ost_x_pos(a0),echa_origX(a1)
		move.w	ost_y_pos(a0),echa_origY(a1)
		move.b	d2,ost_anim(a1)
		move.b	d2,ost_frame(a1)
		addq.b	#1,d2
		move.b	d3,ost_angle(a1)
		addi.b	#$100/6,d3	; angle between each emerald
		lea	$40(a1),a1
		dbf	d1,ECha_LoadLoop ; repeat 5 more times

ECha_Move:	; Routine 2
		move.w	echa_angle(a0),d0
		add.w	d0,ost_angle(a0)
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	echa_radius(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	echa_origX(a0),d1
		add.w	echa_origY(a0),d0
		move.w	d1,ost_x_pos(a0)
		move.w	d0,ost_y_pos(a0)

	ECha_Expand:
		cmpi.w	#$2000,echa_radius(a0)
		beq.s	ECha_Rotate
		addi.w	#$20,echa_radius(a0) ; expand circle of emeralds

	ECha_Rotate:
		cmpi.w	#$2000,echa_angle(a0)
		beq.s	ECha_Rise
		addi.w	#$20,echa_angle(a0) ; move emeralds around the centre

	ECha_Rise:
		cmpi.w	#$140,echa_origY(a0)
		beq.s	ECha_End
		subq.w	#1,echa_origY(a0) ; make circle rise

ECha_End:
		rts	
