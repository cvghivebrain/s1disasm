; ---------------------------------------------------------------------------
; Object 41 - springs
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Spring_Index(pc,d0.w),d1
		jsr	Spring_Index(pc,d1.w)
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
; ===========================================================================
Spring_Index:	index *,,2
		ptr Spring_Main		; 0
		ptr Spring_Up		; 2
		ptr Spring_AniUp	; 4
		ptr Spring_ResetUp	; 6
		ptr Spring_LR		; 8
		ptr Spring_AniLR	; $A
		ptr Spring_ResetLR	; $C
		ptr Spring_Dwn		; $E
		ptr Spring_AniDwn	; $10
		ptr Spring_ResetDwn	; $12

spring_pow:	equ $30			; power of current spring

Spring_Powers:	dc.w -$1000		; power	of red spring
		dc.w -$A00		; power	of yellow spring
; ===========================================================================

Spring_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Spring,ost_mappings(a0)
		move.w	#tile_Nem_HSpring,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		move.b	ost_subtype(a0),d0
		btst	#4,d0		; does the spring face left/right?
		beq.s	Spring_NotLR	; if not, branch

		move.b	#id_Spring_LR,ost_routine(a0) ; use "Spring_LR" routine
		move.b	#1,ost_anim(a0)
		move.b	#3,ost_frame(a0)
		move.w	#tile_Nem_VSpring,ost_tile(a0)
		move.b	#8,ost_actwidth(a0)

	Spring_NotLR:
		btst	#5,d0		; does the spring face downwards?
		beq.s	Spring_NotDwn	; if not, branch

		move.b	#id_Spring_Dwn,ost_routine(a0) ; use "Spring_Dwn" routine
		bset	#1,ost_status(a0)

	Spring_NotDwn:
		btst	#1,d0
		beq.s	loc_DB72
		bset	#5,ost_tile(a0)

loc_DB72:
		andi.w	#$F,d0
		move.w	Spring_Powers(pc,d0.w),spring_pow(a0)
		rts	
; ===========================================================================

Spring_Up:	; Routine 2
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		tst.b	ost_solid(a0)	; is Sonic on top of the spring?
		bne.s	Spring_BounceUp	; if yes, branch
		rts	
; ===========================================================================

Spring_BounceUp:
		addq.b	#2,ost_routine(a0)
		addq.w	#8,ost_y_pos(a1)
		move.w	spring_pow(a0),ost_y_vel(a1) ; move Sonic upwards
		bset	#1,ost_status(a1)
		bclr	#3,ost_status(a1)
		move.b	#id_Spring,ost_anim(a1) ; use "bouncing" animation
		move.b	#2,ost_routine(a1)
		bclr	#3,ost_status(a0)
		clr.b	ost_solid(a0)
		sfx	sfx_Spring,0,0,0	; play spring sound

Spring_AniUp:	; Routine 4
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetUp:	; Routine 6
		move.b	#1,ost_anim_next(a0) ; reset animation
		subq.b	#4,ost_routine(a0) ; goto "Spring_Up" routine
		rts	
; ===========================================================================

Spring_LR:	; Routine 8
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		cmpi.b	#2,ost_routine(a0)
		bne.s	loc_DC0C
		move.b	#8,ost_routine(a0)

loc_DC0C:
		btst	#5,ost_status(a0)
		bne.s	Spring_BounceLR
		rts	
; ===========================================================================

Spring_BounceLR:
		addq.b	#2,ost_routine(a0)
		move.w	spring_pow(a0),ost_x_vel(a1) ; move Sonic to the left
		addq.w	#8,ost_x_pos(a1)
		btst	#0,ost_status(a0)	; is object flipped?
		bne.s	Spring_Flipped	; if yes, branch
		subi.w	#$10,ost_x_pos(a1)
		neg.w	ost_x_vel(a1)	; move Sonic to	the right

	Spring_Flipped:
		move.w	#$F,$3E(a1)
		move.w	ost_x_vel(a1),ost_inertia(a1)
		bchg	#0,ost_status(a1)
		btst	#2,ost_status(a1)
		bne.s	loc_DC56
		move.b	#id_Walk,ost_anim(a1)	; use walking animation

loc_DC56:
		bclr	#5,ost_status(a0)
		bclr	#5,ost_status(a1)
		sfx	sfx_Spring,0,0,0	; play spring sound

Spring_AniLR:	; Routine $A
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetLR:	; Routine $C
		move.b	#2,ost_anim_next(a0) ; reset animation
		subq.b	#4,ost_routine(a0) ; goto "Spring_LR" routine
		rts	
; ===========================================================================

Spring_Dwn:	; Routine $E
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		cmpi.b	#id_Spring_Up,ost_routine(a0)
		bne.s	loc_DCA4
		move.b	#id_Spring_Dwn,ost_routine(a0)

loc_DCA4:
		tst.b	ost_solid(a0)
		bne.s	locret_DCAE
		tst.w	d4
		bmi.s	Spring_BounceDwn

locret_DCAE:
		rts	
; ===========================================================================

Spring_BounceDwn:
		addq.b	#2,ost_routine(a0)
		subq.w	#8,ost_y_pos(a1)
		move.w	spring_pow(a0),ost_y_vel(a1)
		neg.w	ost_y_vel(a1)	; move Sonic downwards
		bset	#1,ost_status(a1)
		bclr	#3,ost_status(a1)
		move.b	#2,ost_routine(a1)
		bclr	#3,ost_status(a0)
		clr.b	ost_solid(a0)
		sfx	sfx_Spring,0,0,0	; play spring sound

Spring_AniDwn:	; Routine $10
		lea	(Ani_Spring).l,a1
		bra.w	AnimateSprite
; ===========================================================================

Spring_ResetDwn:
		; Routine $12
		move.b	#1,ost_anim_next(a0) ; reset animation
		subq.b	#4,ost_routine(a0) ; goto "Spring_Dwn" routine
		rts	
