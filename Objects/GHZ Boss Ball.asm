; ---------------------------------------------------------------------------
; Object 48 - ball on a	chain that Eggman swings (GHZ)
; ---------------------------------------------------------------------------

include_BossBall_1:	macro

BossBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GBall_Index(pc,d0.w),d1
		jmp	GBall_Index(pc,d1.w)
; ===========================================================================
GBall_Index:	index *,,2
		ptr GBall_Main
		ptr GBall_Base
		ptr GBall_Display2
		ptr GBall_Link
		ptr GBall_ChkVanish

ost_ball_boss_dist:	equ $32					; distance of base from boss (2 bytes)
ost_ball_parent:	equ $34					; address of OST of parent object (4 bytes)
ost_ball_base_y_pos:	equ $38					; y position of base (2 bytes)
ost_ball_base_x_pos:	equ $3A					; x position of base (2 bytes)
ost_ball_base_dist:	equ $3C					; distance of ball/link from base
ost_ball_direction:	equ $3D					; swing direction - 0 = left; 1 = right
ost_ball_angle:		equ $3E					; swing angle (2 bytes)
; ===========================================================================

GBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$4080,ost_angle(a0)
		move.w	#-$200,ost_ball_angle(a0)
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#tile_Nem_Weapons,ost_tile(a0)
		lea	ost_subtype(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_17B60
; ===========================================================================

GBall_MakeLinks:
		jsr	(FindNextFreeObj).l
		bne.s	GBall_MakeBall
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_BossBall,0(a1)			; load chain link object
		move.b	#id_GBall_Link,ost_routine(a1)
		move.l	#Map_Swing_GHZ,ost_mappings(a1)
		move.w	#tile_Nem_Swing,ost_tile(a1)
		move.b	#id_frame_swing_chain,ost_frame(a1)
		addq.b	#1,ost_subtype(a0)

loc_17B60:
		move.w	a1,d5
		subi.w	#v_ost_all&$FFFF,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#render_rel,ost_render(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#6,ost_priority(a1)
		move.l	ost_ball_parent(a0),ost_ball_parent(a1)
		dbf	d1,GBall_MakeLinks			; repeat sequence 5 more times

GBall_MakeBall:
		move.b	#id_GBall_ChkVanish,ost_routine(a1)
		move.l	#Map_GBall,ost_mappings(a1)		; load different mappings for final link
		move.w	#tile_Nem_Ball+tile_pal3,ost_tile(a1)	; use different graphics
		move.b	#id_frame_ball_check1,ost_frame(a1)
		move.b	#5,ost_priority(a1)
		move.b	#id_col_20x20+id_col_hurt,ost_col_type(a1) ; make object hurt Sonic
		rts	
; ===========================================================================

GBall_PosData:	dc.b 0,	$10, $20, $30, $40, $60			; y-position data for links and	giant ball

; ===========================================================================

GBall_Base:	; Routine 2
		lea	(GBall_PosData).l,a3
		lea	ost_subtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_17BC6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_ost_all&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	ost_ball_base_dist(a1),d0
		beq.s	loc_17BE0
		addq.b	#1,ost_ball_base_dist(a1)

loc_17BE0:
		dbf	d6,loc_17BC6

		cmp.b	ost_ball_base_dist(a1),d0
		bne.s	loc_17BFA
		movea.l	ost_ball_parent(a0),a1
		cmpi.b	#6,ost_routine2(a1)
		bne.s	loc_17BFA
		addq.b	#2,ost_routine(a0)

loc_17BFA:
		cmpi.w	#$20,ost_ball_boss_dist(a0)
		beq.s	GBall_Display
		addq.w	#1,ost_ball_boss_dist(a0)

GBall_Display:
		bsr.w	sub_17C2A
		move.b	ost_angle(a0),d0
		jsr	(Swing_Move2).l
		jmp	(DisplaySprite).l
; ===========================================================================

GBall_Display2:	; Routine 4
		bsr.w	sub_17C2A
		jsr	(GBall_Move).l
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_17C2A:
		movea.l	ost_ball_parent(a0),a1
		addi.b	#$20,ost_anim_frame(a0)
		bcc.s	loc_17C3C
		bchg	#0,ost_frame(a0)

loc_17C3C:
		move.w	ost_x_pos(a1),ost_ball_base_x_pos(a0)
		move.w	ost_y_pos(a1),d0
		add.w	ost_ball_boss_dist(a0),d0
		move.w	d0,ost_ball_base_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		tst.b	ost_status(a1)
		bpl.s	locret_17C66
		move.b	#id_ExplosionBomb,0(a0)
		move.b	#id_ExBom_Main,ost_routine(a0)

locret_17C66:
		rts	
; End of function sub_17C2A

; ===========================================================================

GBall_Link:	; Routine 6
		movea.l	ost_ball_parent(a0),a1
		tst.b	ost_status(a1)
		bpl.s	GBall_Display3
		move.b	#id_ExplosionBomb,0(a0)
		move.b	#id_ExBom_Main,ost_routine(a0)

GBall_Display3:
		jmp	(DisplaySprite).l
; ===========================================================================

GBall_ChkVanish:; Routine 8
		moveq	#0,d0
		tst.b	ost_frame(a0)
		bne.s	GBall_Vanish
		addq.b	#1,d0

GBall_Vanish:
		move.b	d0,ost_frame(a0)
		movea.l	ost_ball_parent(a0),a1
		tst.b	ost_status(a1)
		bpl.s	GBall_Display4
		move.b	#0,ost_col_type(a0)
		bsr.w	BossDefeated
		subq.b	#1,ost_ball_base_dist(a0)
		bpl.s	GBall_Display4
		move.b	#id_ExplosionBomb,(a0)
		move.b	#id_ExBom_Main,ost_routine(a0)

GBall_Display4:
		jmp	(DisplaySprite).l
; ===========================================================================

		endm
		
; ---------------------------------------------------------------------------
; Object 48 - ball on a	chain that Eggman swings (GHZ), part 2
; ---------------------------------------------------------------------------

include_BossBall_2:	macro

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


GBall_Move:
		tst.b	ost_ball_direction(a0)			; is ball swinging right?
		bne.s	@right					; if yes, branch
		move.w	ost_ball_angle(a0),d0
		addq.w	#8,d0
		move.w	d0,ost_ball_angle(a0)
		add.w	d0,ost_angle(a0)
		cmpi.w	#$200,d0
		bne.s	@not_at_highest
		move.b	#1,ost_ball_direction(a0)
		bra.s	@not_at_highest
; ===========================================================================

	@right:
		move.w	ost_ball_angle(a0),d0
		subq.w	#8,d0
		move.w	d0,ost_ball_angle(a0)
		add.w	d0,ost_angle(a0)
		cmpi.w	#-$200,d0
		bne.s	@not_at_highest
		move.b	#0,ost_ball_direction(a0)

	@not_at_highest:
		move.b	ost_angle(a0),d0
; End of function GBall_Move

		endm
		
