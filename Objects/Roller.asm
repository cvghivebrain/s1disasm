; ---------------------------------------------------------------------------
; Object 43 - Roller enemy (SYZ)
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

ost_roller_open_time:	equ $30	; time roller stays open for (2 bytes)
ost_roller_mode:	equ $32	; +1 = roller has jumped; +$80 = roller has stopped
; ===========================================================================

Roll_Main:	; Routine 0
		move.b	#$E,ost_height(a0)
		move.b	#8,ost_width(a0)
		bsr.w	ObjectFall
		bsr.w	FindFloorObj
		tst.w	d1
		bpl.s	locret_E052
		add.w	d1,ost_y_pos(a0) ; match roller's position with the floor
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Roll,ost_mappings(a0)
		move.w	#tile_Nem_Roller,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)

	locret_E052:
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
Roll_Index2:	index *
		ptr Roll_RollChk
		ptr Roll_RollNoChk
		ptr Roll_ChkJump
		ptr Roll_MatchFloor
; ===========================================================================

Roll_RollChk:
		move.w	(v_ost_player+ost_x_pos).w,d0
		subi.w	#$100,d0
		bcs.s	loc_E0D2
		sub.w	ost_x_pos(a0),d0 ; check distance between Roller and Sonic
		bcs.s	loc_E0D2
		addq.b	#4,ost_routine2(a0)
		move.b	#id_ani_roll_roll,ost_anim(a0)
		move.w	#$700,ost_x_vel(a0) ; move Roller horizontally
		move.b	#id_col_14x14+id_col_hurt,ost_col_type(a0) ; make Roller invincible

loc_E0D2:
		addq.l	#4,sp
		rts	
; ===========================================================================

Roll_RollNoChk:
		cmpi.b	#id_ani_roll_roll,ost_anim(a0)
		beq.s	loc_E0F8
		subq.w	#1,ost_roller_open_time(a0)
		bpl.s	locret_E0F6
		move.b	#id_ani_roll_fold,ost_anim(a0)
		move.w	#$700,ost_x_vel(a0)
		move.b	#id_col_14x14+id_col_hurt,ost_col_type(a0)

locret_E0F6:
		rts	
; ===========================================================================

loc_E0F8:
		addq.b	#2,ost_routine2(a0)
		rts	
; ===========================================================================

Roll_ChkJump:
		bsr.w	Roll_Stop
		bsr.w	SpeedToPos
		bsr.w	FindFloorObj
		cmpi.w	#-8,d1
		blt.s	Roll_Jump
		cmpi.w	#$C,d1
		bge.s	Roll_Jump
		add.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

Roll_Jump:
		addq.b	#2,ost_routine2(a0)
		bset	#0,ost_roller_mode(a0)
		beq.s	locret_E12E
		move.w	#-$600,ost_y_vel(a0) ; move Roller vertically

locret_E12E:
		rts	
; ===========================================================================

Roll_MatchFloor:
		bsr.w	ObjectFall
		tst.w	ost_y_vel(a0)
		bmi.s	locret_E150
		bsr.w	FindFloorObj
		tst.w	d1
		bpl.s	locret_E150
		add.w	d1,ost_y_pos(a0) ; match Roller's position with the floor
		subq.b	#2,ost_routine2(a0)
		move.w	#0,ost_y_vel(a0)

locret_E150:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Roll_Stop:
		tst.b	ost_roller_mode(a0)
		bmi.s	locret_E188
		move.w	(v_ost_player+ost_x_pos).w,d0
		subi.w	#$30,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	locret_E188
		move.b	#id_ani_roll_unfold,ost_anim(a0)
		move.b	#id_col_14x14,ost_col_type(a0)
		clr.w	ost_x_vel(a0)
		move.w	#120,ost_roller_open_time(a0) ; set waiting time to 2 seconds
		move.b	#2,ost_routine2(a0)
		bset	#7,ost_roller_mode(a0)

locret_E188:
		rts	
; End of function Roll_Stop
