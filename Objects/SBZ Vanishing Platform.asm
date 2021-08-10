; ---------------------------------------------------------------------------
; Object 6C - vanishing	platforms (SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	VanP_Index(pc,d0.w),d1
		jmp	VanP_Index(pc,d1.w)
; ===========================================================================
VanP_Index:	index *,,2
		ptr VanP_Main
		ptr VanP_Vanish
		ptr VanP_Appear
		ptr loc_16068

vanp_timer:	equ $30		; counter for time until event
vanp_timelen:	equ $32		; time between events (general)
; ===========================================================================

VanP_Main:	; Routine 0
		addq.b	#6,ost_routine(a0)
		move.l	#Map_VanP,ost_mappings(a0)
		move.w	#tile_Nem_SbzBlock+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#$F,d0		; read only the	2nd digit
		addq.w	#1,d0		; add 1
		lsl.w	#7,d0		; multiply by $80
		move.w	d0,d1
		subq.w	#1,d0
		move.w	d0,vanp_timer(a0)
		move.w	d0,vanp_timelen(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#$F0,d0		; read only the	1st digit
		addi.w	#$80,d1
		mulu.w	d1,d0
		lsr.l	#8,d0
		move.w	d0,$36(a0)
		subq.w	#1,d1
		move.w	d1,$38(a0)

loc_16068:	; Routine 6
		move.w	(v_framecount).w,d0
		sub.w	$36(a0),d0
		and.w	$38(a0),d0
		bne.s	@animate
		subq.b	#4,ost_routine(a0) ; goto VanP_Vanish next
		bra.s	VanP_Vanish
; ===========================================================================

@animate:
		lea	(Ani_Van).l,a1
		jsr	(AnimateSprite).l
		bra.w	RememberState
; ===========================================================================

VanP_Vanish:	; Routine 2
VanP_Appear:	; Routine 4
		subq.w	#1,vanp_timer(a0)
		bpl.s	@wait
		move.w	#127,vanp_timer(a0)
		tst.b	ost_anim(a0)	; is platform vanishing?
		beq.s	@isvanishing	; if yes, branch
		move.w	vanp_timelen(a0),vanp_timer(a0)

	@isvanishing:
		bchg	#0,ost_anim(a0)

	@wait:
		lea	(Ani_Van).l,a1
		jsr	(AnimateSprite).l
		btst	#1,ost_frame(a0)	; has platform vanished?
		bne.s	@notsolid	; if yes, branch
		cmpi.b	#id_VanP_Vanish,ost_routine(a0)
		bne.s	@loc_160D6
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(PlatformObject).l
		bra.w	RememberState
; ===========================================================================

@loc_160D6:
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),d2
		jsr	(MvSonicOnPtfm2).l
		bra.w	RememberState
; ===========================================================================

@notsolid:
		btst	#3,ost_status(a0)
		beq.s	@display
		lea	(v_player).w,a1
		bclr	#3,ost_status(a1)
		bclr	#3,ost_status(a0)
		move.b	#id_VanP_Vanish,ost_routine(a0)
		clr.b	ost_solid(a0)

	@display:
		bra.w	RememberState
