; ---------------------------------------------------------------------------
; Object 5C - metal pylons in foreground (SLZ)

; spawned by:
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3
; ---------------------------------------------------------------------------

Pylon:
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
		addq.b	#2,ost_routine(a0)			; goto Pyl_Display next
		move.l	#Map_Pylon,ost_mappings(a0)
		move.w	#tile_Nem_Pylon+tile_hi,ost_tile(a0)
		move.b	#$10,ost_displaywidth(a0)

Pyl_Display:	; Routine 2
		move.l	(v_camera_x_pos).w,d1			; get camera x pos (in high word)
		add.l	d1,d1					; double it
		swap	d1					; move into low word
		neg.w	d1					; invert
		move.w	d1,ost_x_pos(a0)			; update x position of pylon
		move.l	(v_camera_y_pos).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,ost_y_screen(a0)
		bra.w	DisplaySprite
