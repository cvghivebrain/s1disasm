; ---------------------------------------------------------------------------
; Subroutine to react to ost_col_type(a0)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReactToItem:
		nop	
		move.w	ost_x_pos(a0),d2 ; load Sonic's x-axis position
		move.w	ost_y_pos(a0),d3 ; load Sonic's y-axis position
		subq.w	#8,d2
		moveq	#0,d5
		move.b	ost_height(a0),d5 ; load Sonic's height
		subq.b	#3,d5
		sub.w	d5,d3
		cmpi.b	#id_frame_Duck,ost_frame(a0) ; is Sonic ducking?
		bne.s	@notducking	; if not, branch
		addi.w	#$C,d3
		moveq	#$A,d5

	@notducking:
		move.w	#$10,d4
		add.w	d5,d5
		lea	(v_ost_all+$800).w,a1 ; first OST address for interactable objects
		move.w	#$5F,d6

@loop:
		tst.b	ost_render(a1)
		bpl.s	@next
		move.b	ost_col_type(a1),d0 ; load collision type
		bne.s	@proximity	; if nonzero, branch

	@next:
		lea	$40(a1),a1	; next object RAM
		dbf	d6,@loop	; repeat $5F more times

		moveq	#0,d0
		rts	
; ===========================================================================
@sizes:		;   width, height
		dc.b  $14, $14	; $01 - GHZ ball
		dc.b   $C, $14	; $02
		dc.b  $14,  $C	; $03
		dc.b	4, $10	; $04 - GHZ spike pole, SYZ boss spike
		dc.b   $C, $12	; $05 - Ball Hog, Burrobot
		dc.b  $10, $10	; $06 - SBZ spikeball, Crabmeat, Monitor, SYZ spikeball, Prison
		dc.b	6,   6	; $07 - Cannonball, Crab/Buzz missile, Ring
		dc.b  $18,  $C	; $08 - Buzz Bomber
		dc.b   $C, $10	; $09 - Chopper
		dc.b  $10,  $C	; $0A - Jaws
		dc.b	8,   8	; $0B - MZ fire, Fireball, Batbrain, LZ spikeball, SLZ seesaw spike, Orbinaut, Caterkiller
		dc.b  $14, $10	; $0C - Newtron, Motobug, Yadrin
		dc.b  $14,   8	; $0D - Newtron
		dc.b   $E,  $E	; $0E - Roller
		dc.b  $18, $18	; $0F - Bosses
		dc.b  $28, $10	; $10 - MZ stomper
		dc.b  $10, $18	; $11 - MZ stomper
		dc.b	8, $10	; $12 - Giant ring
		dc.b  $20, $70	; $13 - MZ geyser
		dc.b  $40, $20	; $14 - MZ lava wall, MZ lava tag
		dc.b  $80, $20	; $15 - MZ lava tag
		dc.b  $20, $20	; $16 - MZ lava tag
		dc.b	8,   8	; $17 - SYZ bumper
		dc.b	4,   4	; $18 - SYZ spike chain, Bomb shrapnel, Orbinaut spike, LZ gargoyle fire
		dc.b  $20,   8	; $19 - SLZ swing
		dc.b   $C,  $C	; $1A - Bomb enemy, FZ plasma
		dc.b	8,   4	; $1B - LZ harpoon
		dc.b  $18,   4	; $1C - LZ harpoon
		dc.b  $28,   4	; $1D - LZ harpoon
		dc.b	4,   8	; $1E - LZ harpoon
		dc.b	4, $18	; $1F - LZ harpoon
		dc.b	4, $28	; $20 - LZ harpoon
		dc.b	4, $20	; $21 - LZ pole
		dc.b  $18, $18	; $22 - SBZ saw
		dc.b   $C, $18	; $23 - SBZ flamethrower
		dc.b  $48,   8	; $24 - SBZ electric
; ===========================================================================

@proximity:
		andi.w	#$3F,d0		; read only bits 0-5, ignore 6-7
		add.w	d0,d0
		lea	@sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	ost_x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	@outsidex	; branch if not touching
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	@withinx	; branch if touching
		bra.w	@next
; ===========================================================================

@outsidex:
		cmp.w	d4,d0
		bhi.w	@next

@withinx:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	ost_y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	@outsidey	; branch if not touching
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	@withiny	; branch if touching
		bra.w	@next
; ===========================================================================

@outsidey:
		cmp.w	d5,d0
		bhi.w	@next

@withiny:
	@chktype:
		move.b	ost_col_type(a1),d1 ; load collision type
		andi.b	#$C0,d1		; is ost_col_type $40 or higher?
		beq.w	React_Enemy	; if not, branch
		cmpi.b	#$C0,d1		; is ost_col_type $C0 or higher?
		beq.w	React_Special	; if yes, branch
		tst.b	d1		; is ost_col_type $80-$BF?
		bmi.w	React_ChkHurt	; if yes, branch

; ost_col_type is $40-$7F (powerups)

		move.b	ost_col_type(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0		; is collision type $46	?
		beq.s	React_Monitor	; if yes, branch
		cmpi.w	#90,ost_sonic_flash_time(a0) ; is Sonic invincible?
		bcc.w	@invincible	; if yes, branch
		addq.b	#2,ost_routine(a1) ; advance the object's routine counter

	@invincible:
		rts	
; ===========================================================================

React_Monitor:
		tst.w	ost_y_vel(a0)	; is Sonic moving upwards?
		bpl.s	@movingdown	; if not, branch

		move.w	ost_y_pos(a0),d0
		subi.w	#$10,d0
		cmp.w	ost_y_pos(a1),d0
		bcs.s	@donothing
		neg.w	ost_y_vel(a0)	; reverse Sonic's vertical speed
		move.w	#-$180,ost_y_vel(a1)
		tst.b	ost_routine2(a1)
		bne.s	@donothing
		addq.b	#4,ost_routine2(a1) ; advance the monitor's routine counter
		rts	
; ===========================================================================

@movingdown:
		cmpi.b	#id_Roll,ost_anim(a0) ; is Sonic rolling/jumping?
		bne.s	@donothing
		neg.w	ost_y_vel(a0)	; reverse Sonic's y-motion
		addq.b	#2,ost_routine(a1) ; advance the monitor's routine counter

	@donothing:
		rts	
; ===========================================================================

React_Enemy:
		tst.b	(v_invinc).w	; is Sonic invincible?
		bne.s	@donthurtsonic	; if yes, branch
		cmpi.b	#id_Roll,ost_anim(a0) ; is Sonic rolling/jumping?
		bne.w	React_ChkHurt	; if not, branch

	@donthurtsonic:
		tst.b	ost_col_property(a1)
		beq.s	@breakenemy

		neg.w	ost_x_vel(a0)	; repel Sonic
		neg.w	ost_y_vel(a0)
		asr	ost_x_vel(a0)
		asr	ost_y_vel(a0)
		move.b	#0,ost_col_type(a1)
		subq.b	#1,ost_col_property(a1)
		bne.s	@flagnotclear
		bset	#status_onscreen_bit,ost_status(a1)

	@flagnotclear:
		rts	
; ===========================================================================

@breakenemy:
		bset	#status_onscreen_bit,ost_status(a1)
		moveq	#0,d0
		move.w	(v_itembonus).w,d0
		addq.w	#2,(v_itembonus).w ; add 2 to item bonus counter
		cmpi.w	#6,d0
		bcs.s	@bonusokay
		moveq	#6,d0		; max bonus is lvl6

	@bonusokay:
		move.w	d0,ost_enemy_combo(a1)
		move.w	@points(pc,d0.w),d0
		cmpi.w	#$20,(v_itembonus).w ; have 16 enemies been destroyed?
		bcs.s	@lessthan16	; if not, branch
		move.w	#1000,d0	; fix bonus to 10000
		move.w	#$A,ost_enemy_combo(a1)

	@lessthan16:
		bsr.w	AddPoints
		move.b	#id_ExplosionItem,0(a1) ; change object to explosion
		move.b	#0,ost_routine(a1)
		tst.w	ost_y_vel(a0)
		bmi.s	@bouncedown
		move.w	ost_y_pos(a0),d0
		cmp.w	ost_y_pos(a1),d0
		bcc.s	@bounceup
		neg.w	ost_y_vel(a0)
		rts	
; ===========================================================================

	@bouncedown:
		addi.w	#$100,ost_y_vel(a0)
		rts	

	@bounceup:
		subi.w	#$100,ost_y_vel(a0)
		rts	

@points:	dc.w 10, 20, 50, 100	; points awarded div 10

; ===========================================================================

React_Caterkiller:
		bset	#status_onscreen_bit,ost_status(a1)

React_ChkHurt:
		tst.b	(v_invinc).w	; is Sonic invincible?
		beq.s	@notinvincible	; if not, branch

	@isflashing:
		moveq	#-1,d0
		rts	
; ===========================================================================

	@notinvincible:
		nop	
		tst.w	ost_sonic_flash_time(a0) ; is Sonic flashing?
		bne.s	@isflashing	; if yes, branch
		movea.l	a1,a2

; End of function ReactToItem
; continue straight to HurtSonic

; ---------------------------------------------------------------------------
; Hurting Sonic	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HurtSonic:
		tst.b	(v_shield).w	; does Sonic have a shield?
		bne.s	@hasshield	; if yes, branch
		tst.w	(v_rings).w	; does Sonic have any rings?
		beq.w	@norings	; if not, branch

		jsr	(FindFreeObj).l
		bne.s	@hasshield
		move.b	#id_RingLoss,0(a1) ; load bouncing multi rings object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

	@hasshield:
		move.b	#0,(v_shield).w	; remove shield
		move.b	#id_Sonic_Hurt,ost_routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#status_air_bit,ost_status(a0)
		move.w	#-$400,ost_y_vel(a0) ; make Sonic bounce away from the object
		move.w	#-$200,ost_x_vel(a0)
		btst	#status_underwater_bit,ost_status(a0) ; is Sonic underwater?
		beq.s	@isdry		; if not, branch

		move.w	#-$200,ost_y_vel(a0) ; slower bounce
		move.w	#-$100,ost_x_vel(a0)

	@isdry:
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_x_pos(a2),d0
		bcs.s	@isleft		; if Sonic is left of the object, branch
		neg.w	ost_x_vel(a0)	; if Sonic is right of the object, reverse

	@isleft:
		move.w	#0,ost_inertia(a0)
		move.b	#id_Hurt,ost_anim(a0)
		move.w	#120,ost_sonic_flash_time(a0) ; set temp invincible time to 2 seconds
		move.w	#sfx_Death,d0	; load normal damage sound
		cmpi.b	#id_Spikes,(a2)	; was damage caused by spikes?
		bne.s	@sound		; if not, branch
		cmpi.b	#id_Harpoon,(a2) ; was damage caused by LZ harpoon?
		bne.s	@sound		; if not, branch
		move.w	#sfx_HitSpikes,d0 ; load spikes damage sound

	@sound:
		jsr	(PlaySound_Special).l
		moveq	#-1,d0
		rts	
; ===========================================================================

@norings:
		tst.w	(f_debugmode).w	; is debug mode	cheat on?
		bne.w	@hasshield	; if yes, branch

; ---------------------------------------------------------------------------
; Subroutine to	kill Sonic
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


KillSonic:
		tst.w	(v_debuguse).w	; is debug mode	active?
		bne.s	@dontdie	; if yes, branch
		move.b	#0,(v_invinc).w	; remove invincibility
		move.b	#id_Sonic_Death,ost_routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#status_air_bit,ost_status(a0)
		move.w	#-$700,ost_y_vel(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_inertia(a0)
		move.w	ost_y_pos(a0),$38(a0)
		move.b	#id_Death,ost_anim(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#sfx_Death,d0	; play normal death sound
		cmpi.b	#id_Spikes,(a2)	; check	if you were killed by spikes
		bne.s	@sound
		move.w	#sfx_HitSpikes,d0 ; play spikes death sound

	@sound:
		jsr	(PlaySound_Special).l

	@dontdie:
		moveq	#-1,d0
		rts	
; End of function KillSonic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


React_Special:
		move.b	ost_col_type(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$B,d1		; is collision type $CB	?
		beq.s	@caterkiller	; if yes, branch
		cmpi.b	#$C,d1		; is collision type $CC	?
		beq.s	@yadrin		; if yes, branch
		cmpi.b	#$17,d1		; is collision type $D7	?
		beq.s	@D7orE1		; if yes, branch
		cmpi.b	#$21,d1		; is collision type $E1	?
		beq.s	@D7orE1		; if yes, branch
		rts	
; ===========================================================================

@caterkiller:
		bra.w	React_Caterkiller
; ===========================================================================

@yadrin:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	@normalenemy
		move.w	ost_x_pos(a1),d0
		subq.w	#4,d0
		btst	#status_xflip_bit,ost_status(a1)
		beq.s	@noflip
		subi.w	#$10,d0

	@noflip:
		sub.w	d2,d0
		bcc.s	@loc_1B13C
		addi.w	#$18,d0
		bcs.s	@loc_1B140
		bra.s	@normalenemy
; ===========================================================================

	@loc_1B13C:
		cmp.w	d4,d0
		bhi.s	@normalenemy

	@loc_1B140:
		bra.w	React_ChkHurt
; ===========================================================================

	@normalenemy:
		bra.w	React_Enemy
; ===========================================================================

@D7orE1:
		addq.b	#1,ost_col_property(a1)
		rts	
; End of function React_Special
