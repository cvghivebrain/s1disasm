; ---------------------------------------------------------------------------
; Object 4C - lava geyser / lavafall producer (MZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GMake_Index(pc,d0.w),d1
		jsr	GMake_Index(pc,d1.w)
		bra.w	Geyser_ChkDel
; ===========================================================================
GMake_Index:	index *,,2
		ptr GMake_Main
		ptr GMake_Wait
		ptr GMake_ChkType
		ptr GMake_MakeLava
		ptr GMake_Display
		ptr GMake_Delete

gmake_time:	equ $34		; time delay (2 bytes)
gmake_timer:	equ $32		; current time remaining (2 bytes)
ost_gmake_parent:	equ $3C		; address of parent object
; ===========================================================================

GMake_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Geyser,ost_mappings(a0)
		move.w	#tile_Nem_Lava+tile_pal4+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$38,ost_actwidth(a0)
		move.w	#120,gmake_time(a0) ; set time delay to 2 seconds

GMake_Wait:	; Routine 2
		subq.w	#1,gmake_timer(a0) ; decrement timer
		bpl.s	@cancel		; if time remains, branch

		move.w	gmake_time(a0),gmake_timer(a0) ; reset timer
		move.w	(v_player+ost_y_pos).w,d0
		move.w	ost_y_pos(a0),d1
		cmp.w	d1,d0
		bcc.s	@cancel
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	@cancel
		addq.b	#2,ost_routine(a0) ; if Sonic is within range, goto GMake_ChkType

	@cancel:
		rts	
; ===========================================================================

GMake_MakeLava:	; Routine 6
		addq.b	#2,ost_routine(a0)
		bsr.w	FindNextFreeObj
		bne.s	@fail
		move.b	#id_LavaGeyser,0(a1) ; load lavafall object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.l	a0,ost_gmake_parent(a1)

	@fail:
		move.b	#1,ost_anim(a0)
		tst.b	ost_subtype(a0)	; is object type 0 (geyser) ?
		beq.s	@isgeyser	; if yes, branch
		move.b	#4,ost_anim(a0)
		bra.s	GMake_Display
; ===========================================================================

	@isgeyser:
		movea.l	ost_gmake_parent(a0),a1 ; get parent object address
		bset	#1,ost_status(a1)
		move.w	#-$580,ost_y_vel(a1)
		bra.s	GMake_Display
; ===========================================================================

GMake_ChkType:	; Routine 4
		tst.b	ost_subtype(a0)	; is object type 00 (geyser) ?
		beq.s	GMake_Display	; if yes, branch
		addq.b	#2,ost_routine(a0)
		rts	
; ===========================================================================

GMake_Display:	; Routine 8
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		rts	
; ===========================================================================

GMake_Delete:	; Routine $A
		move.b	#0,ost_anim(a0)
		move.b	#2,ost_routine(a0)
		tst.b	ost_subtype(a0)
		beq.w	DeleteObject
		rts	
