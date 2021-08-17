; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Yad_ChkWall:
		move.w	(v_framecount).w,d0
		add.w	d7,d0
		andi.w	#3,d0
		bne.s	loc_F836
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		tst.w	ost_x_vel(a0)
		bmi.s	loc_F82C
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	loc_F836

loc_F828:
		moveq	#1,d0
		rts	
; ===========================================================================

loc_F82C:
		not.w	d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bmi.s	loc_F828

loc_F836:
		moveq	#0,d0
		rts	
; End of function Yad_ChkWall

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)
; ---------------------------------------------------------------------------

Yadrin:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Yad_Index(pc,d0.w),d1
		jmp	Yad_Index(pc,d1.w)
; ===========================================================================
Yad_Index:	index *,,2
		ptr Yad_Main
		ptr Yad_Action

yad_timedelay:	equ $30
; ===========================================================================

Yad_Main:	; Routine 0
		move.l	#Map_Yad,ost_mappings(a0)
		move.w	#tile_Nem_Yadrin+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		move.b	#$11,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.b	#$CC,ost_col_type(a0)
		bsr.w	ObjectFall
		bsr.w	ObjFloorDist
		tst.w	d1
		bpl.s	locret_F89E
		add.w	d1,ost_y_pos(a0)	; match	object's position with the floor
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)
		bchg	#0,ost_status(a0)

	locret_F89E:
		rts	
; ===========================================================================

Yad_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Yad_Index2(pc,d0.w),d1
		jsr	Yad_Index2(pc,d1.w)
		lea	(Ani_Yad).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
Yad_Index2:	index *
		ptr Yad_Move
		ptr Yad_FixToFloor
; ===========================================================================

Yad_Move:
		subq.w	#1,yad_timedelay(a0) ; subtract 1 from pause time
		bpl.s	locret_F8E2	; if time remains, branch
		addq.b	#2,ost_routine2(a0)
		move.w	#-$100,ost_x_vel(a0) ; move object
		move.b	#1,ost_anim(a0)
		bchg	#0,ost_status(a0)
		bne.s	locret_F8E2
		neg.w	ost_x_vel(a0)	; change direction

	locret_F8E2:
		rts	
; ===========================================================================

Yad_FixToFloor:
		bsr.w	SpeedToPos
		bsr.w	ObjFloorDist
		cmpi.w	#-8,d1
		blt.s	Yad_Pause
		cmpi.w	#$C,d1
		bge.s	Yad_Pause
		add.w	d1,ost_y_pos(a0)	; match	object's position to the floor
		bsr.w	Yad_ChkWall
		bne.s	Yad_Pause
		rts	
; ===========================================================================

Yad_Pause:
		subq.b	#2,ost_routine2(a0)
		move.w	#59,yad_timedelay(a0) ; set pause time to 1 second
		move.w	#0,ost_x_vel(a0)
		move.b	#0,ost_anim(a0)
		rts	