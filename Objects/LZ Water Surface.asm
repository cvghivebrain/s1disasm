; ---------------------------------------------------------------------------
; Object 1B - water surface (LZ)

; spawned by:
;	GM_Level (loads 2 at x positions $60 and $120)
; ---------------------------------------------------------------------------

WaterSurface:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Surf_Index(pc,d0.w),d1
		jmp	Surf_Index(pc,d1.w)
; ===========================================================================
Surf_Index:	index offset(*),,2
		ptr Surf_Main
		ptr Surf_Action

		rsobj WaterSurface,$30
ost_surf_x_start:	rs.w 1					; $30 ; original x-axis position
ost_surf_freeze:	rs.b 1					; $32 ; flag to freeze animation
		rsobjend
; ===========================================================================

Surf_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Surf_Action next
		move.l	#Map_Surf,ost_mappings(a0)
		move.w	#tile_Nem_Water+tile_pal3+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$80,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_surf_x_start(a0)	; save initial x position ($60 or $120)

Surf_Action:	; Routine 2
		move.w	(v_camera_x_pos).w,d1			; get camera x position
		andi.w	#$FFE0,d1				; round down to $20
		add.w	ost_surf_x_start(a0),d1			; add initial position
		btst	#0,(v_frame_counter_low).w
		beq.s	.even					; branch on even frames
		addi.w	#$20,d1					; add $20 every other frame to create flicker

	.even:
		move.w	d1,ost_x_pos(a0)			; match x position to screen position
		move.w	(v_water_height_actual).w,d1
		move.w	d1,ost_y_pos(a0)			; match y position to water height
		tst.b	ost_surf_freeze(a0)
		bne.s	.stopped
		btst	#bitStart,(v_joypad_press_actual).w	; is Start button pressed?
		beq.s	.animate				; if not, branch
		addq.b	#id_frame_surf_paused1,ost_frame(a0)	; use different frames
		move.b	#1,ost_surf_freeze(a0)			; stop animation
		bra.s	.display
; ===========================================================================

.stopped:
		tst.w	(f_pause).w				; is the game paused?
		bne.s	.display				; if yes, branch
		move.b	#0,ost_surf_freeze(a0)			; resume animation
		subq.b	#id_frame_surf_paused1,ost_frame(a0)	; use normal frames

.animate:
		subq.b	#1,ost_anim_time(a0)			; decrement animation timer
		bpl.s	.display				; branch if time remains
		move.b	#7,ost_anim_time(a0)			; reset timer
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#id_frame_surf_normal3+1,ost_frame(a0)
		bcs.s	.display
		move.b	#0,ost_frame(a0)			; reset to frame 0 when animation finishes

.display:
		bra.w	DisplaySprite
