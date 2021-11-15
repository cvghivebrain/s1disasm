; ---------------------------------------------------------------------------
; Object 7E - special stage results screen
; ---------------------------------------------------------------------------

SSResult:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SSR_Index(pc,d0.w),d1
		jmp	SSR_Index(pc,d1.w)
; ===========================================================================
SSR_Index:	index *,,2
		ptr SSR_ChkPLC
		ptr SSR_Move
		ptr SSR_Wait
		ptr SSR_RingBonus
		ptr SSR_Wait
		ptr SSR_Exit
		ptr SSR_Wait
		ptr SSR_Continue
		ptr SSR_Wait
		ptr SSR_Exit
		ptr SSR_ContAni

ost_ssr_x_stop:		equ $30					; on screen x position (2 bytes)
; ===========================================================================

SSR_ChkPLC:	; Routine 0
		tst.l	(v_plc_buffer).w			; are the pattern load cues empty?
		beq.s	SSR_Main				; if yes, branch
		rts	
; ===========================================================================

SSR_Main:
		movea.l	a0,a1
		lea	(SSR_Config).l,a2
		moveq	#3,d1
		cmpi.w	#50,(v_rings).w				; do you have 50 or more rings?
		bcs.s	SSR_Loop				; if no, branch
		addq.w	#1,d1					; if yes, add 1	to d1 (number of sprites)

	SSR_Loop:
		move.b	#id_SSResult,0(a1)
		move.w	(a2)+,ost_x_pos(a1)			; load start x position
		move.w	(a2)+,ost_ssr_x_stop(a1)		; load main x position
		move.w	(a2)+,ost_y_screen(a1)			; load y position
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,ost_frame(a1)
		move.l	#Map_SSR,ost_mappings(a1)
		move.w	#tile_Nem_TitleCard+tile_hi,ost_tile(a1)
		move.b	#render_abs,ost_render(a1)
		lea	$40(a1),a1
		dbf	d1,SSR_Loop				; repeat sequence 3 or 4 times

		moveq	#7,d0
		move.b	(v_emeralds).w,d1
		beq.s	loc_C842
		moveq	#0,d0
		cmpi.b	#6,d1					; do you have all chaos	emeralds?
		bne.s	loc_C842				; if not, branch
		moveq	#8,d0					; load "Sonic got them all" text
		move.w	#$18,ost_x_pos(a0)
		move.w	#$118,ost_ssr_x_stop(a0)		; change position of text

loc_C842:
		move.b	d0,ost_frame(a0)

SSR_Move:	; Routine 2
		moveq	#$10,d1					; set horizontal speed
		move.w	ost_ssr_x_stop(a0),d0
		cmp.w	ost_x_pos(a0),d0			; has item reached its target position?
		beq.s	loc_C86C				; if yes, branch
		bge.s	SSR_ChgPos
		neg.w	d1

SSR_ChgPos:
		add.w	d1,ost_x_pos(a0)			; change item's position

loc_C85A:
		move.w	ost_x_pos(a0),d0
		bmi.s	locret_C86A
		cmpi.w	#$200,d0				; has item moved beyond	$200 on	x-axis?
		bcc.s	locret_C86A				; if yes, branch
		bra.w	DisplaySprite
; ===========================================================================

locret_C86A:
		rts	
; ===========================================================================

loc_C86C:
		cmpi.b	#2,ost_frame(a0)
		bne.s	loc_C85A
		addq.b	#2,ost_routine(a0)
		move.w	#180,ost_anim_time(a0)			; set time delay to 3 seconds
		move.b	#id_SSRChaos,(v_ost_ssres_emeralds).w	; load chaos emerald object

SSR_Wait:	; Routine 4, 8, $C, $10
		subq.w	#1,ost_anim_time(a0)			; subtract 1 from time delay
		bne.s	SSR_Display
		addq.b	#2,ost_routine(a0)

SSR_Display:
		bra.w	DisplaySprite
; ===========================================================================

SSR_RingBonus:	; Routine 6
		bsr.w	DisplaySprite
		move.b	#1,(f_pass_bonus_update).w		; set ring bonus update flag
		tst.w	(v_ring_bonus).w			; is ring bonus	= zero?
		beq.s	loc_C8C4				; if yes, branch
		subi.w	#10,(v_ring_bonus).w			; subtract 10 from ring bonus
		moveq	#10,d0					; add 10 to score
		jsr	(AddPoints).l
		move.b	(v_vblank_counter_byte).w,d0
		andi.b	#3,d0
		bne.s	locret_C8EA
		play.w	1, jmp, sfx_Switch			; play "blip" sound
; ===========================================================================

loc_C8C4:
		play.w	1, jsr, sfx_Register			; play "ker-ching" sound
		addq.b	#2,ost_routine(a0)
		move.w	#180,ost_anim_time(a0)			; set time delay to 3 seconds
		cmpi.w	#50,(v_rings).w				; do you have at least 50 rings?
		bcs.s	locret_C8EA				; if not, branch
		move.w	#60,ost_anim_time(a0)			; set time delay to 1 second
		addq.b	#4,ost_routine(a0)			; goto "SSR_Continue" routine

locret_C8EA:
		rts	
; ===========================================================================

SSR_Exit:	; Routine $A, $12
		move.w	#1,(f_restart).w			; restart level
		bra.w	DisplaySprite
; ===========================================================================

SSR_Continue:	; Routine $E
		move.b	#4,(v_ost_ssresult5+ost_frame).w
		move.b	#id_SSR_ContAni,(v_ost_ssresult5+ost_routine).w
		play.w	1, jsr, sfx_Continue			; play continues jingle
		addq.b	#2,ost_routine(a0)
		move.w	#360,ost_anim_time(a0)			; set time delay to 6 seconds
		bra.w	DisplaySprite
; ===========================================================================

SSR_ContAni:	; Routine $14
		move.b	(v_vblank_counter_byte).w,d0
		andi.b	#$F,d0
		bne.s	SSR_Display2
		bchg	#0,ost_frame(a0)			; Sonic taps his foot every 16 frames

SSR_Display2:
		bra.w	DisplaySprite
; ===========================================================================
SSR_Config:	dc.w $20, $120,	$C4				; start	x pos, stop x pos, y pos
		dc.b id_SSR_Move, id_frame_ssr_chaos		; routine number, frame number
		dc.w $320, $120, $118
		dc.b id_SSR_Move, id_frame_ssr_score
		dc.w $360, $120, $128
		dc.b id_SSR_Move, 2
		dc.w $1EC, $11C, $C4
		dc.b id_SSR_Move, id_frame_card_oval_3
		dc.w $3A0, $120, $138
		dc.b id_SSR_Move, 6
