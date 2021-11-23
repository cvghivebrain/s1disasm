; ---------------------------------------------------------------------------
; Object 01 - Sonic
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
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#vram_sonic/$20,ost_tile(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$18,ost_actwidth(a0)
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
		jsr	Sonic_Modes(pc,d1.w)

	@lock2:
		bsr.s	Sonic_Display
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Water
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
		bsr.w	Sonic_Loops
		bsr.w	Sonic_LoadGfx
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
		dc.b mus_GHZ
		dc.b mus_LZ
		dc.b mus_MZ
		dc.b mus_SLZ
		dc.b mus_SYZ
		dc.b mus_SBZ
		zonewarning MusicList2,1
		; The ending doesn't get an entry
		even

; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	ost_sonic_flash_time(a0),d0		; is Sonic flashing?
		beq.s	@display				; if not, branch
		subq.w	#1,ost_sonic_flash_time(a0)		; decrement timer
		lsr.w	#3,d0					; is Sonic on a visible frame?
		bcc.s	@chkinvincible				; if not, branch

	@display:
		jsr	(DisplaySprite).l

	@chkinvincible:
		tst.b	(v_invincibility).w			; does Sonic have invincibility?
		beq.s	@chkshoes				; if not, branch
		tst.w	ost_sonic_inv_time(a0)			; check invinciblity timer
		beq.s	@chkshoes				; if 0, branch
		subq.w	#1,ost_sonic_inv_time(a0)		; decrement timer
		bne.s	@chkshoes
		tst.b	(f_boss_boundary).w
		bne.s	@removeinvincible
		cmpi.w	#$C,(v_air).w				; is air < $C?
		bcs.s	@removeinvincible			; if yes, branch
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w		; check if level is SBZ3
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
		bne.s	@exit
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

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RecordPosition:
		move.w	(v_sonic_pos_tracker_num).w,d0
		lea	(v_sonic_pos_tracker).w,a1
		lea	(a1,d0.w),a1
		move.w	ost_x_pos(a0),(a1)+
		move.w	ost_y_pos(a0),(a1)+
		addq.b	#4,(v_sonic_pos_tracker_num_low).w
		rts	
; End of function Sonic_RecordPosition
; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		bset	#status_underwater_bit,ost_status(a0)
		bne.s	@exit
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
		bclr	#status_underwater_bit,ost_status(a0)
		beq.s	@exit
		bsr.w	ResumeMusic
		move.w	#sonic_max_speed,(v_sonic_max_speed).w	; restore Sonic's speed
		move.w	#sonic_acceleration,(v_sonic_acceleration).w ; restore Sonic's acceleration
		move.w	#sonic_deceleration,(v_sonic_deceleration).w ; restore Sonic's deceleration
		asl	ost_y_vel(a0)
		beq.w	@exit
		move.b	#id_Splash,(v_ost_splash).w		; load splash object
		cmpi.w	#-$1000,ost_y_vel(a0)
		bgt.s	@belowmaxspeed
		move.w	#-$1000,ost_y_vel(a0)			; set maximum speed on leaving water

	@belowmaxspeed:
		play.w	1, jmp, sfx_Splash			; play splash sound
; End of function Sonic_Water

; ===========================================================================
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
		subi.w	#$28,ost_y_vel(a0)			; reduce jump speed

	@notwater:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
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
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	loc_12EA6
		subi.w	#$28,ost_y_vel(a0)

loc_12EA6:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk/run
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		lea	(a1,d0.w),a1				; a1 = actual address of OST
		tst.b	ost_status(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	ost_actwidth(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2					; d2 = width of platform -4
		add.w	ost_x_pos(a0),d1
		sub.w	ost_x_pos(a1),d1			; d1 = Sonic's position - object's position + half object's width
		cmpi.w	#4,d1					; is Sonic within 4 pixels of left edge?
		blt.s	Sonic_BalLeft				; if yes, branch
		cmp.w	d2,d1					; is Sonic within 4 pixels of right edge?
		bge.s	Sonic_BalRight				; if yes, branch
		bra.s	Sonic_LookUp
; ===========================================================================

Sonic_Balance:
		jsr	(FindFloorObj).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,ost_sonic_angle_right(a0)		; check for edge to the right
		bne.s	loc_12F62				; branch if not found

	Sonic_BalRight:
		bclr	#status_xflip_bit,ost_status(a0)
		bra.s	Sonic_DoBal
; ===========================================================================

	loc_12F62:
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
		cmpi.w	#$C8,(v_camera_y_shift).w
		beq.s	Sonic_ScrOk
		addq.w	#2,(v_camera_y_shift).w
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_Duck:
		btst	#bitDn,(v_joypad_hold).w		; is down being pressed?
		beq.s	Sonic_ResetScr				; if not, branch
		move.b	#id_Duck,ost_anim(a0)			; use "ducking" animation
		cmpi.w	#8,(v_camera_y_shift).w
		beq.s	Sonic_ScrOk
		subq.w	#2,(v_camera_y_shift).w
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_ResetScr:
		cmpi.w	#$60,(v_camera_y_shift).w		; is screen in its default position?
		beq.s	Sonic_ScrOk				; if yes, branch
		bcc.s	Sonic_HighScr				; branch if screen is higher
		addq.w	#4,(v_camera_y_shift).w			; move screen back to default

	Sonic_HighScr:
		subq.w	#2,(v_camera_y_shift).w			; move screen back to default

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

Sonic_FindCorner:
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
		bsr.w	Sonic_CalcRoomAhead
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
; End of function Sonic_Move


; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk to the left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		bne.s	locret_130E8				; branch if Sonic is running on a wall or ceiling
		cmpi.w	#$400,d0
		blt.s	locret_130E8
		move.b	#id_Stop,ost_anim(a0)			; use "stopping" animation
		bclr	#status_xflip_bit,ost_status(a0)
		play.w	1, jsr, sfx_Skid			; play stopping sound

locret_130E8:
		rts	
; End of function Sonic_MoveLeft


; ---------------------------------------------------------------------------
; Subroutine to	make Sonic walk to the right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		bcc.s	loc_13120
		move.w	#$80,d0

loc_13120:
		move.w	d0,ost_inertia(a0)
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_1314E				; branch if Sonic is running on a wall or ceiling
		cmpi.w	#-$400,d0
		bgt.s	locret_1314E
		move.b	#id_Stop,ost_anim(a0)			; use "stopping" animation
		bset	#0,ost_status(a0)
		play.w	1, jsr, sfx_Skid			; play stopping sound

locret_1314E:
		rts	
; End of function Sonic_MoveRight

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's speed as he rolls
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollSpeed:
		move.w	(v_sonic_max_speed).w,d6
		asl.w	#1,d6
		move.w	(v_sonic_acceleration).w,d5
		asr.w	#1,d5
		move.w	(v_sonic_deceleration).w,d4
		asr.w	#2,d4
		tst.b	(f_jump_only).w				; are controls except jump locked?
		bne.w	loc_131CC				; if yes, branch
		tst.w	ost_sonic_lock_time(a0)
		bne.s	@notright
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	@notleft				; if not, branch
		bsr.w	Sonic_RollLeft

	@notleft:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	@notright				; if not, branch
		bsr.w	Sonic_RollRight

	@notright:
		move.w	ost_inertia(a0),d0
		beq.s	loc_131AA
		bmi.s	loc_1319E
		sub.w	d5,d0
		bcc.s	loc_13198
		move.w	#0,d0

loc_13198:
		move.w	d0,ost_inertia(a0)
		bra.s	loc_131AA
; ===========================================================================

loc_1319E:
		add.w	d5,d0
		bcc.s	loc_131A6
		move.w	#0,d0

loc_131A6:
		move.w	d0,ost_inertia(a0)

loc_131AA:
		tst.w	ost_inertia(a0)				; is Sonic moving?
		bne.s	loc_131CC				; if yes, branch
		bclr	#status_jump_bit,ost_status(a0)
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		move.b	#id_Wait,ost_anim(a0)			; use "standing" animation
		subq.w	#5,ost_y_pos(a0)

loc_131CC:
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		muls.w	ost_inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)
		muls.w	ost_inertia(a0),d1
		asr.l	#8,d1
		cmpi.w	#$1000,d1
		ble.s	loc_131F0
		move.w	#$1000,d1

loc_131F0:
		cmpi.w	#-$1000,d1
		bge.s	loc_131FA
		move.w	#-$1000,d1

loc_131FA:
		move.w	d1,ost_x_vel(a0)
		bra.w	Sonic_FindCorner
; End of function Sonic_RollSpeed


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollLeft:
		move.w	ost_inertia(a0),d0
		beq.s	loc_1320A
		bpl.s	loc_13218

loc_1320A:
		bset	#status_xflip_bit,ost_status(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		rts	
; ===========================================================================

loc_13218:
		sub.w	d4,d0
		bcc.s	loc_13220
		move.w	#-$80,d0

loc_13220:
		move.w	d0,ost_inertia(a0)
		rts	
; End of function Sonic_RollLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRight:
		move.w	ost_inertia(a0),d0
		bmi.s	loc_1323A
		bclr	#status_xflip_bit,ost_status(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		rts	
; ===========================================================================

loc_1323A:
		add.w	d4,d0
		bcc.s	loc_13242
		move.w	#$80,d0

loc_13242:
		move.w	d0,ost_inertia(a0)
		rts	
; End of function Sonic_RollRight

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's direction while jumping
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpDirection:
		move.w	(v_sonic_max_speed).w,d6
		move.w	(v_sonic_acceleration).w,d5
		asl.w	#1,d5
		btst	#status_rolljump_bit,ost_status(a0)	; is Sonic jumping while rolling?
		bne.s	Obj01_ResetScr2				; if yes, branch
		
		move.w	ost_x_vel(a0),d0
		btst	#bitL,(v_joypad_hold).w			; is left being pressed?
		beq.s	loc_13278				; if not, branch
		bset	#status_xflip_bit,ost_status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_13278
		move.w	d1,d0

	loc_13278:
		btst	#bitR,(v_joypad_hold).w			; is right being pressed?
		beq.s	Obj01_JumpMove				; if not, branch
		bclr	#status_xflip_bit,ost_status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Obj01_JumpMove
		move.w	d6,d0

Obj01_JumpMove:
		move.w	d0,ost_x_vel(a0)			; change Sonic's horizontal speed

Obj01_ResetScr2:
		cmpi.w	#$60,(v_camera_y_shift).w		; is the screen in its default position?
		beq.s	loc_132A4				; if yes, branch
		bcc.s	loc_132A0
		addq.w	#4,(v_camera_y_shift).w

loc_132A0:
		subq.w	#2,(v_camera_y_shift).w

loc_132A4:
		cmpi.w	#-$400,ost_y_vel(a0)			; is Sonic moving faster than -$400 upwards?
		bcs.s	locret_132D2				; if yes, branch
		move.w	ost_x_vel(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_132D2
		bmi.s	loc_132C6
		sub.w	d1,d0
		bcc.s	loc_132C0
		move.w	#0,d0

loc_132C0:
		move.w	d0,ost_x_vel(a0)
		rts	
; ===========================================================================

loc_132C6:
		sub.w	d1,d0
		bcs.s	loc_132CE
		move.w	#0,d0

loc_132CE:
		move.w	d0,ost_x_vel(a0)

locret_132D2:
		rts	
; End of function Sonic_JumpDirection

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to squash Sonic
; ---------------------------------------------------------------------------
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_13302				; branch if Sonic is running on a wall or ceiling
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	locret_13302				; branch if there's space between Sonic and the ceiling
		move.w	#0,ost_inertia(a0)			; stop Sonic moving
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_y_vel(a0)
		move.b	#id_Warp3,ost_anim(a0)			; use "warping" animation

locret_13302:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	prevent	Sonic leaving the boundaries of	a level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_LevelBound:
		move.l	ost_x_pos(a0),d1
		move.w	ost_x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(v_boundary_left).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0					; has Sonic touched the	side boundary?
		bhi.s	@sides					; if yes, branch
		move.w	(v_boundary_right).w,d0
		addi.w	#$128,d0
		tst.b	(f_boss_boundary).w
		bne.s	@screenlocked
		addi.w	#$40,d0

	@screenlocked:
		cmp.w	d1,d0					; has Sonic touched the	side boundary?
		bls.s	@sides					; if yes, branch

	@chkbottom:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0			; has Sonic touched the bottom boundary?
		blt.s	@bottom					; if yes, branch
		rts	
; ===========================================================================

@bottom:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w		; is level SBZ2 ?
		bne.w	KillSonic				; if not, kill Sonic
		cmpi.w	#$2000,(v_ost_player+ost_x_pos).w	; has Sonic reached $2000 on x-axis?
		bcs.w	KillSonic				; if not, kill Sonic
		clr.b	(v_last_lamppost).w			; clear	lamppost counter
		move.w	#1,(f_restart).w			; restart the level
		move.w	#(id_LZ<<8)+3,(v_zone).w		; set level to SBZ3 (LZ4)
		rts	
; ===========================================================================

@sides:
		move.w	d0,ost_x_pos(a0)
		move.w	#0,ost_x_sub(a0)
		move.w	#0,ost_x_vel(a0)			; stop Sonic moving
		move.w	#0,ost_inertia(a0)
		bra.s	@chkbottom
; End of function Sonic_LevelBound
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		tst.b	(f_jump_only).w
		bne.s	@noroll
		move.w	ost_inertia(a0),d0
		bpl.s	@ispositive
		neg.w	d0

	@ispositive:
		cmpi.w	#$80,d0					; is Sonic moving at $80 speed or faster?
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
		bset	#status_jump_bit,ost_status(a0)
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "rolling" animation
		addq.w	#5,ost_y_pos(a0)
		play.w	1, jsr, sfx_Roll			; play rolling sound
		tst.w	ost_inertia(a0)
		bne.s	@ismoving
		move.w	#$200,ost_inertia(a0)			; set inertia if 0

	@ismoving:
		rts	
; End of function Sonic_Roll
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		move.w	#$680,d2				; jump strength
		btst	#status_underwater_bit,ost_status(a0)	; is Sonic underwater?
		beq.s	@not_underwater				; if not, branch
		move.w	#$380,d2				; underwater jump strength

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
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		btst	#status_jump_bit,ost_status(a0)		; is Sonic rolling?
		bne.s	@is_rolling				; if yes, branch
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0)			; use "jumping" animation
		bset	#status_jump_bit,ost_status(a0)
		addq.w	#5,ost_y_pos(a0)

	@no_jump:
		rts	
; ===========================================================================

@is_rolling:
		bset	#status_rolljump_bit,ost_status(a0)
		rts	
; End of function Sonic_Jump
; ---------------------------------------------------------------------------
; Subroutine controlling Sonic's jump height/duration
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpHeight:
		tst.b	ost_sonic_jump(a0)
		beq.s	loc_134C4
		move.w	#-$400,d1
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	loc_134AE
		move.w	#-$200,d1

loc_134AE:
		cmp.w	ost_y_vel(a0),d1
		ble.s	locret_134C2
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnABC,d0				; is A, B or C pressed?
		bne.s	locret_134C2				; if yes, branch
		move.w	d1,ost_y_vel(a0)

locret_134C2:
		rts	
; ===========================================================================

loc_134C4:
		cmpi.w	#-$FC0,ost_y_vel(a0)
		bge.s	locret_134D2
		move.w	#-$FC0,ost_y_vel(a0)

locret_134D2:
		rts	
; End of function Sonic_JumpHeight

; ---------------------------------------------------------------------------
; Subroutine to	slow Sonic walking up a	slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeResist:
		move.b	ost_angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_13508
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	ost_inertia(a0)
		beq.s	locret_13508
		bmi.s	loc_13504
		tst.w	d0
		beq.s	locret_13502
		add.w	d0,ost_inertia(a0)			; change Sonic's inertia

locret_13502:
		rts	
; ===========================================================================

loc_13504:
		add.w	d0,ost_inertia(a0)

locret_13508:
		rts	
; End of function Sonic_SlopeResist
; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope	while he's rolling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollRepel:
		move.b	ost_angle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#-$40,d0
		bcc.s	locret_13544
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	ost_inertia(a0)
		bmi.s	loc_1353A
		tst.w	d0
		bpl.s	loc_13534
		asr.l	#2,d0

loc_13534:
		add.w	d0,ost_inertia(a0)
		rts	
; ===========================================================================

loc_1353A:
		tst.w	d0
		bmi.s	loc_13540
		asr.l	#2,d0

loc_13540:
		add.w	d0,ost_inertia(a0)

locret_13544:
		rts	
; End of function Sonic_RollRepel
; ---------------------------------------------------------------------------
; Subroutine to	push Sonic down	a slope
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_SlopeRepel:
		nop	
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	locret_13580
		tst.w	ost_sonic_lock_time(a0)
		bne.s	loc_13582
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_13580
		move.w	ost_inertia(a0),d0
		bpl.s	loc_1356A
		neg.w	d0

loc_1356A:
		cmpi.w	#$280,d0
		bcc.s	locret_13580
		clr.w	ost_inertia(a0)
		bset	#status_air_bit,ost_status(a0)
		move.w	#$1E,ost_sonic_lock_time(a0)

locret_13580:
		rts	
; ===========================================================================

loc_13582:
		subq.w	#1,$3E(a0)
		rts	
; End of function Sonic_SlopeRepel
; ---------------------------------------------------------------------------
; Subroutine to	return Sonic's angle to 0 as he jumps
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpAngle:
		move.b	ost_angle(a0),d0			; get Sonic's angle
		beq.s	locret_135A2				; if already 0,	branch
		bpl.s	loc_13598				; if higher than 0, branch

		addq.b	#2,d0					; increase angle
		bcc.s	loc_13596
		moveq	#0,d0

loc_13596:
		bra.s	loc_1359E
; ===========================================================================

loc_13598:
		subq.b	#2,d0					; decrease angle
		bcc.s	loc_1359E
		moveq	#0,d0

loc_1359E:
		move.b	d0,ost_angle(a0)

locret_135A2:
		rts	
; End of function Sonic_JumpAngle
; ---------------------------------------------------------------------------
; Subroutine for Sonic to interact with	the floor after	jumping/falling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Floor:
		move.w	ost_x_vel(a0),d1
		move.w	ost_y_vel(a0),d2
		jsr	(CalcAngle).l
		move.b	d0,(v_sonic_angle1_unused).w
		subi.b	#$20,d0
		move.b	d0,(v_sonic_angle2_unused).w
		andi.b	#$C0,d0
		move.b	d0,(v_sonic_angle3_unused).w
		cmpi.b	#$40,d0
		beq.w	loc_13680
		cmpi.b	#$80,d0
		beq.w	loc_136E2
		cmpi.b	#$C0,d0
		beq.w	loc_1373E
		bsr.w	Sonic_FindCeilingLeft_Basic
		tst.w	d1
		bpl.s	loc_135F0
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_135F0:
		bsr.w	Sonic_FindCeilingRight_Basic
		tst.w	d1
		bpl.s	loc_13602
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_13602:
		bsr.w	Sonic_FindFloor
		move.b	d1,(v_sonic_floor_dist_unused).w
		tst.w	d1
		bpl.s	locret_1367E
		move.b	ost_y_vel(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.s	loc_1361E
		cmp.b	d2,d0
		blt.s	locret_1367E

loc_1361E:
		add.w	d1,ost_y_pos(a0)
		move.b	d3,ost_angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,ost_anim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_1365C
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.s	loc_1364E
		asr	ost_y_vel(a0)
		bra.s	loc_13670
; ===========================================================================

loc_1364E:
		move.w	#0,ost_y_vel(a0)
		move.w	ost_x_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

loc_1365C:
		move.w	#0,ost_x_vel(a0)
		cmpi.w	#$FC0,ost_y_vel(a0)
		ble.s	loc_13670
		move.w	#$FC0,ost_y_vel(a0)

loc_13670:
		move.w	ost_y_vel(a0),ost_inertia(a0)
		tst.b	d3
		bpl.s	locret_1367E
		neg.w	ost_inertia(a0)

locret_1367E:
		rts	
; ===========================================================================

loc_13680:
		bsr.w	Sonic_FindCeilingLeft_Basic
		tst.w	d1
		bpl.s	loc_1369A
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

loc_1369A:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	loc_136B4
		sub.w	d1,ost_y_pos(a0)
		tst.w	ost_y_vel(a0)
		bpl.s	locret_136B2
		move.w	#0,ost_y_vel(a0)

locret_136B2:
		rts	
; ===========================================================================

loc_136B4:
		tst.w	ost_y_vel(a0)
		bmi.s	locret_136E0
		bsr.w	Sonic_FindFloor
		tst.w	d1
		bpl.s	locret_136E0
		add.w	d1,ost_y_pos(a0)
		move.b	d3,ost_angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,ost_anim(a0)
		move.w	#0,ost_y_vel(a0)
		move.w	ost_x_vel(a0),ost_inertia(a0)

locret_136E0:
		rts	
; ===========================================================================

loc_136E2:
		bsr.w	Sonic_FindCeilingLeft_Basic
		tst.w	d1
		bpl.s	loc_136F4
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_136F4:
		bsr.w	Sonic_FindCeilingRight_Basic
		tst.w	d1
		bpl.s	loc_13706
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_13706:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	locret_1373C
		sub.w	d1,ost_y_pos(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_13726
		move.w	#0,ost_y_vel(a0)
		rts	
; ===========================================================================

loc_13726:
		move.b	d3,ost_angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.w	ost_y_vel(a0),ost_inertia(a0)
		tst.b	d3
		bpl.s	locret_1373C
		neg.w	ost_inertia(a0)

locret_1373C:
		rts	
; ===========================================================================

loc_1373E:
		bsr.w	Sonic_FindCeilingRight_Basic
		tst.w	d1
		bpl.s	loc_13758
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

loc_13758:
		bsr.w	Sonic_FindCeiling
		tst.w	d1
		bpl.s	loc_13772
		sub.w	d1,ost_y_pos(a0)
		tst.w	ost_y_vel(a0)
		bpl.s	locret_13770
		move.w	#0,ost_y_vel(a0)

locret_13770:
		rts	
; ===========================================================================

loc_13772:
		tst.w	ost_y_vel(a0)
		bmi.s	locret_1379E
		bsr.w	Sonic_FindFloor
		tst.w	d1
		bpl.s	locret_1379E
		add.w	d1,ost_y_pos(a0)
		move.b	d3,ost_angle(a0)
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Walk,ost_anim(a0)
		move.w	#0,ost_y_vel(a0)
		move.w	ost_x_vel(a0),ost_inertia(a0)

locret_1379E:
		rts	
; End of function Sonic_Floor
; ---------------------------------------------------------------------------
; Subroutine to	reset Sonic's mode when he lands on the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_ResetOnFloor:
		btst	#status_rolljump_bit,ost_status(a0)
		beq.s	loc_137AE
		nop	
		nop	
		nop	

loc_137AE:
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_air_bit,ost_status(a0)
		bclr	#status_rolljump_bit,ost_status(a0)
		btst	#status_jump_bit,ost_status(a0)
		beq.s	loc_137E4
		bclr	#status_jump_bit,ost_status(a0)
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		move.b	#id_Walk,ost_anim(a0)			; use running/walking animation
		subq.w	#5,ost_y_pos(a0)

loc_137E4:
		move.b	#0,ost_sonic_jump(a0)
		move.w	#0,(v_enemy_combo).w
		rts	
; End of function Sonic_ResetOnFloor
; ---------------------------------------------------------------------------
; Sonic	when he	gets hurt
; ---------------------------------------------------------------------------

Sonic_Hurt:	; Routine 4
		jsr	(SpeedToPos).l
		addi.w	#$30,ost_y_vel(a0)
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	@not_underwater
		subi.w	#$20,ost_y_vel(a0)

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

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HurtStop:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.w	KillSonic
		bsr.w	Sonic_Floor
		btst	#status_air_bit,ost_status(a0)
		bne.s	locret_13860
		moveq	#0,d0
		move.w	d0,ost_y_vel(a0)
		move.w	d0,ost_x_vel(a0)
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0)
		subq.b	#2,ost_routine(a0)
		move.w	#$78,ost_sonic_flash_time(a0)

locret_13860:
		rts	
; End of function Sonic_HurtStop

; ---------------------------------------------------------------------------
; Sonic	when he	dies
; ---------------------------------------------------------------------------

Sonic_Death:	; Routine 6
		bsr.w	GameOver
		jsr	(ObjectFall).l
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Animate
		bsr.w	Sonic_LoadGfx
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


GameOver:
		move.w	(v_boundary_bottom).w,d0
		addi.w	#$100,d0
		cmp.w	ost_y_pos(a0),d0
		bcc.w	locret_13900
		move.w	#-$38,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)
		clr.b	(f_hud_time_update).w			; stop time counter
		addq.b	#1,(f_hud_lives_update).w		; update lives counter
		subq.b	#1,(v_lives).w				; subtract 1 from number of lives
		bne.s	loc_138D4
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_gameover1).w	; load GAME object
		move.b	#id_GameOverCard,(v_ost_gameover2).w	; load OVER object
		move.b	#id_frame_gameover_over,(v_ost_gameover2+ost_frame).w ; set OVER object to correct frame
		clr.b	(f_time_over).w

loc_138C2:
		play.w	0, jsr, mus_GameOver			; play game over music
		moveq	#3,d0
		jmp	(AddPLC).l				; load game over patterns
; ===========================================================================

loc_138D4:
		move.w	#60,ost_sonic_restart_time(a0)		; set time delay to 1 second
		tst.b	(f_time_over).w				; is TIME OVER tag set?
		beq.s	locret_13900				; if not, branch
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_gameover1).w	; load TIME object
		move.b	#id_GameOverCard,(v_ost_gameover2).w	; load OVER object
		move.b	#id_frame_gameover_time,(v_ost_gameover1+ost_frame).w
		move.b	#id_frame_gameover_over2,(v_ost_gameover2+ost_frame).w
		bra.s	loc_138C2
; ===========================================================================

locret_13900:
		rts	
; End of function GameOver

; ---------------------------------------------------------------------------
; Sonic	when the level is restarted
; ---------------------------------------------------------------------------

Sonic_ResetLevel:; Routine 8
		tst.w	ost_sonic_restart_time(a0)
		beq.s	locret_13914
		subq.w	#1,ost_sonic_restart_time(a0)		; subtract 1 from time delay
		bne.s	locret_13914
		move.w	#1,(f_restart).w			; restart the level

	locret_13914:
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	make Sonic run around loops (GHZ/SLZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Loops:
		cmpi.b	#id_SLZ,(v_zone).w			; is level SLZ ?
		beq.s	@isstarlight				; if yes, branch
		tst.b	(v_zone).w				; is level GHZ ?
		bne.w	@noloops				; if not, branch

	@isstarlight:
		move.w	ost_y_pos(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.b	ost_x_pos(a0),d1
		andi.w	#$7F,d1
		add.w	d1,d0
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
		bcc.s	@chkifright

		bclr	#render_behind_bit,ost_render(a0)	; return Sonic to high plane
		rts	
; ===========================================================================

@chkifright:
		cmpi.b	#$E0,d2
		bcs.s	@chkangle1

		bset	#render_behind_bit,ost_render(a0)	; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle1:
		btst	#render_behind_bit,ost_render(a0)	; is Sonic on low plane?
		bne.s	@chkangle2				; if yes, branch

		move.b	ost_angle(a0),d1
		beq.s	@done
		cmpi.b	#$80,d1					; is Sonic upside-down?
		bhi.s	@done					; if yes, branch
		bset	#render_behind_bit,ost_render(a0)	; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle2:
		move.b	ost_angle(a0),d1
		cmpi.b	#$80,d1					; is Sonic upright?
		bls.s	@done					; if yes, branch
		bclr	#render_behind_bit,ost_render(a0)	; send Sonic to high plane

@noloops:
@done:
		rts	
; End of function Sonic_Loops
; ---------------------------------------------------------------------------
; Subroutine to	animate	Sonic's sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		move.b	(a1),d0
		bmi.s	@walkrunroll				; if animation is walk/run/roll/jump, branch
		move.b	ost_status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,ost_render(a0)
		or.b	d1,ost_render(a0)
		subq.b	#1,ost_anim_time(a0)			; subtract 1 from frame duration
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
		subq.b	#1,ost_anim_time(a0)			; subtract 1 from frame duration
		bpl.s	@delay					; if time remains, branch
		addq.b	#1,d0					; is animation walking/running?
		bne.w	@rolljump				; if not, branch
		moveq	#0,d1
		move.b	ost_angle(a0),d0			; get Sonic's angle
		move.b	ost_status(a0),d2
		andi.b	#1,d2					; is Sonic mirrored horizontally?
		bne.s	@flip					; if yes, branch
		not.b	d0					; reverse angle

	@flip:
		addi.b	#$10,d0					; add $10 to angle
		bpl.s	@noinvert				; if angle is $0-$7F, branch
		moveq	#3,d1

	@noinvert:
		andi.b	#$FC,ost_render(a0)
		eor.b	d1,d2
		or.b	d2,ost_render(a0)
		btst	#status_pushing_bit,ost_status(a0)	; is Sonic pushing something?
		bne.w	@push					; if yes, branch

		lsr.b	#4,d0					; divide angle by $10
		andi.b	#6,d0					; angle	must be	0, 2, 4	or 6
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bpl.s	@nomodspeed
		neg.w	d2					; modulus speed

	@nomodspeed:
		lea	(Run).l,a1				; use running animation
		cmpi.w	#$600,d2				; is Sonic at running speed?
		bcc.s	@running				; if yes, branch

		lea	(Walk).l,a1				; use walking animation
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

	@running:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	@belowmax
		moveq	#0,d2					; max animation speed

	@belowmax:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0)			; modify frame duration
		bsr.w	@loadframe
		add.b	d3,ost_frame(a0)			; modify frame number
		rts	
; ===========================================================================

@rolljump:
		addq.b	#1,d0					; is animation rolling/jumping?
		bne.s	@push					; if not, branch
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bpl.s	@nomodspeed2
		neg.w	d2

	@nomodspeed2:
		lea	(Roll2).l,a1				; use fast animation
		cmpi.w	#$600,d2				; is Sonic moving fast?
		bcc.s	@rollfast				; if yes, branch
		lea	(Roll).l,a1				; use slower animation

	@rollfast:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	@belowmax2
		moveq	#0,d2

	@belowmax2:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0)			; modify frame duration
		move.b	ost_status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,ost_render(a0)
		or.b	d1,ost_render(a0)
		bra.w	@loadframe
; ===========================================================================

@push:
		move.w	ost_inertia(a0),d2			; get Sonic's speed
		bmi.s	@negspeed
		neg.w	d2

	@negspeed:
		addi.w	#$800,d2
		bpl.s	@belowmax3	
		moveq	#0,d2

	@belowmax3:
		lsr.w	#6,d2
		move.b	d2,ost_anim_time(a0)			; modify frame duration
		lea	(Pushing).l,a1
		move.b	ost_status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,ost_render(a0)
		or.b	d1,ost_render(a0)
		bra.w	@loadframe

; End of function Sonic_Animate

Ani_Sonic:	include "Animations\Sonic.asm"

; ---------------------------------------------------------------------------
; Sonic	graphics loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		subq.b	#1,d1
		bmi.s	@nochange				; if zero, branch
		lea	(v_sonic_gfx_buffer).w,a3
		move.b	#1,(f_sonic_dma_gfx).w			; set flag for Sonic graphics DMA

	@readentry:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(Art_Sonic).l,a1
		adda.l	d2,a1

	@loadtile:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	$20(a3),a3				; next tile
		dbf	d0,@loadtile				; repeat for number of tiles

		dbf	d1,@readentry				; repeat for number of entries

	@nochange:
		rts	

; End of function Sonic_LoadGfx

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 2
; ---------------------------------------------------------------------------

include_Sonic_2:	macro

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_AnglePos:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	loc_14602
		moveq	#0,d0
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		rts	
; ===========================================================================

loc_14602:
		moveq	#3,d0
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		bpl.s	loc_14624
		move.b	ost_angle(a0),d0
		bpl.s	loc_1461E
		subq.b	#1,d0

loc_1461E:
		addi.b	#$20,d0
		bra.s	loc_14630
; ===========================================================================

loc_14624:
		move.b	ost_angle(a0),d0
		bpl.s	loc_1462C
		addq.b	#1,d0

loc_1462C:
		addi.b	#$1F,d0

loc_14630:
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	Sonic_WalkVertL
		cmpi.b	#$80,d0
		beq.w	Sonic_WalkCeiling
		cmpi.b	#$C0,d0
		beq.w	Sonic_WalkVertR
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(v_angle_left).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_146BE
		bpl.s	loc_146C0
		cmpi.w	#-$E,d1
		blt.s	locret_146E6
		add.w	d1,ost_y_pos(a0)

locret_146BE:
		rts	
; ===========================================================================

loc_146C0:
		cmpi.w	#$E,d1
		bgt.s	loc_146CC

loc_146C6:
		add.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

loc_146CC:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	loc_146C6
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts	
; ===========================================================================

locret_146E6:
		rts	
; End of function Sonic_AnglePos

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

locret_1470A:
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
; Subroutine to	change Sonic's angle as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Angle:
		move.b	(v_angle_left).w,d2
		cmp.w	d0,d1
		ble.s	loc_1475E
		move.b	(v_angle_right).w,d2
		move.w	d0,d1

loc_1475E:
		btst	#0,d2
		bne.s	loc_1476A
		move.b	d2,ost_angle(a0)
		rts	
; ===========================================================================

loc_1476A:
		move.b	ost_angle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,ost_angle(a0)
		rts	
; End of function Sonic_Angle

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertR:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_left).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_147F0
		bpl.s	loc_147F2
		cmpi.w	#-$E,d1
		blt.w	locret_1470A
		add.w	d1,ost_x_pos(a0)

locret_147F0:
		rts	
; ===========================================================================

loc_147F2:
		cmpi.w	#$E,d1
		bgt.s	loc_147FE

loc_147F8:
		add.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

loc_147FE:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	loc_147F8
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts	
; End of function Sonic_WalkVertR

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk upside-down
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkCeiling:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_14892
		bpl.s	loc_14894
		cmpi.w	#-$E,d1
		blt.w	locret_146E6
		sub.w	d1,ost_y_pos(a0)

locret_14892:
		rts	
; ===========================================================================

loc_14894:
		cmpi.w	#$E,d1
		bgt.s	loc_148A0

loc_1489A:
		sub.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

loc_148A0:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	loc_1489A
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts	
; End of function Sonic_WalkCeiling

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertL:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle
		tst.w	d1
		beq.s	locret_14934
		bpl.s	loc_14936
		cmpi.w	#-$E,d1
		blt.w	locret_1470A
		sub.w	d1,ost_x_pos(a0)

locret_14934:
		rts	
; ===========================================================================

loc_14936:
		cmpi.w	#$E,d1
		bgt.s	loc_14942

loc_1493C:
		sub.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

loc_14942:
		tst.b	ost_sonic_sbz_disc(a0)
		bne.s	loc_1493C
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Run,ost_anim_restart(a0)
		rts	
; End of function Sonic_WalkVertL

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 3
; ---------------------------------------------------------------------------

include_Sonic_3:	macro

; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic to the wall in front of him

; input:
;	d0 = Sonic's floor angle rotated 90 degrees
; output:
;	d1 = distance to wall
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		bpl.s	loc_14D1A
		move.b	d1,d0
		bpl.s	loc_14D14
		subq.b	#1,d0

loc_14D14:
		addi.b	#$20,d0
		bra.s	loc_14D24
; ===========================================================================

loc_14D1A:
		move.b	d1,d0
		bpl.s	loc_14D20
		addq.b	#1,d0

loc_14D20:
		addi.b	#$1F,d0

loc_14D24:
		andi.b	#$C0,d0
		beq.w	Sonic_FindFloor_Basic_2
		cmpi.b	#$80,d0
		beq.w	Sonic_FindCeiling_Basic_2
		andi.b	#$38,d1
		bne.s	loc_14D3C
		addq.w	#8,d2

loc_14D3C:
		cmpi.b	#$40,d0
		beq.w	Sonic_FindCeilingLeft_Basic_2
		bra.w	Sonic_FindCeilingRight_Basic_2

; End of function Sonic_CalcRoomAhead

; ---------------------------------------------------------------------------
; Subroutine to	calculate distance from Sonic's head to the ceiling

; input:
;	d0 = Sonic's floor angle inverted
; output:
;	d1 = distance to ceiling
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_CalcHeadroom:
		move.b	d0,(v_angle_right).w
		move.b	d0,(v_angle_left).w
		addi.b	#$20,d0
		andi.b	#$C0,d0					; read only bits 6 and 7 of angle
		cmpi.b	#$40,d0					; is Sonic on a left-facing wall?
		beq.w	Sonic_FindCeilingLeft			; ceiling is to the left
		cmpi.b	#$80,d0					; is Sonic on the ground?
		beq.w	Sonic_FindCeiling			; ceiling is directly above
		cmpi.b	#$C0,d0					; is Sonic on a right-facing wall?
		beq.w	Sonic_FindCeilingRight			; ceiling is to the right

; End of function Sonic_CalcHeadroom

; ---------------------------------------------------------------------------
; Subroutine to	find distance to floor

; output:
;	d0 = distance to floor (larger if on a slope)
;	d1 = distance to floor (smaller if on a slope)
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save distance from bottom right to floor in stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottom edge
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's left edge
		lea	(v_angle_left).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor				; d1 = distance from left to floor
		move.w	(sp)+,d0				; retrieve distance from bottom right to floor from stack
		move.b	#0,d2

Sonic_FindSmaller:
		move.b	(v_angle_left).w,d3
		cmp.w	d0,d1					; compare the output distances
		ble.s	@no_swap				; branch if d0 > d1
		move.b	(v_angle_right).w,d3
		exg	d0,d1					; d1 is always the smaller distance

	@no_swap:
		btst	#0,d3					; is bit 0 of angle set?
		beq.s	@bit0_clear				; if not, branch
		move.b	d2,d3					; clear d3 (this is copied to ost_angle)

	@bit0_clear:
		rts	

; End of function Sonic_FindFloor

; ===========================================================================

Sonic_FindFloor_Basic:
		move.w	ost_y_pos(a0),d2			; unused
		move.w	ost_x_pos(a0),d3			; unused

Sonic_FindFloor_Basic_2:
		addi.w	#$A,d2
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#0,d2

loc_14E0A:
		move.b	(v_angle_right).w,d3
		btst	#0,d3
		beq.s	locret_14E16
		move.b	d2,d3

locret_14E16:
		rts	

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 4
; ---------------------------------------------------------------------------

include_Sonic_4:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling when Sonic is running up/down a wall
; and the ceiling is to his right

; output:
;	d1 = distance to ceiling
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_FindCeilingRight:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's topmost edge (left/right)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (top)
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)				; save distance from head to wall in stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottommost edge (right/left)
		move.b	ost_height(a0),d0
		ext.w	d0
		add.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (bottom)
		lea	(v_angle_left).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall				; d1 = distance from feet to wall
		move.w	(sp)+,d0				; retrieve distance from head to wall from stack
		
		move.b	#$C0,d2
		bra.w	Sonic_FindSmaller

; End of function Sonic_FindCeilingRight


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_FindCeilingRight_Basic:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

Sonic_FindCeilingRight_Basic_2:
		addi.w	#$A,d3
		lea	(v_angle_right).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	loc_14E0A

; End of function Sonic_FindCeilingRight_Basic

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 5
; ---------------------------------------------------------------------------

include_Sonic_5:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling

; output:
;	d1 = distance to ceiling
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)				; save distance from top right to ceiling in stack
		
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
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor				; d1 = distance from top left to ceiling
		move.w	(sp)+,d0				; retrieve distance from top right to ceiling from stack
		
		move.b	#$80,d2
		bra.w	Sonic_FindSmaller
; End of function Sonic_FindCeiling

; ===========================================================================

Sonic_FindCeiling_Basic:
		move.w	ost_y_pos(a0),d2			; unused
		move.w	ost_x_pos(a0),d3			; unused

Sonic_FindCeiling_Basic_2:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#-$80,d2
		bra.w	loc_14E0A

		endm

; ---------------------------------------------------------------------------
; Object 01 - Sonic, part 6
; ---------------------------------------------------------------------------

include_Sonic_6:	macro

; ---------------------------------------------------------------------------
; Subroutine to	find distance to ceiling when Sonic is running up/down a wall
; and the ceiling is to his left

; output:
;	d1 = distance to ceiling
;	a1 = address within 256x256 mappings where Sonic is standing
;	(a1) = 16x16 tile number
;	(a4) = floor angle
; ---------------------------------------------------------------------------

Sonic_FindCeilingLeft:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		sub.w	d0,d2					; d2 = y pos. of Sonic's topmost edge (left/right)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's leftmost edge (top)
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)				; save distance from head to wall in stack
		
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3
		moveq	#0,d0
		move.b	ost_width(a0),d0
		ext.w	d0
		add.w	d0,d2					; d2 = y pos. of Sonic's bottommost edge (right/left)
		move.b	ost_height(a0),d0
		ext.w	d0
		sub.w	d0,d3					; d3 = x pos. of Sonic's rightmost edge (bottom)
		eori.w	#$F,d3
		lea	(v_angle_left).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall				; d1 = distance from feet to wall
		move.w	(sp)+,d0				; retrieve distance from head to wall from stack
		
		move.b	#$40,d2
		bra.w	Sonic_FindSmaller

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic when	he jumps at a wall
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_FindCeilingLeft_Basic:
		move.w	ost_y_pos(a0),d2
		move.w	ost_x_pos(a0),d3

Sonic_FindCeilingLeft_Basic_2:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_angle_right).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	loc_14E0A
; End of function Sonic_FindCeilingLeft_Basic

		endm
