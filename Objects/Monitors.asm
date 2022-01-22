; ---------------------------------------------------------------------------
; Object 26 - monitors

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtypes 2/3/4/5/6
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 2/3/4/5/6
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3 - subtypes 2/3/4/5/6
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtypes 2/4/5/6
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes 2/4/5/6
;	ObjPos_SBZ1, ObjPos_SBZ2, ObjPos_SBZ3 - subtypes 2/4/5/6/$11/$13/$15/$17
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
		addq.b	#2,ost_routine(a0)			; goto Mon_Solid next
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
		move.b	#id_Mon_Display,ost_routine(a0)		; goto Mon_Display next
		move.b	#id_frame_monitor_broken,ost_frame(a0)	; use broken monitor frame
		rts	
; ===========================================================================

	@notbroken:
		move.b	#id_col_16x16+id_col_item,ost_col_type(a0)
		move.b	ost_subtype(a0),ost_anim(a0)		; use animation based on subtype

Mon_Solid:	; Routine 2
		move.b	ost_routine2(a0),d0			; is monitor being stood on or falling?
		beq.s	Mon_Solid_Normal			; if not, branch
		subq.b	#2,d0
		bne.s	Mon_Solid_Fall				; branch if ost_routine2 > 2

		; ost_routine2 = 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		bsr.w	ExitPlatform				; clear platform flags if Sonic walks off the monitor
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on top of the monitor?
		bne.w	@ontop					; if yes, branch
		clr.b	ost_routine2(a0)
		bra.w	Mon_Animate
; ===========================================================================

	@ontop:
		move.w	#$10,d3
		move.w	ost_x_pos(a0),d2
		bsr.w	MoveWithPlatform			; update Sonic's position
		bra.w	Mon_Animate
; ===========================================================================

Mon_Solid_Fall:	; ost_routine2 = 4
		bsr.w	ObjectFall				; apply gravity and update position
		jsr	(FindFloorObj).l
		tst.w	d1					; has monitor hit the floor?
		bpl.w	Mon_Animate				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)				; stop moving
		clr.b	ost_routine2(a0)
		bra.w	Mon_Animate
; ===========================================================================

Mon_Solid_Normal:
		; ost_routine2 = 0
		move.w	#$1A,d1					; monitor width/2
		move.w	#$F,d2					; monitor height/2
		bsr.w	Mon_Solid_Detect			; detect collision
		beq.w	Mon_Solid_ChkPush			; branch if none
		tst.w	ost_y_vel(a1)				; is Sonic moving upwards?
		bmi.s	@dont_break				; if yes, branch
		cmpi.b	#id_Roll,ost_anim(a1)			; is Sonic rolling/jumping?
		beq.s	Mon_Solid_ChkPush			; if yes, branch

	@dont_break:
		tst.w	d1					; is side collision flag set?
		bpl.s	Mon_Solid_Side				; if yes, branch
		sub.w	d3,ost_y_pos(a1)			; align Sonic to top of monitor
		bsr.w	Plat_NoCheck				; update platform status flags for Sonic/monitor
		move.b	#2,ost_routine2(a0)			; Sonic is standing on monitor
		bra.w	Mon_Animate
; ===========================================================================

Mon_Solid_Side:
		tst.w	d0
		beq.w	@sonic_push				; branch if Sonic is touching right side of monitor
		bmi.s	@sonic_left				; branch if Sonic is to the left
		tst.w	ost_x_vel(a1)				; is Sonic moving left?
		bmi.s	@sonic_push				; if yes, branch
		bra.s	@sonic_right				; Sonic is moving right/stationary
; ===========================================================================

@sonic_left:
		tst.w	ost_x_vel(a1)				; is Sonic moving right?
		bpl.s	@sonic_push				; if yes, branch

@sonic_right:
		sub.w	d0,ost_x_pos(a1)			; align Sonic to side of monitor
		move.w	#0,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)			; stop Sonic moving

@sonic_push:
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air?
		bne.s	Mon_Solid_ClearPush			; if yes, branch
		bset	#status_pushing_bit,ost_status(a1)	; set pushing flags
		bset	#status_pushing_bit,ost_status(a0)
		bra.s	Mon_Animate
; ===========================================================================

Mon_Solid_ChkPush:
		btst	#status_pushing_bit,ost_status(a0)	; is monitor being pushed?
		beq.s	Mon_Animate				; if not, branch
		move.w	#id_Run,ost_anim(a1)

Mon_Solid_ClearPush:
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
		addq.b	#2,ost_routine(a0)			; goto Mon_Animate next
		move.b	#0,ost_col_type(a0)
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	Mon_Explode				; branch if not found
		move.b	#id_PowerUp,ost_id(a1)			; load monitor contents object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_anim(a0),ost_anim(a1)		; inherit animation id

Mon_Explode:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
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

; input:
;	d1 = width/2
;	d2 = height/2

; output:
;	d0 = distance from right side of monitor
;	d1 = collision type: 0 = none; 1 = side collision; -1 = top/bottom collision
;	d3 = distance from top of monitor
; ---------------------------------------------------------------------------

Mon_Solid_Detect:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0					; d0 = distance from left side of monitor
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
		add.w	d2,d3					; d3 = distance from top of monitor
		bmi.s	@no_collision				; branch if Sonic is above object
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	@no_collision				; branch if Sonic is below object
		
		tst.b	(v_lock_multi).w
		bmi.s	@no_collision				; branch if object collision is disabled
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w
		bcc.s	@no_collision				; branch if Sonic is dead
		tst.w	(v_debug_active).w
		bne.s	@no_collision				; branch if debug mode is in use
		
		cmp.w	d0,d1					; is Sonic between left side & middle of monitor?
		bcc.s	@left_hit				; if yes, branch
		add.w	d1,d1
		sub.w	d1,d0					; d0 = distance from right side of monitor

	@left_hit:
		cmpi.w	#$10,d3					; is Sonic between top & middle of monitor?
		bcs.s	@top_hit				; if yes, branch

@side_hit:
		moveq	#1,d1					; set side collision flag
		rts	
; ===========================================================================

@no_collision:
		moveq	#0,d1					; set no collision flag
		rts	
; ===========================================================================

@top_hit:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	ost_x_pos(a1),d1
		sub.w	ost_x_pos(a0),d1
		bmi.s	@side_hit				; branch if Sonic is to the left
		cmp.w	d2,d1
		bcc.s	@side_hit				; branch if Sonic is to the right
		moveq	#-1,d1					; set top/bottom collision flag
		rts	
; End of function Mon_Solid_Detect

		endm
		
