; ---------------------------------------------------------------------------
; Subroutine to detect collision with a platform, and update relevant flags
;
; input:
;	d0 = y position (Plat_NoXCheck_AltY only)
;	d1 = platform width

; output:
;	d2 = Sonic's y position
;	a1 = OST of Sonic
;	a2 = OST of platform that Sonic is already on
;	uses d0, d1
; ---------------------------------------------------------------------------

DetectPlatform:
		lea	(v_ost_player).w,a1
		tst.w	ost_y_vel(a1)				; is Sonic moving up/jumping?
		bmi.w	Plat_Exit				; if yes, branch

		; perform x-axis range check
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0 = Sonic's distance from centre of platform (-ve if left of centre)
		add.w	d1,d0
		bmi.w	Plat_Exit				; branch if Sonic is left of the platform
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit				; branch if Sonic is right of the platform

	Plat_NoXCheck:						; jump here to skip x position check
		move.w	ost_y_pos(a0),d0
		subq.w	#8,d0					; assume platform is 8px tall

	Plat_NoXCheck_AltY:					; jump here to skip x position check and use custom y position

		; perform y-axis range check
		move.w	ost_y_pos(a1),d2
		move.b	ost_height(a1),d1
		ext.w	d1
		add.w	d2,d1					; d1 = y pos of Sonic's bottom edge
		addq.w	#4,d1
		sub.w	d1,d0					; d0 = distance between top of platform and Sonic's bottom edge (-ve if below platform)
		bhi.w	Plat_Exit				; branch if Sonic is above platform
		cmpi.w	#-16,d0
		blo.w	Plat_Exit				; branch if Sonic is more than 16px below top of platform

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
		beq.s	.no					; if not, branch
		moveq	#0,d0
		move.b	ost_sonic_on_obj(a1),d0			; get OST index for that platform
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0			; convert index to RAM address
		movea.l	d0,a2					; point a2 to that address
		bclr	#status_platform_bit,ost_status(a2)	; clear platform bit for the other platform
		clr.b	ost_routine2(a2)
		cmpi.b	#id_Plat_StoodOn,ost_routine(a2)	; does its routine counter suggest it's being stood on? (platforms all use similar routines)
		bne.s	.no					; if not, branch
		subq.b	#2,ost_routine(a2)			; decrement counter to "detect mode"

	.no:
		move.w	a0,d0
		subi.w	#v_ost_all&$FFFF,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,ost_sonic_on_obj(a1)			; convert current platform OST address to index and store it
		move.b	#0,ost_angle(a1)
		move.w	#0,ost_y_vel(a1)
		move.w	ost_x_vel(a1),ost_inertia(a1)
		btst	#status_air_bit,ost_status(a1)		; is Sonic in the air/jumping?
		beq.s	.notinair				; if not, branch
		pushr	a0
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l			; make Sonic land
		popr	a0

	.notinair:
		bset	#status_platform_bit,ost_status(a1)
		bset	#status_platform_bit,ost_status(a0)

Plat_Exit:
		rts
