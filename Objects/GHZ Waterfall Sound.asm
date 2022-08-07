; ---------------------------------------------------------------------------
; Object 49 - waterfall	sound effect (GHZ)

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3
; ---------------------------------------------------------------------------

WaterSound:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	WSnd_Index(pc,d0.w),d1
		jmp	WSnd_Index(pc,d1.w)
; ===========================================================================
WSnd_Index:	index *,,2
		ptr WSnd_Main
		ptr WSnd_PlaySnd
; ===========================================================================

WSnd_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto WSnd_PlaySnd next
		move.b	#render_rel,ost_render(a0)

WSnd_PlaySnd:	; Routine 2
		move.b	(v_vblank_counter_byte).w,d0		; get low byte of VBlank counter
		andi.b	#$3F,d0					; read bits 0-5
		bne.s	.skip_sfx				; branch if not 0
		play.w	1, jsr, sfx_Waterfall			; play waterfall sound (every 64 frames)

	.skip_sfx:
		out_of_range	DeleteObject
		rts	
