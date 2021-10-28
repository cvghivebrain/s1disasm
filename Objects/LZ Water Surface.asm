; ---------------------------------------------------------------------------
; Object 1B - water surface (LZ)
; ---------------------------------------------------------------------------

WaterSurface:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Surf_Index(pc,d0.w),d1
		jmp	Surf_Index(pc,d1.w)
; ===========================================================================
Surf_Index:	index *,,2
		ptr Surf_Main
		ptr Surf_Action

ost_surf_x_start:	equ $30	; original x-axis position (2 bytes)
ost_surf_freeze:	equ $32	; flag to freeze animation
; ===========================================================================

Surf_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Surf,ost_mappings(a0)
		move.w	#tile_Nem_Water+tile_pal3+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$80,ost_actwidth(a0)
		move.w	ost_x_pos(a0),ost_surf_x_start(a0)

Surf_Action:	; Routine 2
		move.w	(v_camera_x_pos).w,d1
		andi.w	#$FFE0,d1
		add.w	ost_surf_x_start(a0),d1
		btst	#0,(v_frame_counter_low).w
		beq.s	@even		; branch on even frames
		addi.w	#$20,d1

	@even:
		move.w	d1,ost_x_pos(a0) ; match obj x-position to screen position
		move.w	(v_water_height_actual).w,d1
		move.w	d1,ost_y_pos(a0) ; match obj y-position to water height
		tst.b	ost_surf_freeze(a0)
		bne.s	@stopped
		btst	#bitStart,(v_joypad_press_actual).w ; is Start button pressed?
		beq.s	@animate	; if not, branch
		addq.b	#id_frame_surf_paused1,ost_frame(a0) ; use different frames
		move.b	#1,ost_surf_freeze(a0) ; stop animation
		bra.s	@display
; ===========================================================================

@stopped:
		tst.w	(f_pause).w	; is the game paused?
		bne.s	@display	; if yes, branch
		move.b	#0,ost_surf_freeze(a0) ; resume animation
		subq.b	#id_frame_surf_paused1,ost_frame(a0) ; use normal frames

@animate:
		subq.b	#1,ost_anim_time(a0)
		bpl.s	@display
		move.b	#7,ost_anim_time(a0)
		addq.b	#1,ost_frame(a0)
		cmpi.b	#id_frame_surf_normal3+1,ost_frame(a0)
		bcs.s	@display
		move.b	#0,ost_frame(a0)

@display:
		bra.w	DisplaySprite
