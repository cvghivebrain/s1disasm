; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w	; is debug mode	being used?
		beq.s	Sonic_Normal	; if not, branch
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
		addq.b	#2,ost_routine(a0)
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		move.l	#Map_Sonic,ost_mappings(a0)
		move.w	#$780,ost_tile(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	#$600,(v_sonspeedmax).w ; Sonic's top speed
		move.w	#$C,(v_sonspeedacc).w ; Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; Sonic's deceleration

Sonic_Control:	; Routine 2
		tst.w	(f_debugmode).w	; is debug cheat enabled?
		beq.s	loc_12C58	; if not, branch
		btst	#bitB,(v_joypad_press_actual).w ; is button B pressed?
		beq.s	loc_12C58	; if not, branch
		move.w	#1,(v_debuguse).w ; change Sonic into a ring/item
		clr.b	(f_lockctrl).w
		rts	
; ===========================================================================

loc_12C58:
		tst.b	(f_lockctrl).w	; are controls locked?
		bne.s	loc_12C64	; if yes, branch
		move.w	(v_joypad_hold_actual).w,(v_joypad_hold).w ; enable joypad control

loc_12C64:
		btst	#0,(f_lockmulti).w ; are controls locked?
		bne.s	loc_12C7E	; if yes, branch
		moveq	#0,d0
		move.b	ost_status(a0),d0
		andi.w	#6,d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)

loc_12C7E:
		bsr.s	Sonic_Display
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Water
		move.b	(v_angle_right).w,ost_sonic_angle_right(a0)
		move.b	(v_angle_left).w,ost_sonic_angle_left(a0)
		tst.b	(f_wtunnelmode).w
		beq.s	loc_12CA6
		tst.b	ost_anim(a0)
		bne.s	loc_12CA6
		move.b	ost_anim_restart(a0),ost_anim(a0)

loc_12CA6:
		bsr.w	Sonic_Animate
		tst.b	(f_lockmulti).w	; are controls locked?
		bmi.s	loc_12CB6	; if yes, branch
		jsr	(ReactToItem).l	; run collisions with enemies or anything that uses ost_col_type

loc_12CB6:
		bsr.w	Sonic_Loops
		bsr.w	Sonic_LoadGfx
		rts	
; ===========================================================================
Sonic_Modes:	index *,,2
		ptr Sonic_Mode_Normal
		ptr Sonic_Mode_Jump
		ptr Sonic_Mode_Roll
		ptr Sonic_Mode_Jump2
		
; ---------------------------------------------------------------------------
; Music	to play	after invincibility wears off
; ---------------------------------------------------------------------------
MusicList2:
		dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SYZ
		dc.b bgm_SBZ
		zonewarning MusicList2,1
		; The ending doesn't get an entry
		even

; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	ost_sonic_flash_time(a0),d0 ; is Sonic flashing?
		beq.s	@display	; if not, branch
		subq.w	#1,ost_sonic_flash_time(a0) ; decrement timer
		lsr.w	#3,d0		; is Sonic on a visible frame?
		bcc.s	@chkinvincible	; if not, branch

	@display:
		jsr	(DisplaySprite).l

	@chkinvincible:
		tst.b	(v_invinc).w	; does Sonic have invincibility?
		beq.s	@chkshoes	; if not, branch
		tst.w	ost_sonic_inv_time(a0) ; check invinciblity timer
		beq.s	@chkshoes	; if 0, branch
		subq.w	#1,ost_sonic_inv_time(a0) ; decrement timer
		bne.s	@chkshoes
		tst.b	(f_lockscreen).w
		bne.s	@removeinvincible
		cmpi.w	#$C,(v_air).w	; is air < $C?
		bcs.s	@removeinvincible ; if yes, branch
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; check if level is SBZ3
		bne.s	@music		; if not, branch
		moveq	#5,d0		; play SBZ music

	@music:
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound).l	; play normal music

	@removeinvincible:
		move.b	#0,(v_invinc).w ; cancel invincibility

	@chkshoes:
		tst.b	(v_shoes).w	; does Sonic have speed	shoes?
		beq.s	@exit		; if not, branch
		tst.w	ost_sonic_shoe_time(a0)	; check	time remaining
		beq.s	@exit		; if 0, branch
		subq.w	#1,ost_sonic_shoe_time(a0) ; decrement timer
		bne.s	@exit
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		move.b	#0,(v_shoes).w	; cancel speed shoes
		music	bgm_Slowdown,1,0,0 ; run music at normal speed

	@exit:
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	record Sonic's previous positions for invincibility stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RecordPosition:
		move.w	(v_trackpos).w,d0
		lea	(v_sonic_pos_tracker).w,a1
		lea	(a1,d0.w),a1
		move.w	ost_x_pos(a0),(a1)+
		move.w	ost_y_pos(a0),(a1)+
		addq.b	#4,(v_trackbyte).w
		rts	
; End of function Sonic_RecordPosition
; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Water:
		cmpi.b	#1,(v_zone).w	; is level LZ?
		beq.s	@islabyrinth	; if yes, branch

	@exit:
		rts	
; ===========================================================================

	@islabyrinth:
		move.w	(v_waterpos1).w,d0
		cmp.w	ost_y_pos(a0),d0 ; is Sonic above the water?
		bge.s	@abovewater	; if yes, branch
		bset	#status_underwater_bit,ost_status(a0)
		bne.s	@exit
		bsr.w	ResumeMusic
		move.b	#id_DrownCount,(v_ost_all+$340).w ; load bubbles object from Sonic's mouth
		move.b	#$81,(v_ost_all+$340+ost_subtype).w
		move.w	#$300,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#6,(v_sonspeedacc).w ; change Sonic's acceleration
		move.w	#$40,(v_sonspeeddec).w ; change Sonic's deceleration
		asr	ost_x_vel(a0)
		asr	ost_y_vel(a0)
		asr	ost_y_vel(a0)	; slow Sonic
		beq.s	@exit		; branch if Sonic stops moving
		move.b	#id_Splash,(v_ost_all+$300).w ; load splash object
		sfx	sfx_Splash,1,0,0  ; play splash sound
; ===========================================================================

@abovewater:
		bclr	#status_underwater_bit,ost_status(a0)
		beq.s	@exit
		bsr.w	ResumeMusic
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		asl	ost_y_vel(a0)
		beq.w	@exit
		move.b	#id_Splash,(v_ost_all+$300).w ; load splash object
		cmpi.w	#-$1000,ost_y_vel(a0)
		bgt.s	@belowmaxspeed
		move.w	#-$1000,ost_y_vel(a0) ; set maximum speed on leaving water

	@belowmaxspeed:
		sfx	sfx_Splash,1,0,0  ; play splash sound
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

Sonic_Mode_Jump:
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	loc_12E5C
		subi.w	#$28,ost_y_vel(a0)

loc_12E5C:
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

Sonic_Mode_Jump2:
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
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		move.w	(v_sonspeeddec).w,d4
		tst.b	(f_jumponly).w
		bne.w	Sonic_InertiaLR
		tst.w	ost_sonic_lock_time(a0) ; are controls locked?
		bne.w	Sonic_ResetScr	; if yes, branch
		btst	#bitL,(v_joypad_hold).w ; is left being pressed?
		beq.s	@notleft	; if not, branch
		bsr.w	Sonic_MoveLeft

	@notleft:
		btst	#bitR,(v_joypad_hold).w ; is right being pressed?
		beq.s	@notright	; if not, branch
		bsr.w	Sonic_MoveRight

	@notright:
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0		; is Sonic on a	slope?
		bne.w	Sonic_ResetScr	; if yes, branch
		tst.w	ost_inertia(a0)	; is Sonic moving?
		bne.w	Sonic_ResetScr	; if yes, branch
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#id_Wait,ost_anim(a0) ; use "standing" animation
		btst	#status_platform_bit,ost_status(a0) ; is Sonic on a platform?
		beq.s	Sonic_Balance	; if not, branch
		
		moveq	#0,d0
		move.b	ost_sonic_on_obj(a0),d0 ; get OST index of platform or object
		lsl.w	#6,d0
		lea	(v_ost_all).w,a1
		lea	(a1,d0.w),a1	; a1 = actual address of OST
		tst.b	ost_status(a1)
		bmi.s	Sonic_LookUp
		moveq	#0,d1
		move.b	ost_actwidth(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2		; d2 = width of platform -4
		add.w	ost_x_pos(a0),d1
		sub.w	ost_x_pos(a1),d1 ; d1 = Sonic's position - object's position + half object's width
		cmpi.w	#4,d1		; is Sonic within 4 pixels of left edge?
		blt.s	Sonic_BalLeft	; if yes, branch
		cmp.w	d2,d1		; is Sonic within 4 pixels of right edge?
		bge.s	Sonic_BalRight	; if yes, branch
		bra.s	Sonic_LookUp
; ===========================================================================

Sonic_Balance:
		jsr	(ObjFloorDist).l
		cmpi.w	#$C,d1
		blt.s	Sonic_LookUp
		cmpi.b	#3,ost_sonic_angle_right(a0) ; check for edge to the right
		bne.s	loc_12F62	; branch if not found

	Sonic_BalRight:
		bclr	#status_xflip_bit,ost_status(a0)
		bra.s	Sonic_DoBal
; ===========================================================================

	loc_12F62:
		cmpi.b	#3,ost_sonic_angle_left(a0) ; check for edge to the left
		bne.s	Sonic_LookUp	; branch if not found

	Sonic_BalLeft:
		bset	#status_xflip_bit,ost_status(a0)

	Sonic_DoBal:
		move.b	#id_Balance,ost_anim(a0) ; use "balancing" animation
		bra.s	Sonic_ResetScr
; ===========================================================================

Sonic_LookUp:
		btst	#bitUp,(v_joypad_hold).w ; is up being pressed?
		beq.s	Sonic_Duck	; if not, branch
		move.b	#id_LookUp,ost_anim(a0) ; use "looking up" animation
		cmpi.w	#$C8,(v_lookshift).w
		beq.s	Sonic_ScrOk
		addq.w	#2,(v_lookshift).w
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_Duck:
		btst	#bitDn,(v_joypad_hold).w ; is down being pressed?
		beq.s	Sonic_ResetScr	; if not, branch
		move.b	#id_Duck,ost_anim(a0) ; use "ducking" animation
		cmpi.w	#8,(v_lookshift).w
		beq.s	Sonic_ScrOk
		subq.w	#2,(v_lookshift).w
		bra.s	Sonic_ScrOk
; ===========================================================================

Sonic_ResetScr:
		cmpi.w	#$60,(v_lookshift).w ; is screen in its default position?
		beq.s	Sonic_ScrOk	; if yes, branch
		bcc.s	Sonic_HighScr	; branch if screen is higher
		addq.w	#4,(v_lookshift).w ; move screen back to default

	Sonic_HighScr:
		subq.w	#2,(v_lookshift).w ; move screen back to default

	Sonic_ScrOk:

Sonic_Inertia:
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0	; is left/right	pressed?
		bne.s	Sonic_InertiaLR	; if yes, branch
		move.w	ost_inertia(a0),d0 ; get Sonic's inertia
		beq.s	Sonic_InertiaLR	; if 0, branch
		bmi.s	@inertia_neg	; if negative, branch
		sub.w	d5,d0		; subtract acceleration
		bcc.s	@inertia_not_0	; branch if inertia is larger
		move.w	#0,d0

	@inertia_not_0:
		move.w	d0,ost_inertia(a0) ; update inertia
		bra.s	Sonic_InertiaLR
; ===========================================================================

	@inertia_neg:
		add.w	d5,d0
		bcc.s	@inertia_not_0_
		move.w	#0,d0

	@inertia_not_0_:
		move.w	d0,ost_inertia(a0) ; update inertia

Sonic_InertiaLR:
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		muls.w	ost_inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a0)
		muls.w	ost_inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a0)

loc_1300C:
		move.b	ost_angle(a0),d0
		addi.b	#$40,d0
		bmi.s	locret_1307C
		move.b	#$40,d1
		tst.w	ost_inertia(a0)
		beq.s	locret_1307C
		bmi.s	loc_13024
		neg.w	d1

loc_13024:
		move.b	ost_angle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	Sonic_WalkSpeed
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_1307C
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_13078
		cmpi.b	#$40,d0
		beq.s	loc_13066
		cmpi.b	#$80,d0
		beq.s	loc_13060
		add.w	d1,ost_x_vel(a0)
		bset	#5,ost_status(a0)
		move.w	#0,ost_inertia(a0)
		rts	
; ===========================================================================

loc_13060:
		sub.w	d1,ost_y_vel(a0)
		rts	
; ===========================================================================

loc_13066:
		sub.w	d1,ost_x_vel(a0)
		bset	#5,ost_status(a0)
		move.w	#0,ost_inertia(a0)
		rts	
; ===========================================================================

loc_13078:
		add.w	d1,ost_y_vel(a0)

locret_1307C:
		rts	
; End of function Sonic_Move


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveLeft:
		move.w	ost_inertia(a0),d0
		beq.s	loc_13086
		bpl.s	loc_130B2

loc_13086:
		bset	#status_xflip_bit,ost_status(a0)
		bne.s	loc_1309A
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#1,ost_anim_restart(a0)

loc_1309A:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_130A6
		move.w	d1,d0

loc_130A6:
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0) ; use walking animation
		rts	
; ===========================================================================

loc_130B2:
		sub.w	d4,d0
		bcc.s	loc_130BA
		move.w	#-$80,d0

loc_130BA:
		move.w	d0,ost_inertia(a0)
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_130E8
		cmpi.w	#$400,d0
		blt.s	locret_130E8
		move.b	#id_Stop,ost_anim(a0) ; use "stopping" animation
		bclr	#0,ost_status(a0)
		sfx	sfx_Skid,0,0,0	; play stopping sound

locret_130E8:
		rts	
; End of function Sonic_MoveLeft


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_MoveRight:
		move.w	ost_inertia(a0),d0
		bmi.s	loc_13118
		bclr	#status_xflip_bit,ost_status(a0)
		beq.s	loc_13104
		bclr	#status_pushing_bit,ost_status(a0)
		move.b	#1,ost_anim_restart(a0)

loc_13104:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_1310C
		move.w	d6,d0

loc_1310C:
		move.w	d0,ost_inertia(a0)
		move.b	#id_Walk,ost_anim(a0) ; use walking animation
		rts	
; ===========================================================================

loc_13118:
		add.w	d4,d0
		bcc.s	loc_13120
		move.w	#$80,d0

loc_13120:
		move.w	d0,ost_inertia(a0)
		move.b	ost_angle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_1314E
		cmpi.w	#-$400,d0
		bgt.s	locret_1314E
		move.b	#id_Stop,ost_anim(a0) ; use "stopping" animation
		bset	#0,ost_status(a0)
		sfx	sfx_Skid,0,0,0	; play stopping sound

locret_1314E:
		rts	
; End of function Sonic_MoveRight
; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's speed as he rolls
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollSpeed:
		move.w	(v_sonspeedmax).w,d6
		asl.w	#1,d6
		move.w	(v_sonspeedacc).w,d5
		asr.w	#1,d5
		move.w	(v_sonspeeddec).w,d4
		asr.w	#2,d4
		tst.b	(f_jumponly).w
		bne.w	loc_131CC
		tst.w	ost_sonic_lock_time(a0)
		bne.s	@notright
		btst	#bitL,(v_joypad_hold).w ; is left being pressed?
		beq.s	@notleft	; if not, branch
		bsr.w	Sonic_RollLeft

	@notleft:
		btst	#bitR,(v_joypad_hold).w ; is right being pressed?
		beq.s	@notright	; if not, branch
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
		tst.w	ost_inertia(a0)	; is Sonic moving?
		bne.s	loc_131CC	; if yes, branch
		bclr	#status_jump_bit,ost_status(a0)
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		move.b	#id_Wait,ost_anim(a0) ; use "standing" animation
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
		bra.w	loc_1300C
; End of function Sonic_RollSpeed


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RollLeft:
		move.w	ost_inertia(a0),d0
		beq.s	loc_1320A
		bpl.s	loc_13218

loc_1320A:
		bset	#status_xflip_bit,ost_status(a0)
		move.b	#id_Roll,ost_anim(a0) ; use "rolling" animation
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
		move.b	#id_Roll,ost_anim(a0) ; use "rolling" animation
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
		move.w	(v_sonspeedmax).w,d6
		move.w	(v_sonspeedacc).w,d5
		asl.w	#1,d5
		btst	#status_rolljump_bit,ost_status(a0) ; is Sonic jumping while rolling?
		bne.s	Obj01_ResetScr2	; if yes, branch
		
		move.w	ost_x_vel(a0),d0
		btst	#bitL,(v_joypad_hold).w ; is left being pressed?
		beq.s	loc_13278	; if not, branch
		bset	#status_xflip_bit,ost_status(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_13278
		move.w	d1,d0

	loc_13278:
		btst	#bitR,(v_joypad_hold).w ; is right being pressed?
		beq.s	Obj01_JumpMove	; if not, branch
		bclr	#status_xflip_bit,ost_status(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	Obj01_JumpMove
		move.w	d6,d0

Obj01_JumpMove:
		move.w	d0,ost_x_vel(a0) ; change Sonic's horizontal speed

Obj01_ResetScr2:
		cmpi.w	#$60,(v_lookshift).w ; is the screen in its default position?
		beq.s	loc_132A4	; if yes, branch
		bcc.s	loc_132A0
		addq.w	#4,(v_lookshift).w

loc_132A0:
		subq.w	#2,(v_lookshift).w

loc_132A4:
		cmpi.w	#-$400,ost_y_vel(a0) ; is Sonic moving faster than -$400 upwards?
		bcs.s	locret_132D2	; if yes, branch
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
		bne.s	locret_13302
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	locret_13302
		move.w	#0,ost_inertia(a0) ; stop Sonic moving
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_y_vel(a0)
		move.b	#id_Warp3,ost_anim(a0) ; use "warping" animation

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
		move.w	(v_limitleft2).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bhi.s	@sides		; if yes, branch
		move.w	(v_limitright2).w,d0
		addi.w	#$128,d0
		tst.b	(f_lockscreen).w
		bne.s	@screenlocked
		addi.w	#$40,d0

	@screenlocked:
		cmp.w	d1,d0		; has Sonic touched the	side boundary?
		bls.s	@sides		; if yes, branch

	@chkbottom:
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	ost_y_pos(a0),d0 ; has Sonic touched the bottom boundary?
		blt.s	@bottom		; if yes, branch
		rts	
; ===========================================================================

@bottom:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2 ?
		bne.w	KillSonic	; if not, kill Sonic
		cmpi.w	#$2000,(v_ost_player+ost_x_pos).w ; has Sonic reached $2000 on x-axis?
		bcs.w	KillSonic	; if not, kill Sonic
		clr.b	(v_lastlamp).w	; clear	lamppost counter
		move.w	#1,(f_restart).w ; restart the level
		move.w	#(id_LZ<<8)+3,(v_zone).w ; set level to SBZ3 (LZ4)
		rts	
; ===========================================================================

@sides:
		move.w	d0,ost_x_pos(a0)
		move.w	#0,ost_x_pos+2(a0)
		move.w	#0,ost_x_vel(a0)	; stop Sonic moving
		move.w	#0,ost_inertia(a0)
		bra.s	@chkbottom
; End of function Sonic_LevelBound
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to roll when he's moving
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Roll:
		tst.b	(f_jumponly).w
		bne.s	@noroll
		move.w	ost_inertia(a0),d0
		bpl.s	@ispositive
		neg.w	d0

	@ispositive:
		cmpi.w	#$80,d0		; is Sonic moving at $80 speed or faster?
		bcs.s	@noroll		; if not, branch
		move.b	(v_joypad_hold).w,d0
		andi.b	#btnL+btnR,d0	; is left/right	being pressed?
		bne.s	@noroll		; if yes, branch
		btst	#bitDn,(v_joypad_hold).w ; is down being pressed?
		bne.s	Sonic_ChkRoll	; if yes, branch

	@noroll:
		rts	
; ===========================================================================

Sonic_ChkRoll:
		btst	#status_jump_bit,ost_status(a0) ; is Sonic already rolling or jumping?
		beq.s	@roll		; if not, branch
		rts	
; ===========================================================================

@roll:
		bset	#status_jump_bit,ost_status(a0)
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0) ; use "rolling" animation
		addq.w	#5,ost_y_pos(a0)
		sfx	sfx_Roll,0,0,0	; play rolling sound
		tst.w	ost_inertia(a0)
		bne.s	@ismoving
		move.w	#$200,ost_inertia(a0) ; set inertia if 0

	@ismoving:
		rts	
; End of function Sonic_Roll
; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Jump:
		move.b	(v_joypad_press).w,d0
		andi.b	#btnABC,d0	; is A, B or C pressed?
		beq.w	locret_1348E	; if not, branch
		moveq	#0,d0
		move.b	ost_angle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_14D48
		cmpi.w	#6,d1
		blt.w	locret_1348E
		move.w	#$680,d2	; jump height
		btst	#status_underwater_bit,ost_status(a0)
		beq.s	loc_1341C
		move.w	#$380,d2	; underwater jump height

loc_1341C:
		moveq	#0,d0
		move.b	ost_angle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,ost_x_vel(a0) ; make Sonic jump
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,ost_y_vel(a0) ; make Sonic jump
		bset	#status_air_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a0)
		addq.l	#4,sp
		move.b	#1,ost_sonic_jump(a0)
		clr.b	ost_sonic_sbz_disc(a0)
		sfx	sfx_Jump,0,0,0	; play jumping sound
		move.b	#$13,ost_height(a0)
		move.b	#9,ost_width(a0)
		btst	#status_jump_bit,ost_status(a0) ; is Sonic rolling?
		bne.s	loc_13490	; if yes, branch
		move.b	#$E,ost_height(a0)
		move.b	#7,ost_width(a0)
		move.b	#id_Roll,ost_anim(a0) ; use "jumping" animation
		bset	#status_jump_bit,ost_status(a0)
		addq.w	#5,ost_y_pos(a0)

locret_1348E:
		rts	
; ===========================================================================

loc_13490:
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
		andi.b	#btnABC,d0	; is A, B or C pressed?
		bne.s	locret_134C2	; if yes, branch
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
		add.w	d0,ost_inertia(a0) ; change Sonic's inertia

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
		move.b	ost_angle(a0),d0	; get Sonic's angle
		beq.s	locret_135A2	; if already 0,	branch
		bpl.s	loc_13598	; if higher than 0, branch

		addq.b	#2,d0		; increase angle
		bcc.s	loc_13596
		moveq	#0,d0

loc_13596:
		bra.s	loc_1359E
; ===========================================================================

loc_13598:
		subq.b	#2,d0		; decrease angle
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
		move.b	d0,($FFFFFFEC).w
		subi.b	#$20,d0
		move.b	d0,($FFFFFFED).w
		andi.b	#$C0,d0
		move.b	d0,($FFFFFFEE).w
		cmpi.b	#$40,d0
		beq.w	loc_13680
		cmpi.b	#$80,d0
		beq.w	loc_136E2
		cmpi.b	#$C0,d0
		beq.w	loc_1373E
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_135F0
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_135F0:
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.s	loc_13602
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_13602:
		bsr.w	Sonic_HitFloor
		move.b	d1,($FFFFFFEF).w
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
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_1369A
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

loc_1369A:
		bsr.w	Sonic_DontRunOnWalls
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
		bsr.w	Sonic_HitFloor
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
		bsr.w	Sonic_HitWall
		tst.w	d1
		bpl.s	loc_136F4
		sub.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_136F4:
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.s	loc_13706
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)

loc_13706:
		bsr.w	Sonic_DontRunOnWalls
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
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.s	loc_13758
		add.w	d1,ost_x_pos(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	ost_y_vel(a0),ost_inertia(a0)
		rts	
; ===========================================================================

loc_13758:
		bsr.w	Sonic_DontRunOnWalls
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
		bsr.w	Sonic_HitFloor
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
		move.b	#id_Walk,ost_anim(a0) ; use running/walking animation
		subq.w	#5,ost_y_pos(a0)

loc_137E4:
		move.b	#0,ost_sonic_jump(a0)
		move.w	#0,(v_itembonus).w
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
		move.w	(v_limitbtm2).w,d0
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
		move.w	(v_limitbtm2).w,d0
		addi.w	#$100,d0
		cmp.w	ost_y_pos(a0),d0
		bcc.w	locret_13900
		move.w	#-$38,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)
		clr.b	(f_timecount).w	; stop time counter
		addq.b	#1,(f_lifecount).w ; update lives counter
		subq.b	#1,(v_lives).w	; subtract 1 from number of lives
		bne.s	loc_138D4
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_all+$80).w ; load GAME object
		move.b	#id_GameOverCard,(v_ost_all+$C0).w ; load OVER object
		move.b	#1,(v_ost_all+$C0+ost_frame).w ; set OVER object to correct frame
		clr.b	(f_timeover).w

loc_138C2:
		music	bgm_GameOver,0,0,0	; play game over music
		moveq	#3,d0
		jmp	(AddPLC).l	; load game over patterns
; ===========================================================================

loc_138D4:
		move.w	#60,ost_sonic_restart_time(a0) ; set time delay to 1 second
		tst.b	(f_timeover).w	; is TIME OVER tag set?
		beq.s	locret_13900	; if not, branch
		move.w	#0,ost_sonic_restart_time(a0)
		move.b	#id_GameOverCard,(v_ost_all+$80).w ; load TIME object
		move.b	#id_GameOverCard,(v_ost_all+$C0).w ; load OVER object
		move.b	#2,(v_ost_all+$80+ost_frame).w
		move.b	#3,(v_ost_all+$C0+ost_frame).w
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
		subq.w	#1,ost_sonic_restart_time(a0) ; subtract 1 from time delay
		bne.s	locret_13914
		move.w	#1,(f_restart).w ; restart the level

	locret_13914:
		rts	
; ---------------------------------------------------------------------------
; Subroutine to	make Sonic run around loops (GHZ/SLZ)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Loops:
		cmpi.b	#id_SLZ,(v_zone).w ; is level SLZ ?
		beq.s	@isstarlight	; if yes, branch
		tst.b	(v_zone).w	; is level GHZ ?
		bne.w	@noloops	; if not, branch

	@isstarlight:
		move.w	ost_y_pos(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.b	ost_x_pos(a0),d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(v_level_layout).w,a1
		move.b	(a1,d0.w),d1	; d1 is	the 256x256 tile Sonic is currently on

		cmp.b	(v_256roll1).w,d1 ; is Sonic on a "roll tunnel" tile?
		beq.w	Sonic_ChkRoll	; if yes, branch
		cmp.b	(v_256roll2).w,d1
		beq.w	Sonic_ChkRoll

		cmp.b	(v_256loop1).w,d1 ; is Sonic on a loop tile?
		beq.s	@chkifleft	; if yes, branch
		cmp.b	(v_256loop2).w,d1
		beq.s	@chkifinair
		bclr	#render_behind_bit,ost_render(a0) ; return Sonic to high plane
		rts	
; ===========================================================================

@chkifinair:
		btst	#status_air_bit,ost_status(a0) ; is Sonic in the air?
		beq.s	@chkifleft	; if not, branch

		bclr	#render_behind_bit,ost_render(a0) ; return Sonic to high plane
		rts	
; ===========================================================================

@chkifleft:
		move.w	ost_x_pos(a0),d2
		cmpi.b	#$2C,d2
		bcc.s	@chkifright

		bclr	#render_behind_bit,ost_render(a0) ; return Sonic to high plane
		rts	
; ===========================================================================

@chkifright:
		cmpi.b	#$E0,d2
		bcs.s	@chkangle1

		bset	#render_behind_bit,ost_render(a0) ; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle1:
		btst	#render_behind_bit,ost_render(a0) ; is Sonic on low plane?
		bne.s	@chkangle2	; if yes, branch

		move.b	ost_angle(a0),d1
		beq.s	@done
		cmpi.b	#$80,d1		; is Sonic upside-down?
		bhi.s	@done		; if yes, branch
		bset	#render_behind_bit,ost_render(a0) ; send Sonic to low plane
		rts	
; ===========================================================================

@chkangle2:
		move.b	ost_angle(a0),d1
		cmpi.b	#$80,d1		; is Sonic upright?
		bls.s	@done		; if yes, branch
		bclr	#render_behind_bit,ost_render(a0) ; send Sonic to high plane

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
		cmp.b	ost_anim_restart(a0),d0 ; is animation set to restart?
		beq.s	@do		; if not, branch
		move.b	d0,ost_anim_restart(a0) ; set to "no restart"
		move.b	#0,ost_anim_frame(a0) ; reset animation
		move.b	#0,ost_anim_time(a0) ; reset frame duration

	@do:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1	; jump to appropriate animation	script
		move.b	(a1),d0
		bmi.s	@walkrunroll	; if animation is walk/run/roll/jump, branch
		move.b	ost_status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,ost_render(a0)
		or.b	d1,ost_render(a0)
		subq.b	#1,ost_anim_time(a0) ; subtract 1 from frame duration
		bpl.s	@delay		; if time remains, branch
		move.b	d0,ost_anim_time(a0) ; load frame duration

@loadframe:
		moveq	#0,d1
		move.b	ost_anim_frame(a0),d1 ; load current frame number
		move.b	1(a1,d1.w),d0	; read sprite number from script
		bmi.s	@end_FF		; if animation is complete, branch

	@next:
		move.b	d0,ost_frame(a0)	; load sprite number
		addq.b	#1,ost_anim_frame(a0) ; next frame number

	@delay:
		rts	
; ===========================================================================

@end_FF:
		addq.b	#1,d0		; is the end flag = $FF	?
		bne.s	@end_FE		; if not, branch
		move.b	#0,ost_anim_frame(a0) ; restart the animation
		move.b	1(a1),d0	; read sprite number
		bra.s	@next
; ===========================================================================

@end_FE:
		addq.b	#1,d0		; is the end flag = $FE	?
		bne.s	@end_FD		; if not, branch
		move.b	2(a1,d1.w),d0	; read the next	byte in	the script
		sub.b	d0,ost_anim_frame(a0) ; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0	; read sprite number
		bra.s	@next
; ===========================================================================

@end_FD:
		addq.b	#1,d0		; is the end flag = $FD	?
		bne.s	@end		; if not, branch
		move.b	2(a1,d1.w),ost_anim(a0) ; read next byte, run that animation

	@end:
		rts	
; ===========================================================================

@walkrunroll:
		subq.b	#1,ost_anim_time(a0) ; subtract 1 from frame duration
		bpl.s	@delay		; if time remains, branch
		addq.b	#1,d0		; is animation walking/running?
		bne.w	@rolljump	; if not, branch
		moveq	#0,d1
		move.b	ost_angle(a0),d0 ; get Sonic's angle
		move.b	ost_status(a0),d2
		andi.b	#1,d2		; is Sonic mirrored horizontally?
		bne.s	@flip		; if yes, branch
		not.b	d0		; reverse angle

	@flip:
		addi.b	#$10,d0		; add $10 to angle
		bpl.s	@noinvert	; if angle is $0-$7F, branch
		moveq	#3,d1

	@noinvert:
		andi.b	#$FC,ost_render(a0)
		eor.b	d1,d2
		or.b	d2,ost_render(a0)
		btst	#status_pushing_bit,ost_status(a0) ; is Sonic pushing something?
		bne.w	@push		; if yes, branch

		lsr.b	#4,d0		; divide angle by $10
		andi.b	#6,d0		; angle	must be	0, 2, 4	or 6
		move.w	ost_inertia(a0),d2 ; get Sonic's speed
		bpl.s	@nomodspeed
		neg.w	d2		; modulus speed

	@nomodspeed:
		lea	(Run).l,a1	; use running animation
		cmpi.w	#$600,d2	; is Sonic at running speed?
		bcc.s	@running	; if yes, branch

		lea	(Walk).l,a1	; use walking animation
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

	@running:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	@belowmax
		moveq	#0,d2		; max animation speed

	@belowmax:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0) ; modify frame duration
		bsr.w	@loadframe
		add.b	d3,ost_frame(a0)	; modify frame number
		rts	
; ===========================================================================

@rolljump:
		addq.b	#1,d0		; is animation rolling/jumping?
		bne.s	@push		; if not, branch
		move.w	ost_inertia(a0),d2 ; get Sonic's speed
		bpl.s	@nomodspeed2
		neg.w	d2

	@nomodspeed2:
		lea	(Roll2).l,a1	; use fast animation
		cmpi.w	#$600,d2	; is Sonic moving fast?
		bcc.s	@rollfast	; if yes, branch
		lea	(Roll).l,a1	; use slower animation

	@rollfast:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	@belowmax2
		moveq	#0,d2

	@belowmax2:
		lsr.w	#8,d2
		move.b	d2,ost_anim_time(a0) ; modify frame duration
		move.b	ost_status(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,ost_render(a0)
		or.b	d1,ost_render(a0)
		bra.w	@loadframe
; ===========================================================================

@push:
		move.w	ost_inertia(a0),d2 ; get Sonic's speed
		bmi.s	@negspeed
		neg.w	d2

	@negspeed:
		addi.w	#$800,d2
		bpl.s	@belowmax3	
		moveq	#0,d2

	@belowmax3:
		lsr.w	#6,d2
		move.b	d2,ost_anim_time(a0) ; modify frame duration
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
		move.b	ost_frame(a0),d0 ; load frame number
		cmp.b	(v_sonframenum).w,d0 ; has frame changed?
		beq.s	@nochange	; if not, branch

		move.b	d0,(v_sonframenum).w
		lea	(SonicDynPLC).l,a2 ; load PLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1	; read "number of entries" value
		subq.b	#1,d1
		bmi.s	@nochange	; if zero, branch
		lea	(v_sonic_gfx_buffer).w,a3
		move.b	#1,(f_sonframechg).w ; set flag for Sonic graphics DMA

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
		lea	$20(a3),a3	; next tile
		dbf	d0,@loadtile	; repeat for number of tiles

		dbf	d1,@readentry	; repeat for number of entries

	@nochange:
		rts	

; End of function Sonic_LoadGfx
