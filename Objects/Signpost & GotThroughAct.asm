; ---------------------------------------------------------------------------
; Object 0D - signpost at the end of a level
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

ost_sign_spin_time:	equ $30	; time for signpost to spin (2 bytes)
ost_sign_sparkle_time:	equ $32	; time between sparkles (2 bytes)
ost_sign_sparkle_id:	equ $34	; counter to keep track of sparkles
; ===========================================================================

Sign_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Sign,ost_mappings(a0)
		move.w	#tile_Nem_SignPost,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$18,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)

Sign_Touch:	; Routine 2
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	@notouch
		cmpi.w	#$20,d0		; is Sonic within $20 pixels of	the signpost?
		bcc.s	@notouch	; if not, branch
		play.w	0, jsr, sfx_Signpost		; play signpost sound
		clr.b	(f_hud_time_update).w	; stop time counter
		move.w	(v_boundary_right).w,(v_boundary_left).w ; lock screen position
		addq.b	#2,ost_routine(a0)

	@notouch:
		rts	
; ===========================================================================

Sign_Spin:	; Routine 4
		subq.w	#1,ost_sign_spin_time(a0) ; subtract 1 from spin time
		bpl.s	@chksparkle	; if time remains, branch
		move.w	#60,ost_sign_spin_time(a0) ; set spin cycle time to 1 second
		addq.b	#1,ost_anim(a0)	; next spin cycle
		cmpi.b	#id_ani_sign_sonic,ost_anim(a0) ; have 3 spin cycles completed?
		bne.s	@chksparkle	; if not, branch
		addq.b	#2,ost_routine(a0)

	@chksparkle:
		subq.w	#1,ost_sign_sparkle_time(a0) ; subtract 1 from time delay
		bpl.s	@fail		; if time remains, branch
		move.w	#$B,ost_sign_sparkle_time(a0) ; set time between sparkles to $B frames
		moveq	#0,d0
		move.b	ost_sign_sparkle_id(a0),d0 ; get sparkle id
		addq.b	#2,ost_sign_sparkle_id(a0) ; increment sparkle counter
		andi.b	#$E,ost_sign_sparkle_id(a0)
		lea	Sign_SparkPos(pc,d0.w),a2 ; load sparkle position data
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Rings,0(a1)	; load rings object
		move.b	#id_Ring_Sparkle,ost_routine(a1) ; jump to ring sparkle subroutine
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_x_pos(a0),d0
		move.w	d0,ost_x_pos(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_y_pos(a0),d0
		move.w	d0,ost_y_pos(a1)
		move.l	#Map_Ring,ost_mappings(a1)
		move.w	#tile_Nem_Ring+tile_pal2,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#2,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)

	@fail:
		rts	
; ===========================================================================
Sign_SparkPos:	dc.b -$18,-$10		; x-position, y-position
		dc.b	8,   8
		dc.b -$10,   0
		dc.b  $18,  -8
		dc.b	0,  -8
		dc.b  $10,   0
		dc.b -$18,   8
		dc.b  $18, $10
; ===========================================================================

Sign_SonicRun:	; Routine 6
		tst.w	(v_debug_active).w	; is debug mode	on?
		bne.w	locret_ECEE	; if yes, branch
		btst	#status_air_bit,(v_ost_player+ost_status).w
		bne.s	loc_EC70
		move.b	#1,(f_lock_controls).w ; lock controls
		move.w	#btnR<<8,(v_joypad_hold).w ; make Sonic run to the right

	loc_EC70:
		tst.b	(v_ost_player).w
		beq.s	loc_EC86
		move.w	(v_ost_player+ost_x_pos).w,d0
		move.w	(v_boundary_right).w,d1
		addi.w	#$128,d1
		cmp.w	d1,d0
		bcs.s	locret_ECEE

	loc_EC86:
		addq.b	#2,ost_routine(a0)


; ---------------------------------------------------------------------------
; Subroutine to	set up bonuses at the end of an	act
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


GotThroughAct:
		tst.b	(v_ost_haspassed1).w
		bne.s	locret_ECEE
		move.w	(v_boundary_right).w,(v_boundary_left).w
		clr.b	(v_invincibility).w	; disable invincibility
		clr.b	(f_hud_time_update).w	; stop time counter
		move.b	#id_HasPassedCard,(v_ost_haspassed1).w
		moveq	#id_PLC_TitleCard,d0
		jsr	(NewPLC).l	; load title card patterns
		move.b	#1,(f_pass_bonus_update).w
		moveq	#0,d0
		move.b	(v_time_min).w,d0
		mulu.w	#60,d0		; convert minutes to seconds
		moveq	#0,d1
		move.b	(v_time_sec).w,d1
		add.w	d1,d0		; add up your time
		divu.w	#15,d0		; divide by 15
		moveq	#(WorstTime-TimeBonuses)/2,d1
		cmp.w	d1,d0		; is time 5 minutes or higher?
		bcs.s	@hastimebonus	; if not, branch
		move.w	d1,d0		; use minimum time bonus (0)

	@hastimebonus:
		add.w	d0,d0
		move.w	TimeBonuses(pc,d0.w),(v_time_bonus).w ; set time bonus
		move.w	(v_rings).w,d0	; load number of rings
		mulu.w	#10,d0		; multiply by 10
		move.w	d0,(v_ring_bonus).w ; set ring bonus
		play.w	1, jsr, mus_GotThrough		; play "Sonic has passed" music

locret_ECEE:
		rts	
; End of function GotThroughAct

; ===========================================================================
TimeBonuses:	dc.w   5000
		dc.w   5000		; < 0:30 = 50000
		dc.w   1000		; < 0:45 = 10000
		dc.w    500		; < 1:00 = 5000
		dc.w    400
		dc.w    400		; < 1:30 = 4000
		dc.w    300
		dc.w    300		; < 2:00 = 3000
		dc.w    200
		dc.w    200
		dc.w    200
		dc.w    200		; < 3:00 = 2000
		dc.w    100
		dc.w    100
		dc.w    100
		dc.w    100		; < 4:00 = 1000
		dc.w     50
		dc.w     50
		dc.w     50
		dc.w     50		; < 5:00 = 500
WorstTime:	dc.w      0		; 5:00+ = 0
; ===========================================================================

Sign_Exit:	; Routine 8
		rts	
