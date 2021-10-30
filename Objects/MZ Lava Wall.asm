; ---------------------------------------------------------------------------
; Object 4E - advancing	wall of	lava (MZ)
; ---------------------------------------------------------------------------

LavaWall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LWall_Index(pc,d0.w),d1
		jmp	LWall_Index(pc,d1.w)
; ===========================================================================
LWall_Index:	index *,,2
		ptr LWall_Main
		ptr LWall_Solid
		ptr LWall_Action
		ptr LWall_Move
		ptr LWall_Delete

ost_lwall_flag:		equ $36	; flag to start wall moving
ost_lwall_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

LWall_Main:	; Routine 0
		addq.b	#4,ost_routine(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	@make
; ===========================================================================

	@loop:
		bsr.w	FindNextFreeObj
		bne.s	@fail

@make:
		move.b	#id_LavaWall,0(a1) ; load object
		move.l	#Map_LWall,ost_mappings(a1)
		move.w	#tile_Nem_Lava+tile_pal4,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$50,ost_actwidth(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#1,ost_priority(a1)
		move.b	#id_ani_lavawall_0,ost_anim(a1)
		move.b	#$94,ost_col_type(a1)
		move.l	a0,ost_lwall_parent(a1)

	@fail:
		dbf	d1,@loop	; repeat sequence once

		addq.b	#6,ost_routine(a1)
		move.b	#id_frame_lavawall_4,ost_frame(a1)

LWall_Action:	; Routine 4
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@rangechk
		neg.w	d0

	@rangechk:
		cmpi.w	#$C0,d0		; is Sonic within $C0 pixels (x-axis)?
		bcc.s	@movewall	; if not, branch
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0
		bcc.s	@rangechk2
		neg.w	d0

	@rangechk2:
		cmpi.w	#$60,d0		; is Sonic within $60 pixels (y-axis)?
		bcc.s	@movewall	; if not, branch
		move.b	#1,ost_lwall_flag(a0) ; set object to move
		bra.s	LWall_Solid
; ===========================================================================

@movewall:
		tst.b	ost_lwall_flag(a0) ; is object set to move?
		beq.s	LWall_Solid	; if not, branch
		move.w	#$180,ost_x_vel(a0) ; set object speed
		subq.b	#2,ost_routine(a0)

LWall_Solid:	; Routine 2
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	ost_x_pos(a0),d4
		move.b	ost_routine(a0),d0
		move.w	d0,-(sp)
		bsr.w	SolidObject
		move.w	(sp)+,d0
		move.b	d0,ost_routine(a0)
		cmpi.w	#$6A0,ost_x_pos(a0) ; has object reached $6A0 on the x-axis?
		bne.s	@animate	; if not, branch
		clr.w	ost_x_vel(a0)	; stop object moving
		clr.b	ost_lwall_flag(a0)

	@animate:
		lea	(Ani_LWall).l,a1
		bsr.w	AnimateSprite
		cmpi.b	#4,(v_ost_player+ost_routine).w
		bcc.s	@rangechk
		bsr.w	SpeedToPos

	@rangechk:
		bsr.w	DisplaySprite
		tst.b	ost_lwall_flag(a0) ; is wall already moving?
		bne.s	@moving		; if yes, branch
		out_of_range.s	@chkgone

	@moving:
		rts	
; ===========================================================================

@chkgone:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,ost_routine(a0)
		rts	
; ===========================================================================

LWall_Move:	; Routine 6
		movea.l	ost_lwall_parent(a0),a1
		cmpi.b	#id_LWall_Delete,ost_routine(a1)
		beq.s	LWall_Delete
		move.w	ost_x_pos(a1),ost_x_pos(a0) ; move rest of lava wall
		subi.w	#$80,ost_x_pos(a0)
		bra.w	DisplaySprite
; ===========================================================================

LWall_Delete:	; Routine 8
		bra.w	DeleteObject
