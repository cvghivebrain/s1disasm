; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence

; spawned by:
;	GM_Ending
; ---------------------------------------------------------------------------

EndSonic:
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	index *,,2
		ptr ESon_Main
		ptr ESon_MakeEmeralds
		ptr ESon_Animate
		ptr ESon_LookUp
		ptr ESon_ClrEmeralds
		ptr ESon_Animate
		ptr ESon_MakeLogo
		ptr ESon_Animate
		ptr ESon_Leap
		ptr ESon_Animate

ost_esonic_wait_time:	equ $30					; time to wait between events (2 bytes)
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#6,(v_emeralds).w			; do you have all 6 emeralds?
		beq.s	ESon_Main2				; if yes, branch
		addi.b	#id_ESon_Leap,ost_routine2(a0)		; else, skip emerald sequence
		move.w	#216,ost_esonic_wait_time(a0)		; set delay to 3.6 seconds
		rts	
; ===========================================================================

ESon_Main2:
		addq.b	#2,ost_routine2(a0)			; goto ESon_MakeEmeralds next
		move.l	#Map_ESon,ost_mappings(a0)
		move.w	#tile_Nem_EndSonic,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		clr.b	ost_status(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_frame_esonic_hold1,ost_frame(a0)
		move.w	#80,ost_esonic_wait_time(a0)		; set delay to 1.3 seconds

ESon_MakeEmeralds:
		; Routine 2
		subq.w	#1,ost_esonic_wait_time(a0)		; decrement timer
		bne.s	@wait					; branch if time remains
		addq.b	#2,ost_routine2(a0)			; goto ESon_Animate next
		move.w	#id_ani_esonic_confused,ost_anim(a0)
		move.b	#id_EndChaos,(v_ost_end_emeralds).w	; load chaos emeralds objects

	@wait:
		rts	
; ===========================================================================

ESon_LookUp:	; Routine 6
		cmpi.w	#$2000,((v_ost_end_emeralds&$FFFFFF)+ost_echaos_radius).l ; has emerald circle expanded fully?
		bne.s	@wait					; if not, branch
		move.w	#1,(f_restart).w			; set level to restart (causes flash)
		move.w	#90,ost_esonic_wait_time(a0)		; set delay to 1.5 seconds
		addq.b	#2,ost_routine2(a0)			; goto ESon_ClrEmeralds next

	@wait:
		rts	
; ===========================================================================

ESon_ClrEmeralds:
		; Routine 8
		subq.w	#1,ost_esonic_wait_time(a0)		; decrement timer
		bne.s	@wait
		lea	(v_ost_end_emeralds).w,a1		; address of OST of emeralds
		move.w	#((sizeof_ost*$10)/4)-1,d1		; amount of space to clear (excessive; $10 could be 6)

	@loop:
		clr.l	(a1)+
		dbf	d1,@loop				; clear the object RAM

		move.w	#1,(f_restart).w
		addq.b	#2,ost_routine2(a0)			; goto ESon_Animate next
		move.b	#id_ani_esonic_confused,ost_anim(a0)
		move.w	#60,ost_esonic_wait_time(a0)		; set delay to 1 second

	@wait:
		rts	
; ===========================================================================

ESon_MakeLogo:	; Routine $C
		subq.w	#1,ost_esonic_wait_time(a0)		; decrement timer
		bne.s	@wait
		addq.b	#2,ost_routine2(a0)			; goto ESon_Animate next
		move.w	#180,ost_esonic_wait_time(a0)		; set delay to 3 seconds
		move.b	#id_ani_esonic_leap,ost_anim(a0)
		move.b	#id_EndSTH,(v_ost_end_emeralds).w	; load "SONIC THE HEDGEHOG" object

	@wait:
		rts	
; ===========================================================================

ESon_Animate:	; Rountine 4, $A, $E, $12
		lea	(Ani_ESon).l,a1
		jmp	(AnimateSprite).l			; increments ost_routine2 after each animation
; ===========================================================================

ESon_Leap:	; Routine $10
		subq.w	#1,ost_esonic_wait_time(a0)		; decrement timer
		bne.s	@wait
		addq.b	#2,ost_routine2(a0)			; goto ESon_Animate next
		move.l	#Map_ESon,ost_mappings(a0)
		move.w	#tile_Nem_EndSonic,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		clr.b	ost_status(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_frame_esonic_leap1,ost_frame(a0)
		move.b	#id_ani_esonic_leap,ost_anim(a0)	; use "leaping" animation
		move.b	#id_EndSTH,(v_ost_end_emeralds).w	; load "SONIC THE HEDGEHOG" object
		bra.s	ESon_Animate

	@wait:
		rts	
