; ---------------------------------------------------------------------------
; Object 2E - contents of monitors
; ---------------------------------------------------------------------------

PowerUp:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Pow_Index(pc,d0.w),d1
		jsr	Pow_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Pow_Index:	index *,,2
		ptr Pow_Main
		ptr Pow_Move
		ptr Pow_Delete
; ===========================================================================

Pow_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#tile_Nem_Monitors,ost_tile(a0)
		move.b	#render_rel+render_rawmap,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.w	#-$300,ost_y_vel(a0)
		moveq	#0,d0
		move.b	ost_anim(a0),d0	; get subtype
		addq.b	#2,d0
		move.b	d0,ost_frame(a0) ; use correct frame
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,ost_mappings(a0)

Pow_Move:	; Routine 2
		tst.w	ost_y_vel(a0)	; is object moving?
		bpl.w	Pow_Checks	; if not, branch
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0) ; reduce object speed
		rts	
; ===========================================================================

Pow_Checks:
		addq.b	#2,ost_routine(a0)
		move.w	#29,ost_anim_time(a0) ; display icon for half a second

Pow_ChkEggman:
		move.b	ost_anim(a0),d0
		cmpi.b	#id_ani_monitor_eggman,d0 ; does monitor contain Eggman?
		bne.s	Pow_ChkSonic
		rts			; Eggman monitor does nothing
; ===========================================================================

Pow_ChkSonic:
		cmpi.b	#2,d0		; does monitor contain Sonic?
		bne.s	Pow_ChkShoes

	ExtraLife:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_hud_lives_update).w ; update the lives counter
		music	bgm_ExtraLife,1,0,0 ; play extra life music
; ===========================================================================

Pow_ChkShoes:
		cmpi.b	#3,d0		; does monitor contain speed shoes?
		bne.s	Pow_ChkShield

		move.b	#1,(v_shoes).w	; speed up the BG music
		move.w	#$4B0,(v_ost_player+ost_sonic_shoe_time).w ; time limit for the power-up
		move.w	#$C00,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#$18,(v_sonspeedacc).w	; change Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w	; change Sonic's deceleration
		music	bgm_Speedup,1,0,0 ; speed up the music
; ===========================================================================

Pow_ChkShield:
		cmpi.b	#4,d0		; does monitor contain a shield?
		bne.s	Pow_ChkInvinc

		move.b	#1,(v_shield).w	; give Sonic a shield
		move.b	#id_ShieldItem,(v_ost_shield).w ; load shield object ($38)
		music	sfx_Shield,1,0,0 ; play shield sound
; ===========================================================================

Pow_ChkInvinc:
		cmpi.b	#5,d0		; does monitor contain invincibility?
		bne.s	Pow_ChkRings

		move.b	#1,(v_invincibility).w	; make Sonic invincible
		move.w	#$4B0,(v_ost_player+ost_sonic_inv_time).w ; time limit for the power-up
		move.b	#id_ShieldItem,(v_ost_stars1).w ; load stars object ($3801)
		move.b	#id_ani_stars1,(v_ost_stars1+ost_anim).w
		move.b	#id_ShieldItem,(v_ost_stars2).w ; load stars object ($3802)
		move.b	#id_ani_stars2,(v_ost_stars2+ost_anim).w
		move.b	#id_ShieldItem,(v_ost_stars3).w ; load stars object ($3803)
		move.b	#id_ani_stars3,(v_ost_stars3+ost_anim).w
		move.b	#id_ShieldItem,(v_ost_stars4).w ; load stars object ($3804)
		move.b	#id_ani_stars4,(v_ost_stars4+ost_anim).w
		tst.b	(f_lockscreen).w ; is boss mode on?
		bne.s	Pow_NoMusic	; if yes, branch
		if Revision=0
		else
			cmpi.w	#$C,(v_air).w
			bls.s	Pow_NoMusic
		endc
		music	bgm_Invincible,1,0,0 ; play invincibility music
; ===========================================================================

Pow_NoMusic:
		rts	
; ===========================================================================

Pow_ChkRings:
		cmpi.b	#6,d0		; does monitor contain 10 rings?
		bne.s	Pow_ChkS

		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		ori.b	#1,(v_hud_rings_update).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		bcs.s	Pow_RingSound
		bset	#1,(v_ring_reward).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		bcs.s	Pow_RingSound
		bset	#2,(v_ring_reward).w
		beq.w	ExtraLife

	Pow_RingSound:
		music	sfx_Ring,1,0,0	; play ring sound
; ===========================================================================

Pow_ChkS:
		cmpi.b	#7,d0		; does monitor contain 'S'?
		bne.s	Pow_ChkEnd
		nop	

Pow_ChkEnd:
		rts			; 'S' and goggles monitors do nothing
; ===========================================================================

Pow_Delete:	; Routine 4
		subq.w	#1,ost_anim_time(a0)
		bmi.w	DeleteObject	; delete after half a second
		rts	
