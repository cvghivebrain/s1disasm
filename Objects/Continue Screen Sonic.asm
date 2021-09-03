; ---------------------------------------------------------------------------
; Object 81 - Sonic on the continue screen
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	CSon_Index(pc,d0.w),d1
		jsr	CSon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
CSon_Index:	index *,,2
		ptr CSon_Main
		ptr CSon_ChkLand
		ptr CSon_Animate
		ptr CSon_Run
; ===========================================================================

CSon_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$A0,ost_x_pos(a0)
		move.w	#$C0,ost_y_pos(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#$780,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_Float3,ost_anim(a0) ; use "floating" animation
		move.w	#$400,ost_y_vel(a0) ; make Sonic fall from above

CSon_ChkLand:	; Routine 2
		cmpi.w	#$1A0,ost_y_pos(a0) ; has Sonic landed yet?
		bne.s	CSon_ShowFall	; if not, branch

		addq.b	#2,ost_routine(a0)
		clr.w	ost_y_vel(a0)	; stop Sonic falling
		move.l	#Map_ContScr,ost_mappings(a0)
		move.w	#$500+tile_hi,ost_tile(a0)
		move.b	#id_Walk,ost_anim(a0)
		bra.s	CSon_Animate

CSon_ShowFall:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
; ===========================================================================

CSon_Animate:	; Routine 4
		tst.b	(v_jpadpress1).w ; is Start button pressed?
		bmi.s	CSon_GetUp	; if yes, branch
		lea	(AniScript_CSon).l,a1
		jmp	(AnimateSprite).l

CSon_GetUp:
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#$780,ost_tile(a0)
		move.b	#id_Float4,ost_anim(a0) ; use "getting up" animation
		clr.w	ost_inertia(a0)
		subq.w	#8,ost_y_pos(a0)
		sfx	bgm_Fade,0,1,1 ; fade out music

CSon_Run:	; Routine 6
		cmpi.w	#$800,ost_inertia(a0) ; check Sonic's inertia
		bne.s	CSon_AddInertia	; if too low, branch
		move.w	#$1000,ost_x_vel(a0) ; move Sonic to the right
		bra.s	CSon_ShowRun

CSon_AddInertia:
		addi.w	#$20,ost_inertia(a0) ; increase inertia

CSon_ShowRun:
		jsr	(SpeedToPos).l
		jsr	(Sonic_Animate).l
		jmp	(Sonic_LoadGfx).l
