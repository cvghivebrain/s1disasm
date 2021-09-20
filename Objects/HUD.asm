; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------

HUD:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	HUD_Index(pc,d0.w),d1
		jmp	HUD_Index(pc,d1.w)
; ===========================================================================
HUD_Index:	index *
		ptr HUD_Main
		ptr HUD_Flash
; ===========================================================================

HUD_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$90,ost_x_pos(a0)
		move.w	#$108,ost_y_screen(a0)
		move.l	#Map_HUD,ost_mappings(a0)
		move.w	#tile_Nem_Hud,ost_tile(a0)
		move.b	#render_abs,ost_render(a0)
		move.b	#0,ost_priority(a0)

HUD_Flash:	; Routine 2
		tst.w	(v_rings).w	; do you have any rings?
		beq.s	@norings	; if not, branch
		clr.b	ost_frame(a0)	; make all counters yellow
		jmp	(DisplaySprite).l
; ===========================================================================

@norings:
		moveq	#0,d0
		btst	#3,(v_framebyte).w
		bne.s	@display
		addq.w	#id_frame_hud_ringred,d0 ; make ring counter flash red
		cmpi.b	#9,(v_timemin).w ; have	9 minutes elapsed?
		bne.s	@display	; if not, branch
		addq.w	#id_frame_hud_timered,d0 ; make time counter flash red

	@display:
		move.b	d0,ost_frame(a0)
		jmp	DisplaySprite
