; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy	(MZ, SBZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3
;	ObjPos_SBZ1, ObjPos_SBZ2
;	Caterkiller - routines 4/6 (body segments)
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

		rsobj Caterkiller,$2A
ost_cat_wait_time:	rs.b 1					; $2A ; time to wait between actions
ost_cat_mode:		rs.b 1					; $2B ; bit 4 (+$10) = mouth is open/segment moving up; bit 7 (+$80) = update animation
ost_cat_floormap:	rs.b 16					; $2C ; height map of floor beneath caterkiller (16 bytes)
ost_cat_parent:		rs.l 1					; $3C ; address of OST of parent object (4 bytes - high byte is ost_cat_segment_pos)
ost_cat_segment_pos:	equ ost_cat_parent			; $3C ; segment position - starts as 0/4/8/$A, increments as it moves
		rsobjend
; ===========================================================================

Cat_Fall:
		rts	
; ===========================================================================

Cat_Main:	; Routine 0
		move.b	#7,ost_height(a0)
		move.b	#8,ost_width(a0)
		jsr	(ObjectFall).l				; apply gravity and update position
		jsr	(FindFloorObj).l
		tst.w	d1					; has caterkiller hit floor?
		bpl.s	Cat_Fall				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		clr.w	ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)			; goto Cat_Head next
		move.l	#Map_Cat,ost_mappings(a0)
		move.w	#tile_Nem_Cater_SBZ+tile_pal2,ost_tile(a0)
		cmpi.b	#id_SBZ,(v_zone).w
		beq.s	.isscrapbrain				; if zone is SBZ, branch
		move.w	#tile_Nem_Cater+tile_pal2,ost_tile(a0)	; MZ specific code

	.isscrapbrain:
		andi.b	#render_xflip+render_yflip,ost_render(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	ost_render(a0),ost_status(a0)
		move.b	#4,ost_priority(a0)
		move.b	#8,ost_displaywidth(a0)
		move.b	#id_col_8x8,ost_col_type(a0)
		move.w	ost_x_pos(a0),d2			; head x position
		moveq	#12,d5					; distance between segments (12px)
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.noflip
		neg.w	d5					; negative if xflipped

	.noflip:
		move.b	#id_Cat_BodySeg1,d6			; routine number
		moveq	#0,d3
		moveq	#4,d4
		movea.l	a0,a2					; parent OST address
		moveq	#3-1,d1					; 3 body segments

Cat_Loop:
		jsr	(FindNextFreeObj).l
		if Revision=0
			bne.s	.fail
		else
			bne.w	Cat_Despawn
		endc
		move.b	#id_Caterkiller,ost_id(a1)		; load body segment object
		move.b	d6,ost_routine(a1)			; goto Cat_BodySeg1 or Cat_BodySeg2 next
		addq.b	#2,d6					; alternate between the two
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	#5,ost_priority(a1)
		move.b	#8,ost_displaywidth(a1)
		move.b	#id_col_8x8+id_col_custom,ost_col_type(a1)
		add.w	d5,d2
		move.w	d2,ost_x_pos(a1)			; body segment x pos = previous segment x pos +12
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	ost_status(a0),ost_render(a1)
		move.b	#id_frame_cat_body1,ost_frame(a1)
		move.l	a2,ost_cat_parent(a1)
		move.b	d4,ost_cat_segment_pos(a1)
		addq.b	#4,d4
		movea.l	a1,a2					; make adjacent segment the parent object instead of head

	.fail:
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
		move.b	ost_cat_mode(a0),d1			; is animation flag set?
		bpl.s	.display				; if not, branch
		lea	(Ani_Cat).l,a1
		move.b	ost_angle(a0),d0
		andi.w	#$7F,d0					; ignore high bit of angle
		addq.b	#4,ost_angle(a0)			; increment angle (wraps from $FC to 0)
		move.b	(a1,d0.w),d0				; get byte from animation script, based on angle
		bpl.s	.animate				; branch if not $FF
		bclr	#7,ost_cat_mode(a0)			; disable animation
		bra.s	.display

	.animate:
		andi.b	#$10,d1					; read mouth open/closed bit
		add.b	d1,d0					; add to frame (+$10)
		move.b	d0,ost_frame(a0)			; set frame

	.display:
		out_of_range	Cat_Despawn
		jmp	(DisplaySprite).l

Cat_Despawn:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	.delete
		bclr	#7,2(a2,d0.w)				; clear high bit of respawn entry

	.delete:
		move.b	#id_Cat_Delete,ost_routine(a0)		; goto Cat_Delete next
		rts	
; ===========================================================================

Cat_Delete:	; Routine $A
		jmp	(DeleteObject).l
; ===========================================================================
Cat_Head_Index:	index *,,2
		ptr Cat_Undulate
		ptr Cat_Floor
; ===========================================================================

Cat_Undulate:
		subq.b	#1,ost_cat_wait_time(a0)		; decrement timer
		bmi.s	.move					; branch if -1
		rts	
; ===========================================================================

	.move:
		addq.b	#2,ost_routine2(a0)			; goto Cat_Floor next
		move.b	#$10,ost_cat_wait_time(a0)		; set timer for movement
		move.w	#-$C0,ost_x_vel(a0)			; move head to the left
		move.w	#$40,ost_inertia(a0)
		bchg	#4,ost_cat_mode(a0)			; change between mouth open/moving up, and mouth closed/moving down
		bne.s	.is_moving				; branch if mouth open/moving up
		clr.w	ost_x_vel(a0)				; don't move left
		neg.w	ost_inertia(a0)

	.is_moving:
		bset	#7,ost_cat_mode(a0)			; update animation

Cat_Floor:
		subq.b	#1,ost_cat_wait_time(a0)		; decrement timer
		bmi.s	.undulate_next				; branch if -1
		if Revision=0
			move.l	ost_x_pos(a0),-(sp)		; save x pos to stack
			move.l	ost_x_pos(a0),d2
		else
			tst.w	ost_x_vel(a0)
			beq.s	.notmoving			; branch if head isn't moving horizontally
			move.l	ost_x_pos(a0),d2
			move.l	d2,d3				; d3 = x pos before update
		endc
		move.w	ost_x_vel(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.noflip
		neg.w	d0					; change direction if xflipped (i.e. move right)

	.noflip:
		ext.l	d0
		asl.l	#8,d0					; multiply speed by $100
		add.l	d0,d2					; add to x pos
		move.l	d2,ost_x_pos(a0)			; update position
		if Revision=0
			jsr	(FindFloorObj).l
			popr	d2				; retrieve previous x pos from stack
			cmpi.w	#-8,d1
			blt.s	.turn_around			; branch if > 8px below floor
			cmpi.w	#$C,d1
			bge.s	.turn_around			; branch if > 11px above floor (also detects a ledge)
			add.w	d1,ost_y_pos(a0)		; align to floor
			swap	d2
			cmp.w	ost_x_pos(a0),d2
			beq.s	.notmoving			; branch if head hasn't moved horizontally
		else
			swap	d3
			cmp.w	ost_x_pos(a0),d3
			beq.s	.notmoving			; branch if head hasn't moved horizontally
			jsr	(FindFloorObj).l
			cmpi.w	#-8,d1
			blt.s	.turn_around			; branch if > 8px below floor
			cmpi.w	#$C,d1
			bge.s	.turn_around			; branch if > 11px above floor (also detects a ledge)
			add.w	d1,ost_y_pos(a0)		; align to floor
		endc
		moveq	#0,d0
		move.b	ost_cat_segment_pos(a0),d0		; get pos counter for head (starts as 0)
		addq.b	#1,ost_cat_segment_pos(a0)		; increment counter
		andi.b	#$F,ost_cat_segment_pos(a0)		; wrap to 0 after $F
		move.b	d1,ost_cat_floormap(a0,d0.w)		; write floor height for current position in array

	.notmoving:
		rts	
; ===========================================================================

.undulate_next:
		subq.b	#2,ost_routine2(a0)			; goto Cat_Undulate next
		move.b	#7,ost_cat_wait_time(a0)		; set timer for delay
		if Revision=0
			move.w	#0,ost_x_vel(a0)		; stop moving
		else
			clr.w	ost_x_vel(a0)			; stop moving
			clr.w	ost_inertia(a0)
		endc
		rts	
; ===========================================================================

.turn_around:
		if Revision=0
			move.l	d2,ost_x_pos(a0)		; restore previous x pos (i.e. stop moving)
			bchg	#status_xflip_bit,ost_status(a0) ; change direction
			move.b	ost_status(a0),ost_render(a0)
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0	; get pos counter for head
			move.b	#$80,ost_cat_floormap(a0,d0.w)	; save stop position in floor map array
		else
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0	; get pos counter for head
			move.b	#$80,ost_cat_floormap(a0,d0.w)	; save stop position in floor map array
			neg.w	ost_x_sub(a0)
			beq.s	.face_left			; branch if x subpixel is 0
			btst	#status_xflip_bit,ost_status(a0)
			beq.s	.face_left			; branch if facing left
			subq.w	#1,ost_x_pos(a0)
			addq.b	#1,ost_cat_segment_pos(a0)	; increment pos counter
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			clr.b	ost_cat_floormap(a0,d0.w)
	.face_left:
			bchg	#status_xflip_bit,ost_status(a0)
			move.b	ost_status(a0),ost_render(a0)
		endc
		addq.b	#1,ost_cat_segment_pos(a0)		; increment pos counter
		andi.b	#$F,ost_cat_segment_pos(a0)		; wrap to 0 after $F
		rts	
; ===========================================================================

Cat_BodySeg2:	; Routine 6
		movea.l	ost_cat_parent(a0),a1			; get OST of 1st body segment
		move.b	ost_cat_mode(a1),ost_cat_mode(a0)	; copy animation mode flags
		bpl.s	Cat_BodySeg1				; branch if not updating

		lea	(Ani_Cat).l,a1
		move.b	ost_angle(a0),d0
		andi.w	#$7F,d0					; ignore high bit of angle
		addq.b	#4,ost_angle(a0)			; increment angle (wraps from $FC to 0)
		tst.b	4(a1,d0.w)				; get byte from animation script, based on angle
		bpl.s	.update_frame				; branch if not $FF
		addq.b	#4,ost_angle(a0)			; increment angle again

	.update_frame:
		move.b	(a1,d0.w),d0				; get frame id from animation
		addq.b	#id_frame_cat_body1,d0			; skip head frames to body frames
		move.b	d0,ost_frame(a0)			; update frame

Cat_BodySeg1:	; Routine 4, 8
		movea.l	ost_cat_parent(a0),a1			; get OST of head or previous body segment
		tst.b	ost_status(a0)
		bmi.w	Cat_Body_Break				; branch if caterkiller is broken
		move.b	ost_cat_mode(a1),ost_cat_mode(a0)	; copy animation mode flags
		move.b	ost_routine2(a1),ost_routine2(a0)
		beq.w	.chk_broken
		move.w	ost_inertia(a1),ost_inertia(a0)
		move.w	ost_x_vel(a1),d0
		if Revision=0
			add.w	ost_inertia(a1),d0
		else
			add.w	ost_inertia(a0),d0
		endc
		move.w	d0,ost_x_vel(a0)			; update x speed
		move.l	ost_x_pos(a0),d2
		move.l	d2,d3					; d3 = x pos before update
		move.w	ost_x_vel(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.noflip
		neg.w	d0					; reverse speed if xflipped

	.noflip:
		ext.l	d0
		asl.l	#8,d0					; multiply speed by $100
		add.l	d0,d2					; add to x pos
		move.l	d2,ost_x_pos(a0)			; update position
		swap	d3
		cmp.w	ost_x_pos(a0),d3
		beq.s	.chk_broken				; branch if segment hasn't moved
		moveq	#0,d0
		move.b	ost_cat_segment_pos(a0),d0		; get pos counter
		move.b	ost_cat_floormap(a1,d0.w),d1		; get floor height from parent's floor array
		cmpi.b	#$80,d1					; floor height $80 means a wall or drop
		bne.s	.align_to_floor				; branch if not $80
		if Revision=0
			swap	d3
			move.l	d3,ost_x_pos(a0)		; restore previous x pos (i.e. don't move)
			move.b	d1,ost_cat_floormap(a0,d0.w)	; write $80 to current floor array (for next segment to read)
		else
			move.b	d1,ost_cat_floormap(a0,d0.w)
			neg.w	ost_x_sub(a0)
			beq.s	.face_left
			btst	#status_xflip_bit,ost_status(a0)
			beq.s	.face_left			; branch if facing left
			cmpi.w	#-$C0,ost_x_vel(a0)
			bne.s	.face_left			; branch if not moving left
			subq.w	#1,ost_x_pos(a0)
			addq.b	#1,ost_cat_segment_pos(a0)
			moveq	#0,d0
			move.b	ost_cat_segment_pos(a0),d0
			clr.b	ost_cat_floormap(a0,d0.w)
	.face_left:
		endc
		bchg	#status_xflip_bit,ost_status(a0)	; change direction
		move.b	ost_status(a0),ost_render(a0)
		addq.b	#1,ost_cat_segment_pos(a0)		; increment pos counter
		andi.b	#$F,ost_cat_segment_pos(a0)		; wrap to 0 after $F
		bra.s	.chk_broken
; ===========================================================================

.align_to_floor:
		ext.w	d1
		add.w	d1,ost_y_pos(a0)			; align to floor
		addq.b	#1,ost_cat_segment_pos(a0)		; increment pos counter
		andi.b	#$F,ost_cat_segment_pos(a0)		; wrap to 0 after $F
		move.b	d1,ost_cat_floormap(a0,d0.w)		; write floor height for current position in array

.chk_broken:
		cmpi.b	#id_Cat_Fragment,ost_routine(a1)
		beq.s	Cat_Body_Break				; branch if parent is broken body segment
		cmpi.b	#id_ExplosionItem,ost_id(a1)
		beq.s	.head_broken				; branch if parent is broken head
		cmpi.b	#id_Cat_Delete,ost_routine(a1)
		bne.s	.deleted				; branch if parent is set to delete

	.head_broken:
		move.b	#id_Cat_Delete,ost_routine(a0)		; set current segment to delete

	.deleted:
		jmp	(DisplaySprite).l

; ===========================================================================
Cat_FragSpeed:	dc.w -$200					; head x speed
		dc.w -$180					; body x speed
		dc.w $180					; body x speed
		dc.w $200					; body x speed
; ===========================================================================

Cat_Body_Break:
		bset	#render_onscreen_bit,ost_status(a1)	; stop parent despawning

Cat_Head_Break:
		moveq	#0,d0
		move.b	ost_routine(a0),d0			; get routine number (2/4/6/8)
		move.w	Cat_FragSpeed-2(pc,d0.w),d0		; get speed of specified segment
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	.no_xflip
		neg.w	d0					; reverse if xflipped

	.no_xflip:
		move.w	d0,ost_x_vel(a0)			; set x speed
		move.w	#-$400,ost_y_vel(a0)
		move.b	#id_Cat_Fragment,ost_routine(a0)	; goto Cat_Fragment next
		andi.b	#$F8,ost_frame(a0)			; use first head/body frame

Cat_Fragment:	; Routine $C
		jsr	(ObjectFall).l				; apply gravity & update positioin
		tst.w	ost_y_vel(a0)
		bmi.s	.nocollide				; branch if moving upwards
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit floor?
		bpl.s	.nocollide				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#-$400,ost_y_vel(a0)			; bounce

	.nocollide:
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	Cat_Despawn				; if not, branch
		jmp	(DisplaySprite).l

; ---------------------------------------------------------------------------
; Animation script (uses non-standard format)
; ---------------------------------------------------------------------------

Ani_Cat:
		dc.b 0,	0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 1
		dc.b 1,	1, 1, 1, 1, 1, 2, 2, 2,	2, 2, 3, 3, 3, 3, 3
		dc.b 4,	4, 4, 4, 4, 4, 5, 5, 5,	5, 5, 6, 6, 6, 6, 6
		dc.b 6,	6, 7, 7, 7, 7, 7, 7, 7,	7, 7, 7, $FF, 7, 7, $FF
		dc.b 7,	7, 7, 7, 7, 7, 7, 7, 7,	7, 7, 7, 7, 7, 7, 6
		dc.b 6,	6, 6, 6, 6, 6, 5, 5, 5,	5, 5, 4, 4, 4, 4, 4
		dc.b 4,	3, 3, 3, 3, 3, 2, 2, 2,	2, 2, 1, 1, 1, 1, 1
		dc.b 1,	1, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, $FF, 0, 0, $FF
		even
