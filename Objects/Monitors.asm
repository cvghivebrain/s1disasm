; ---------------------------------------------------------------------------
; Object 26 - monitors
; ---------------------------------------------------------------------------

Monitor:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Mon_Index(pc,d0.w),d1
		jmp	Mon_Index(pc,d1.w)
; ===========================================================================
Mon_Index:	index *,,2
		ptr Mon_Main
		ptr Mon_Solid
		ptr Mon_BreakOpen
		ptr Mon_Animate
		ptr Mon_Display
; ===========================================================================

Mon_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$E,ost_height(a0)
		move.b	#$E,ost_width(a0)
		move.l	#Map_Monitor,ost_mappings(a0)
		move.w	#tile_Nem_Monitors,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$F,ost_actwidth(a0)
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)				; has monitor been broken?
		beq.s	@notbroken				; if not, branch
		move.b	#id_Mon_Display,ost_routine(a0)		; run "Mon_Display" routine
		move.b	#id_frame_monitor_broken,ost_frame(a0)	; use broken monitor frame
		rts	
; ===========================================================================

	@notbroken:
		move.b	#id_col_16x16+id_col_item,ost_col_type(a0)
		move.b	ost_subtype(a0),ost_anim(a0)

Mon_Solid:	; Routine 2
		move.b	ost_routine2(a0),d0			; is monitor set to fall?
		beq.s	Mon_Solid_Normal			; if not, branch
		subq.b	#2,d0
		bne.s	Mon_Solid_Fall

		; ost_routine2 = 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on top of the monitor?
		bne.w	@ontop					; if yes, branch
		clr.b	ost_routine2(a0)
		bra.w	Mon_Animate
; ===========================================================================

	@ontop:
		move.w	#$10,d3
		move.w	ost_x_pos(a0),d2
		bsr.w	MoveWithPlatform
		bra.w	Mon_Animate
; ===========================================================================

Mon_Solid_Fall:	; ost_routine2 = 4
		bsr.w	ObjectFall
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.w	Mon_Animate
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)
		clr.b	ost_routine2(a0)
		bra.w	Mon_Animate
; ===========================================================================

Mon_Solid_Normal:
		; ost_routine2 = 0
		move.w	#$1A,d1					; monitor width/2
		move.w	#$F,d2					; monitor height/2
		bsr.w	Mon_SolidSides				; detect collision
		beq.w	loc_A25C				; branch if none
		tst.w	ost_y_vel(a1)
		bmi.s	loc_A20A
		cmpi.b	#id_Roll,ost_anim(a1)			; is Sonic rolling?
		beq.s	loc_A25C				; if yes, branch

loc_A20A:
		tst.w	d1
		bpl.s	loc_A220
		sub.w	d3,ost_y_pos(a1)
		bsr.w	Plat_NoCheck
		move.b	#2,ost_routine2(a0)
		bra.w	Mon_Animate
; ===========================================================================

loc_A220:
		tst.w	d0
		beq.w	loc_A246
		bmi.s	loc_A230
		tst.w	ost_x_vel(a1)
		bmi.s	loc_A246
		bra.s	loc_A236
; ===========================================================================

loc_A230:
		tst.w	ost_x_vel(a1)
		bpl.s	loc_A246

loc_A236:
		sub.w	d0,ost_x_pos(a1)
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)

loc_A246:
		btst	#status_air_bit,ost_status(a1)
		bne.s	loc_A26A
		bset	#status_pushing_bit,ost_status(a1)
		bset	#status_pushing_bit,ost_status(a0)
		bra.s	Mon_Animate
; ===========================================================================

loc_A25C:
		btst	#status_pushing_bit,ost_status(a0)
		beq.s	Mon_Animate
		move.w	#1,ost_anim(a1)				; clear ost_anim and set ost_anim_restart to 1

loc_A26A:
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a1)

Mon_Animate:	; Routine 6
		lea	(Ani_Monitor).l,a1
		bsr.w	AnimateSprite

Mon_Display:	; Routine 8
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
; ===========================================================================

Mon_BreakOpen:	; Routine 4
		addq.b	#2,ost_routine(a0)
		move.b	#0,ost_col_type(a0)
		bsr.w	FindFreeObj
		bne.s	Mon_Explode
		move.b	#id_PowerUp,ost_id(a1)			; load monitor contents object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_anim(a0),ost_anim(a1)

Mon_Explode:
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_ExplosionItem,ost_id(a1)		; load explosion object
		addq.b	#2,ost_routine(a1)			; don't create an animal
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

	@fail:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#id_ani_monitor_breaking,ost_anim(a0)	; set monitor type to broken
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Object 26 - monitors, part 2
; ---------------------------------------------------------------------------

include_Monitor_2:	macro

; ---------------------------------------------------------------------------
; Subroutine to	make the sides of a monitor solid
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Mon_SolidSides:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	@no_collision				; branch if Sonic is left of object
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	@no_collision				; branch if Sonic is right of object
		move.b	ost_height(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	ost_y_pos(a1),d3
		sub.w	ost_y_pos(a0),d3
		add.w	d2,d3
		bmi.s	@no_collision				; branch if Sonic is above object
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	@no_collision				; branch if Sonic is below object
		
		tst.b	(v_lock_multi).w
		bmi.s	@no_collision				; branch if object collision is off
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w
		bcc.s	@no_collision				; branch if Sonic is dead
		tst.w	(v_debug_active).w
		bne.s	@no_collision				; branch if debug mode is in use
		
		cmp.w	d0,d1
		bcc.s	@loc_A4DC
		add.w	d1,d1
		sub.w	d1,d0

@loc_A4DC:
		cmpi.w	#$10,d3
		bcs.s	@loc_A4EA

@loc_A4E2:
		moveq	#1,d1
		rts	
; ===========================================================================

@no_collision:
		moveq	#0,d1
		rts	
; ===========================================================================

@loc_A4EA:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	ost_x_pos(a1),d1
		sub.w	ost_x_pos(a0),d1
		bmi.s	@loc_A4E2
		cmp.w	d2,d1
		bcc.s	@loc_A4E2
		moveq	#-1,d1
		rts	
; End of function Obj26_SolidSides

		endm
		
