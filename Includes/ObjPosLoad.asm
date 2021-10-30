; ---------------------------------------------------------------------------
; Subroutine to	load a level's objects
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)
; End of function ObjPosLoad

; ===========================================================================
OPL_Index:	index *
		ptr OPL_Main
		ptr OPL_Next
; ===========================================================================

OPL_Main:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0	; get zone/act numbers
		lsl.b	#6,d0
		lsr.w	#4,d0		; combine zone/act into single number, times 4
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1		; copy index pointer to a1
		adda.w	(a0,d0.w),a0	; jump to objpos data
		move.l	a0,(v_opl_ptr_right).w ; copy objpos data address
		move.l	a0,(v_opl_ptr_left).w
		adda.w	2(a1,d0.w),a1	; jump to secondary objpos data (this is always blank)
		move.l	a1,(v_opl_ptr_alt_right).w ; copy objpos data address
		move.l	a1,(v_opl_ptr_alt_left).w
		lea	(v_respawn_list).w,a2
		move.w	#$101,(a2)+
		move.w	#$5E,d0

	@clear_respawn_list:
		clr.l	(a2)+
		dbf	d0,@clear_respawn_list ; clear object respawn list

		lea	(v_respawn_list).w,a2
		moveq	#0,d2
		move.w	(v_camera_x_pos).w,d6
		subi.w	#$80,d6		; d6 = screen x position minus $80
		bhs.s	@use_screen_x
		moveq	#0,d6		; assume 0 if screen is within $80 pixels of left boundary

	@use_screen_x:
		andi.w	#$FF80,d6	; round down to nearest $80
		movea.l	(v_opl_ptr_right).w,a0 ; get objpos data pointer

OPL_ChkLoop:
		cmp.w	(a0),d6
		bls.s	loc_D956	; branch if objpos is right of the screen
		tst.b	4(a0)		; does object have remember respawn flag?
		bpl.s	@no_respawn	; if not, branch
		move.b	(a2),d2		; d2 = respawn state
		addq.b	#1,(a2)

	@no_respawn:
		addq.w	#6,a0		; goto next object in objpos list
		bra.s	OPL_ChkLoop	; loop
; ===========================================================================

loc_D956:
		move.l	a0,(v_opl_ptr_right).w ; last objpos read so far
		movea.l	(v_opl_ptr_left).w,a0 ; get first objpos again
		subi.w	#$80,d6		; extend left checking boundary by $80
		blo.s	loc_D976	; branch if d6 is within $80 or outside left level boundary

OPL_ChkLoop2:
		cmp.w	(a0),d6
		bls.s	loc_D976
		tst.b	4(a0)
		bpl.s	@no_respawn
		addq.b	#1,1(a2)

	@no_respawn:
		addq.w	#6,a0
		bra.s	OPL_ChkLoop2
; ===========================================================================

loc_D976:
		move.l	a0,(v_opl_ptr_left).w
		move.w	#-1,(v_opl_screen_x_pos).w ; initial screen position

OPL_Next:
		lea	(v_respawn_list).w,a2
		moveq	#0,d2
		move.w	(v_camera_x_pos).w,d6 ; get screen position
		andi.w	#$FF80,d6	; round down to nearest $80
		cmp.w	(v_opl_screen_x_pos).w,d6 ; compare to previous screen position
		beq.w	OPL_NoMove	; branch if screen hasn't moved
		bge.s	OPL_MovedRight	; branch if screen is right of previous position
		
		move.w	d6,(v_opl_screen_x_pos).w ; update screen position
		movea.l	(v_opl_ptr_left).w,a0
		subi.w	#$80,d6
		blo.s	loc_D9D2

OPL_ChkLeftLoop:
		cmp.w	-6(a0),d6
		bge.s	loc_D9D2
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	@no_respawn
		subq.b	#1,1(a2)
		move.b	1(a2),d2

	@no_respawn:
		bsr.w	OPL_ChkRespawn
		bne.s	loc_D9C6
		subq.w	#6,a0
		bra.s	OPL_ChkLeftLoop
; ===========================================================================

loc_D9C6:
		tst.b	4(a0)
		bpl.s	@no_respawn
		addq.b	#1,1(a2)

	@no_respawn:
		addq.w	#6,a0

loc_D9D2:
		move.l	a0,(v_opl_ptr_left).w
		movea.l	(v_opl_ptr_right).w,a0
		addi.w	#$300,d6

loc_D9DE:
		cmp.w	-6(a0),d6
		bgt.s	loc_D9F0
		tst.b	-2(a0)
		bpl.s	loc_D9EC
		subq.b	#1,(a2)

loc_D9EC:
		subq.w	#6,a0
		bra.s	loc_D9DE
; ===========================================================================

loc_D9F0:
		move.l	a0,(v_opl_ptr_right).w
		rts	
; ===========================================================================

OPL_MovedRight:
		move.w	d6,(v_opl_screen_x_pos).w
		movea.l	(v_opl_ptr_right).w,a0
		addi.w	#$280,d6

loc_DA02:
		cmp.w	(a0),d6
		bls.s	loc_DA16
		tst.b	4(a0)
		bpl.s	loc_DA10
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DA10:
		bsr.w	OPL_ChkRespawn
		beq.s	loc_DA02

loc_DA16:
		move.l	a0,(v_opl_ptr_right).w
		movea.l	(v_opl_ptr_left).w,a0
		subi.w	#$300,d6
		blo.s	loc_DA36

loc_DA24:
		cmp.w	(a0),d6
		bls.s	loc_DA36
		tst.b	4(a0)
		bpl.s	loc_DA32
		addq.b	#1,1(a2)

loc_DA32:
		addq.w	#6,a0
		bra.s	loc_DA24
; ===========================================================================

loc_DA36:
		move.l	a0,(v_opl_ptr_left).w

OPL_NoMove:
		rts	
; ===========================================================================

OPL_ChkRespawn:
		tst.b	4(a0)		; is remember respawn flag set?
		bpl.s	OPL_MakeItem	; if not, branch
		bset	#7,2(a2,d2.w)
		beq.s	OPL_MakeItem	; branch if object hasn't already been destroyed
		addq.w	#6,a0
		moveq	#0,d0
		rts	
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj
		bne.s	locret_DA8A
		move.w	(a0)+,ost_x_pos(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0	; ignore x/yflip bits
		move.w	d0,ost_y_pos(a1)
		rol.w	#2,d1
		andi.b	#render_xflip+render_yflip,d1 ; read only x/yflip bits
		move.b	d1,ost_render(a1)
		move.b	d1,ost_status(a1)
		move.b	(a0)+,d0	; get object id
		bpl.s	loc_DA80	; branch if remember respawn flag is not set
		andi.b	#$7F,d0		; ignore respawn bit
		move.b	d2,ost_respawn(a1) ; give object its place in the respawn table

loc_DA80:
		move.b	d0,0(a1)
		move.b	(a0)+,ost_subtype(a1)
		moveq	#0,d0

locret_DA8A:
		rts	
