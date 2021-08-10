; ---------------------------------------------------------------------------
; Object 6E - electrocution orbs (SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Elec_Index(pc,d0.w),d1
		jmp	Elec_Index(pc,d1.w)
; ===========================================================================
Elec_Index:	index *,,2
		ptr Elec_Main
		ptr Elec_Shock

elec_freq:	equ $34		; frequency
; ===========================================================================

Elec_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Elec,ost_mappings(a0)
		move.w	#tile_Nem_Electric,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$28,ost_actwidth(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; read object type
		lsl.w	#4,d0		; multiply by $10
		subq.w	#1,d0
		move.w	d0,elec_freq(a0)

Elec_Shock:	; Routine 2
		move.w	(v_framecount).w,d0
		and.w	elec_freq(a0),d0 ; is it time to zap?
		bne.s	@animate	; if not, branch

		move.b	#1,ost_anim(a0)	; run "zap" animation
		tst.b	ost_render(a0)
		bpl.s	@animate
		sfx	sfx_Electric,0,0,0	; play electricity sound

	@animate:
		lea	(Ani_Elec).l,a1
		jsr	(AnimateSprite).l
		move.b	#0,ost_col_type(a0)
		cmpi.b	#4,ost_frame(a0)	; is 4th frame displayed?
		bne.s	@display	; if not, branch
		move.b	#$A4,ost_col_type(a0) ; if yes, make object hurt Sonic

	@display:
		bra.w	RememberState
