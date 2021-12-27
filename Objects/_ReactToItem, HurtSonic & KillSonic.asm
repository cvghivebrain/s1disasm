; ---------------------------------------------------------------------------
; Subroutine to react to ost_col_type(a0)
; ---------------------------------------------------------------------------

ReactToItem:
		nop	
		move.w	ost_x_pos(a0),d2			; load Sonic's x-axis position
		move.w	ost_y_pos(a0),d3			; load Sonic's y-axis position
		subq.w	#8,d2
		moveq	#0,d5
		move.b	ost_height(a0),d5			; load Sonic's height
		subq.b	#3,d5
		sub.w	d5,d3
		cmpi.b	#id_frame_Duck,ost_frame(a0)		; is Sonic ducking?
		bne.s	@notducking				; if not, branch
		addi.w	#$C,d3
		moveq	#$A,d5

	@notducking:
		move.w	#$10,d4
		add.w	d5,d5
		lea	(v_ost_level_obj).w,a1			; first OST address for interactable objects
		move.w	#countof_ost_ert-1,d6

React_Loop:
		tst.b	ost_render(a1)
		bpl.s	React_Next
		move.b	ost_col_type(a1),d0			; load collision type
		bne.s	React_ChkDist				; if nonzero, branch

	React_Next:
		lea	sizeof_ost(a1),a1			; next object RAM
		dbf	d6,React_Loop				; repeat $5F more times

		moveq	#0,d0
		rts	
; ===========================================================================
colid:		macro *
		id_\*: equ ((*-React_Sizes)/2)+1
		dc.b \1,\2
		endm

id_col_enemy:	equ 0						; enemies
id_col_item:	equ $40						; monitors, rings, giant rings
id_col_hurt:	equ $80						; hurts Sonic when touched
id_col_custom:	equ $C0						; enemies with spikes (yadrin, caterkiller), SYZ bumper

React_Sizes:	;   width, height
col_20x20:	colid  $14, $14					; $01 - GHZ ball
col_12x20:	colid   $C, $14					; $02
col_20x12:	colid  $14,  $C					; $03
col_4x16:	colid	4,  $10					; $04 - GHZ spike pole, SYZ boss spike
col_12x18:	colid   $C, $12					; $05 - Ball Hog, Burrobot
col_16x16:	colid  $10, $10					; $06 - SBZ spikeball, Crabmeat, Monitor, SYZ spikeball, Prison
col_6x6:	colid	6,    6					; $07 - Cannonball, Crab/Buzz missile, Ring
col_24x12:	colid  $18,  $C					; $08 - Buzz Bomber
col_12x16:	colid   $C, $10					; $09 - Chopper
col_16x12:	colid  $10,  $C					; $0A - Jaws
col_8x8:	colid	8,    8					; $0B - MZ fire, Fireball, Batbrain, LZ spikeball, SLZ seesaw spike, Orbinaut, Caterkiller
col_20x16:	colid  $14, $10					; $0C - Newtron, Motobug, Yadrin
col_20x8:	colid  $14,   8					; $0D - Newtron
col_14x14:	colid   $E,  $E					; $0E - Roller
col_24x24:	colid  $18, $18					; $0F - Bosses
col_40x16:	colid  $28, $10					; $10 - MZ stomper
col_16x24:	colid  $10, $18					; $11 - MZ stomper
col_8x16:	colid	8,  $10					; $12 - Giant ring
col_32x112:	colid  $20, $70					; $13 - MZ geyser
col_64x32:	colid  $40, $20					; $14 - MZ lava wall, MZ lava tag
col_128x32:	colid  $80, $20					; $15 - MZ lava tag
col_32x32:	colid  $20, $20					; $16 - MZ lava tag
col_8x8_2:	colid	8,    8					; $17 - SYZ bumper
col_4x4:	colid	4,    4					; $18 - SYZ spike chain, Bomb shrapnel, Orbinaut spike, LZ gargoyle fire
col_32x8:	colid  $20,   8					; $19 - SLZ swing
col_12x12:	colid   $C,  $C					; $1A - Bomb enemy, FZ plasma
col_8x4:	colid	8,    4					; $1B - LZ harpoon
col_24x4:	colid  $18,   4					; $1C - LZ harpoon
col_40x4:	colid  $28,   4					; $1D - LZ harpoon
col_4x8:	colid	4,    8					; $1E - LZ harpoon
col_4x24:	colid	4,  $18					; $1F - LZ harpoon
col_4x40:	colid	4,  $28					; $20 - LZ harpoon
col_4x32:	colid	4,  $20					; $21 - LZ pole
col_24x24_2:	colid  $18, $18					; $22 - SBZ saw
col_12x24:	colid   $C, $18					; $23 - SBZ flamethrower
col_72x8:	colid  $48,   8					; $24 - SBZ electric
; ===========================================================================

React_ChkDist:
		andi.w	#$3F,d0					; read only bits 0-5, ignore 6-7
		add.w	d0,d0
		lea	React_Sizes-2(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	ost_x_pos(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	@outsidex				; branch if not touching
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	@withinx				; branch if touching
		bra.w	React_Next
; ===========================================================================

@outsidex:
		cmp.w	d4,d0
		bhi.w	React_Next

@withinx:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	ost_y_pos(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	@outsidey				; branch if not touching
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	@withiny				; branch if touching
		bra.w	React_Next
; ===========================================================================

@outsidey:
		cmp.w	d5,d0
		bhi.w	React_Next

@withiny:
	@chktype:
		move.b	ost_col_type(a1),d1			; load collision type
		andi.b	#$C0,d1					; is ost_col_type $40 or higher?
		beq.w	React_Enemy				; if not, branch
		cmpi.b	#$C0,d1					; is ost_col_type $C0 or higher?
		beq.w	React_Special				; if yes, branch
		tst.b	d1					; is ost_col_type $80-$BF?
		bmi.w	React_ChkHurt				; if yes, branch

; ost_col_type is $40-$7F (powerups)

		move.b	ost_col_type(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#id_col_16x16,d0			; is collision type $46 (monitor)?
		beq.s	React_Monitor				; if yes, branch
		cmpi.w	#90,ost_sonic_flash_time(a0)		; is Sonic invincible?
		bcc.w	@invincible				; if yes, branch
		addq.b	#2,ost_routine(a1)			; advance the object's routine counter

	@invincible:
		rts	
; ===========================================================================

React_Monitor:
		tst.w	ost_y_vel(a0)				; is Sonic moving upwards?
		bpl.s	@movingdown				; if not, branch

		move.w	ost_y_pos(a0),d0
		subi.w	#$10,d0
		cmp.w	ost_y_pos(a1),d0
		bcs.s	@donothing
		neg.w	ost_y_vel(a0)				; reverse Sonic's vertical speed
		move.w	#-$180,ost_y_vel(a1)
		tst.b	ost_routine2(a1)
		bne.s	@donothing
		addq.b	#4,ost_routine2(a1)			; set routine counter to goto Mon_Solid_Fall
		rts	
; ===========================================================================

@movingdown:
		cmpi.b	#id_Roll,ost_anim(a0)			; is Sonic rolling/jumping?
		bne.s	@donothing
		neg.w	ost_y_vel(a0)				; reverse Sonic's y-motion
		addq.b	#2,ost_routine(a1)			; advance the monitor's routine counter

	@donothing:
		rts	
; ===========================================================================

React_Enemy:
		tst.b	(v_invincibility).w			; is Sonic invincible?
		bne.s	@donthurtsonic				; if yes, branch
		cmpi.b	#id_Roll,ost_anim(a0)			; is Sonic rolling/jumping?
		bne.w	React_ChkHurt				; if not, branch

	@donthurtsonic:
		tst.b	ost_col_property(a1)
		beq.s	@breakenemy

		neg.w	ost_x_vel(a0)				; repel Sonic
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
		move.w	(v_enemy_combo).w,d0
		addq.w	#2,(v_enemy_combo).w			; add 2 to item bonus counter
		cmpi.w	#6,d0
		bcs.s	@bonusokay
		moveq	#6,d0					; max bonus is lvl6

	@bonusokay:
		move.w	d0,ost_enemy_combo(a1)
		move.w	@points(pc,d0.w),d0
		cmpi.w	#$20,(v_enemy_combo).w			; have 16 enemies been destroyed?
		bcs.s	@lessthan16				; if not, branch
		move.w	#1000,d0				; fix bonus to 10000
		move.w	#$A,ost_enemy_combo(a1)

	@lessthan16:
		bsr.w	AddPoints
		move.b	#id_ExplosionItem,0(a1)			; change object to explosion
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

@points:	dc.w 10, 20, 50, 100				; points awarded div 10

; ===========================================================================

React_Caterkiller:
		bset	#status_onscreen_bit,ost_status(a1)

React_ChkHurt:
		tst.b	(v_invincibility).w			; is Sonic invincible?
		beq.s	@notinvincible				; if not, branch

	@isflashing:
		moveq	#-1,d0
		rts	
; ===========================================================================

	@notinvincible:
		nop	
		tst.w	ost_sonic_flash_time(a0)		; is Sonic flashing?
		bne.s	@isflashing				; if yes, branch
		movea.l	a1,a2

; End of function ReactToItem
; continue straight to HurtSonic

; ---------------------------------------------------------------------------
; Hurting Sonic	subroutine

; input:
;	a2 = address of OST of object hurting Sonic
; ---------------------------------------------------------------------------

HurtSonic:
		tst.b	(v_shield).w				; does Sonic have a shield?
		bne.s	@hasshield				; if yes, branch
		tst.w	(v_rings).w				; does Sonic have any rings?
		beq.w	@norings				; if not, branch

		jsr	(FindFreeObj).l
		bne.s	@hasshield
		move.b	#id_RingLoss,0(a1)			; load bouncing multi rings object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

	@hasshield:
		move.b	#0,(v_shield).w				; remove shield
		move.b	#id_Sonic_Hurt,ost_routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#status_air_bit,ost_status(a0)
		move.w	#-$400,ost_y_vel(a0)			; make Sonic bounce away from the object
		move.w	#-$200,ost_x_vel(a0)
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@isdry					; if not, branch

		move.w	#-$200,ost_y_vel(a0)			; slower bounce
		move.w	#-$100,ost_x_vel(a0)

	@isdry:
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_x_pos(a2),d0
		bcs.s	@isleft					; if Sonic is left of the object, branch
		neg.w	ost_x_vel(a0)				; if Sonic is right of the object, reverse

	@isleft:
		move.w	#0,ost_inertia(a0)
		move.b	#id_Hurt,ost_anim(a0)
		move.w	#120,ost_sonic_flash_time(a0)		; set temp invincible time to 2 seconds
		move.w	#sfx_Death,d0				; load normal damage sound
		cmpi.b	#id_Spikes,(a2)				; was damage caused by spikes?
		bne.s	@sound					; if not, branch
		cmpi.b	#id_Harpoon,(a2)			; was damage caused by LZ harpoon?
		bne.s	@sound					; if not, branch
		move.w	#sfx_SpikeHit,d0			; load spikes damage sound

	@sound:
		jsr	(PlaySound1).l
		moveq	#-1,d0
		rts	
; ===========================================================================

@norings:
		tst.w	(f_debug_enable).w			; is debug mode	cheat on?
		bne.w	@hasshield				; if yes, branch

; ---------------------------------------------------------------------------
; Subroutine to	kill Sonic

; input:
;	a2 = address of OST of object killing Sonic
; ---------------------------------------------------------------------------

KillSonic:
		tst.w	(v_debug_active).w			; is debug mode	active?
		bne.s	@dontdie				; if yes, branch
		move.b	#0,(v_invincibility).w			; remove invincibility
		move.b	#id_Sonic_Death,ost_routine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#status_air_bit,ost_status(a0)
		move.w	#-$700,ost_y_vel(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_inertia(a0)
		move.w	ost_y_pos(a0),$38(a0)
		move.b	#id_Death,ost_anim(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#sfx_Death,d0				; play normal death sound
		cmpi.b	#id_Spikes,(a2)				; check	if you were killed by spikes
		bne.s	@sound
		move.w	#sfx_SpikeHit,d0			; play spikes death sound

	@sound:
		jsr	(PlaySound1).l

	@dontdie:
		moveq	#-1,d0
		rts	
; End of function KillSonic


React_Special:
		move.b	ost_col_type(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#id_col_8x8,d1				; is collision type $CB	?
		beq.s	@caterkiller				; if yes, branch
		cmpi.b	#id_col_20x16,d1			; is collision type $CC ?
		beq.s	@yadrin					; if yes, branch
		cmpi.b	#id_col_8x8_2,d1			; is collision type $D7 ?
		beq.s	@D7orE1					; if yes, branch
		cmpi.b	#id_col_4x32,d1				; is collision type $E1	?
		beq.s	@D7orE1					; if yes, branch
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
