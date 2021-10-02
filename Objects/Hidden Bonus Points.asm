; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level
; ---------------------------------------------------------------------------

HiddenBonus:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bonus_Index(pc,d0.w),d1
		jmp	Bonus_Index(pc,d1.w)
; ===========================================================================
Bonus_Index:	index *,,2
		ptr Bonus_Main
		ptr Bonus_Display

ost_bonus_wait_time:	equ $30	; length of time to display bonus sprites (2 bytes)
; ===========================================================================

Bonus_Main:	; Routine 0
		moveq	#$10,d2
		move.w	d2,d3
		add.w	d3,d3
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d2,d0
		cmp.w	d3,d0
		bcc.s	@chkdel
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1
		bcc.s	@chkdel
		tst.w	(v_debug_active).w
		bne.s	@chkdel
		tst.b	(f_bigring).w
		bne.s	@chkdel
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bonus,ost_mappings(a0)
		move.w	#tile_Nem_Bonus+tile_hi,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#0,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	ost_subtype(a0),ost_frame(a0)
		move.w	#119,ost_bonus_wait_time(a0) ; set display time to 2 seconds
		sfx	sfx_Bonus,0,0,0	; play bonus sound
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	@points(pc,d0.w),d0 ; load bonus points array
		jsr	(AddPoints).l

	@chkdel:
		out_of_range.s	@delete
		rts	

	@delete:
		jmp	(DeleteObject).l

; ===========================================================================
@points:	dc.w 0			; Bonus	points array
		dc.w 1000
		dc.w 100
		dc.w 1
; ===========================================================================

Bonus_Display:	; Routine 2
		subq.w	#1,ost_bonus_wait_time(a0) ; decrement display time
		bmi.s	Bonus_Display_Delete ; if time is zero, branch
		out_of_range.s	Bonus_Display_Delete
		jmp	(DisplaySprite).l

Bonus_Display_Delete:	
		jmp	(DeleteObject).l
