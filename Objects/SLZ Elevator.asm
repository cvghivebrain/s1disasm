; ---------------------------------------------------------------------------
; Object 59 - platforms	that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Elev_Index(pc,d0.w),d1
		jsr	Elev_Index(pc,d1.w)
		out_of_range	DeleteObject,ost_elev_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================
Elev_Index:	index *,,2
		ptr Elev_Main
		ptr Elev_Platform
		ptr Elev_Action
		ptr Elev_MakeMulti

Elev_Var1:	dc.b $28, 0		; width, frame number

Elev_Var2:	dc.b $10, 1		; distance to move, action type
		dc.b $20, 1
		dc.b $34, 1
		dc.b $10, 3
		dc.b $20, 3
		dc.b $34, 3
		dc.b $14, 1
		dc.b $24, 1
		dc.b $2C, 1
		dc.b $14, 3
		dc.b $24, 3
		dc.b $2C, 3
		dc.b $20, 5
		dc.b $20, 7
		dc.b $30, 9

ost_elev_y_start:	equ $30	; original y-axis position (2 bytes)
ost_elev_x_start:	equ $32	; original x-axis position (2 bytes)
ost_elev_moved:		equ $34	; distance moved (2 bytes)
ost_elev_acceleration:	equ $38	; acceleration - i.e. its movement is not linear (2 bytes)
ost_elev_dec_flag:	equ $3A	; 1 = decelerate
ost_elev_distance:	equ $3C	; distance to move (2 bytes)
ost_elev_dist_master:	equ $3E	; master copy of ost_elev_distance (2 bytes)
; ===========================================================================

Elev_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		bpl.s	@normal		; branch for types 00-7F
		addq.b	#4,ost_routine(a0) ; goto Elev_MakeMulti next
		andi.w	#$7F,d0
		mulu.w	#6,d0
		move.w	d0,ost_elev_distance(a0)
		move.w	d0,ost_elev_dist_master(a0)
		addq.l	#4,sp
		rts	
; ===========================================================================

	@normal:
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	Elev_Var1(pc,d0.w),a2
		move.b	(a2)+,ost_actwidth(a0) ; set width
		move.b	(a2)+,ost_frame(a0) ; set frame
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	Elev_Var2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,ost_elev_distance(a0) ; set distance to move
		move.b	(a2)+,ost_subtype(a0)	; set type
		move.l	#Map_Elev,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_elev_x_start(a0)
		move.w	ost_y_pos(a0),ost_elev_y_start(a0)

Elev_Platform:	; Routine 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(DetectPlatform).l
		bra.w	Elev_Types
; ===========================================================================

Elev_Action:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	Elev_Types
		move.w	(sp)+,d2
		tst.b	0(a0)
		beq.s	@deleted
		jmp	(MoveWithPlatform2).l

	@deleted:
		rts	
; ===========================================================================

Elev_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; subtype has changed by now, see Elev_Var2
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jmp	@index(pc,d1.w)
; ===========================================================================
@index:		index *
		ptr @type00	; doesn't move
		ptr @type01	; rises when stood on
		ptr @type02	
		ptr @type01	; falls when stood on
		ptr @type04
		ptr @type01	; rises diagonally when stood on
		ptr @type06
		ptr @type01	; falls diagonally when stood on
		ptr @type08
		ptr @type09	; rises and vanishes
; ===========================================================================

@type00:
		rts	
; ===========================================================================

; Moves when stood on - serves types 1, 3, 5 and 7
@type01:
		cmpi.b	#4,ost_routine(a0) ; check if Sonic is standing on the object
		bne.s	@notstanding
		addq.b	#1,ost_subtype(a0) ; if yes, add 1 to type (goes to 2, 4, 6 or 8)

	@notstanding:
		rts	
; ===========================================================================

@type02:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		neg.w	d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; ===========================================================================

@type04:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; ===========================================================================

@type06:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		asr.w	#1,d0
		neg.w	d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		move.w	ost_elev_moved(a0),d0
		add.w	ost_elev_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		rts	
; ===========================================================================

@type08:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		asr.w	#1,d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		move.w	ost_elev_moved(a0),d0
		neg.w	d0
		add.w	ost_elev_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		rts	
; ===========================================================================

@type09:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		neg.w	d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		tst.b	ost_subtype(a0)
		beq.w	@typereset
		rts	
; ===========================================================================

	@typereset:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	@delete
		bset	#status_air_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a1)
		move.b	#id_Sonic_Control,ost_routine(a1)

	@delete:
		bra.w	DeleteObject

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Elev_Move:
		move.w	ost_elev_acceleration(a0),d0
		tst.b	ost_elev_dec_flag(a0)
		bne.s	loc_10CC8
		cmpi.w	#$800,d0
		bcc.s	loc_10CD0
		addi.w	#$10,d0
		bra.s	loc_10CD0
; ===========================================================================

loc_10CC8:
		tst.w	d0
		beq.s	loc_10CD0
		subi.w	#$10,d0

loc_10CD0:
		move.w	d0,ost_elev_acceleration(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	ost_elev_moved(a0),d0
		move.l	d0,ost_elev_moved(a0)
		swap	d0
		move.w	ost_elev_distance(a0),d2
		cmp.w	d2,d0
		bls.s	loc_10CF0
		move.b	#1,ost_elev_dec_flag(a0)

loc_10CF0:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_10CFA
		clr.b	ost_subtype(a0)

locret_10CFA:
		rts	
; End of function Elev_Move

; ===========================================================================

Elev_MakeMulti:	; Routine 6
		subq.w	#1,ost_elev_distance(a0)
		bne.s	@chkdel
		move.w	ost_elev_dist_master(a0),ost_elev_distance(a0)
		bsr.w	FindFreeObj
		bne.s	@chkdel
		move.b	#id_Elevator,0(a1) ; duplicate the object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#$E,ost_subtype(a1)

@chkdel:
		addq.l	#4,sp
		out_of_range	DeleteObject
		rts	
