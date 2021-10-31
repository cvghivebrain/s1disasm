; ---------------------------------------------------------------------------
; Object 7F - chaos emeralds from the special stage results screen
; ---------------------------------------------------------------------------

SSRChaos:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SSRC_Index(pc,d0.w),d1
		jmp	SSRC_Index(pc,d1.w)
; ===========================================================================
SSRC_Index:	index *,,2
		ptr SSRC_Main
		ptr SSRC_Flash

; ---------------------------------------------------------------------------
; X-axis positions for chaos emeralds
; ---------------------------------------------------------------------------
SSRC_PosData:	dc.w $110, $128, $F8, $140, $E0, $158
; ===========================================================================

SSRC_Main:	; Routine 0
		movea.l	a0,a1
		lea	(SSRC_PosData).l,a2
		moveq	#0,d2
		moveq	#0,d1
		move.b	(v_emeralds).w,d1 ; d1 is number of emeralds
		subq.b	#1,d1		; subtract 1 from d1
		bcs.w	DeleteObject	; if you have 0	emeralds, branch

	SSRC_Loop:
		move.b	#id_SSRChaos,0(a1)
		move.w	(a2)+,ost_x_pos(a1) ; set x position
		move.w	#$F0,ost_y_screen(a1) ; set y position
		lea	(v_emerald_list).w,a3 ; check which emeralds you have
		move.b	(a3,d2.w),d3
		move.b	d3,ost_frame(a1)
		move.b	d3,ost_anim(a1)
		addq.b	#1,d2
		addq.b	#2,ost_routine(a1)
		move.l	#Map_SSRC,ost_mappings(a1)
		move.w	#tile_Nem_ResultEm+tile_hi,ost_tile(a1)
		move.b	#render_abs,ost_render(a1)
		lea	$40(a1),a1	; next object
		dbf	d1,SSRC_Loop	; loop for d1 number of	emeralds

SSRC_Flash:	; Routine 2
		move.b	ost_frame(a0),d0
		move.b	#id_frame_ssrc_blank,ost_frame(a0) ; load 6th frame (blank)
		cmpi.b	#6,d0
		bne.s	SSRC_Display
		move.b	ost_anim(a0),ost_frame(a0) ; load visible frame

	SSRC_Display:
		bra.w	DisplaySprite
