; ---------------------------------------------------------------------------
; Object 60 - Orbinaut enemy (LZ, SLZ, SBZ)

; spawned by:
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtype 0
;	ObjPos_SLZ1, ObjPos_SLZ2, ObjPos_SLZ3 - subtype 2
;	ObjPos_SBZ3 - subtype 0
; ---------------------------------------------------------------------------

Orbinaut:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Orb_Index(pc,d0.w),d1
		jmp	Orb_Index(pc,d1.w)
; ===========================================================================
Orb_Index:	index *,,2
		ptr Orb_Main
		ptr Orb_ChkSonic
		ptr Orb_MoveHead
		ptr Orb_MoveOrb
		ptr Orb_FireOrb

ost_orb_direction:	equ $36					; direction orbs rotate: 1 = clockwise; -1 = anticlockwise
ost_orb_child_count:	equ $37					; number of child objects
ost_orb_child_list:	equ $38					; OST indices of child objects (4 bytes - 1 byte per ball)
ost_orb_parent:		equ $3C					; address of OST of parent object (4 bytes)
; ===========================================================================

Orb_Main:	; Routine 0
		move.l	#Map_Orb,ost_mappings(a0)
		move.w	#tile_Nem_Orbinaut,ost_tile(a0)		; SBZ specific code
		cmpi.b	#id_SBZ,(v_zone).w			; check if level is SBZ
		beq.s	@isscrap
		move.w	#tile_Nem_Orbinaut+tile_pal2,ost_tile(a0) ; SLZ specific code

	@isscrap:
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	@notlabyrinth
		move.w	#tile_Nem_Orbinaut_LZ,ost_tile(a0)	; LZ specific code

	@notlabyrinth:
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#id_col_8x8,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		moveq	#0,d2
		lea	ost_orb_child_count(a0),a2
		movea.l	a2,a3					; (a3) = number of orbs
		addq.w	#1,a2					; a2 = address of list of orb OST indices
		moveq	#4-1,d1					; 4 spiked orbs

@orb_loop:
		bsr.w	FindNextFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		addq.b	#1,(a3)					; increment orb count
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5					; convert OST RAM address to id
		move.b	d5,(a2)+				; add to list
		move.b	ost_id(a0),ost_id(a1)			; load spiked orb object
		move.b	#id_Orb_MoveOrb,ost_routine(a1)		; goto Orb_MoveOrb next
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		ori.b	#render_rel,ost_render(a1)
		move.b	#4,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#id_frame_orb_spikeball,ost_frame(a1)
		move.b	#id_col_4x4+id_col_hurt,ost_col_type(a1)
		move.b	d2,ost_angle(a1)			; set position around orbinaut
		addi.b	#$40,d2					; next orb is a quarter circle ahead
		move.l	a0,ost_orb_parent(a1)
		dbf	d1,@orb_loop				; repeat sequence 3 more times

	@fail:
		moveq	#1,d0
		btst	#status_xflip_bit,ost_status(a0)	; is orbinaut facing left?
		beq.s	@noflip					; if not, branch
		neg.w	d0					; reverse orb rotation

	@noflip:
		move.b	d0,ost_orb_direction(a0)
		move.b	ost_subtype(a0),ost_routine(a0)		; if type is 2, skip Orb_ChkSonic
		addq.b	#2,ost_routine(a0)			; goto Orb_ChkSonic (type 0) or Orb_MoveHead (type 2) next
		move.w	#-$40,ost_x_vel(a0)			; move orbinaut to the left
		btst	#status_xflip_bit,ost_status(a0)	; is orbinaut facing left?
		beq.s	@noflip2				; if not, branch
		neg.w	ost_x_vel(a0)				; move orbinaut	to the right

	@noflip2:
		rts	
; ===========================================================================

Orb_ChkSonic:	; Routine 2
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0			; is Sonic to the right of the orbinaut?
		bcc.s	@isright				; if yes, branch
		neg.w	d0

	@isright:
		cmpi.w	#$A0,d0					; is Sonic within $A0 pixels of	orbinaut?
		bcc.s	@animate				; if not, branch
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0			; is Sonic above the orbinaut?
		bcc.s	@isabove				; if yes, branch
		neg.w	d0

	@isabove:
		cmpi.w	#$50,d0					; is Sonic within $50 pixels of	orbinaut?
		bcc.s	@animate				; if not, branch
		tst.w	(v_debug_active).w			; is debug mode	on?
		bne.s	@animate				; if yes, branch
		move.b	#id_ani_orb_angry,ost_anim(a0)		; use "angry" animation

@animate:
		lea	(Ani_Orb).l,a1
		bsr.w	AnimateSprite
		bra.w	Orb_ChkDel
; ===========================================================================

Orb_MoveHead:	; Routine 4
		bsr.w	SpeedToPos				; update position

Orb_ChkDel:
		out_of_range	@chkgone
		bra.w	DisplaySprite

	@chkgone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	loc_11E34
		bclr	#7,2(a2,d0.w)

	loc_11E34:
		lea	ost_orb_child_count(a0),a2
		moveq	#0,d2
		move.b	(a2)+,d2
		subq.w	#1,d2					; d2 = number of children minus 1
		bcs.s	Orb_Delete

	@del_loop:
		moveq	#0,d0
		move.b	(a2)+,d0				; get OST index for child
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0			; convert to RAM address
		movea.l	d0,a1
		bsr.w	DeleteChild				; delete child object
		dbf	d2,@del_loop				; repeat for all children

Orb_Delete:
		bra.w	DeleteObject
; ===========================================================================

Orb_MoveOrb:	; Routine 6
		movea.l	ost_orb_parent(a0),a1
		cmpi.b	#id_Orbinaut,ost_id(a1)			; does parent object still exist?
		bne.w	DeleteObject				; if not, delete
		cmpi.b	#id_frame_orb_angry,ost_frame(a1)	; is orbinaut angry?
		bne.s	@circle					; if not, branch
		cmpi.b	#$40,ost_angle(a0)			; is spike orb directly under the orbinaut?
		bne.s	@circle					; if not, branch
		addq.b	#2,ost_routine(a0)			; goto Orb_FireOrb next
		subq.b	#1,ost_orb_child_count(a1)		; decrement orb count
		bne.s	@fire					; branch if not 0
		addq.b	#2,ost_routine(a1)			; if all orbs have been thrown, goto Orb_MoveHead next

	@fire:
		move.w	#-$200,ost_x_vel(a0)			; move orb to the left (quickly)
		btst	#status_xflip_bit,ost_status(a1)
		beq.s	@noflip
		neg.w	ost_x_vel(a0)

	@noflip:
		bra.w	DisplaySprite
; ===========================================================================

@circle:
		move.b	ost_angle(a0),d0			; get angle
		jsr	(CalcSine).l				; convert to sine/cosine
		asr.w	#4,d1
		add.w	ost_x_pos(a1),d1
		move.w	d1,ost_x_pos(a0)
		asr.w	#4,d0
		add.w	ost_y_pos(a1),d0
		move.w	d0,ost_y_pos(a0)
		move.b	ost_orb_direction(a1),d0		; get direction (1 or -1)
		add.b	d0,ost_angle(a0)			; add to angle
		bra.w	DisplaySprite
; ===========================================================================

Orb_FireOrb:	; Routine 8
		bsr.w	SpeedToPos				; update position
		tst.b	ost_render(a0)				; is orb on-screen?
		bpl.w	DeleteObject				; if not, branch
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Orb:	index *
		ptr ani_orb_normal
		ptr ani_orb_angry
		
ani_orb_normal:	dc.b $F
		dc.b id_frame_orb_normal
		dc.b afEnd
		even

ani_orb_angry:	dc.b $F
		dc.b id_frame_orb_medium
		dc.b id_frame_orb_angry
		dc.b afBack, 1
		even
