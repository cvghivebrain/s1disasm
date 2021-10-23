; ---------------------------------------------------------------------------
; Object 7B - exploding	spikeys	that Eggman drops (SLZ)
; ---------------------------------------------------------------------------

BossSpikeball:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj7B_Index(pc,d0.w),d0
		jsr	Obj7B_Index(pc,d0.w)
		move.w	ost_bspike_x_start(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	Obj7A_Delete
		cmpi.w	#$280,d0
		bhi.w	Obj7A_Delete
		jmp	(DisplaySprite).l
; ===========================================================================
Obj7B_Index:	index *,,2
		ptr Obj7B_Main
		ptr Obj7B_Fall
		ptr loc_18DC6
		ptr loc_18EAA
		ptr Obj7B_Explode
		ptr Obj7B_MoveFrag

ost_bspike_x_start:	equ $30	; original x position (2 bytes)
ost_bspike_y_start:	equ $34	; original y position (2 bytes)
ost_bspike_state:	equ $3A	; 0/2 = seesaw tilted; 1/3 = flat
ost_bspike_seesaw:	equ $3C	; address of OST of seesaw (4 bytes)
; ===========================================================================

Obj7B_Main:	; Routine 0
		move.l	#Map_SSawBall,ost_mappings(a0)
		move.w	#tile_Nem_SlzSpike_Boss,ost_tile(a0)
		move.b	#id_frame_seesaw_silver,ost_frame(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$8B,ost_col_type(a0)
		move.b	#$C,ost_actwidth(a0)
		movea.l	ost_bspike_seesaw(a0),a1
		move.w	ost_x_pos(a1),ost_bspike_x_start(a0)
		move.w	ost_y_pos(a1),ost_bspike_y_start(a0)
		bset	#status_xflip_bit,ost_status(a0)
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_x_pos(a1),d0
		bgt.s	loc_18D68
		bclr	#status_xflip_bit,ost_status(a0)
		move.b	#2,ost_bspike_state(a0)

loc_18D68:
		addq.b	#2,ost_routine(a0)

Obj7B_Fall:	; Routine 2
		jsr	(ObjectFall).l
		movea.l	ost_bspike_seesaw(a0),a1
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	loc_18D8E
		addq.w	#2,d0

loc_18D8E:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	ost_y_pos(a0),d1
		bgt.s	locret_18DC4
		movea.l	ost_bspike_seesaw(a0),a1
		moveq	#2,d1
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	loc_18DAE
		moveq	#0,d1

loc_18DAE:
		move.w	#$F0,ost_subtype(a0)
		move.b	#10,ost_anim_delay(a0) ; set frame duration to 10 frames
		move.b	ost_anim_delay(a0),ost_anim_time(a0)
		bra.w	loc_18FA2
; ===========================================================================

locret_18DC4:
		rts	
; ===========================================================================

loc_18DC6:	; Routine 4
		movea.l	ost_bspike_seesaw(a0),a1
		moveq	#0,d0
		move.b	ost_bspike_state(a0),d0
		sub.b	ost_seesaw_state(a1),d0
		beq.s	loc_18E2A
		bcc.s	loc_18DDA
		neg.b	d0

loc_18DDA:
		move.w	#-$818,d1
		move.w	#-$114,d2
		cmpi.b	#1,d0
		beq.s	loc_18E00
		move.w	#-$960,d1
		move.w	#-$F4,d2
		cmpi.w	#$9C0,ost_seesaw_impact(a1)
		blt.s	loc_18E00
		move.w	#-$A20,d1
		move.w	#-$80,d2

loc_18E00:
		move.w	d1,ost_y_vel(a0)
		move.w	d2,ost_x_vel(a0)
		move.w	ost_x_pos(a0),d0
		sub.w	ost_bspike_x_start(a0),d0
		bcc.s	loc_18E16
		neg.w	ost_x_vel(a0)

loc_18E16:
		move.b	#id_frame_seesaw_silver,ost_frame(a0)
		move.w	#$20,ost_subtype(a0)
		addq.b	#2,ost_routine(a0)
		bra.w	loc_18EAA
; ===========================================================================

loc_18E2A:
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0
		move.w	#$28,d2
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	loc_18E48
		neg.w	d2
		addq.w	#2,d0

loc_18E48:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1
		move.w	d1,ost_y_pos(a0)
		add.w	ost_bspike_x_start(a0),d2
		move.w	d2,ost_x_pos(a0)
		clr.w	ost_y_pos+2(a0)
		clr.w	ost_x_pos+2(a0)
		subq.w	#1,ost_subtype(a0)
		bne.s	loc_18E7A
		move.w	#$20,ost_subtype(a0)
		move.b	#8,ost_routine(a0)
		rts	
; ===========================================================================

loc_18E7A:
		cmpi.w	#$78,ost_subtype(a0)
		bne.s	loc_18E88
		move.b	#5,ost_anim_delay(a0)

loc_18E88:
		cmpi.w	#$3C,ost_subtype(a0)
		bne.s	loc_18E96
		move.b	#2,ost_anim_delay(a0)

loc_18E96:
		subq.b	#1,ost_anim_time(a0)
		bgt.s	locret_18EA8
		bchg	#0,ost_frame(a0)
		move.b	ost_anim_delay(a0),ost_anim_time(a0)

locret_18EA8:
		rts	
; ===========================================================================

loc_18EAA:	; Routine 6
		lea	(v_ost_all+$40).w,a1
		moveq	#id_BossStarLight,d0
		moveq	#$40,d1
		moveq	#$3E,d2

loc_18EB4:
		cmp.b	(a1),d0
		beq.s	loc_18EC0
		adda.w	d1,a1
		dbf	d2,loc_18EB4

		bra.s	loc_18F38
; ===========================================================================

loc_18EC0:
		move.w	ost_x_pos(a1),d0
		move.w	ost_y_pos(a1),d1
		move.w	ost_x_pos(a0),d2
		move.w	ost_y_pos(a0),d3
		lea	byte_19022(pc),a2
		lea	byte_19026(pc),a3
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d0,d2
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d0
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d2
		cmp.w	d2,d0
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d1,d3
		bcs.s	loc_18F38
		move.b	(a2)+,d4
		ext.w	d4
		add.w	d4,d1
		move.b	(a3)+,d4
		ext.w	d4
		add.w	d4,d3
		cmp.w	d3,d1
		bcs.s	loc_18F38
		addq.b	#2,ost_routine(a0)
		clr.w	ost_subtype(a0)
		clr.b	ost_col_type(a1)
		subq.b	#1,ost_col_property(a1)
		bne.s	loc_18F38
		bset	#status_onscreen_bit,ost_status(a1)
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)

loc_18F38:
		tst.w	ost_y_vel(a0)
		bpl.s	loc_18F5C
		jsr	(ObjectFall).l
		move.w	ost_bspike_y_start(a0),d0
		subi.w	#$2F,d0
		cmp.w	ost_y_pos(a0),d0
		bgt.s	loc_18F58
		jsr	(ObjectFall).l

loc_18F58:
		bra.w	loc_18E7A
; ===========================================================================

loc_18F5C:
		jsr	(ObjectFall).l
		movea.l	ost_bspike_seesaw(a0),a1
		lea	(word_19018).l,a2
		moveq	#0,d0
		move.b	ost_frame(a1),d0
		move.w	ost_x_pos(a0),d1
		sub.w	ost_bspike_x_start(a0),d1
		bcc.s	loc_18F7E
		addq.w	#2,d0

loc_18F7E:
		add.w	d0,d0
		move.w	ost_bspike_y_start(a0),d1
		add.w	(a2,d0.w),d1
		cmp.w	ost_y_pos(a0),d1
		bgt.s	loc_18F58
		movea.l	ost_bspike_seesaw(a0),a1
		moveq	#2,d1
		tst.w	ost_x_vel(a0)
		bmi.s	loc_18F9C
		moveq	#0,d1

loc_18F9C:
		move.w	#0,ost_subtype(a0)

loc_18FA2:
		move.b	d1,ost_seesaw_state(a1)
		move.b	d1,ost_bspike_state(a0)
		cmp.b	ost_frame(a1),d1
		beq.s	loc_19008
		bclr	#status_platform_bit,ost_status(a1)
		beq.s	loc_19008
		clr.b	ost_routine2(a1)
		move.b	#2,ost_routine(a1)
		lea	(v_ost_all).w,a2
		move.w	ost_y_vel(a0),ost_y_vel(a2)
		neg.w	ost_y_vel(a2)
		cmpi.b	#1,ost_frame(a1)
		bne.s	loc_18FDC
		asr	ost_y_vel(a2)

loc_18FDC:
		bset	#status_air_bit,ost_status(a2)
		bclr	#status_platform_bit,ost_status(a2)
		clr.b	ost_sonic_jump(a2)
		move.l	a0,-(sp)
		lea	(a2),a0
		jsr	(Sonic_ChkRoll).l
		movea.l	(sp)+,a0
		move.b	#2,ost_routine(a2)
		play.w	1, jsr, sfx_Spring		; play "spring" sound

loc_19008:
		clr.w	ost_x_vel(a0)
		clr.w	ost_y_vel(a0)
		addq.b	#2,ost_routine(a0)
		bra.w	loc_18E7A
; ===========================================================================
word_19018:	dc.w -8, -$1C, -$2F, -$1C, -8
		even
byte_19022:	dc.b $E8, $30, $E8, $30
		even
byte_19026:	dc.b 8,	$F0, 8,	$F0
		even
; ===========================================================================

Obj7B_Explode:	; Routine 8
		move.b	#id_ExplosionBomb,(a0)
		clr.b	ost_routine(a0)
		cmpi.w	#$20,ost_subtype(a0)
		beq.s	Obj7B_MakeFrag
		rts	
; ===========================================================================

Obj7B_MakeFrag:
		move.w	ost_bspike_y_start(a0),ost_y_pos(a0)
		moveq	#3,d1
		lea	Obj7B_FragSpeed(pc),a2

Obj7B_Loop:
		jsr	(FindFreeObj).l
		bne.s	loc_1909A
		move.b	#id_BossSpikeball,(a1) ; load shrapnel object
		move.b	#$A,ost_routine(a1)
		move.l	#Map_BSBall,ost_mappings(a1)
		move.b	#3,ost_priority(a1)
		move.w	#tile_Nem_Bomb_Boss,ost_tile(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	(a2)+,ost_x_vel(a1)
		move.w	(a2)+,ost_y_vel(a1)
		move.b	#$98,ost_col_type(a1)
		ori.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a1)
		move.b	#$C,ost_actwidth(a1)

loc_1909A:
		dbf	d1,Obj7B_Loop	; repeat sequence 3 more times

		rts	
; ===========================================================================
Obj7B_FragSpeed:dc.w -$100, -$340	; horizontal, vertical
		dc.w -$A0, -$240
		dc.w $100, -$340
		dc.w $A0, -$240
; ===========================================================================

Obj7B_MoveFrag:	; Routine $A
		jsr	(SpeedToPos).l
		move.w	ost_x_pos(a0),ost_bspike_x_start(a0)
		move.w	ost_y_pos(a0),ost_bspike_y_start(a0)
		addi.w	#$18,ost_y_vel(a0)
		moveq	#4,d0
		and.w	(v_vblank_counter_word).w,d0
		lsr.w	#2,d0
		move.b	d0,ost_frame(a0)
		tst.b	ost_render(a0)
		bpl.w	Obj7A_Delete
		rts	
