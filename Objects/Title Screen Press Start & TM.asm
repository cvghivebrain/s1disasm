; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" and "TM" from title screen

; spawned by:
;	GM_Title - frames 0 (PSB), 2 (sprite mask), 3 (TM)
; ---------------------------------------------------------------------------

PSBTM:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	PSB_Index(pc,d0.w),d1
		jsr	PSB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
PSB_Index:	index offset(*),,2
		ptr PSB_Main
		ptr PSB_Animate
		ptr PSB_Exit
; ===========================================================================

PSB_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto PSB_Animate next
		move.w	#$D0,ost_x_pos(a0)
		move.w	#$130,ost_y_screen(a0)
		move.l	#Map_PSB,ost_mappings(a0)
		move.w	#vram_title/sizeof_cell,ost_tile(a0)
		cmpi.b	#id_frame_psb_mask,ost_frame(a0)	; is object the sprite mask or "TM"?
		bcs.s	PSB_Animate				; if not, branch

		addq.b	#2,ost_routine(a0)			; goto PSB_Exit next
		cmpi.b	#id_frame_psb_tm,ost_frame(a0)		; is the object "TM"?
		bne.s	PSB_Exit				; if not, branch

		move.w	#(vram_title_tm/sizeof_cell)+tile_pal2,ost_tile(a0) ; "TM" specific code
		move.w	#$170,ost_x_pos(a0)
		move.w	#$F8,ost_y_screen(a0)

PSB_Exit:	; Routine 4
		rts	
; ===========================================================================

PSB_Animate:	; Routine 2
		lea	(Ani_PSB).l,a1
		bra.w	AnimateSprite				; "PRESS START" is animated

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_PSBTM_animation:	macro

Ani_PSB:	index offset(*)
		ptr ani_psb_flash
		
ani_psb_flash:	dc.b $1F
		dc.b id_frame_psb_blank
		dc.b id_frame_psb_psb
		dc.b afEnd
		even

		endm
