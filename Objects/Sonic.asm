; ---------------------------------------------------------------------------
; Object 01 - Sonic

; spawned by:
;	GM_Level, GM_Ending, VanishSonic
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debug_active).w			; is debug mode	being used?
		beq.s	Sonic_Normal				; if not, branch
		jmp	(DebugMode).l
; ===========================================================================

Sonic_Normal:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================
Sonic_Index:	index *,,2
		ptr Sonic_Main
		ptr Sonic_Control
		ptr Sonic_Hurt
		ptr Sonic_Death
		ptr Sonic_ResetLevel
; ===========================================================================

Sonic_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Sonic_Control next
		move.b	#sonic_height,ost_height(a0)
		move.b	#sonic_width,ost_width(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#tile_sonic,ost_tile(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$18,ost_displaywidth(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	#sonic_max_speed,(v_sonic_max_speed).w	; Sonic's top speed
		move.w	#sonic_acceleration,(v_sonic_acceleration).w ; Sonic's acceleration
		move.w	#sonic_deceleration,(v_sonic_deceleration).w ; Sonic's deceleration

Sonic_Control:	; Routine 2
		tst.w	(f_debug_enable).w			; is debug cheat enabled?
		beq.s	@no_debug				; if not, branch
		btst	#bitB,(v_joypad_press_actual).w		; is button B pressed?
		beq.s	@no_debug				; if not, branch
		move.w	#1,(v_debug_active).w			; change Sonic into a ring/item
		clr.b	(f_lock_controls).w
		rts	
; ===========================================================================

@no_debug:
		tst.b	(f_lock_controls).w			; are controls locked?
		bne.s	@lock					; if yes, branch
		move.w	(v_joypad_hold_actual).w,(v_joypad_hold).w ; enable joypad control

	@lock:
		btst	#0,(v_lock_multi).w			; are controls and position locked?
		bne.s	@lock2					; if yes, branch
		moveq	#0,d0
		move.b	ost_status(a0),d0
		andi.w	#status_air+status_jump,d0		; read status bits 1 and 2
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)			; controls, physics, update position

	@lock2:
		bsr.s	Sonic_Display				; display sprite, update invincibility/speed shoes
		bsr.w	Sonic_RecordPosition			; save position for invincibility stars
		bsr.w	Sonic_Water				; water physics, drowning, splashes
		move.b	(v_angle_right).w,ost_sonic_angle_right(a0)
		move.b	(v_angle_left).w,ost_sonic_angle_left(a0)
		tst.b	(f_water_tunnel_now).w			; is Sonic in a LZ water tunnel?
		beq.s	@no_tunnel				; if not, branch
		tst.b	ost_anim(a0)				; is Sonic using walking animation?
		bne.s	@no_tunnel				; if not, branch
		move.b	ost_anim_restart(a0),ost_anim(a0)	; update animation

	@no_tunnel:
		bsr.w	Sonic_Animate
		tst.b	(v_lock_multi).w			; is object collision disabled?
		bmi.s	@no_collision				; if yes, branch
		jsr	(ReactToItem).l				; run collisions with enemies or anything that uses ost_col_type

	@no_collision:
		bsr.w	Sonic_LoopPlane				; move Sonic to correct plane when in a GHZ/SLZ loop
		bsr.w	Sonic_LoadGfx				; load new gfx when Sonic's frame changes
		rts	

; ===========================================================================
Sonic_Modes:	index *,,2
		ptr Sonic_Mode_Normal				; status_jump_bit = 0; status_air_bit = 0
		ptr Sonic_Mode_Air				; status_jump_bit = 0; status_air_bit = 1
		ptr Sonic_Mode_Roll				; status_jump_bit = 1; status_air_bit = 0
		ptr Sonic_Mode_Jump				; status_jump_bit = 1; status_air_bit = 1
		
; ---------------------------------------------------------------------------
; Music	to play	after invincibility wears off
; ---------------------------------------------------------------------------

MusicList2:
		include_MusicList				; see "Includes\GM_Level.asm"
		zonewarning MusicList2,1
		; The ending doesn't get an entry
		even

; ---------------------------------------------------------------------------
; Subroutine to display Sonic and update invincibility/speed shoes
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	ost_sonic_flash_time(a0),d0		; is Sonic flashing?
		beq.s	@display				; if not, branch
		subq.w	#1,ost_sonic_flash_time(a0)		; decrement timer
		lsr.w	#3,d0					; are any of bits 0-2 set?
		bcc.s	@chkinvincible				; if not, branch (Sonic is invisible every 8th frame)

	@display:
		jsr	(DisplaySprite).l

	@chkinvincible:
		tst.b	(v_invincibility).w			; does Sonic have invincibility?
		beq.s	@chkshoes				; if not, branch
		tst.w	ost_sonic_invincible_time(a0)		; check invinciblity timer
		beq.s	@chkshoes				; if 0, branch
		subq.w	#1,ost_sonic_invincible_time(a0)	; decrement timer
		bne.s	@chkshoes				; if not 0, branch
		tst.b	(f_boss_boundary).w
		bne.s	@removeinvincible			; branch if at a boss
		cmpi.w	#air_alert,(v_air).w			; is air < $C?
		bcs.s	@removeinvincible			; if yes, branch
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#id_SBZ_act3,(v_zone).w			; check if level is SBZ3
		bne.s	@music					; if not, branch
		moveq	#5,d0					; play SBZ music

	@music:
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound0).l				; play normal music

	@removeinvincible:
		move.b	#0,(v_invincibility).w			; cancel invincibility

	@chkshoes:
		tst.b	(v_shoes).w				; does Sonic have speed	shoes?
		beq.s	@exit					; if not, branch
		tst.w	ost_sonic_shoe_time(a0)			; check	time remaining
		beq.s	@exit					; if 0, branch
		subq.w	#1,ost_sonic_shoe_time(a0)		; decrement timer
		bne.s	@exit					; branch if time remains
		move.w	#sonic_max_speed,(v_sonic_max_speed).w	; restore Sonic's speed
		move.w	#sonic_acceleration,(v_sonic_acceleration).w ; restore Sonic's acceleration
		move.w	#sonic_deceleration,(v_sonic_deceleration).w ; restore Sonic's deceleration
		move.b	#0,(v_shoes).w				; cancel speed shoes
		play.w	0, jmp, cmd_Slowdown			; run music at normal speed

	@exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	record Sonic's previous positions for invincibility stars
; ---------------------------------------------------------------------------

Sonic_RecordPosition:
		move.w	(v_sonic_pos_tracker_num).w,d0
		lea	(v_sonic_pos_tracker).w,a1		; address to record data to
		lea	(a1,d0.w),a1				; jump to current index
		move.w	ost_x_pos(a0),(a1)+			; save x/y position
		move.w	ost_y_pos(a0),(a1)+
		addq.b	#4,(v_sonic_pos_tracker_num_low).w	; next index (wraps to 0 after $FC)
		rts

; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

Sonic_Water:
		cmpi.b	#id_LZ,(v_zone).w			; is level LZ?
		beq.s	@islabyrinth				; if yes, branch

	@exit:
		rts	
; ===========================================================================

	@islabyrinth:
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; is Sonic above the water?
		bge.s	@abovewater				; if yes, branch
		bset	#status_underwater_bit,ost_status(a0)	; set underwater flag in status
		bne.s	@exit					; branch if already set

		bsr.w	ResumeMusic
		move.b	#id_DrownCount,(v_ost_bubble).w		; load bubbles object from Sonic's mouth
		move.b	#$81,(v_ost_bubble+ost_subtype).w
		move.w	#sonic_max_speed_water,(v_sonic_max_speed).w ; change Sonic's top speed
		move.w	#sonic_acceleration_water,(v_sonic_acceleration).w ; change Sonic's acceleration
		move.w	#sonic_deceleration_water,(v_sonic_deceleration).w ; change Sonic's deceleration
		asr	ost_x_vel(a0)
		asr	ost_y_vel(a0)
		asr	ost_y_vel(a0)				; slow Sonic
		beq.s	@exit					; branch if Sonic stops moving
		move.b	#id_Splash,(v_ost_splash).w		; load splash object
		play.w	1, jmp, sfx_Splash			; play splash sound
; ===========================================================================

@abovewater:
		bclr	#status_underwater_bit,ost_status(a0)	; clear underwater flag in status
		beq.s	@exit					; branch if already clear

		bsr.w	ResumeMusic
		move.w	#sonic_max_speed,(v_sonic_max_speed).w	; restore Sonic's speed
		move.w	#sonic_acceleration,(v_sonic_acceleration).w ; restore Sonic's acceleration
		move.w	#sonic_deceleration,(v_sonic_deceleration).w ; restore Sonic's deceleration
		asl	ost_y_vel(a0)
		beq.w	@exit
		move.b	#id_Splash,(v_ost_splash).w		; load splash object
		cmpi.w	#-sonic_max_speed_surface,ost_y_vel(a0)
		bgt.s	@belowmaxspeed
		move.w	#-sonic_max_speed_surface,ost_y_vel(a0)	; set maximum speed on leaving water

	@belowmaxspeed:
		play.w	1, jmp, sfx_Splash			; play splash sound

; ---------------------------------------------------------------------------
; Modes	for controlling	Sonic
; ---------------------------------------------------------------------------

Sonic_Mode_Normal:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts	
; ===========================================================================

Sonic_Mode_Air:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@notwater				; if not, branch
		subi.w	#sonic_buoyancy,ost_y_vel(a0)		; apply upward force

	@notwater:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_JumpCollision
		rts	
; ===========================================================================

Sonic_Mode_Roll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts	
; ===========================================================================

Sonic_Mode_Jump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@notwater				; if not, branch
		subi.w	#sonic_buoyancy,ost_y_vel(a0)		; apply upward force

	@notwater:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_JumpCollision
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk/run
; ---------------------------------------------------------------------------

Sonic_Move:
		move.w	(v_sonic_max_speed).w,d6
		move.w	(v_sonic_acceleration).w,d5
		move.w	(v_sonic_deceleration).w,d4
		tst.b	(f_jump_only).w
		bne.w	Sonic_InertiaLR
		tst.w	ost_sonic_lock_time(a0)			; are controls locked?
		bne.w	Sonic_ResetScr				; if yes, branch
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	@notleft				; if not, branch
		bsr.w	Sonic_MoveLeft

	@notleft:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	@notright				; if not, branch
		bsr.w	Sonic_MoveRight

	@notright:
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0					; is Sonic on a	slope?
		bne.w	Sonic_ResetScr				; if yes, branch
		tst.w	ost_inertia(a0)				; is Sonic moving?
		bne.w	Sonic_ResetScr				; if yes, branch
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Wait,ost_anim(a0)			; use "standing" animation
		btst	#status_platform_bit,ost_status(a0)	; is Sonic on a platform?
		beq.s	Sonic_Balance				; if not, branch
		
		moveq	#0,d0
		move.b	ost_sonic_on_obj(a0),d0			; get OST index of platform or object
		lsl.w	#6,d0
		lea	(v_ost_all).w,a1
		lea	(a1,d0.w),a1				; a1 = actual address of OST of object being stood on
		tst.b	ost_status(a1)				; has object been broken?
		bmi.s	Sonic_LookUp				; if yes, branch

		moveq	#0,d1
		move.b	ost_displaywidth(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2					; d2 = width of platform -4
		add.w	ost_x_pos(a0),d1
		sub.w	ost_x_pos(a1),d1			; d1 = Sonic's position - object's position + half object's width
		cmpi.w	#4,d1					; is Sonic within 4px of left edge?
		blt.s	Sonic_BalLeft				; if yes, branch
		cmp.w	d2,d1					; is Sonic within 4px of right edge?
		bge.s	Sonic_BalRight				; if yes, branch
		bra.s	Sonic_LookUp
; ===========================================================================

Sonic_Balance:
		jsr	(FindFloorObj).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp				; branch if drop is not found
		cmpi.b	#3,ost_sonic_angle_right(a0)		; check for edge to the right
		bne.s	Sonic_BalLeftChk			; branch if not found

	Sonic_BalRight:
		bclr	#status_xflip_bit,ost_status(a0)
		bra.s	Sonic_DoBal
; ===========================================================================

	Sonic_BalLeftChk:
		cmpi.b	#3,ost_sonic_angle_left(a0)		; check for edge to the left
		bne.s	Sonic_LookUp				; branch if not found

	Sonic_BalLeft:
		bset	#status_xflip_bit,ost_status(a0)

	Sonic_DoBal:
		move.b	#id_Balance,ost_anim(a0)		; use "balancing" animation
		bra.s	Sonic_ResetScr
; ===========================================================================

Sonic_LookUp:
		btst	#bitUp,(v_joypad_hold).w		; is up being pressed?
		beq.s	Sonic_Duck				; if not, branch
		move.b	#id_LookUp,ost_anim(a0)			; use "looking up" animation
		cmpi.w	#camera_y_shift_up,(v_camera_y_shift).w	; $C8
		beq.s	Sonic_ScrOk				; branch if screen is at max y scroll
		addq.w	#2,(v_camera_y_shift).w			; scroll up 2px
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_Duck:
		btst	#bitDn,(v_joypad_hold).w		; is down being pressed?
		beq.s	Sonic_ResetScr				; if not, branch
		move.b	#id_Duck,ost_anim(a0)			; use "ducking" animation
		cmpi.w	#camera_y_shift_down,(v_camera_y_shift).w ; 8
		beq.s	Sonic_ScrOk				; branch if screen is at min y scroll
		subq.w	#2,(v_camera_y_shift).w			; scroll down 2px
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_ResetScr:
		cmpi.w	#camera_y_shift_default,(v_camera_y_shift).w ; is screen in its default position? ($60)
		beq.s	Sonic_ScrOk				; if yes, branch
		bcc.s	Sonic_HighScr				; branch if screen is higher
		addq.w	#4,(v_camera_y_shift).w			; move screen back 4px to default (actually 2px because of next line)

	Sonic_HighScr:
		subq.w	#2,(v_camera_y_shift).w			; move screen back 2px to default

	Sonic_ScrOk:

Sonic_Inertia:
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0				; is left/right	pressed?
		bne.s	Sonic_InertiaLR				; if yes, branch
		move.w	ost_inertia(a0),d0			; get Sonic's inertia
		beq.s	Sonic_InertiaLR				; if 0, branch
		bmi.s	@inertia_neg				; if negative, branch
		sub.w	d5,d0					; subtract acceleration
		bcc.s	@inertia_not_0				; branch if inertia is larger
		move.w	#0,d0

	@inertia_not_0:
		move.w	d0,ost_inertia(a0)			; update inertia
		bra.s	Sonic_InertiaLR
; ===========================================================================

	@inertia_neg:
		add.w	d5,d0
		bcc.s	@inertia_not_0_
		move.w	#0,d0

	@inertia_not_0_:
		move.w	d0,ost_inertia(a0)			; update inertia

Sonic_InertiaLR:
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		muls.w	ost_inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)
		muls.w	ost_inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)

Sonic_StopAtWall:
		move.b	ost_angle(a0),d0
		addi.b	#$40,d0
		bmi.s	@exit					; branch if angle is $40-$BF
		move.b	#$40,d1					; d1 = 90-degree clockwise rotation
		tst.w	ost_inertia(a0)				; get inertia
		beq.s	@exit					; branch if 0
		bmi.s	@neginertia				; branch if negative
		neg.w	d1					; d1 = 90-degree anticlockwise rotation

	@neginertia:
		move.b	ost_angle(a0),d0
		add.b	d1,d0					; d0 = angle with 90-degree rotation
		move.w	d0,-(sp)				; store in stack
		bsr.w	Sonic_CalcRoomAhead			; get distance to wall ahead
		move.w	(sp)+,d0				; restore from stack
		tst.w	d1					; has Sonic hit a wall?
		bpl.s	@exit					; if not, branch
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	@wall_below				; branch if wall is below
		cmpi.b	#$40,d0
		beq.s	@wall_left				; branch if wall is left
		cmpi.b	#$80,d0
		beq.s	@wall_above				; branch if wall is above
		
	@wall_right:
		add.w	d1,ost_x_vel(a0)
		bset	#status_pushing_bit,ost_status(a0)	; start pushing when Sonic hits a wall
		move.w	#0,ost_inertia(a0)			; stop Sonic moving
		rts	
; ===========================================================================

	@wall_above:
		sub.w	d1,ost_y_vel(a0)
		rts	
; ===========================================================================

	@wall_left:
		sub.w	d1,ost_x_vel(a0)
		bset	#status_pushing_bit,ost_status(a0)
		move.w	#0,ost_inertia(a0)
		rts	
; ===========================================================================

	@wall_below:
		add.w	d1,ost_y_vel(a0)

@exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk to the left
; ---------------------------------------------------------------------------

Sonic_MoveLeft:
		move.w	ost_inertia(a0),d0
		beq.s	@inertia0				; branch if inertia is 0
		bpl.s	@inertia_pos				; branch if inertia is positive

	@inertia0:
		bset	#status_xflip_bit,ost_status(a0)	; make Sonic face left
		bne.s	@alreadyleft				; branch if already facing left
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)		; restart animation

	@alreadyleft:
		sub.w	d5,d0					; d0 = inertia minus acceleration
		move.w	d6,d1					; d1 = max speed
		neg.w	d1					; negative for left direction
		cmp.w	d1,d0
		bgt.s	@below_max				; branch if Sonic is moving below max speed
		move.w	d1,d0					; apply speed limit

	@below_max:
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		rts	
; ===========================================================================

@inertia_pos:
		sub.w	d4,d0					; d0 = inertia minus deceleration
		bcc.s	@inertia_pos_				; branch if inertia is still positive
		move.w	#-$80,d0

	@inertia_pos_:
		move.w	d0,ost_inertia(a0)
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	@exit					; branch if Sonic is running on a wall or ceiling
		cmpi.w	#$400,d0
		blt.s	@exit
		move.b	#id_Stop,ost_anim(a0)			; use "stopping" animation
		bclr	#status_xflip_bit,ost_status(a0)	; make Sonic face right
		play.w	1, jsr, sfx_Skid			; play stopping sound

	@exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk to the right
; ---------------------------------------------------------------------------

Sonic_MoveRight:
		move.w	ost_inertia(a0),d0
		bmi.s	@inertia_neg				; branch if inertia is negative
		bclr	#status_xflip_bit,ost_status(a0)	; make Sonic face right
		beq.s	@alreadyright				; branch if already facing right
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)		; restart animation

	@alreadyright:
		add.w	d5,d0					; d0 = inertia plus acceleration
		cmp.w	d6,d0
		blt.s	@below_max				; branch if Sonic is moving below max speed
		move.w	d6,d0					; apply speed limit

	@below_max:
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		rts	
; ===========================================================================

@inertia_neg:
		add.w	d4,d0					; d0 = inertia plus deceleration
		bcc.s	@inertia_neg_				; branch if inertia is still negative
		move.w	#$80,d0

	@inertia_neg_:
		move.w	d0,ost_inertia(a0)
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	@exit					; branch if Sonic is running on a wall or ceiling
		cmpi.w	#-$400,d0
		bgt.s	@exit
		move.b	#id_Stop,ost_anim(a0)			; use "stopping" animation
		bset	#status_xflip_bit,ost_status(a0)	; make Sonic face left
		play.w	1, jsr, sfx_Skid			; play stopping sound

	@exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's speed as he rolls
; ---------------------------------------------------------------------------

Sonic_RollSpeed:
		move.w	(v_sonic_max_speed).w,d6
		asl.w	#1,d6
		move.w	(v_sonic_acceleration).w,d5
		asr.w	#1,d5
		move.w	(v_sonic_deceleration).w,d4
		asr.w	#2,d4
		tst.b	(f_jump_only).w				; are controls except jump locked?
		bne.w	@update_speed				; if yes, branch
		tst.w	ost_sonic_lock_time(a0)			; are controls temporarily locked?
		bne.s	@notright				; is yes, branch

		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	@notleft				; if not, branch
		bsr.w	Sonic_RollLeft

	@notleft:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	@notright				; if not, branch
		bsr.w	Sonic_RollRight

	@notright:
		move.w	ost_inertia(a0),d0
		beq.s	@chk_stop				; branch if inertia is 0
		bmi.s	@inertia_neg				; branch if inertia is negative

		sub.w	d5,d0					; d0 = inertia minus acceleration
		bcc.s	@inertia_pos				; branch if inertia is still positive
		move.w	#0,d0

	@inertia_pos:
		move.w	d0,ost_inertia(a0)
		bra.s	@chk_stop
; ===========================================================================

@inertia_neg:
		add.w	d5,d0					; d0 = inertia plus acceleration
		bcc.s	@inertia_neg_				; branch if inertia is still negative
		move.w	#0,d0

	@inertia_neg_:
		move.w	d0,ost_inertia(a0)			; update inertia

@chk_stop:
		tst.w	ost_inertia(a0)				; is Sonic moving?
		bne.s	@update_speed				; if yes, branch
		bclr	#status_jump_bit,ost_status(a0)
		move.b	#sonic_height,ost_height(a0)
		move.b	#sonic_width,ost_width(a0)
		move.b	#id_Wait,ost_anim(a0)			; use "standing" animation
		subq.w	#sonic_height-sonic_height_roll,ost_y_pos(a0)

@update_speed:
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l				; convert angle to sine/cosine
		muls.w	ost_inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)			; update y speed
		muls.w	ost_inertia(a0),d1
		asr.l	#8,d1
		cmpi.w	#sonic_max_speed_roll,d1		; is Sonic rolling at max speed?
		ble.s	@below_max				; if not, branch
		move.w	#sonic_max_speed_roll,d1		; set max

	@below_max:
		cmpi.w	#-sonic_max_speed_roll,d1
		bge.s	@below_max_
		move.w	#-sonic_max_speed_roll,d1

	@below_max_:
		move.w	d1,ost_x_vel(a0)			; update x speed
		bra.w	Sonic_StopAtWall

; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's speed when rolling and moving left
; ---------------------------------------------------------------------------

Sonic_RollLeft:
		move.w	ost_inertia(a0),d0
		beq.s	@no_change				; branch if inertia is 0
		bpl.s	@inertia_pos				; branch if inertia is positive

	@no_change:
		bset	#status_xflip_bit,ost_status(a0)	; face Sonic left
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		rts	
; ===========================================================================

@inertia_pos:
		sub.w	d4,d0					; d0 = inertia minus deceleration
		bcc.s	@inertia_pos_				; branch if inertia is still positive
		move.w	#-$80,d0

	@inertia_pos_:
		move.w	d0,ost_inertia(a0)			; update inertia
		rts

; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's speed when rolling and moving right
; ---------------------------------------------------------------------------

Sonic_RollRight:
		move.w	ost_inertia(a0),d0
		bmi.s	@inertia_neg				; branch if inertia is negative

		bclr	#status_xflip_bit,ost_status(a0)	; face Sonic left
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		rts	
; ===========================================================================

@inertia_neg:
		add.w	d4,d0					; d0 = inertia plus deceleration
		bcc.s	@inertia_neg_				; branch if inertia is still negative
		move.w	#$80,d0

	@inertia_neg_:
		move.w	d0,ost_inertia(a0)			; update inertia
		rts

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's direction while jumping
; ---------------------------------------------------------------------------

Sonic_JumpDirection:
		move.w	(v_sonic_max_speed).w,d6
		move.w	(v_sonic_acceleration).w,d5
		asl.w	#1,d5
		btst	#status_rolljump_bit,ost_status(a0)	; is Sonic jumping while rolling?
		bne.s	@chk_camera				; if yes, branch
		
		move.w	ost_x_vel(a0),d0
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	@not_left				; if not, branch

		bset	#status_xflip_bit,ost_status(a0)	; face Sonic left
		sub.w	d5,d0					; d0 = speed minus acceleration
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0					; does new speed exceed max?
		bgt.s	@not_left				; if not, branch
		move.w	d1,d0					; set max speed

	@not_left:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	@update_speed				; if not, branch

		bclr	#status_xflip_bit,ost_status(a0)	; face Sonic right
		add.w	d5,d0					; d0 = speed plus acceleration
		cmp.w	d6,d0					; does new speed exceed max?
		blt.s	@update_speed				; if not, branch
		move.w	d6,d0					; set max speed

	@update_speed:
		move.w	d0,ost_x_vel(a0)			; update x speed

@chk_camera:
		cmpi.w	#camera_y_shift_default,(v_camera_y_shift).w ; is the screen in its default position? ($60)
		beq.s	@camera_ok				; if yes, branch
		bcc.s	@camera_high				; branch if higher
		addq.w	#4,(v_camera_y_shift).w

	@camera_high:
		subq.w	#2,(v_camera_y_shift).w			; move camera back 2px

	@camera_ok:
		cmpi.w	#-$400,ost_y_vel(a0)			; is Sonic moving faster than -$400 upwards?
		bcs.s	@exit					; if yes, branch
		move.w	ost_x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1					; d1 = x speed / 32
		beq.s	@exit					; branch if 0
		bmi.s	@moving_left				; branch if moving left
		sub.w	d1,d0					; subtract d1 from x speed
		bcc.s	@speed_pos
		move.w	#0,d0

	@speed_pos:
		move.w	d0,ost_x_vel(a0)			; apply air drag
		rts	
; ===========================================================================

@moving_left:
		sub.w	d1,d0					; subtract d1 from x speed
		bcs.s	@speed_neg
		move.w	#0,d0

	@speed_neg:
		move.w	d0,ost_x_vel(a0)			; apply air drag

@exit:
		rts

; ---------------------------------------------------------------------------
; Unused subroutine to squash Sonic against the ceiling
; ---------------------------------------------------------------------------

		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	@dont_squash				; branch if Sonic is running on a wall or ceiling
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	@dont_squash				; branch if there's space between Sonic and the ceiling
		move.w	#0,ost_inertia(a0)			; stop Sonic moving
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_y_vel(a0)
		move.b	#id_Warp3,ost_anim(a0)			; use "warping" animation

	@dont_squash:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	prevent	Sonic leaving the boundaries of	a level
; ---------------------------------------------------------------------------

Sonic_LevelBound:
		move.l	ost_x_pos(a0),d1			; get x pos including subpixel
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0					; d0 = x speed * $100
		add.l	d0,d1					; add d0 to x pos
		swap	d1					; swap x pos and x subpixel words
		move.w	(v_boundary_left).w,d0
		addi.w	#16,d0
		cmp.w	d1,d0					; has Sonic touched the	left boundary?
		bhi.s	@sides					; if yes, branch
		move.w	(v_boundary_right).w,d0
		addi.w	#296,d0
		tst.b	(f_boss_boundary).w			; is screen locked at boss?
		bne.s	@screenlocked				; if yes, branch
		addi.w	#64,d0

	@screenlocked:
		cmp.w	d1,d0					; has Sonic touched the	right boundary?
		bls.s	@sides					; if yes, branch

	@chkbottom:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#224,d0
		cmp.w	ost_y_pos(a0),d0			; has Sonic touched the bottom boundary?
		blt.s	@bottom					; if yes, branch
		rts	
; ===========================================================================

@bottom:
		cmpi.w	#id_SBZ_act2,(v_zone).w			; is level SBZ2 ?
		bne.w	KillSonic				; if not, kill Sonic
		cmpi.w	#$2000,(v_ost_player+ost_x_pos).w	; has Sonic reached $2000 on x axis?
		bcs.w	KillSonic				; if not, kill Sonic
		clr.b	(v_last_lamppost).w			; clear	lamppost counter
		move.w	#1,(f_restart).w			; restart the level
		move.w	#id_SBZ_act3,(v_zone).w			; set level to SBZ3 (LZ4)
		rts	
; ===========================================================================

@sides:
		move.w	d0,ost_x_pos(a0)			; align to boundary
		move.w	#0,ost_x_sub(a0)
		move.w	#0,ost_x_vel(a0)			; stop Sonic moving
		move.w	#0,ost_inertia(a0)
		bra.s	@chkbottom

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

Sonic_Roll:
		tst.b	(f_jump_only).w				; are controls except jump locked?
		bne.s	@noroll					; if yes, branch
		move.w	ost_inertia(a0),d0
		bpl.s	@inertia_pos
		neg.w	d0					; make inertia positive

	@inertia_pos:
		cmpi.w	#sonic_min_speed_roll,d0		; is Sonic moving at $80 speed or faster?
		bcs.s	@noroll					; if not, branch
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0				; is left/right	being pressed?
		bne.s	@noroll					; if yes, branch
		btst	#bitDn,(v_joypad_hold).w		; is down being pressed?
		bne.s	Sonic_ChkRoll				; if yes, branch

	@noroll:
		rts	
; ===========================================================================

Sonic_ChkRoll:
		btst	#status_jump_bit,ost_status(a0)		; is Sonic already rolling or jumping?
		beq.s	@roll					; if not, branch
		rts	
; ===========================================================================

@roll:
		bset	#status_jump_bit,ost_status(a0)		; set rolling/jumping flag
		move.b	#sonic_height_roll,ost_height(a0)
		move.b	#sonic_width_roll,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		addq.w	#sonic_height-sonic_height_roll,ost_y_pos(a0)
		play.w	1, jsr, sfx_Roll			; play rolling sound
		tst.w	ost_inertia(a0)
		bne.s	@ismoving
		move.w	#$200,ost_inertia(a0)			; set inertia if 0

	@ismoving:
		rts

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

Sonic_Jump:
		move.b	(v_joypad_press).w,d0
		andi.b	#btnABC,d0				; is A, B or C pressed?
		beq.w	@no_jump				; if not, branch
		moveq	#0,d0
		move.b	ost_angle(a0),d0			; get floor angle
		addi.b	#$80,d0					; invert it
		bsr.w	Sonic_CalcHeadroom
		cmpi.w	#6,d1					; is there room to jump?
		blt.w	@no_jump				; if not, branch
		move.w	#sonic_jump_power,d2			; jump strength
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@not_underwater				; if not, branch
		move.w	#sonic_jump_power_water,d2		; underwater jump strength

	@not_underwater:
		moveq	#0,d0
		move.b	ost_angle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,ost_x_vel(a0)			; make Sonic jump
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,ost_y_vel(a0)			; make Sonic jump
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		addq.l	#4,sp
		move.b	#1,ost_sonic_jump(a0)
		clr.b	ost_sonic_sbz_disc(a0)
		play.w	1, jsr, sfx_Jump			; play jumping sound
		move.b	#sonic_height,ost_height(a0)
		move.b	#sonic_width,ost_width(a0)
		btst	#status_jump_bit,ost_status(a0)		; is Sonic rolling?
		bne.s	@is_rolling				; if yes, branch
		move.b	#sonic_height_roll,ost_height(a0)
		move.b	#sonic_width_roll,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "jumping" animation
		bset	#status_jump_bit,ost_status(a0)
		addq.w	#sonic_height-sonic_height_roll,ost_y_pos(a0)

	@no_jump:
		rts	
; ===========================================================================

@is_rolling:
		bset	#status_rolljump_bit,ost_status(a0)	; set flag for jumping while rolling
		rts

; ---------------------------------------------------------------------------
; Subroutine limiting Sonic's jump height when A/B/C is released
; ---------------------------------------------------------------------------

Sonic_JumpHeight:
		tst.b	ost_sonic_jump(a0)			; is Sonic jumping?
		beq.s	@not_jumping				; if not, branch
		move.w	#-sonic_jump_release,d1			; jump power after A/B/C is released
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@not_underwater				; if not, branch
		move.w	#-sonic_jump_release_water,d1

	@not_underwater:
		cmp.w	ost_y_vel(a0),d1
		ble.s	@keep_speed				; branch if jump power is less than post-A/B/C value
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnABC,d0				; is A, B or C pressed?
		bne.s	@keep_speed				; if yes, branch
		move.w	d1,ost_y_vel(a0)			; update y speed with smaller jump power

	@keep_speed:
		rts	
; ===========================================================================

@not_jumping:							; unused?
		cmpi.w	#-$FC0,ost_y_vel(a0)
		bge.s	@below_max
		move.w	#-$FC0,ost_y_vel(a0)

	@below_max:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	slow Sonic walking up a	slope
; ---------------------------------------------------------------------------

Sonic_SlopeResist:
		move.b	ost_angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	@no_change				; branch if Sonic is on ceiling
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l				; convert angle to sine
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	ost_inertia(a0)
		beq.s	@no_change				; branch if Sonic has no inertia
		bmi.s	@inertia_neg				; branch if Sonic has negative inertia
		tst.w	d0
		beq.s	@no_change_
		add.w	d0,ost_inertia(a0)			; update Sonic's inertia

	@no_change_:
		rts	
; ===========================================================================

@inertia_neg:
		add.w	d0,ost_inertia(a0)

@no_change:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope	while he's rolling
; ---------------------------------------------------------------------------

Sonic_RollRepel:
		move.b	ost_angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	@no_change				; branch if Sonic is on ceiling
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l				; convert angle to sine
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	ost_inertia(a0)
		bmi.s	@inertia_neg				; branch if Sonic has negative inertia
		tst.w	d0
		bpl.s	@sine_pos				; branch sine is positive
		asr.l	#2,d0

	@sine_pos:
		add.w	d0,ost_inertia(a0)			; update Sonic's inertia
		rts	
; ===========================================================================

@inertia_neg:
		tst.w	d0
		bmi.s	@sine_neg				; branch sine is negative
		asr.l	#2,d0

	@sine_neg:
		add.w	d0,ost_inertia(a0)			; update Sonic's inertia

@no_change:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope
; ---------------------------------------------------------------------------

Sonic_SlopeRepel:
		nop	
		tst.b	ost_sonic_sbz_disc(a0)			; is Sonic on a SBZ disc?
		bne.s	@exit					; if yes, branch
		tst.w	ost_sonic_lock_time(a0)			; are controls temporarily locked?
		bne.s	@locked					; if yes, branch
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	@exit					; branch if slope is 0 +-$20
		move.w	ost_inertia(a0),d0
		bpl.s	@inertia_pos				; branch if inertia is positive
		neg.w	d0

	@inertia_pos:
		cmpi.w	#sonic_min_speed_slope,d0
		bcc.s	@exit					; branch if inertia is at least $280
		clr.w	ost_inertia(a0)				; set Sonic's inertia to 0
		bset	#status_air_bit,ost_status(a0)
		move.w	#30,ost_sonic_lock_time(a0)		; lock controls for half a second

	@exit:
		rts	
; ===========================================================================

@locked:
		subq.w	#1,ost_sonic_lock_time(a0)		; decrement timer
		rts

; ---------------------------------------------------------------------------
; Subroutine to	return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

Sonic_JumpAngle:
		move.b	ost_angle(a0),d0			; get Sonic's angle
		beq.s	@exit					; branch if 0
		bpl.s	@angle_pos				; branch if 1-$7F

		addq.b	#2,d0					; increase angle
		bcc.s	@angle_neg				; branch if $80-$FF
		moveq	#0,d0					; reset to 0

	@angle_neg:
		bra.s	@update
; ===========================================================================

@angle_pos:
		subq.b	#2,d0					; decrease angle
		bcc.s	@update					; branch if 0-$7F
		moveq	#0,d0					; reset to 0

@update:
		move.b	d0,ost_angle(a0)			; update angle

@exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with floor/walls after jumping/falling
; ---------------------------------------------------------------------------

Sonic_JumpCollision:
		move.w	ost_x_vel(a0),d1
		move.w	ost_y_vel(a0),d2
		jsr	(CalcAngle).l				; convert x/y speed to angle of direction
		move.b	d0,(v_sonic_angle1_unused).w
		subi.b	#$20,d0
		move.b	d0,(v_sonic_angle2_unused).w
		andi.b	#$C0,d0
		move.b	d0,(v_sonic_angle3_unused).w
		cmpi.b	#$40,d0
		beq.w	Sonic_JumpCollision_Left		; branch if Sonic is moving left +-45 degrees
		cmpi.b	#$80,d0
		beq.w	Sonic_JumpCollision_Up			; branch if Sonic is moving up +-45 degrees
		cmpi.b	#$C0,d0
		beq.w	Sonic_JumpCollision_Right		; branch if Sonic is moving right +-45 degrees

		; Sonic is moving down +-45 degrees
		bsr.w	Sonic_FindWallLeft_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallleft				; branch if Sonic hasn't hit left wall
		sub.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving left

	@no_wallleft:
		bsr.w	Sonic_FindWallRight_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallright				; branch if Sonic hasn't hit right wall
		add.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving right

	@no_wallright:
		bsr.w	Sonic_FindFloor
		move.b	d1,(v_sonic_floor_dist_unused).w
		tst.w	d1
		bpl.s	@exit					; branch if Sonic hasn't hit floor
		move.b	ost_y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	@on_floor
		cmp.b	d2,d0
		blt.s	@exit

	@on_floor:
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.b	d3,ost_angle(a0)			; save floor angle
		bsr.w	Sonic_ResetOnFloor			; reset Sonic's flags
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	@steep					; branch if floor is steep slope (over 45 degrees)
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	@flat					; branch if floor is flat (or almost)
		asr	ost_y_vel(a0)
		bra.s	@y_to_inertia
; ===========================================================================

@flat:
		move.w	#0,ost_y_vel(a0)			; stop Sonic falling
		move.w	ost_x_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

@steep:
		move.w	#0,ost_x_vel(a0)			; stop Sonic moving left/right
		cmpi.w	#$FC0,ost_y_vel(a0)
		ble.s	@y_to_inertia				; branch if y speed is below max
		move.w	#$FC0,ost_y_vel(a0)			; set max speed

@y_to_inertia:
		move.w	ost_y_vel(a0),ost_inertia(a0)
		tst.b	d3
		bpl.s	@exit
		neg.w	ost_inertia(a0)

@exit:
		rts	
; ===========================================================================

Sonic_JumpCollision_Left:
		bsr.w	Sonic_FindWallLeft_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallleft				; branch if Sonic hasn't hit left wall
		sub.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving left
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

@no_wallleft:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	@no_ceiling				; branch if Sonic hasn't hit ceiling
		sub.w	d1,ost_y_pos(a0)			; align to ceiling
		tst.w	ost_y_vel(a0)
		bpl.s	@moving_down				; branch if Sonic is moving down
		move.w	#0,ost_y_vel(a0)			; stop moving up

	@moving_down:
		rts	
; ===========================================================================

@no_ceiling:
		tst.w	ost_y_vel(a0)
		bmi.s	@exit					; branch if Sonic is moving up
		bsr.w	Sonic_FindFloor
		tst.w	d1
		bpl.s	@exit					; branch if Sonic hasn't hit the floor
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.b	d3,ost_angle(a0)			; save floor angle
		bsr.w	Sonic_ResetOnFloor			; reset Sonic's flags
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		move.w	#0,ost_y_vel(a0)
		move.w	ost_x_vel(a0),ost_inertia(a0)

	@exit:
		rts	
; ===========================================================================

Sonic_JumpCollision_Up:
		bsr.w	Sonic_FindWallLeft_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallleft				; branch if Sonic hasn't hit left wall
		sub.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving left

	@no_wallleft:
		bsr.w	Sonic_FindWallRight_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallright				; branch if Sonic hasn't hit right wall
		add.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving right

	@no_wallright:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	@exit					; branch if Sonic hasn't hit ceiling
		sub.w	d1,ost_y_pos(a0)			; align to ceiling
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	@steep					; branch if ceiling is almost-vertical slope
		move.w	#0,ost_y_vel(a0)
		rts	
; ===========================================================================

@steep:
		move.b	d3,ost_angle(a0)			; save floor angle
		bsr.w	Sonic_ResetOnFloor			; reset Sonic's flags
		move.w	ost_y_vel(a0),ost_inertia(a0)
		tst.b	d3
		bpl.s	@exit
		neg.w	ost_inertia(a0)

@exit:
		rts	
; ===========================================================================

Sonic_JumpCollision_Right:
		bsr.w	Sonic_FindWallRight_Quick_UsePos
		tst.w	d1
		bpl.s	@no_wallright				; branch if Sonic hasn't hit right wall
		add.w	d1,ost_x_pos(a0)			; align to wall
		move.w	#0,ost_x_vel(a0)			; stop moving right
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

@no_wallright:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	@no_ceiling				; branch if Sonic hasn't hit ceiling
		sub.w	d1,ost_y_pos(a0)			; align to ceiling
		tst.w	ost_y_vel(a0)
		bpl.s	@moving_down				; branch if Sonic is moving down
		move.w	#0,ost_y_vel(a0)			; stop moving up

	@moving_down:
		rts	
; ===========================================================================

@no_ceiling:
		tst.w	ost_y_vel(a0)
		bmi.s	@exit					; branch if Sonic is moving up
		bsr.w	Sonic_FindFloor
		tst.w	d1
		bpl.s	@exit					; branch if Sonic hasn't hit the floor
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.b	d3,ost_angle(a0)			; save floor angle
		bsr.w	Sonic_ResetOnFloor			; reset Sonic's flags
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		move.w	#0,ost_y_vel(a0)
		move.w	ost_x_vel(a0),ost_inertia(a0)

@exit:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	reset Sonic's mode when he lands on the floor
; ---------------------------------------------------------------------------

Sonic_ResetOnFloor:
		btst	#status_rolljump_bit,ost_status(a0)	; is Sonic jumping while rolling?
		beq.s	@no_rolljump				; if not, branch
		nop	
		nop	
		nop	

	@no_rolljump:
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_air_bit,ost_status(a0)
		bclr	#status_rolljump_bit,ost_status(a0)
		btst	#status_jump_bit,ost_status(a0)		; is Sonic jumping/rolling?
		beq.s	@no_jump				; if not, branch
		bclr	#status_jump_bit,ost_status(a0)
		move.b	#sonic_height,ost_height(a0)
		move.b	#sonic_width,ost_width(a0)
		move.b	#id_Walk,ost_anim(a0)			; use running/walking animation
		subq.w	#sonic_height-sonic_height_roll,ost_y_pos(a0)

	@no_jump:
		move.b	#0,ost_sonic_jump(a0)
		move.w	#0,(v_enemy_combo).w			; reset counter for points for breaking multiple enemies
		rts

; ---------------------------------------------------------------------------
; Sonic	when he	gets hurt
; ---------------------------------------------------------------------------

Sonic_Hurt:	; Routine 4
		jsr	(SpeedToPos).l				; update position
		addi.w	#$30,ost_y_vel(a0)			; apply gravity
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	@not_underwater				; branch if Sonic isn't underwater
		subi.w	#$20,ost_y_vel(a0)			; apply less gravity (net $10)

	@not_underwater:
		bsr.w	Sonic_HurtStop
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jmp	(DisplaySprite).l

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic falling after he's been hurt
; ---------------------------------------------------------------------------

Sonic_HurtStop:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#224,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.w	KillSonic				; branch if Sonic falls below level boundary
		bsr.w	Sonic_JumpCollision			; floor/wall collision
		btst	#status_air_bit,ost_status(a0)
		bne.s	@no_floor				; branch if Sonic is still in the air
		moveq	#0,d0
		move.w	d0,ost_y_vel(a0)			; stop moving
		move.w	d0,ost_x_vel(a0)
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0)			; use walking animation
		subq.b	#2,ost_routine(a0)			; goto Sonic_Control next
		move.w	#sonic_flash_time,ost_sonic_flash_time(a0) ; set invincibility timer to 2 seconds

	@no_floor:
		rts

; ---------------------------------------------------------------------------
; Sonic	when he	dies
; ---------------------------------------------------------------------------

Sonic_Death:	; Routine 6
		bsr.w	GameOver
		jsr	(ObjectFall).l				; apply gravity and update position
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jmp	(DisplaySprite).l

; ---------------------------------------------------------------------------
; Subroutine to check for game over
; ---------------------------------------------------------------------------

GameOver:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#224+32,d0
		cmp.w	ost_y_pos(a0),d0			; has Sonic fallen more than 32px off screen after dying
		bcc.w	@exit					; if not, branch
		move.w	#-$38,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)			; goto Sonic_ResetLevel next
		clr.b	(f_hud_time_update).w			; stop time counter
		addq.b	#1,(f_hud_lives_update).w		; update lives counter
		subq.b	#1,(v_lives).w				; subtract 1 from number of lives
		bne.s	@lives_remain				; branch if some lives are remaining
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_gameover1).w	; load GAME object
		move.b	#id_GameOverCard,(v_ost_gameover2).w	; load OVER object
		move.b	#id_frame_gameover_over,(v_ost_gameover2+ost_frame).w ; set OVER object to correct frame
		clr.b	(f_time_over).w

@music_gfx:
		play.w	0, jsr, mus_GameOver			; play game over music
		moveq	#id_PLC_GameOver,d0
		jmp	(AddPLC).l				; load game over patterns
; ===========================================================================

@lives_remain:
		move.w	#60,ost_sonic_restart_time(a0)		; set time delay to 1 second
		tst.b	(f_time_over).w				; is TIME OVER tag set?
		beq.s	@exit					; if not, branch
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_gameover1).w	; load TIME object
		move.b	#id_GameOverCard,(v_ost_gameover2).w	; load OVER object
		move.b	#id_frame_gameover_time,(v_ost_gameover1+ost_frame).w
		move.b	#id_frame_gameover_over2,(v_ost_gameover2+ost_frame).w
		bra.s	@music_gfx
; ===========================================================================

@exit:
		rts

; ---------------------------------------------------------------------------
; Sonic	when the level is restarted
; ---------------------------------------------------------------------------

Sonic_ResetLevel:
		; Routine 8
		tst.w	ost_sonic_restart_time(a0)
		beq.s	@exit					; branch if timer is on 0
		subq.w	#1,ost_sonic_restart_time(a0)		; decrement timer
		bne.s	@exit					; branch if timer isn't on 0
		move.w	#1,(f_restart).w			; restart the level

	@exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's plane setting when in a loop (GHZ/SLZ)
; ---------------------------------------------------------------------------

Sonic_LoopPlane:
		cmpi.b	#id_SLZ,(v_zone).w			; is level SLZ ?
		beq.s	@isstarlight				; if yes, branch
		tst.b	(v_zone).w				; is level GHZ ?
		bne.w	@noloops				; if not, branch

	@isstarlight:
		move.w	ost_y_pos(a0),d0
		lsr.w	#1,d0					; divide y pos by 2 (because layout alternates between level and bg lines)
		andi.w	#$380,d0				; read only high byte of y pos (because each level tile is 256px tall)
		move.b	ost_x_pos(a0),d1
		andi.w	#$7F,d1					; read only low byte of x pos
		add.w	d1,d0					; combine for position within layout
		lea	(v_level_layout).w,a1
		move.b	(a1,d0.w),d1				; d1 is	the 256x256 tile Sonic is currently on

		cmp.b	(v_256x256_with_tunnel_1).w,d1		; is Sonic on a "roll tunnel" tile?
		beq.w	Sonic_ChkRoll				; if yes, branch
		cmp.b	(v_256x256_with_tunnel_2).w,d1
		beq.w	Sonic_ChkRoll

		cmp.b	(v_256x256_with_loop_1).w,d1		; is Sonic on a loop tile?
		beq.s	@chkifleft				; if yes, branch
		cmp.b	(v_256x256_with_loop_2).w,d1
		beq.s	@chkifinair
		bclr	#render_behind_bit,ost_render(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifinair:
		btst	#status_air_bit,ost_status(a0)		; is Sonic in the air?
		beq.s	@chkifleft				; if not, branch

		bclr	#render_behind_bit,ost_render(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifleft:
		move.w	ost_x_pos(a0),d2
		cmpi.b	#$2C,d2
		bcc.s	@chkifright				; branch if Sonic is > 44px from left edge of tile

		bclr	#render_behind_bit,ost_render(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifright:
		cmpi.b	#$E0,d2
		bcs.s	@chkangle1				; branch if Sonic is > 32px from right edge of tile

		bset	#render_behind_bit,ost_render(a0)	; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle1:
		btst	#render_behind_bit,ost_render(a0)	; is Sonic on low plane?
		bne.s	@chkangle2				; if yes, branch

		move.b	ost_angle(a0),d1
		beq.s	@done
		cmpi.b	#$80,d1
		bhi.s	@done					; branch if Sonic is on right surface of loop
		bset	#render_behind_bit,ost_render(a0)	; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle2:
		move.b	ost_angle(a0),d1
		cmpi.b	#$80,d1
		bls.s	@done					; branch if Sonic is on left surface of loop
		bclr	#render_behind_bit,ost_render(a0)	; send Sonic to high plane

@noloops:
@done:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	animate	Sonic's sprites
; ---------------------------------------------------------------------------

Sonic_Animate:
		lea	(Ani_Sonic).l,a1
		moveq	#0,d0
		move.b	ost_anim(a0),d0
		cmp.b	ost_anim_restart(a0),d0			; is animation set to restart?
		beq.s	@do					; if not, branch
		move.b	d0,ost_anim_restart(a0)			; set to "no restart"
		move.b	#0,ost_anim_frame(a0)			; reset animation
		move.b	#0,ost_anim_time(a0)			; reset frame duration

	@do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1				; jump to appropriate animation	script
		move.b	(a1),d0					; get frame duration (or special $Fx flag)
		bmi.s	@walkrunroll				; if animation is walk/run/roll/jump, branch
		move.b	ost_status(a0),d1
		andi.b	#status_xflip,d1			; read xflip from status
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d1,ost_render(a0)			; apply xflip from status
		subq.b	#1,ost_anim_time(a0)			; decrement frame duration
		bpl.s	@delay					; if time remains, branch
		move.b	d0,ost_anim_time(a0)			; load frame duration

@loadframe:
		moveq	#0,d1
		move.b	ost_anim_frame(a0),d1			; load current frame number
		move.b	1(a1,d1.w),d0				; read sprite number from script
		bmi.s	@end_FF					; if animation is complete, branch

	@next:
		move.b	d0,ost_frame(a0)			; load sprite number
		addq.b	#1,ost_anim_frame(a0)			; next frame number

	@delay:
		rts	
; ===========================================================================

@end_FF:
		addq.b	#1,d0					; is the end flag = $FF	?
		bne.s	@end_FE					; if not, branch
		move.b	#0,ost_anim_frame(a0)			; restart the animation
		move.b	1(a1),d0				; read sprite number
		bra.s	@next
; ===========================================================================

@end_FE:
		addq.b	#1,d0					; is the end flag = $FE	?
		bne.s	@end_FD					; if not, branch
		move.b	2(a1,d1.w),d0				; read the next	byte in	the script
		sub.b	d0,ost_anim_frame(a0)			; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0				; read sprite number
		bra.s	@next
; ===========================================================================

@end_FD:
		addq.b	#1,d0					; is the end flag = $FD	?
		bne.s	@end					; if not, branch
		move.b	2(a1,d1.w),ost_anim(a0)			; read next byte, run that animation

	@end:
		rts	
; ===========================================================================

@walkrunroll:
		subq.b	#1,ost_anim_time(a0)			; decrement frame duration
		bpl.s	@delay					; if time remains, branch
		addq.b	#1,d0					; is animation walking/running?
		bne.w	@rolljump				; if not, branch

		moveq	#0,d1
		move.b	ost_angle(a0),d0			; get Sonic's angle
		move.b	ost_status(a0),d2
		andi.b	#status_xflip,d2			; is Sonic xflipped?
		bne.s	@flip					; if yes, branch
		not.b	d0					; reverse angle

	@flip:
		addi.b	#$10,d0					; add $10 to angle
		bpl.s	@noinvert				; if angle+$10 is $0-$7F, branch
		moveq	#status_xflip+status_yflip,d1

	@noinvert:
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		eor.b	d1,d2					; include x/yflip bits, allow for cancelling of double xflipped sprites
		or.b	d2,ost_render(a0)			; apply x/yflip
		btst	#status_pushing_bit,ost_status(a0)	; is Sonic pushing something?
		bne.w	@push					; if yes, branch

		lsr.b	#4,d0					; divide angle by $10
		andi.b	#6,d0					; angle	must be	0, 2, 4	or 6
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bpl.s	@speed_pos
		neg.w	d2					; absolute speed

	@speed_pos:
		lea	(Run).l,a1				; use running animation
		cmpi.w	#sonic_max_speed,d2			; is Sonic at running speed?
		bcc.s	@running				; if yes, branch

		lea	(Walk).l,a1				; use walking animation
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0					; multiply d0 by 1.5 (d0 = 0, 3, 6 or 9)

	@running:
		add.b	d0,d0					; d0 = 0, 4, 8 or 12 if running; 0, 6, 12 or 18 if walking
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2				; d2 = $800 minus Sonic's speed
		bpl.s	@belowmax				; branch if speed is below $800
		moveq	#0,d2					; max animation speed

	@belowmax:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0)			; set frame duration
		bsr.w	@loadframe				; run animation
		add.b	d3,ost_frame(a0)			; modify frame number for rotated animations
		rts	
; ===========================================================================

@rolljump:
		addq.b	#1,d0					; is animation rolling/jumping?
		bne.s	@push					; if not, branch
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bpl.s	@speed_pos2
		neg.w	d2					; absolute speed

	@speed_pos2:
		lea	(Roll2).l,a1				; use fast animation
		cmpi.w	#sonic_max_speed,d2			; is Sonic moving fast?
		bcc.s	@rollfast				; if yes, branch
		lea	(Roll).l,a1				; use slower animation

	@rollfast:
		neg.w	d2
		addi.w	#$400,d2				; d2 = $400 minus Sonic's speed
		bpl.s	@belowmax2				; branch if speed is below $400
		moveq	#0,d2					; max animation speed

	@belowmax2:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0)			; set frame duration
		move.b	ost_status(a0),d1
		andi.b	#status_xflip,d1			; read xflip from status
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d1,ost_render(a0)			; apply xflip from status
		bra.w	@loadframe				; run animation
; ===========================================================================

@push:
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bmi.s	@negspeed
		neg.w	d2

	@negspeed:
		addi.w	#$800,d2				; d2 = $800 minus Sonic's speed
		bpl.s	@belowmax3				; branch if speed is below $800
		moveq	#0,d2					; max animation speed

	@belowmax3:
		lsr.w	#6,d2
		move.b	d2,ost_anim_time(a0)			; set frame duration
		lea	(Pushing).l,a1
		move.b	ost_status(a0),d1
		andi.b	#status_xflip,d1			; read xflip from status
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0)
		or.b	d1,ost_render(a0)			; apply xflip from status
		bra.w	@loadframe				; run animation

include_Sonic_1:	macro

; ---------------------------------------------------------------------------
; Subroutine to load Sonic's graphics to RAM
; ---------------------------------------------------------------------------

Sonic_LoadGfx:
		moveq	#0,d0
		move.b	ost_frame(a0),d0			; load frame number
		cmp.b	(v_sonic_last_frame_id).w,d0		; has frame changed?
		beq.s	@nochange				; if not, branch

		move.b	d0,(v_sonic_last_frame_id).w
		lea	(SonicDynPLC).l,a2			; load PLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1				; read "number of entries" value
		subq.b	#1,d1					; minus 1 for number of loops
		bmi.s	@nochange				; if zero, branch
		lea	(v_sonic_gfx_buffer).w,a3		; RAM address to write gfx
		move.b	#1,(f_sonic_dma_gfx).w			; set flag for Sonic graphics DMA

	@loop_entry:
		moveq	#0,d2
		move.b	(a2)+,d2				; get 1st byte of entry
		move.w	d2,d0
		lsr.b	#4,d0					; read high nybble of byte (number of tiles)
		lsl.w	#8,d2					; move 1st byte into high byte
		move.b	(a2)+,d2				; get 2nd byte
		lsl.w	#5,d2					; multiply by 32 (also clears high nybble)
		lea	(Art_Sonic).l,a1
		adda.l	d2,a1					; jump to relevant gfx

	@loop_tile:
		movem.l	(a1)+,d2-d6/a4-a6			; copy tile to registers
		movem.l	d2-d6/a4-a6,(a3)			; copy registers to RAM
		lea	sizeof_cell(a3),a3			; next tile
		dbf	d0,@loop_tile				; repeat for number of tiles

		dbf	d1,@loop_entry				; repeat for number of entries

	@nochange:
		rts	

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 2
; ---------------------------------------------------------------------------

include_Sonic_2:	macro

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

Sonic_AnglePos:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	@not_on_platform			; branch if Sonic isn't on a platform
		moveq	#0,d0
		move.b	d0,(v_angle_right).w			; clear angle hotspots
		move.b	d0,(v_angle_left).w
		rts	
; ===========================================================================

@not_on_platform:
		moveq	#3,d0
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		move.b	ost_angle(a0),d0			; get last angle
		addi.b	#$20,d0
		bpl.s	@floor_or_left				; branch if angle is (generally) flat or left vertical
		move.b	ost_angle(a0),d0
		bpl.s	@angle_pos				; branch if angle is between $60 and $7F
		subq.b	#1,d0					; subtract 1 if $80-$DF

	@angle_pos:
		addi.b	#$20,d0					; d0 = angle + ($1F or $20)
		bra.s	@chk_surface
; ===========================================================================

@floor_or_left:
		move.b	ost_angle(a0),d0
		bpl.s	@angle_pos_				; branch if angle is between 0 and $60
		addq.b	#1,d0					; add 1 if $E0-$FF

	@angle_pos_:
		addi.b	#$1F,d0					; d0 = angle + ($1F or $20)

@chk_surface:
		andi.b	#$C0,d0					; read only bits 6-7 of angle
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL				; branch if on left vertical
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling			; branch if on ceiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR				; branch if on right vertical

		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of bottom edge of Sonic
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of right edge of Sonic
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to floor) to stack

		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of bottom edge of Sonic
		move.b	ost_width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3					; d3 = x pos of left edge of Sonic
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to floor left side
		move.w	(sp)+,d0				; d0 = distance to floor right side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	@on_floor				; branch if Sonic is 0px from floor
		bpl.s	@above_floor				; branch if Sonic is above floor
		cmpi.w	#-$E,d1
		blt.s	Sonic_BelowFloor			; branch if Sonic is > 14px below floor
		add.w	d1,ost_y_pos(a0)			; align to floor

	@on_floor:
		rts	
; ===========================================================================

@above_floor:
		cmpi.w	#$E,d1
		bgt.s	@in_air					; branch if Sonic is > 14px above floor

@on_disc:
		add.w	d1,ost_y_pos(a0)			; align to floor
		rts	
; ===========================================================================

@in_air:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	@on_disc				; branch if Sonic is on a SBZ disc
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts	
; ===========================================================================

Sonic_BelowFloor:
		rts

; ===========================================================================
		move.l	ost_x_pos(a0),d2
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,ost_x_pos(a0)
		move.w	#$38,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,ost_y_pos(a0)
		rts	
; ===========================================================================

Sonic_InsideWall:
		rts	
; ===========================================================================
		move.l	ost_y_pos(a0),d3
		move.w	ost_y_vel(a0),d0
		subi.w	#$38,d0
		move.w	d0,ost_y_vel(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,ost_y_pos(a0)
		rts	
		rts	
; ===========================================================================
		move.l	ost_x_pos(a0),d2
		move.l	ost_y_pos(a0),d3
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.w	ost_y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,ost_x_pos(a0)
		move.l	d3,ost_y_pos(a0)
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	update Sonic's angle

; input:
;	d0 = distance to floor right side
;	d1 = distance to floor left side

; output:
;	d1 = shortest distance to floor (either side)
;	d2 = angle
; ---------------------------------------------------------------------------

Sonic_Angle:
		move.b	(v_angle_left).w,d2			; use left side angle
		cmp.w	d0,d1
		ble.s	@left_nearer				; branch if floor is nearer on left side
		move.b	(v_angle_right).w,d2			; use right side angle
		move.w	d0,d1					; use distance of right side

	@left_nearer:
		btst	#0,d2
		bne.s	@snap_angle				; branch if bit 0 of angle is set
		move.b	d2,ost_angle(a0)			; update angle
		rts	
; ===========================================================================

@snap_angle:
		move.b	ost_angle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2					; snap to nearest 90 degree angle
		move.b	d2,ost_angle(a0)			; update angle
		rts

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his right
; ---------------------------------------------------------------------------

Sonic_WalkVertR:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2					; d2 = y pos of upper edge of Sonic (i.e. his front or back)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile width
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of lower edge of Sonic (i.e. his front or back)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#$10,a3					; tile width
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	@on_wall				; branch if Sonic is 0px from wall
		bpl.s	@outside_wall				; branch if Sonic is outside wall
		cmpi.w	#-$E,d1
		blt.w	Sonic_InsideWall			; branch if Sonic is > 14px inside wall
		add.w	d1,ost_x_pos(a0)			; align to wall

	@on_wall:
		rts	
; ===========================================================================

@outside_wall:
		cmpi.w	#$E,d1
		bgt.s	@in_air					; branch if Sonic is > 14px outside wall

@on_disc:
		add.w	d1,ost_x_pos(a0)			; align to wall
		rts	
; ===========================================================================

@in_air:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	@on_disc				; branch if Sonic is on a SBZ disc
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk upside-down
; ---------------------------------------------------------------------------

Sonic_WalkCeiling:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge of Sonic (i.e. his feet)
		eori.w	#$F,d2					; add some amount
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos of right edge of Sonic
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_yflip,d6			; yflip tile
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to ceiling) to stack

		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of top edge of Sonic (i.e. his feet)
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of left edge of Sonic
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_yflip,d6			; yflip tile
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to ceiling left side
		move.w	(sp)+,d0				; d0 = distance to ceiling right side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	@on_ceiling				; branch if Sonic is 0px from ceiling
		bpl.s	@below_ceiling				; branch if Sonic is below ceiling
		cmpi.w	#-$E,d1
		blt.w	Sonic_BelowFloor			; branch if Sonic is > 14px inside ceiling
		sub.w	d1,ost_y_pos(a0)			; align to ceiling

	@on_ceiling:
		rts	
; ===========================================================================

@below_ceiling:
		cmpi.w	#$E,d1
		bgt.s	@in_air					; branch if Sonic is > 14px below ceiling

@on_disc:
		sub.w	d1,ost_y_pos(a0)			; align to ceiling
		rts	
; ===========================================================================

@in_air:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	@on_disc				; branch if Sonic is on a SBZ disc
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his left
; ---------------------------------------------------------------------------

Sonic_WalkVertL:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos of upper edge of Sonic (i.e. his front or back)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		eori.w	#$F,d3					; add some amount
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile width
		move.w	#tilemap_xflip,d6			; xflip tile
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack

		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos of lower edge of Sonic (i.e. his front or back)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos of bottom edge of Sonic (i.e. his feet)
		eori.w	#$F,d3
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#-$10,a3				; tile width
		move.w	#tilemap_xflip,d6			; xflip tile
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
		bsr.w	Sonic_Angle				; update angle
		tst.w	d1
		beq.s	@on_wall				; branch if Sonic is 0px from wall
		bpl.s	@outside_wall				; branch if Sonic is outside wall
		cmpi.w	#-$E,d1
		blt.w	Sonic_InsideWall			; branch if Sonic is > 14px inside wall
		sub.w	d1,ost_x_pos(a0)			; align to wall

	@on_wall:
		rts	
; ===========================================================================

@outside_wall:
		cmpi.w	#$E,d1
		bgt.s	@in_air					; branch if Sonic is > 14px outside wall

@on_disc:
		sub.w	d1,ost_x_pos(a0)			; align to wall
		rts	
; ===========================================================================

@in_air:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	@on_disc				; branch if Sonic is on a SBZ disc
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 3
; ---------------------------------------------------------------------------

include_Sonic_3:	macro

; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic to the wall in front of him

; input:
;	d0 = Sonic's floor angle rotated 90 degrees (i.e. angle of wall ahead)

; output:
;	d1 = distance to wall
; ---------------------------------------------------------------------------

Sonic_CalcRoomAhead:
		move.l	ost_x_pos(a0),d3
		move.l	ost_y_pos(a0),d2
		move.w	ost_x_vel(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3					; d3 = predicted x pos. at next frame
		move.w	ost_y_vel(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2					; d2 = predicted y pos. at next frame
		swap	d2
		swap	d3
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		move.b	d0,d1
		addi.b	#$20,d0
		bpl.s	@floor_or_left				; branch if angle is floor or left vertical
		move.b	d1,d0
		bpl.s	@angle_pos
		subq.b	#1,d0

	@angle_pos:
		addi.b	#$20,d0
		bra.s	@find_wall
; ===========================================================================

@floor_or_left:
		move.b	d1,d0
		bpl.s	@angle_pos_
		addq.b	#1,d0

	@angle_pos_:
		addi.b	#$1F,d0

@find_wall:
		andi.b	#$C0,d0
		beq.w	Sonic_FindFloor_Quick
		cmpi.b	#$80,d0
		beq.w	Sonic_FindCeiling_Quick
		andi.b	#$38,d1
		bne.s	@find_wall_lr
		addq.w	#8,d2

	@find_wall_lr:
		cmpi.b	#$40,d0
		beq.w	Sonic_FindWallLeft_Quick
		bra.w	Sonic_FindWallRight_Quick

; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic's head to the ceiling

; input:
;	d0 = Sonic's floor angle inverted

; output:
;	d1 = distance to ceiling
; ---------------------------------------------------------------------------

Sonic_CalcHeadroom:
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		addi.b	#$20,d0
		andi.b	#$C0,d0					; read only bits 6 and 7 of angle
		cmpi.b	#$40,d0					; is Sonic on a left-facing wall?
		beq.w	Sonic_FindWallLeft			; ceiling is to the left
		cmpi.b	#$80,d0					; is Sonic on the ground?
		beq.w	Sonic_FindCeiling			; ceiling is directly above
		cmpi.b	#$C0,d0					; is Sonic on a right-facing wall?
		beq.w	Sonic_FindWallRight			; ceiling is to the right

; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor

; output:
;	d0 = distance to floor (larger if on a slope)
;	d1 = distance to floor (smaller if on a slope)
;	d3 = floor angle
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindFloor:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottom edge
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's right edge
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to floor) to stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottom edge
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's left edge
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_top_bit,d5		; bit to test for solidness (top solid)
		bsr.w	FindFloor				; d1 = distance to floor left side
		move.w	(sp)+,d0				; d0 = distance to floor right side
		move.b	#0,d2

Sonic_FindSmaller:
		move.b	(v_angle_left).w,d3
		cmp.w	d0,d1					; compare the output distances
		ble.s	@no_swap				; branch if d0 > d1
		move.b	(v_angle_right).w,d3
		exg	d0,d1					; d1 is always the smaller distance

	@no_swap:
		btst	#0,d3					; is bit 0 of angle set?
		beq.s	@no_angle_snap				; if not, branch
		move.b	d2,d3					; clear d3 (this is copied to ost_angle)

	@no_angle_snap:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor, no width/height checks

; input:
;	d2 = y position of Sonic
;	d3 = x position of Sonic

; output:
;	d1 = distance to floor
;	d3 = floor angle
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

		move.w	ost_y_pos(a0),d2			; unused
		move.w	ost_x_pos(a0),d3			; unused

Sonic_FindFloor_Quick:
		addi.w	#sonic_average_radius,d2
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
		move.b	#0,d2

Sonic_SnapAngle:
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	@no_angle_snap				; branch if bit 0 of angle is clear
		move.b	d2,d3					; snap angle to 0, $40, $80 or $C0

	@no_angle_snap:
		rts	

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 4
; ---------------------------------------------------------------------------

include_Sonic_4:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to wall when Sonic is moving vertically

; output:
;	d0 = distance to wall (larger if on a slope)
;	d1 = distance to wall (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindWallRight:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's upper edge (his left/right)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (his feet/head)
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's lower edge (his right/left)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (his feet/head)
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall				; d1 = distance to wall upper side
		move.w	(sp)+,d0				; d0 = distance to wall lower side
		
		move.b	#$C0,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance

; ---------------------------------------------------------------------------
; Subroutine to	find distance to wall when moving vertically, no width/height checks

; input:
;	d2 = y position of Sonic (Sonic_FindWallRight_Quick only)
;	d3 = x position of Sonic (Sonic_FindWallRight_Quick only)

; output:
;	d1 = distance to wall
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindWallRight_Quick_UsePos:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

Sonic_FindWallRight_Quick:
		addi.w	#sonic_average_radius,d3
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#$10,a3					; tile height
		move.w	#0,d6
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 5
; ---------------------------------------------------------------------------

include_Sonic_5:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling

; output:
;	d0 = distance to ceiling (larger if on a slope)
;	d1 = distance to ceiling (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindCeiling:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's top edge
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's right edge
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_yflip,d6			; yflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save d1 (distance to ceiling) to stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's top edge
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's left edge
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_yflip,d6			; yflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor				; d1 = distance to ceiling on left side
		move.w	(sp)+,d0				; d0 = distance to ceiling on right side
		
		move.b	#$80,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance

; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling, no width/height checks

; input:
;	d2 = y position of Sonic
;	d3 = x position of Sonic

; output:
;	d1 = distance to ceiling
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

		move.w	ost_y_pos(a0),d2			; unused
		move.w	ost_x_pos(a0),d3			; unused

Sonic_FindCeiling_Quick:
		subi.w	#sonic_average_radius,d2
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_yflip,d6			; yflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindFloor
		move.b	#-$80,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 6
; ---------------------------------------------------------------------------

include_Sonic_6:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to wall when Sonic is moving vertically

; output:
;	d0 = distance to wall (larger if on a slope)
;	d1 = distance to wall (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindWallLeft:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's upper edge (his left/right)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (his feet/head)
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_xflip,d6			; xflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.w	d1,-(sp)				; save d1 (distance to wall) to stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's lower edge (his right/left)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (his feet/head)
		eori.w	#$F,d3
		lea	(v_angle_left).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_xflip,d6			; xflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall				; d1 = distance to wall lower side
		move.w	(sp)+,d0				; d0 = distance to wall upper side
		
		move.b	#$40,d2
		bra.w	Sonic_FindSmaller			; make d1 the smaller distance

; ---------------------------------------------------------------------------
; Subroutine to	find distance to wall when moving vertically, no width/height checks

; input:
;	d2 = y position of Sonic (Sonic_FindWallLeft_Quick only)
;	d3 = x position of Sonic (Sonic_FindWallLeft_Quick only)

; output:
;	d1 = distance to wall
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindWallLeft_Quick_UsePos:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

Sonic_FindWallLeft_Quick:
		subi.w	#sonic_average_radius,d3
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4			; write angle here
		movea.w	#-$10,a3				; tile height
		move.w	#tilemap_xflip,d6			; xflip tile
		moveq	#tilemap_solid_lrb_bit,d5		; bit to test for solidness (left/right/bottom solid)
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	Sonic_SnapAngle				; check for snap to 90 degrees

		endm
