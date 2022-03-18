; ---------------------------------------------------------------------------
; Object 86 - plasma balls (FZ)

; spawned by:
;	BossFinal - routine 0
;	BossPlasma - routine 8
; ---------------------------------------------------------------------------

BossPlasma:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Plasma_Index(pc,d0.w),d0
		jmp	Plasma_Index(pc,d0.w)
; ===========================================================================
Plasma_Index:	index *,,2
		ptr Plasma_Main
		ptr Plasma_Generator
		ptr Plasma_MakeBalls
		ptr Plasma_Finish
		ptr Plasma_Balls

ost_plasma_flag:	equ $29					; flag set when firing
ost_plasma_x_target:	equ $30					; x position where plasma ball stops (2 bytes)
ost_plasma_count_top:	equ $32					; number of plasma balls moving across top (2 bytes)
ost_plasma_parent:	equ $34					; address of OST of parent object (4 bytes)
ost_plasma_count_any:	equ $38					; number of plasma balls on-screen (2 bytes)
; ===========================================================================

Plasma_Main:	; Routine 0
		move.w	#$2588,ost_x_pos(a0)
		move.w	#$53C,ost_y_pos(a0)
		move.w	#tile_Nem_FzBoss,ost_tile(a0)
		move.l	#Map_PLaunch,ost_mappings(a0)
		move.b	#id_ani_plaunch_red,ost_anim(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_width(a0)
		move.b	#8,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		addq.b	#2,ost_routine(a0)			; goto Plasma_Generator next

Plasma_Generator:
		; Routine 2
		movea.l	ost_plasma_parent(a0),a1		; get address of OST of parent object
		cmpi.b	#id_BFZ_Eggman_Fall,ost_fz_mode(a1)	; has boss been beaten?
		bne.s	@not_beaten				; if not, branch
		move.b	#id_ExplosionBomb,(a0)			; replace object with explosion
		move.b	#id_ExBom_Main,ost_routine(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

@not_beaten:
		move.b	#id_ani_plaunch_red,ost_anim(a0)
		tst.b	ost_plasma_flag(a0)			; is plasma set to activate?
		beq.s	Plasma_Update				; if not, branch
		addq.b	#2,ost_routine(a0)			; goto Plasma_MakeBalls next
		move.b	#id_ani_plaunch_redsparking,ost_anim(a0) ; use sparking animation
		move.b	#$3E,ost_subtype(a0)

Plasma_Update:
		move.w	#$13,d1
		move.w	#8,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bmi.s	@animate				; branch if Sonic is left of the plasma launcher
		subi.w	#320,d0
		bmi.s	@animate				; branch if Sonic is within 320px of plasma launcher
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	Cyl_Delete				; if not, branch

	@animate:
		lea	Ani_PLaunch(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Plasma_MakeBalls:
		; Routine 4
		tst.b	ost_plasma_flag(a0)			; is plasma set to activate?
		beq.w	@skip_balls				; if not, branch
		clr.b	ost_plasma_flag(a0)
		add.w	ost_plasma_x_target(a0),d0		; these four lines do nothing
		andi.w	#$1E,d0
		adda.w	d0,a2
		addq.w	#4,ost_plasma_x_target(a0)
		clr.w	ost_plasma_count_top(a0)		; initialise plasma ball count
		moveq	#4-1,d2					; number of plasma balls

	@loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.w	@skip_balls				; branch if not found
		move.b	#id_BossPlasma,(a1)			; load plasma ball object
		move.w	ost_x_pos(a0),ost_x_pos(a1)		; start at same position as launcher object
		move.w	#$53C,ost_y_pos(a1)
		move.b	#id_Plasma_Balls,ost_routine(a1)	; goto Plasma_Balls next
		move.w	#tile_Nem_FzBoss+tile_pal2,ost_tile(a1)
		move.l	#Map_Plasma,ost_mappings(a1)
		move.b	#$C,ost_height(a1)
		move.b	#$C,ost_width(a1)
		move.b	#0,ost_col_type(a1)
		move.b	#3,ost_priority(a1)
		move.w	#$3E,ost_subtype(a1)
		move.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a1)
		move.l	a0,ost_plasma_parent(a1)		; save launcher OST to plasma ball OST
		jsr	(RandomNumber).l			; d0 = random number
		move.w	ost_plasma_count_top(a0),d1		; id of plasma ball (0-3)
		muls.w	#-$4F,d1				; avg distance between balls
		addi.w	#$2578,d1				; add initial x pos
		andi.w	#$1F,d0
		subi.w	#$10,d0
		add.w	d1,d0					; add random number between -16 and 15
		move.w	d0,ost_plasma_x_target(a1)		; set x pos for plasma ball to stop
		addq.w	#1,ost_plasma_count_top(a0)		; next plasma ball
		move.w	ost_plasma_count_top(a0),ost_plasma_count_any(a0)
		dbf	d2,@loop				; repeat sequence 3 more times

	@skip_balls:
		tst.w	ost_plasma_count_top(a0)		; are plasma balls still loaded?
		bne.s	@update					; if yes, branch
		addq.b	#2,ost_routine(a0)			; goto Plasma_Finish next

	@update:
		bra.w	Plasma_Update
; ===========================================================================

Plasma_Finish:	; Routine 6
		move.b	#id_ani_plaunch_whitesparking,ost_anim(a0)
		tst.w	ost_plasma_count_any(a0)
		bne.s	loc_1A97E
		move.b	#id_Plasma_Generator,ost_routine(a0)	; goto Plasma_Generator next
		movea.l	ost_plasma_parent(a0),a1		; address of OST of parent object (boss)
		move.w	#-1,ost_fz_phase_state(a1)		; signal to boss that plasma phase is finished

loc_1A97E:
		bra.w	Plasma_Update
; ===========================================================================

Plasma_Balls:	; Routine 8
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Plasma_Balls_Index(pc,d0.w),d0
		jsr	Plasma_Balls_Index(pc,d0.w)
		lea	Ani_Plasma(pc),a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================
Plasma_Balls_Index:
		index *,,2
		ptr Plasma_Spread
		ptr Plasma_Drop
		ptr Plasma_Move
; ===========================================================================

Plasma_Spread:
		move.w	ost_plasma_x_target(a0),d0
		sub.w	ost_x_pos(a0),d0
		asl.w	#4,d0
		move.w	d0,ost_x_vel(a0)			; set speed so balls all arrive in position at the same time
		move.w	#180,ost_subtype(a0)			; set timer to 3 seconds
		addq.b	#2,ost_routine2(a0)			; goto Plasma_Drop next
		rts	
; ===========================================================================

Plasma_Drop:
		tst.w	ost_x_vel(a0)				; is plasma ball moving?
		beq.s	@skip_stop				; if not, branch
		jsr	(SpeedToPos).l				; update position
		move.w	ost_x_pos(a0),d0
		sub.w	ost_plasma_x_target(a0),d0
		bcc.s	@skip_stop				; branch if plasma ball hasn't reached target x pos
		clr.w	ost_x_vel(a0)				; stop moving
		add.w	d0,ost_x_pos(a0)			; align to target
		movea.l	ost_plasma_parent(a0),a1		; address of OST of parent object (launcher)
		subq.w	#1,ost_plasma_count_top(a1)		; decrement count of plasma balls at top

	@skip_stop:
		move.b	#id_ani_plasma_full,ost_anim(a0)
		subq.w	#1,ost_subtype(a0)			; decrement timer
		bne.s	@wait					; branch if not 0
		addq.b	#2,ost_routine2(a0)			; goto Plasma_Move next
		move.b	#id_ani_plasma_short,ost_anim(a0)
		move.b	#id_col_12x12+id_col_hurt,ost_col_type(a0) ; make plasma ball harmful
		move.w	#180,ost_subtype(a0)
		moveq	#0,d0
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_vel(a0)			; move towards Sonic on x axis
		move.w	#$140,ost_y_vel(a0)			; move downwards

	@wait:
		rts	
; ===========================================================================

Plasma_Move:
		jsr	(SpeedToPos).l				; update position
		cmpi.w	#$5E0,ost_y_pos(a0)			; has plasma ball moved off screen?
		bcc.s	@delete					; if yes, branch
		subq.w	#1,ost_subtype(a0)			; decrement timer
		beq.s	@delete					; branch if 0
		rts	
; ===========================================================================

@delete:
		movea.l	ost_plasma_parent(a0),a1		; address of OST of parent object (launcher)
		subq.w	#1,ost_plasma_count_any(a1)		; decrement count of plasma balls
		bra.w	Cyl_Delete

; ---------------------------------------------------------------------------
; Animation scripts
; ---------------------------------------------------------------------------

Ani_PLaunch:	index *
		ptr ani_plaunch_red
		ptr ani_plaunch_redsparking
		ptr ani_plaunch_whitesparking
		
ani_plaunch_red:
		dc.b $7E
		dc.b id_frame_plaunch_red
		dc.b afEnd
		even

ani_plaunch_redsparking:
		dc.b 1
		dc.b id_frame_plaunch_red
		dc.b id_frame_plaunch_sparking1
		dc.b id_frame_plaunch_red
		dc.b id_frame_plaunch_sparking2
		dc.b afEnd
		even

ani_plaunch_whitesparking:
		dc.b 1
		dc.b id_frame_plaunch_white
		dc.b id_frame_plaunch_sparking1
		dc.b id_frame_plaunch_white
		dc.b id_frame_plaunch_sparking2
		dc.b afEnd
		even

include_BossPlasma_animation:	macro

Ani_Plasma:	index *
		ptr ani_plasma_full
		ptr ani_plasma_short
		
ani_plasma_full:
		dc.b 1
		dc.b id_frame_plasma_fuzzy1
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy5
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy2
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy6
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy3
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy4
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy1
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy5
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy2
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy6
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy3
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_fuzzy4
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_white1
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_white2
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_white3
		dc.b id_frame_plasma_blank
		dc.b id_frame_plasma_white4
		dc.b afEnd
		even

ani_plasma_short:
		dc.b 0
		dc.b id_frame_plasma_fuzzy3
		dc.b id_frame_plasma_white4
		dc.b id_frame_plasma_fuzzy2
		dc.b id_frame_plasma_white4
		dc.b id_frame_plasma_fuzzy4
		dc.b id_frame_plasma_white4
		dc.b id_frame_plasma_fuzzy2
		dc.b id_frame_plasma_white4
		dc.b afEnd
		even

		endm
