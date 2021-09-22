; ---------------------------------------------------------------------------
; Object 5E - seesaws (SLZ)
; ---------------------------------------------------------------------------

Seesaw:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	See_Index(pc,d0.w),d1
		jsr	See_Index(pc,d1.w)
		move.w	ost_seesaw_x_start(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
See_Index:	index *,,2
		ptr See_Main
		ptr See_Slope
		ptr See_Slope2
		ptr See_Spikeball
		ptr See_MoveSpike
		ptr See_SpikeFall

ost_seesaw_x_start:	equ $30	; original x-axis position (2 bytes)
ost_seesaw_y_start:	equ $34	; original y-axis position (2 bytes)
ost_seesaw_impact:	equ $38	; speed Sonic hits the seesaw (2 bytes)
ost_seesaw_state:	equ $3A	; 0/2 = tilted; 1/3 = flat
ost_seesaw_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

See_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Seesaw,ost_mappings(a0)
		move.w	#tile_Nem_Seesaw,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$30,ost_actwidth(a0)
		move.w	ost_x_pos(a0),ost_seesaw_x_start(a0)
		tst.b	ost_subtype(a0)	; is object type 00 ?
		bne.s	@noball		; if not, branch

		bsr.w	FindNextFreeObj
		bne.s	@noball
		move.b	#id_Seesaw,0(a1) ; load spikeball object
		addq.b	#6,ost_routine(a1) ; use See_Spikeball routine
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.l	a0,ost_seesaw_parent(a1)

	@noball:
		btst	#status_xflip_bit,ost_status(a0) ; is seesaw flipped?
		beq.s	@noflip		; if not, branch
		move.b	#2,ost_frame(a0) ; use different frame

	@noflip:
		move.b	ost_frame(a0),ost_seesaw_state(a0)

See_Slope:	; Routine 2
		move.b	ost_seesaw_state(a0),d1
		bsr.w	See_ChgFrame
		lea	(See_DataSlope).l,a2
		btst	#0,ost_frame(a0) ; is seesaw flat?
		beq.s	@notflat	; if not, branch
		lea	(See_DataFlat).l,a2

	@notflat:
		lea	(v_ost_player).w,a1
		move.w	ost_y_vel(a1),ost_seesaw_impact(a0)
		move.w	#$30,d1
		jsr	(SlopeObject).l
		rts	
; ===========================================================================

See_Slope2:	; Routine 4
		bsr.w	See_ChkSide
		lea	(See_DataSlope).l,a2
		btst	#0,ost_frame(a0) ; is seesaw flat?
		beq.s	@notflat	; if not, branch
		lea	(See_DataFlat).l,a2

	@notflat:
		move.w	#$30,d1
		jsr	(ExitPlatform).l
		move.w	#$30,d1
		move.w	ost_x_pos(a0),d2
		jsr	(SlopeObject_NoChk).l
		rts	
; ===========================================================================

See_ChkSide:
		moveq	#2,d1
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a0),d0
		sub.w	ost_x_pos(a1),d0 ; is Sonic on the left side of the seesaw?
		bcc.s	@leftside	; if yes, branch
		neg.w	d0
		moveq	#0,d1

	@leftside:
		cmpi.w	#8,d0
		bcc.s	See_ChgFrame
		moveq	#1,d1

See_ChgFrame:
		move.b	ost_frame(a0),d0
		cmp.b	d1,d0		; does frame need to change?
		beq.s	@noflip		; if not, branch
		bcc.s	@loc_11772
		addq.b	#2,d0

	@loc_11772:
		subq.b	#1,d0
		move.b	d0,ost_frame(a0)
		move.b	d1,ost_seesaw_state(a0)
		bclr	#render_xflip_bit,ost_render(a0)
		btst	#1,ost_frame(a0)
		beq.s	@noflip
		bset	#render_xflip_bit,ost_render(a0)

	@noflip:
		rts	
; ===========================================================================

See_Spikeball:	; Routine 6
		addq.b	#2,ost_routine(a0)
		move.l	#Map_SSawBall,ost_mappings(a0)
		move.w	#tile_Nem_SlzSpike,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$8B,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		move.w	ost_x_pos(a0),ost_seesaw_x_start(a0)
		addi.w	#$28,ost_x_pos(a0)
		move.w	ost_y_pos(a0),ost_seesaw_y_start(a0)
		move.b	#id_frame_seesaw_silver,ost_frame(a0)
		btst	#status_xflip_bit,ost_status(a0) ; is seesaw flipped?
		beq.s	See_MoveSpike	; if not, branch
		subi.w	#$50,ost_x_pos(a0) ; move spikeball to the other side
		move.b	#2,ost_seesaw_state(a0)

See_MoveSpike:	; Routine 8
		movea.l	ost_seesaw_parent(a0),a1
		moveq	#0,d0
		move.b	ost_seesaw_state(a0),d0
		sub.b	ost_seesaw_state(a1),d0
		beq.s	loc_1183E
		bcc.s	loc_117FC
		neg.b	d0

loc_117FC:
		move.w	#-$818,d1
		move.w	#-$114,d2
		cmpi.b	#1,d0
		beq.s	loc_11822
		move.w	#-$AF0,d1
		move.w	#-$CC,d2
		cmpi.w	#$A00,ost_seesaw_impact(a1)
		blt.s	loc_11822
		move.w	#-$E00,d1
		move.w	#-$A0,d2

loc_11822:
		move.w	d1,ost_y_vel(a0)
		move.w	d2,ost_x_vel(a0)
		move.w	ost_x_pos(a0),d0
		sub.w	ost_seesaw_x_start(a0),d0
		bcc.s	loc_11838
		neg.w	ost_x_vel(a0)

loc_11838:
		addq.b	#2,ost_routine(a0)
		bra.s	See_SpikeFall
; ===========================================================================

loc_1183E:
		lea	(See_Speeds).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0
		move.w	#$28,d2
		move.w	ost_x_pos(a0),d1
		sub.w	ost_seesaw_x_start(a0),d1
		bcc.s	loc_1185C
		neg.w	d2
		addq.w	#2,d0

loc_1185C:
		add.w	d0,d0
		move.w	ost_seesaw_y_start(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,ost_y_pos(a0)
		add.w	ost_seesaw_x_start(a0),d2
		move.w	d2,ost_x_pos(a0)
		clr.w	ost_y_sub(a0)
		clr.w	ost_x_sub(a0)
		rts	
; ===========================================================================

See_SpikeFall:	; Routine $A
		tst.w	ost_y_vel(a0)	; is spikeball falling down?
		bpl.s	loc_1189A	; if yes, branch
		bsr.w	ObjectFall
		move.w	ost_seesaw_y_start(a0),d0
		subi.w	#$2F,d0
		cmp.w	ost_y_pos(a0),d0
		bgt.s	locret_11898
		bsr.w	ObjectFall

locret_11898:
		rts	
; ===========================================================================

loc_1189A:
		bsr.w	ObjectFall
		movea.l	ost_seesaw_parent(a0),a1
		lea	(See_Speeds).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0
		move.w	ost_x_pos(a0),d1
		sub.w	ost_seesaw_x_start(a0),d1
		bcc.s	loc_118BA
		addq.w	#2,d0

loc_118BA:
		add.w	d0,d0
		move.w	ost_seesaw_y_start(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	ost_y_pos(a0),d1
		bgt.s	locret_11938
		movea.l	ost_seesaw_parent(a0),a1
		moveq	#2,d1
		tst.w	ost_x_vel(a0)
		bmi.s	See_Spring
		moveq	#0,d1

See_Spring:
		move.b	d1,ost_seesaw_state(a1)
		move.b	d1,ost_seesaw_state(a0)
		cmp.b	ost_frame(a1),d1
		beq.s	loc_1192C
		bclr	#status_platform_bit,ost_status(a1)
		beq.s	loc_1192C
		clr.b	ost_routine2(a1)
		move.b	#id_See_Slope,ost_routine(a1)
		lea	(v_ost_player).w,a2
		move.w	ost_y_vel(a0),ost_y_vel(a2)
		neg.w	ost_y_vel(a2)
		bset	#status_air_bit,ost_status(a2)
		bclr	#status_platform_bit,ost_status(a2)
		clr.b	ost_sonic_jump(a2)
		move.b	#id_Spring,ost_anim(a2) ; change Sonic's animation to "spring" ($10)
		move.b	#2,ost_routine(a2)
		sfx	sfx_Spring,0,0,0 ; play spring sound

loc_1192C:
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)
		subq.b	#2,ost_routine(a0)

locret_11938:
		rts	
; ===========================================================================
See_Speeds:	dc.w -8, -$1C, -$2F, -$1C, -8

See_DataSlope:	incbin	"misc\slzssaw1.bin"
		even
See_DataFlat:	incbin	"misc\slzssaw2.bin"
		even
