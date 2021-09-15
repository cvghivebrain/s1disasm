; ---------------------------------------------------------------------------
; Object 5D - fans (SLZ)
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

ost_fan_wait_time:	equ $30	; time between switching on/off (2 bytes)
ost_fan_flag:		equ $32	; 0 = on; 1 = off
; ===========================================================================

Fan_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Fan,ost_mappings(a0)
		move.w	#tile_Nem_Fan+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)

Fan_Delay:	; Routine 2
		btst	#1,ost_subtype(a0) ; is object type 02/03 (always on)?
		bne.s	@blow		; if yes, branch
		subq.w	#1,ost_fan_wait_time(a0) ; subtract 1 from time delay
		bpl.s	@blow		; if time remains, branch
		move.w	#120,ost_fan_wait_time(a0) ; set delay to 2 seconds
		bchg	#0,ost_fan_flag(a0) ; switch fan on/off
		beq.s	@blow		; if fan is on, branch
		move.w	#180,ost_fan_wait_time(a0) ; set delay to 3 seconds

@blow:
		tst.b	ost_fan_flag(a0) ; is fan switched on?
		bne.w	@chkdel		; if not, branch
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		btst	#status_xflip_bit,ost_status(a0) ; is fan facing right?
		bne.s	@chksonic	; if yes, branch
		neg.w	d0

@chksonic:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0		; is Sonic more	than $A0 pixels	from the fan?
		bcc.s	@animate	; if yes, branch
		move.w	ost_y_pos(a1),d1
		addi.w	#$60,d1
		sub.w	ost_y_pos(a0),d1
		bcs.s	@animate	; branch if Sonic is too low
		cmpi.w	#$70,d1
		bcc.s	@animate	; branch if Sonic is too high
		subi.w	#$50,d0		; is Sonic more than $50 pixels from the fan?
		bcc.s	@faraway	; if yes, branch
		not.w	d0
		add.w	d0,d0

	@faraway:
		addi.w	#$60,d0
		btst	#status_xflip_bit,ost_status(a0) ; is fan facing right?
		bne.s	@right		; if yes, branch
		neg.w	d0

	@right:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,ost_subtype(a0)
		beq.s	@movesonic
		neg.w	d0

	@movesonic:
		add.w	d0,ost_x_pos(a1) ; push Sonic away from the fan

@animate:
		subq.b	#1,ost_anim_time(a0)
		bpl.s	@chkdel
		move.b	#0,ost_anim_time(a0)
		addq.b	#1,ost_anim_frame(a0)
		cmpi.b	#3,ost_anim_frame(a0)
		bcs.s	@noreset
		move.b	#0,ost_anim_frame(a0) ; reset after 4 frames

	@noreset:
		moveq	#0,d0
		btst	#0,ost_subtype(a0)
		beq.s	@noflip
		moveq	#2,d0

	@noflip:
		add.b	ost_anim_frame(a0),d0
		move.b	d0,ost_frame(a0)

@chkdel:
		bsr.w	DisplaySprite
		out_of_range	DeleteObject
		rts	
