; ---------------------------------------------------------------------------
; Object 59 - platforms	that move when you stand on them (SLZ)
; ---------------------------------------------------------------------------

Elevator:
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

Elev_Var1:	dc.b $28, 0					; width, frame number

Elev_Var2:							; distance to move, action type
Elev_Var2_0:	dc.b $10, id_Elev_Up
Elev_Var2_1:	dc.b $20, id_Elev_Up
Elev_Var2_2:	dc.b $34, id_Elev_Up				; unused
Elev_Var2_3:	dc.b $10, id_Elev_Down
Elev_Var2_4:	dc.b $20, id_Elev_Down				; unused
Elev_Var2_5:	dc.b $34, id_Elev_Down				; unused
Elev_Var2_6:	dc.b $14, id_Elev_Up				; unused
Elev_Var2_7:	dc.b $24, id_Elev_Up				; unused
Elev_Var2_8:	dc.b $2C, id_Elev_Up				; unused
Elev_Var2_9:	dc.b $14, id_Elev_Down				; unused
Elev_Var2_A:	dc.b $24, id_Elev_Down				; unused
Elev_Var2_B:	dc.b $2C, id_Elev_Down				; unused
Elev_Var2_C:	dc.b $20, id_Elev_UpRight
Elev_Var2_D:	dc.b $20, id_Elev_DownLeft			; unused
Elev_Var2_E:	dc.b $30, id_Elev_UpVanish

sizeof_Elev_Var2:	equ Elev_Var2_1-Elev_Var2

ost_elev_y_start:	equ $30					; original y-axis position (2 bytes)
ost_elev_x_start:	equ $32					; original x-axis position (2 bytes)
ost_elev_moved:		equ $34					; distance moved (2 bytes)
ost_elev_acceleration:	equ $38					; acceleration - i.e. its movement is not linear (2 bytes)
ost_elev_dec_flag:	equ $3A					; 1 = decelerate
ost_elev_distance:	equ $3C					; distance to move (2 bytes)
ost_elev_dist_master:	equ $3E					; master copy of ost_elev_distance (2 bytes)
; ===========================================================================

Elev_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		bpl.s	@normal					; branch for types 00-7F
		addq.b	#4,ost_routine(a0)			; goto Elev_MakeMulti next
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
		move.b	(a2)+,ost_actwidth(a0)			; set width
		move.b	(a2)+,ost_frame(a0)			; set frame
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	Elev_Var2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,ost_elev_distance(a0)		; set distance to move
		move.b	(a2)+,ost_subtype(a0)			; set type
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
		tst.b	ost_id(a0)
		beq.s	@deleted
		jmp	(MoveWithPlatform2).l

	@deleted:
		rts	
; ===========================================================================

Elev_Types:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; subtype has changed by now, see Elev_Var2
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	Elev_Type_Index(pc,d0.w),d1
		jmp	Elev_Type_Index(pc,d1.w)
; ===========================================================================
Elev_Type_Index:
		index *
		ptr Elev_Still					; 0 - doesn't move
		ptr Elev_Up					; 1 - rises when stood on
		ptr Elev_Up_Now	
		ptr Elev_Down					; 3 - falls when stood on
		ptr Elev_Down_Now
		ptr Elev_UpRight				; 5 - rises diagonally when stood on
		ptr Elev_UpRight_Now
		ptr Elev_DownLeft				; 7 - falls diagonally when stood on
		ptr Elev_DownLeft_Now
		ptr Elev_UpVanish				; 9 - rises and vanishes
; ===========================================================================

Elev_Still:
		rts	
; ===========================================================================

; Moves when stood on - serves types 1, 3, 5 and 7
Elev_Up:
Elev_Down:
Elev_UpRight:
Elev_DownLeft:
		cmpi.b	#4,ost_routine(a0)			; check if Sonic is standing on the object
		bne.s	@notstanding
		addq.b	#1,ost_subtype(a0)			; if yes, add 1 to type (goes to 2, 4, 6 or 8)

	@notstanding:
		rts	
; ===========================================================================

; Type 2
Elev_Up_Now:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		neg.w	d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; ===========================================================================

; Type 4
Elev_Down_Now:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; ===========================================================================

; Type 6
Elev_UpRight_Now:
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

; Type 8
Elev_DownLeft_Now:
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

; Type 9
Elev_UpVanish:
		bsr.w	Elev_Move
		move.w	ost_elev_moved(a0),d0
		neg.w	d0
		add.w	ost_elev_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		tst.b	ost_subtype(a0)				; has platform reached destination?
		beq.w	@typereset				; if yes, branch
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
		move.b	#id_Elevator,ost_id(a1)			; duplicate the object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#type_elev_up_vanish_1,ost_subtype(a1)

@chkdel:
		addq.l	#4,sp
		out_of_range	DeleteObject
		rts	
