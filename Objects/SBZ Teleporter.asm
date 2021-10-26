; ---------------------------------------------------------------------------
; Object 72 - teleporter (SBZ)
; ---------------------------------------------------------------------------

Teleport:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Tele_Index(pc,d0.w),d1
		jsr	Tele_Index(pc,d1.w)
		out_of_range.s	@delete
		rts	

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================
Tele_Index:	index *,,2
		ptr Tele_Main
		ptr Tele_Action
		ptr Tele_Bump
		ptr Tele_Bend

ost_tele_camera:	equ $2E	; something to do with the camera following the pipe (2 bytes)
ost_tele_bump:		equ $32	; counter for initial "bump" when Sonic enters teleport, 0-$80
ost_tele_x_target:	equ $36	; next x position to teleport to (2 bytes)
ost_tele_y_target:	equ $38	; next y position to teleport to (2 bytes)
ost_tele_bends:		equ $3A	; number of bends Sonic has passed in pipe, increments by 4
ost_tele_data_size:	equ $3B	; size of coordinate data in bytes
ost_tele_data_ptr:	equ $3C	; address of coordinate data (4 bytes)
; ===========================================================================

Tele_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	Tele_Data(pc),a2
		adda.w	(a2,d0.w),a2	; address of coordinate data
		move.w	(a2)+,ost_tele_data_size-1(a0) ; get size of data
		move.l	a2,ost_tele_data_ptr(a0)
		move.w	(a2)+,ost_tele_x_target(a0) ; get 1st target
		move.w	(a2)+,ost_tele_y_target(a0)

Tele_Action:	; Routine 2
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		addi.w	#$F,d0

	@noflip:
		cmpi.w	#$10,d0		; is Sonic within $10 pixels on x-axis?
		bcc.s	@do_nothing	; if not, branch
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		addi.w	#$20,d1
		cmpi.w	#$40,d1		; is Sonic within $20 pixels on y-axis?
		bcc.s	@do_nothing	; if not, branch
		tst.b	(v_lock_multi).w
		bne.s	@do_nothing
		cmpi.b	#7,ost_subtype(a0) ; is this teleport #7?
		bne.s	@not7		; if not, branch
		cmpi.w	#50,(v_rings).w	; teleport #7 requires 50 rings to work
		bcs.s	@do_nothing	; does nothing without 50 rings

	@not7:
		addq.b	#2,ost_routine(a0)
		move.b	#$81,(v_lock_multi).w ; lock controls
		move.b	#id_Roll,ost_anim(a1) ; use Sonic's rolling animation
		move.w	#$800,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)
		move.w	#0,ost_y_vel(a1)
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a1)
		bset	#status_air_bit,ost_status(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		clr.b	ost_tele_bump(a0)
		play.w	1, jsr, sfx_Roll		; play Sonic rolling sound

@do_nothing:
		rts	
; ===========================================================================

Tele_Bump:	; Routine 4
		lea	(v_ost_player).w,a1
		move.b	ost_tele_bump(a0),d0
		addq.b	#2,ost_tele_bump(a0)
		jsr	(CalcSine).l
		asr.w	#5,d0
		move.w	ost_y_pos(a0),d2
		sub.w	d0,d2
		move.w	d2,ost_y_pos(a1) ; make Sonic "bump" vertically
		cmpi.b	#$80,ost_tele_bump(a0) ; has bump completed?
		bne.s	locret_16796	; if not, branch
		bsr.w	Tele_Move
		addq.b	#2,ost_routine(a0)
		play.w	1, jsr, sfx_Dash		; play Sonic dashing sound

locret_16796:
		rts	
; ===========================================================================

Tele_Bend:	; Routine 6
		addq.l	#4,sp
		lea	(v_ost_player).w,a1
		subq.b	#1,ost_tele_camera(a0)
		bpl.s	loc_167DA
		move.w	ost_tele_x_target(a0),ost_x_pos(a1)
		move.w	ost_tele_y_target(a0),ost_y_pos(a1)
		moveq	#0,d1
		move.b	ost_tele_bends(a0),d1
		addq.b	#4,d1
		cmp.b	ost_tele_data_size(a0),d1
		bcs.s	loc_167C2
		moveq	#0,d1
		bra.s	loc_16800
; ===========================================================================

loc_167C2:
		move.b	d1,ost_tele_bends(a0)
		movea.l	ost_tele_data_ptr(a0),a2
		move.w	(a2,d1.w),ost_tele_x_target(a0)
		move.w	2(a2,d1.w),ost_tele_y_target(a0)
		bra.w	Tele_Move
; ===========================================================================

loc_167DA:
		move.l	ost_x_pos(a1),d2
		move.l	ost_y_pos(a1),d3
		move.w	ost_x_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	ost_y_vel(a1),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,ost_x_pos(a1)
		move.l	d3,ost_y_pos(a1)
		rts	
; ===========================================================================

loc_16800:
		andi.w	#$7FF,ost_y_pos(a1)
		clr.b	ost_routine(a0)
		clr.b	(v_lock_multi).w
		move.w	#0,ost_x_vel(a1)
		move.w	#$200,ost_y_vel(a1)
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Tele_Move:
		moveq	#0,d0
		move.w	#$1000,d2
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0
		bge.s	loc_16830
		neg.w	d0
		neg.w	d2

loc_16830:
		moveq	#0,d1
		move.w	#$1000,d3
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1
		bge.s	loc_16844
		neg.w	d1
		neg.w	d3

loc_16844:
		cmp.w	d0,d1
		bcs.s	loc_1687A
		moveq	#0,d1
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1
		swap	d1
		divs.w	d3,d1
		moveq	#0,d0
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0
		beq.s	loc_16866
		swap	d0
		divs.w	d1,d0

loc_16866:
		move.w	d0,ost_x_vel(a1)
		move.w	d3,ost_y_vel(a1)
		tst.w	d1
		bpl.s	loc_16874
		neg.w	d1

loc_16874:
		move.w	d1,ost_tele_camera(a0)
		rts	
; ===========================================================================

loc_1687A:
		moveq	#0,d0
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0
		swap	d0
		divs.w	d2,d0
		moveq	#0,d1
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1
		beq.s	loc_16898
		swap	d1
		divs.w	d0,d1

loc_16898:
		move.w	d1,ost_y_vel(a1)
		move.w	d2,ost_x_vel(a1)
		tst.w	d0
		bpl.s	loc_168A6
		neg.w	d0

loc_168A6:
		move.w	d0,ost_tele_camera(a0)
		rts	
; End of function Tele_Move

; ===========================================================================
Tele_Data:	index *
		ptr Tele_Type00
		ptr Tele_Type01
		ptr Tele_Type02
		ptr Tele_Type03
		ptr Tele_Type04
		ptr Tele_Type05
		ptr Tele_Type06
		ptr Tele_Type07
Tele_Type00:	dc.w @end-*-2
		dc.w $794, $98C
	@end:
Tele_Type01:	dc.w @end-*-2
		dc.w $94, $38C
	@end:
Tele_Type02:	dc.w @end-*-2
		dc.w $794, $2E8
		dc.w $7A4, $2C0
		dc.w $7D0, $2AC
		dc.w $858, $2AC
		dc.w $884, $298
		dc.w $894, $270
		dc.w $894, $190
	@end:
Tele_Type03:	dc.w @end-*-2
		dc.w $894, $690
	@end:
Tele_Type04:	dc.w @end-*-2
		dc.w $1194, $470
		dc.w $1184, $498
		dc.w $1158, $4AC
		dc.w $FD0, $4AC
		dc.w $FA4, $4C0
		dc.w $F94, $4E8
		dc.w $F94, $590
	@end:
Tele_Type05:	dc.w @end-*-2
		dc.w $1294, $490
	@end:
Tele_Type06:	dc.w @end-*-2
		dc.w $1594, $FFE8
		dc.w $1584, $FFC0
		dc.w $1560, $FFAC
		dc.w $14D0, $FFAC
		dc.w $14A4, $FF98
		dc.w $1494, $FF70
		dc.w $1494, $FD90
	@end:
Tele_Type07:	dc.w @end-*-2
		dc.w $894, $90
	@end:
