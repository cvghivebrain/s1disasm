; ---------------------------------------------------------------------------
; Object 38 - shield and invincibility stars
; ---------------------------------------------------------------------------

ShieldItem:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Shi_Index(pc,d0.w),d1
		jmp	Shi_Index(pc,d1.w)
; ===========================================================================
Shi_Index:	index *,,2
		ptr Shi_Main
		ptr Shi_Shield
		ptr Shi_Stars

ost_invincibility_last_pos:	equ $30	; previous position in tracking index, for invincibility trail
; ===========================================================================

Shi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Shield,ost_mappings(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		tst.b	ost_anim(a0)	; is object a shield?
		bne.s	@stars		; if not, branch
		move.w	#tile_Nem_Shield,ost_tile(a0) ; shield specific code
		rts	
; ===========================================================================

@stars:
		addq.b	#2,ost_routine(a0) ; goto Shi_Stars next
		move.w	#tile_Nem_Stars,ost_tile(a0)
		rts	
; ===========================================================================

Shi_Shield:	; Routine 2
		tst.b	(v_invincibility).w	; does Sonic have invincibility?
		bne.s	@remove		; if yes, branch
		tst.b	(v_shield).w	; does Sonic have shield?
		beq.s	@delete		; if not, branch
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a0)
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a0)
		move.b	(v_ost_player+ost_status).w,ost_status(a0)
		lea	(Ani_Shield).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l

	@remove:
		rts	

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Shi_Stars:	; Routine 4
		tst.b	(v_invincibility).w	; does Sonic have invincibility?
		beq.s	Shi_Start_Delete ; if not, branch
		move.w	(v_sonic_pos_tracker_num).w,d0 ; get index value for tracking data
		move.b	ost_anim(a0),d1
		subq.b	#1,d1
		bra.s	@trail
; ===========================================================================
		lsl.b	#4,d1
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	ost_invincibility_last_pos(a0),d1
		sub.b	d1,d0
		addq.b	#4,d1
		andi.b	#$F,d1
		move.b	d1,ost_invincibility_last_pos(a0)
		bra.s	@b
; ===========================================================================

@trail:
		lsl.b	#3,d1		; multiply animation number by 8
		move.b	d1,d2
		add.b	d1,d1
		add.b	d2,d1		; multiply by 3
		addq.b	#4,d1		; add 4
		sub.b	d1,d0		; subtract from tracking index
		move.b	ost_invincibility_last_pos(a0),d1 ; retrieve earlier value
		sub.b	d1,d0		; use earlier tracking data to create trail
		addq.b	#4,d1
		cmpi.b	#$18,d1
		bcs.s	@a
		moveq	#0,d1

	@a:
		move.b	d1,ost_invincibility_last_pos(a0)

	@b:
		lea	(v_sonic_pos_tracker).w,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,ost_x_pos(a0)
		move.w	(a1)+,ost_y_pos(a0)
		move.b	(v_ost_player+ost_status).w,ost_status(a0)
		lea	(Ani_Shield).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

Shi_Start_Delete:	
		jmp	(DeleteObject).l
