; ---------------------------------------------------------------------------
; Object 6D - flame thrower (SBZ)

; spawned by:
;	ObjPos_SBZ1, ObjPos_SBZ2 - subtype $43
; ---------------------------------------------------------------------------

Flamethrower:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Flame_Index(pc,d0.w),d1
		jmp	Flame_Index(pc,d1.w)
; ===========================================================================
Flame_Index:	index *,,2
		ptr Flame_Main
		ptr Flame_Action

ost_flame_time:		equ $30					; time until current action is complete (2 bytes)
ost_flame_on_master:	equ $32					; time flame is on (2 bytes)
ost_flame_off_master:	equ $34					; time flame is off (2 bytes)
ost_flame_last_frame:	equ $36					; last frame of animation
; ===========================================================================

Flame_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Flame_Action next
		move.l	#Map_Flame,ost_mappings(a0)
		move.w	#tile_Nem_FlamePipe+tile_hi,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.w	ost_y_pos(a0),ost_flame_time(a0)	; store ost_y_pos (gets overwritten later though)
		move.b	#$C,ost_displaywidth(a0)
		move.b	ost_subtype(a0),d0
		andi.w	#$F0,d0					; read 1st digit of object type
		add.w	d0,d0					; multiply by 2
		move.w	d0,ost_flame_time(a0)
		move.w	d0,ost_flame_on_master(a0)		; set flaming time
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0					; read 2nd digit of object type
		lsl.w	#5,d0					; multiply by $20
		move.w	d0,ost_flame_off_master(a0)		; set pause time
		move.b	#id_frame_flame_pipe11,ost_flame_last_frame(a0) ; final frame = $A
		btst	#status_yflip_bit,ost_status(a0)	; is object yflipped?
		beq.s	Flame_Action				; if not, branch

		move.b	#id_ani_flame_valve_on,ost_anim(a0)	; use value-style animation
		move.b	#id_frame_flame_valve11,ost_flame_last_frame(a0) ; final frame = $15

Flame_Action:	; Routine 2
		subq.w	#1,ost_flame_time(a0)			; decrement timer
		bpl.s	@wait					; if time remains, branch
		move.w	ost_flame_off_master(a0),ost_flame_time(a0) ; begin pause time
		bchg	#0,ost_anim(a0)				; switch between on/off animations
		beq.s	@wait					; branch if previously on

		move.w	ost_flame_on_master(a0),ost_flame_time(a0) ; begin flaming time
		play.w	1, jsr, sfx_Flame			; play flame sound

	@wait:
		lea	(Ani_Flame).l,a1
		bsr.w	AnimateSprite
		move.b	#0,ost_col_type(a0)
		move.b	ost_flame_last_frame(a0),d0
		cmp.b	ost_frame(a0),d0			; has flame animation finished?
		bne.s	@harmless				; if not, branch
		move.b	#id_col_12x24+id_col_hurt,ost_col_type(a0) ; make object harmful

	@harmless:
		out_of_range	DeleteObject
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Flame:	index *
		ptr ani_flame_pipe_on
		ptr ani_flame_pipe_off
		ptr ani_flame_valve_on
		ptr ani_flame_valve_off
		
ani_flame_pipe_on:
		dc.b 3
		dc.b id_frame_flame_pipe1
		dc.b id_frame_flame_pipe2
		dc.b id_frame_flame_pipe3
		dc.b id_frame_flame_pipe4
		dc.b id_frame_flame_pipe5
		dc.b id_frame_flame_pipe6
		dc.b id_frame_flame_pipe7
		dc.b id_frame_flame_pipe8
		dc.b id_frame_flame_pipe9
		dc.b id_frame_flame_pipe10
		dc.b id_frame_flame_pipe11
		dc.b afBack, 2

ani_flame_pipe_off:
		dc.b 0
		dc.b id_frame_flame_pipe10
		dc.b id_frame_flame_pipe8
		dc.b id_frame_flame_pipe6
		dc.b id_frame_flame_pipe4
		dc.b id_frame_flame_pipe2
		dc.b id_frame_flame_pipe1
		dc.b afBack, 1
		even

ani_flame_valve_on:
		dc.b 3
		dc.b id_frame_flame_valve1
		dc.b id_frame_flame_valve2
		dc.b id_frame_flame_valve3
		dc.b id_frame_flame_valve4
		dc.b id_frame_flame_valve5
		dc.b id_frame_flame_valve6
		dc.b id_frame_flame_valve7
		dc.b id_frame_flame_valve8
		dc.b id_frame_flame_valve9
		dc.b id_frame_flame_valve10
		dc.b id_frame_flame_valve11
		dc.b afBack, 2

ani_flame_valve_off:
		dc.b 0
		dc.b id_frame_flame_valve10
		dc.b id_frame_flame_valve8
		dc.b id_frame_flame_valve7
		dc.b id_frame_flame_valve5
		dc.b id_frame_flame_valve3
		dc.b id_frame_flame_valve1
		dc.b afBack, 1
		even
