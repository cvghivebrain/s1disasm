; ---------------------------------------------------------------------------
; Object 79 - lamppost

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtypes 1/2/3/4
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 1/2/5
;	ObjPos_SYZ1, ObjPos_SYZ2, ObjPos_SYZ3 - subtypes 1/2
;	ObjPos_LZ1, ObjPos_LZ2, ObjPos_LZ3 - subtypes 1/2
;	ObjPos_SLZ3 - subtype 1
;	ObjPos_SBZ1, ObjPos_SBZ3 - subtypes 1/2
; ---------------------------------------------------------------------------

Lamppost:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Lamp_Index(pc,d0.w),d1
		jsr	Lamp_Index(pc,d1.w)
		jmp	(RememberState).l
; ===========================================================================
Lamp_Index:	index *,,2
		ptr Lamp_Main
		ptr Lamp_Blue
		ptr Lamp_Finish
		ptr Lamp_Twirl

ost_lamp_x_start:	equ $30					; original x-axis position (2 bytes)
ost_lamp_y_start:	equ $32					; original y-axis position (2 bytes)
ost_lamp_twirl_time:	equ $36					; length of time to twirl the lamp (2 bytes)
; ===========================================================================

Lamp_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Lamp_Blue next
		move.l	#Map_Lamp,ost_mappings(a0)
		move.w	#tile_Nem_Lamp,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#5,ost_priority(a0)
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)				; has lamppost been hit?
		bne.s	@red					; if yes, branch

		move.b	(v_last_lamppost).w,d1			; get number of last lamppost hit
		andi.b	#$7F,d1
		move.b	ost_subtype(a0),d2			; get lamppost number
		andi.b	#$7F,d2
		cmp.b	d2,d1					; is this a "new" lamppost?
		bcs.s	Lamp_Blue				; if yes, branch

	@red:
		bset	#0,2(a2,d0.w)				; remember lamppost as red
		move.b	#id_Lamp_Finish,ost_routine(a0)		; goto Lamp_Finish next
		move.b	#id_frame_lamp_red,ost_frame(a0)	; use red lamppost frame
		rts	
; ===========================================================================

Lamp_Blue:	; Routine 2
		tst.w	(v_debug_active).w			; is debug mode	being used?
		bne.w	@donothing				; if yes, branch
		tst.b	(v_lock_multi).w			; is object collision enabled?
		bmi.w	@donothing				; if not, branch
		move.b	(v_last_lamppost).w,d1
		andi.b	#$7F,d1
		move.b	ost_subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1					; is this a "new" lamppost?
		bcs.s	@chkhit					; if yes, branch

		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bset	#0,2(a2,d0.w)				; remember lamppost as red
		move.b	#id_Lamp_Finish,ost_routine(a0)		; goto Lamp_Finish next
		move.b	#id_frame_lamp_red,ost_frame(a0)	; use red lamppost frame
		bra.w	@donothing
; ===========================================================================

@chkhit:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		addq.w	#8,d0
		cmpi.w	#$10,d0
		bcc.w	@donothing
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0
		addi.w	#$40,d0
		cmpi.w	#$68,d0
		bcc.s	@donothing

		play.w	1, jsr, sfx_Lamppost			; play lamppost sound
		addq.b	#2,ost_routine(a0)			; goto Lamp_Finish next
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_Lamppost,ost_id(a1)			; load twirling lamp object
		move.b	#id_Lamp_Twirl,ost_routine(a1)		; child object goto Lamp_Twirl next
		move.w	ost_x_pos(a0),ost_lamp_x_start(a1)
		move.w	ost_y_pos(a0),ost_lamp_y_start(a1)
		subi.w	#$18,ost_lamp_y_start(a1)
		move.l	#Map_Lamp,ost_mappings(a1)
		move.w	#tile_Nem_Lamp,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#4,ost_priority(a1)
		move.b	#id_frame_lamp_redballonly,ost_frame(a1) ; use "ball only" frame
		move.w	#32,ost_lamp_twirl_time(a1)

	@fail:
		move.b	#id_frame_lamp_poleonly,ost_frame(a0)	; use "post only" frame
		bsr.w	Lamp_StoreInfo				; store Sonic's position, rings, lives etc.
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bset	#0,2(a2,d0.w)				; remember lamppost as red

	@donothing:
		rts	
; ===========================================================================

Lamp_Finish:	; Routine 4
		rts	
; ===========================================================================

Lamp_Twirl:	; Routine 6
		subq.w	#1,ost_lamp_twirl_time(a0)		; decrement timer
		bpl.s	@continue				; if time remains, keep twirling
		move.b	#id_Lamp_Finish,ost_routine(a0)		; goto Lamp_Finish next

	@continue:
		move.b	ost_angle(a0),d0
		subi.b	#$10,ost_angle(a0)
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$C00,d1
		swap	d1
		add.w	ost_lamp_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		muls.w	#$C00,d0
		swap	d0
		add.w	ost_lamp_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Subroutine to	store information when you hit a lamppost
; ---------------------------------------------------------------------------

Lamp_StoreInfo:
		move.b	ost_subtype(a0),(v_last_lamppost).w	; lamppost number
		move.b	(v_last_lamppost).w,(v_last_lamppost_lampcopy).w
		move.w	ost_x_pos(a0),(v_sonic_x_pos_lampcopy).w ; x-position
		move.w	ost_y_pos(a0),(v_sonic_y_pos_lampcopy).w ; y-position
		move.w	(v_rings).w,(v_rings_lampcopy).w	; rings
		move.b	(v_ring_reward).w,(v_ring_reward_lampcopy).w ; lives
		move.l	(v_time).w,(v_time_lampcopy).w		; time
		move.b	(v_dle_routine).w,(v_dle_routine_lampcopy).w ; routine counter for dynamic level mod
		move.w	(v_boundary_bottom).w,(v_boundary_bottom_lampcopy).w ; lower y-boundary of level
		move.w	(v_camera_x_pos).w,(v_camera_x_pos_lampcopy).w ; screen x-position
		move.w	(v_camera_y_pos).w,(v_camera_y_pos_lampcopy).w ; screen y-position
		move.w	(v_bg1_x_pos).w,(v_bg1_x_pos_lampcopy).w ; bg position
		move.w	(v_bg1_y_pos).w,(v_bg1_y_pos_lampcopy).w ; bg position
		move.w	(v_bg2_x_pos).w,(v_bg2_x_pos_lampcopy).w ; bg position
		move.w	(v_bg2_y_pos).w,(v_bg2_y_pos_lampcopy).w ; bg position
		move.w	(v_bg3_x_pos).w,(v_bg3_x_pos_lampcopy).w ; bg position
		move.w	(v_bg3_y_pos).w,(v_bg3_y_pos_lampcopy).w ; bg position
		move.w	(v_water_height_normal).w,(v_water_height_normal_lampcopy).w ; water height
		move.b	(v_water_routine).w,(v_water_routine_lampcopy).w ; rountine counter for water
		move.b	(f_water_pal_full).w,(f_water_pal_full_lampcopy).w ; water direction
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	load stored info when you start	a level	from a lamppost
; ---------------------------------------------------------------------------

Lamp_LoadInfo:
		move.b	(v_last_lamppost_lampcopy).w,(v_last_lamppost).w
		move.w	(v_sonic_x_pos_lampcopy).w,(v_ost_player+ost_x_pos).w
		move.w	(v_sonic_y_pos_lampcopy).w,(v_ost_player+ost_y_pos).w
		move.w	(v_rings_lampcopy).w,(v_rings).w
		move.b	(v_ring_reward_lampcopy).w,(v_ring_reward).w
		clr.w	(v_rings).w
		clr.b	(v_ring_reward).w
		move.l	(v_time_lampcopy).w,(v_time).w
		move.b	#59,(v_time_frames).w			; second counter ticks at next frame
		subq.b	#1,(v_time_sec).w
		move.b	(v_dle_routine_lampcopy).w,(v_dle_routine).w
		move.b	(v_water_routine_lampcopy).w,(v_water_routine).w
		move.w	(v_boundary_bottom_lampcopy).w,(v_boundary_bottom).w
		move.w	(v_boundary_bottom_lampcopy).w,(v_boundary_bottom_next).w
		move.w	(v_camera_x_pos_lampcopy).w,(v_camera_x_pos).w
		move.w	(v_camera_y_pos_lampcopy).w,(v_camera_y_pos).w
		move.w	(v_bg1_x_pos_lampcopy).w,(v_bg1_x_pos).w
		move.w	(v_bg1_y_pos_lampcopy).w,(v_bg1_y_pos).w
		move.w	(v_bg2_x_pos_lampcopy).w,(v_bg2_x_pos).w
		move.w	(v_bg2_y_pos_lampcopy).w,(v_bg2_y_pos).w
		move.w	(v_bg3_x_pos_lampcopy).w,(v_bg3_x_pos).w
		move.w	(v_bg3_y_pos_lampcopy).w,(v_bg3_y_pos).w
		cmpi.b	#id_LZ,(v_zone).w			; is this Labyrinth Zone?
		bne.s	@notlabyrinth				; if not, branch

		move.w	(v_water_height_normal_lampcopy).w,(v_water_height_normal).w
		move.b	(v_water_routine_lampcopy).w,(v_water_routine).w
		move.b	(f_water_pal_full_lampcopy).w,(f_water_pal_full).w

	@notlabyrinth:
		tst.b	(v_last_lamppost).w			; is last lamppost negative? (it never is)
		bpl.s	@exit					; if not, branch
		move.w	(v_sonic_x_pos_lampcopy).w,d0
		subi.w	#160,d0
		move.w	d0,(v_boundary_left).w			; set left boundary to half a screen to Sonic's left

	@exit:
		rts	
