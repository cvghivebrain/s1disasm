; ---------------------------------------------------------------------------
; Object 13 - fireball maker (MZ, SLZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes x0/x1/x2/x5/x7
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes x6/x7
; ---------------------------------------------------------------------------

FireMaker:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FireM_Index(pc,d0.w),d1
		jsr	FireM_Index(pc,d1.w)
		bra.w	FBall_ChkDel
; ===========================================================================
FireM_Index:	index *,,2
		ptr FireM_Main
		ptr FireM_MakeFire

; Delay between launching fireballs
FireM_Rates:	dc.b 30						; 0x - 0.5 seconds (unused)
		dc.b 60						; 1x - 1 seconds (SLZ2)
		dc.b 90						; 2x - 1.5 seconds (MZ3)
		dc.b 120					; 3x - 2 seconds (MZ1/2/3, SLZ1/3)
		dc.b 150					; 4x - 2.5 seconds (MZ1/2/3)
		dc.b 180					; 5x - 3 seconds (MZ3)
; ===========================================================================

FireM_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto FireM_MakeFire next
		move.b	ost_subtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0					; get high nybble of subtype (rate)
		move.b	FireM_Rates(pc,d0.w),ost_anim_time_low(a0)
		move.b	ost_anim_time_low(a0),ost_anim_time(a0)	; set time delay for fireballs
		andi.b	#$F,ost_subtype(a0)			; get low nybble of subtype (speed/direction)

FireM_MakeFire:	; Routine 2
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bne.s	@wait					; if time remains, branch
		move.b	ost_anim_time_low(a0),ost_anim_time(a0)	; reset time delay
		bsr.w	CheckOffScreen				; is object on-screen?
		bne.s	@wait					; if not, branch
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@wait					; branch if not found

		move.b	#id_FireBall,ost_id(a1)			; load fireball object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)		; subtype = speed/direction

	@wait:
		rts	
