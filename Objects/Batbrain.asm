; ---------------------------------------------------------------------------
; Object 55 - Batbrain enemy (MZ)
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

ost_bat_sonic_y_pos:	equ $36	; Sonic's y position (2 bytes)
; ===========================================================================

Bat_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bat,ost_mappings(a0)
		move.w	#tile_Nem_Batbrain+tile_hi,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$C,ost_height(a0)
		move.b	#2,ost_priority(a0)
		move.b	#$B,ost_col_type(a0)
		move.b	#$10,ost_actwidth(a0)

Bat_Action:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		lea	(Ani_Bat).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
@index:		index *
		ptr @dropcheck
		ptr @dropfly
		ptr @flapsound
		ptr @flyup
; ===========================================================================

@dropcheck:
		move.w	#$80,d2
		bsr.w	@chkdistance	; is Sonic < $80 pixels from basaran?
		bcc.s	@nodrop		; if not, branch
		move.w	(v_ost_player+ost_y_pos).w,d0
		move.w	d0,ost_bat_sonic_y_pos(a0)
		sub.w	ost_y_pos(a0),d0
		bcs.s	@nodrop
		cmpi.w	#$80,d0		; is Sonic < $80 pixels from basaran?
		bcc.s	@nodrop		; if not, branch
		tst.w	(v_debuguse).w	; is debug mode	on?
		bne.s	@nodrop		; if yes, branch

		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	@nodrop
		move.b	#id_ani_bat_drop,ost_anim(a0)
		addq.b	#2,ost_routine2(a0)

	@nodrop:
		rts	
; ===========================================================================

@dropfly:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0) ; make basaran fall
		move.w	#$80,d2
		bsr.w	@chkdistance
		move.w	ost_bat_sonic_y_pos(a0),d0
		sub.w	ost_y_pos(a0),d0
		bcs.s	@chkdel
		cmpi.w	#$10,d0		; is basaran close to Sonic vertically?
		bcc.s	@dropmore	; if not, branch
		move.w	d1,ost_x_vel(a0) ; make basaran fly horizontally
		move.w	#0,ost_y_vel(a0) ; stop basaran falling
		move.b	#id_ani_bat_fly,ost_anim(a0)
		addq.b	#2,ost_routine2(a0)

	@dropmore:
		rts	

	@chkdel:
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		rts	
; ===========================================================================

@flapsound:
		move.b	(v_vbla_byte).w,d0
		andi.b	#$F,d0
		bne.s	@nosound
		sfx	sfx_Basaran,0,0,0 ; play flapping sound every 16th frame

	@nosound:
		bsr.w	SpeedToPos
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@isright	; if Sonic is right of basaran, branch
		neg.w	d0

	@isright:
		cmpi.w	#$80,d0		; is Sonic within $80 pixels of basaran?
		bcs.s	@dontflyup	; if yes, branch
		move.b	(v_vbla_byte).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	@dontflyup
		addq.b	#2,ost_routine2(a0)

@dontflyup:
		rts	
; ===========================================================================

@flyup:
		bsr.w	SpeedToPos
		subi.w	#$18,ost_y_vel(a0) ; make basaran fly upwards
		bsr.w	ObjHitCeiling
		tst.w	d1		; has basaran hit the ceiling?
		bpl.s	@noceiling	; if not, branch
		sub.w	d1,ost_y_pos(a0)
		andi.w	#$FFF8,ost_x_pos(a0) ; snap to tile
		clr.w	ost_x_vel(a0)	; stop basaran moving
		clr.w	ost_y_vel(a0)
		clr.b	ost_anim(a0)
		clr.b	ost_routine2(a0)

	@noceiling:
		rts	
; ===========================================================================

; Subroutine to check Sonic's distance from the basaran

; input:
;	d2 = distance to compare

; output:
;	d0 = distance between Sonic and basaran
;	d1 = speed/direction for basaran to fly

@chkdistance:
		move.w	#$100,d1
		bset	#status_xflip_bit,ost_status(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	@right		; if Sonic is right of basaran, branch
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
