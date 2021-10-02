; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Burrobot:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Burro_Index(pc,d0.w),d1
		jmp	Burro_Index(pc,d1.w)
; ===========================================================================
Burro_Index:	index *,,2
		ptr Burro_Main
		ptr Burro_Action

ost_burro_turn_time:	equ $30	; time between direction changes (2 bytes)
;			equ $32	; flag for something
; ===========================================================================

Burro_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$13,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Burro,ost_mappings(a0)
		move.w	#tile_Nem_Burrobot,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#5,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		addq.b	#6,ost_routine2(a0) ; run "Burro_ChkSonic" routine
		move.b	#id_ani_burro_digging,ost_anim(a0)

Burro_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr Burro_ChangeDir
		ptr Burro_Move
		ptr Burro_Jump
		ptr Burro_ChkSonic
; ===========================================================================

Burro_ChangeDir:
		subq.w	#1,ost_burro_turn_time(a0)
		bpl.s	@nochg
		addq.b	#2,ost_routine2(a0)
		move.w	#255,ost_burro_turn_time(a0)
		move.w	#$80,ost_x_vel(a0)
		move.b	#id_ani_burro_walk2,ost_anim(a0)
		bchg	#status_xflip_bit,ost_status(a0) ; change direction the Burrobot is facing
		beq.s	@nochg
		neg.w	ost_x_vel(a0)	; change direction the Burrobot	is moving

	@nochg:
		rts	
; ===========================================================================

Burro_Move:
		subq.w	#1,ost_burro_turn_time(a0)
		bmi.s	loc_AD84
		bsr.w	SpeedToPos
		bchg	#0,$32(a0)
		bne.s	loc_AD78
		move.w	ost_x_pos(a0),d3
		addi.w	#$C,d3
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	loc_AD6A
		subi.w	#$18,d3

loc_AD6A:
		jsr	(FindFloorObj2).l
		cmpi.w	#$C,d1
		bge.s	loc_AD84
		rts	
; ===========================================================================

loc_AD78:
		jsr	(FindFloorObj).l
		add.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

loc_AD84:
		btst	#2,(v_vblank_counter_byte).w
		beq.s	loc_ADA4
		subq.b	#2,ost_routine2(a0)
		move.w	#59,ost_burro_turn_time(a0)
		move.w	#0,ost_x_vel(a0)
		move.b	#id_ani_burro_walk1,ost_anim(a0)
		rts	
; ===========================================================================

loc_ADA4:
		addq.b	#2,ost_routine2(a0)
		move.w	#-$400,ost_y_vel(a0)
		move.b	#id_ani_burro_digging,ost_anim(a0)
		rts	
; ===========================================================================

Burro_Jump:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)
		bmi.s	locret_ADF0
		move.b	#id_ani_burro_fall,ost_anim(a0)
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.s	locret_ADF0
		add.w	d1,ost_y_pos(a0)
		move.w	#0,ost_y_vel(a0)
		move.b	#id_ani_burro_walk2,ost_anim(a0)
		move.w	#255,ost_burro_turn_time(a0)
		subq.b	#2,ost_routine2(a0)
		bsr.w	Burro_ChkSonic2

locret_ADF0:
		rts	
; ===========================================================================

Burro_ChkSonic:
		move.w	#$60,d2
		bsr.w	Burro_ChkSonic2
		bcc.s	locret_AE20
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0
		bcc.s	locret_AE20
		cmpi.w	#-$80,d0
		bcs.s	locret_AE20
		tst.w	(v_debug_active).w
		bne.s	locret_AE20
		subq.b	#2,ost_routine2(a0)
		move.w	d1,ost_x_vel(a0)
		move.w	#-$400,ost_y_vel(a0)

locret_AE20:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Burro_ChkSonic2:
		move.w	#$80,d1
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	loc_AE40
		neg.w	d0
		neg.w	d1
		bclr	#status_xflip_bit,ost_status(a0)

loc_AE40:
		cmp.w	d2,d0
		rts	
; End of function Burro_ChkSonic2
