; ---------------------------------------------------------------------------
; Object 0B - pole that	breaks (LZ)

; spawned by:
;	ObjPos_LZ3 - subtype 4
; ---------------------------------------------------------------------------

Pole:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Pole_Index(pc,d0.w),d1
		jmp	Pole_Index(pc,d1.w)
; ===========================================================================
Pole_Index:	index *,,2
		ptr Pole_Main
		ptr Pole_Action
		ptr Pole_Display

ost_pole_time:		equ $30					; time between grabbing the pole & breaking (2 bytes)
ost_pole_grabbed:	equ $32					; flag set when Sonic grabs the pole
; ===========================================================================

Pole_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Pole_Action next
		move.l	#Map_Pole,ost_mappings(a0)
		move.w	#tile_Nem_LzPole+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#8,ost_displaywidth(a0)
		move.b	#4,ost_priority(a0)
		move.b	#id_col_4x32+id_col_custom,ost_col_type(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get object type
		mulu.w	#60,d0					; multiply by 60 (1 second)
		move.w	d0,ost_pole_time(a0)			; set breakage time

Pole_Action:	; Routine 2
		tst.b	ost_pole_grabbed(a0)			; has pole already been grabbed?
		beq.s	@grab					; if not, branch
		tst.w	ost_pole_time(a0)
		beq.s	@moveup
		subq.w	#1,ost_pole_time(a0)			; decrement time until break
		bne.s	@moveup
		move.b	#id_frame_pole_broken,ost_frame(a0)	; break the pole
		bra.s	@release
; ===========================================================================

@moveup:
		lea	(v_ost_player).w,a1
		move.w	ost_y_pos(a0),d0
		subi.w	#$18,d0					; d0 = y position for top of pole
		btst	#bitUp,(v_joypad_hold_actual).w		; is "up" pressed?
		beq.s	@movedown				; if not, branch
		subq.w	#1,ost_y_pos(a1)			; move Sonic up
		cmp.w	ost_y_pos(a1),d0
		bcs.s	@movedown
		move.w	d0,ost_y_pos(a1)			; keep Sonic from moving beyond top of pole

@movedown:
		addi.w	#$24,d0					; d0 = y position for bottom of pole
		btst	#bitDn,(v_joypad_hold_actual).w		; is "down" pressed?
		beq.s	@letgo					; if not, branch
		addq.w	#1,ost_y_pos(a1)			; move Sonic down
		cmp.w	ost_y_pos(a1),d0
		bcc.s	@letgo
		move.w	d0,ost_y_pos(a1)			; keep Sonic from moving beyond bottom of pole

@letgo:
		move.b	(v_joypad_press).w,d0
		andi.w	#btnABC,d0				; is A/B/C pressed?
		beq.s	Pole_Display				; if not, branch

@release:
		clr.b	ost_col_type(a0)
		addq.b	#2,ost_routine(a0)			; goto Pole_Display next
		clr.b	(v_lock_multi).w
		clr.b	(f_water_tunnel_disable).w
		clr.b	ost_pole_grabbed(a0)
		bra.s	Pole_Display
; ===========================================================================

@grab:
		tst.b	ost_col_property(a0)			; has Sonic touched the	pole?
		beq.s	Pole_Display				; if not, branch
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a0),d0
		addi.w	#$14,d0
		cmp.w	ost_x_pos(a1),d0			; is Sonic left of pole?
		bcc.s	Pole_Display				; if yes, branch

		clr.b	ost_col_property(a0)
		cmpi.b	#id_Sonic_Hurt,ost_routine(a1)		; is Sonic hurt or dead?
		bcc.s	Pole_Display				; if yes, branch
		clr.w	ost_x_vel(a1)				; stop Sonic moving
		clr.w	ost_y_vel(a1)				; stop Sonic moving
		move.w	ost_x_pos(a0),d0
		addi.w	#$14,d0
		move.w	d0,ost_x_pos(a1)			; align Sonic to pole
		bclr	#status_xflip_bit,ost_status(a1)
		move.b	#id_Hang,ost_anim(a1)			; set Sonic's animation to "hanging" ($11)
		move.b	#1,(v_lock_multi).w			; lock controls
		move.b	#1,(f_water_tunnel_disable).w		; disable wind tunnel
		move.b	#1,ost_pole_grabbed(a0)			; begin countdown to breakage

Pole_Display:	; Routine 4
		bra.w	DespawnObject
