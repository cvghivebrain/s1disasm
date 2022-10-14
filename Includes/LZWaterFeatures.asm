; ---------------------------------------------------------------------------
; Subroutine to	do special water effects in Labyrinth Zone

;	uses d0.l, d1.l, d2.w, a1, a2
; ---------------------------------------------------------------------------

LZWaterFeatures:
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	.notlabyrinth				; if not, branch
		if Revision=0
		else
			tst.b   (f_disable_scrolling).w
			bne.s	.set_height
		endc
		cmpi.b	#id_Sonic_Death,(v_ost_player+ost_routine).w ; has Sonic just died?
		bcc.s	.set_height				; if yes, skip other effects

		bsr.w	LZWindTunnels
		bsr.w	LZWaterSlides
		bsr.w	LZDynamicWater

	.set_height:
		clr.b	(f_water_pal_full).w
		moveq	#0,d0
		move.b	(v_oscillating_0_to_20).w,d0		; get oscillating value
		lsr.w	#1,d0
		add.w	(v_water_height_normal).w,d0		; add to normal water height
		move.w	d0,(v_water_height_actual).w		; set actual water height
		move.w	(v_water_height_actual).w,d0
		sub.w	(v_camera_y_pos).w,d0
		bcc.s	.isbelow				; branch if water is below top of screen
		tst.w	d0
		bpl.s	.isbelow

		move.b	#223,(v_vdp_hint_line).w
		move.b	#1,(f_water_pal_full).w			; screen is all underwater

	.isbelow:
		cmpi.w	#223,d0					; is water within 223 pixels of top of screen?
		bcs.s	.isvisible				; if yes, branch
		move.w	#223,d0					; HBlank runs at bottom of screen

	.isvisible:
		move.b	d0,(v_vdp_hint_line).w			; set water surface as on-screen

.notlabyrinth:
		rts

; ---------------------------------------------------------------------------
; Initial water heights
; ---------------------------------------------------------------------------

WaterHeight:	dc.w $B8					; Labyrinth 1
		dc.w $328					; Labyrinth 2
		dc.w $900					; Labyrinth 3
		dc.w $228					; Scrap Brain 3
		even

; ---------------------------------------------------------------------------
; Labyrinth dynamic water height routines

;	uses d0.l, d1.l, d2.b
; ---------------------------------------------------------------------------

LZDynamicWater:
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		move.w	DynWater_Index(pc,d0.w),d0
		jsr	DynWater_Index(pc,d0.w)
		moveq	#0,d1
		move.b	(v_water_direction).w,d1
		move.w	(v_water_height_next).w,d0
		sub.w	(v_water_height_normal).w,d0
		beq.s	.exit					; if water level is correct, branch
		bcc.s	.movewater				; if water level is too high, branch
		neg.w	d1					; set water to move up instead

	.movewater:
		add.w	d1,(v_water_height_normal).w		; move water up/down

	.exit:
		rts	
; ===========================================================================
DynWater_Index:	index *
		ptr DynWater_LZ1
		ptr DynWater_LZ2
		ptr DynWater_LZ3
		ptr DynWater_SBZ3
; ===========================================================================

DynWater_LZ1:
		move.w	(v_camera_x_pos).w,d0
		move.b	(v_water_routine).w,d2
		bne.s	DynWater_LZ1_1				; branch if water routine counter is 1

		move.w	#$B8,d1					; water height
		cmpi.w	#$600,d0
		bcs.s	.set_water				; branch if screen is left of $600

		move.w	#$108,d1
		cmpi.w	#$200,(v_ost_player+ost_y_pos).w
		bcs.s	.sonicishigh				; branch if Sonic is above $200
		cmpi.w	#$C00,d0
		bcs.s	.set_water				; branch if screen is left of $C00

		move.w	#$318,d1
		cmpi.w	#$1080,d0
		bcs.s	.set_water				; branch if screen is left of $1080

		move.b	#$80,(v_button_state+5).w		; set flag for button 5 pressed
		move.w	#$5C8,d1
		cmpi.w	#$1380,d0
		bcs.s	.set_water				; branch if screen is left of $1380

		move.w	#$3A8,d1
		cmp.w	(v_water_height_normal).w,d1
		bne.s	.set_water				; branch if water hasn't reached last height set
		move.b	#1,(v_water_routine).w			; goto DynWater_LZ1_1 next

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height
		rts	
; ===========================================================================

.sonicishigh:
		cmpi.w	#$C80,d0
		bcs.s	.set_water				; branch if screen is left of $C80
		move.w	#$E8,d1
		cmpi.w	#$1500,d0
		bcs.s	.set_water				; branch if screen is left of $1500
		move.w	#$108,d1
		bra.s	.set_water
; ===========================================================================

DynWater_LZ1_1:
		subq.b	#1,d2
		bne.s	DynWater_LZ1_2				; branch if water routine counter is 2

		cmpi.w	#$2E0,(v_ost_player+ost_y_pos).w
		bcc.s	.skip					; branch if Sonic is below $2E0

		move.w	#$3A8,d1
		cmpi.w	#$1300,d0
		bcs.s	.set_water				; branch if screen is left of $1300

		move.w	#$108,d1
		move.b	#2,(v_water_routine).w

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height

	.skip:
DynWater_LZ1_2:
		rts	
; ===========================================================================

DynWater_LZ2:
		move.w	(v_camera_x_pos).w,d0
		move.w	#$328,d1
		cmpi.w	#$500,d0
		bcs.s	.set_water				; branch if screen is left of $500

		move.w	#$3C8,d1
		cmpi.w	#$B00,d0
		bcs.s	.set_water				; branch if screen is left of $B00

		move.w	#$428,d1

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height
		rts	
; ===========================================================================

DynWater_LZ3:
		move.w	(v_camera_x_pos).w,d0
		move.b	(v_water_routine).w,d2
		bne.s	DynWater_LZ3_1				; branch if water routine counter is 1

		move.w	#$900,d1
		cmpi.w	#$600,d0
		bcs.s	.set_water				; branch if screen is left of $600

		cmpi.w	#$3C0,(v_ost_player+ost_y_pos).w
		bcs.s	.set_water				; branch if Sonic is above $3C0
		cmpi.w	#$600,(v_ost_player+ost_y_pos).w
		bcc.s	.set_water				; branch if Sonic is below $600

		move.w	#$4C8,d1
		move.b	#$4B,(v_level_layout+(sizeof_levelrow*2)+6).w ; modify level layout (row 2, column 6)
		move.b	#1,(v_water_routine).w			; goto DynWater_LZ3_1 next
		play.w	1, bsr.w, sfx_Rumbling			; play the rumbling sound

	.set_water:
		move.w	d1,(v_water_height_next).w
		move.w	d1,(v_water_height_normal).w		; change water height instantly
		rts	
; ===========================================================================

DynWater_LZ3_1:
		subq.b	#1,d2
		bne.s	DynWater_LZ3_2				; branch if water routine counter is 2

		move.w	#$4C8,d1
		cmpi.w	#$770,d0
		bcs.s	.set_water				; branch if screen is left of $770

		move.w	#$308,d1
		cmpi.w	#$1400,d0
		bcs.s	.set_water				; branch if screen is left of $1400

		cmpi.w	#$508,(v_water_height_next).w
		beq.s	.skip_sonic_chk				; branch if water is already set to $508 next
		cmpi.w	#$600,(v_ost_player+ost_y_pos).w
		bcc.s	.skip_sonic_chk				; branch if Sonic is below $600
		cmpi.w	#$280,(v_ost_player+ost_y_pos).w
		bcc.s	.set_water				; branch if Sonic is below $280

	.skip_sonic_chk:
		move.w	#$508,d1
		move.w	d1,(v_water_height_normal).w		; change water height instantly
		cmpi.w	#$1770,d0
		bcs.s	.set_water				; branch if screen is left of $1770
		move.b	#2,(v_water_routine).w			; goto DynWater_LZ3_2 next

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height
		rts	
; ===========================================================================

DynWater_LZ3_2:
		subq.b	#1,d2
		bne.s	DynWater_LZ3_3				; branch if water routine counter is 3

		move.w	#$508,d1
		cmpi.w	#$1860,d0
		bcs.s	.set_water				; branch if screen is left of $1860

		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcc.s	.next					; branch if screen is right of $1AF0

		cmp.w	(v_water_height_normal).w,d1
		bne.s	.set_water				; branch if water hasn't reached target

	.next:
		move.b	#3,(v_water_routine).w			; goto DynWater_LZ3_3 next

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height
		rts	
; ===========================================================================

DynWater_LZ3_3:
		subq.b	#1,d2
		bne.s	DynWater_LZ3_4				; branch if water routine counter is 4

		move.w	#$188,d1
		cmpi.w	#$1AF0,d0
		bcs.s	.set_water				; branch if screen is left of $1AF0

		move.w	#$900,d1
		cmpi.w	#$1BC0,d0
		bcs.s	.set_water				; branch if screen is left of $1BC0

		move.b	#4,(v_water_routine).w			; goto DynWater_LZ3_4 next
		move.w	#$608,(v_water_height_next).w
		move.w	#$7C0,(v_water_height_normal).w
		move.b	#1,(v_button_state+8).w			; set flag for button 8 pressed
		rts	
; ===========================================================================

.set_water:
		move.w	d1,(v_water_height_next).w
		move.w	d1,(v_water_height_normal).w		; instantly change water height
		rts	
; ===========================================================================

DynWater_LZ3_4:
		cmpi.w	#$1E00,d0
		bcs.s	.dontset				; branch if screen is left of $1E00

		move.w	#$128,(v_water_height_next).w		; set next target water height

	.dontset:
		rts	
; ===========================================================================

DynWater_SBZ3:
		move.w	#$228,d1
		cmpi.w	#$F00,(v_camera_x_pos).w
		bcs.s	.set_water				; branch if screen is left of $F00

		move.w	#$4C8,d1

	.set_water:
		move.w	d1,(v_water_height_next).w		; set next target water height
		rts

; ---------------------------------------------------------------------------
; Labyrinth Zone "wind tunnels"	subroutine

;	uses d0.l, d1.l, d2.w, a1, a2
; ---------------------------------------------------------------------------

LZWindTunnels:
		tst.w	(v_debug_active).w
		bne.w	.exit					; branch if debug mode is currently in use
		lea	(LZWind_Data+8).l,a2			; address of list of tunnel area boundaries
		moveq	#0,d0
		move.b	(v_act).w,d0				; get act number
		lsl.w	#3,d0					; multiply by 8
		adda.w	d0,a2					; jump to boundary list for specified act
		moveq	#0,d1					; 1 tunnel for acts 2/3/4
		tst.b	(v_act).w				; is act number 1?
		bne.s	.notact1				; if not, branch

		moveq	#1,d1					; 2 tunnels for act 1
		subq.w	#8,a2					; use different data for act 1

	.notact1:
		lea	(v_ost_player).w,a1

.tunnel_loop:
		move.w	ost_x_pos(a1),d0
		cmp.w	(a2),d0
		bcs.w	.chknext				; branch if Sonic is left of tunnel
		cmp.w	4(a2),d0
		bcc.w	.chknext				; branch if Sonic is right of tunnel
		move.w	ost_y_pos(a1),d2
		cmp.w	2(a2),d2
		bcs.s	.chknext				; branch if Sonic is above tunnel
		cmp.w	6(a2),d2
		bcc.s	.chknext				; branch if Sonic is below tunnel

		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		andi.b	#$3F,d0					; read only bits 0-5
		bne.s	.skipsound				; branch if any are set
		play.w	1, jsr, sfx_Waterfall			; play rushing water sound every 64th frame

	.skipsound:
		tst.b	(f_water_tunnel_disable).w
		bne.w	.exit					; branch if tunnels are disabled
		cmpi.b	#id_Sonic_Hurt,ost_routine(a1)
		bcc.s	.end_tunnel				; branch if is Sonic is hurt or dead
		move.b	#1,(f_water_tunnel_now).w		; set flag that Sonic is in a tunnel
		subi.w	#$80,d0
		cmp.w	(a2),d0
		bcc.s	.movesonic
		moveq	#2,d0
		cmpi.b	#1,(v_act).w				; is act number 2?
		bne.s	.notact2				; if not, branch
		neg.w	d0					; act 2 tunnel is entered from below

	.notact2:
		add.w	d0,ost_y_pos(a1)			; move Sonic down/up 2px to align with tunnel entrance

.movesonic:
		addq.w	#4,ost_x_pos(a1)
		move.w	#$400,ost_x_vel(a1)			; move Sonic horizontally
		move.w	#0,ost_y_vel(a1)
		move.b	#id_Float2,ost_anim(a1)			; use floating animation
		bset	#status_air_bit,ost_status(a1)
		btst	#bitUp,(v_joypad_hold).w		; is up pressed?
		beq.s	.down					; if not, branch
		subq.w	#1,ost_y_pos(a1)			; move Sonic up on pole

	.down:
		btst	#bitDn,(v_joypad_hold).w		; is down being pressed?
		beq.s	.end					; if not, branch
		addq.w	#1,ost_y_pos(a1)			; move Sonic down on pole

	.end:
		rts	
; ===========================================================================

.chknext:
		addq.w	#8,a2					; use second set of values (act 1 only)
		dbf	d1,.tunnel_loop				; on act 1, repeat for a second tunnel

		tst.b	(f_water_tunnel_now).w
		beq.s	.exit					; branch if Sonic is still in tunnel
		move.b	#id_Walk,ost_anim(a1)			; use walking animation

.end_tunnel:
		clr.b	(f_water_tunnel_now).w			; finish tunnel

.exit:
		rts

; ===========================================================================

		;    left, top,  right, bottom boundaries
LZWind_Data:	dc.w $A80, $300, $C10,  $380			; act 1 values (set 1)
		dc.w $F80, $100, $1410,	$180			; act 1 values (set 2)
		dc.w $460, $400, $710,  $480			; act 2 values
		dc.w $A20, $600, $1610, $6E0			; act 3 values
		dc.w $C80, $600, $13D0, $680			; SBZ act 3 values
		even

; ---------------------------------------------------------------------------
; Labyrinth Zone water slide subroutine

;	uses d0.w, d1.l, a1, a2
; ---------------------------------------------------------------------------

LZWaterSlides:
		lea	(v_ost_player).w,a1
		btst	#status_air_bit,ost_status(a1)		; is Sonic in air?
		bne.s	.sonic_in_air				; branch if Sonic is in air

		move.w	ost_y_pos(a1),d0
		lsr.w	#1,d0					; divide y pos by 2 (because layout alternates between level and bg lines)
		andi.w	#$380,d0				; read only high byte of y pos (because each level tile is 256px tall)
		move.b	ost_x_pos(a1),d1
		andi.w	#$7F,d1					; read only high byte of x pos
		add.w	d1,d0					; combine for position within layout
		lea	(v_level_layout).w,a2
		move.b	(a2,d0.w),d0				; get 256x256 tile number
		lea	Slide_Chunks_End(pc),a2			; get list of 256x256 tiles that contain slides
		moveq	#Slide_Chunks_End-Slide_Chunks-1,d1	; number of slide tiles

	.loop:
		cmp.b	-(a2),d0				; compare current 256x256 tile with those in list
		dbeq	d1,.loop				; check every tile in list
		beq.s	LZSlide_Move				; branch when match found

	.sonic_in_air:
		tst.b	(f_jump_only).w
		beq.s	.not_locked				; branch if controls aren't locked
		move.w	#sonic_lock_time_slide,ost_sonic_lock_time(a1) ; lock controls for 5 more frames
		clr.b	(f_jump_only).w				; unlock controls

	.not_locked:
		rts	
; ===========================================================================

LZSlide_Move:
		cmpi.w	#3,d1
		bcc.s	.steep_slope				; branch if 256x256 tile id is 4/8/$4B/$4C (steep slopes)
		nop	

	.steep_slope:
		bclr	#status_xflip_bit,ost_status(a1)	; face Sonic right
		move.b	Slide_Speeds(pc,d1.w),d0		; get inertia from list
		move.b	d0,ost_inertia(a1)			; set inertia
		bpl.s	.face_right
		bset	#status_xflip_bit,ost_status(a1)	; face Sonic left

	.face_right:
		clr.b	ost_inertia+1(a1)			; round inertia down to nearest $100
		move.b	#id_WaterSlide,ost_anim(a1)		; use Sonic's "sliding" animation
		move.b	#1,(f_jump_only).w			; lock controls (except jumping)
		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		andi.b	#$1F,d0					; read only bits 0-4
		bne.s	.skip_sound				; branch if any are set
		play.w	1, jsr, sfx_Waterfall			; play water sound every 32nd frame

	.skip_sound:
		rts

; ===========================================================================

Slide_Speeds:
		dc.b $A, -$B, $A, -$A, -$B, -$C, $B
		even

Slide_Chunks:
		dc.b 2, 7, 3, $4C, $4B, 8, 4
	Slide_Chunks_End:
		even
