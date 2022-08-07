; ---------------------------------------------------------------------------
; Object 4C - lava geyser / lavafall producer (MZ)

; spawned by:
;	ObjPos_MZ2, ObjPos_MZ3 - subtype 1
;	PushBlock - subtype 0
; ---------------------------------------------------------------------------

GeyserMaker:
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

		rsobj GeyserMaker,$32
ost_gmake_wait_time:	rs.w 1					; $32 ; current time remaining
ost_gmake_wait_total:	rs.w 1					; $34 ; time delay
		rsset $3C
ost_gmake_parent:	rs.l 1					; $3C ; address of OST of parent object
		rsobjend
; ===========================================================================

GMake_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto GMake_Wait next
		move.l	#Map_Geyser,ost_mappings(a0)
		move.w	#tile_Nem_Lava+tile_pal4+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$38,ost_displaywidth(a0)
		move.w	#120,ost_gmake_wait_total(a0)		; set time delay to 2 seconds

GMake_Wait:	; Routine 2
		subq.w	#1,ost_gmake_wait_time(a0)		; decrement timer
		bpl.s	.cancel					; if time remains, branch

		move.w	ost_gmake_wait_total(a0),ost_gmake_wait_time(a0) ; reset timer
		move.w	(v_ost_player+ost_y_pos).w,d0
		move.w	ost_y_pos(a0),d1
		cmp.w	d1,d0
		bcc.s	.cancel					; branch if Sonic is to the right
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	.cancel					; branch if Sonic is more than 368px to the left
		addq.b	#2,ost_routine(a0)			; if Sonic is within range, goto GMake_ChkType next

	.cancel:
		rts	
; ===========================================================================

GMake_MakeLava:	; Routine 6
		addq.b	#2,ost_routine(a0)			; goto GMake_Display next
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_LavaGeyser,ost_id(a1)		; load lavafall object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)
		move.l	a0,ost_geyser_parent(a1)

	.fail:
		move.b	#id_ani_geyser_bubble2,ost_anim(a0)
		tst.b	ost_subtype(a0)				; is object type 0 (geyser) ?
		beq.s	.isgeyser				; if yes, branch
		move.b	#id_ani_geyser_blank,ost_anim(a0)
		bra.s	GMake_Display
; ===========================================================================

	.isgeyser:
		movea.l	ost_gmake_parent(a0),a1			; copy address of parent OST (from PushBlock)
		bset	#status_yflip_bit,ost_status(a1)
		move.w	#-$580,ost_y_vel(a1)
		bra.s	GMake_Display
; ===========================================================================

GMake_ChkType:	; Routine 4
		tst.b	ost_subtype(a0)				; is object type 0 (geyser) ?
		beq.s	GMake_Display				; if yes, branch
		addq.b	#2,ost_routine(a0)			; goto GMake_MakeLava next
		rts	
; ===========================================================================

GMake_Display:	; Routine 8
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite				; animate and goto next routine if specified
		bsr.w	DisplaySprite
		rts	
; ===========================================================================

GMake_Delete:	; Routine $A
		move.b	#id_ani_geyser_bubble1,ost_anim(a0)
		move.b	#id_GMake_Wait,ost_routine(a0)
		tst.b	ost_subtype(a0)
		beq.w	DeleteObject
		rts	
