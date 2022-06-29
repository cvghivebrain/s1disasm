; ---------------------------------------------------------------------------
; Object 38 - shield and invincibility stars

; spawned by:
;	PowerUp - animations 0-4
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

		rsobj ShieldItem,$30
ost_invincibility_last_pos:	rs.b 1				; $30 ; previous position in tracking index, for invincibility trail
		rsobjend
; ===========================================================================

Shi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Shi_Shield next
		move.l	#Map_Shield,ost_mappings(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$10,ost_displaywidth(a0)
		tst.b	ost_anim(a0)				; is object a shield?
		bne.s	@stars					; if not, branch
		move.w	#tile_Nem_Shield,ost_tile(a0)		; shield specific code
		rts	
; ===========================================================================

@stars:
		addq.b	#2,ost_routine(a0)			; goto Shi_Stars next
		move.w	#tile_Nem_Stars,ost_tile(a0)
		rts	
; ===========================================================================

Shi_Shield:	; Routine 2
		tst.b	(v_invincibility).w			; does Sonic have invincibility?
		bne.s	@hide					; if yes, branch
		tst.b	(v_shield).w				; does Sonic have shield?
		beq.s	@delete					; if not, branch

		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a0) ; match Sonic's position & orientation
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a0)
		move.b	(v_ost_player+ost_status).w,ost_status(a0)
		lea	(Ani_Shield).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l

	@hide:
		rts	

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

Shi_Stars:	; Routine 4
		tst.b	(v_invincibility).w			; does Sonic have invincibility?
		beq.s	@delete					; if not, branch
		move.w	(v_sonic_pos_tracker_num).w,d0		; get current index value for position tracking data
		move.b	ost_anim(a0),d1				; get animation id (1 to 4)
		subq.b	#1,d1					; subtract 1 (0 to 3)
		bra.s	@trail
; ===========================================================================
; unused - similar to below, but with star objects closer together
		lsl.b	#4,d1					; multiply animation number by 16
		addq.b	#4,d1					; add 4
		sub.b	d1,d0					; subtract from tracker
		move.b	ost_invincibility_last_pos(a0),d1	; retrieve previous index
		sub.b	d1,d0					; subtract from tracker
		addq.b	#4,d1					; increment tracking index
		andi.b	#$F,d1					; cap at 15
		move.b	d1,ost_invincibility_last_pos(a0)	; set new tracking index value
		bra.s	@set_pos
; ===========================================================================

@trail:
		lsl.b	#3,d1
		move.b	d1,d2
		add.b	d1,d1
		add.b	d2,d1					; multiply animation number by 24
		addq.b	#4,d1					; add 4
		sub.b	d1,d0					; subtract from tracker
		move.b	ost_invincibility_last_pos(a0),d1	; retrieve previous index
		sub.b	d1,d0					; subtract from tracker
		addq.b	#4,d1					; increment tracking index
		cmpi.b	#$18,d1
		bcs.s	@is_valid				; branch if valid (0-23)
		moveq	#0,d1					; reset to 0

	@is_valid:
		move.b	d1,ost_invincibility_last_pos(a0)	; set new tracking index value

	@set_pos:
		lea	(v_sonic_pos_tracker).w,a1		; position data
		lea	(a1,d0.w),a1				; jump to relevant position data
		move.w	(a1)+,ost_x_pos(a0)			; update position of stars
		move.w	(a1)+,ost_y_pos(a0)
		move.b	(v_ost_player+ost_status).w,ost_status(a0)
		lea	(Ani_Shield).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l
; ===========================================================================

@delete:	
		jmp	(DeleteObject).l

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_ShieldItem_animation:	macro

Ani_Shield:	index *
		ptr ani_shield_0
		ptr ani_stars1
		ptr ani_stars2
		ptr ani_stars3
		ptr ani_stars4
		
ani_shield_0:	dc.b 1
		dc.b id_frame_shield_1
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_2
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_3
		dc.b id_frame_shield_blank
		dc.b afEnd

ani_stars1:	dc.b 5
		dc.b id_frame_stars1
		dc.b id_frame_stars2
		dc.b id_frame_stars3
		dc.b id_frame_stars4
		dc.b afEnd

ani_stars2:	dc.b 0
		dc.b id_frame_stars1
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_stars1
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b afEnd

ani_stars3:	dc.b 0
		dc.b id_frame_stars1
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b afEnd

ani_stars4:	dc.b 0
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars1
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars2
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars3
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b id_frame_stars4
		dc.b id_frame_shield_blank
		dc.b id_frame_shield_blank
		dc.b afEnd
		even

		endm
