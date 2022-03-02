; ---------------------------------------------------------------------------
; Object 63 - platforms	on a conveyor belt (LZ)

; spawned by:
;	ObjPos_LZ1 - subtypes $7F (wheel), $80/$81
;	ObjPos_LZ2 - subtypes $7F (wheel), $82/$83
;	ObjPos_LZ3 - subtypes $7F (wheel), $84/$85
;	LabyrinthConvey - subtypes 0-$53
; ---------------------------------------------------------------------------

LabyrinthConvey:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LCon_Index(pc,d0.w),d1
		jsr	LCon_Index(pc,d1.w)
		out_of_range.s	LCon_ChkDel,ost_lcon_x_pos_centre(a0)

LCon_Display:
		bra.w	DisplaySprite
; ===========================================================================

LCon_ChkDel:
		cmpi.b	#2,(v_act).w				; is this act 3?
		bne.s	@not_act3				; if not, branch
		cmpi.w	#-$80,d0				; is object to the right?
		bcc.s	LCon_Display				; if yes, branch

	@not_act3:
		move.b	ost_lcon_subtype_copy(a0),d0		; get original subtype
		bpl.w	DeleteObject				; branch if not the parent object
		andi.w	#$7F,d0
		lea	(v_convey_init_list).w,a2
		bclr	#0,(a2,d0.w)
		bra.w	DeleteObject
; ===========================================================================
LCon_Index:	index *,,2
		ptr LCon_Main
		ptr LCon_Platform
		ptr LCon_OnPlatform
		ptr LCon_Wheel

ost_lcon_subtype_copy:	equ $2F					; copy of the initial subtype ($80/$81/etc.)
ost_lcon_x_pos_centre:	equ $30					; approximate x position of centre of conveyor (2 bytes)
ost_lcon_corner_x_pos:	equ $34					; x position of next corner (2 bytes)
ost_lcon_corner_y_pos:	equ $36					; y position of next corner (2 bytes)
ost_lcon_corner_next:	equ $38					; index of next corner
ost_lcon_corner_count:	equ $39					; total number of corners +1, times 4
ost_lcon_corner_inc:	equ $3A					; amount to add to corner index (4 or -4)
ost_lcon_reverse:	equ $3B					; 1 = conveyors run backwards
ost_lcon_corner_ptr:	equ $3C					; address of corner position data (4 bytes)
; ===========================================================================

LCon_Main:	; Routine 0
		move.b	ost_subtype(a0),d0
		bmi.w	LCon_LoadPlatforms			; branch if subtype is $80+
		addq.b	#2,ost_routine(a0)			; goto LCon_Platform next
		move.l	#Map_LConv,ost_mappings(a0)
		move.w	#tile_Nem_LzWheel+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		cmpi.b	#type_lcon_wheel,ost_subtype(a0)	; is object a wheel? ($7F)
		bne.s	LCon_Platform_Init			; if not, branch
		
		addq.b	#4,ost_routine(a0)			; goto LCon_Wheel next
		move.w	#tile_Nem_LzWheel,ost_tile(a0)
		move.b	#1,ost_priority(a0)
		bra.w	LCon_Wheel
; ===========================================================================

LCon_Platform_Init:
		move.b	#id_frame_lcon_platform,ost_frame(a0)	; use plaform sprite
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (not the same as initial subtype)
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0					; read high nybble of subtype
		lea	LCon_Corner_Data(pc),a2
		adda.w	(a2,d0.w),a2				; get address of corner data
		move.w	(a2)+,ost_lcon_corner_count-1(a0)	; get corner count
		move.w	(a2)+,ost_lcon_x_pos_centre(a0)
		move.l	a2,ost_lcon_corner_ptr(a0)		; pointer to corner x/y values
		andi.w	#$F,d1					; read low nybble of subtype
		lsl.w	#2,d1					; multiply by 4
		move.b	d1,ost_lcon_corner_next(a0)
		move.b	#4,ost_lcon_corner_inc(a0)
		tst.b	(f_convey_reverse).w			; is conveyor set to reverse?
		beq.s	@no_reverse				; if not, branch
		
		move.b	#1,ost_lcon_reverse(a0)
		neg.b	ost_lcon_corner_inc(a0)
		moveq	#0,d1
		move.b	ost_lcon_corner_next(a0),d1
		add.b	ost_lcon_corner_inc(a0),d1
		cmp.b	ost_lcon_corner_count(a0),d1		; is next corner valid?
		bcs.s	@is_valid				; if yes, branch
		move.b	d1,d0
		moveq	#0,d1					; reset corner counter to 0
		tst.b	d0
		bpl.s	@is_valid
		move.b	ost_lcon_corner_count(a0),d1
		subq.b	#4,d1

	@is_valid:
		move.b	d1,ost_lcon_corner_next(a0)		; update corner counter

	@no_reverse:
		move.w	(a2,d1.w),ost_lcon_corner_x_pos(a0)	; get corner position data
		move.w	2(a2,d1.w),ost_lcon_corner_y_pos(a0)
		bsr.w	LCon_Platform_Move			; begin platform moving
		bra.w	LCon_Platform
; ===========================================================================

LCon_LoadPlatforms:
		move.b	d0,ost_lcon_subtype_copy(a0)
		andi.w	#$7F,d0					; d0 = bits 0-6 of subtype
		lea	(v_convey_init_list).w,a2
		bset	#0,(a2,d0.w)				; set flag to indicate object exists
		bne.w	DeleteObject				; delete now if already set
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosLZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2				; get address of platform position data
		move.w	(a2)+,d1				; get object count
		movea.l	a0,a1					; overwrite current object with 1st platform
		bra.s	@makefirst
; ===========================================================================

	@loop:
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found

	@makefirst:
		move.b	#id_LabyrinthConvey,ost_id(a1)		; load platform object
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,ost_subtype(a1)

	@fail:
		dbf	d1,@loop				; repeat for number of objects

		addq.l	#4,sp
		rts	
; ===========================================================================

LCon_Platform:	; Routine 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(DetectPlatform).l			; goto LCon_OnPlatform next if Sonic stands on platform
		bra.w	LCon_Platform_Update
; ===========================================================================

LCon_OnPlatform:
		; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	LCon_Platform_Update
		move.w	(sp)+,d2
		jmp	(MoveWithPlatform2).l
; ===========================================================================

LCon_Wheel:	; Routine 6
		move.w	(v_frame_counter).w,d0			; get synchronised frame counter
		andi.w	#3,d0					; read only bits 0-1 (max. 4 frames)
		bne.s	@frame_not_0				; branch if not 0
		moveq	#1,d1
		tst.b	(f_convey_reverse).w			; is conveyor running in reverse?
		beq.s	@no_reverse				; if not, branch
		neg.b	d1					; reverse animation

	@no_reverse:
		add.b	d1,ost_frame(a0)			; increment or decrement frame
		andi.b	#3,ost_frame(a0)

	@frame_not_0:
		addq.l	#4,sp
		bra.w	DespawnObj

; ---------------------------------------------------------------------------
; Subroutine to get next corner coordinates and update platform position
; ---------------------------------------------------------------------------

LCon_Platform_Update:
		tst.b	(v_button_state+$E).w			; has button $E been pressed?
		beq.s	@no_reverse				; if not, branch
		tst.b	ost_lcon_reverse(a0)			; is reverse flag already set?
		bne.s	@no_reverse				; if yes, branch
		move.b	#1,ost_lcon_reverse(a0)			; set local flag
		move.b	#1,(f_convey_reverse).w			; set global flag
		neg.b	ost_lcon_corner_inc(a0)
		bra.s	@next_corner
; ===========================================================================

@no_reverse:
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_lcon_corner_x_pos(a0),d0		; is platform at corner?
		bne.s	@not_at_corner				; if not, branch
		move.w	ost_y_pos(a0),d0
		cmp.w	ost_lcon_corner_y_pos(a0),d0
		bne.s	@not_at_corner

@next_corner:
		moveq	#0,d1
		move.b	ost_lcon_corner_next(a0),d1
		add.b	ost_lcon_corner_inc(a0),d1
		cmp.b	ost_lcon_corner_count(a0),d1		; is next corner valid?
		bcs.s	@is_valid				; if yes, branch
		move.b	d1,d0
		moveq	#0,d1					; reset corner counter to 0
		tst.b	d0
		bpl.s	@is_valid
		move.b	ost_lcon_corner_count(a0),d1
		subq.b	#4,d1

	@is_valid:
		move.b	d1,ost_lcon_corner_next(a0)
		movea.l	ost_lcon_corner_ptr(a0),a1
		move.w	(a1,d1.w),ost_lcon_corner_x_pos(a0)
		move.w	2(a1,d1.w),ost_lcon_corner_y_pos(a0)
		bsr.w	LCon_Platform_Move

	@not_at_corner:
		bsr.w	SpeedToPos
		rts	
; End of function LCon_Platform_Update

; ---------------------------------------------------------------------------
; Subroutine to set direction and speed of platform
; ---------------------------------------------------------------------------

LCon_Platform_Move:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	ost_x_pos(a0),d0
		sub.w	ost_lcon_corner_x_pos(a0),d0		; d0 = x distance between platform & corner
		bcc.s	@is_right				; branch if +ve (platform is right of corner)
		neg.w	d0					; make d0 +ve
		neg.w	d2					; d2 = $100

	@is_right:
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	ost_y_pos(a0),d1
		sub.w	ost_lcon_corner_y_pos(a0),d1		; d1 = y distance between platform & corner
		bcc.s	@is_below				; branch if +ve (platform is below corner)
		neg.w	d1					; make d1 +ve
		neg.w	d3					; d3 = $100

	@is_below:
		cmp.w	d0,d1					; is platform nearer corner on y axis?
		bcs.s	@nearer_y				; if yes, branch
		move.w	ost_x_pos(a0),d0
		sub.w	ost_lcon_corner_x_pos(a0),d0		; d0 = x distance between platform & corner
		beq.s	@match_x				; branch if 0
		ext.l	d0
		asl.l	#8,d0					; multiply by $100
		divs.w	d1,d0					; divide by y distance
		neg.w	d0

	@match_x:
		move.w	d0,ost_x_vel(a0)
		move.w	d3,ost_y_vel(a0)
		swap	d0
		move.w	d0,ost_x_sub(a0)
		clr.w	ost_y_sub(a0)
		rts	
; ===========================================================================

@nearer_y:
		move.w	ost_y_pos(a0),d1
		sub.w	ost_lcon_corner_y_pos(a0),d1
		beq.s	@match_y
		ext.l	d1
		asl.l	#8,d1
		divs.w	d0,d1
		neg.w	d1

	@match_y:
		move.w	d1,ost_y_vel(a0)
		move.w	d2,ost_x_vel(a0)
		swap	d1
		move.w	d1,ost_y_sub(a0)
		clr.w	ost_x_sub(a0)
		rts	
; End of function LCon_Platform_Move

; ===========================================================================
LCon_Corner_Data:
		index *
		ptr LCon_Corners_0
		ptr LCon_Corners_1
		ptr LCon_Corners_2
		ptr LCon_Corners_3
		ptr LCon_Corners_4
		ptr LCon_Corners_5
LCon_Corners_0:	dc.w @end-(*+4)					; act 1
		dc.w $1070
		dc.w $1078, $21A
		dc.w $10BE, $260
		dc.w $10BE, $393
		dc.w $108C, $3C5
		dc.w $1022, $390
		dc.w $1022, $244
	@end:

LCon_Corners_1:	dc.w @end-(*+4)					; act 1
		dc.w $1280
		dc.w $127E, $280
		dc.w $12CE, $2D0
		dc.w $12CE, $46E
		dc.w $1232, $420
		dc.w $1232, $2CC
	@end:

LCon_Corners_2:	dc.w @end-(*+4)					; act 2
		dc.w $D68
		dc.w $D22, $482
		dc.w $D22, $5DE
		dc.w $DAE, $5DE
		dc.w $DAE, $482
	@end:

LCon_Corners_3:	dc.w @end-(*+4)					; act 2
		dc.w $DA0
		dc.w $D62, $3A2
		dc.w $DEE, $3A2
		dc.w $DEE, $4DE
		dc.w $D62, $4DE
	@end:

LCon_Corners_4:	dc.w @end-(*+4)					; act 3
		dc.w $D00
		dc.w $CAC, $242
		dc.w $DDE, $242
		dc.w $DDE, $3DE
		dc.w $C52, $3DE
		dc.w $C52, $29C
	@end:

LCon_Corners_5:	dc.w @end-(*+4)					; act 3
		dc.w $1300
		dc.w $1252, $20A
		dc.w $13DE, $20A
		dc.w $13DE, $2BE
		dc.w $1252, $2BE
	@end:
