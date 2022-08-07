; ---------------------------------------------------------------------------
; Object 5D - fans (SLZ)

; spawned by:
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtypes 0/1/2
; ---------------------------------------------------------------------------

Fan:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Fan_Index(pc,d0.w),d1
		jmp	Fan_Index(pc,d1.w)
; ===========================================================================
Fan_Index:	index *,,2
		ptr Fan_Main
		ptr Fan_Delay

		rsobj Fan,$30
ost_fan_wait_time:	rs.w 1					; $30 ; time between switching on/off
ost_fan_flag:		rs.b 1					; $32 ; 0 = on; 1 = off
		rsobjend
; ===========================================================================

Fan_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Fan_Delay next
		move.l	#Map_Fan,ost_mappings(a0)
		move.w	#tile_Nem_Fan+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#4,ost_priority(a0)

Fan_Delay:	; Routine 2
		btst	#1,ost_subtype(a0)			; is object type 2 or 3? (always on)
		bne.s	.skip_timer				; if yes, branch
		subq.w	#1,ost_fan_wait_time(a0)		; decrement timer
		bpl.s	.skip_timer				; if time remains, branch
		move.w	#120,ost_fan_wait_time(a0)		; set timer to 2 seconds
		bchg	#0,ost_fan_flag(a0)			; switch fan on/off
		beq.s	.skip_timer				; if fan is on, branch
		move.w	#180,ost_fan_wait_time(a0)		; set timer to 3 seconds

.skip_timer:
		tst.b	ost_fan_flag(a0)			; is fan switched on?
		bne.w	.chkdel					; if not, branch
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0 = distance between fan and Sonic (-ve if Sonic is to the left)
		btst	#status_xflip_bit,ost_status(a0)	; is fan facing right?
		bne.s	.facing_right				; if yes, branch
		neg.w	d0					; +ve: face left & Sonic left; face right & Sonic right
								; -ve: face left & Sonic right; face right & Sonic left
	.facing_right:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0					; is Sonic within 160px in front or 80px behind fan?
		bcc.s	.animate				; if not, branch
		move.w	ost_y_pos(a1),d1
		addi.w	#$60,d1
		sub.w	ost_y_pos(a0),d1
		bcs.s	.animate				; branch if Sonic is > 96px below fan
		cmpi.w	#$70,d1
		bcc.s	.animate				; branch if Sonic is > 112px above fan
		subi.w	#$50,d0
		bcc.s	.over_80px				; branch if Sonic is not within 80px in front/behind fan
		not.w	d0
		add.w	d0,d0

	.over_80px:
		addi.w	#$60,d0
		btst	#status_xflip_bit,ost_status(a0)	; is fan facing right?
		bne.s	.right					; if yes, branch
		neg.w	d0

	.right:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,ost_subtype(a0)			; is type 0/2? (blows left)
		beq.s	.blows_left				; if yes, branch
		neg.w	d0

	.blows_left:
		add.w	d0,ost_x_pos(a1)			; push Sonic left or right

.animate:
		subq.b	#1,ost_anim_time(a0)			; decrement animation timer
		bpl.s	.chkdel					; branch if time remains
		move.b	#0,ost_anim_time(a0)			; reset timer
		addq.b	#1,ost_anim_frame(a0)			; next frame
		cmpi.b	#3,ost_anim_frame(a0)
		bcs.s	.is_valid				; branch if frame is valid
		move.b	#0,ost_anim_frame(a0)			; reset frame counter

	.is_valid:
		moveq	#0,d0
		btst	#0,ost_subtype(a0)			; is type 0/2? (blows left)
		beq.s	.noflip					; if yes, branch
		moveq	#id_frame_fan_2,d0			; start at frame 2 for opposite spin

	.noflip:
		add.b	ost_anim_frame(a0),d0			; add to frame counter
		move.b	d0,ost_frame(a0)			; update frame

.chkdel:
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
