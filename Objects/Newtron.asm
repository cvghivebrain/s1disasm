; ---------------------------------------------------------------------------
; Object 42 - Newtron enemy (GHZ)

; spawned by:
;	ObjPos_GHZ1, ObjPos_GHZ2, ObjPos_GHZ3 - subtypes 0/1
; ---------------------------------------------------------------------------

Newtron:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Newt_Index(pc,d0.w),d1
		jmp	Newt_Index(pc,d1.w)
; ===========================================================================
Newt_Index:	index *,,2
		ptr Newt_Main
		ptr Newt_Action
		ptr Newt_Delete

ost_newtron_fire_flag:	equ $32					; set to 1 after newtron fires a missile
; ===========================================================================

Newt_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Newt_Action next
		move.l	#Map_Newt,ost_mappings(a0)
		move.w	#tile_Nem_Newtron,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$14,ost_actwidth(a0)
		move.b	#$10,ost_height(a0)
		move.b	#8,ost_width(a0)

Newt_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Newt_Action_Index(pc,d0.w),d1
		jsr	Newt_Action_Index(pc,d1.w)
		lea	(Ani_Newt).l,a1
		bsr.w	AnimateSprite				; animate (green newtron goto Newt_Delete after firing)
		bra.w	RememberState
; ===========================================================================
Newt_Action_Index:
		index *,,2
		ptr Newt_ChkDist
		ptr Newt_Type0
		ptr Newt_Type0_Floor
		ptr Newt_Type0_Fly
		ptr Newt_Type1
; ===========================================================================

Newt_ChkDist:
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@sonicisright				; branch if Sonic is to the right
		neg.w	d0					; make d0 +ve
		bclr	#status_xflip_bit,ost_status(a0)

	@sonicisright:
		cmpi.w	#$80,d0					; is Sonic within $80 pixels of	the newtron?
		bcc.s	@outofrange				; if not, branch
		addq.b	#id_Newt_Type0,ost_routine2(a0)		; goto Newt_Type0 next
		move.b	#id_ani_newt_drop,ost_anim(a0)
		tst.b	ost_subtype(a0)				; check	object type
		beq.s	@istype00				; if type is 00, branch

		move.w	#tile_Nem_Newtron+tile_pal2,ost_tile(a0)
		move.b	#id_Newt_Type1,ost_routine2(a0)		; goto Newt_Type1 next
		move.b	#id_ani_newt_firing,ost_anim(a0)	; use different animation

	@outofrange:
	@istype00:
		rts	
; ===========================================================================

Newt_Type0:
		cmpi.b	#id_frame_newt_drop2,ost_frame(a0)	; has "appearing" animation finished?
		bcc.s	@fall					; is yes, branch
		bset	#status_xflip_bit,ost_status(a0)	; face right
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@sonicisright2				; branch if Sonic is to the right
		bclr	#status_xflip_bit,ost_status(a0)	; face left

	@sonicisright2:
		rts	
; ===========================================================================

@fall:
		cmpi.b	#id_frame_newt_norm,ost_frame(a0)	; is fully visible upright frame used?
		bne.s	@not_upright				; if not, branch
		move.b	#id_col_20x16,ost_col_type(a0)

	@not_upright:
		bsr.w	ObjectFall				; apply gravity and update position
		bsr.w	FindFloorObj
		tst.w	d1					; has newtron hit the floor?
		bpl.s	@keepfalling				; if not, branch

		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#0,ost_y_vel(a0)			; stop newtron falling
		addq.b	#2,ost_routine2(a0)			; goto Newt_Type0_Floor next
		move.b	#id_ani_newt_fly1,ost_anim(a0)
		btst	#tile_pal12_bit,ost_tile(a0)		; is newtron blue?
		beq.s	@is_blue				; if yes, branch
		addq.b	#1,ost_anim(a0)				; use different animation for green newtron

	@is_blue:
		move.b	#id_col_20x8,ost_col_type(a0)
		move.w	#$200,ost_x_vel(a0)			; move newtron horizontally
		btst	#status_xflip_bit,ost_status(a0)
		bne.s	@noflip
		neg.w	ost_x_vel(a0)

	@keepfalling:
	@noflip:
		rts	
; ===========================================================================

Newt_Type0_Floor:
		bsr.w	SpeedToPos				; update position
		bsr.w	FindFloorObj
		cmpi.w	#-8,d1
		blt.s	@nextroutine				; branch if more than 8px below floor
		cmpi.w	#$C,d1
		bge.s	@nextroutine				; branch if more than 11px above floor (also detects a ledge)
		add.w	d1,ost_y_pos(a0)			; align to floor
		rts	
; ===========================================================================

	@nextroutine:
		addq.b	#2,ost_routine2(a0)			; goto Newt_Type0_Fly next
		rts	
; ===========================================================================

Newt_Type0_Fly:
		bsr.w	SpeedToPos				; update position (flies straight)
		rts	
; ===========================================================================

Newt_Type1:
		cmpi.b	#id_frame_newt_norm,ost_frame(a0)
		bne.s	@firemissile
		move.b	#id_col_20x16,ost_col_type(a0)

	@firemissile:
		cmpi.b	#id_frame_newt_firing,ost_frame(a0)	; is animation on firing frame?
		bne.s	@fail					; if not, branch
		tst.b	ost_newtron_fire_flag(a0)		; has newtron already fired?
		bne.s	@fail					; if yes, branch

		move.b	#1,ost_newtron_fire_flag(a0)		; set fired flag
		bsr.w	FindFreeObj				; find free OST slot
		bne.s	@fail					; branch if not found
		move.b	#id_Missile,ost_id(a1)			; load missile object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		subq.w	#8,ost_y_pos(a1)
		move.w	#$200,ost_x_vel(a1)			; missile goes right
		move.w	#$14,d0
		btst	#status_xflip_bit,ost_status(a0)	; is newtron facing right?
		bne.s	@noflip					; if yes, branch
		neg.w	d0
		neg.w	ost_x_vel(a1)				; missile goes left

	@noflip:
		add.w	d0,ost_x_pos(a1)
		move.b	ost_status(a0),ost_status(a1)
		move.b	#1,ost_subtype(a1)

	@fail:
		rts	
; ===========================================================================

Newt_Delete:	; Routine 4
		bra.w	DeleteObject

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Newt:	index *
		ptr ani_newt_blank
		ptr ani_newt_drop
		ptr ani_newt_fly1
		ptr ani_newt_fly2
		ptr ani_newt_firing
		
ani_newt_blank:		dc.b $F
			dc.b id_frame_newt_blank
			dc.b afEnd
			even
ani_newt_drop:		dc.b $13
			dc.b id_frame_newt_trans
			dc.b id_frame_newt_norm
			dc.b id_frame_newt_drop1
			dc.b id_frame_newt_drop2
			dc.b id_frame_newt_drop3
			dc.b afBack, 1
ani_newt_fly1:		dc.b 2
			dc.b id_frame_newt_fly1a
			dc.b id_frame_newt_fly1b
			dc.b afEnd
ani_newt_fly2:		dc.b 2
			dc.b id_frame_newt_fly2a
			dc.b id_frame_newt_fly2b
			dc.b afEnd
ani_newt_firing:	dc.b $13
			dc.b id_frame_newt_trans
			dc.b id_frame_newt_norm
			dc.b id_frame_newt_norm
			dc.b id_frame_newt_firing
			dc.b id_frame_newt_norm
			dc.b id_frame_newt_norm
			dc.b id_frame_newt_trans
			dc.b afRoutine
			even

; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------

Map_Newt:	index *
		ptr frame_newt_trans
		ptr frame_newt_norm
		ptr frame_newt_firing
		ptr frame_newt_drop1
		ptr frame_newt_drop2
		ptr frame_newt_drop3
		ptr frame_newt_fly1a
		ptr frame_newt_fly1b
		ptr frame_newt_fly2a
		ptr frame_newt_fly2b
		ptr frame_newt_blank
		
frame_newt_trans:
		spritemap					; partially visible
		piece	-$14, -$14, 4x2, 0
		piece	$C, -$C, 1x1, 8
		piece	-$C, -4, 4x3, 9
		endsprite
		
frame_newt_norm:
		spritemap					; visible
		piece	-$14, -$14, 2x3, $15
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
frame_newt_firing:
		spritemap					; open mouth, firing
		piece	-$14, -$14, 2x3, $2A
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
frame_newt_drop1:
		spritemap					; dropping
		piece	-$14, -$14, 2x3, $30
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x2, $36
		piece	$C, $C, 1x1, $3C
		endsprite
		
frame_newt_drop2:
		spritemap
		piece	-$14, -$C, 4x2, $3D
		piece	$C, -4, 1x1, $20
		piece	-4, 4, 3x1, $45
		endsprite
		
frame_newt_drop3:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		endsprite
		
frame_newt_fly1a:
		spritemap					; flying
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52
		endsprite
		
frame_newt_fly1b:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53
		endsprite
		
frame_newt_fly2a:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52, pal4, hi
		endsprite
		
frame_newt_fly2b:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53, pal4, hi
		endsprite
		
frame_newt_blank:
		spritemap
		endsprite
		even
