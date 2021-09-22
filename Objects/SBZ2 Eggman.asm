; ---------------------------------------------------------------------------
; Object 82 - Eggman (SBZ2)
; ---------------------------------------------------------------------------

ScrapEggman:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SEgg_Index(pc,d0.w),d1
		jmp	SEgg_Index(pc,d1.w)
; ===========================================================================
SEgg_Index:	index *,,2
		ptr SEgg_Main
		ptr SEgg_Eggman
		ptr SEgg_Switch

SEgg_ObjData:	dc.b id_SEgg_Eggman, id_ani_eggman_stand, 3	; routine number, animation, priority
		dc.b id_SEgg_Switch, 0, 3

ost_eggman_parent:	equ $34	; address of OST of parent object (4 bytes)
ost_eggman_wait_time:	equ $3C	; time delay between events (2 bytes)
; ===========================================================================

SEgg_Main:	; Routine 0
		lea	SEgg_ObjData(pc),a2
		move.w	#$2160,ost_x_pos(a0)
		move.w	#$5A4,ost_y_pos(a0)
		move.b	#$F,ost_col_type(a0)
		move.b	#$10,ost_col_property(a0)
		bclr	#status_xflip_bit,ost_status(a0)
		clr.b	ost_routine2(a0)
		move.b	(a2)+,ost_routine(a0)
		move.b	(a2)+,ost_anim(a0)
		move.b	(a2)+,ost_priority(a0)
		move.l	#Map_SEgg,ost_mappings(a0)
		move.w	#tile_Nem_Sbz2Eggman,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		move.b	#$20,ost_actwidth(a0)
		jsr	(FindNextFreeObj).l
		bne.s	SEgg_Eggman
		move.l	a0,ost_eggman_parent(a1)
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
		bset	#render_onscreen_bit,ost_render(a1)
		move.b	#$10,ost_actwidth(a1)
		move.b	#id_frame_button_up,ost_frame(a1)

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
		ptr SEgg_Move
; ===========================================================================

SEgg_ChkSonic:
		move.w	ost_x_pos(a0),d0
		sub.w	(v_ost_player+ost_x_pos).w,d0
		cmpi.w	#128,d0		; is Sonic within 128 pixels of	Eggman?
		bcc.s	SEgg_Move	; if not, branch
		addq.b	#2,ost_routine2(a0)
		move.w	#180,ost_eggman_wait_time(a0) ; set delay to 3 seconds
		move.b	#id_ani_eggman_laugh,ost_anim(a0)

SEgg_Move:
		jmp	(SpeedToPos).l
; ===========================================================================

SEgg_PreLeap:
		subq.w	#1,ost_eggman_wait_time(a0) ; subtract 1 from time delay
		bne.s	loc_19954	; if time remains, branch
		addq.b	#2,ost_routine2(a0)
		move.b	#id_ani_eggman_jump1,ost_anim(a0)
		addq.w	#4,ost_y_pos(a0)
		move.w	#15,ost_eggman_wait_time(a0)

loc_19954:
		bra.s	SEgg_Move
; ===========================================================================

SEgg_Leap:
		subq.w	#1,ost_eggman_wait_time(a0)
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
		lea	(v_ost_all).w,a1 ; start at the first object RAM
		moveq	#$3E,d0
		moveq	#$40,d1

SEgg_FindLoop:	
		adda.w	d1,a1		; jump to next object RAM
		cmpi.b	#id_FalseFloor,(a1) ; is object a block? (object $83)
		dbeq	d0,SEgg_FindLoop ; if not, repeat (max $3E times)

		bne.s	loc_199D0
		move.w	#$474F,ost_subtype(a1) ; set block to disintegrate
		addq.b	#2,ost_routine2(a0)
		move.b	#id_ani_eggman_laugh,ost_anim(a0)

loc_199D0:
		bra.w	SEgg_Move
; ===========================================================================

SEgg_Switch:	; Routine 4
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	SEgg_SwIndex(pc,d0.w),d0
		jmp	SEgg_SwIndex(pc,d0.w)
; ===========================================================================
SEgg_SwIndex:	index *
		ptr SEgg_SwChk
		ptr SEgg_SwDisplay
; ===========================================================================

SEgg_SwChk:
		movea.l	ost_eggman_parent(a0),a1
		cmpi.w	#$5357,ost_subtype(a1)
		bne.s	SEgg_SwDisplay
		move.b	#id_frame_button_down,ost_frame(a0)
		addq.b	#2,ost_routine2(a0)

SEgg_SwDisplay:
		jmp	(DisplaySprite).l
