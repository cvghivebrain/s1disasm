; ---------------------------------------------------------------------------
; Object 3E - prison capsule
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Pri_Index(pc,d0.w),d1
		jsr	Pri_Index(pc,d1.w)
		out_of_range.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================
Pri_Index:	index *,,2
		ptr Pri_Main
		ptr Pri_BodyMain
		ptr Pri_Switched
		ptr Pri_Explosion
		ptr Pri_Explosion
		ptr Pri_Explosion
		ptr Pri_Animals
		ptr Pri_EndAct

pri_origY:	equ $30		; original y-axis position

Pri_Var:	dc.b id_Pri_BodyMain,	$20, 4,	0	; routine, width, priority, frame
		dc.b id_Pri_Switched,	$C, 5, 1
		dc.b id_Pri_Explosion,	$10, 4,	3
		dc.b id_Pri_Explosion+2,	$10, 3,	5
; ===========================================================================

Pri_Main:	; Routine 0
		move.l	#Map_Pri,ost_mappings(a0)
		move.w	#tile_Nem_Prison,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	ost_y_pos(a0),pri_origY(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		lsl.w	#2,d0
		lea	Pri_Var(pc,d0.w),a1
		move.b	(a1)+,ost_routine(a0)
		move.b	(a1)+,ost_actwidth(a0)
		move.b	(a1)+,ost_priority(a0)
		move.b	(a1)+,ost_frame(a0)
		cmpi.w	#8,d0		; is object type number	02?
		bne.s	@not02		; if not, branch

		move.b	#6,ost_col_type(a0)
		move.b	#8,ost_col_property(a0)

	@not02:
		rts	
; ===========================================================================

Pri_BodyMain:	; Routine 2
		cmpi.b	#2,(v_bossstatus).w
		beq.s	@chkopened
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	ost_x_pos(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

@chkopened:
		tst.b	ost_routine2(a0)	; has the prison been opened?
		beq.s	@open		; if yes, branch
		clr.b	ost_routine2(a0)
		bclr	#3,(v_player+ost_status).w
		bset	#1,(v_player+ost_status).w

	@open:
		move.b	#2,ost_frame(a0)	; use frame number 2 (destroyed	prison)
		rts	
; ===========================================================================

Pri_Switched:	; Routine 4
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		lea	(Ani_Pri).l,a1
		jsr	(AnimateSprite).l
		move.w	pri_origY(a0),ost_y_pos(a0)
		tst.b	ost_routine2(a0)	; has prison already been opened?
		beq.s	@open2		; if yes, branch

		addq.w	#8,ost_y_pos(a0)
		move.b	#$A,ost_routine(a0)
		move.w	#60,ost_anim_time(a0) ; set time between animal spawns
		clr.b	(f_timecount).w	; stop time counter
		clr.b	(f_lockscreen).w ; lock screen position
		move.b	#1,(f_lockctrl).w ; lock controls
		move.w	#(btnR<<8),(v_jpadhold2).w ; make Sonic run to the right
		clr.b	ost_routine2(a0)
		bclr	#3,(v_player+ost_status).w
		bset	#1,(v_player+ost_status).w

	@open2:
		rts	
; ===========================================================================

Pri_Explosion:	; Routine 6, 8, $A
		moveq	#7,d0
		and.b	(v_vbla_byte).w,d0
		bne.s	@noexplosion
		jsr	(FindFreeObj).l
		bne.s	@noexplosion
		move.b	#id_ExplosionBomb,0(a1) ; load explosion object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,ost_x_pos(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,ost_y_pos(a1)

	@noexplosion:
		subq.w	#1,ost_anim_time(a0)
		beq.s	@makeanimal
		rts	
; ===========================================================================

@makeanimal:
		move.b	#2,(v_bossstatus).w
		move.b	#$C,ost_routine(a0)	; replace explosions with animals
		move.b	#6,ost_frame(a0)
		move.w	#150,ost_anim_time(a0)
		addi.w	#$20,ost_y_pos(a0)
		moveq	#7,d6
		move.w	#$9A,d5
		moveq	#-$1C,d4

	@loop:
		jsr	(FindFreeObj).l
		bne.s	@fail
		move.b	#id_Animals,0(a1) ; load animal object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		add.w	d4,ost_x_pos(a1)
		addq.w	#7,d4
		move.w	d5,$36(a1)
		subq.w	#8,d5
		dbf	d6,@loop	; repeat 7 more	times

	@fail:
		rts	
; ===========================================================================

Pri_Animals:	; Routine $C
		moveq	#7,d0
		and.b	(v_vbla_byte).w,d0
		bne.s	@noanimal
		jsr	(FindFreeObj).l
		bne.s	@noanimal
		move.b	#id_Animals,0(a1) ; load animal object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		subq.w	#6,d0
		tst.w	d1
		bpl.s	@ispositive
		neg.w	d0

	@ispositive:
		add.w	d0,ost_x_pos(a1)
		move.w	#$C,$36(a1)

	@noanimal:
		subq.w	#1,ost_anim_time(a0)
		bne.s	@wait
		addq.b	#2,ost_routine(a0)
		move.w	#180,ost_anim_time(a0)

	@wait:
		rts	
; ===========================================================================

Pri_EndAct:	; Routine $E
		moveq	#$3E,d0
		moveq	#id_Animals,d1
		moveq	#$40,d2
		lea	(v_objspace+$40).w,a1 ; load object RAM

	@findanimal:
		cmp.b	(a1),d1		; is object $28	(animal) loaded?
		beq.s	@found		; if yes, branch
		adda.w	d2,a1		; next object RAM
		dbf	d0,@findanimal	; repeat $3E times

		jsr	(GotThroughAct).l
		jmp	(DeleteObject).l

	@found:
		rts	
