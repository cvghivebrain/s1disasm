; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy	(MZ, SBZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3
;	ObjPos_SBZ1, ObjPos_SBZ2
; ---------------------------------------------------------------------------

Caterkiller:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Cat_Index(pc,d0.w),d1
		jmp	Cat_Index(pc,d1.w)
; ===========================================================================
Cat_Index:	index *,,2
		ptr Cat_Main
		ptr Cat_Head
		ptr Cat_BodySeg1
		ptr Cat_BodySeg2
		ptr Cat_BodySeg1
		ptr Cat_Delete
		ptr Cat_Fragment

ost_cat_wait_time:	equ $2A					; time to wait between actions
ost_cat_mode:		equ $2B					; bit 4 (+$10) = segment is moving; bit 7 (+$80) = update animation
ost_cat_floormap:	equ $2C					; height map of floor beneath caterkiller (16 bytes)
ost_cat_parent:		equ $3C					; address of OST of parent object (4 bytes - high byte is ost_cat_segment_pos)
ost_cat_segment_pos:	equ $3C					; segment position - starts as 0/4/8/$A, increments as it moves
; ===========================================================================

locret_16950:
		rts	
; ===========================================================================

Cat_Main:	; Routine 0
		move.b	#7,ost_height(a0)
		move.b	#8,ost_width(a0)
		jsr	(ObjectFall).l				; make caterkiller fall
		jsr	(FindFloorObj).l
		tst.w	d1					; has caterkiller hit floor?
		bpl.s	locret_16950				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)			; goto Cat_Head next
		move.l	#Map_Cat,ost_mappings(a0)
		move.w	#tile_Nem_Cater_SBZ+tile_pal2,ost_tile(a0)
		cmpi.b	#id_SBZ,(v_zone).w
		beq.s	@isscrapbrain				; if zone is SBZ, branch
		move.w	#tile_Nem_Cater+tile_pal2,ost_tile(a0)	; MZ specific code

	@isscrapbrain:
		andi.b	#render_xflip+render_yflip,ost_render(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	ost_render(a0),ost_status(a0)
		move.b	#4,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#id_col_8x8,ost_col_type(a0)
		move.w	ost_x_pos(a0),d2			; head x position
		moveq	#12,d5					; distance between segments
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d5					; negative if xflipped

	@noflip:
		move.b	#id_Cat_BodySeg1,d6			; routine number
		moveq	#0,d3
		moveq	#4,d4
		movea.l	a0,a2					; parent OST address
		moveq	#3-1,d1					; 3 body segments

Cat_Loop:
		jsr	(FindNextFreeObj).l
		if Revision=0
		bne.s	@fail
		else
			bne.w	Cat_ChkGone
		endc
		move.b	#id_Caterkiller,ost_id(a1)		; load body segment object
		move.b	d6,ost_routine(a1)			; goto Cat_BodySeg1 or Cat_BodySeg2 next
		addq.b	#2,d6					; alternate between the two
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	#5,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#id_col_8x8+id_col_custom,ost_col_type(a1)
		add.w	d5,d2
		move.w	d2,ost_x_pos(a1)			; body x pos = head x pos plus/minus 12
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	ost_status(a0),ost_render(a1)
		move.b	#id_frame_cat_body1,ost_frame(a1)
		move.l	a2,ost_cat_parent(a1)
		move.b	d4,ost_cat_segment_pos(a1)
		addq.b	#4,d4
		movea.l	a1,a2					; make parent object the adjacent segment instead of head

	@fail:
		dbf	d1,Cat_Loop				; repeat sequence 2 more times

		move.b	#7,ost_cat_wait_time(a0)
		clr.b	ost_cat_segment_pos(a0)

Cat_Head:	; Routine 2
		tst.b	ost_status(a0)				; has caterkiller been broken?
		bmi.w	Cat_Head_Break				; if yes, branch
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Cat_Head_Index(pc,d0.w),d1
		jsr	Cat_Head_Index(pc,d1.w)
		move.b	ost_cat_mode(a0),d1
		bpl.s	@display
		lea	(Ani_Cat).l,a1
		move.b	ost_angle(a0),d0
		andi.w	#$7F,d0
		addq.b	#4,ost_angle(a0)
		move.b	(a1,d0.w),d0
		bpl.s	@animate
		bclr	#7,ost_cat_mode(a0)
		bra.s	@display

	@animate:
		andi.b	#$10,d1
		add.b	d1,d0
		move.b	d0,ost_frame(a0)

	@display:
		out_of_range	Cat_ChkGone
		jmp	(DisplaySprite).l

Cat_ChkGone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		move.b	#id_Cat_Delete,ost_routine(a0)		; goto Cat_Delete next
		rts	
; ===========================================================================

Cat_Delete:	; Routine $A
		jmp	(DeleteObject).l
; ===========================================================================
Cat_Head_Index:	index *
		ptr Cat_Undulate
		ptr Cat_Floor
; ===========================================================================

Cat_Undulate:
		subq.b	#1,ost_cat_wait_time(a0)		; decrement timer
		bmi.s	@move					; branch if -1
		rts	
; ===========================================================================

	@move:
		addq.b	#2,ost_routine2(a0)			; goto Cat_Floor next
		move.b	#$10,ost_cat_wait_time(a0)		; reset timer
		move.w	#-$C0,ost_x_vel(a0)
		move.w	#$40,ost_inertia(a0)
		bchg	#4,ost_cat_mode(a0)			; is segment moving?
		bne.s	@is_moving				; if yes, branch
		clr.w	ost_x_vel(a0)
		neg.w	ost_inertia(a0)

	@is_moving:
		bset	#7,ost_cat_mode(a0)			; update animation

Cat_Floor:
		subq.b	#1,ost_cat_wait_time(a0)		; decrement timer
		bmi.s	@undulate_next				; branch if -1
		if Revision=0
			move.l	ost_x_pos(a0),-(sp)
			move.l	ost_x_pos(a0),d2
		else
			tst.w	ost_x_vel(a0)
			beq.s	@notmoving
			move.l	ost_x_pos(a0),d2
			move.l	d2,d3
		endc
		move.w	ost_x_vel(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d0

	@noflip:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,ost_x_pos(a0)
		if Revision=0
			jsr	(FindFloorObj).l
			move.l	(sp)+,d2
			cmpi.w	#-8,d1
			blt.s	@loc_16B70
			cmpi.w	#$C,d1
			bge.s	@loc_16B70
			add.w	d1,ost_y_pos(a0)
			swap	d2
			cmp.w	ost_x_pos(a0),d2
			beq.s	@notmoving
		else
			swap	d3
			cmp.w	ost_x_pos(a0),d3
			beq.s	@notmoving
			jsr	(FindFloorObj).l
			cmpi.w	#-8,d1
			blt.s	@loc_16B70
			cmpi.w	#$C,d1
			bge.s	@loc_16B70
			add.w	d1,ost_y_pos(a0)
		endc
		moveq	#0,d0
		move.b	ost_cat_segment_pos(a0),d0
		addq.b	#1,ost_cat_segment_pos(a0)
		andi.b	#$F,ost_cat_segment_pos(a0)
		move.b	d1,ost_cat_floormap(a0,d0.w)

	@notmoving:
		rts	
; ===========================================================================

@undulate_next:
		subq.b	#2,ost_routine2(a0)
		move.b	#7,ost_cat_wait_time(a0)
		if Revision=0
			move.w	#0,ost_x_vel(a0)
		else
			clr.w	ost_x_vel(a0)
			clr.w	ost_inertia(a0)
		endc
		rts	
; ===========================================================================

@loc_16B70:
		if Revision=0
			move.l	d2,ost_x_pos(a0)
			bchg	#status_xflip_bit,ost_status(a0)
			move.b	ost_status(a0),ost_render(a0)
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			move.b	#$80,ost_cat_floormap(a0,d0.w)
		else
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			move.b	#$80,ost_cat_floormap(a0,d0)
			neg.w	ost_x_sub(a0)
			beq.s	@loc_1730A
			btst	#status_xflip_bit,ost_status(a0)
			beq.s	@loc_1730A
			subq.w	#1,ost_x_pos(a0)
			addq.b	#1,ost_cat_segment_pos(a0)
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			clr.b	ost_cat_floormap(a0,d0)
	@loc_1730A:
			bchg	#status_xflip_bit,ost_status(a0)
			move.b	ost_status(a0),ost_render(a0)
		endc
		addq.b	#1,ost_cat_segment_pos(a0)
		andi.b	#$F,ost_cat_segment_pos(a0)
		rts	
; ===========================================================================

Cat_BodySeg2:	; Routine 6
		movea.l	ost_cat_parent(a0),a1
		move.b	ost_cat_mode(a1),ost_cat_mode(a0)
		bpl.s	Cat_BodySeg1
		lea	(Ani_Cat).l,a1
		move.b	ost_angle(a0),d0			; get angle byte
		andi.w	#$7F,d0					; wraps to 0 at $80
		addq.b	#4,ost_angle(a0)			; increment
		tst.b	4(a1,d0.w)
		bpl.s	Cat_AniBody
		addq.b	#4,ost_angle(a0)

Cat_AniBody:
		move.b	(a1,d0.w),d0				; get frame id from animation
		addq.b	#id_frame_cat_body1,d0			; skip head frames
		move.b	d0,ost_frame(a0)

Cat_BodySeg1:	; Routine 4, 8
		movea.l	ost_cat_parent(a0),a1
		tst.b	ost_status(a0)				; is caterkiller broken?
		bmi.w	Cat_Body_Break				; if yes, branch
		move.b	ost_cat_mode(a1),ost_cat_mode(a0)
		move.b	ost_routine2(a1),ost_routine2(a0)
		beq.w	loc_16C64
		move.w	ost_inertia(a1),ost_inertia(a0)
		move.w	ost_x_vel(a1),d0
		if Revision=0
			add.w	ost_inertia(a1),d0
		else
			add.w	ost_inertia(a0),d0
		endc
		move.w	d0,ost_x_vel(a0)
		move.l	ost_x_pos(a0),d2
		move.l	d2,d3
		move.w	ost_x_vel(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d0

	@noflip:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,ost_x_pos(a0)
		swap	d3
		cmp.w	ost_x_pos(a0),d3
		beq.s	loc_16C64
		moveq	#0,d0
		move.b	ost_cat_segment_pos(a0),d0
		move.b	ost_cat_floormap(a1,d0.w),d1
		cmpi.b	#$80,d1
		bne.s	loc_16C50
		if Revision=0
			swap	d3
			move.l	d3,ost_x_pos(a0)
			move.b	d1,ost_cat_floormap(a0,d0.w)
		else
			move.b	d1,ost_cat_floormap(a0,d0)
			neg.w	ost_x_sub(a0)
			beq.s	locj_173E4
			btst	#status_xflip_bit,ost_status(a0)
			beq.s	locj_173E4
			cmpi.w	#-$C0,ost_x_vel(a0)
			bne.s	locj_173E4
			subq.w	#1,ost_x_pos(a0)
			addq.b	#1,ost_cat_segment_pos(a0)
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			clr.b	ost_cat_floormap(a0,d0)
	locj_173E4:
		endc
		bchg	#status_xflip_bit,ost_status(a0)
		move.b	ost_status(a0),ost_render(a0)
		addq.b	#1,ost_cat_segment_pos(a0)
		andi.b	#$F,ost_cat_segment_pos(a0)
		bra.s	loc_16C64
; ===========================================================================

loc_16C50:
		ext.w	d1
		add.w	d1,ost_y_pos(a0)
		addq.b	#1,ost_cat_segment_pos(a0)
		andi.b	#$F,ost_cat_segment_pos(a0)
		move.b	d1,ost_cat_floormap(a0,d0.w)

loc_16C64:
		cmpi.b	#id_Cat_Fragment,ost_routine(a1)
		beq.s	Cat_Body_Break
		cmpi.b	#id_ExplosionItem,ost_id(a1)
		beq.s	loc_16C7C
		cmpi.b	#id_Cat_Delete,ost_routine(a1)
		bne.s	loc_16C82

loc_16C7C:
		move.b	#id_Cat_Delete,ost_routine(a0)

loc_16C82:
		jmp	(DisplaySprite).l

; ===========================================================================
Cat_FragSpeed:	dc.w -$200, -$180, $180, $200
; ===========================================================================

Cat_Body_Break:
		bset	#render_onscreen_bit,ost_status(a1)

Cat_Head_Break:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Cat_FragSpeed-2(pc,d0.w),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_16CAA
		neg.w	d0

loc_16CAA:
		move.w	d0,ost_x_vel(a0)
		move.w	#-$400,ost_y_vel(a0)
		move.b	#id_Cat_Fragment,ost_routine(a0)
		andi.b	#$F8,ost_frame(a0)

Cat_Fragment:	; Routine $C
		jsr	(ObjectFall).l				; make object fall & update positioin
		tst.w	ost_y_vel(a0)				; is object moving upwards?
		bmi.s	@nocollide				; if yes, branch
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit floor?
		bpl.s	@nocollide				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#-$400,ost_y_vel(a0)			; bounce

	@nocollide:
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	Cat_ChkGone				; if not, branch
		jmp	(DisplaySprite).l
