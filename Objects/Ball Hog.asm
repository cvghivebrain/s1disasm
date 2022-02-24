; ---------------------------------------------------------------------------
; Object 1E - Ball Hog enemy (SBZ)

; spawned by:
;	ObjPos_SBZ1, ObjPos_SBZ2
; ---------------------------------------------------------------------------

BallHog:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Hog_Index(pc,d0.w),d1
		jmp	Hog_Index(pc,d1.w)
; ===========================================================================
Hog_Index:	index *,,2
		ptr Hog_Main
		ptr Hog_Action

ost_hog_flag:	equ $32						; 0 to launch a cannonball
; ===========================================================================

Hog_Main:	; Routine 0
		move.b	#$13,ost_height(a0)
		move.b	#8,ost_width(a0)
		move.l	#Map_Hog,ost_mappings(a0)
		move.w	#tile_Nem_BallHog+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#id_col_12x18,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		bsr.w	ObjectFall
		jsr	(FindFloorObj).l			; find floor
		tst.w	d1
		bpl.s	@floornotfound
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	#0,ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)

	@floornotfound:
		rts	
; ===========================================================================

Hog_Action:	; Routine 2
		lea	(Ani_Hog).l,a1
		bsr.w	AnimateSprite
		cmpi.b	#id_frame_hog_open,ost_frame(a0)	; is final frame (01) displayed?
		bne.s	@setlaunchflag				; if not, branch
		tst.b	ost_hog_flag(a0)			; is it set to launch cannonball?
		beq.s	@makeball				; if yes, branch
		bra.s	@remember
; ===========================================================================

@setlaunchflag:
		clr.b	ost_hog_flag(a0)			; set to launch cannonball

@remember:
		bra.w	RememberState
; ===========================================================================

@makeball:
		move.b	#1,ost_hog_flag(a0)
		bsr.w	FindFreeObj
		bne.s	@fail
		move.b	#id_Cannonball,ost_id(a1)			; load cannonball object ($20)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	#-$100,ost_x_vel(a1)			; cannonball bounces to the left
		move.w	#0,ost_y_vel(a1)
		moveq	#-4,d0
		btst	#status_xflip_bit,ost_status(a0)	; is Ball Hog facing right?
		beq.s	@noflip					; if not, branch
		neg.w	d0
		neg.w	ost_x_vel(a1)				; cannonball bounces to	the right

	@noflip:
		add.w	d0,ost_x_pos(a1)
		addi.w	#$C,ost_y_pos(a1)
		move.b	ost_subtype(a0),ost_subtype(a1)		; copy object type from Ball Hog

	@fail:
		bra.s	@remember

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

include_BallHog_animation:	macro

Ani_Hog:	index *
		ptr ani_hog_0
		
ani_hog_0:	dc.b 9
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_leap
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_leap
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_leap
		dc.b id_frame_hog_squat
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_standing
		dc.b id_frame_hog_open
		dc.b afEnd
		even

		endm
