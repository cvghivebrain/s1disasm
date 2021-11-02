; ---------------------------------------------------------------------------
; Object 8B - Eggman on "TRY AGAIN" and "END"	screens
; ---------------------------------------------------------------------------

EndEggman:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	EEgg_Index(pc,d0.w),d1
		jsr	EEgg_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
EEgg_Index:	index *,,2
		ptr EEgg_Main
		ptr EEgg_Animate
		ptr EEgg_Juggle
		ptr EEgg_Wait

ost_eeggman_wait_time:	equ $30	; time between juggle motions (2 bytes)
; ===========================================================================

EEgg_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$120,ost_x_pos(a0)
		move.w	#$F4,ost_y_screen(a0)
		move.l	#Map_EEgg,ost_mappings(a0)
		move.w	#tile_Nem_TryAgain,ost_tile(a0)
		move.b	#render_abs,ost_render(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_ani_eegg_end,ost_anim(a0) ; use "END" animation
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	EEgg_Animate	; if yes, branch

		move.b	#id_CreditsText,(v_ost_tryagain).w ; load credits object
		move.w	#id_frame_cred_tryagain,(v_credits_num).w ; use "TRY AGAIN" text
		move.b	#id_TryChaos,(v_ost_tryag_emeralds).w ; load emeralds object on "TRY AGAIN" screen
		move.b	#id_ani_eegg_juggle1,ost_anim(a0) ; use "TRY AGAIN" animation

EEgg_Animate:	; Routine 2
		lea	(Ani_EEgg).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

EEgg_Juggle:	; Routine 4
		addq.b	#2,ost_routine(a0)
		moveq	#2,d0
		btst	#0,ost_anim(a0)
		beq.s	@noflip
		neg.w	d0

	@noflip:
		lea	(v_ost_tryag_emeralds).w,a1 ; get RAM address for emeralds
		moveq	#5,d1

@emeraldloop:
		move.b	d0,ost_ectry_speed(a1)
		move.w	d0,d2
		asl.w	#3,d2
		add.b	d2,ost_angle(a1)
		lea	$40(a1),a1
		dbf	d1,@emeraldloop
		addq.b	#1,ost_frame(a0)
		move.w	#112,ost_eeggman_wait_time(a0)

EEgg_Wait:	; Routine 6
		subq.w	#1,ost_eeggman_wait_time(a0) ; decrement timer
		bpl.s	@nochg		; branch if time remains
		bchg	#0,ost_anim(a0)
		move.b	#id_EEgg_Animate,ost_routine(a0) ; goto EEgg_Animate next

	@nochg:
		rts	
