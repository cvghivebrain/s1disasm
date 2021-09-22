; ---------------------------------------------------------------------------
; Object 34 - zone title cards
; ---------------------------------------------------------------------------

TitleCard:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Card_Index(pc,d0.w),d1
		jmp	Card_Index(pc,d1.w)
; ===========================================================================
Card_Index:	index *,,2
		ptr Card_CheckSBZ3
		ptr Card_ChkPos
		ptr Card_Wait
		ptr Card_Wait

ost_card_x_stop:	equ $30	; on screen x position (2 bytes)
ost_card_x_start:	equ $32	; start & finish x position (2 bytes)
; ===========================================================================

Card_CheckSBZ3:	; Routine 0
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; check if level is SBZ 3
		bne.s	Card_CheckFZ
		moveq	#5,d0		; load title card number 5 (SBZ)

	Card_CheckFZ:
		move.w	d0,d2
		cmpi.w	#(id_SBZ<<8)+2,(v_zone).w ; check if level is FZ
		bne.s	Card_LoadConfig
		moveq	#6,d0		; load title card number 6 (FZ)
		moveq	#$B,d2		; use "FINAL" mappings

	Card_LoadConfig:
		lea	(Card_PosData).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(Card_ItemData).l,a2
		moveq	#3,d1

Card_Loop:
		move.b	#id_TitleCard,0(a1)
		move.w	(a3),ost_x_pos(a1) ; load start x position
		move.w	(a3)+,ost_card_x_start(a1) ; load finish x position (same as start)
		move.w	(a3)+,ost_card_x_stop(a1) ; load main x position
		move.w	(a2)+,ost_y_screen(a1) ; load y position
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,d0	; load frame number
		bne.s	Card_ActNumber	; branch if not 0
		move.b	d2,d0		; use zone number instead (or $B for FZ)

	Card_ActNumber:
		cmpi.b	#7,d0		; is sprite the act number?
		bne.s	Card_MakeSprite	; if not, branch
		add.b	(v_act).w,d0	; add act number to frame
		cmpi.b	#3,(v_act).w
		bne.s	Card_MakeSprite
		subq.b	#1,d0		; use act 3 frame if act 4 (for SBZ3)

	Card_MakeSprite:
		move.b	d0,ost_frame(a1) ; display frame number d0
		move.l	#Map_Card,ost_mappings(a1)
		move.w	#tile_Nem_TitleCard+tile_hi,ost_tile(a1)
		move.b	#$78,ost_actwidth(a1)
		move.b	#render_abs,ost_render(a1)
		move.b	#0,ost_priority(a1)
		move.w	#60,ost_anim_time(a1) ; set time delay to 1 second
		lea	$40(a1),a1	; next object
		dbf	d1,Card_Loop	; repeat sequence another 3 times

Card_ChkPos:	; Routine 2
		moveq	#$10,d1		; set horizontal speed
		move.w	ost_card_x_stop(a0),d0
		cmp.w	ost_x_pos(a0),d0 ; has item reached the target position?
		beq.s	Card_NoMove	; if yes, branch
		bge.s	Card_Move
		neg.w	d1

Card_Move:
		add.w	d1,ost_x_pos(a0) ; change item's position

Card_NoMove:
		move.w	ost_x_pos(a0),d0
		bmi.s	locret_C3D8
		cmpi.w	#$200,d0	; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C3D8	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_C3D8:
		rts	
; ===========================================================================

Card_Wait:	; Routine 4/6
		tst.w	ost_anim_time(a0) ; is time remaining zero?
		beq.s	Card_ChkPos2	; if yes, branch
		subq.w	#1,ost_anim_time(a0) ; subtract 1 from time
		bra.w	DisplaySprite
; ===========================================================================

Card_ChkPos2:
		tst.b	ost_render(a0)
		bpl.s	Card_ChangeArt
		moveq	#$20,d1
		move.w	ost_card_x_start(a0),d0
		cmp.w	ost_x_pos(a0),d0 ; has item reached the finish position?
		beq.s	Card_ChangeArt	; if yes, branch
		bge.s	Card_Move2
		neg.w	d1

Card_Move2:
		add.w	d1,ost_x_pos(a0) ; change item's position
		move.w	ost_x_pos(a0),d0
		bmi.s	locret_C412
		cmpi.w	#$200,d0	; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C412	; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_C412:
		rts	
; ===========================================================================

Card_ChangeArt:
		cmpi.b	#id_Card_Wait,ost_routine(a0)
		bne.s	Card_Delete
		moveq	#id_PLC_Explode,d0
		jsr	(AddPLC).l	; load explosion patterns
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#id_PLC_GHZAnimals,d0
		jsr	(AddPLC).l	; load animal patterns

Card_Delete:
		bra.w	DeleteObject
; ===========================================================================
Card_ItemData:	; y position, routine number, frame number
		dc.w $D0
		dc.b id_Card_ChkPos, id_frame_card_ghz	; zone name (frame number changes)
		dc.w $E4
		dc.b id_Card_ChkPos, id_frame_card_zone	; "ZONE"
		dc.w $EA
		dc.b id_Card_ChkPos, id_frame_card_act1	; act number (frame number changes)
		dc.w $E0
		dc.b id_Card_ChkPos, id_frame_card_oval	; oval
; ---------------------------------------------------------------------------
; Title	card configuration data
; Format:
; 4 bytes per item (YYYY XXXX)
; 4 items per level (GREEN HILL, ZONE, ACT X, oval)
; ---------------------------------------------------------------------------
Card_PosData:	dc.w 0,	$120, -$104, $13C, $414, $154, $214, $154 ; GHZ
		dc.w 0,	$120, -$10C, $134, $40C, $14C, $20C, $14C ; LZ
		dc.w 0,	$120, -$120, $120, $3F8, $138, $1F8, $138 ; MZ
		dc.w 0,	$120, -$104, $13C, $414, $154, $214, $154 ; SLZ
		dc.w 0,	$120, -$FC, $144, $41C, $15C, $21C, $15C ; SYZ
		dc.w 0,	$120, -$FC, $144, $41C, $15C, $21C, $15C ; SBZ
		dc.w 0,	$120, -$11C, $124, $3EC, $3EC, $1EC, $12C ; FZ
