; ---------------------------------------------------------------------------
; Object 0D - signpost at the end of a level

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_MZ1, ObjPos_MZ2
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_LZ1, ObjPos_LZ2
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SBZ1, ObjPos_SBZ2
; ---------------------------------------------------------------------------

Signpost:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Sign_Index(pc,d0.w),d1
		jsr	Sign_Index(pc,d1.w)
		lea	(Ani_Sign).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
; ===========================================================================
Sign_Index:	index *,,2
		ptr Sign_Main
		ptr Sign_Touch
		ptr Sign_Spin
		ptr Sign_SonicRun
		ptr Sign_Exit

ost_sign_spin_time:	equ $30					; time for signpost to spin (2 bytes)
ost_sign_sparkle_time:	equ $32					; time between sparkles (2 bytes)
ost_sign_sparkle_id:	equ $34					; counter to keep track of sparkles
; ===========================================================================

Sign_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Sign_Touch next
		move.l	#Map_Sign,ost_mappings(a0)
		move.w	#tile_Nem_SignPost,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$18,ost_displaywidth(a0)
		move.b	#4,ost_priority(a0)

Sign_Touch:	; Routine 2
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	@exit					; branch if Sonic is left of the signpost
		cmpi.w	#$20,d0					; is Sonic within 32px of right?
		bcc.s	@exit					; if not, branch

		play.w	0, jsr, sfx_Signpost			; play signpost sound
		clr.b	(f_hud_time_update).w			; stop time counter
		move.w	(v_boundary_right).w,(v_boundary_left).w ; lock screen position
		addq.b	#2,ost_routine(a0)			; goto Sign_Spin next

	@exit:
		rts	
; ===========================================================================

Sign_Spin:	; Routine 4
		subq.w	#1,ost_sign_spin_time(a0)		; decrement spin timer
		bpl.s	@chksparkle				; if time remains, branch
		move.w	#60,ost_sign_spin_time(a0)		; set spin cycle time to 1 second
		addq.b	#1,ost_anim(a0)				; next spin cycle
		cmpi.b	#id_ani_sign_sonic,ost_anim(a0)		; have 3 spin cycles completed?
		bne.s	@chksparkle				; if not, branch
		addq.b	#2,ost_routine(a0)			; goto Sign_SonicRun next

	@chksparkle:
		subq.w	#1,ost_sign_sparkle_time(a0)		; decrement sparkle timer
		bpl.s	@fail					; if time remains, branch
		move.w	#$B,ost_sign_sparkle_time(a0)		; set time between sparkles to 12 frames
		moveq	#0,d0
		move.b	ost_sign_sparkle_id(a0),d0		; get sparkle id
		addq.b	#2,ost_sign_sparkle_id(a0)		; increment sparkle counter
		andi.b	#$E,ost_sign_sparkle_id(a0)
		lea	Sign_SparkPos(pc,d0.w),a2		; load sparkle position data
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_Rings,ost_id(a1)			; load rings object
		move.b	#id_Ring_Sparkle,ost_routine(a1)	; jump to ring sparkle subroutine
		move.b	(a2)+,d0				; get relative x position
		ext.w	d0
		add.w	ost_x_pos(a0),d0			; add to signpost x position
		move.w	d0,ost_x_pos(a1)			; update sparkle position
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_y_pos(a0),d0
		move.w	d0,ost_y_pos(a1)
		move.l	#Map_Ring,ost_mappings(a1)
		move.w	#tile_Nem_Ring+tile_pal2,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#2,ost_priority(a1)
		move.b	#8,ost_displaywidth(a1)

	@fail:
		rts	
; ===========================================================================
Sign_SparkPos:	; x pos, y pos
		dc.b -$18,-$10
		dc.b	8,   8
		dc.b -$10,   0
		dc.b  $18,  -8
		dc.b	0,  -8
		dc.b  $10,   0
		dc.b -$18,   8
		dc.b  $18, $10
; ===========================================================================

Sign_SonicRun:	; Routine 6
		tst.w	(v_debug_active).w			; is debug mode	on?
		bne.w	Sign_SonicRun_Exit			; if yes, branch
		btst	#status_air_bit,(v_ost_player+ost_status).w ; is Sonic in the air?
		bne.s	@wait_to_land				; if yes, branch
		move.b	#1,(f_lock_controls).w			; lock controls
		move.w	#btnR<<8,(v_joypad_hold).w		; make Sonic run to the right

	@wait_to_land:
		tst.b	(v_ost_player).w			; is Sonic object still loaded?
		beq.s	@skip_boundary_chk			; if not, branch
		move.w	(v_ost_player+ost_x_pos).w,d0
		move.w	(v_boundary_right).w,d1
		addi.w	#$128,d1
		cmp.w	d1,d0					; has Sonic passed 296px outside right level boundary?
		bcs.s	Sign_SonicRun_Exit			; if not, branch

	@skip_boundary_chk:
		addq.b	#2,ost_routine(a0)			; goto Sign_Exit next

; ---------------------------------------------------------------------------
; Subroutine to	set up bonuses at the end of an	act
; ---------------------------------------------------------------------------

HasPassedAct:
		tst.b	(v_ost_haspassed1).w			; has "Sonic Has Passed" title card loaded?
		bne.s	Sign_SonicRun_Exit			; if yes, branch

		move.w	(v_boundary_right).w,(v_boundary_left).w
		clr.b	(v_invincibility).w			; disable invincibility
		clr.b	(f_hud_time_update).w			; stop time counter
		move.b	#id_HasPassedCard,(v_ost_haspassed1).w	; load "Sonic Has Passed" title card
		moveq	#id_PLC_TitleCard,d0
		jsr	(NewPLC).l				; load title card patterns
		move.b	#1,(f_pass_bonus_update).w
		moveq	#0,d0
		move.b	(v_time_min).w,d0
		mulu.w	#60,d0					; convert minutes to seconds
		moveq	#0,d1
		move.b	(v_time_sec).w,d1
		add.w	d1,d0					; d0 = total seconds
		divu.w	#15,d0					; divide by 15
		moveq	#(WorstTime-TimeBonuses)/2,d1
		cmp.w	d1,d0					; is time 5 minutes or higher?
		bcs.s	@hastimebonus				; if not, branch
		move.w	d1,d0					; use minimum time bonus (0)

	@hastimebonus:
		add.w	d0,d0
		move.w	TimeBonuses(pc,d0.w),(v_time_bonus).w	; set time bonus
		move.w	(v_rings).w,d0				; load number of rings
		mulu.w	#10,d0					; multiply by 10
		move.w	d0,(v_ring_bonus).w			; set ring bonus
		play.w	1, jsr, mus_HasPassed			; play "Sonic Has Passed" music

Sign_SonicRun_Exit:
		rts	
; End of function HasPassedAct

; ===========================================================================
TimeBonuses:	dc.w   5000
		dc.w   5000					; < 0:30 = 50000
		dc.w   1000					; < 0:45 = 10000
		dc.w    500					; < 1:00 = 5000
		dc.w    400
		dc.w    400					; < 1:30 = 4000
		dc.w    300
		dc.w    300					; < 2:00 = 3000
		dc.w    200
		dc.w    200
		dc.w    200
		dc.w    200					; < 3:00 = 2000
		dc.w    100
		dc.w    100
		dc.w    100
		dc.w    100					; < 4:00 = 1000
		dc.w     50
		dc.w     50
		dc.w     50
		dc.w     50					; < 5:00 = 500
WorstTime:	dc.w      0					; 5:00+ = 0
; ===========================================================================

Sign_Exit:	; Routine 8
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Sign:	index *
		ptr ani_sign_eggman
		ptr ani_sign_spin1
		ptr ani_sign_spin2
		ptr ani_sign_sonic
		
ani_sign_eggman:
		dc.b $F
		dc.b id_frame_sign_eggman
		dc.b afEnd
		even

ani_sign_spin1:
		dc.b 1
		dc.b id_frame_sign_eggman
		dc.b id_frame_sign_spin1
		dc.b id_frame_sign_spin2
		dc.b id_frame_sign_spin3
		dc.b afEnd

ani_sign_spin2:
		dc.b 1
		dc.b id_frame_sign_sonic
		dc.b id_frame_sign_spin1
		dc.b id_frame_sign_spin2
		dc.b id_frame_sign_spin3
		dc.b afEnd

ani_sign_sonic:
		dc.b $F
		dc.b id_frame_sign_sonic
		dc.b afEnd
		even
