; ---------------------------------------------------------------------------
; Subroutine to detect collision with a wall

; input:
;	d7 = current OST id (these are numbered backwards $7E to 0)

; output:
;	d0 = collision flag: 0 = none; 1 = yes
; ---------------------------------------------------------------------------

Yad_ChkWall:
		move.w	(v_frame_counter).w,d0			; get word that increments every frame
		add.w	d7,d0					; add OST id (so that multiple yadrins don't do wall check on the same frame)
		andi.w	#3,d0					; read only bits 0-1
		bne.s	@no_collision				; branch if either are set
		moveq	#0,d3
		move.b	ost_actwidth(a0),d3
		tst.w	ost_x_vel(a0)				; is yadrin moving to the left?
		bmi.s	@moving_left				; if yes, branch
		bsr.w	FindWallRightObj
		tst.w	d1					; has yadrin hit wall to the right?
		bpl.s	@no_collision				; if not, branch

@collision:
		moveq	#1,d0					; set collision flag
		rts	
; ===========================================================================

@moving_left:
		not.w	d3					; flip width
		bsr.w	FindWallLeftObj
		tst.w	d1					; has yadrin hit wall to the left?
		bmi.s	@collision				; if yes, branch

@no_collision:
		moveq	#0,d0
		rts	
; End of function Yad_ChkWall

; ---------------------------------------------------------------------------
; Object 50 - Yadrin enemy (SYZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3
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

ost_yadrin_wait_time:	equ $30					; time to wait before changing direction (2 bytes)
; ===========================================================================

Yad_Main:	; Routine 0
		move.l	#Map_Yad,ost_mappings(a0)
		move.w	#tile_Nem_Yadrin+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		move.b	#$11,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.b	#id_col_20x16+id_col_custom,ost_col_type(a0)
		bsr.w	ObjectFall				; apply gravity & update position
		bsr.w	FindFloorObj
		tst.w	d1					; has yadrin hit the floor?
		bpl.s	@keep_falling				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#0,ost_y_vel(a0)			; stop falling
		addq.b	#2,ost_routine(a0)			; goto Yad_Action next
		bchg	#status_xflip_bit,ost_status(a0)

	@keep_falling:
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
Yad_Index2:	index *,,2
		ptr Yad_Move
		ptr Yad_FixToFloor
; ===========================================================================

Yad_Move:
		subq.w	#1,ost_yadrin_wait_time(a0)		; decrement timer
		bpl.s	@wait					; if time remains, branch
		addq.b	#2,ost_routine2(a0)			; goto Yad_FixToFloor next
		move.w	#-$100,ost_x_vel(a0)			; move object left
		move.b	#id_ani_yadrin_walk,ost_anim(a0)	; use walking animation
		bchg	#status_xflip_bit,ost_status(a0)
		bne.s	@no_xflip
		neg.w	ost_x_vel(a0)				; move right if xflipped

	@wait:
	@no_xflip:
		rts	
; ===========================================================================

Yad_FixToFloor:
		bsr.w	SpeedToPos				; update position
		bsr.w	FindFloorObj
		cmpi.w	#-8,d1
		blt.s	Yad_Pause				; branch if > 8px below floor
		cmpi.w	#$C,d1
		bge.s	Yad_Pause				; branch if > 11px above floor (also detects a ledge)
		add.w	d1,ost_y_pos(a0)			; align to floor
		bsr.w	Yad_ChkWall				; detect wall
		bne.s	Yad_Pause				; branch if wall is hit
		rts	
; ===========================================================================

Yad_Pause:
		subq.b	#2,ost_routine2(a0)			; goto Yad_Move next
		move.w	#59,ost_yadrin_wait_time(a0)		; set pause time to 1 second
		move.w	#0,ost_x_vel(a0)			; stop moving
		move.b	#id_ani_yadrin_stand,ost_anim(a0)	; use standing animation
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Yad:	index *
		ptr ani_yadrin_stand
		ptr ani_yadrin_walk

ani_yadrin_stand:
		dc.b 7
		dc.b id_frame_yadrin_walk0
		dc.b afEnd
		even

ani_yadrin_walk:
		dc.b 7
		dc.b id_frame_yadrin_walk0
		dc.b id_frame_yadrin_walk3
		dc.b id_frame_yadrin_walk1
		dc.b id_frame_yadrin_walk4
		dc.b id_frame_yadrin_walk0
		dc.b id_frame_yadrin_walk3
		dc.b id_frame_yadrin_walk2
		dc.b id_frame_yadrin_walk5
		dc.b afEnd
		even
