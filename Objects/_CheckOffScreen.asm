; ---------------------------------------------------------------------------
; Subroutine to	check if an object is off screen

; output:
;	d0.l = flag set if object is off screen
;	d1.w = y pos of object relative to screen

; usage:
;		bsr.w	CheckOffScreen
;		bne.s	.offscreen				; branch if off screen
; ---------------------------------------------------------------------------

CheckOffScreen:
		move.w	ost_x_pos(a0),d0			; get object x position
		sub.w	(v_camera_x_pos).w,d0			; subtract screen x position
		bmi.s	.offscreen				; branch if off left side of screen
		cmpi.w	#screen_width,d0
		bge.s	.offscreen				; branch if off right side of screen

		move.w	ost_y_pos(a0),d1			; get object y position
		sub.w	(v_camera_y_pos).w,d1			; subtract screen y position
		bmi.s	.offscreen				; branch if off top of screen
		cmpi.w	#screen_height,d1
		bge.s	.offscreen				; branch if off bottom of screen

		moveq	#0,d0					; set flag to 0
		rts	

	.offscreen:
		moveq	#1,d0					; set flag to 1
		rts

; ---------------------------------------------------------------------------
; Subroutine to	check if an object is off screen
; More precise than above subroutine, taking width into account

; output:
;	d0.l = flag set if object is off screen
;	d1.w = y pos of object relative to screen

;	uses d1.l

; usage:
;		bsr.w	CheckOffScreen_Wide
;		bne.s	.offscreen				; branch if off screen
; ---------------------------------------------------------------------------

CheckOffScreen_Wide:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		move.w	ost_x_pos(a0),d0			; get object x position
		sub.w	(v_camera_x_pos).w,d0			; subtract screen x position
		add.w	d1,d0					; d0 = x pos of object's right edge relative to screen
		bmi.s	.offscreen				; branch if off left side of screen
		add.w	d1,d1
		sub.w	d1,d0					; d0 = x pos of object's left edge relative to screen
		cmpi.w	#screen_width,d0
		bge.s	.offscreen				; branch if off right side of screen

		move.w	ost_y_pos(a0),d1
		sub.w	(v_camera_y_pos).w,d1
		bmi.s	.offscreen				; branch if off top of screen
		cmpi.w	#screen_height,d1
		bge.s	.offscreen				; branch if off bottom of screen

		moveq	#0,d0					; set flag to 0
		rts	

	.offscreen:
		moveq	#1,d0					; set flag to 1
		rts
