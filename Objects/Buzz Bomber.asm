; ---------------------------------------------------------------------------
; Object 22 - Buzz Bomber enemy	(GHZ, MZ, SYZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Buzz_Index(pc,d0.w),d1
		jmp	Buzz_Index(pc,d1.w)
; ===========================================================================
Buzz_Index:	index *,,2
		ptr Buzz_Main
		ptr Buzz_Action
		ptr Buzz_Delete

ost_buzz_wait_time:	equ $32	; time delay for each action (2 bytes)
ost_buzz_mode:		equ $34	; current action - 0 = flying; 1 = recently fired; 2 = near Sonic
; ===========================================================================

Buzz_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Buzz,ost_mappings(a0)
		move.w	#tile_Nem_Buzz,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#8,ost_col_type(a0)
		move.b	#$18,ost_actwidth(a0)

Buzz_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Buzz).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr @move
		ptr @chknearsonic
; ===========================================================================

@move:
		subq.w	#1,ost_buzz_wait_time(a0) ; subtract 1 from time delay
		bpl.s	@noflip		; if time remains, branch
		btst	#1,ost_buzz_mode(a0) ; is Buzz Bomber near Sonic?
		bne.s	@fire		; if yes, branch
		addq.b	#2,ost_routine2(a0)
		move.w	#127,ost_buzz_wait_time(a0) ; set time delay to just over 2 seconds
		move.w	#$400,ost_x_vel(a0) ; move Buzz Bomber to the right
		move.b	#1,ost_anim(a0)	; use "flying" animation
		btst	#0,ost_status(a0) ; is Buzz Bomber facing left?
		bne.s	@noflip		; if not, branch
		neg.w	ost_x_vel(a0)	; move Buzz Bomber to the left

	@noflip:
		rts	
; ===========================================================================

	@fire:
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Missile,0(a1) ; load missile object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		addi.w	#$1C,ost_y_pos(a1)
		move.w	#$200,ost_y_vel(a1) ; move missile downwards
		move.w	#$200,ost_x_vel(a1) ; move missile to the right
		move.w	#$18,d0
		btst	#status_xflip_bit,ost_status(a0) ; is Buzz Bomber facing left?
		bne.s	@noflip2	; if not, branch
		neg.w	d0
		neg.w	ost_x_vel(a1)	; move missile to the left

	@noflip2:
		add.w	d0,ost_x_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.w	#$E,ost_missile_wait_time(a1)
		move.l	a0,ost_missile_parent(a1)
		move.b	#1,ost_buzz_mode(a0) ; set to "already fired" to prevent refiring
		move.w	#59,ost_buzz_wait_time(a0)
		move.b	#2,ost_anim(a0)	; use "firing" animation

	@fail:
		rts	
; ===========================================================================

@chknearsonic:
		subq.w	#1,ost_buzz_wait_time(a0) ; subtract 1 from time delay
		bmi.s	@chgdirection
		bsr.w	SpeedToPos
		tst.b	ost_buzz_mode(a0)
		bne.s	@keepgoing
		move.w	(v_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bpl.s	@isleft
		neg.w	d0

	@isleft:
		cmpi.w	#$60,d0		; is Buzz Bomber within	$60 pixels of Sonic?
		bcc.s	@keepgoing	; if not, branch
		tst.b	ost_render(a0)
		bpl.s	@keepgoing
		move.b	#2,ost_buzz_mode(a0) ; set Buzz Bomber to "near Sonic"
		move.w	#29,ost_buzz_wait_time(a0) ; set time delay to half a second
		bra.s	@stop
; ===========================================================================

	@chgdirection:
		move.b	#0,ost_buzz_mode(a0) ; set Buzz Bomber to "normal"
		bchg	#status_xflip_bit,ost_status(a0) ; change direction
		move.w	#59,ost_buzz_wait_time(a0)

	@stop:
		subq.b	#2,ost_routine2(a0)
		move.w	#0,ost_x_vel(a0) ; stop Buzz Bomber moving
		move.b	#0,ost_anim(a0)	; use "hovering" animation

@keepgoing:
		rts	
; ===========================================================================

Buzz_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts	
