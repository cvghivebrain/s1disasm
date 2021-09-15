; ---------------------------------------------------------------------------
; Object 69 - spinning platforms and trapdoors (SBZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Spin_Index(pc,d0.w),d1
		jmp	Spin_Index(pc,d1.w)
; ===========================================================================
Spin_Index:	index *,,2
		ptr Spin_Main
		ptr Spin_Trapdoor
		ptr Spin_Spinner

ost_spin_wait_time:	equ $30	; time until change (2 bytes)
ost_spin_wait_master:	equ $32	; time between changes (2 bytes)
ost_spin_flag:		equ $34	; 1 = switch between animations, spinning platforms only
ost_spin_sync:		equ $36	; bitmask used to synchronise timing: subtype $8x = $3F; subtype $9x = $7F (2 bytes)
; ===========================================================================

Spin_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Trap,ost_mappings(a0)
		move.w	#tile_Nem_TrapDoor+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$80,ost_actwidth(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype
		andi.w	#$F,d0		; read only 2nd digit
		mulu.w	#60,d0		; multiply by 60 (1 second)
		move.w	d0,ost_spin_wait_master(a0)
		tst.b	ost_subtype(a0)	; is subtype $8x?
		bpl.s	Spin_Trapdoor	; if not, branch

		addq.b	#2,ost_routine(a0) ; goto Spin_Spinner next
		move.l	#Map_Spin,ost_mappings(a0)
		move.w	#tile_Nem_SpinPform,ost_tile(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#2,ost_anim(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		move.w	d0,d1
		andi.w	#$F,d0		; read only the	2nd digit
		mulu.w	#6,d0		; multiply by 6
		move.w	d0,ost_spin_wait_time(a0)
		move.w	d0,ost_spin_wait_master(a0) ; set time delay
		andi.w	#$70,d1		; read 2nd digit (e.g. $80/$90), ignore high bit ($00/$10)
		addi.w	#$10,d1		; add $10 ($10/$20)
		lsl.w	#2,d1		; multiply by 4 ($40/$80)
		subq.w	#1,d1		; subtract 1 ($3F/$7F)
		move.w	d1,ost_spin_sync(a0)
		bra.s	Spin_Spinner
; ===========================================================================

Spin_Trapdoor:	; Routine 2
		subq.w	#1,ost_spin_wait_time(a0) ; decrement timer
		bpl.s	@animate	; if time remains, branch

		move.w	ost_spin_wait_master(a0),ost_spin_wait_time(a0)
		bchg	#0,ost_anim(a0)	; switch between opening/closing animations
		tst.b	ost_render(a0)
		bpl.s	@animate
		sfx	sfx_Door,0,0,0	; play door sound

	@animate:
		lea	(Ani_Spin).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_frame(a0)	; is frame number 0 displayed?
		bne.s	@notsolid	; if not, branch
		move.w	#$4B,d1
		move.w	#$C,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		bra.w	RememberState
; ===========================================================================

@notsolid:
		btst	#status_platform_bit,ost_status(a0) ; is Sonic standing on the trapdoor?
		beq.s	@display	; if not, branch
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)

	@display:
		bra.w	RememberState
; ===========================================================================

Spin_Spinner:	; Routine 4
		move.w	(v_framecount).w,d0 ; read frame counter
		and.w	ost_spin_sync(a0),d0 ; apply bitmask ($3F or $7F)
		bne.s	@delay		; branch if not 0
		move.b	#1,ost_spin_flag(a0) ; set flag (occurs every 64 or 128 frames)

	@delay:
		tst.b	ost_spin_flag(a0) ; is flag set?
		beq.s	@animate	; if not, branch
		subq.w	#1,ost_spin_wait_time(a0)
		bpl.s	@animate
		move.w	ost_spin_wait_master(a0),ost_spin_wait_time(a0)
		clr.b	ost_spin_flag(a0)
		bchg	#0,ost_anim(a0)

	@animate:
		lea	(Ani_Spin).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_frame(a0)	; check	if frame number	0 is displayed
		bne.s	@notsolid2	; if not, branch
		move.w	#$1B,d1
		move.w	#7,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		bra.w	RememberState
; ===========================================================================

@notsolid2:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	@display
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)

	@display:
		bra.w	RememberState
