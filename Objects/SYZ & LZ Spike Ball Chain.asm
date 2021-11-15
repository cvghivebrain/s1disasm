; ---------------------------------------------------------------------------
; Object 57 - spiked balls (SYZ, LZ)
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

ost_sball_child_count:	equ $29					; number of child objects
		; $30-$37	; OST indices of child objects (1 byte each)
ost_sball_y_start:	equ $38					; centre y-axis position (2 bytes)
ost_sball_x_start:	equ $3A					; centre x-axis position (2 bytes)
ost_sball_radius:	equ $3C					; radius (1 byte)
ost_sball_speed:	equ $3E					; rate of spin (2 bytes)
; ===========================================================================

SBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_SBall,ost_mappings(a0)
		move.w	#tile_Nem_SmallSpike,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
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
		andi.b	#$F0,d1					; read only the	1st digit
		ext.w	d1
		asl.w	#3,d1					; multiply by 8
		move.w	d1,ost_sball_speed(a0)			; set object twirl speed
		move.b	ost_status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,ost_angle(a0)
		lea	ost_sball_child_count(a0),a2
		move.b	ost_subtype(a0),d1			; get object type
		andi.w	#7,d1					; read only the	2nd digit
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,ost_sball_radius(a0)
		subq.w	#1,d1					; set chain length (type-1)
		bcs.s	@fail
		btst	#3,ost_subtype(a0)
		beq.s	@makechain
		subq.w	#1,d1
		bcs.s	@fail

@makechain:
		bsr.w	FindFreeObj
		bne.s	@fail
		addq.b	#1,ost_sball_child_count(a0)		; increment child object counter
		move.w	a1,d5					; get child object RAM address
		subi.w	#v_ost_all&$FFFF,d5			; subtract $D000
		lsr.w	#6,d5					; divide by $40
		andi.w	#$7F,d5
		move.b	d5,(a2)+				; copy child RAM number
		move.b	#id_SBall_Display,ost_routine(a1)
		move.b	0(a0),0(a1)
		move.l	ost_mappings(a0),ost_mappings(a1)
		move.w	ost_tile(a0),ost_tile(a1)
		move.b	ost_render(a0),ost_render(a1)
		move.b	ost_priority(a0),ost_priority(a1)
		move.b	ost_actwidth(a0),ost_actwidth(a1)
		move.b	ost_col_type(a0),ost_col_type(a1)
		subi.b	#$10,d3
		move.b	d3,ost_sball_radius(a1)
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	@notlzagain

		tst.b	d3
		bne.s	@notlzagain
		move.b	#id_frame_sball_base,ost_frame(a1)	; use different frame for LZ chain

	@notlzagain:
		dbf	d1,@makechain				; repeat for length of chain

	@fail:
		move.w	a0,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		cmpi.b	#id_LZ,(v_zone).w			; check if level is LZ
		bne.s	SBall_Move

		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0) ; if yes, make last spikeball larger
		move.b	#id_frame_sball_spikeball,ost_frame(a0)	; use different frame

SBall_Move:	; Routine 2
		bsr.w	@movesub
		bra.w	@chkdel
; ===========================================================================

@movesub:
		move.w	ost_sball_speed(a0),d0
		add.w	d0,ost_angle(a0)
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		move.w	ost_sball_y_start(a0),d2
		move.w	ost_sball_x_start(a0),d3
		lea	ost_sball_child_count(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

	@loop:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_ost_all&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	ost_sball_radius(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a1)
		move.w	d5,ost_x_pos(a1)
		dbf	d6,@loop
		rts	
; ===========================================================================

@chkdel:
		out_of_range	@delete,ost_sball_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================

@delete:
		moveq	#0,d2
		lea	ost_sball_child_count(a0),a2
		move.b	(a2)+,d2

	@deleteloop:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#v_ost_all&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	DeleteChild
		dbf	d2,@deleteloop				; delete all pieces of chain

		rts	
; ===========================================================================

SBall_Display:	; Routine 4
		bra.w	DisplaySprite
