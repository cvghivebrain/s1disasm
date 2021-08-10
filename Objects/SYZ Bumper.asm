; ---------------------------------------------------------------------------
; Object 47 - pinball bumper (SYZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bump_Index(pc,d0.w),d1
		jmp	Bump_Index(pc,d1.w)
; ===========================================================================
Bump_Index:	index *,,2
		ptr Bump_Main
		ptr Bump_Hit
; ===========================================================================

Bump_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bump,ost_mappings(a0)
		move.w	#tile_Nem_Bumper,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$D7,ost_col_type(a0)

Bump_Hit:	; Routine 2
		tst.b	ost_col_property(a0)	; has Sonic touched the	bumper?
		beq.w	@display	; if not, branch
		clr.b	ost_col_property(a0)
		lea	(v_player).w,a1
		move.w	ost_x_pos(a0),d1
		move.w	ost_y_pos(a0),d2
		sub.w	ost_x_pos(a1),d1
		sub.w	ost_y_pos(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a1)	; bounce Sonic away
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a1)	; bounce Sonic away
		bset	#1,ost_status(a1)
		bclr	#4,ost_status(a1)
		bclr	#5,ost_status(a1)
		clr.b	$3C(a1)
		move.b	#1,ost_anim(a0)	; use "hit" animation
		sfx	sfx_Bumper,0,0,0	; play bumper sound
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@addscore
		cmpi.b	#$8A,2(a2,d0.w)	; has bumper been hit 10 times?
		bcc.s	@display	; if yes, Sonic	gets no	points
		addq.b	#1,2(a2,d0.w)

	@addscore:
		moveq	#1,d0
		jsr	(AddPoints).l	; add 10 to score
		bsr.w	FindFreeObj
		bne.s	@display
		move.b	#id_Points,0(a1) ; load points object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#4,ost_frame(a1)

	@display:
		lea	(Ani_Bump).l,a1
		bsr.w	AnimateSprite
		out_of_range.s	@resetcount
		bra.w	DisplaySprite
; ===========================================================================

@resetcount:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		bra.w	DeleteObject
