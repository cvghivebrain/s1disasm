; ---------------------------------------------------------------------------
; Object 13 - lava ball	maker (MZ, SLZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LavaM_Index(pc,d0.w),d1
		jsr	LavaM_Index(pc,d1.w)
		bra.w	LBall_ChkDel
; ===========================================================================
LavaM_Index:	index *,,2
		ptr LavaM_Main
		ptr LavaM_MakeLava
; ---------------------------------------------------------------------------
;
; Lava ball production rates
;
LavaM_Rates:	dc.b 30, 60, 90, 120, 150, 180
; ===========================================================================

LavaM_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	ost_subtype(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0		; get high nybble of subtype (rate)
		move.b	LavaM_Rates(pc,d0.w),ost_anim_delay(a0)
		move.b	ost_anim_delay(a0),ost_anim_time(a0) ; set time delay for lava balls
		andi.b	#$F,ost_subtype(a0) ; get low nybble of subtype (speed/direction)

LavaM_MakeLava:	; Routine 2
		subq.b	#1,ost_anim_time(a0) ; subtract 1 from time delay
		bne.s	LavaM_Wait	; if time still	remains, branch
		move.b	ost_anim_delay(a0),ost_anim_time(a0) ; reset time delay
		bsr.w	ChkObjectVisible
		bne.s	LavaM_Wait
		bsr.w	FindFreeObj
		bne.s	LavaM_Wait
		move.b	#id_LavaBall,0(a1) ; load lava ball object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1) ; subtype = speed/direction

	LavaM_Wait:
		rts	
