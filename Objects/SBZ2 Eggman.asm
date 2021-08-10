; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SEgg_Index(pc,d0.w),d1
		jmp	SEgg_Index(pc,d1.w)
; ===========================================================================
SEgg_Index:	index *,,2
		ptr SEgg_Main
		ptr SEgg_Eggman
		ptr SEgg_Switch

SEgg_ObjData:	dc.b id_SEgg_Eggman,	0, 3		; routine number, animation, priority
		dc.b id_SEgg_Switch,	0, 3
; ===========================================================================

SEgg_Main:	; Routine 0
		lea	SEgg_ObjData(pc),a2
		move.w	#$2160,ost_x_pos(a0)
		move.w	#$5A4,ost_y_pos(a0)
		move.b	#$F,ost_col_type(a0)
		move.b	#$10,ost_col_property(a0)
		bclr	#0,ost_status(a0)
		clr.b	ost_routine2(a0)
		move.b	(a2)+,ost_routine(a0)
		move.b	(a2)+,ost_anim(a0)
		move.b	(a2)+,ost_priority(a0)
		move.l	#Map_SEgg,ost_mappings(a0)
		move.w	#tile_Nem_Sbz2Eggman,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#7,ost_render(a0)
		move.b	#$20,ost_actwidth(a0)
		jsr	(FindNextFreeObj).l
		bne.s	SEgg_Eggman
		move.l	a0,$34(a1)
		move.b	#id_ScrapEggman,(a1) ; load switch object
		move.w	#$2130,ost_x_pos(a1)
		move.w	#$5BC,ost_y_pos(a1)
		clr.b	ost_routine2(a0)
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,ost_anim(a1)
		move.b	(a2)+,ost_priority(a1)
		move.l	#Map_But,ost_mappings(a1)
		move.w	#$4A4,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		bset	#7,ost_render(a1)
		move.b	#$10,ost_actwidth(a1)
		move.b	#0,ost_frame(a1)

SEgg_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	SEgg_EggIndex(pc,d0.w),d1
		jsr	SEgg_EggIndex(pc,d1.w)
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
SEgg_EggIndex:	index *
		ptr SEgg_ChkSonic
		ptr SEgg_PreLeap
		ptr SEgg_Leap
		ptr loc_19934
; ===========================================================================

SEgg_ChkSonic:
		move.w	ost_x_pos(a0),d0
		sub.w	(v_player+ost_x_pos).w,d0
		cmpi.w	#128,d0		; is Sonic within 128 pixels of	Eggman?
		bcc.s	loc_19934	; if not, branch
		addq.b	#2,ost_routine2(a0)
		move.w	#180,$3C(a0)	; set delay to 3 seconds
		move.b	#1,ost_anim(a0)

loc_19934:
		jmp	(SpeedToPos).l
; ===========================================================================

SEgg_PreLeap:
		subq.w	#1,$3C(a0)	; subtract 1 from time delay
		bne.s	loc_19954	; if time remains, branch
		addq.b	#2,ost_routine2(a0)
		move.b	#2,ost_anim(a0)
		addq.w	#4,ost_y_pos(a0)
		move.w	#15,$3C(a0)

loc_19954:
		bra.s	loc_19934
; ===========================================================================

SEgg_Leap:
		subq.w	#1,$3C(a0)
		bgt.s	loc_199D0
		bne.s	loc_1996A
		move.w	#-$FC,ost_x_vel(a0) ; make Eggman leap
		move.w	#-$3C0,ost_y_vel(a0)

loc_1996A:
		cmpi.w	#$2132,ost_x_pos(a0)
		bgt.s	loc_19976
		clr.w	ost_x_vel(a0)

loc_19976:
		addi.w	#$24,ost_y_vel(a0)
		tst.w	ost_y_vel(a0)
		bmi.s	SEgg_FindBlocks
		cmpi.w	#$595,ost_y_pos(a0)
		bcs.s	SEgg_FindBlocks
		move.w	#$5357,ost_subtype(a0)
		cmpi.w	#$59B,ost_y_pos(a0)
		bcs.s	SEgg_FindBlocks
		move.w	#$59B,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)

SEgg_FindBlocks:
		move.w	ost_x_vel(a0),d0
		or.w	ost_y_vel(a0),d0
		bne.s	loc_199D0
		lea	(v_objspace).w,a1 ; start at the first object RAM
		moveq	#$3E,d0
		moveq	#$40,d1

SEgg_FindLoop:	
		adda.w	d1,a1		; jump to next object RAM
		cmpi.b	#id_FalseFloor,(a1) ; is object a block? (object $83)
		dbeq	d0,SEgg_FindLoop ; if not, repeat (max	$3E times)

		bne.s	loc_199D0
		move.w	#$474F,ost_subtype(a1) ; set block to disintegrate
		addq.b	#2,ost_routine2(a0)
		move.b	#1,ost_anim(a0)

loc_199D0:
		bra.w	loc_19934
; ===========================================================================

SEgg_Switch:	; Routine 4
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	SEgg_SwIndex(pc,d0.w),d0
		jmp	SEgg_SwIndex(pc,d0.w)
; ===========================================================================
SEgg_SwIndex:	index *
		ptr loc_199E6
		ptr SEgg_SwDisplay
; ===========================================================================

loc_199E6:
		movea.l	$34(a0),a1
		cmpi.w	#$5357,ost_subtype(a1)
		bne.s	SEgg_SwDisplay
		move.b	#1,ost_frame(a0)
		addq.b	#2,ost_routine2(a0)

SEgg_SwDisplay:
		jmp	(DisplaySprite).l
