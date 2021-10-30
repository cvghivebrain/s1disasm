; ---------------------------------------------------------------------------
; Object 40 - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

MotoBug:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Moto_Index(pc,d0.w),d1
		jmp	Moto_Index(pc,d1.w)
; ===========================================================================
Moto_Index:	index *,,2
		ptr Moto_Main
		ptr Moto_Action
		ptr Moto_Animate
		ptr Moto_Delete

ost_moto_wait_time:	equ $30	; time delay before changing direction (2 bytes)
ost_moto_smoke_time:	equ $33	; time delay between smoke puffs
; ===========================================================================

Moto_Main:	; Routine 0
		move.l	#Map_Moto,ost_mappings(a0)
		move.w	#tile_Nem_Motobug,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		tst.b	ost_anim(a0)	; is object a smoke trail?
		bne.s	@smoke		; if yes, branch
		move.b	#$E,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.b	#$C,ost_col_type(a0)
		bsr.w	ObjectFall
		jsr	(FindFloorObj).l
		tst.w	d1
		bpl.s	@notonfloor
		add.w	d1,ost_y_pos(a0) ; match object's position with the floor
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0) ; goto Moto_Action next
		bchg	#status_xflip_bit,ost_status(a0)

	@notonfloor:
		rts	
; ===========================================================================

@smoke:
		addq.b	#4,ost_routine(a0) ; goto Moto_Animate next
		bra.w	Moto_Animate
; ===========================================================================

Moto_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Moto_ActIndex(pc,d0.w),d1
		jsr	Moto_ActIndex(pc,d1.w)
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite

; ---------------------------------------------------------------------------
; Subroutine to remember whether an object is destroyed/collected
; ---------------------------------------------------------------------------

RememberState:
		out_of_range	@offscreen
		bra.w	DisplaySprite

	@offscreen:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		bra.w	DeleteObject

; ===========================================================================
Moto_ActIndex:	index *
		ptr @move
		ptr @findfloor
; ===========================================================================

@move:
		subq.w	#1,ost_moto_wait_time(a0) ; subtract 1 from pause time
		bpl.s	@wait		; if time remains, branch
		addq.b	#2,ost_routine2(a0)
		move.w	#-$100,ost_x_vel(a0) ; move object to the left
		move.b	#id_ani_moto_walk,ost_anim(a0)
		bchg	#status_xflip_bit,ost_status(a0)
		bne.s	@wait
		neg.w	ost_x_vel(a0)	; change direction

	@wait:
		rts	
; ===========================================================================

@findfloor:
		bsr.w	SpeedToPos
		jsr	(FindFloorObj).l
		cmpi.w	#-8,d1
		blt.s	@pause
		cmpi.w	#$C,d1
		bge.s	@pause
		add.w	d1,ost_y_pos(a0) ; match object's position with the floor
		subq.b	#1,ost_moto_smoke_time(a0)
		bpl.s	@nosmoke
		move.b	#$F,ost_moto_smoke_time(a0)
		bsr.w	FindFreeObj
		bne.s	@nosmoke
		move.b	#id_MotoBug,0(a1) ; load exhaust smoke object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	#id_ani_moto_smoke,ost_anim(a1)

	@nosmoke:
		rts	

@pause:
		subq.b	#2,ost_routine2(a0)
		move.w	#59,ost_moto_wait_time(a0) ; set pause time to 1 second
		move.w	#0,ost_x_vel(a0) ; stop the object moving
		move.b	#id_ani_moto_stand,ost_anim(a0)
		rts	
; ===========================================================================

Moto_Animate:	; Routine 4
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

Moto_Delete:	; Routine 6
		bra.w	DeleteObject
