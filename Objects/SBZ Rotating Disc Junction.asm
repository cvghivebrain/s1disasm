; ---------------------------------------------------------------------------
; Object 66 - rotating disc junction that grabs Sonic (SBZ)

; spawned by:
;	ObjPos_SBZ1 - subtypes 0/2
;	Junction
; ---------------------------------------------------------------------------

Junction:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Jun_Index(pc,d0.w),d1
		jmp	Jun_Index(pc,d1.w)
; ===========================================================================
Jun_Index:	index *,,2
		ptr Jun_Main
		ptr Jun_Action
		ptr Jun_Display
		ptr Jun_Release

ost_junc_grab_frame:	equ $32					; which frame the junction grabbed Sonic on
ost_junc_direction:	equ $34					; direction of rotation: 1 or -1 (added to the frame number)
ost_junc_button_flag:	equ $36					; flag set when button is pressed
ost_junc_button_num:	equ $38					; which button will reverse the disc
; ===========================================================================

Jun_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Jun_Action next
		move.w	#1,d1
		movea.l	a0,a1
		bra.s	@makeitem
; ===========================================================================

	@loop:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_Junction,ost_id(a1)			; load 2nd junction object
		addq.b	#4,ost_routine(a1)			; goto Jun_Display next
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#3,ost_priority(a1)
		move.b	#id_frame_junc_circle,ost_frame(a1)	; use large circular sprite

@makeitem:
		move.l	#Map_Jun,ost_mappings(a1)
		move.w	#tile_Nem_SbzWheel2+tile_pal3,ost_tile(a1)
		ori.b	#render_rel,ost_render(a1)
		move.b	#$38,ost_actwidth(a1)

	@fail:
		dbf	d1,@loop				; repeat once for large background circle

		move.b	#$30,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		move.w	#$3C,$30(a0)
		move.b	#1,ost_junc_direction(a0)		; set default direction (anticlockwise)
		move.b	ost_subtype(a0),ost_junc_button_num(a0)

Jun_Action:	; Routine 2
		bsr.w	Jun_Update				; check if button is pressed and animate the junction
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	Jun_Display				; if not, branch
		move.w	#$30,d1
		move.w	d1,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		btst	#status_pushing_bit,ost_status(a0)	; is Sonic pushing the disc?
		beq.w	Jun_Display				; if not, branch

		lea	(v_ost_player).w,a1
		moveq	#id_frame_junc_nw,d1
		move.w	ost_x_pos(a1),d0
		cmp.w	ost_x_pos(a0),d0			; is Sonic to the left of the disc?
		bcs.s	@isleft					; if yes, branch
		moveq	#id_frame_junc_ese,d1		

	@isleft:
		cmp.b	ost_frame(a0),d1			; is the gap next to Sonic?
		bne.s	Jun_Display				; if not, branch

		move.b	d1,ost_junc_grab_frame(a0)
		addq.b	#4,ost_routine(a0)			; goto Jun_Release next
		move.b	#1,(v_lock_multi).w			; lock controls
		move.b	#id_Roll,ost_anim(a1)			; make Sonic use "rolling" animation
		move.w	#$800,ost_inertia(a1)
		move.w	#0,ost_x_vel(a1)
		move.w	#0,ost_y_vel(a1)
		bclr	#status_pushing_bit,ost_status(a0)
		bclr	#status_pushing_bit,ost_status(a1)
		bset	#status_air_bit,ost_status(a1)
		move.w	ost_x_pos(a1),d2
		move.w	ost_y_pos(a1),d3
		bsr.w	Jun_MoveSonic				; update Sonic's position within the junction
		add.w	d2,ost_x_pos(a1)
		add.w	d3,ost_y_pos(a1)
		asr	ost_x_pos(a1)
		asr	ost_y_pos(a1)

Jun_Display:	; Routine 4
		bra.w	DespawnObject
; ===========================================================================

Jun_Release:	; Routine 6
		move.b	ost_frame(a0),d0
		cmpi.b	#id_frame_junc_s,d0			; is gap pointing down?
		beq.s	@release				; if yes, branch
		cmpi.b	#id_frame_junc_ese,d0			; is gap pointing right?
		bne.s	@dontrelease				; if not, branch

	@release:
		cmp.b	ost_junc_grab_frame(a0),d0		; is gap on the frame Sonic was grabbed on?
		beq.s	@dontrelease				; if yes, branch
		lea	(v_ost_player).w,a1
		move.w	#0,ost_x_vel(a1)
		move.w	#$800,ost_y_vel(a1)			; drop Sonic straight down
		cmpi.b	#id_frame_junc_s,d0			; is gap pointing down?
		beq.s	@isdown					; if yes, branch
		move.w	#$800,ost_x_vel(a1)
		move.w	#$800,ost_y_vel(a1)			; launch Sonic diagonally down-right

	@isdown:
		clr.b	(v_lock_multi).w			; unlock controls
		subq.b	#4,ost_routine(a0)			; goto Jun_Action next

	@dontrelease:
		bsr.s	Jun_Update				; check if button is pressed and animate the junction
		bsr.s	Jun_MoveSonic				; update Sonic's position within the junction
		bra.w	DespawnObject

; ---------------------------------------------------------------------------
; Subroutine to update direction when button is pressed and animate
; ---------------------------------------------------------------------------

Jun_Update:
		lea	(v_button_state).w,a2
		moveq	#0,d0
		move.b	ost_junc_button_num(a0),d0
		btst	#0,(a2,d0.w)				; is relevant button pressed?
		beq.s	@unpressed				; if not, branch

		tst.b	ost_junc_button_flag(a0)		; has button previously been pressed?
		bne.s	@animate				; if yes, branch
		neg.b	ost_junc_direction(a0)			; reverse direction (set to -1)
		move.b	#1,ost_junc_button_flag(a0)		; set to "previously pressed"
		bra.s	@animate
; ===========================================================================

@unpressed:
		clr.b	ost_junc_button_flag(a0)		; set to "not yet pressed"

@animate:
		subq.b	#1,ost_anim_time(a0)			; decrement frame timer
		bpl.s	@nochange				; if time remains, branch
		move.b	#7,ost_anim_time(a0)			; 7 frames until next update
		move.b	ost_junc_direction(a0),d1
		move.b	ost_frame(a0),d0
		add.b	d1,d0					; add direction (1 or -1) to frame
		andi.b	#$F,d0
		move.b	d0,ost_frame(a0)			; update frame

	@nochange:
		rts	
; End of function Jun_Update

; ---------------------------------------------------------------------------
; Subroutine to move Sonic while he's in the junction
; ---------------------------------------------------------------------------

Jun_MoveSonic:
		lea	(v_ost_player).w,a1
		moveq	#0,d0
		move.b	ost_frame(a0),d0
		add.w	d0,d0					; d0 = current frame * 2
		lea	@data(pc,d0.w),a2			; jump to relevant position data
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_x_pos(a0),d0			; get x pos relative to junction
		move.w	d0,ost_x_pos(a1)			; update Sonic's x pos
		move.b	(a2)+,d0
		ext.w	d0
		add.w	ost_y_pos(a0),d0			; get y pos relative to junction
		move.w	d0,ost_y_pos(a1)			; update Sonic's y pos
		rts	

@data:		; x pos, y pos
		dc.b -$20,    0					; w
		dc.b -$1E,   $E					; wsw
		dc.b -$18,  $18					; sw
		dc.b  -$E,  $1E					; ssw
		dc.b    0,  $20					; s
		dc.b   $E,  $1E					; sse
		dc.b  $18,  $18					; se
		dc.b  $1E,   $E					; ese
		dc.b  $20,    0					; e
		dc.b  $1E,  -$E					; ene
		dc.b  $18, -$18					; ne
		dc.b   $E, -$1E					; nne
		dc.b    0, -$20					; n
		dc.b  -$E, -$1E					; nnw
		dc.b -$18, -$18					; nw
		dc.b -$1E,  -$E					; wnw
