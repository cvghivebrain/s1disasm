; ---------------------------------------------------------------------------
; Platform subroutine
;
; input:
;	d1 = platform width
;	d0 = y position (Plat_NoXCheck_AltY only)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

DetectPlatform:
		lea	(v_ost_player).w,a1
		tst.w	ost_y_vel(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

;		perform x-axis range check
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit				; branch if Sonic is right of the platform

	Plat_NoXCheck:						; jump here to skip x position check
		move.w	ost_y_pos(a0),d0
		subq.w	#8,d0

	Plat_NoXCheck_AltY:					; jump here to skip x position check and use custom y position

;		perform y-axis range check
		move.w	ost_y_pos(a1),d2
		move.b	ost_height(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	Plat_Exit
		cmpi.w	#-$10,d0
		blo.w	Plat_Exit

		tst.b	(v_lock_multi).w			; is object collision off?
		bmi.w	Plat_Exit				; if yes, branch
		cmpi.b	#id_Sonic_Death,ost_routine(a1)		; is Sonic dying?
		bhs.w	Plat_Exit				; if yes, branch
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,ost_y_pos(a1)
		addq.b	#2,ost_routine(a0)			; increment object's routine counter

Plat_NoCheck:							; jump here to skip all checks
		btst	#status_platform_bit,ost_status(a1)	; is Sonic on a platform already?
		beq.s	@no					; if not, branch
		moveq	#0,d0
		move.b	ost_sonic_on_obj(a1),d0			; get OST index for that platform
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0			; convert index to RAM address
		movea.l	d0,a2					; point a2 to that address
		bclr	#status_platform_bit,ost_status(a2)	; clear platform bit for the other platform
		clr.b	ost_routine2(a2)
		cmpi.b	#4,ost_routine(a2)			; does its rountine counter suggest it's being stood on? (platforms all use similar rountines)
		bne.s	@no					; if not, branch
		subq.b	#2,ost_routine(a2)			; decrement counter to "detect mode"

	@no:
		move.w	a0,d0
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,ost_sonic_on_obj(a1)			; convert current platform OST address to index and store it
		move.b	#0,ost_angle(a1)
		move.w	#0,ost_y_vel(a1)
		move.w	ost_x_vel(a1),ost_inertia(a1)
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air/jumping?
		beq.s	@notinair				; if not, branch
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l			; make Sonic land
		movea.l	(sp)+,a0

	@notinair:
		bset	#status_platform_bit,ost_status(a1)
		bset	#status_platform_bit,ost_status(a0)

Plat_Exit:
		rts	
; End of function DetectPlatform
