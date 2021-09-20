; ---------------------------------------------------------------------------
; Object 62 - gargoyle head (LZ)
; ---------------------------------------------------------------------------

Gargoyle:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Gar_Index(pc,d0.w),d1
		jsr	Gar_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Gar_Index:	index *,,2
		ptr Gar_Main
		ptr Gar_MakeFire
		ptr Gar_FireBall
		ptr Gar_AniFire

Gar_SpitRate:	dc.b 30, 60, 90, 120, 150, 180,	210, 240
; ===========================================================================

Gar_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Gar,ost_mappings(a0)
		move.w	#tile_Nem_Gargoyle+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#$F,d0		; read only the	2nd digit
		move.b	Gar_SpitRate(pc,d0.w),ost_anim_delay(a0) ; set fireball spit rate
		move.b	ost_anim_delay(a0),ost_anim_time(a0)
		andi.b	#$F,ost_subtype(a0)

Gar_MakeFire:	; Routine 2
		subq.b	#1,ost_anim_time(a0) ; decrement timer
		bne.s	@nofire		; if time remains, branch

		move.b	ost_anim_delay(a0),ost_anim_time(a0) ; reset timer
		bsr.w	CheckOffScreen
		bne.s	@nofire
		bsr.w	FindFreeObj
		bne.s	@nofire
		move.b	#id_Gargoyle,0(a1) ; load fireball object
		addq.b	#4,ost_routine(a1) ; use Gar_FireBall routine
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	ost_render(a0),ost_render(a1)
		move.b	ost_status(a0),ost_status(a1)

	@nofire:
		rts	
; ===========================================================================

Gar_FireBall:	; Routine 4
		addq.b	#2,ost_routine(a0)
		move.b	#8,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Gar,ost_mappings(a0)
		move.w	#tile_Nem_Gargoyle,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$98,ost_col_type(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#id_frame_gargoyle_fireball1,ost_frame(a0)
		addq.w	#8,ost_y_pos(a0)
		move.w	#$200,ost_x_vel(a0)
		btst	#status_xflip_bit,ost_status(a0) ; is gargoyle facing left?
		bne.s	@noflip		; if not, branch
		neg.w	ost_x_vel(a0)

	@noflip:
		sfx	sfx_Fireball,0,0,0 ; play lava ball sound

Gar_AniFire:	; Routine 6
		move.b	(v_framebyte).w,d0
		andi.b	#7,d0
		bne.s	@nochg
		bchg	#0,ost_frame(a0) ; change every 8 frames

	@nochg:
		bsr.w	SpeedToPos
		btst	#status_xflip_bit,ost_status(a0) ; is fireball moving left?
		bne.s	@isright	; if not, branch
		moveq	#-8,d3
		bsr.w	ObjHitWallLeft
		tst.w	d1
		bmi.w	DeleteObject	; delete if the	fireball hits a	wall
		rts	

	@isright:
		moveq	#8,d3
		bsr.w	ObjHitWallRight
		tst.w	d1
		bmi.w	DeleteObject
		rts	
