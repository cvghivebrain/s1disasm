; ---------------------------------------------------------------------------
; Object 6A - ground saws and pizza cutters (SBZ)

; spawned by:
;	ObjPos_SBZ1, ObjPos_SBZ2 - subtypes 1/2/3
; ---------------------------------------------------------------------------

Saws:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Saw_Index(pc,d0.w),d1
		jmp	Saw_Index(pc,d1.w)
; ===========================================================================
Saw_Index:	index *,,2
		ptr Saw_Main
		ptr Saw_Action

		rsobj Saws,$38
ost_saw_y_start:	rs.w 1					; $38 ; original y-axis position
ost_saw_x_start:	rs.w 1					; $3A ; original x-axis position
		rsset $3D
ost_saw_flag:		rs.b 1					; $3D ; flag set when the ground saw appears
		rsobjend
; ===========================================================================

Saw_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Saw_Action next
		move.l	#Map_Saw,ost_mappings(a0)
		move.w	#tile_Nem_Cutter+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$20,ost_displaywidth(a0)
		move.w	ost_x_pos(a0),ost_saw_x_start(a0)
		move.w	ost_y_pos(a0),ost_saw_y_start(a0)
		cmpi.b	#id_Saw_Ground_Right,ost_subtype(a0)	; is object a ground saw?
		bcc.s	Saw_Action				; if yes, branch
		move.b	#id_col_24x24_2+id_col_hurt,ost_col_type(a0)

Saw_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#7,d0					; read bits 0-2 of subtype
		add.w	d0,d0
		move.w	Saw_Type_Index(pc,d0.w),d1
		jsr	Saw_Type_Index(pc,d1.w)
		out_of_range.s	@delete,ost_saw_x_start(a0)
		jmp	(DisplaySprite).l

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================
Saw_Type_Index:
		index *
		ptr Saw_Pizza_Still				; pizza cutter, doesn't move - unused
		ptr Saw_Pizza_Sideways				; pizza cutter, moves side-to-side
		ptr Saw_Pizza_UpDown				; pizza cutter, moves up and down
		ptr Saw_Ground_Right				; ground saw, moves right
		ptr Saw_Ground_Left				; ground saw, moves left - unused
; ===========================================================================

; Type 0
Saw_Pizza_Still:
		rts						; doesn't move
; ===========================================================================

; Type 1
Saw_Pizza_Sideways:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_60).w,d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip01
		neg.w	d0
		add.w	d1,d0

	@noflip01:
		move.w	ost_saw_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)			; move saw sideways

		subq.b	#1,ost_anim_time(a0)
		bpl.s	@sameframe01
		move.b	#2,ost_anim_time(a0)			; time between frame changes
		bchg	#0,ost_frame(a0)			; change frame

	@sameframe01:
		tst.b	ost_render(a0)
		bpl.s	@nosound01
		move.w	(v_frame_counter).w,d0
		andi.w	#$F,d0
		bne.s	@nosound01
		play.w	1, jsr, sfx_Saw				; play saw sound

	@nosound01:
		rts	
; ===========================================================================

; Type 2
Saw_Pizza_UpDown:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillating_0_to_30).w,d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip02
		neg.w	d0
		addi.w	#$80,d0

	@noflip02:
		move.w	ost_saw_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0)			; move saw vertically
		subq.b	#1,ost_anim_time(a0)
		bpl.s	@sameframe02
		move.b	#2,ost_anim_time(a0)
		bchg	#0,ost_frame(a0)

	@sameframe02:
		tst.b	ost_render(a0)
		bpl.s	@nosound02
		move.b	(v_oscillating_0_to_30).w,d0
		cmpi.b	#$18,d0
		bne.s	@nosound02
		play.w	1, jsr, sfx_Saw				; play saw sound

	@nosound02:
		rts	
; ===========================================================================

; Type 3
Saw_Ground_Right:
		tst.b	ost_saw_flag(a0)			; has the saw appeared already?
		bne.s	@already_here				; if yes, branch

		move.w	(v_ost_player+ost_x_pos).w,d0
		subi.w	#$C0,d0
		bcs.s	@nosaw03x				; branch if Sonic is within 192px of left edge boundary
		sub.w	ost_x_pos(a0),d0
		bcs.s	@nosaw03x				; branch if saw is < 192px to Sonic's left
		move.w	(v_ost_player+ost_y_pos).w,d0
		subi.w	#$80,d0
		cmp.w	ost_y_pos(a0),d0
		bcc.s	@nosaw03y				; branch if saw is > 128px above Sonic
		addi.w	#$100,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.s	@nosaw03y				; branch if saw is > 128px below Sonic

		move.b	#1,ost_saw_flag(a0)			; flag object as already loaded
		move.w	#$600,ost_x_vel(a0)			; move object to the right
		move.b	#id_col_24x24_2+id_col_hurt,ost_col_type(a0)
		move.b	#id_frame_saw_groundsaw1,ost_frame(a0)
		play.w	1, jsr, sfx_Saw				; play saw sound

	@nosaw03x:
		addq.l	#4,sp

	@nosaw03y:
		rts	
; ===========================================================================

@already_here:
		jsr	(SpeedToPos).l				; update position
		move.w	ost_x_pos(a0),ost_saw_x_start(a0)
		subq.b	#1,ost_anim_time(a0)			; decrement frame timer
		bpl.s	@sameframe03				; branch if time remains
		move.b	#2,ost_anim_time(a0)			; reset timer
		bchg	#0,ost_frame(a0)			; change frame

	@sameframe03:
		rts	
; ===========================================================================

; Type 4
Saw_Ground_Left:
		tst.b	ost_saw_flag(a0)			; has the saw appeared already?
		bne.s	@already_here				; if yes, branch

		move.w	(v_ost_player+ost_x_pos).w,d0
		addi.w	#$E0,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@nosaw04x				; branch if saw is > 224px right of Sonic 
		move.w	(v_ost_player+ost_y_pos).w,d0
		subi.w	#$80,d0
		cmp.w	ost_y_pos(a0),d0
		bcc.s	@nosaw04y				; branch if saw is > 128px above Sonic
		addi.w	#$100,d0
		cmp.w	ost_y_pos(a0),d0
		bcs.s	@nosaw04y				; branch if saw is > 128px below Sonic

		move.b	#1,ost_saw_flag(a0)			; flag object as already loaded
		move.w	#-$600,ost_x_vel(a0)			; move object to the left
		move.b	#id_col_24x24_2+id_col_hurt,ost_col_type(a0)
		move.b	#id_frame_saw_groundsaw1,ost_frame(a0)
		play.w	1, jsr, sfx_Saw				; play saw sound

	@nosaw04x:
		addq.l	#4,sp

	@nosaw04y:
		rts	
; ===========================================================================

@already_here:
		jsr	(SpeedToPos).l				; update position
		move.w	ost_x_pos(a0),ost_saw_x_start(a0)
		subq.b	#1,ost_anim_time(a0)			; decrement frame timer
		bpl.s	@sameframe04				; branch if time remains
		move.b	#2,ost_anim_time(a0)			; reset timer
		bchg	#0,ost_frame(a0)			; change frame

	@sameframe04:
		rts	
