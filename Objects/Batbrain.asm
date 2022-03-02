; ---------------------------------------------------------------------------
; Object 55 - Batbrain enemy (MZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3
; ---------------------------------------------------------------------------

Batbrain:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bat_Index(pc,d0.w),d1
		jmp	Bat_Index(pc,d1.w)
; ===========================================================================
Bat_Index:	index *,,2
		ptr Bat_Main
		ptr Bat_Action

ost_bat_sonic_y_pos:	equ $36					; Sonic's y position (2 bytes)
; ===========================================================================

Bat_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Bat_Action next
		move.l	#Map_Bat,ost_mappings(a0)
		move.w	#tile_Nem_Batbrain+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$C,ost_height(a0)
		move.b	#2,ost_priority(a0)
		move.b	#id_col_8x8,ost_col_type(a0)
		move.b	#$10,ost_actwidth(a0)

Bat_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Bat_Action_Index(pc,d0.w),d1
		jsr	Bat_Action_Index(pc,d1.w)
		lea	(Ani_Bat).l,a1
		bsr.w	AnimateSprite
		bra.w	DespawnObject
; ===========================================================================
Bat_Action_Index:
		index *
		ptr Bat_DropChk
		ptr Bat_DropFly
		ptr Bat_FlapSound
		ptr Bat_FlyUp
; ===========================================================================

Bat_DropChk:
		move.w	#$80,d2
		bsr.w	Bat_ChkDist				; cmp d2 to x dist between Sonic and batbrain
		bcc.s	@nodrop					; branch if x dist > 128px
		move.w	(v_ost_player+ost_y_pos).w,d0
		move.w	d0,ost_bat_sonic_y_pos(a0)
		sub.w	ost_y_pos(a0),d0
		bcs.s	@nodrop					; branch if Sonic is above the batbrain
		cmpi.w	#$80,d0
		bcc.s	@nodrop					; branch if Sonic is > 128px below the batbrain
		tst.w	(v_debug_active).w
		bne.s	@nodrop					; branch if debug mode is in use

		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		add.b	d7,d0					; add OST index number (so each batbrain updates on a different frame)
		andi.b	#7,d0					; read only bits 0-2
		bne.s	@nodrop					; branch if any are set
		move.b	#id_ani_bat_drop,ost_anim(a0)
		addq.b	#2,ost_routine2(a0)			; goto Bat_DropFly next

	@nodrop:
		rts	
; ===========================================================================

Bat_DropFly:
		bsr.w	SpeedToPos				; update position
		addi.w	#$18,ost_y_vel(a0)			; make batbrain fall
		move.w	#$80,d2
		bsr.w	Bat_ChkDist				; update xflip flag and get direction to fly
		move.w	ost_bat_sonic_y_pos(a0),d0
		sub.w	ost_y_pos(a0),d0
		bcs.s	@chkdel					; branch if Sonic is above the batbrain
		cmpi.w	#$10,d0
		bcc.s	@dropmore				; branch if Sonic is > 16px below the batbrain

		move.w	d1,ost_x_vel(a0)			; make batbrain fly horizontally
		move.w	#0,ost_y_vel(a0)			; stop batbrain falling
		move.b	#id_ani_bat_fly,ost_anim(a0)
		addq.b	#2,ost_routine2(a0)			; goto Bat_FlapSound next

	@dropmore:
		rts	

	@chkdel:
		tst.b	ost_render(a0)
		bpl.w	DeleteObject				; branch if batbrain is off screen
		rts	
; ===========================================================================

Bat_FlapSound:
		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		andi.b	#$F,d0					; read only low nybble
		bne.s	@nosound				; branch if not 0
		play.w	1, jsr, sfx_basaran			; play flapping sound every 16th frame

	@nosound:
		bsr.w	SpeedToPos				; update position
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@sonic_right				; if Sonic is right of batbrain, branch
		neg.w	d0					; d0 = x dist between Sonic and batbrain

	@sonic_right:
		cmpi.w	#$80,d0
		bcs.s	@dontflyup				; branch if Sonic is < 128px from batbrain
		move.b	(v_vblank_counter_byte).w,d0		; get byte that increments every frame
		add.b	d7,d0					; add OST index number (so each batbrain updates on a different frame)
		andi.b	#7,d0					; read only bits 0-2
		bne.s	@dontflyup				; branch if any are set
		addq.b	#2,ost_routine2(a0)			; goto Bat_FlyUp next

	@dontflyup:
		rts	
; ===========================================================================

Bat_FlyUp:
		bsr.w	SpeedToPos				; update position
		subi.w	#$18,ost_y_vel(a0)			; make batbrain fly upwards
		bsr.w	FindCeilingObj
		tst.w	d1					; has batbrain hit the ceiling?
		bpl.s	@noceiling				; if not, branch
		sub.w	d1,ost_y_pos(a0)			; align to ceiling
		andi.w	#$FFF8,ost_x_pos(a0)			; snap to tile
		clr.w	ost_x_vel(a0)				; stop batbrain moving
		clr.w	ost_y_vel(a0)
		clr.b	ost_anim(a0)
		clr.b	ost_routine2(a0)			; goto Bat_DropChk next

	@noceiling:
		rts

; ---------------------------------------------------------------------------
; Subroutine to check Sonic's distance from the batbrain and set direction

; input:
;	d2 = distance to compare

; output:
;	d0 = distance between Sonic and batbrain (always +ve)
;	d1 = speed/direction for batbrain to fly horizontally
; ---------------------------------------------------------------------------

Bat_ChkDist:
		move.w	#$100,d1
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@right					; if Sonic is right of batbrain, branch
		neg.w	d0
		neg.w	d1
		bclr	#status_xflip_bit,ost_status(a0)

	@right:
		cmp.w	d2,d0
		rts	
; ===========================================================================
; unused crap
		bsr.w	SpeedToPos
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Bat:	index *
		ptr ani_bat_hang
		ptr ani_bat_drop
		ptr ani_bat_fly
		
ani_bat_hang:	dc.b $F
		dc.b id_frame_bat_hanging
		dc.b afEnd
		even

ani_bat_drop:	dc.b $F
		dc.b id_frame_bat_fly1
		dc.b afEnd
		even

ani_bat_fly:	dc.b 3
		dc.b id_frame_bat_fly1
		dc.b id_frame_bat_fly2
		dc.b id_frame_bat_fly3
		dc.b id_frame_bat_fly2
		dc.b afEnd
		even
