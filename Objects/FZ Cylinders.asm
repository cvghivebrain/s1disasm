; ---------------------------------------------------------------------------
; Object 84 - cylinder Eggman hides in (FZ)

; spawned by:
;	BossFinal - subtypes 0/2/4/6
; ---------------------------------------------------------------------------

Cyl_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

EggmanCylinder:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Cyl_Index(pc,d0.w),d0
		jmp	Cyl_Index(pc,d0.w)
; ===========================================================================
Cyl_Index:	index offset(*),,2
		ptr Cyl_Main
		ptr Cyl_Action
		ptr Cyl_Move

Cyl_PosData:	dc.w $24D0, $620				; bottom left
		dc.w $2550, $620				; bottom right
		dc.w $2490, $4C0				; top left
		dc.w $2510, $4C0				; top right

		rsobj EggmanCylinder
ost_cylinder_flag:	rs.b 1					; $29 ; flag set when extending
		rsset $30
ost_cylinder_eggman:	rs.w 1					; $30 ; -1 if cylinder contains Eggman
		rsset $34
ost_cylinder_parent:	rs.l 1					; $34 ; address of OST of parent object
ost_cylinder_y_start:	rs.l 1					; $38 ; original y position (low word always 0)
ost_cylinder_y_move:	rs.l 1					; $3C ; amount the cylinder has moved
		rsobjend
; ===========================================================================

Cyl_Main:	; Routine 0
		lea	Cyl_PosData(pc),a1
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (0/2/4/6)
		add.w	d0,d0
		adda.w	d0,a1					; jump to relevant address for x/y pos data
		move.b	#render_rel,ost_render(a0)
		bset	#render_onscreen_bit,ost_render(a0)
		bset	#render_useheight_bit,ost_render(a0)
		move.w	#tile_Nem_FzBoss,ost_tile(a0)
		move.l	#Map_EggCyl,ost_mappings(a0)
		move.w	(a1)+,ost_x_pos(a0)
		move.w	(a1),ost_y_pos(a0)
		move.w	(a1)+,ost_cylinder_y_start(a0)
		move.b	#$20,ost_height(a0)
		move.b	#$60,ost_width(a0)
		move.b	#$20,ost_displaywidth(a0)
		move.b	#$60,ost_height(a0)
		move.b	#3,ost_priority(a0)
		addq.b	#2,ost_routine(a0)			; goto Cyl_Action next

Cyl_Action:	; Routine 2
		cmpi.b	#2,ost_subtype(a0)			; is cylinder on ceiling?
		ble.s	.not_ceiling				; if not, branch
		bset	#status_yflip_bit,ost_render(a0)	; yflip

	.not_ceiling:
		clr.l	ost_cylinder_y_move(a0)
		tst.b	ost_cylinder_flag(a0)			; is cylinder set to move?
		beq.s	Cyl_Update				; if not, branch
		addq.b	#2,ost_routine(a0)			; goto Cyl_Move next

Cyl_Update:
		move.l	ost_cylinder_y_move(a0),d0
		move.l	ost_cylinder_y_start(a0),d1
		add.l	d0,d1					; add y diff to start position
		swap	d1					; get important word
		move.w	d1,ost_y_pos(a0)			; update y position
		cmpi.b	#id_Cyl_Move,ost_routine(a0)		; is cylinder active?
		bne.s	.skip_eggman				; if not, branch
		tst.w	ost_cylinder_eggman(a0)			; does cylinder contain Eggman?
		bpl.s	.skip_eggman				; if not, branch
		moveq	#-$A,d0
		cmpi.b	#2,ost_subtype(a0)			; is cylinder on ceiling?
		ble.s	.not_ceiling				; if not, branch
		moveq	#$E,d0

	.not_ceiling:
		add.w	d0,d1
		movea.l	ost_cylinder_parent(a0),a1		; get address of OST of parent (Eggman)
		move.w	d1,ost_y_pos(a1)			; update Eggman position
		move.w	ost_x_pos(a0),ost_x_pos(a1)

	.skip_eggman:
		move.w	#$2B,d1
		move.w	#$60,d2
		move.w	#$61,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		moveq	#0,d0
		move.w	ost_cylinder_y_move(a0),d1		; distance cylinder has moved
		bpl.s	.moved_down				; branch if 0 or +ve
		neg.w	d1					; make value +ve
		subq.w	#8,d1
		bcs.s	.update_frame				; branch if it was more than 8px
		addq.b	#1,d0
		asr.w	#4,d1					; divide by 16
		add.w	d1,d0
		bra.s	.update_frame
; ===========================================================================

.moved_down:
		subi.w	#$27,d1
		bcs.s	.update_frame				; branch if cylinder moved more than 39px
		addq.b	#1,d0
		asr.w	#4,d1					; divide by 16
		add.w	d1,d0

.update_frame:
		move.b	d0,ost_frame(a0)			; set frame
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bmi.s	.display				; branch if Sonic is left of cylinder
		subi.w	#320,d0
		bmi.s	.display				; branch if Sonic is within 320px of cylinder
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	Cyl_Delete				; if not, branch

	.display:
		jmp	(DisplaySprite).l
; ===========================================================================

Cyl_Move:	; Routine 4
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.w	Cyl_Move_Index(pc,d0.w),d0
		jsr	Cyl_Move_Index(pc,d0.w)
		bra.w	Cyl_Update
; ===========================================================================
Cyl_Move_Index:	index offset(*),,2
		ptr Cyl_Bottom					; bottom left
		ptr Cyl_Bottom					; bottom right
		ptr Cyl_Top					; top left
		ptr Cyl_Top					; top right
; ===========================================================================

Cyl_Bottom:
		tst.b	ost_cylinder_flag(a0)			; is cylinder extending?
		bne.s	.extend					; if yes, branch
		movea.l	ost_cylinder_parent(a0),a1		; get address of OST of parent (Eggman)
		tst.b	ost_col_property(a1)			; has boss been beaten?
		bne.s	.not_beaten				; if not, branch
		bsr.w	BossExplode				; spawn explosion
		subi.l	#$10000,ost_cylinder_y_move(a0)

	.not_beaten:
		addi.l	#$20000,ost_cylinder_y_move(a0)		; retract 2px
		bcc.s	.exit					; branch if not fully retracted
		clr.l	ost_cylinder_y_move(a0)			; reset to 0
		movea.l	ost_cylinder_parent(a0),a1		; get address of OST of parent
		subq.w	#1,ost_fz_phase_state(a1)
		clr.w	ost_fz_cylinder_flag(a1)
		subq.b	#2,ost_routine(a0)			; goto Cyl_Action next
		rts	
; ===========================================================================

.extend:
		cmpi.w	#-$10,ost_cylinder_y_move(a0)		; has cylinder moved at least 16px?
		bge.s	.after_16px				; if yes, branch
		subi.l	#$28000,ost_cylinder_y_move(a0)		; move 2.5px

	.after_16px:
		subi.l	#$8000,ost_cylinder_y_move(a0)		; move 0.5px
		cmpi.w	#-$A0,ost_cylinder_y_move(a0)		; has cylinder moved 160px?
		bgt.s	.exit					; if yes, branch
		clr.w	ost_cylinder_y_move+2(a0)		; clear subpixel
		move.w	#-$A0,ost_cylinder_y_move(a0)		; align to 160px
		clr.b	ost_cylinder_flag(a0)			; clear extending flag

.exit:
		rts	
; ===========================================================================

Cyl_Top:
		bset	#render_yflip_bit,ost_render(a0)
		tst.b	ost_cylinder_flag(a0)
		bne.s	.extend
		movea.l	ost_cylinder_parent(a0),a1
		tst.b	ost_col_property(a1)
		bne.s	.not_beaten
		bsr.w	BossExplode
		addi.l	#$10000,ost_cylinder_y_move(a0)

	.not_beaten:
		subi.l	#$20000,ost_cylinder_y_move(a0)
		bcc.s	.exit
		clr.l	ost_cylinder_y_move(a0)
		movea.l	ost_cylinder_parent(a0),a1
		subq.w	#1,ost_fz_phase_state(a1)
		clr.w	ost_fz_cylinder_flag(a1)
		subq.b	#2,ost_routine(a0)			; goto Cyl_Action next
		rts	
; ===========================================================================

.extend:
		cmpi.w	#$10,ost_cylinder_y_move(a0)
		blt.s	.after_16px
		addi.l	#$28000,ost_cylinder_y_move(a0)

	.after_16px:
		addi.l	#$8000,ost_cylinder_y_move(a0)
		cmpi.w	#$A0,ost_cylinder_y_move(a0)
		blt.s	.exit
		clr.w	ost_cylinder_y_move+2(a0)
		move.w	#$A0,ost_cylinder_y_move(a0)
		clr.b	ost_cylinder_flag(a0)

.exit:
		rts	
