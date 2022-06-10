; ---------------------------------------------------------------------------
; Object 36 - spikes

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtypes 0/$10/$20/$30/$40
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 1/$10/$12/$30/$52
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtypes 0/1/$10/$20/$30/$40
;	ObjPos_SBZ3 - subtypes 0/$30
; ---------------------------------------------------------------------------

Spikes:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Spike_Index(pc,d0.w),d1
		jmp	Spike_Index(pc,d1.w)
; ===========================================================================
Spike_Index:	index *,,2
		ptr Spike_Main
		ptr Spike_Solid

Spike_Var:	; frame	number,	object width
Spike_Var_0:	dc.b id_frame_spike_3up, $14			; $0x
Spike_Var_1:	dc.b id_frame_spike_3left, $10			; $1x
Spike_Var_2:	dc.b id_frame_spike_1up, 4			; $2x
Spike_Var_3:	dc.b id_frame_spike_3upwide, $1C		; $3x
Spike_Var_4:	dc.b id_frame_spike_6upwide, $40		; $4x
Spike_Var_5:	dc.b id_frame_spike_1left, $10			; $5x

ost_spike_x_start:	equ $30					; original X position (2 bytes)
ost_spike_y_start:	equ $32					; original Y position (2 bytes)
ost_spike_move_dist:	equ $34					; pixel distance to move object * $100, either direction (2 bytes)
ost_spike_move_flag:	equ $36					; 0 = original position; 1 = moved position (2 bytes)
ost_spike_move_time:	equ $38					; time until object moves again (2 bytes)
; ===========================================================================

Spike_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Spike_Solid next
		move.l	#Map_Spike,ost_mappings(a0)
		move.w	#tile_Nem_Spikes,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	ost_subtype(a0),d0
		andi.b	#$F,ost_subtype(a0)			; read only low nybble of subtype
		andi.w	#$F0,d0					; read high nybble
		lea	(Spike_Var).l,a1
		lsr.w	#3,d0
		adda.w	d0,a1					; use high nybble of subtype to get frame & width info
		move.b	(a1)+,ost_frame(a0)
		move.b	(a1)+,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_spike_x_start(a0)
		move.w	ost_y_pos(a0),ost_spike_y_start(a0)

Spike_Solid:	; Routine 2
		bsr.w	Spike_Move				; update position
		move.w	#4,d2					; height for type $5x
		cmpi.b	#id_frame_spike_1left,ost_frame(a0)	; is object type $5x ?
		beq.s	Spike_SideWays				; if yes, branch
		cmpi.b	#id_frame_spike_3left,ost_frame(a0)	; is object type $1x ?
		bne.s	Spike_Upright				; if not, branch
		move.w	#$14,d2					; height for type $1x

; Spikes types $1x and $5x face	sideways

Spike_SideWays:
		move.w	#$1B,d1
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject				; detect collision
		btst	#status_platform_bit,ost_status(a0)	; is Sonic on top of the spikes?
		bne.s	Spike_Display				; if yes, branch
		cmpi.w	#1,d4					; is Sonic touching the sides?
		beq.s	Spike_Hurt				; if yes, branch
		bra.s	Spike_Display
; ===========================================================================

; Spikes types $0x, $2x, $3x and $4x face up or	down

Spike_Upright:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2					; height
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject				; detect collision
		btst	#status_platform_bit,ost_status(a0)	; is Sonic on top of the spikes?
		bne.s	Spike_Hurt				; if yes, branch
		tst.w	d4
		bpl.s	Spike_Display				; branch if Sonic is touching sides, or not touching at all

Spike_Hurt:
		tst.b	(v_invincibility).w			; is Sonic invincible?
		bne.s	Spike_Display				; if yes, branch
		move.l	a0,-(sp)				; save OST address for spikes to stack
		movea.l	a0,a2					; a2 is OST for spikes now
		lea	(v_ost_player).w,a0			; a0 is temporarily Sonic now
		cmpi.b	#id_Sonic_Hurt,ost_routine(a0)		; is Sonic hurt or dead?
		bcc.s	Spike_Skip_Hurt				; if yes, branch
		if Revision<>2
			move.l	ost_y_pos(a0),d3
			move.w	ost_y_vel(a0),d0
			ext.l	d0
			asl.l	#8,d0
		else
								; this fixes the infamous "spike bug"
			tst.w	ost_sonic_flash_time(a0)	; is Sonic flashing after being hurt?
			bne.s	Spike_Skip_Hurt			; if yes, branch
			jmp	(Spike_Bugfix).l		; this is a copy of the above code that was pushed aside for this
	Spike_Resume:
		endc
		sub.l	d0,d3
		move.l	d3,ost_y_pos(a0)			; move Sonic away from spikes, based on his y speed
		jsr	(HurtSonic).l				; lose rings/die

	Spike_Skip_Hurt:
		movea.l	(sp)+,a0				; restore OST address for spikes from stack

Spike_Display:
		bsr.w	DisplaySprite
		out_of_range	DeleteObject,ost_spike_x_start(a0)
		rts	
; ===========================================================================

Spike_Move:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (only low nybble remains)
		add.w	d0,d0
		move.w	Spike_TypeIndex(pc,d0.w),d1
		jmp	Spike_TypeIndex(pc,d1.w)
; ===========================================================================
Spike_TypeIndex:
		index *
		ptr Spike_Still					; $x0
		ptr Spike_UpDown				; $x1
		ptr Spike_LeftRight				; $x2
; ===========================================================================

; Type 0 - doesn't move
Spike_Still:
		rts
; ===========================================================================

; Type 1 - moves up and down
Spike_UpDown:
		bsr.w	Spike_Wait				; run timer and update ost_spike_move_dist
		moveq	#0,d0
		move.b	ost_spike_move_dist(a0),d0		; get distance to move
		add.w	ost_spike_y_start(a0),d0		; add to initial y position
		move.w	d0,ost_y_pos(a0)			; update position
		rts	
; ===========================================================================

; Type 2 - moves side-to-side
Spike_LeftRight:
		bsr.w	Spike_Wait				; run timer and update ost_spike_move_dist
		moveq	#0,d0
		move.b	ost_spike_move_dist(a0),d0		; get distance to move
		add.w	ost_spike_x_start(a0),d0		; add to initial x position
		move.w	d0,ost_x_pos(a0)			; update position
		rts	
; ===========================================================================

Spike_Wait:
		tst.w	ost_spike_move_time(a0)			; has timer hit 0?
		beq.s	@update					; if yes, branch
		subq.w	#1,ost_spike_move_time(a0)		; decrement timer
		bne.s	@exit					; branch if not 0
		tst.b	ost_render(a0)				; is spikes object on-screen?
		bpl.s	@exit					; if not, branch
		play.w	1, jsr, sfx_SpikeMove			; play "spikes moving" sound
		bra.s	@exit
; ===========================================================================

@update:
		tst.w	ost_spike_move_flag(a0)			; are spikes in original position?
		beq.s	@original_pos				; if yes, branch
		subi.w	#$800,ost_spike_move_dist(a0)		; subtract 8px from distance
		bcc.s	@exit					; branch if 0 or more
		move.w	#0,ost_spike_move_dist(a0)		; set minimum distance
		move.w	#0,ost_spike_move_flag(a0)		; set flag that spikes are in original position
		move.w	#60,ost_spike_move_time(a0)		; set time delay to 1 second
		bra.s	@exit
; ===========================================================================

@original_pos:
		addi.w	#$800,ost_spike_move_dist(a0)		; add 8px to move distance
		cmpi.w	#$2000,ost_spike_move_dist(a0)		; has it moved 32px?
		bcs.s	@exit					; if not, branch
		move.w	#$2000,ost_spike_move_dist(a0)		; set max distance
		move.w	#1,ost_spike_move_flag(a0)		; set flag that spikes are in new position
		move.w	#60,ost_spike_move_time(a0)		; set time delay to 1 second

@exit:
		rts	
