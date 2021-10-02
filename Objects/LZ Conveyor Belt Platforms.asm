; ---------------------------------------------------------------------------
; Object 63 - platforms	on a conveyor belt (LZ)
; ---------------------------------------------------------------------------

LabyrinthConvey:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LCon_Index(pc,d0.w),d1
		jsr	LCon_Index(pc,d1.w)
		out_of_range.s	loc_1236A,$30(a0)

LCon_Display:
		bra.w	DisplaySprite
; ===========================================================================

loc_1236A:
		cmpi.b	#2,(v_act).w
		bne.s	loc_12378
		cmpi.w	#-$80,d0
		bcc.s	LCon_Display

loc_12378:
		move.b	ost_lcon_subtype_copy(a0),d0
		bpl.w	DeleteObject
		andi.w	#$7F,d0
		lea	(v_obj63).w,a2
		bclr	#0,(a2,d0.w)
		bra.w	DeleteObject
; ===========================================================================
LCon_Index:	index *,,2
		ptr LCon_Main
		ptr loc_124B2
		ptr loc_124C2
		ptr LCon_AniWheel

ost_lcon_subtype_copy:	equ $2F	; copy of the initial subtype ($80/$81/etc.)

ost_lcon_reverse:	equ $3B	; 1 = conveyors run backwards
ost_lcon_corner_ptr:	equ $3C	; address of corner position data (4 bytes)
; ===========================================================================

LCon_Main:	; Routine 0
		move.b	ost_subtype(a0),d0
		bmi.w	LCon_LoadPlatforms ; branch if subtype is $80+
		addq.b	#2,ost_routine(a0)
		move.l	#Map_LConv,ost_mappings(a0)
		move.w	#tile_Nem_LzWheel+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		cmpi.b	#$7F,ost_subtype(a0) ; is object a wheel?
		bne.s	loc_123E2	; if not, branch
		addq.b	#4,ost_routine(a0)
		move.w	#tile_Nem_LzWheel,ost_tile(a0)
		move.b	#1,ost_priority(a0)
		bra.w	LCon_AniWheel
; ===========================================================================

loc_123E2:
		move.b	#id_frame_lcon_platform,ost_frame(a0) ; use plaform sprite
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype (not the same as initial subtype)
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0		; read high nybble of subtype
		lea	LCon_Data(pc),a2
		adda.w	(a2,d0.w),a2	; get address of corner data
		move.w	(a2)+,$39-1(a0)
		move.w	(a2)+,$30(a0)
		move.l	a2,ost_lcon_corner_ptr(a0)
		andi.w	#$F,d1		; read low nybble of subtype
		lsl.w	#2,d1		; multiply by 4
		move.b	d1,$38(a0)
		move.b	#4,$3A(a0)
		tst.b	(f_conveyrev).w	; is conveyor set to reverse?
		beq.s	loc_1244C	; if not, branch
		move.b	#1,ost_lcon_reverse(a0)
		neg.b	$3A(a0)
		moveq	#0,d1
		move.b	$38(a0),d1
		add.b	$3A(a0),d1
		cmp.b	$39(a0),d1
		bcs.s	loc_12448
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_12448
		move.b	$39(a0),d1
		subq.b	#4,d1

loc_12448:
		move.b	d1,$38(a0)

loc_1244C:
		move.w	(a2,d1.w),$34(a0)
		move.w	2(a2,d1.w),$36(a0)
		bsr.w	LCon_ChangeDir
		bra.w	loc_124B2
; ===========================================================================

LCon_LoadPlatforms:
		move.b	d0,ost_lcon_subtype_copy(a0)
		andi.w	#$7F,d0		; get low nybble of subtype
		lea	(v_obj63).w,a2
		bset	#0,(a2,d0.w)
		bne.w	DeleteObject
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosLZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2	; get address of platform position data
		move.w	(a2)+,d1	; get object count
		movea.l	a0,a1		; overwrite current object with 1st platform
		bra.s	@makefirst
; ===========================================================================

	@loop:
		bsr.w	FindFreeObj
		bne.s	@fail

	@makefirst:
		move.b	#id_LabyrinthConvey,0(a1) ; load platform object
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,ost_subtype(a1)

	@fail:
		dbf	d1,@loop	; repeat for number of objects

		addq.l	#4,sp
		rts	
; ===========================================================================

loc_124B2:	; Routine 2
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(DetectPlatform).l
		bra.w	sub_12502
; ===========================================================================

loc_124C2:	; Routine 4
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		jsr	(ExitPlatform).l
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	sub_12502
		move.w	(sp)+,d2
		jmp	(MoveWithPlatform2).l
; ===========================================================================

LCon_AniWheel:	; Routine 6
		move.w	(v_frame_counter).w,d0
		andi.w	#3,d0
		bne.s	loc_124FC
		moveq	#1,d1
		tst.b	(f_conveyrev).w
		beq.s	loc_124F2
		neg.b	d1

loc_124F2:
		add.b	d1,ost_frame(a0)
		andi.b	#3,ost_frame(a0)

loc_124FC:
		addq.l	#4,sp
		bra.w	RememberState

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_12502:
		tst.b	(f_switch+$E).w
		beq.s	loc_12520
		tst.b	ost_lcon_reverse(a0)
		bne.s	loc_12520
		move.b	#1,ost_lcon_reverse(a0)
		move.b	#1,(f_conveyrev).w
		neg.b	$3A(a0)
		bra.s	loc_12534
; ===========================================================================

loc_12520:
		move.w	ost_x_pos(a0),d0
		cmp.w	$34(a0),d0
		bne.s	loc_1256A
		move.w	ost_y_pos(a0),d0
		cmp.w	$36(a0),d0
		bne.s	loc_1256A

loc_12534:
		moveq	#0,d1
		move.b	$38(a0),d1
		add.b	$3A(a0),d1
		cmp.b	$39(a0),d1
		bcs.s	loc_12552
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_12552
		move.b	$39(a0),d1
		subq.b	#4,d1

loc_12552:
		move.b	d1,$38(a0)
		movea.l	ost_lcon_corner_ptr(a0),a1
		move.w	(a1,d1.w),$34(a0)
		move.w	2(a1,d1.w),$36(a0)
		bsr.w	LCon_ChangeDir

loc_1256A:
		bsr.w	SpeedToPos
		rts	
; End of function sub_12502


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LCon_ChangeDir:
		moveq	#0,d0
		move.w	#-$100,d2
		move.w	ost_x_pos(a0),d0
		sub.w	$34(a0),d0
		bcc.s	loc_12584
		neg.w	d0
		neg.w	d2

loc_12584:
		moveq	#0,d1
		move.w	#-$100,d3
		move.w	ost_y_pos(a0),d1
		sub.w	$36(a0),d1
		bcc.s	loc_12598
		neg.w	d1
		neg.w	d3

loc_12598:
		cmp.w	d0,d1
		bcs.s	loc_125C2
		move.w	ost_x_pos(a0),d0
		sub.w	$34(a0),d0
		beq.s	loc_125AE
		ext.l	d0
		asl.l	#8,d0
		divs.w	d1,d0
		neg.w	d0

loc_125AE:
		move.w	d0,ost_x_vel(a0)
		move.w	d3,ost_y_vel(a0)
		swap	d0
		move.w	d0,ost_x_sub(a0)
		clr.w	ost_y_sub(a0)
		rts	
; ===========================================================================

loc_125C2:
		move.w	ost_y_pos(a0),d1
		sub.w	$36(a0),d1
		beq.s	loc_125D4
		ext.l	d1
		asl.l	#8,d1
		divs.w	d0,d1
		neg.w	d1

loc_125D4:
		move.w	d1,ost_y_vel(a0)
		move.w	d2,ost_x_vel(a0)
		swap	d1
		move.w	d1,ost_y_sub(a0)
		clr.w	ost_x_sub(a0)
		rts	
; End of function LCon_ChangeDir

; ===========================================================================
LCon_Data:	index *
		ptr word_125F4
		ptr word_12610
		ptr word_12628
		ptr word_1263C
		ptr word_12650
		ptr word_12668
word_125F4:	dc.w $18, $1070		; act 1
		dc.w $1078, $21A
		dc.w $10BE, $260
		dc.w $10BE, $393
		dc.w $108C, $3C5
		dc.w $1022, $390
		dc.w $1022, $244
word_12610:	dc.w $14, $1280		; act 1
		dc.w $127E, $280
		dc.w $12CE, $2D0
		dc.w $12CE, $46E
		dc.w $1232, $420
		dc.w $1232, $2CC
word_12628:	dc.w $10, $D68		; act 2
		dc.w $D22, $482
		dc.w $D22, $5DE
		dc.w $DAE, $5DE
		dc.w $DAE, $482
word_1263C:	dc.w $10, $DA0		; act 2
		dc.w $D62, $3A2
		dc.w $DEE, $3A2
		dc.w $DEE, $4DE
		dc.w $D62, $4DE
word_12650:	dc.w $14, $D00		; act 3
		dc.w $CAC, $242
		dc.w $DDE, $242
		dc.w $DDE, $3DE
		dc.w $C52, $3DE
		dc.w $C52, $29C
word_12668:	dc.w $10, $1300		; act 3
		dc.w $1252, $20A
		dc.w $13DE, $20A
		dc.w $13DE, $2BE
		dc.w $1252, $2BE
