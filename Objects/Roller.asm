; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SYZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2
; ---------------------------------------------------------------------------

Roller:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Roll_Index(pc,d0.w),d1
		jmp	Roll_Index(pc,d1.w)
; ===========================================================================
Roll_Index:	index *,,2
		ptr Roll_Main
		ptr Roll_Action

ost_roller_open_time:	equ $30					; time roller stays open for (2 bytes)
ost_roller_mode:	equ $32					; +1 = roller has jumped; +$80 = roller has stopped
; ===========================================================================

Roll_Main:	; Routine 0
		move.b	#$E,ost_height(a0)
		move.b	#8,ost_width(a0)
		bsr.w	ObjectFall				; apply gravity and update position
		bsr.w	FindFloorObj
		tst.w	d1					; has roller hit the floor?
		bpl.s	@no_floor				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#0,ost_y_vel(a0)			; stop falling
		addq.b	#2,ost_routine(a0)			; goto Roll_Action next
		move.l	#Map_Roll,ost_mappings(a0)
		move.w	#tile_Nem_Roller,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$10,ost_displaywidth(a0)

	@no_floor:
		rts	
; ===========================================================================

Roll_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Roll_Index2(pc,d0.w),d1
		jsr	Roll_Index2(pc,d1.w)
		lea	(Ani_Roll).l,a1
		bsr.w	AnimateSprite
		move.w	ost_x_pos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_camera_x_pos).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bgt.w	Roll_ChkGone
		bra.w	DisplaySprite
; ===========================================================================

Roll_ChkGone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	Roll_Delete
		bclr	#7,2(a2,d0.w)

Roll_Delete:
		bra.w	DeleteObject
; ===========================================================================
Roll_Index2:	index *,,2
		ptr Roll_RollChk
		ptr Roll_Stopped
		ptr Roll_ChkJump
		ptr Roll_JumpLand
; ===========================================================================

Roll_RollChk:
		move.w	(v_ost_player+ost_x_pos).w,d0
		subi.w	#$100,d0				; d0 = Sonic's x position minus $100
		bcs.s	@exit					; branch if Sonic is < 256px from left edge of level
		sub.w	ost_x_pos(a0),d0			; is Sonic > 256px left of the roller?
		bcs.s	@exit					; if not, branch
		addq.b	#id_Roll_ChkJump,ost_routine2(a0)	; goto Roll_ChkJump next
		move.b	#id_ani_roll_roll,ost_anim(a0)		; use roller's rolling animation
		move.w	#$700,ost_x_vel(a0)			; move roller to the right
		move.b	#id_col_14x14+id_col_hurt,ost_col_type(a0) ; make roller invincible

	@exit:
		addq.l	#4,sp
		rts	
; ===========================================================================

Roll_Stopped:
		cmpi.b	#id_ani_roll_roll,ost_anim(a0)		; is roller still rolling?
		beq.s	@is_rolling				; if yes, branch
		subq.w	#1,ost_roller_open_time(a0)		; decrement timer
		bpl.s	@wait					; branch if time remains
		move.b	#id_ani_roll_fold,ost_anim(a0)		; use curling animation
		move.w	#$700,ost_x_vel(a0)			; move roller right
		move.b	#id_col_14x14+id_col_hurt,ost_col_type(a0) ; make roller invincible

	@wait:
		rts	
; ===========================================================================

@is_rolling:
		addq.b	#2,ost_routine2(a0)			; goto Roll_ChkJump next
		rts	
; ===========================================================================

Roll_ChkJump:
		bsr.w	Roll_Stop				; stop rolling if it's within range of Sonic
		bsr.w	SpeedToPos				; update position
		bsr.w	FindFloorObj
		cmpi.w	#-8,d1
		blt.s	Roll_Jump				; branch if more than 8px below floor
		cmpi.w	#$C,d1
		bge.s	Roll_Jump				; branch if more than 11px above floor (also detects a ledge)
		add.w	d1,ost_y_pos(a0)			; align to floor
		rts	
; ===========================================================================

Roll_Jump:
		addq.b	#2,ost_routine2(a0)			; goto Roll_JumpLand next
		bset	#0,ost_roller_mode(a0)			; set jump flag
		beq.s	@dont_jump				; branch if previously 0 (jumps on next frame instead)
		move.w	#-$600,ost_y_vel(a0)			; move roller upwards

	@dont_jump:
		rts	
; ===========================================================================

Roll_JumpLand:
		bsr.w	ObjectFall				; apply gravity and update position
		tst.w	ost_y_vel(a0)
		bmi.s	@exit					; branch if moving upwards
		bsr.w	FindFloorObj
		tst.w	d1					; has roller hit the floor?
		bpl.s	@exit					; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		subq.b	#2,ost_routine2(a0)			; goto Roll_ChkJump next
		move.w	#0,ost_y_vel(a0)			; stop falling

@exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to stop Roller if it's within range
; ---------------------------------------------------------------------------

Roll_Stop:
		tst.b	ost_roller_mode(a0)			; has roller already stopped?
		bmi.s	@exit					; if yes, branch
		move.w	(v_ost_player+ost_x_pos).w,d0
		subi.w	#$30,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@exit					; branch if Sonic is > 48px left of the roller
		move.b	#id_ani_roll_unfold,ost_anim(a0)
		move.b	#id_col_14x14,ost_col_type(a0)
		clr.w	ost_x_vel(a0)				; stop roller moving
		move.w	#120,ost_roller_open_time(a0)		; set waiting time to 2 seconds
		move.b	#id_Roll_Stopped,ost_routine2(a0)	; goto Roll_Stopped next
		bset	#7,ost_roller_mode(a0)			; set flag for roller stopped

	@exit:
		rts	
; End of function Roll_Stop

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Roll:	index *
		ptr ani_roll_unfold
		ptr ani_roll_fold
		ptr ani_roll_roll
		
ani_roll_unfold:
		dc.b $F
		dc.b id_frame_roll_roll1
		dc.b id_frame_roll_fold
		dc.b id_frame_roll_stand
		dc.b afBack, 1
ani_roll_fold:	dc.b $F
		dc.b id_frame_roll_fold
		dc.b id_frame_roll_roll1
		dc.b afChange, id_ani_roll_roll
		even
ani_roll_roll:	dc.b 3
		dc.b id_frame_roll_roll2
		dc.b id_frame_roll_roll3
		dc.b id_frame_roll_roll1
		dc.b afEnd
		even
