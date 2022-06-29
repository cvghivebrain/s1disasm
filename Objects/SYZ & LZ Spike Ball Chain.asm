; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ, LZ)

; spawned by:
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3 - subtype $54
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtypes $26/$45/$54/$65/$B5/$C4/$C5/$D4/$D5
;	ObjPos_SBZ3 - subtypes $34/$35/$44/$45/$C3/$C4/$C5/$D4/$D5
; ---------------------------------------------------------------------------

SpikeBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SBall_Index(pc,d0.w),d1
		jmp	SBall_Index(pc,d1.w)
; ===========================================================================
SBall_Index:	index *,,2
		ptr SBall_Main
		ptr SBall_Move
		ptr SBall_Display

		rsobj SpikeBall
ost_sball_child_count:	rs.b 1					; $29 ; number of child objects
ost_sball_child_list:	rs.b 14					; $2A ; OST indices of child objects and parent (14 bytes)
ost_sball_y_start:	rs.w 1					; $38 ; centre y-axis position
ost_sball_x_start:	rs.w 1					; $3A ; centre x-axis position
ost_sball_radius:	rs.b 1					; $3C ; radius
ost_sball_speed:	rs.w 1					; $3E ; rate of spin
		rsobjend
; ===========================================================================

SBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto SBall_Move next
		move.l	#Map_SBall,ost_mappings(a0)
		move.w	#tile_Nem_SmallSpike,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#8,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_sball_x_start(a0)
		move.w	ost_y_pos(a0),ost_sball_y_start(a0)
		move.b	#id_col_4x4+id_col_hurt,ost_col_type(a0) ; SYZ specific code (chain hurts Sonic)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	@notlz

		move.b	#0,ost_col_type(a0)			; LZ specific code (chain doesn't hurt)
		move.w	#tile_Nem_LzSpikeBall,ost_tile(a0)
		move.l	#Map_SBall2,ost_mappings(a0)

	@notlz:
		move.b	ost_subtype(a0),d1			; get object type
		andi.b	#$F0,d1					; read only high nybble
		ext.w	d1
		asl.w	#3,d1					; multiply by 8
		move.w	d1,ost_sball_speed(a0)			; set object twirl speed
		move.b	ost_status(a0),d0
		ror.b	#2,d0					; move bits 0-1 into bits 6-7
		andi.b	#$C0,d0					; read only x/y flip bits
		move.b	d0,ost_angle(a0)			; use those as the starting angle
		lea	ost_sball_child_count(a0),a2
		move.b	ost_subtype(a0),d1			; get object type
		andi.w	#7,d1					; read only bits 0-2 of low nybble
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3					; multiply type by $10
		move.b	d3,ost_sball_radius(a0)			; set as radius
		subq.w	#1,d1					; type minus 1 for first loop
		bcs.s	@fail					; branch if type was 0 (invalid)
		btst	#3,ost_subtype(a0)
		beq.s	@makechain				; branch if bit 3 of subtype isn't set (+8)
		subq.w	#1,d1
		bcs.s	@fail

@makechain:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		addq.b	#1,ost_sball_child_count(a0)		; increment child object counter
		move.w	a1,d5					; get RAM address of OST of child object
		subi.w	#v_ost_all&$FFFF,d5			; subtract $D000
		lsr.w	#6,d5					; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+				; add OST index to list of child objects
		move.b	#id_SBall_Display,ost_routine(a1)
		move.b	ost_id(a0),ost_id(a1)
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	ost_render(a0),ost_render(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.b	ost_displaywidth(a0),ost_displaywidth(a1)
		move.b	ost_col_type(a0),ost_col_type(a1)
		subi.b	#$10,d3					; subtract $10 for radius, each object closer to centre
		move.b	d3,ost_sball_radius(a1)
		cmpi.b	#id_LZ,(v_zone).w			; check if zone is LZ
		bne.s	@notlzagain				; if not, branch

		tst.b	d3
		bne.s	@notlzagain				; branch if not the centre object
		move.b	#id_frame_sball_base,ost_frame(a1)	; use different frame for LZ chain base

	@notlzagain:
		dbf	d1,@makechain				; repeat for length of chain

	@fail:
		move.w	a0,d5					; parent object OST address
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5					; convert to OST index
		move.b	d5,(a2)+				; add to end of list
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	SBall_Move				; if not, branch

		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0) ; make the end object a harmful spikeball
		move.b	#id_frame_sball_spikeball,ost_frame(a0)	; use different frame

SBall_Move:	; Routine 2
		bsr.w	SBall_MoveAll
		bra.w	SBall_ChkDel
; ===========================================================================

SBall_MoveAll:
		move.w	ost_sball_speed(a0),d0
		add.w	d0,ost_angle(a0)			; add spin speed to angle
		move.b	ost_angle(a0),d0			; get updated angle
		jsr	(CalcSine).l				; convert to sine/cosine
		move.w	ost_sball_y_start(a0),d2		; get position of chain base
		move.w	ost_sball_x_start(a0),d3
		lea	ost_sball_child_count(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6				; get number of objects

	@loop:
		moveq	#0,d4
		move.b	(a2)+,d4				; get OST index of object
		lsl.w	#6,d4
		addi.l	#v_ost_all&$FFFFFF,d4			; convert to RAM address
		movea.l	d4,a1					; point a1 to address
		moveq	#0,d4
		move.b	ost_sball_radius(a1),d4			; get radius for that object
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a1)			; update position
		move.w	d5,ost_x_pos(a1)
		dbf	d6,@loop				; repeat for all objects
		rts	
; ===========================================================================

SBall_ChkDel:
		out_of_range	@delete,ost_sball_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================

@delete:
		moveq	#0,d2
		lea	ost_sball_child_count(a0),a2
		move.b	(a2)+,d2				; get number of objects

	@deleteloop:
		moveq	#0,d0
		move.b	(a2)+,d0				; get OST index of object
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0			; convert to RAM address
		movea.l	d0,a1					; point a1 to address
		bsr.w	DeleteChild
		dbf	d2,@deleteloop				; delete all pieces of chain

		rts	
; ===========================================================================

SBall_Display:	; Routine 4
		bra.w	DisplaySprite
