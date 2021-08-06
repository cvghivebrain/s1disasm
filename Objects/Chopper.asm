; ---------------------------------------------------------------------------
; Object 2B - Chopper enemy (GHZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Chop_Index(pc,d0.w),d1
		jsr	Chop_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Chop_Index:	index *,,2
		ptr Chop_Main
		ptr Chop_ChgSpeed

chop_origY:	equ $30
; ===========================================================================

Chop_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Chop,ost_mappings(a0)
		move.w	#tile_Nem_Chopper,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#9,ost_col_type(a0)
		move.b	#$10,ost_actwidth(a0)
		move.w	#-$700,ost_y_vel(a0) ; set vertical speed
		move.w	ost_y_pos(a0),chop_origY(a0) ; save original position

Chop_ChgSpeed:	; Routine 2
		lea	(Ani_Chop).l,a1
		bsr.w	AnimateSprite
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)	; reduce speed
		move.w	chop_origY(a0),d0
		cmp.w	ost_y_pos(a0),d0	; has Chopper returned to its original position?
		bcc.s	@chganimation	; if not, branch
		move.w	d0,ost_y_pos(a0)
		move.w	#-$700,ost_y_vel(a0) ; set vertical speed

	@chganimation:
		move.b	#1,ost_anim(a0)	; use fast animation
		subi.w	#$C0,d0
		cmp.w	ost_y_pos(a0),d0
		bcc.s	@nochg
		move.b	#0,ost_anim(a0)	; use slow animation
		tst.w	ost_y_vel(a0)	; is Chopper at	its highest point?
		bmi.s	@nochg		; if not, branch
		move.b	#2,ost_anim(a0)	; use stationary animation

	@nochg:
		rts	
