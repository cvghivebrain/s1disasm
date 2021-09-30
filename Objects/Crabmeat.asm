; ---------------------------------------------------------------------------
; Object 1F - Crabmeat enemy (GHZ, SYZ)
; ---------------------------------------------------------------------------

Crabmeat:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Crab_Index(pc,d0.w),d1
		jmp	Crab_Index(pc,d1.w)
; ===========================================================================
Crab_Index:	index *,,2
		ptr Crab_Main
		ptr Crab_Action
		ptr Crab_Delete
		ptr Crab_BallMain
		ptr Crab_BallMove

ost_crab_wait_time:	equ $30	; time until crabmeat fires (2 bytes)
ost_crab_mode:		equ $32	; current action - 0/1 = not firing; 2/3 = firing
; ===========================================================================

Crab_Main:	; Routine 0
		move.b	#$10,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Crab,ost_mappings(a0)
		move.w	#tile_Nem_Crabmeat,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#6,ost_col_type(a0)
		move.b	#$15,ost_actwidth(a0)
		bsr.w	ObjectFall
		jsr	(FindFloorObj).l ; find floor
		tst.w	d1
		bpl.s	@floornotfound
		add.w	d1,ost_y_pos(a0)
		move.b	d3,ost_angle(a0)
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)

	@floornotfound:
		rts	
; ===========================================================================

Crab_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr @waittofire
		ptr @walkonfloor
; ===========================================================================

@waittofire:
		subq.w	#1,ost_crab_wait_time(a0) ; subtract 1 from time delay
		bpl.s	@dontmove
		tst.b	ost_render(a0)
		bpl.s	@movecrab
		bchg	#1,ost_crab_mode(a0)
		bne.s	@fire

	@movecrab:
		addq.b	#2,ost_routine2(a0)
		move.w	#127,ost_crab_wait_time(a0) ; set time delay to approx 2 seconds
		move.w	#$80,ost_x_vel(a0) ; move Crabmeat to the right
		bsr.w	Crab_SetAni
		addq.b	#3,d0		; use walking animation
		move.b	d0,ost_anim(a0)
		bchg	#status_xflip_bit,ost_status(a0)
		bne.s	@noflip
		neg.w	ost_x_vel(a0)	; change direction

	@dontmove:
	@noflip:
		rts	
; ===========================================================================

@fire:
		move.w	#59,ost_crab_wait_time(a0)
		move.b	#id_ani_crab_firing,ost_anim(a0) ; use firing animation
		bsr.w	FindFreeObj
		bne.s	@failleft
		move.b	#id_Crabmeat,0(a1) ; load left fireball
		move.b	#id_Crab_BallMain,ost_routine(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		subi.w	#$10,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	#-$100,ost_x_vel(a1)

	@failleft:
		bsr.w	FindFreeObj
		bne.s	@failright
		move.b	#id_Crabmeat,0(a1) ; load right fireball
		move.b	#id_Crab_BallMain,ost_routine(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		addi.w	#$10,ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	#$100,ost_x_vel(a1)

	@failright:
		rts	
; ===========================================================================

@walkonfloor:
		subq.w	#1,ost_crab_wait_time(a0)
		bmi.s	loc_966E
		bsr.w	SpeedToPos
		bchg	#0,ost_crab_mode(a0)
		bne.s	loc_9654
		move.w	ost_x_pos(a0),d3
		addi.w	#$10,d3
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_9640
		subi.w	#$20,d3

loc_9640:
		jsr	(FindFloorObj2).l
		cmpi.w	#-8,d1
		blt.s	loc_966E
		cmpi.w	#$C,d1
		bge.s	loc_966E
		rts	
; ===========================================================================

loc_9654:
		jsr	(FindFloorObj).l
		add.w	d1,ost_y_pos(a0)
		move.b	d3,ost_angle(a0)
		bsr.w	Crab_SetAni
		addq.b	#3,d0
		move.b	d0,ost_anim(a0)
		rts	
; ===========================================================================

loc_966E:
		subq.b	#2,ost_routine2(a0)
		move.w	#59,ost_crab_wait_time(a0)
		move.w	#0,ost_x_vel(a0)
		bsr.w	Crab_SetAni
		move.b	d0,ost_anim(a0)
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	set the	correct	animation for a	Crabmeat
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Crab_SetAni:
		moveq	#id_ani_crab_stand,d0
		move.b	ost_angle(a0),d3
		bmi.s	loc_96A4
		cmpi.b	#6,d3
		bcs.s	locret_96A2
		moveq	#id_ani_crab_standslope,d0
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	locret_96A2
		moveq	#id_ani_crab_standsloperev,d0

locret_96A2:
		rts	
; ===========================================================================

loc_96A4:
		cmpi.b	#-6,d3
		bhi.s	locret_96B6
		moveq	#id_ani_crab_standsloperev,d0
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	locret_96B6
		moveq	#id_ani_crab_standslope,d0

locret_96B6:
		rts	
; End of function Crab_SetAni

; ===========================================================================

Crab_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Sub-object - missile that the	Crabmeat throws
; ---------------------------------------------------------------------------

Crab_BallMain:	; Routine 6
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Crab,ost_mappings(a0)
		move.w	#tile_Nem_Crabmeat,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$87,ost_col_type(a0)
		move.b	#8,ost_actwidth(a0)
		move.w	#-$400,ost_y_vel(a0)
		move.b	#id_ani_crab_ball,ost_anim(a0)

Crab_BallMove:	; Routine 8
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
		bsr.w	DisplaySprite
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0 ; has object moved below the level boundary?
		bcs.s	@delete		; if yes, branch
		rts	

	@delete:
		bra.w	DeleteObject
