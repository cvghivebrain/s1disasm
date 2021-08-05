; ---------------------------------------------------------------------------
; Object 8C - chaos emeralds on	the "TRY AGAIN"	screen
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	TCha_Index(pc,d0.w),d1
		jsr	TCha_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
TCha_Index:	index *,,2
		ptr TCha_Main
		ptr TCha_Move
; ===========================================================================

TCha_Main:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#5,d1
		sub.b	(v_emeralds).w,d1

@makeemerald:
		move.b	#id_TryChaos,(a1) ; load emerald object
		addq.b	#2,ost_routine(a1)
		move.l	#Map_ECha,ost_mappings(a1)
		move.w	#tile_Nem_EndEm_TryAgain,ost_tile(a1)
		move.b	#render_abs,ost_render(a1)
		move.b	#1,ost_priority(a1)
		move.w	#$104,ost_x_pos(a1)
		move.w	#$120,$38(a1)
		move.w	#$EC,ost_y_screen(a1)
		move.w	ost_y_screen(a1),$3A(a1)
		move.b	#$1C,$3C(a1)
		lea	(v_emldlist).w,a3

	@chkemerald:
		moveq	#0,d0
		move.b	(v_emeralds).w,d0
		subq.w	#1,d0
		bcs.s	@loc_5B42

	@chkloop:
		cmp.b	(a3,d0.w),d2
		bne.s	@notgot
		addq.b	#1,d2
		bra.s	@chkemerald
; ===========================================================================

	@notgot:
		dbf	d0,@chkloop

@loc_5B42:
		move.b	d2,ost_frame(a1)
		addq.b	#1,ost_frame(a1)
		addq.b	#1,d2
		move.b	#$80,ost_angle(a1)
		move.b	d3,ost_anim_time(a1)
		move.b	d3,ost_anim_delay(a1)
		addi.w	#10,d3
		lea	$40(a1),a1
		dbf	d1,@makeemerald	; repeat 5 times

TCha_Move:	; Routine 2
		tst.w	$3E(a0)
		beq.s	locret_5BBA
		tst.b	ost_anim_time(a0)
		beq.s	loc_5B78
		subq.b	#1,ost_anim_time(a0)
		bne.s	loc_5B80

loc_5B78:
		move.w	$3E(a0),d0
		add.w	d0,ost_angle(a0)

loc_5B80:
		move.b	ost_angle(a0),d0
		beq.s	loc_5B8C
		cmpi.b	#$80,d0
		bne.s	loc_5B96

loc_5B8C:
		clr.w	$3E(a0)
		move.b	ost_anim_delay(a0),ost_anim_time(a0)

loc_5B96:
		jsr	(CalcSine).l
		moveq	#0,d4
		move.b	$3C(a0),d4
		muls.w	d4,d1
		asr.l	#8,d1
		muls.w	d4,d0
		asr.l	#8,d0
		add.w	$38(a0),d1
		add.w	$3A(a0),d0
		move.w	d1,ost_x_pos(a0)
		move.w	d0,ost_y_screen(a0)

locret_5BBA:
		rts	
