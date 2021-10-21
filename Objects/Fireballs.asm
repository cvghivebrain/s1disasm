; ---------------------------------------------------------------------------
; Object 14 - lava balls (MZ, SLZ)
; ---------------------------------------------------------------------------

LavaBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LBall_Index(pc,d0.w),d1
		jsr	LBall_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
LBall_Index:	index *,,2
		ptr LBall_Main
		ptr LBall_Action
		ptr LBall_Delete

LBall_Speeds:	dc.w -$400, -$500, -$600, -$700, -$200
		dc.w $200, -$200, $200,	0

ost_fireball_y_start:	equ $30	; original y position (2 bytes)
; ===========================================================================

LBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#8,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		cmpi.b	#3,(v_zone).w	; check if level is SLZ
		bne.s	@notSLZ
		move.w	#tile_Nem_Fireball_SLZ,ost_tile(a0) ; SLZ specific code

	@notSLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$8B,ost_col_type(a0)
		move.w	ost_y_pos(a0),ost_fireball_y_start(a0)
		tst.b	$29(a0)
		beq.s	@speed
		addq.b	#2,ost_priority(a0)

	@speed:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	LBall_Speeds(pc,d0.w),ost_y_vel(a0) ; load object speed (vertical)
		move.b	#8,ost_actwidth(a0)
		cmpi.b	#6,ost_subtype(a0) ; is object type 0-5?
		bcs.s	@sound		; if yes, branch

		move.b	#$10,ost_actwidth(a0)
		move.b	#id_ani_fire_horizontal,ost_anim(a0) ; use horizontal animation
		move.w	ost_y_vel(a0),ost_x_vel(a0) ; set horizontal speed
		move.w	#0,ost_y_vel(a0) ; delete vertical speed

	@sound:
		sfx	sfx_LavaBall,0,0,0 ; play lava ball sound

LBall_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	LBall_TypeIndex(pc,d0.w),d1
		jsr	LBall_TypeIndex(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

LBall_ChkDel:
		out_of_range	DeleteObject
		rts	
; ===========================================================================
LBall_TypeIndex:index *
		ptr LBall_Type00
		ptr LBall_Type00
		ptr LBall_Type00
		ptr LBall_Type00
		ptr LBall_Type04
		ptr LBall_Type05
		ptr LBall_Type06
		ptr LBall_Type07
		ptr LBall_Type08
; ===========================================================================
; lavaball types 00-03 fly up and fall back down

LBall_Type00:
		addi.w	#$18,ost_y_vel(a0) ; increase object's downward speed
		move.w	ost_fireball_y_start(a0),d0
		cmp.w	ost_y_pos(a0),d0 ; has object fallen back to its original position?
		bcc.s	loc_E41E	; if not, branch
		addq.b	#2,ost_routine(a0) ; goto "LBall_Delete" routine

loc_E41E:
		bclr	#status_yflip_bit,ost_status(a0)
		tst.w	ost_y_vel(a0)
		bpl.s	locret_E430
		bset	#status_yflip_bit,ost_status(a0)

locret_E430:
		rts	
; ===========================================================================
; lavaball type	04 flies up until it hits the ceiling

LBall_Type04:
		bset	#status_yflip_bit,ost_status(a0)
		bsr.w	ObjHitCeiling
		tst.w	d1
		bpl.s	locret_E452
		move.b	#8,ost_subtype(a0)
		move.b	#id_ani_fire_vertcollide,ost_anim(a0)
		move.w	#0,ost_y_vel(a0) ; stop the object when it touches the ceiling

locret_E452:
		rts	
; ===========================================================================
; lavaball type	05 falls down until it hits the	floor

LBall_Type05:
		bclr	#status_yflip_bit,ost_status(a0)
		bsr.w	FindFloorObj
		tst.w	d1
		bpl.s	locret_E474
		move.b	#8,ost_subtype(a0)
		move.b	#id_ani_fire_vertcollide,ost_anim(a0)
		move.w	#0,ost_y_vel(a0) ; stop the object when it touches the floor

locret_E474:
		rts	
; ===========================================================================
; lavaball types 06-07 move sideways until they hit a wall

LBall_Type06:
		bset	#status_xflip_bit,ost_status(a0)
		moveq	#-8,d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bpl.s	locret_E498
		move.b	#8,ost_subtype(a0)
		move.b	#id_ani_fire_horicollide,ost_anim(a0)
		move.w	#0,ost_x_vel(a0) ; stop object when it touches a wall

locret_E498:
		rts	
; ===========================================================================

LBall_Type07:
		bclr	#status_xflip_bit,ost_status(a0)
		moveq	#8,d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bpl.s	locret_E4BC
		move.b	#8,ost_subtype(a0)
		move.b	#id_ani_fire_horicollide,ost_anim(a0)
		move.w	#0,ost_x_vel(a0) ; stop object when it touches a wall

locret_E4BC:
		rts	
; ===========================================================================

LBall_Type08:
		rts	
; ===========================================================================

LBall_Delete:
		bra.w	DeleteObject
