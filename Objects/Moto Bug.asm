; ---------------------------------------------------------------------------
; Object 40 - Moto Bug enemy (GHZ)

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3
;	MotoBug - animation 2 (smoke)
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

ost_moto_wait_time:	equ $30					; time delay before changing direction (2 bytes)
ost_moto_smoke_time:	equ $33					; time delay between smoke puffs
; ===========================================================================

Moto_Main:	; Routine 0
		move.l	#Map_Moto,ost_mappings(a0)
		move.w	#tile_Nem_Motobug,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		tst.b	ost_anim(a0)				; is object a smoke trail?
		bne.s	@smoke					; if yes, branch
		move.b	#$E,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.b	#id_col_20x16,ost_col_type(a0)
		bsr.w	ObjectFall				; apply gravity and update position
		jsr	(FindFloorObj).l
		tst.w	d1					; has motobug hit the floor?
		bpl.s	@notonfloor				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#0,ost_y_vel(a0)			; stop falling
		addq.b	#2,ost_routine(a0)			; goto Moto_Action next
		bchg	#status_xflip_bit,ost_status(a0)

	@notonfloor:
		rts	
; ===========================================================================

@smoke:
		addq.b	#4,ost_routine(a0)			; goto Moto_Animate next
		bra.w	Moto_Animate
; ===========================================================================

Moto_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Moto_ActIndex(pc,d0.w),d1
		jsr	Moto_ActIndex(pc,d1.w)
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite

		;jmp	(DespawnObject).l				; runs straight into DespawnObject

include_MotoBug_1:	macro

; ===========================================================================
Moto_ActIndex:	index *
		ptr Moto_Move
		ptr Moto_FindFloor
; ===========================================================================

Moto_Move:
		subq.w	#1,ost_moto_wait_time(a0)		; decrement wait timer
		bpl.s	@wait					; if time remains, branch
		addq.b	#2,ost_routine2(a0)			; goto Moto_FindFloor next
		move.w	#-$100,ost_x_vel(a0)			; move object to the left
		move.b	#id_ani_moto_walk,ost_anim(a0)
		bchg	#status_xflip_bit,ost_status(a0)
		bne.s	@wait
		neg.w	ost_x_vel(a0)				; change direction

	@wait:
		rts	
; ===========================================================================

Moto_FindFloor:
		bsr.w	SpeedToPos				; update position
		jsr	(FindFloorObj).l			; d1 = distance to floor
		cmpi.w	#-8,d1
		blt.s	@pause
		cmpi.w	#$C,d1
		bge.s	@pause					; branch if object is more than 11px above or 8px below floor

		add.w	d1,ost_y_pos(a0)			; align to floor
		subq.b	#1,ost_moto_smoke_time(a0)		; decrement time between smoke puffs
		bpl.s	@nosmoke				; branch if time remains
		move.b	#$F,ost_moto_smoke_time(a0)		; reset timer
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@nosmoke				; branch if not found
		move.b	#id_MotoBug,ost_id(a1)			; load exhaust smoke object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	#id_ani_moto_smoke,ost_anim(a1)

	@nosmoke:
		rts	

@pause:
		subq.b	#2,ost_routine2(a0)			; goto Moto_Move next
		move.w	#59,ost_moto_wait_time(a0)		; set pause time to 1 second
		move.w	#0,ost_x_vel(a0)			; stop the object moving
		move.b	#id_ani_moto_stand,ost_anim(a0)
		rts	
; ===========================================================================

Moto_Animate:	; Routine 4
		lea	(Ani_Moto).l,a1
		bsr.w	AnimateSprite				; if smoke animation, goto Moto_Delete next
		bra.w	DisplaySprite
; ===========================================================================

Moto_Delete:	; Routine 6
		bra.w	DeleteObject

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Moto:	index *
		ptr ani_moto_stand
		ptr ani_moto_walk
		ptr ani_moto_smoke

ani_moto_stand:	dc.b $F
		dc.b id_frame_moto_2
		dc.b afEnd
		even

ani_moto_walk:	dc.b 7
		dc.b id_frame_moto_0
		dc.b id_frame_moto_1
		dc.b id_frame_moto_0
		dc.b id_frame_moto_2
		dc.b afEnd
		even

ani_moto_smoke:	dc.b 1
		dc.b id_frame_moto_smoke1
		dc.b id_frame_moto_blank
		dc.b id_frame_moto_smoke1
		dc.b id_frame_moto_blank
		dc.b id_frame_moto_smoke2
		dc.b id_frame_moto_blank
		dc.b id_frame_moto_smoke2
		dc.b id_frame_moto_blank
		dc.b id_frame_moto_smoke2
		dc.b id_frame_moto_blank
		dc.b id_frame_moto_smoke3
		dc.b afRoutine
		even

		endm
