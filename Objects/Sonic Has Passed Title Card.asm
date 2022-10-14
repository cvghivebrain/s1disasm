; ---------------------------------------------------------------------------
; Object 3A - "SONIC HAS PASSED" title card

; spawned by:
;	Signpost, HasPassedCard
; ---------------------------------------------------------------------------

HasPassedCard:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Has_Index(pc,d0.w),d1
		jmp	Has_Index(pc,d1.w)
; ===========================================================================
Has_Index:	index offset(*),,2
		ptr Has_Main
		ptr Has_Move
		ptr Has_Wait
		ptr Has_Bonus
		ptr Has_Wait
		ptr Has_NextLevel
		ptr Has_Wait
		ptr Has_MoveBack
		ptr Has_Boundary

		rsobj HasPassedCard,$30
ost_has_x_stop:		rs.w 1					; $30 ; on screen x position
ost_has_x_start:	rs.w 1					; $32 ; start & finish x position
		rsobjend

include_Has_Config:	macro
		; x pos start, x pos stop, y pos
		; routine, frame
Has_Config:	dc.w 4, $124, $BC				; "SONIC HAS"
		dc.b id_Has_Move, id_frame_has_sonichas

		dc.w -$120, $120, $D0				; "PASSED"
		dc.b id_Has_Move, id_frame_has_passed

		dc.w $40C, $14C, $D6				; "ACT" 1/2/3
		dc.b id_Has_Move, id_frame_card_act1_6

		dc.w $520, $120, $EC				; score
		dc.b id_Has_Move, id_frame_has_score

		dc.w $540, $120, $FC				; time bonus
		dc.b id_Has_Move, id_frame_has_timebonus

		dc.w $560, $120, $10C				; ring bonus
		dc.b id_Has_Move, id_frame_has_ringbonus

		dc.w $20C, $14C, $CC				; oval
		dc.b id_Has_Move, id_frame_card_oval_5
		endm
; ===========================================================================

Has_Main:	; Routine 0
		tst.l	(v_plc_buffer).w			; are the pattern load cues empty?
		beq.s	.plc_free				; if yes, branch
		rts	
; ===========================================================================

.plc_free:
		movea.l	a0,a1					; replace current object with 1st from list
		lea	(Has_Config).l,a2			; position, routine & frame settings
		moveq	#6,d1					; 6 additional items

	.loop:
		move.b	#id_HasPassedCard,ost_id(a1)
		move.w	(a2),ost_x_pos(a1)			; set actual x position
		move.w	(a2)+,ost_has_x_start(a1)		; set start x position (same as actual)
		move.w	(a2)+,ost_has_x_stop(a1)		; set stop x position
		move.w	(a2)+,ost_y_screen(a1)			; set y position
		move.b	(a2)+,ost_routine(a1)			; goto Has_Move next
		move.b	(a2)+,d0				; get frame number
		cmpi.b	#id_frame_card_act1_6,d0		; is object the act number?
		bne.s	.not_act				; if not, branch
		add.b	(v_act).w,d0				; add act number to frame number

	.not_act:
		move.b	d0,ost_frame(a1)			; set frame number
		move.l	#Map_Has,ost_mappings(a1)
		move.w	#tile_Nem_TitleCard+tile_hi,ost_tile(a1)
		move.b	#render_abs,ost_render(a1)
		lea	sizeof_ost(a1),a1			; next OST slot in RAM
		dbf	d1,.loop				; repeat 6 times

Has_Move:	; Routine 2
		moveq	#$10,d1					; set horizontal speed (moves right)
		move.w	ost_has_x_stop(a0),d0
		cmp.w	ost_x_pos(a0),d0			; has object reached its target position?
		beq.s	.at_target				; if yes, branch
		bge.s	.is_left				; branch if object is left of target position
		neg.w	d1					; move left instead

	.is_left:
		add.w	d1,ost_x_pos(a0)			; update position

	.chk_visible:
		move.w	ost_x_pos(a0),d0
		bmi.s	.exit					; branch if object is at -ve x pos
		cmpi.w	#$200,d0				; is object further right than $200?
		bcc.s	.exit					; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

.exit:
		rts	
; ===========================================================================

.sbz2_ending:
		move.b	#id_Has_MoveBack,ost_routine(a0)
		bra.w	Has_MoveBack
; ===========================================================================

.at_target:
		cmpi.b	#id_Has_MoveBack,(v_ost_haspassed6+ost_routine).w ; is ring bonus object on routine Has_MoveBack?
		beq.s	.sbz2_ending				; if yes, branch
		cmpi.b	#id_frame_has_ringbonus,ost_frame(a0)	; is object the ring bonus?
		bne.s	.chk_visible				; if not, branch

		addq.b	#2,ost_routine(a0)			; goto Has_Wait next, and then Has_Bonus
		move.w	#180,ost_anim_time(a0)			; set time delay to 3 seconds

Has_Wait:	; Routine 4, 8, $C
		subq.w	#1,ost_anim_time(a0)			; decrement timer
		bne.s	.wait					; branch if time remains
		addq.b	#2,ost_routine(a0)			; goto Has_Bonus/Has_NextLevel/Has_MoveBack next

	.wait:
		bra.w	DisplaySprite
; ===========================================================================

Has_Bonus:	; Routine 6
		bsr.w	DisplaySprite
		move.b	#1,(f_pass_bonus_update).w		; set time/ring bonus update flag
		moveq	#0,d0
		tst.w	(v_time_bonus).w			; is time bonus	= zero?
		beq.s	.skip_timebonus				; if yes, branch
		addi.w	#10,d0					; add 10 to score
		subi.w	#10,(v_time_bonus).w			; subtract 10 from time bonus

	.skip_timebonus:
		tst.w	(v_ring_bonus).w			; is ring bonus	= zero?
		beq.s	.skip_ringbonus				; if yes, branch
		addi.w	#10,d0					; add 10 to score
		subi.w	#10,(v_ring_bonus).w			; subtract 10 from ring bonus

	.skip_ringbonus:
		tst.w	d0					; is there any bonus?
		bne.s	.add_bonus				; if yes, branch
		play.w	1, jsr, sfx_Register			; play "ker-ching" sound
		addq.b	#2,ost_routine(a0)			; goto Has_Wait next, and then Has_NextLevel
		cmpi.w	#id_SBZ_act2,(v_zone).w			; is current level SBZ2?
		bne.s	.not_sbz2				; if not, branch
		addq.b	#4,ost_routine(a0)			; goto Has_Wait next, and then Has_MoveBack

	.not_sbz2:
		move.w	#180,ost_anim_time(a0)			; set time delay to 3 seconds

.exit:
		rts	
; ===========================================================================

.add_bonus:
		jsr	(AddPoints).l				; add d0 to score and update counter
		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		andi.b	#3,d0					; read bits 0-1
		bne.s	.exit					; branch if either are set
		play.w	1, jmp, sfx_Switch			; play "blip" sound every 4th frame
; ===========================================================================

Has_NextLevel:	; Routine $A
		move.b	(v_zone).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(v_act).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0					; combine zone/act numbers into single value
		move.w	LevelOrder(pc,d0.w),d0			; load level from level order array
		move.w	d0,(v_zone).w				; set level number
		tst.w	d0
		bne.s	.valid_level				; branch if not 0
		move.b	#id_Sega,(v_gamemode).w			; goto Sega logo screen next
		bra.s	.skip_restart
; ===========================================================================

.valid_level:
		clr.b	(v_last_lamppost).w			; clear	lamppost counter
		tst.b	(f_giantring_collected).w		; has Sonic jumped into	a giant	ring?
		beq.s	.restart				; if not, branch
		move.b	#id_Special,(v_gamemode).w		; set game mode to Special Stage ($10)
		bra.s	.skip_restart
; ===========================================================================

.restart:
		move.w	#1,(f_restart).w			; restart level

.skip_restart:
		bra.w	DisplaySprite

; ---------------------------------------------------------------------------
; Level	order array

; Lists which levels which are loaded after the current level
; ---------------------------------------------------------------------------

LevelOrder:
		; Green Hill Zone
		dc.w id_GHZ_act2				; Act 1
		dc.w id_GHZ_act3				; Act 2
		dc.w id_MZ_act1					; Act 3
		dc.w id_GHZ_act1

		; Labyrinth Zone
		dc.w id_LZ_act2					; Act 1
		dc.w id_LZ_act3					; Act 2
		dc.w id_SLZ_act1				; Act 3
		dc.w id_FZ					; Scrap Brain Zone Act 3

		; Marble Zone
		dc.w id_MZ_act2					; Act 1
		dc.w id_MZ_act3					; Act 2
		dc.w id_SYZ_act1				; Act 3
		dc.w id_GHZ_act1

		; Star Light Zone
		dc.w id_SLZ_act2				; Act 1
		dc.w id_SLZ_act3				; Act 2
		dc.w id_SBZ_act1				; Act 3
		dc.w id_GHZ_act1

		; Spring Yard Zone
		dc.w id_SYZ_act2				; Act 1
		dc.w id_SYZ_act3				; Act 2
		dc.w id_LZ_act1					; Act 3
		dc.w id_GHZ_act1

		; Scrap Brain Zone
		dc.w id_SBZ_act2				; Act 1
		dc.w id_SBZ_act3				; Act 2
		dc.w id_GHZ_act1				; Final Zone
		dc.w id_GHZ_act1
		even
		zonewarning LevelOrder,8
; ===========================================================================

Has_MoveBack:	; Routine $E
		; moves title cards off screen during SBZ2 Eggman event
		moveq	#$20,d1					; set horizontal speed (moves right)
		move.w	ost_has_x_start(a0),d0
		cmp.w	ost_x_pos(a0),d0			; has item reached its target position?
		beq.s	.at_target				; if yes, branch
		bge.s	.is_left				; branch if object is left of target position
		neg.w	d1					; move left instead

	.is_left:
		add.w	d1,ost_x_pos(a0)			; update position
		move.w	ost_x_pos(a0),d0
		bmi.s	.exit					; branch if object is at -ve x pos
		cmpi.w	#$200,d0				; is object further right than $200?
		bcc.s	.exit					; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

.exit:
		rts	
; ===========================================================================

.at_target:
		cmpi.b	#id_frame_has_ringbonus,ost_frame(a0)	; is object the ring bonus?
		bne.w	DeleteObject				; if not, branch
		addq.b	#2,ost_routine(a0)			; goto Has_Boundary next
		clr.b	(f_lock_controls).w			; unlock controls
		play.w	0, jmp, mus_FZ				; play FZ music
; ===========================================================================

Has_Boundary:	; Routine $10
		addq.w	#2,(v_boundary_right).w			; extend right level boundary 2px
		cmpi.w	#$2100,(v_boundary_right).w
		beq.w	DeleteObject				; if boundary reaches $2100, delete object
		rts	
; ===========================================================================
		include_Has_Config				; see beginning of this file
