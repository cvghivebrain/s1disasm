; ---------------------------------------------------------------------------
; Object 0E - Sonic on the title screen
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	TSon_Index(pc,d0.w),d1
		jmp	TSon_Index(pc,d1.w)
; ===========================================================================
TSon_Index:	index *,,2
		ptr TSon_Main
		ptr TSon_Delay
		ptr TSon_Move
		ptr TSon_Animate
; ===========================================================================

TSon_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$F0,ost_x_pos(a0)
		move.w	#$DE,ost_y_screen(a0) ; position is fixed to screen
		move.l	#Map_TSon,ost_mappings(a0)
		move.w	#$300+tile_pal2,ost_tile(a0)
		move.b	#1,ost_priority(a0)
		move.b	#29,ost_anim_delay(a0) ; set time delay to 0.5 seconds
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite

TSon_Delay:	;Routine 2
		subq.b	#1,ost_anim_delay(a0) ; subtract 1 from time delay
		bpl.s	@wait		; if time remains, branch
		addq.b	#2,ost_routine(a0) ; go to next routine
		bra.w	DisplaySprite

	@wait:
		rts	
; ===========================================================================

TSon_Move:	; Routine 4
		subq.w	#8,ost_y_screen(a0) ; move Sonic up
		cmpi.w	#$96,ost_y_screen(a0) ; has Sonic reached final position?
		bne.s	@display	; if not, branch
		addq.b	#2,ost_routine(a0)

	@display:
		bra.w	DisplaySprite

		rts	
; ===========================================================================

TSon_Animate:	; Routine 6
		lea	(Ani_TSon).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite

		rts	
