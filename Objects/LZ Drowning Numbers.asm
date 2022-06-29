; ---------------------------------------------------------------------------
; Object 0A - drowning countdown numbers and small bubbles that float out of
; Sonic's mouth (LZ)

; spawned by:
;	SonicPlayer - subtype $81
;	DrownCount - subtypes 6 (small), $E (medium), 0-5 (numbers)
; ---------------------------------------------------------------------------

DrownCount:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Drown_Index(pc,d0.w),d1
		jmp	Drown_Index(pc,d1.w)
; ===========================================================================
Drown_Index:	index *,,2
		ptr Drown_Main
		ptr Drown_Animate
		ptr Drown_ChkWater
		ptr Drown_Display
		ptr Drown_Delete
		ptr Drown_Countdown
		ptr Drown_AirLeft
		ptr Drown_Display_Num
		ptr Drown_Delete

		rsobj DrownCount,$2C
ost_drown_restart_time:	rs.w 1					; $2C ; time to restart after Sonic drowns
		rsset $30
ost_drown_x_start:	rs.w 1					; $30 ; original x-axis position
ost_drown_disp_time:	rs.b 1					; $32 ; time to display each number
ost_drown_type:		rs.b 1					; $33 ; bubble type
ost_drown_extra_bub:	rs.b 1					; $34 ; number of extra bubbles to create
ost_drown_extra_flag:	rs.w 1					; $36 ; flags for extra bubbles
ost_drown_num_time:	rs.w 1					; $38 ; time between each number changes
ost_drown_delay_time	rs.w 1					; $3A ; delay between bubbles
		rsobjend
; ===========================================================================

Drown_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Drown_Animate next
		move.l	#Map_Bub,ost_mappings(a0)
		move.w	#tile_Nem_Bubbles+tile_hi,ost_tile(a0)
		move.b	#render_onscreen+render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	ost_subtype(a0),d0			; get bubble type (first bubble is $81)
		bpl.s	@bubble_or_num				; branch if $00-$7F

		addq.b	#8,ost_routine(a0)			; goto Drown_Countdown next
		move.l	#Map_Drown,ost_mappings(a0)
		move.w	#$440,ost_tile(a0)			; VRAM $8800 - Sonic's face holding his breath (REV00 only)
		andi.w	#$7F,d0					; ignore high bit of type
		move.b	d0,ost_drown_type(a0)			; type should be 1
		bra.w	Drown_Countdown
; ===========================================================================

@bubble_or_num:
		move.b	d0,ost_anim(a0)				; use animation from subtype (0-5 = nums; 6 = small bubble; $E = medium)
		move.w	ost_x_pos(a0),ost_drown_x_start(a0)
		move.w	#-$88,ost_y_vel(a0)

Drown_Animate:	; Routine 2
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l			; run animation and goto Drown_ChkWater next

Drown_ChkWater:	; Routine 4
		move.w	(v_water_height_actual).w,d0
		cmp.w	ost_y_pos(a0),d0			; has bubble reached the water surface?
		bcs.s	@wobble					; if not, branch

		move.b	#id_Drown_Display,ost_routine(a0)	; goto Drown_Display next
		addq.b	#7,ost_anim(a0)
		cmpi.b	#id_ani_drown_blank,ost_anim(a0)
		beq.s	Drown_Display
		bra.s	Drown_Display
; ===========================================================================

@wobble:
		tst.b	(f_water_tunnel_now).w			; is Sonic in a water tunnel?
		beq.s	@notunnel				; if not, branch
		addq.w	#4,ost_drown_x_start(a0)

	@notunnel:
		move.b	ost_angle(a0),d0
		addq.b	#1,ost_angle(a0)
		andi.w	#$7F,d0
		lea	(Drown_WobbleData).l,a1
		move.b	(a1,d0.w),d0				; get byte from wobble data array based on angle value
		ext.w	d0
		add.w	ost_drown_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)			; update position
		bsr.s	Drown_ShowNumber
		jsr	(SpeedToPos).l
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.s	@delete					; if not, branch
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Drown_Display:	; Routine 6, Routine $E
Drown_Display_Num:
		bsr.s	Drown_ShowNumber
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Drown_Delete:	; Routine 8, Routine $10
		jmp	(DeleteObject).l
; ===========================================================================

Drown_AirLeft:	; Routine $C
		cmpi.w	#air_alert,(v_air).w			; check air remaining
		bhi.s	@delete					; if higher than $C, branch
		subq.w	#1,ost_drown_num_time(a0)
		bne.s	@display
		move.b	#id_Drown_Display_Num,ost_routine(a0)	; goto Drown_Display next
		addq.b	#7,ost_anim(a0)				; use flashing number animation
		bra.s	Drown_Display
; ===========================================================================

	@display:
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_render(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:	
		jmp	(DeleteObject).l
; ===========================================================================

Drown_ShowNumber:
		tst.w	ost_drown_num_time(a0)
		beq.s	@nonumber
		subq.w	#1,ost_drown_num_time(a0)		; decrement timer
		bne.s	@nonumber				; if time remains, branch
		cmpi.b	#id_ani_drown_zeroflash,ost_anim(a0)
		bcc.s	@nonumber

		move.w	#15,ost_drown_num_time(a0)
		clr.w	ost_y_vel(a0)
		move.b	#render_onscreen+render_abs,ost_render(a0)
		move.w	ost_x_pos(a0),d0
		sub.w	(v_camera_x_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,ost_x_pos(a0)
		move.w	ost_y_pos(a0),d0
		sub.w	(v_camera_y_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,ost_y_screen(a0)
		move.b	#id_Drown_AirLeft,ost_routine(a0)	; goto Drown_AirLeft next

	@nonumber:
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Data for a bubble's side-to-side wobble (also used by REV01's underwater
; background ripple effect)
; ---------------------------------------------------------------------------
Drown_WobbleData:
LZ_BG_Ripple_Data:
		if Revision=0
		dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
		dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
		dc.b 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
		dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
		dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
		dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
		dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
		dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1
		else
		rept 2
		dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
		dc.b 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
		dc.b 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
		dc.b 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
		dc.b 0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -3, -3, -3, -3, -3
		dc.b -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4
		dc.b -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3
		dc.b -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1
		endr
		endc
; ===========================================================================

Drown_Countdown:; Routine $A
		tst.w	ost_drown_restart_time(a0)		; has Sonic drowned?
		bne.w	@kill_sonic				; if yes, branch
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dead?
		bcc.w	@nocountdown				; if yes, branch
		btst	#status_underwater_bit,(v_ost_player+ost_status).w ; is Sonic underwater?
		beq.w	@nocountdown				; if not, branch

		subq.w	#1,ost_drown_num_time(a0)		; decrement timer between countdown number changes
		bpl.w	@create_bubble				; branch if time remains
		move.w	#59,ost_drown_num_time(a0)		; set timer to 1 second
		move.w	#1,ost_drown_extra_flag(a0)
		jsr	(RandomNumber).l
		andi.w	#1,d0					; random number 0 or 1
		move.b	d0,ost_drown_extra_bub(a0)
		move.w	(v_air).w,d0				; check air remaining
		cmpi.w	#air_ding1,d0
		beq.s	@warnsound				; play sound if	air is 25
		cmpi.w	#air_ding2,d0
		beq.s	@warnsound				; play sound if	air is 20
		cmpi.w	#air_ding3,d0
		beq.s	@warnsound				; play sound if	air is 15
		cmpi.w	#air_alert,d0
		bhi.s	@reduceair				; if air is above 12, branch

		bne.s	@skipmusic				; if air is less than 12, branch
		play.w	0, jsr, mus_Drowning			; play countdown music

	@skipmusic:
		subq.b	#1,ost_drown_disp_time(a0)		; decrement display timer
		bpl.s	@reduceair				; branch if time remains
		move.b	ost_drown_type(a0),ost_drown_disp_time(a0) ; reset timer (1)
		bset	#7,ost_drown_extra_flag(a0)
		bra.s	@reduceair
; ===========================================================================

@warnsound:
		play.w	1, jsr, sfx_Ding			; play "ding-ding" warning sound

@reduceair:
		subq.w	#1,(v_air).w				; decrement air remaining
		bcc.w	@gotomakenum				; if air is above 0, branch

		; Sonic drowns here
		bsr.w	ResumeMusic
		move.b	#$81,(v_lock_multi).w			; lock controls
		play.w	1, jsr, sfx_Drown			; play drowning sound
		move.b	#$A,ost_drown_extra_bub(a0)
		move.w	#1,ost_drown_extra_flag(a0)
		move.w	#120,ost_drown_restart_time(a0)		; restart after 2 seconds
		move.l	a0,-(sp)				; save OST address to stack
		lea	(v_ost_player).w,a0			; use Sonic's OST temporarily
		bsr.w	Sonic_ResetOnFloor			; clear Sonic's status flags
		move.b	#id_Drown,ost_anim(a0)			; use Sonic's drowning animation
		bset	#status_air_bit,ost_status(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#0,ost_y_vel(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_inertia(a0)
		move.b	#1,(f_disable_scrolling).w
		movea.l	(sp)+,a0				; restore OST from stack
		rts	
; ===========================================================================

@kill_sonic:
		subq.w	#1,ost_drown_restart_time(a0)		; decrement delay timer after drowning
		bne.s	@delay_death				; branch if time remains
		move.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; kill Sonic
		rts	
; ===========================================================================

	@delay_death:
		move.l	a0,-(sp)				; save OST address to stack
		lea	(v_ost_player).w,a0			; use Sonic's OST temporarily
		jsr	(SpeedToPos).l				; update Sonic's position
		addi.w	#$10,ost_y_vel(a0)			; make Sonic fall
		movea.l	(sp)+,a0				; restore OST
		bra.s	@create_bubble
; ===========================================================================

@gotomakenum:
		bra.s	@makenum
; ===========================================================================

@create_bubble:
		tst.w	ost_drown_extra_flag(a0)		; should bubbles/numbers be spawned?
		beq.w	@nocountdown				; if not, branch
		subq.w	#1,ost_drown_delay_time(a0)		; decrement timer between bubble spawning
		bpl.w	@nocountdown				; branch if time remains

@makenum:
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		move.w	d0,ost_drown_delay_time(a0)		; set timer as random 0-15 frames
		jsr	(FindFreeObj).l				; find free OST slot
		bne.w	@nocountdown				; branch if not found
		move.b	#id_DrownCount,ost_id(a1)		; load object
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a1)
		moveq	#6,d0					; 6 pixels to right
		btst	#status_xflip_bit,(v_ost_player+ost_status).w ; is Sonic facing left?
		beq.s	@noflip					; if not, branch
		neg.w	d0					; 6 pixels to left
		move.b	#$40,ost_angle(a1)

	@noflip:
		add.w	d0,ost_x_pos(a1)
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a1)
		move.b	#id_ani_drown_smallbubble,ost_subtype(a1) ; object is small bubble (6)
		tst.w	ost_drown_restart_time(a0)		; has Sonic drowned?
		beq.w	@not_dead				; if not, branch
		andi.w	#7,ost_drown_delay_time(a0)		; cut time between bubbles to 7 frames or less
		addi.w	#0,ost_drown_delay_time(a0)
		move.w	(v_ost_player+ost_y_pos).w,d0
		subi.w	#$C,d0
		move.w	d0,ost_y_pos(a1)
		jsr	(RandomNumber).l
		move.b	d0,ost_angle(a1)
		move.w	(v_frame_counter).w,d0
		andi.b	#3,d0
		bne.s	@loc_14082
		move.b	#id_ani_drown_mediumbubble,ost_subtype(a1) ; object is medium bubble ($E)
		bra.s	@loc_14082
; ===========================================================================

@not_dead:
		btst	#7,ost_drown_extra_flag(a0)
		beq.s	@loc_14082
		move.w	(v_air).w,d2				; get air remaining
		lsr.w	#1,d2					; divide by 2
		jsr	(RandomNumber).l
		andi.w	#3,d0
		bne.s	@loc_1406A
		bset	#6,ost_drown_extra_flag(a0)
		bne.s	@loc_14082
		move.b	d2,ost_subtype(a1)			; object is a number (0-5)
		move.w	#28,ost_drown_num_time(a1)

	@loc_1406A:
		tst.b	ost_drown_extra_bub(a0)
		bne.s	@loc_14082
		bset	#6,ost_drown_extra_flag(a0)
		bne.s	@loc_14082
		move.b	d2,ost_subtype(a1)
		move.w	#28,ost_drown_num_time(a1)

@loc_14082:
		subq.b	#1,ost_drown_extra_bub(a0)
		bpl.s	@nocountdown
		clr.w	ost_drown_extra_flag(a0)

@nocountdown:
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_DrownCount_animation:	macro

Ani_Drown:	index *
		ptr ani_drown_zeroappear
		ptr ani_drown_oneappear
		ptr ani_drown_twoappear
		ptr ani_drown_threeappear
		ptr ani_drown_fourappear
		ptr ani_drown_fiveappear
		ptr ani_drown_smallbubble			; 6
		ptr ani_drown_zeroflash				; 7
		ptr ani_drown_oneflash				; 8
		ptr ani_drown_twoflash				; 9
		ptr ani_drown_threeflash			; $A
		ptr ani_drown_fourflash				; $B
		ptr ani_drown_fiveflash				; $C
		ptr ani_drown_blank				; $D
		ptr ani_drown_mediumbubble			; $E
		
ani_drown_zeroappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_zero_small
		dc.b id_frame_bubble_zero
		dc.b afRoutine
		even

ani_drown_oneappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_one_small
		dc.b id_frame_bubble_one
		dc.b afRoutine
		even

ani_drown_twoappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_one_small
		dc.b id_frame_bubble_two
		dc.b afRoutine
		even

ani_drown_threeappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_three_small
		dc.b id_frame_bubble_three
		dc.b afRoutine
		even

ani_drown_fourappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_zero_small
		dc.b id_frame_bubble_four
		dc.b afRoutine
		even

ani_drown_fiveappear:
		dc.b 5
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b id_frame_bubble_five_small
		dc.b id_frame_bubble_five
		dc.b afRoutine
		even

ani_drown_smallbubble:
		dc.b $E
		dc.b id_frame_bubble_0
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b afRoutine
		even

ani_drown_zeroflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_zero
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_zero
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_zero
		dc.b afRoutine

ani_drown_oneflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_one
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_one
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_one
		dc.b afRoutine

ani_drown_twoflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_two
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_two
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_two
		dc.b afRoutine

ani_drown_threeflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_three
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_three
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_three
		dc.b afRoutine

ani_drown_fourflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_four
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_four
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_four
		dc.b afRoutine

ani_drown_fiveflash:
		dc.b 7
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_five
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_five
		dc.b id_frame_bubble_blank
		dc.b id_frame_bubble_five
		dc.b afRoutine

ani_drown_blank:
		dc.b $E
		dc.b afRoutine

ani_drown_mediumbubble:
		dc.b $E
		dc.b id_frame_bubble_1
		dc.b id_frame_bubble_2
		dc.b id_frame_bubble_3
		dc.b id_frame_bubble_4
		dc.b afRoutine
		even

		endm
