; ---------------------------------------------------------------------------
; Object 51 - smashable	green block (MZ)
; ---------------------------------------------------------------------------

SmashBlock:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Smab_Index(pc,d0.w),d1
		jsr	Smab_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Smab_Index:	index *,,2
		ptr Smab_Main
		ptr Smab_Solid
		ptr Smab_Points

ost_smash_sonic_ani:	equ $32					; Sonic's current animation number
ost_smash_count:	equ $34					; number of blocks hit + enemies previously hit in a single jump (2 bytes)
; ===========================================================================

Smab_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Smab,ost_mappings(a0)
		move.w	#tile_Nem_MzBlock+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#4,ost_priority(a0)
		move.b	ost_subtype(a0),ost_frame(a0)

Smab_Solid:	; Routine 2

		move.w	(v_enemy_combo).w,ost_smash_count(a0)
		move.b	(v_ost_player+ost_anim).w,ost_smash_sonic_ani(a0) ; load Sonic's animation number
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject
		btst	#status_platform_bit,ost_status(a0)	; has Sonic landed on the block?
		bne.s	@smash					; if yes, branch

	@notspinning:
		rts	
; ===========================================================================

@smash:
		cmpi.b	#id_Roll,ost_smash_sonic_ani(a0)	; is Sonic rolling/jumping?
		bne.s	@notspinning				; if not, branch
		move.w	ost_smash_count(a0),(v_enemy_combo).w
		bset	#status_jump_bit,ost_status(a1)
		move.b	#$E,ost_height(a1)
		move.b	#7,ost_width(a1)
		move.b	#id_Roll,ost_anim(a1)			; make Sonic roll
		move.w	#-$300,ost_y_vel(a1)			; rebound Sonic
		bset	#status_air_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a1)
		move.b	#id_Sonic_Control,ost_routine(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)
		move.b	#id_frame_smash_four,ost_frame(a0)
		lea	(Smab_Speeds).l,a4			; load broken fragment speed data
		moveq	#3,d1					; set number of	fragments to 4
		move.w	#$38,d2
		bsr.w	SmashObject
		bsr.w	FindFreeObj
		bne.s	Smab_Points
		move.b	#id_Points,0(a1)			; load points object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	(v_enemy_combo).w,d2
		addq.w	#2,(v_enemy_combo).w			; increment bonus counter
		cmpi.w	#6,d2					; have fewer than 3 blocks broken?
		bcs.s	@bonus					; if yes, branch
		moveq	#6,d2					; set cap for points

	@bonus:
		moveq	#0,d0
		move.w	Smab_Scores(pc,d2.w),d0
		cmpi.w	#$20,(v_enemy_combo).w			; have 16 blocks been smashed?
		bcs.s	@givepoints				; if not, branch
		move.w	#1000,d0				; give higher points for 16th block
		moveq	#10,d2

	@givepoints:
		jsr	(AddPoints).l
		lsr.w	#1,d2
		move.b	d2,ost_frame(a1)

Smab_Points:	; Routine 4
		bsr.w	SpeedToPos
		addi.w	#$38,ost_y_vel(a0)
		bsr.w	DisplaySprite
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		rts	
; ===========================================================================
Smab_Speeds:	dc.w -$200, -$200				; x speed, y speed
		dc.w -$100, -$100
		dc.w $200, -$200
		dc.w $100, -$100

Smab_Scores:	dc.w 10, 20, 50, 100
