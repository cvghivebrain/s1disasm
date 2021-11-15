; ---------------------------------------------------------------------------
; Object 4A - special stage entry from beta
; ---------------------------------------------------------------------------

VanishSonic:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Van_Index(pc,d0.w),d1
		jmp	Van_Index(pc,d1.w)
; ===========================================================================
Van_Index:	index *,,2
		ptr Van_Main
		ptr Van_RmvSonic
		ptr Van_LoadSonic

ost_vanish_time:	equ $30					; time for Sonic to disappear (2 bytes)
; ===========================================================================

Van_Main:	; Routine 0
		tst.l	(v_plc_buffer).w			; are pattern load cues empty?
		beq.s	@isempty				; if yes, branch
		rts	

	@isempty:
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Vanish,ost_mappings(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#$38,ost_actwidth(a0)
		move.w	#tile_Nem_Shield,ost_tile(a0)
		move.w	#120,ost_vanish_time(a0)		; set time for Sonic's disappearance to 2 seconds

Van_RmvSonic:	; Routine 2
		move.w	(v_ost_player+ost_x_pos).w,ost_x_pos(a0)
		move.w	(v_ost_player+ost_y_pos).w,ost_y_pos(a0)
		move.b	(v_ost_player+ost_status).w,ost_status(a0)
		lea	(Ani_Vanish).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#id_frame_vanish_flash3,ost_frame(a0)
		bne.s	@display
		tst.b	(v_ost_player).w
		beq.s	@display
		move.b	#0,(v_ost_player).w			; remove Sonic
		play.w	1, jsr, sfx_Goal			; play Special Stage "GOAL" sound

	@display:
		jmp	(DisplaySprite).l
; ===========================================================================

Van_LoadSonic:	; Routine 4
		subq.w	#1,ost_vanish_time(a0)			; subtract 1 from time
		bne.s	@wait					; if time remains, branch
		move.b	#id_SonicPlayer,(v_ost_player).w	; load Sonic object
		jmp	(DeleteObject).l

	@wait:
		rts	
