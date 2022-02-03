; ---------------------------------------------------------------------------
; Object 72 - teleporter (SBZ)

; spawned by:
;	ObjPos_SBZ2 - subtypes 0-7
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

ost_tele_time:		equ $2E					; travel time between each bend (2 bytes; only high byte is read)
ost_tele_bump:		equ $32					; counter for initial "bump" when Sonic enters teleport, 0-$80
ost_tele_x_target:	equ $36					; next x position to teleport to (2 bytes)
ost_tele_y_target:	equ $38					; next y position to teleport to (2 bytes)
ost_tele_bends:		equ $3A					; number of bends Sonic has passed in pipe, increments by 4
ost_tele_data_size:	equ $3B					; size of coordinate data in bytes
ost_tele_data_ptr:	equ $3C					; address of coordinate data (4 bytes)
; ===========================================================================

Tele_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Tele_Action next
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0					; read only low nybble
		lea	Tele_Data(pc),a2
		adda.w	(a2,d0.w),a2				; address of coordinate data
		move.w	(a2)+,ost_tele_data_size-1(a0)		; get size of data
		move.l	a2,ost_tele_data_ptr(a0)
		move.w	(a2)+,ost_tele_x_target(a0)		; get 1st target
		move.w	(a2)+,ost_tele_y_target(a0)

Tele_Action:	; Routine 2
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		addi.w	#$F,d0

	@noflip:
		cmpi.w	#$10,d0					; is Sonic within $10 pixels on x-axis?
		bcc.s	@do_nothing				; if not, branch
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		addi.w	#$20,d1
		cmpi.w	#$40,d1					; is Sonic within $20 pixels on y-axis?
		bcc.s	@do_nothing				; if not, branch
		tst.b	(v_lock_multi).w			; are controls locked?
		bne.s	@do_nothing				; if yes, branch
		cmpi.b	#7,ost_subtype(a0)			; is this teleport #7?
		bne.s	@not7					; if not, branch
		cmpi.w	#50,(v_rings).w				; teleport #7 requires 50 rings to work
		bcs.s	@do_nothing				; does nothing without 50 rings

	@not7:
		addq.b	#2,ost_routine(a0)			; goto Tele_Bump next
		move.b	#$81,(v_lock_multi).w			; lock controls and disable object collision
		move.b	#id_Roll,ost_anim(a1)			; use Sonic's rolling animation
		move.w	#$800,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)
		move.w	#0,ost_y_vel(a1)
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a1)
		bset	#status_air_bit,ost_status(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		clr.b	ost_tele_bump(a0)
		play.w	1, jsr, sfx_Roll			; play Sonic rolling sound

	@do_nothing:
		rts	
; ===========================================================================

Tele_Bump:	; Routine 4
		lea	(v_ost_player).w,a1
		move.b	ost_tele_bump(a0),d0			; get bump value
		addq.b	#2,ost_tele_bump(a0)			; increment bump value
		jsr	(CalcSine).l				; convert to sine
		asr.w	#5,d0
		move.w	ost_y_pos(a0),d2
		sub.w	d0,d2
		move.w	d2,ost_y_pos(a1)			; make Sonic "bump" vertically
		cmpi.b	#$80,ost_tele_bump(a0)			; has bump completed?
		bne.s	@wait					; if not, branch

		bsr.w	Tele_Move				; set speed/direction
		addq.b	#2,ost_routine(a0)			; goto Tele_Bend next
		play.w	1, jsr, sfx_Dash			; play Sonic dashing sound

	@wait:
		rts	
; ===========================================================================

Tele_Bend:	; Routine 6
		addq.l	#4,sp
		lea	(v_ost_player).w,a1
		subq.b	#1,ost_tele_time(a0)			; decrement timer
		bpl.s	@update_pos				; branch if time remains

		move.w	ost_tele_x_target(a0),ost_x_pos(a1)	; move Sonic to target position
		move.w	ost_tele_y_target(a0),ost_y_pos(a1)
		moveq	#0,d1
		move.b	ost_tele_bends(a0),d1			; get current bend count
		addq.b	#4,d1
		cmp.b	ost_tele_data_size(a0),d1		; is next bend valid?
		bcs.s	@next_bend				; if yes, branch
		moveq	#0,d1
		bra.s	@destination				; arrive at destination
; ===========================================================================

@next_bend:
		move.b	d1,ost_tele_bends(a0)			; set bend counter +4
		movea.l	ost_tele_data_ptr(a0),a2
		move.w	(a2,d1.w),ost_tele_x_target(a0)		; set next bend coordinates
		move.w	2(a2,d1.w),ost_tele_y_target(a0)
		bra.w	Tele_Move				; set speed/direction
; ===========================================================================

@update_pos:
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
		move.l	d2,ost_x_pos(a1)			; update Sonic's position
		move.l	d3,ost_y_pos(a1)
		rts	
; ===========================================================================

@destination:
		andi.w	#$7FF,ost_y_pos(a1)			; wrap y position
		clr.b	ost_routine(a0)				; goto Tele_Main next
		clr.b	(v_lock_multi).w			; unlock controls & enable object collision
		move.w	#0,ost_x_vel(a1)
		move.w	#$200,ost_y_vel(a1)
		rts	

; ---------------------------------------------------------------------------
; Subroutine to set Sonic's speed & direction in a teleport pipe
; ---------------------------------------------------------------------------

Tele_Move:
		moveq	#0,d0
		move.w	#$1000,d2
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0			; d0 = x distance between Sonic and next target (-ve if Sonic is to the right)
		bge.s	@sonic_is_left				; branch if +ve
		neg.w	d0
		neg.w	d2

	@sonic_is_left:
		moveq	#0,d1
		move.w	#$1000,d3
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1			; d1 = y distance between Sonic and next target (-ve if Sonic is below)
		bge.s	@sonic_is_above				; branch if +ve
		neg.w	d1
		neg.w	d3

	@sonic_is_above:
		cmp.w	d0,d1					; is x distance > y distance?
		bcs.s	Tele_Move_X				; if yes, branch

		moveq	#0,d1
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1			; d1 = y distance between Sonic and next target (-ve if Sonic is below)
		swap	d1					; move into high word
		divs.w	d3,d1					; divide by $1000 or -$1000
		moveq	#0,d0
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0			; d0 = x distance between Sonic and next target (-ve if Sonic is to the right)
		beq.s	@x_match				; branch if 0
		swap	d0					; move into high word
		divs.w	d1,d0					; divide by d1

	@x_match:
		move.w	d0,ost_x_vel(a1)
		move.w	d3,ost_y_vel(a1)
		tst.w	d1
		bpl.s	@abs_time
		neg.w	d1

	@abs_time:
		move.w	d1,ost_tele_time(a0)			; set travel time for current direction
		rts	
; ===========================================================================

Tele_Move_X:
		moveq	#0,d0
		move.w	ost_tele_x_target(a0),d0
		sub.w	ost_x_pos(a1),d0			; d0 = x distance between Sonic and next target (-ve if Sonic is to the right)
		swap	d0
		divs.w	d2,d0
		moveq	#0,d1
		move.w	ost_tele_y_target(a0),d1
		sub.w	ost_y_pos(a1),d1			; d1 = y distance between Sonic and next target (-ve if Sonic is below)
		beq.s	@y_match				; branch if 0
		swap	d1
		divs.w	d0,d1

	@y_match:
		move.w	d1,ost_y_vel(a1)
		move.w	d2,ost_x_vel(a1)
		tst.w	d0
		bpl.s	@abs_time
		neg.w	d0

	@abs_time:
		move.w	d0,ost_tele_time(a0)			; set travel time for current direction
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
