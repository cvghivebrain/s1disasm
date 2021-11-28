; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------

PSBTM:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	PSB_Index(pc,d0.w),d1
		jsr	PSB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
PSB_Index:	index *,,2
		ptr PSB_Main
		ptr PSB_PrsStart
		ptr PSB_Exit
; ===========================================================================

PSB_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$D0,ost_x_pos(a0)
		move.w	#$130,ost_y_screen(a0)
		move.l	#Map_PSB,ost_mappings(a0)
		move.w	#vram_title/$20,ost_tile(a0)
		cmpi.b	#id_frame_psb_psb+1,ost_frame(a0)	; is object "PRESS START"?
		bcs.s	PSB_PrsStart				; if yes, branch

		addq.b	#2,ost_routine(a0)
		cmpi.b	#id_frame_psb_tm,ost_frame(a0)		; is the object "TM"?
		bne.s	PSB_Exit				; if not, branch

		move.w	#(vram_title_tm/$20)+tile_pal2,ost_tile(a0) ; "TM" specific code
		move.w	#$170,ost_x_pos(a0)
		move.w	#$F8,ost_y_screen(a0)

PSB_Exit:	; Routine 4
		rts	
; ===========================================================================

PSB_PrsStart:	; Routine 2
		lea	(Ani_PSB).l,a1
		bra.w	AnimateSprite				; "PRESS START" is animated
