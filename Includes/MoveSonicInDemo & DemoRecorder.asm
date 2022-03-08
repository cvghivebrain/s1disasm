; ---------------------------------------------------------------------------
; Subroutine to	move Sonic in demo mode

;	uses d0, d1, d2, a0, a1
; ---------------------------------------------------------------------------

MoveSonicInDemo:
		tst.w	(v_demo_mode).w				; is demo mode on?
		bne.s	MDemo_On				; if yes, branch
		rts

; ---------------------------------------------------------------------------
; Unused subroutine for recording a demo

;	uses d0, a1
; ---------------------------------------------------------------------------

DemoRecorder:
		lea	($80000).l,a1				; memory address to record demo to
		move.w	(v_demo_input_counter).w,d0		; get number of inputs so far
		adda.w	d0,a1					; jump to last position in recorded data
		move.b	(v_joypad_hold_actual).w,d0		; get joypad input state
		cmp.b	(a1),d0					; is joypad input same as last frame?
		bne.s	@next					; if not, branch
		addq.b	#1,1(a1)				; increment time for current input
		cmpi.b	#$FF,1(a1)				; has input timer hit 255 (maximum)?
		beq.s	@next					; if yes, branch
		rts	

	@next:
		move.b	d0,2(a1)				; write new input state
		move.b	#0,3(a1)				; set time to 0
		addq.w	#2,(v_demo_input_counter).w		; increment counter
		andi.w	#$3FF,(v_demo_input_counter).w		; counter stops at $200 inputs
		rts	
; ===========================================================================

MDemo_On:
		tst.b	(v_joypad_hold_actual).w		; is start button pressed?
		bpl.s	@dontquit				; if not, branch
		tst.w	(v_demo_mode).w				; is this an ending sequence demo?
		bmi.s	@dontquit				; if yes, branch
		move.b	#id_Title,(v_gamemode).w		; go to title screen

	@dontquit:
		lea	(DemoDataPtr).l,a1			; get address of demo pointer list
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.b	#id_Special,(v_gamemode).w		; is this a special stage?
		bne.s	@notspecial				; if not, branch
		moveq	#6,d0					; use demo #6

	@notspecial:
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1				; jump to address of relevant demo data
		tst.w	(v_demo_mode).w				; is this an ending sequence demo?
		bpl.s	@notcredits				; if not, branch

		lea	(DemoEndDataPtr).l,a1			; get address of ending demo pointer list
		move.w	(v_credits_num).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1				; jump to address of relevant ending demo data

	@notcredits:
		move.w	(v_demo_input_counter).w,d0		; get number of inputs so far
		adda.w	d0,a1					; jump to current input
		move.b	(a1),d0					; get joypad state from demo
		lea	(v_joypad_hold_actual).w,a0		; (a0) = actual joypad state
		move.b	d0,d1
		if Revision=0
			move.b	(a0),d2
		else
			moveq	#0,d2
		endc
		eor.b	d2,d0
		move.b	d1,(a0)+				; force demo input
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(v_demo_input_time).w		; decrement timer for current input
		bcc.s	@end					; branch if 0 or higher
		move.b	3(a1),(v_demo_input_time).w		; get time for next input
		addq.w	#2,(v_demo_input_counter).w		; increment counter

	@end:
		rts
