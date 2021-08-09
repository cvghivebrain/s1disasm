; ---------------------------------------------------------------------------
; Object 5C - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Pyl_Index(pc,d0.w),d1
		jmp	Pyl_Index(pc,d1.w)
; ===========================================================================
Pyl_Index:	index *,,2
		ptr Pyl_Main
		ptr Pyl_Display
; ===========================================================================

Pyl_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Pylon,ost_mappings(a0)
		move.w	#tile_Nem_Pylon+tile_hi,ost_tile(a0)
		move.b	#$10,ost_actwidth(a0)

Pyl_Display:	; Routine 2
		move.l	(v_screenposx).w,d1
		add.l	d1,d1
		swap	d1
		neg.w	d1
		move.w	d1,ost_x_pos(a0)
		move.l	(v_screenposy).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,ost_y_screen(a0)
		bra.w	DisplaySprite
