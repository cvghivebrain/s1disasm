; ---------------------------------------------------------------------------
; Object 2C - Jaws enemy (LZ)
; ---------------------------------------------------------------------------

Jaws:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Jaws_Index(pc,d0.w),d1
		jmp	Jaws_Index(pc,d1.w)
; ===========================================================================
Jaws_Index:	index *,,2
		ptr Jaws_Main
		ptr Jaws_Turn

ost_jaws_turn_time:	equ $30	; time until jaws turns (2 bytes)
ost_jaws_turn_master:	equ $32	; time between turns, copied to ost_jaws_turn_time every turn (2 bytes)
; ===========================================================================

Jaws_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Jaws,ost_mappings(a0)
		move.w	#tile_Nem_Jaws+tile_pal2,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$A,ost_col_type(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; load object subtype number
		lsl.w	#6,d0		; multiply d0 by 64
		subq.w	#1,d0
		move.w	d0,ost_jaws_turn_time(a0) ; set turn delay time
		move.w	d0,ost_jaws_turn_master(a0)
		move.w	#-$40,ost_x_vel(a0) ; move Jaws to the left
		btst	#status_xflip_bit,ost_status(a0) ; is Jaws facing left?
		beq.s	Jaws_Turn	; if yes, branch
		neg.w	ost_x_vel(a0)	; move Jaws to the right

Jaws_Turn:	; Routine 2
		subq.w	#1,ost_jaws_turn_time(a0) ; subtract 1 from turn delay time
		bpl.s	@animate	; if time remains, branch
		move.w	ost_jaws_turn_master(a0),ost_jaws_turn_time(a0) ; reset turn delay time
		neg.w	ost_x_vel(a0)	; change speed direction
		bchg	#status_xflip_bit,ost_status(a0) ; change Jaws facing direction
		move.b	#1,ost_anim_restart(a0) ; reset animation

	@animate:
		lea	(Ani_Jaws).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		bra.w	RememberState
