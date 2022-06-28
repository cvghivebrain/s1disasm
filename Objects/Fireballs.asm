; ---------------------------------------------------------------------------
; Object 14 - fireballs (MZ, SLZ)

; spawned by:
;	FireMaker - subtypes 0/1/2/5/6/7
;	BossMarble - subtype 0
; ---------------------------------------------------------------------------

FireBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FBall_Index(pc,d0.w),d1
		jsr	FBall_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
FBall_Index:	index *,,2
		ptr FBall_Main
		ptr FBall_Action
		ptr FBall_Delete

FBall_Speeds:	; Vertical - goes up and falls down
		dc.w -$400					; x0
		dc.w -$500					; x1
		dc.w -$600					; x2
		dc.w -$700					; x3 (unused)

		; Vertical - constant speed
		dc.w -$200					; x4 (unused)
		dc.w $200					; x5

		; Horizontal
		dc.w -$200					; x6
		dc.w $200					; x7
		dc.w 0						; x8

		rsobj FireBall
ost_fireball_mz_boss:	rs.b 1					; $29 ; set to $FF if spawned by MZ boss
		rsset $30
ost_fireball_y_start:	rs.w 1					; $30 ; original y position
		rsobjend
; ===========================================================================

FBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto FBall_Action next
		move.b	#8,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Fire,ost_mappings(a0)
		move.w	#tile_Nem_Fireball,ost_tile(a0)
		cmpi.b	#id_SLZ,(v_zone).w			; check if level is SLZ
		bne.s	@notSLZ					; if not, branch
		move.w	#tile_Nem_Fireball_SLZ,ost_tile(a0)	; SLZ specific code

	@notSLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#id_col_8x8+id_col_hurt,ost_col_type(a0)
		move.w	ost_y_pos(a0),ost_fireball_y_start(a0)
		tst.b	ost_fireball_mz_boss(a0)		; was fireball spawned by MZ boss?
		beq.s	@speed					; if not, branch
		addq.b	#2,ost_priority(a0)			; use lower sprite priority

	@speed:
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	FBall_Speeds(pc,d0.w),ost_y_vel(a0)	; load object speed (vertical)
		move.b	#8,ost_displaywidth(a0)
		cmpi.b	#6,ost_subtype(a0)			; is object type 0-5?
		bcs.s	@sound					; if yes, branch

		move.b	#$10,ost_displaywidth(a0)
		move.b	#id_ani_fire_horizontal,ost_anim(a0)	; use horizontal animation
		move.w	ost_y_vel(a0),ost_x_vel(a0)		; set horizontal speed
		move.w	#0,ost_y_vel(a0)			; delete vertical speed

	@sound:
		play.w	1, jsr, sfx_FireBall			; play lava ball sound

FBall_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		add.w	d0,d0
		move.w	FBall_TypeIndex(pc,d0.w),d1
		jsr	FBall_TypeIndex(pc,d1.w)		; update speed & check for wall collision
		bsr.w	SpeedToPos				; update position
		lea	(Ani_Fire).l,a1
		bsr.w	AnimateSprite

FBall_ChkDel:
		out_of_range	DeleteObject
		rts	
; ===========================================================================
FBall_TypeIndex:index *
		ptr FBall_Type_UpDown
		ptr FBall_Type_UpDown
		ptr FBall_Type_UpDown
		ptr FBall_Type_UpDown				; unused
		ptr FBall_Type_Up				; unused
		ptr FBall_Type_Down
		ptr FBall_Type_Left
		ptr FBall_Type_Right
		ptr FBall_Type_Stop
; ===========================================================================
; fireball types 00-03 fly up and fall back down

FBall_Type_UpDown:
		addi.w	#$18,ost_y_vel(a0)			; increase object's downward speed
		move.w	ost_fireball_y_start(a0),d0
		cmp.w	ost_y_pos(a0),d0			; has object fallen back to its original position?
		bcc.s	@keep_falling				; if not, branch
		addq.b	#2,ost_routine(a0)			; goto FBall_Delete next

	@keep_falling:
		bclr	#status_yflip_bit,ost_status(a0)
		tst.w	ost_y_vel(a0)				; is fireball falling downwards?
		bpl.s	@upwards				; if yes, branch
		bset	#status_yflip_bit,ost_status(a0)	; set yflip

	@upwards:
		rts	
; ===========================================================================
; fireball type	04 flies up until it hits the ceiling

FBall_Type_Up:
		bset	#status_yflip_bit,ost_status(a0)
		bsr.w	FindCeilingObj
		tst.w	d1					; distance to ceiling
		bpl.s	@no_ceiling				; branch if > 0
		move.b	#id_FBall_Type_Stop,ost_subtype(a0)
		move.b	#id_ani_fire_vertcollide,ost_anim(a0)
		move.w	#0,ost_y_vel(a0)			; stop the object when it touches the ceiling

	@no_ceiling:
		rts	
; ===========================================================================
; fireball type	05 falls down until it hits the	floor

FBall_Type_Down:
		bclr	#status_yflip_bit,ost_status(a0)
		bsr.w	FindFloorObj
		tst.w	d1					; distance to floor
		bpl.s	@no_floor				; branch if > 0
		move.b	#id_FBall_Type_Stop,ost_subtype(a0)
		move.b	#id_ani_fire_vertcollide,ost_anim(a0)
		move.w	#0,ost_y_vel(a0)			; stop the object when it touches the floor

	@no_floor:
		rts	
; ===========================================================================
; fireball types 06-07 move sideways until they hit a wall

FBall_Type_Left:
		bset	#status_xflip_bit,ost_status(a0)
		moveq	#-8,d3					; dist. centre to left edge of fireball
		bsr.w	FindWallLeftObj
		tst.w	d1					; distance to wall
		bpl.s	@no_wall				; branch if > 0
		move.b	#id_FBall_Type_Stop,ost_subtype(a0)
		move.b	#id_ani_fire_horicollide,ost_anim(a0)
		move.w	#0,ost_x_vel(a0)			; stop object when it touches a wall

	@no_wall:
		rts	
; ===========================================================================

FBall_Type_Right:
		bclr	#status_xflip_bit,ost_status(a0)
		moveq	#8,d3					; dist. centre to right edge of fireball
		bsr.w	FindWallRightObj
		tst.w	d1					; distance to wall
		bpl.s	@no_wall				; branch if > 0
		move.b	#id_FBall_Type_Stop,ost_subtype(a0)
		move.b	#id_ani_fire_horicollide,ost_anim(a0)
		move.w	#0,ost_x_vel(a0)			; stop object when it touches a wall

	@no_wall:
		rts	
; ===========================================================================

FBall_Type_Stop:
		rts	
; ===========================================================================

FBall_Delete:	; Routine 4
		bra.w	DeleteObject

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Fire:	index *
		ptr ani_fire_vertical
		ptr ani_fire_vertcollide
		ptr ani_fire_horizontal
		ptr ani_fire_horicollide
		
ani_fire_vertical:
		dc.b 5
		dc.b id_frame_fire_vertical1
		dc.b id_frame_fire_vertical1+afxflip
		dc.b id_frame_fire_vertical2
		dc.b id_frame_fire_vertical2+afxflip
		dc.b afEnd

ani_fire_vertcollide:
		dc.b 5
		dc.b id_frame_fire_vertcollide
		dc.b afRoutine
		even

ani_fire_horizontal:
		dc.b 5
		dc.b id_frame_fire_horizontal1
		dc.b id_frame_fire_horizontal1+afyflip
		dc.b id_frame_fire_horizontal2
		dc.b id_frame_fire_horizontal2+afyflip
		dc.b afEnd

ani_fire_horicollide:
		dc.b 5
		dc.b id_frame_fire_horicollide
		dc.b afRoutine
		even
