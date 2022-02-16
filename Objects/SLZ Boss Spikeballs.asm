; ---------------------------------------------------------------------------
; Object 7B - exploding	spikeys	that Eggman drops (SLZ)

; spawned by:
;	BossStarLight
; ---------------------------------------------------------------------------

BossSpikeball:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BSpike_Index(pc,d0.w),d0
		jsr	BSpike_Index(pc,d0.w)
		move.w	ost_bspike_x_start(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_camera_x_pos).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	BSLZ_Delete
		cmpi.w	#$280,d0
		bhi.w	BSLZ_Delete
		jmp	(DisplaySprite).l
; ===========================================================================
BSpike_Index:	index *,,2
		ptr BSpike_Main
		ptr BSpike_Fall
		ptr BSpike_Bounce
		ptr BSpike_HitBoss
		ptr BSpike_Explode
		ptr BSpike_MoveFrag

ost_bspike_x_start:	equ $30					; seesaw x position (2 bytes)
ost_bspike_y_start:	equ $34					; seesaw y position (2 bytes)
ost_bspike_state:	equ $3A					; seesaw state: 0 = left raised; 2 = right raised; 1/3 = flat
ost_bspike_seesaw:	equ $3C					; address of OST of seesaw (4 bytes)
; ===========================================================================

BSpike_Main:	; Routine 0
		move.l	#Map_SSawBall,ost_mappings(a0)
		move.w	#tile_Nem_SlzSpike_Boss,ost_tile(a0)
		move.b	#id_frame_seesaw_silver,ost_frame(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw below
		move.w	ost_x_pos(a1),ost_bspike_x_start(a0)
		move.w	ost_y_pos(a1),ost_bspike_y_start(a0)
		bset	#status_xflip_bit,ost_status(a0)
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_x_pos(a1),d0			; is spikeball on right side of seesaw?
		bgt.s	@on_right				; if yes, branch
		bclr	#status_xflip_bit,ost_status(a0)
		move.b	#2,ost_bspike_state(a0)

	@on_right:
		addq.b	#2,ost_routine(a0)			; goto BSpike_Fall next

BSpike_Fall:	; Routine 2
		jsr	(ObjectFall).l				; apply gravity and update position
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw below
		lea	(BSpike_YPos).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0			; get seesaw frame
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	@on_right				; branch if spikeball is on right side of seesaw
		addq.w	#2,d0

	@on_right:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1				; d1 = expected y pos for spikeball
		cmp.w	ost_y_pos(a0),d1
		bgt.s	@exit					; branch if spikeball is above d1
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw
		moveq	#2,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@no_xflip
		moveq	#0,d1

	@no_xflip:
		move.w	#$F0,ost_subtype(a0)
		move.b	#10,ost_anim_delay(a0)			; set frame duration to 10 frames
		move.b	ost_anim_delay(a0),ost_anim_time(a0)
		bra.w	BSpike_Update
; ===========================================================================

@exit:
		rts	
; ===========================================================================

BSpike_Bounce:	; Routine 4
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw
		moveq	#0,d0
		move.b	ost_bspike_state(a0),d0
		sub.b	ost_seesaw_state(a1),d0
		beq.s	@no_change				; branch if seesaw and spikeball have same state
		bcc.s	@on_left				; branch if spikeball lands on left side
		neg.b	d0					; make d0 +ve

	@on_left:
		move.w	#-$818,d1
		move.w	#-$114,d2
		cmpi.b	#1,d0					; was seesaw flat?
		beq.s	@weaker					; if yes, branch
		move.w	#-$960,d1
		move.w	#-$F4,d2
		cmpi.w	#$9C0,ost_seesaw_impact(a1)
		blt.s	@weaker					; branch if Sonic landed on seesaw below given speed
		move.w	#-$A20,d1
		move.w	#-$80,d2

	@weaker:
		move.w	d1,ost_y_vel(a0)			; set bounce speed for spikeball
		move.w	d2,ost_x_vel(a0)
		move.w	ost_x_pos(a0),d0
		sub.w	ost_bspike_x_start(a0),d0
		bcc.s	@on_right				; branch if spikeball was on right side
		neg.w	ost_x_vel(a0)				; move in correct direction

	@on_right:
		move.b	#id_frame_seesaw_silver,ost_frame(a0)
		move.w	#$20,ost_subtype(a0)			; set timer
		addq.b	#2,ost_routine(a0)			; goto BSpike_HitBoss next
		bra.w	BSpike_HitBoss
; ===========================================================================

@no_change:
		lea	(BSpike_YPos).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0			; get seesaw frame
		move.w	#$28,d2					; dist from seesaw centre to edge
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	@on_right2				; branch if spikeball is on right side
		neg.w	d2
		addq.w	#2,d0

	@on_right2:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1				; add relative y pos to initial y pos
		move.w	d1,ost_y_pos(a0)			; update y pos
		add.w	ost_bspike_x_start(a0),d2		; add width to initial x pos
		move.w	d2,ost_x_pos(a0)			; update x pos
		clr.w	ost_y_sub(a0)
		clr.w	ost_x_sub(a0)
		subq.w	#1,ost_subtype(a0)			; decrement timer
		bne.s	BSpike_Animate				; branch if time remains
		move.w	#$20,ost_subtype(a0)			; set subtype to allow spawning of shrapnel objects
		move.b	#id_BSpike_Explode,ost_routine(a0)	; goto BSpike_Explode next
		rts	
; ===========================================================================

BSpike_Animate:
		cmpi.w	#$78,ost_subtype(a0)			; subtype decrements like a timer
		bne.s	@not_fast				; branch if not at specified value
		move.b	#5,ost_anim_delay(a0)			; use faster animation speed

	@not_fast:
		cmpi.w	#$3C,ost_subtype(a0)
		bne.s	@not_faster
		move.b	#2,ost_anim_delay(a0)			; use fastest animation speed

	@not_faster:
		subq.b	#1,ost_anim_time(a0)			; decrement animation timer
		bgt.s	@wait					; branch if time remains
		bchg	#0,ost_frame(a0)			; change frame
		move.b	ost_anim_delay(a0),ost_anim_time(a0)

	@wait:
		rts	
; ===========================================================================

BSpike_HitBoss:	; Routine 6
		lea	(v_ost_all+sizeof_ost).w,a1		; start at first OST slot after Sonic
		moveq	#id_BossStarLight,d0
		moveq	#sizeof_ost,d1
		moveq	#$3E,d2					; check first $40 OST slots

	@loop:
		cmp.b	(a1),d0					; is object the boss?
		beq.s	@boss_found				; if yes, branch
		adda.w	d1,a1					; next OST slot
		dbf	d2,@loop				; repeat for all OST slots

		bra.s	@boss_missed
; ===========================================================================

@boss_found:
		move.w	ost_x_pos(a1),d0			; position of boss
		move.w	ost_y_pos(a1),d1
		move.w	ost_x_pos(a0),d2			; position of spikeball
		move.w	ost_y_pos(a0),d3
		lea	BSpike_Boss_Hitbox(pc),a2
		lea	BSpike_Ball_Hitbox(pc),a3
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d0,d2
		bcs.s	@boss_missed
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d2,d0
		bcs.s	@boss_missed
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d1,d3
		bcs.s	@boss_missed
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d3,d1
		bcs.s	@boss_missed

		addq.b	#2,ost_routine(a0)			; goto BSpike_Explode next
		clr.w	ost_subtype(a0)
		clr.b	ost_col_type(a1)			; make boss harmless
		subq.b	#1,ost_col_property(a1)			; subtract hit point from boss
		bne.s	@boss_missed				; branch if not 0
		bset	#status_broken_bit,ost_status(a1)	; flag boss as beaten
		clr.w	ost_x_vel(a0)				; stop spikeball moving
		clr.w	ost_y_vel(a0)

@boss_missed:
		tst.w	ost_y_vel(a0)				; is spikeball moving upwards?
		bpl.s	@downwards				; if not, branch
		jsr	(ObjectFall).l				; apply gravity and update position
		move.w	ost_bspike_y_start(a0),d0
		subi.w	#$2F,d0
		cmp.w	ost_y_pos(a0),d0			; is spikeball within 48px of seesaw?
		bgt.s	@animate				; if yes, branch
		jsr	(ObjectFall).l				; apply gravity and update position

	@animate:
		bra.w	BSpike_Animate
; ===========================================================================

@downwards:
		jsr	(ObjectFall).l				; apply gravity and update position
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw below
		lea	(BSpike_YPos).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0			; get seesaw frame
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	@on_right				; branch if spikeball is on right side of seesaw
		addq.w	#2,d0

	@on_right:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1				; d1 = expected y pos for spikeball
		cmp.w	ost_y_pos(a0),d1
		bgt.s	@animate				; branch if spikeball is above d1
		movea.l	ost_bspike_seesaw(a0),a1		; get address of OST of seesaw
		moveq	#2,d1
		tst.w	ost_x_vel(a0)
		bmi.s	@moving_left
		moveq	#0,d1

	@moving_left:
		move.w	#0,ost_subtype(a0)

BSpike_Update:
		move.b	d1,ost_seesaw_state(a1)			; set new state for seesaw (0 or 2)
		move.b	d1,ost_bspike_state(a0)
		cmp.b	ost_frame(a1),d1			; was seesaw in a different state previously?
		beq.s	@no_change				; if not, branch
		bclr	#status_platform_bit,ost_status(a1)
		beq.s	@no_change				; branch if Sonic wasn't on the seesaw

		clr.b	ost_routine2(a1)
		move.b	#id_See_Slope,ost_routine(a1)		; reset seesaw routine
		lea	(v_ost_player).w,a2
		move.w	ost_y_vel(a0),ost_y_vel(a2)
		neg.w	ost_y_vel(a2)				; launch Sonic into air
		cmpi.b	#id_frame_seesaw_flat,ost_frame(a1)	; was seesaw flat?
		bne.s	@not_flat				; if not, branch
		asr	ost_y_vel(a2)				; reduce speed

	@not_flat:
		bset	#status_air_bit,ost_status(a2)
		bclr	#status_platform_bit,ost_status(a2)
		clr.b	ost_sonic_jump(a2)
		move.l	a0,-(sp)				; save spikeball OST address to stack
		lea	(a2),a0					; pretend Sonic is current object
		jsr	(Sonic_ChkRoll).l			; allow Sonic to bounce-roll off seesaw
		movea.l	(sp)+,a0				; restore spikeball OST
		move.b	#id_Sonic_Control,ost_routine(a2)
		play.w	1, jsr, sfx_Spring			; play "spring" sound

	@no_change:
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)			; goto BSpike_Bounce next
		bra.w	BSpike_Animate
; ===========================================================================
BSpike_YPos:	dc.w -8						; on raised side
		dc.w -$1C					; on flat
		dc.w -$2F					; on low side
		dc.w -$1C
		dc.w -8
		even
BSpike_Boss_Hitbox:
		dc.b -$18, $30					; half width, full width
		dc.b -$18, $30
		even
BSpike_Ball_Hitbox:
		dc.b 8,	-$10					; half width, full width
		dc.b 8, -$10
		even
; ===========================================================================

BSpike_Explode:	; Routine 8
		move.b	#id_ExplosionBomb,(a0)			; turn object into explosion
		clr.b	ost_routine(a0)
		cmpi.w	#$20,ost_subtype(a0)			; is shrapnel flag set?
		beq.s	@make_frags				; if yes, branch
		rts	
; ===========================================================================

@make_frags:
		move.w	ost_bspike_y_start(a0),ost_y_pos(a0)
		moveq	#4-1,d1					; number of fragments
		lea	BSpike_FragSpeed(pc),a2

	@loop:
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_BossSpikeball,(a1)			; load shrapnel object
		move.b	#id_BSpike_MoveFrag,ost_routine(a1)	; goto BSpike_MoveFrag next
		move.l	#Map_BSBall,ost_mappings(a1)
		move.b	#3,ost_priority(a1)
		move.w	#tile_Nem_Bomb_Boss,ost_tile(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	(a2)+,ost_x_vel(a1)
		move.w	(a2)+,ost_y_vel(a1)
		move.b	#id_col_4x4+id_col_hurt,ost_col_type(a1)
		ori.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a1)
		move.b	#$C,ost_actwidth(a1)

	@fail:
		dbf	d1,@loop				; repeat sequence 3 more times

		rts	
; ===========================================================================
BSpike_FragSpeed:
		dc.w -$100, -$340				; horizontal, vertical
		dc.w -$A0, -$240
		dc.w $100, -$340
		dc.w $A0, -$240
; ===========================================================================

BSpike_MoveFrag:
		; Routine $A
		jsr	(SpeedToPos).l				; update position
		move.w	ost_x_pos(a0),ost_bspike_x_start(a0)
		move.w	ost_y_pos(a0),ost_bspike_y_start(a0)
		addi.w	#$18,ost_y_vel(a0)			; apply gravity
		moveq	#4,d0
		and.w	(v_vblank_counter_word).w,d0
		lsr.w	#2,d0					; d0 = bit that changed every 4th frame
		move.b	d0,ost_frame(a0)			; set as frame
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BSLZ_Delete				; if not, branch
		rts	
