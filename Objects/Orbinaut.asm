; ---------------------------------------------------------------------------
; Object 60 - Orbinaut enemy (LZ, SLZ, SBZ)
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
		ptr Orb_Display
		ptr Orb_MoveOrb
		ptr Orb_ChkDel2

ost_orb_child_count:	equ $36	; number of child objects
ost_orb_child_list:	equ $37	; OST indices of child objects (4 bytes - 1 byte per ball)
ost_orb_parent:		equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

Orb_Main:	; Routine 0
		move.l	#Map_Orb,ost_mappings(a0)
		move.w	#tile_Nem_Orbinaut,ost_tile(a0)	; SBZ specific code
		cmpi.b	#id_SBZ,(v_zone).w ; check if level is SBZ
		beq.s	@isscrap
		move.w	#tile_Nem_Orbinaut+tile_pal2,ost_tile(a0) ; SLZ specific code

	@isscrap:
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	@notlabyrinth
		move.w	#tile_Nem_Orbinaut_LZ,ost_tile(a0) ; LZ specific code

	@notlabyrinth:
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#id_col_8x8,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		moveq	#0,d2
		lea	ost_orb_child_list(a0),a2
		movea.l	a2,a3
		addq.w	#1,a2
		moveq	#3,d1

@makesatellites:
		bsr.w	FindNextFreeObj
		bne.s	@fail
		addq.b	#1,(a3)
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	0(a0),0(a1)	; load spiked orb object
		move.b	#id_Orb_MoveOrb,ost_routine(a1) ; use Orb_MoveOrb routine
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		ori.b	#render_rel,ost_render(a1)
		move.b	#4,ost_priority(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#id_frame_orb_spikeball,ost_frame(a1)
		move.b	#id_col_4x4+id_col_hurt,ost_col_type(a1)
		move.b	d2,ost_angle(a1)
		addi.b	#$40,d2
		move.l	a0,ost_orb_parent(a1)
		dbf	d1,@makesatellites ; repeat sequence 3 more times

	@fail:
		moveq	#1,d0
		btst	#status_xflip_bit,ost_status(a0) ; is orbinaut facing left?
		beq.s	@noflip		; if not, branch
		neg.w	d0

	@noflip:
		move.b	d0,ost_orb_child_count(a0)
		move.b	ost_subtype(a0),ost_routine(a0) ; if type is 02, skip Orb_ChkSonic
		addq.b	#2,ost_routine(a0)
		move.w	#-$40,ost_x_vel(a0) ; move orbinaut to the left
		btst	#status_xflip_bit,ost_status(a0) ; is orbinaut facing left??
		beq.s	@noflip2	; if not, branch
		neg.w	ost_x_vel(a0)	; move orbinaut	to the right

	@noflip2:
		rts	
; ===========================================================================

Orb_ChkSonic:	; Routine 2
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0 ; is Sonic to the right of the orbinaut?
		bcc.s	@isright	; if yes, branch
		neg.w	d0

	@isright:
		cmpi.w	#$A0,d0		; is Sonic within $A0 pixels of	orbinaut?
		bcc.s	@animate	; if not, branch
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0 ; is Sonic above the orbinaut?
		bcc.s	@isabove	; if yes, branch
		neg.w	d0

	@isabove:
		cmpi.w	#$50,d0		; is Sonic within $50 pixels of	orbinaut?
		bcc.s	@animate	; if not, branch
		tst.w	(v_debug_active).w	; is debug mode	on?
		bne.s	@animate	; if yes, branch
		move.b	#id_ani_orb_angry,ost_anim(a0) ; use "angry" animation

@animate:
		lea	(Ani_Orb).l,a1
		bsr.w	AnimateSprite
		bra.w	Orb_ChkDel
; ===========================================================================

Orb_Display:	; Routine 4
		bsr.w	SpeedToPos

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
		lea	ost_orb_child_list(a0),a2
		moveq	#0,d2
		move.b	(a2)+,d2
		subq.w	#1,d2
		bcs.s	Orb_Delete

loc_11E40:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,loc_11E40

Orb_Delete:
		bra.w	DeleteObject
; ===========================================================================

Orb_MoveOrb:	; Routine 6
		movea.l	ost_orb_parent(a0),a1
		cmpi.b	#id_Orbinaut,0(a1) ; does parent object still exist?
		bne.w	DeleteObject	; if not, delete
		cmpi.b	#id_frame_orb_angry,ost_frame(a1) ; is orbinaut angry?
		bne.s	@circle		; if not, branch
		cmpi.b	#$40,ost_angle(a0) ; is spikeorb directly under the orbinaut?
		bne.s	@circle		; if not, branch
		addq.b	#2,ost_routine(a0)
		subq.b	#1,ost_orb_child_list(a1)
		bne.s	@fire
		addq.b	#2,ost_routine(a1)

	@fire:
		move.w	#-$200,ost_x_vel(a0) ; move orb to the left (quickly)
		btst	#status_xflip_bit,ost_status(a1)
		beq.s	@noflip
		neg.w	ost_x_vel(a0)

	@noflip:
		bra.w	DisplaySprite
; ===========================================================================

@circle:
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		asr.w	#4,d1
		add.w	ost_x_pos(a1),d1
		move.w	d1,ost_x_pos(a0)
		asr.w	#4,d0
		add.w	ost_y_pos(a1),d0
		move.w	d0,ost_y_pos(a0)
		move.b	ost_orb_child_count(a1),d0
		add.b	d0,ost_angle(a0)
		bra.w	DisplaySprite
; ===========================================================================

Orb_ChkDel2:	; Routine 8
		bsr.w	SpeedToPos
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
