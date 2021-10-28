; ---------------------------------------------------------------------------
; Object 37 - rings flying out of Sonic	when he's hit
; ---------------------------------------------------------------------------

RingLoss:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	RLoss_Index(pc,d0.w),d1
		jmp	RLoss_Index(pc,d1.w)
; ===========================================================================
RLoss_Index:	index *,,2
		ptr RLoss_Count
		ptr RLoss_Bounce
		ptr RLoss_Collect
		ptr RLoss_Sparkle
		ptr RLoss_Delete
; ===========================================================================

RLoss_Count:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(v_rings).w,d5	; check number of rings you have
		moveq	#32,d0
		cmp.w	d0,d5		; do you have 32 or more?
		bcs.s	@belowmax	; if not, branch
		move.w	d0,d5		; if yes, set d5 to 32

	@belowmax:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	@makerings
; ===========================================================================

	@loop:
		bsr.w	FindFreeObj
		bne.w	@resetcounter

@makerings:
		move.b	#id_RingLoss,0(a1) ; load bouncing ring object
		addq.b	#2,ost_routine(a1)
		move.b	#8,ost_height(a1)
		move.b	#8,ost_width(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.l	#Map_Ring,ost_mappings(a1)
		move.w	#tile_Nem_Ring+tile_pal2,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#3,ost_priority(a1)
		move.b	#$47,ost_col_type(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#-1,(v_ani3_time).w
		tst.w	d4
		bmi.s	@loc_9D62
		move.w	d4,d0
		bsr.w	CalcSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	@loc_9D62
		subi.w	#$80,d4
		bcc.s	@loc_9D62
		move.w	#$288,d4

	@loc_9D62:
		move.w	d2,ost_x_vel(a1)
		move.w	d3,ost_y_vel(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,@loop	; repeat for number of rings (max 31)

@resetcounter:
		move.w	#0,(v_rings).w	; reset number of rings to zero
		move.b	#$80,(v_hud_rings_update).w ; update ring counter
		move.b	#0,(v_ring_reward).w
		play.w	1, jsr, sfx_RingLoss		; play ring loss sound

RLoss_Bounce:	; Routine 2
		move.b	(v_ani3_frame).w,ost_frame(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)
		bmi.s	@chkdel
		move.b	(v_vblank_counter_byte).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	@chkdel
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.s	@chkdel
		add.w	d1,ost_y_pos(a0)
		move.w	ost_y_vel(a0),d0
		asr.w	#2,d0
		sub.w	d0,ost_y_vel(a0)
		neg.w	ost_y_vel(a0)

	@chkdel:
		tst.b	(v_ani3_time).w
		beq.s	RLoss_Delete
		move.w	(v_boundary_bottom).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0 ; has object moved below level boundary?
		bcs.s	RLoss_Delete	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

RLoss_Collect:	; Routine 4
		addq.b	#2,ost_routine(a0)
		move.b	#0,ost_col_type(a0)
		move.b	#1,ost_priority(a0)
		bsr.w	CollectRing

RLoss_Sparkle:	; Routine 6
		lea	(Ani_Ring).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

RLoss_Delete:	; Routine 8
		bra.w	DeleteObject
