; ---------------------------------------------------------------------------
; Object 5F - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------

Bomb:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bom_Index(pc,d0.w),d1
		jmp	Bom_Index(pc,d1.w)
; ===========================================================================
Bom_Index:	index *,,2
		ptr Bom_Main
		ptr Bom_Action
		ptr Bom_Display
		ptr Bom_End

ost_bomb_fuse_time:	equ $30	; time left on fuse - also used for change direction timer (2 bytes)
ost_bomb_y_start:	equ $34	; original y-axis position (2 bytes)
ost_bomb_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

Bom_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bomb,ost_mappings(a0)
		move.w	#tile_Nem_Bomb,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$C,ost_actwidth(a0)
		move.b	ost_subtype(a0),d0
		beq.s	loc_11A3C
		move.b	d0,ost_routine(a0)
		rts	
; ===========================================================================

loc_11A3C:
		move.b	#$9A,ost_col_type(a0)
		bchg	#status_xflip_bit,ost_status(a0)

Bom_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Bomb).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr @walk
		ptr @wait
		ptr @explode
; ===========================================================================

@walk:
		bsr.w	@chksonic
		subq.w	#1,ost_bomb_fuse_time(a0) ; subtract 1 from time delay
		bpl.s	@noflip		; if time remains, branch
		addq.b	#2,ost_routine2(a0) ; goto @wait
		move.w	#1535,ost_bomb_fuse_time(a0) ; set time delay to 25.5 seconds
		move.w	#$10,ost_x_vel(a0)
		move.b	#id_ani_bomb_walk,ost_anim(a0) ; use walking animation
		bchg	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	ost_x_vel(a0)	; change direction

	@noflip:
		rts	
; ===========================================================================

@wait:
		bsr.w	@chksonic
		subq.w	#1,ost_bomb_fuse_time(a0) ; subtract 1 from time delay
		bmi.s	@stopwalking	; if time expires, branch
		bsr.w	SpeedToPos
		rts	
; ===========================================================================

	@stopwalking:
		subq.b	#2,ost_routine2(a0)
		move.w	#179,ost_bomb_fuse_time(a0) ; set time delay to 3 seconds
		clr.w	ost_x_vel(a0)	; stop walking
		move.b	#id_ani_bomb_stand,ost_anim(a0)	; use waiting animation
		rts	
; ===========================================================================

@explode:
		subq.w	#1,ost_bomb_fuse_time(a0) ; subtract 1 from time delay
		bpl.s	@noexplode	; if time remains, branch
		move.b	#id_ExplosionBomb,0(a0) ; change bomb into an explosion
		move.b	#0,ost_routine(a0)

	@noexplode:
		rts	
; ===========================================================================

@chksonic:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@isleft
		neg.w	d0

	@isleft:
		cmpi.w	#$60,d0		; is Sonic within $60 pixels?
		bcc.s	@outofrange	; if not, branch
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0
		bcc.s	@isabove
		neg.w	d0

	@isabove:
		cmpi.w	#$60,d0
		bcc.s	@outofrange
		tst.w	(v_debuguse).w
		bne.s	@outofrange

		move.b	#4,ost_routine2(a0)
		move.w	#143,ost_bomb_fuse_time(a0) ; set fuse time
		clr.w	ost_x_vel(a0)
		move.b	#id_ani_bomb_active,ost_anim(a0) ; use activated animation
		bsr.w	FindNextFreeObj
		bne.s	@outofrange
		move.b	#id_Bomb,0(a1)	; load fuse object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_y_pos(a0),ost_bomb_y_start(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	#id_Bom_Display,ost_subtype(a1)
		move.b	#id_ani_bomb_fuse,ost_anim(a1)
		move.w	#$10,ost_y_vel(a1)
		btst	#status_yflip_bit,ost_status(a0) ; is bomb upside-down?
		beq.s	@normal		; if not, branch
		neg.w	ost_y_vel(a1)	; reverse direction for fuse

	@normal:
		move.w	#143,ost_bomb_fuse_time(a1) ; set fuse time
		move.l	a0,ost_bomb_parent(a1)

@outofrange:
		rts	
; ===========================================================================

Bom_Display:	; Routine 4
		bsr.s	loc_11B70
		lea	(Ani_Bomb).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================

loc_11B70:
		subq.w	#1,ost_bomb_fuse_time(a0)
		bmi.s	loc_11B7C
		bsr.w	SpeedToPos
		rts	
; ===========================================================================

loc_11B7C:
		clr.w	ost_bomb_fuse_time(a0)
		clr.b	ost_routine(a0)
		move.w	ost_bomb_y_start(a0),ost_y_pos(a0)
		moveq	#3,d1
		movea.l	a0,a1
		lea	(Bom_ShrSpeed).l,a2 ; load shrapnel speed data
		bra.s	@makeshrapnel
; ===========================================================================

	@loop:
		bsr.w	FindNextFreeObj
		bne.s	@fail

@makeshrapnel:
		move.b	#id_Bomb,0(a1)	; load shrapnel	object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_Bom_End,ost_subtype(a1)
		move.b	#id_ani_bomb_shrapnel,ost_anim(a1)
		move.w	(a2)+,ost_x_vel(a1)
		move.w	(a2)+,ost_y_vel(a1)
		move.b	#$98,ost_col_type(a1)
		bset	#render_onscreen_bit,ost_render(a1)

	@fail:
		dbf	d1,@loop	; repeat 3 more	times

		move.b	#id_Bom_End,ost_routine(a0)

Bom_End:	; Routine 6
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)
		lea	(Ani_Bomb).l,a1
		bsr.w	AnimateSprite
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Bom_ShrSpeed:	dc.w -$200, -$300, -$100, -$200, $200, -$300, $100, -$200
