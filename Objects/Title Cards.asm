; ---------------------------------------------------------------------------
; Object 34 - zone title cards

; spawned by:
;	GM_Level, TitleCard
; ---------------------------------------------------------------------------

TitleCard:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Card_Index(pc,d0.w),d1
		jmp	Card_Index(pc,d1.w)
; ===========================================================================
Card_Index:	index *,,2
		ptr Card_Main
		ptr Card_Move
		ptr Card_Wait
		ptr Card_Wait

		rsobj TitleCard,$30
ost_card_x_stop:	rs.w 1					; $30 ; on screen x position
ost_card_x_start:	rs.w 1					; $32 ; start & finish x position
		rsobjend

include_Card_Data:	macro
Card_ItemData:	; y position, routine number, frame number
		dc.w $D0
		dc.b id_Card_Move, id_frame_card_ghz		; zone name (frame number changes)
		dc.w $E4
		dc.b id_Card_Move, id_frame_card_zone		; "ZONE"
		dc.w $EA
		dc.b id_Card_Move, id_frame_card_act1		; act number (frame number changes)
		dc.w $E0
		dc.b id_Card_Move, id_frame_card_oval		; oval

Card_PosData:	; x pos start, x pos stop
		dc.w 0,	$120					; GREEN HILL
		dc.w -$104, $13C				; ZONE
		dc.w $414, $154					; ACT x
		dc.w $214, $154					; oval
		dc.w 0,	$120					; LABYRINTH
		dc.w -$10C, $134
		dc.w $40C, $14C
		dc.w $20C, $14C
		dc.w 0,	$120					; MARBLE
		dc.w -$120, $120
		dc.w $3F8, $138
		dc.w $1F8, $138
		dc.w 0,	$120					; STAR LIGHT
		dc.w -$104, $13C
		dc.w $414, $154
		dc.w $214, $154
		dc.w 0,	$120					; SPRING YARD
		dc.w -$FC, $144
		dc.w $41C, $15C
		dc.w $21C, $15C
		dc.w 0,	$120					; SCRAP BRAIN
		dc.w -$FC, $144
		dc.w $41C, $15C
		dc.w $21C, $15C
		dc.w 0,	$120					; FINAL
		dc.w -$11C, $124
		dc.w $3EC, $3EC
		dc.w $1EC, $12C
		endm
; ===========================================================================

Card_Main:	; Routine 0
		movea.l	a0,a1					; replace current object with 1st item in list
		moveq	#0,d0
		move.b	(v_zone).w,d0
		cmpi.w	#id_SBZ_act3,(v_zone).w			; check if level is SBZ3
		bne.s	@not_sbz3				; if not, branch
		moveq	#5,d0					; load title card number 5 (SBZ)

	@not_sbz3:
		move.w	d0,d2
		cmpi.w	#id_FZ,(v_zone).w			; check if level is FZ
		bne.s	@not_fz					; if not, branch
		moveq	#6,d0					; load title card number 6 (FZ)
		moveq	#id_frame_card_fz,d2			; use "FINAL" frame ($B)

	@not_fz:
		lea	(Card_PosData).l,a3			; x/y pos data for all items
		lsl.w	#4,d0					; multiply zone by 8
		adda.w	d0,a3					; jump to relevant data
		lea	(Card_ItemData).l,a2			; y pos/routine/frame for each item
		moveq	#4-1,d1					; there are 4 items (minus 1 for 1st loop)

@loop:
		move.b	#id_TitleCard,ost_id(a1)
		move.w	(a3),ost_x_pos(a1)			; set initial x position
		move.w	(a3)+,ost_card_x_start(a1)
		move.w	(a3)+,ost_card_x_stop(a1)		; set target x position
		move.w	(a2)+,ost_y_screen(a1)			; set y position
		move.b	(a2)+,ost_routine(a1)			; goto Card_Move next
		move.b	(a2)+,d0				; set frame number
		bne.s	@not_ghz				; branch if not 0 (GREEN HILL)
		move.b	d2,d0					; use zone number instead (or $B for FZ)

	@not_ghz:
		cmpi.b	#id_frame_card_act1,d0			; is sprite the act number?
		bne.s	@not_act				; if not, branch
		add.b	(v_act).w,d0				; add act number to frame
		cmpi.b	#3,(v_act).w				; is this act 4? (SBZ3 only)
		bne.s	@not_act				; if not, branch
		subq.b	#1,d0					; use act 3 frame if act 4 (for SBZ3)

	@not_act:
		move.b	d0,ost_frame(a1)			; display frame number d0
		move.l	#Map_Card,ost_mappings(a1)
		move.w	#tile_Nem_TitleCard+tile_hi,ost_tile(a1)
		move.b	#$78,ost_displaywidth(a1)
		move.b	#render_abs,ost_render(a1)
		move.b	#0,ost_priority(a1)
		move.w	#60,ost_anim_time(a1)			; set time delay to 1 second
		lea	sizeof_ost(a1),a1			; next object
		dbf	d1,@loop				; repeat sequence 3 times

Card_Move:	; Routine 2
		moveq	#$10,d1					; set to move 16px right
		move.w	ost_card_x_stop(a0),d0
		cmp.w	ost_x_pos(a0),d0			; has item reached the target position?
		beq.s	@at_target				; if yes, branch
		bge.s	@is_left				; branch if item is left of target
		neg.w	d1					; move left instead

	@is_left:
		add.w	d1,ost_x_pos(a0)			; update position

	@at_target:
		move.w	ost_x_pos(a0),d0
		bmi.s	@no_display				; branch if item is outside left of screen
		cmpi.w	#$200,d0				; is item right of $200 on x-axis?
		bcc.s	@no_display				; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

@no_display:
		rts	
; ===========================================================================

Card_Wait:	; Routine 4/6
		; title cards are instructed to jump here by GM_Level
		tst.w	ost_anim_time(a0)			; has timer hit 0?
		beq.s	Card_MoveBack				; if yes, branch
		subq.w	#1,ost_anim_time(a0)			; decrement timer
		bra.w	DisplaySprite
; ===========================================================================

Card_MoveBack:
		tst.b	ost_render(a0)				; is item on-screen?
		bpl.s	Card_ChangeArt				; if not, branch

		moveq	#$20,d1					; set to move 32px right
		move.w	ost_card_x_start(a0),d0
		cmp.w	ost_x_pos(a0),d0			; has item reached the finish position?
		beq.s	Card_ChangeArt				; if yes, branch
		bge.s	@is_left				; branch if item is left of target
		neg.w	d1					; move left instead

	@is_left:
		add.w	d1,ost_x_pos(a0)			; update position
		move.w	ost_x_pos(a0),d0
		bmi.s	@no_display				; branch if item is outside left of screen
		cmpi.w	#$200,d0				; is item right of $200 on x-axis?
		bcc.s	@no_display				; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

@no_display:
		rts	
; ===========================================================================

Card_ChangeArt:
		cmpi.b	#id_Card_Wait,ost_routine(a0)		; is this the main object? (routine 4)
		bne.s	@delete					; if not, branch

		moveq	#id_PLC_Explode,d0
		jsr	(AddPLC).l				; load explosion gfx
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#id_PLC_GHZAnimals,d0
		jsr	(AddPLC).l				; load animal gfx

	@delete:
		bra.w	DeleteObject
; ===========================================================================
		include_Card_Data
