; ---------------------------------------------------------------------------
; Object 42 - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------

Newtron:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Newt_Index(pc,d0.w),d1
		jmp	Newt_Index(pc,d1.w)
; ===========================================================================
Newt_Index:	index *,,2
		ptr Newt_Main
		ptr Newt_Action
		ptr Newt_Delete

ost_newtron_fire_flag:	equ $32					; set to 1 after newtron fires a missile
; ===========================================================================

Newt_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Newt,ost_mappings(a0)
		move.w	#tile_Nem_Newtron,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#8,ost_width(a0)

Newt_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Newt).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr @chkdistance
		ptr @type00
		ptr @matchfloor
		ptr @speed
		ptr @type01
; ===========================================================================

@chkdistance:
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@sonicisright
		neg.w	d0
		bclr	#status_xflip_bit,ost_status(a0)

	@sonicisright:
		cmpi.w	#$80,d0					; is Sonic within $80 pixels of	the newtron?
		bcc.s	@outofrange				; if not, branch
		addq.b	#2,ost_routine2(a0)			; goto @type00 next
		move.b	#id_ani_newt_drop,ost_anim(a0)
		tst.b	ost_subtype(a0)				; check	object type
		beq.s	@istype00				; if type is 00, branch

		move.w	#tile_Nem_Newtron+tile_pal2,ost_tile(a0)
		move.b	#8,ost_routine2(a0)			; goto @type01 next
		move.b	#id_ani_newt_firing,ost_anim(a0)	; use different animation

	@outofrange:
	@istype00:
		rts	
; ===========================================================================

@type00:
		cmpi.b	#id_frame_newt_drop2,ost_frame(a0)	; has "appearing" animation finished?
		bcc.s	@fall					; is yes, branch
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@sonicisright2
		bclr	#status_xflip_bit,ost_status(a0)

	@sonicisright2:
		rts	
; ===========================================================================

	@fall:
		cmpi.b	#id_frame_newt_norm,ost_frame(a0)
		bne.s	@loc_DE42
		move.b	#id_col_20x16,ost_col_type(a0)

	@loc_DE42:
		bsr.w	ObjectFall
		bsr.w	FindFloorObj
		tst.w	d1					; has newtron hit the floor?
		bpl.s	@keepfalling				; if not, branch

		add.w	d1,ost_y_pos(a0)
		move.w	#0,ost_y_vel(a0)			; stop newtron falling
		addq.b	#2,ost_routine2(a0)
		move.b	#id_ani_newt_fly1,ost_anim(a0)
		btst	#tile_pal12_bit,ost_tile(a0)
		beq.s	@pppppppp
		addq.b	#1,ost_anim(a0)

	@pppppppp:
		move.b	#id_col_20x8,ost_col_type(a0)
		move.w	#$200,ost_x_vel(a0)			; move newtron horizontally
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	@keepfalling
		neg.w	ost_x_vel(a0)

	@keepfalling:
		rts	
; ===========================================================================

@matchfloor:
		bsr.w	SpeedToPos
		bsr.w	FindFloorObj
		cmpi.w	#-8,d1
		blt.s	@nextroutine
		cmpi.w	#$C,d1
		bge.s	@nextroutine
		add.w	d1,ost_y_pos(a0)			; match newtron's position with floor
		rts	
; ===========================================================================

	@nextroutine:
		addq.b	#2,ost_routine2(a0)			; goto @speed next
		rts	
; ===========================================================================

@speed:
		bsr.w	SpeedToPos
		rts	
; ===========================================================================

@type01:
		cmpi.b	#id_frame_newt_norm,ost_frame(a0)
		bne.s	@firemissile
		move.b	#id_col_20x16,ost_col_type(a0)

	@firemissile:
		cmpi.b	#id_frame_newt_firing,ost_frame(a0)
		bne.s	@fail
		tst.b	ost_newtron_fire_flag(a0)
		bne.s	@fail
		move.b	#1,ost_newtron_fire_flag(a0)
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Missile,0(a1)			; load missile object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		subq.w	#8,ost_y_pos(a1)
		move.w	#$200,ost_x_vel(a1)
		move.w	#$14,d0
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	@noflip
		neg.w	d0
		neg.w	ost_x_vel(a1)

	@noflip:
		add.w	d0,ost_x_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	#1,ost_subtype(a1)

	@fail:
		rts	
; ===========================================================================

Newt_Delete:	; Routine 4
		bra.w	DeleteObject
