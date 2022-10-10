; ---------------------------------------------------------------------------
; Object 7D - hidden points at the end of a level

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_MZ1, ObjPos_MZ2 - subtypes 1/2/3
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_LZ1, ObjPos_LZ2 - subtypes 1/2/3
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SBZ1 - subtypes 1/2/3
; ---------------------------------------------------------------------------

HiddenBonus:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bonus_Index(pc,d0.w),d1
		jmp	Bonus_Index(pc,d1.w)
; ===========================================================================
Bonus_Index:	index offset(*),,2
		ptr Bonus_Main
		ptr Bonus_Display

		rsobj HiddenBonus,$30
ost_bonus_wait_time:	rs.w 1					; $30 ; length of time to display bonus sprites
		rsobjend
; ===========================================================================

Bonus_Main:	; Routine 0
		moveq	#$10,d2					; radius
		move.w	d2,d3
		add.w	d3,d3
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0			; d0 = Sonic's distance from item (-ve if Sonic is left, +ve if right)
		add.w	d2,d0					; add radius
		cmp.w	d3,d0					; is Sonic within item's width?
		bcc.s	.chkdel					; if not, branch
		move.w	ost_y_pos(a1),d1
		sub.w	ost_y_pos(a0),d1
		add.w	d2,d1
		cmp.w	d3,d1					; is Sonic within item's height?
		bcc.s	.chkdel					; if not, branch

		tst.w	(v_debug_active).w			; is debug in use?
		bne.s	.chkdel					; if yes, branch
		tst.b	(f_giantring_collected).w		; has giant ring been collected?
		bne.s	.chkdel					; if yes, branch

		addq.b	#2,ost_routine(a0)			; goto Bonus_Display next
		move.l	#Map_Bonus,ost_mappings(a0)
		move.w	#tile_Nem_Bonus+tile_hi,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#0,ost_priority(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	ost_subtype(a0),ost_frame(a0)
		move.w	#119,ost_bonus_wait_time(a0)		; set display time to 2 seconds
		play.w	1, jsr, sfx_Bonus			; play bonus sound
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	Bonus_Points(pc,d0.w),d0		; load bonus points from array
		jsr	(AddPoints).l				; add points and update HUD

	.chkdel:
		out_of_range.s	.delete
		rts	

	.delete:
		jmp	(DeleteObject).l

; ===========================================================================
Bonus_Points:	; Bonus	points array
Bonus_Points_0:	dc.w 0						; subtype 0 - 0 points (unused)
Bonus_Points_1:	dc.w 1000					; subtype 1 - 10000 points
Bonus_Points_2:	dc.w 100					; subtype 2 - 1000 points
Bonus_Points_3:	dc.w 1						; subtype 3 - 10 points (should be 100)
; ===========================================================================

Bonus_Display:	; Routine 2
		subq.w	#1,ost_bonus_wait_time(a0)		; decrement display time
		bmi.s	.delete					; if time is zero, branch
		out_of_range.s	.delete
		jmp	(DisplaySprite).l

	.delete:	
		jmp	(DeleteObject).l
