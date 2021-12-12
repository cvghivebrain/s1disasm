; ---------------------------------------------------------------------------
; Object 0A - drowning countdown numbers and small bubbles that float out of
; Sonic's mouth (LZ)
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
		ptr Drown_Display
		ptr Drown_Delete

ost_drown_restart_time:	equ $2C					; time to restart after Sonic drowns (2 bytes)
ost_drown_x_start:	equ $30					; original x-axis position (2 bytes)
ost_drown_disp_time:	equ $32					; time to display each number
ost_drown_type:		equ $33					; bubble type
ost_drown_extra_bub:	equ $34					; number of extra bubbles to create
ost_drown_extra_flag:	equ $36					; flags for extra bubbles (2 bytes)
ost_drown_num_time:	equ $38					; time between each number changes (2 bytes)
;			equ $3A	; some sort of delay for something (2 bytes)
; ===========================================================================

Drown_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bub,ost_mappings(a0)
		move.w	#tile_Nem_Bubbles+tile_hi,ost_tile(a0)
		move.b	#render_onscreen+render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	ost_subtype(a0),d0			; get bubble type (first bubble is $81)
		bpl.s	@smallbubble				; branch if $00-$7F

		addq.b	#8,ost_routine(a0)			; goto Drown_Countdown next
		move.l	#Map_Drown,ost_mappings(a0)
		move.w	#$440,ost_tile(a0)
		andi.w	#$7F,d0					; ignore high bit (first bubble is 1)
		move.b	d0,ost_drown_type(a0)
		bra.w	Drown_Countdown
; ===========================================================================

@smallbubble:
		move.b	d0,ost_anim(a0)
		move.w	ost_x_pos(a0),ost_drown_x_start(a0)
		move.w	#-$88,ost_y_vel(a0)

Drown_Animate:	; Routine 2
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l

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
		move.b	(a1,d0.w),d0
		ext.w	d0
		add.w	ost_drown_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		bsr.s	Drown_ShowNumber
		jsr	(SpeedToPos).l
		tst.b	ost_render(a0)
		bpl.s	@delete
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Drown_Display:	; Routine 6, Routine $E
		bsr.s	Drown_ShowNumber
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Drown_Delete:	; Routine 8, Routine $10
		jmp	(DeleteObject).l
; ===========================================================================

Drown_AirLeft:	; Routine $C
		cmpi.w	#$C,(v_air).w				; check air remaining
		bhi.s	Drown_AirLeft_Delete			; if higher than $C, branch
		subq.w	#1,ost_drown_num_time(a0)
		bne.s	@display
		move.b	#id_Drown_Display+8,ost_routine(a0)	; goto Drown_Display next
		addq.b	#7,ost_anim(a0)
		bra.s	Drown_Display
; ===========================================================================

	@display:
		lea	(Ani_Drown).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_render(a0)
		bpl.s	Drown_AirLeft_Delete
		jmp	(DisplaySprite).l

Drown_AirLeft_Delete:	
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
		tst.w	ost_drown_restart_time(a0)
		bne.w	@loc_13F86
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; is Sonic dead?
		bcc.w	@nocountdown				; if yes, branch
		btst	#status_underwater_bit,(v_ost_player+ost_status).w ; is Sonic underwater?
		beq.w	@nocountdown				; if not, branch

		subq.w	#1,ost_drown_num_time(a0)		; decrement timer
		bpl.w	@nochange				; branch if time remains
		move.w	#59,ost_drown_num_time(a0)
		move.w	#1,ost_drown_extra_flag(a0)
		jsr	(RandomNumber).l
		andi.w	#1,d0
		move.b	d0,ost_drown_extra_bub(a0)
		move.w	(v_air).w,d0				; check air remaining
		cmpi.w	#25,d0
		beq.s	@warnsound				; play sound if	air is 25
		cmpi.w	#20,d0
		beq.s	@warnsound
		cmpi.w	#15,d0
		beq.s	@warnsound
		cmpi.w	#12,d0
		bhi.s	@reduceair				; if air is above 12, branch

		bne.s	@skipmusic				; if air is less than 12, branch
		play.w	0, jsr, mus_Drowning			; play countdown music

	@skipmusic:
		subq.b	#1,ost_drown_disp_time(a0)
		bpl.s	@reduceair
		move.b	ost_drown_type(a0),ost_drown_disp_time(a0)
		bset	#7,ost_drown_extra_flag(a0)
		bra.s	@reduceair
; ===========================================================================

@warnsound:
		play.w	1, jsr, sfx_Ding			; play "ding-ding" warning sound

@reduceair:
		subq.w	#1,(v_air).w				; subtract 1 from air remaining
		bcc.w	@gotomakenum				; if air is above 0, branch

		; Sonic drowns here
		bsr.w	ResumeMusic
		move.b	#$81,(v_lock_multi).w			; lock controls
		play.w	1, jsr, sfx_Drown			; play drowning sound
		move.b	#$A,ost_drown_extra_bub(a0)
		move.w	#1,ost_drown_extra_flag(a0)
		move.w	#$78,ost_drown_restart_time(a0)
		move.l	a0,-(sp)
		lea	(v_ost_player).w,a0
		bsr.w	Sonic_ResetOnFloor
		move.b	#id_Drown,ost_anim(a0)			; use Sonic's drowning animation
		bset	#status_air_bit,ost_status(a0)
		bset	#tile_hi_bit,ost_tile(a0)
		move.w	#0,ost_y_vel(a0)
		move.w	#0,ost_x_vel(a0)
		move.w	#0,ost_inertia(a0)
		move.b	#1,(f_disable_scrolling).w
		movea.l	(sp)+,a0
		rts	
; ===========================================================================

@loc_13F86:
		subq.w	#1,ost_drown_restart_time(a0)
		bne.s	@loc_13F94
		move.b	#id_Sonic_Death,(v_ost_player+ost_routine).w
		rts	
; ===========================================================================

	@loc_13F94:
		move.l	a0,-(sp)
		lea	(v_ost_player).w,a0
		jsr	(SpeedToPos).l
		addi.w	#$10,ost_y_vel(a0)
		movea.l	(sp)+,a0
		bra.s	@nochange
; ===========================================================================

@gotomakenum:
		bra.s	@makenum
; ===========================================================================

@nochange:
		tst.w	ost_drown_extra_flag(a0)
		beq.w	@nocountdown
		subq.w	#1,$3A(a0)
		bpl.w	@nocountdown

@makenum:
		jsr	(RandomNumber).l
		andi.w	#$F,d0
		move.w	d0,$3A(a0)
		jsr	(FindFreeObj).l
		bne.w	@nocountdown
		move.b	#id_DrownCount,0(a1)			; load object
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a1) ; match X position to Sonic
		moveq	#6,d0
		btst	#status_xflip_bit,(v_ost_player+ost_status).w
		beq.s	@noflip
		neg.w	d0
		move.b	#$40,ost_angle(a1)

	@noflip:
		add.w	d0,ost_x_pos(a1)
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a1)
		move.b	#6,ost_subtype(a1)			; object is small bubble
		tst.w	ost_drown_restart_time(a0)
		beq.w	@loc_1403E
		andi.w	#7,$3A(a0)
		addi.w	#0,$3A(a0)
		move.w	(v_ost_player+ost_y_pos).w,d0
		subi.w	#$C,d0
		move.w	d0,ost_y_pos(a1)
		jsr	(RandomNumber).l
		move.b	d0,ost_angle(a1)
		move.w	(v_frame_counter).w,d0
		andi.b	#3,d0
		bne.s	@loc_14082
		move.b	#$E,ost_subtype(a1)			; object is medium bubble
		bra.s	@loc_14082
; ===========================================================================

@loc_1403E:
		btst	#7,ost_drown_extra_flag(a0)
		beq.s	@loc_14082
		move.w	(v_air).w,d2				; get air remaining
		lsr.w	#1,d2					; divide by 2
		jsr	(RandomNumber).l
		andi.w	#3,d0
		bne.s	@loc_1406A
		bset	#6,ost_drown_extra_flag(a0)
		bne.s	@loc_14082
		move.b	d2,ost_subtype(a1)			; object is a number
		move.w	#$1C,ost_drown_num_time(a1)

	@loc_1406A:
		tst.b	ost_drown_extra_bub(a0)
		bne.s	@loc_14082
		bset	#6,ost_drown_extra_flag(a0)
		bne.s	@loc_14082
		move.b	d2,ost_subtype(a1)
		move.w	#$1C,ost_drown_num_time(a1)

@loc_14082:
		subq.b	#1,ost_drown_extra_bub(a0)
		bpl.s	@nocountdown
		clr.w	ost_drown_extra_flag(a0)

@nocountdown:
		rts	
