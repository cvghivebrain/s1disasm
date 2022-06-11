; ---------------------------------------------------------------------------
; Subroutine to	animate	a sprite using an animation script
;
; input:
;	a1 = animation script index (e.g. Ani_Crab)

; output:
;	a1 = animation script (e.g. ani_crab_stand)
;	uses d0, d1
; ---------------------------------------------------------------------------

AnimateSprite:
		moveq	#0,d0
		move.b	ost_anim(a0),d0				; move animation number	to d0
		cmp.b	ost_anim_restart(a0),d0			; is animation set to restart?
		beq.s	Anim_Run				; if not, branch

		move.b	d0,ost_anim_restart(a0)			; set to "no restart"
		move.b	#0,ost_anim_frame(a0)			; reset animation
		move.b	#0,ost_anim_time(a0)			; reset frame duration

Anim_Run:
		subq.b	#1,ost_anim_time(a0)			; subtract 1 from frame duration
		bpl.s	Anim_Wait				; if time remains, branch
		add.w	d0,d0
		adda.w	(a1,d0.w),a1				; jump to appropriate animation	script
		move.b	(a1),ost_anim_time(a0)			; load frame duration
		moveq	#0,d1
		move.b	ost_anim_frame(a0),d1			; load current frame number
		move.b	1(a1,d1.w),d0				; read sprite number from script
		bmi.s	Anim_End_FF				; if animation is complete, branch

Anim_Next:
		move.b	d0,d1					; copy full frame info to d1
		andi.b	#$1F,d0					; sprite number only
		move.b	d0,ost_frame(a0)			; load sprite number
		move.b	ost_status(a0),d0
		rol.b	#3,d1					; move x/yflip bits into bits 0 and 1
		eor.b	d0,d1					; combine with status
		andi.b	#status_xflip+status_yflip,d1		; d1 = x/yflip bits only
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; clear x/yflip bits for render
		or.b	d1,ost_render(a0)			; apply x/yflip bits to render
		addq.b	#1,ost_anim_frame(a0)			; next frame number

Anim_Wait:
		rts	
; ===========================================================================

Anim_End_FF:
		addq.b	#1,d0					; is the end flag = $FF	?
		bne.s	Anim_End_FE				; if not, branch
		move.b	#0,ost_anim_frame(a0)			; restart the animation
		move.b	1(a1),d0				; read sprite number
		bra.s	Anim_Next
; ===========================================================================

Anim_End_FE:
		addq.b	#1,d0					; is the end flag = $FE	?
		bne.s	Anim_End_FD				; if not, branch
		move.b	2(a1,d1.w),d0				; read the next	byte in	the script
		sub.b	d0,ost_anim_frame(a0)			; jump back d0 bytes in the script
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0				; read sprite number
		bra.s	Anim_Next
; ===========================================================================

Anim_End_FD:
		addq.b	#1,d0					; is the end flag = $FD	?
		bne.s	Anim_End_FC				; if not, branch
		move.b	2(a1,d1.w),ost_anim(a0)			; read next byte, run that animation

Anim_End_FC:
		addq.b	#1,d0					; is the end flag = $FC	?
		bne.s	Anim_End_FB				; if not, branch
		addq.b	#2,ost_routine(a0)			; jump to next routine

Anim_End_FB:	; unused
		addq.b	#1,d0					; is the end flag = $FB	?
		bne.s	Anim_End_FA				; if not, branch
		move.b	#0,ost_anim_frame(a0)			; reset animation
		clr.b	ost_routine2(a0)			; reset 2nd routine counter

Anim_End_FA:	; only used by EndSonic
		addq.b	#1,d0					; is the end flag = $FA	?
		bne.s	Anim_End				; if not, branch
		addq.b	#2,ost_routine2(a0)			; jump to next routine

Anim_End:
		rts
