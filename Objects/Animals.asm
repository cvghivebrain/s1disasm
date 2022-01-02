; ---------------------------------------------------------------------------
; Object 28 - animals

; spawned by:
;	ExplosionItem - subtype 0
;	Prison - subtype 0
;	ObjPos_End - subtypes $A, $C-$14
; ---------------------------------------------------------------------------

Animals:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Anml_Index(pc,d0.w),d1
		jmp	Anml_Index(pc,d1.w)
; ===========================================================================
Anml_Index:	index *,,2
		ptr Anml_Main
		ptr Anml_ChkFloor
		ptr Anml_Type0
		ptr Anml_Type1
		ptr Anml_Type0
		ptr Anml_Type0
		ptr Anml_Type0
		ptr Anml_Type5
		ptr Anml_Type0
		ptr Anml_FromPrison
		ptr Anml_End_0A
		ptr Anml_End_0A
		ptr Anml_End_0C
		ptr Anml_End_0D
		ptr Anml_End_0E
		ptr Anml_End_0F
		ptr Anml_End_0E
		ptr Anml_End_0F
		ptr Anml_End_0E
		ptr Anml_End_13
		ptr Anml_End_14

Anml_VarIndex:	dc.b 0,	5					; GHZ
		dc.b 2, 3					; LZ
		dc.b 6, 3					; MZ
		dc.b 4, 5					; SLZ
		dc.b 4,	1					; SYZ
		dc.b 0, 1					; SBZ

Anml_Variables:	dc.w -$200, -$400				; type 0 - GHZ/SBZ
		dc.l Map_Animal1
		dc.w -$200, -$300				; type 1 - SYZ/SBZ
		dc.l Map_Animal2
		dc.w -$180, -$300				; type 2 - LZ
		dc.l Map_Animal1
		dc.w -$140, -$180				; type 3 - MZ/LZ
		dc.l Map_Animal2
		dc.w -$1C0, -$300				; type 4 - SYZ/SLZ
		dc.l Map_Animal3
		dc.w -$300, -$400				; type 5 - GHZ/SLZ
		dc.l Map_Animal2
		dc.w -$280, -$380				; type 6 - MZ
		dc.l Map_Animal3

Anml_EndSpeed:	dc.w -$440, -$400				; $A
		dc.w -$440, -$400				; $B
		dc.w -$440, -$400				; $C
		dc.w -$300, -$400				; $D
		dc.w -$300, -$400				; $E
		dc.w -$180, -$300				; $F
		dc.w -$180, -$300				; $10
		dc.w -$140, -$180				; $11
		dc.w -$1C0, -$300				; $12
		dc.w -$200, -$300				; $13
		dc.w -$280, -$380				; $14

Anml_EndMap:	dc.l Map_Animal2				; $A
		dc.l Map_Animal2				; $B - unused
		dc.l Map_Animal2				; $C
		dc.l Map_Animal1				; $D
		dc.l Map_Animal1				; $E
		dc.l Map_Animal1				; $F
		dc.l Map_Animal1				; $10
		dc.l Map_Animal2				; $11
		dc.l Map_Animal3				; $12
		dc.l Map_Animal2				; $13
		dc.l Map_Animal3				; $14

Anml_EndVram:	dc.w tile_Nem_Flicky_End			; $A
		dc.w tile_Nem_Flicky_End			; $B - unused
		dc.w tile_Nem_Flicky_End			; $C
		dc.w tile_Nem_Rabbit_End			; $D
		dc.w tile_Nem_Rabbit_End			; $E
		dc.w tile_Nem_BlackBird_End			; $F
		dc.w tile_Nem_BlackBird_End			; $10
		dc.w tile_Nem_Seal_End				; $11
		dc.w tile_Nem_Pig_End				; $12
		dc.w tile_Nem_Chicken_End			; $13
		dc.w tile_Nem_Squirrel_End			; $14

ost_animal_direction:	equ $29					; animal goes left/right
ost_animal_type:	equ $30					; type of animal (0-$B)
ost_animal_x_vel:	equ $32					; horizontal speed (2 bytes)
ost_animal_y_vel:	equ $34					; vertical speed (2 bytes)
ost_animal_prison_num:	equ $36					; id num for animals in prison capsule, lets them jummp out 1 at a time (2 bytes)
; ===========================================================================

Anml_Main:	; Routine 0
		tst.b	ost_subtype(a0)				; did animal come from an enemy or prison capsule?
		beq.w	Anml_FromEnemy				; if yes, branch

		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; move object type to d0
		add.w	d0,d0					; multiply d0 by 2
		move.b	d0,ost_routine(a0)			; move d0 to routine counter
		subi.w	#$14,d0
		move.w	Anml_EndVram(pc,d0.w),ost_tile(a0)	; get VRAM tile number
		add.w	d0,d0
		move.l	Anml_EndMap(pc,d0.w),ost_mappings(a0)	; get mappings pointer
		lea	Anml_EndSpeed(pc),a1
		move.w	(a1,d0.w),ost_animal_x_vel(a0)		; load horizontal speed
		move.w	(a1,d0.w),ost_x_vel(a0)
		move.w	2(a1,d0.w),ost_animal_y_vel(a0)		; load vertical speed
		move.w	2(a1,d0.w),ost_y_vel(a0)
		move.b	#$C,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_xflip_bit,ost_render(a0)
		move.b	#6,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0)
		bra.w	DisplaySprite
; ===========================================================================

Anml_FromEnemy:
		addq.b	#2,ost_routine(a0)			; goto Anml_ChkFloor next
		bsr.w	RandomNumber
		andi.w	#1,d0					; d0 = random 0 or 1
		moveq	#0,d1
		move.b	(v_zone).w,d1				; get zone number
		add.w	d1,d1
		add.w	d0,d1					; d1 = (v_zone*2) + 0 or 1
		lea	Anml_VarIndex(pc),a1
		move.b	(a1,d1.w),d0				; get type from index based on zone + random 0 or 1
		move.b	d0,ost_animal_type(a0)
		lsl.w	#3,d0					; multiply by 8
		lea	Anml_Variables(pc),a1
		adda.w	d0,a1					; jump to actual variables
		move.w	(a1)+,ost_animal_x_vel(a0)		; load horizontal speed
		move.w	(a1)+,ost_animal_y_vel(a0)		; load vertical speed
		move.l	(a1)+,ost_mappings(a0)			; load mappings
		move.w	#tile_Nem_Rabbit,ost_tile(a0)		; VRAM setting for 1st animal
		btst	#0,ost_animal_type(a0)			; was the random bit 0?
		beq.s	@type_0					; if yes, branch
		move.w	#tile_Nem_Flicky,ost_tile(a0)		; VRAM setting for 2nd animal

	@type_0:
		move.b	#$C,ost_height(a0)
		move.b	#render_rel,ost_render(a0)
		bset	#render_xflip_bit,ost_render(a0)
		move.b	#6,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#7,ost_anim_time(a0)
		move.b	#id_frame_animal1_drop,ost_frame(a0)	; use "dropping" frame
		move.w	#-$400,ost_y_vel(a0)
		tst.b	(v_boss_status).w			; has boss been beaten?
		bne.s	@after_boss				; if yes, branch
		bsr.w	FindFreeObj
		bne.s	@display
		move.b	#id_Points,ost_id(a1)			; load points object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.w	ost_enemy_combo(a0),d0
		lsr.w	#1,d0
		move.b	d0,ost_frame(a1)

	@display:
		bra.w	DisplaySprite
; ===========================================================================

@after_boss:
		move.b	#id_Anml_FromPrison,ost_routine(a0)	; goto Anml_FromPrison next
		clr.w	ost_x_vel(a0)
		bra.w	DisplaySprite
; ===========================================================================

Anml_ChkFloor:	; Routine 2
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	DeleteObject				; if not, branch
		bsr.w	ObjectFall				; make object fall and update its position
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@display				; if yes, branch

		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@display				; if not, branch

		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_x_vel(a0),ost_x_vel(a0)	; reset speed
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)
		move.b	#id_frame_animal1_flap2,ost_frame(a0)	; use flapping frame
		move.b	ost_animal_type(a0),d0			; get type
		add.b	d0,d0
		addq.b	#4,d0					; d0 = (type*2) + 4
		move.b	d0,ost_routine(a0)			; goto relevant routine next
		tst.b	(v_boss_status).w			; has boss been beaten?
		beq.s	@display				; if not, branch
		btst	#4,(v_vblank_counter_byte).w		; check bit that changes every 16 frames
		beq.s	@display				; branch if 0
		neg.w	ost_x_vel(a0)				; reverse direction
		bchg	#render_xflip_bit,ost_render(a0)

	@display:
		bra.w	DisplaySprite
; ===========================================================================

Anml_Type0:	; Routine 6, $A, $C, $E, $12
		bsr.w	ObjectFall				; make object fall and update its position
		move.b	#id_frame_animal1_flap2,ost_frame(a0)
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@chkdel					; if yes, branch

		move.b	#id_frame_animal1_flap1,ost_frame(a0)
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@chkdel					; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)	; reset y speed

	@chkdel:
		tst.b	ost_subtype(a0)				; is this an animal from the ending?
		bne.s	Anml_End_ChkDel				; if yes, branch
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	DeleteObject				; if not, branch
		bra.w	DisplaySprite
; ===========================================================================

Anml_Type1:	; Routine 8
Anml_Type5:	; Routine $10
		bsr.w	SpeedToPos				; update object position
		addi.w	#$18,ost_y_vel(a0)			; make object fall downwards
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@animate				; if yes, branch

		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@animate				; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)	; reset y speed
		tst.b	ost_subtype(a0)				; is this an animal from the ending?
		beq.s	@animate				; if not, branch

		cmpi.b	#$A,ost_subtype(a0)
		beq.s	@animate
		neg.w	ost_x_vel(a0)
		bchg	#render_xflip_bit,ost_render(a0)

	@animate:
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bpl.s	@chkdel					; branch if time remains
		move.b	#1,ost_anim_time(a0)			; set timer to 1 frame
		addq.b	#1,ost_frame(a0)			; change frame
		andi.b	#1,ost_frame(a0)			; limit to 2 frames

	@chkdel:
		tst.b	ost_subtype(a0)
		bne.s	Anml_End_ChkDel
		tst.b	ost_render(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

Anml_End_ChkDel:
		move.w	ost_x_pos(a0),d0
		sub.w	(v_ost_player+ost_x_pos).w,d0		; d0 = distance between Sonic & object (+ve if Sonic is to the left)
		bcs.s	@display				; branch if Sonic is to the right
		subi.w	#384,d0
		bpl.s	@display				; branch if Sonic is > 384px to the left
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	DeleteObject				; if not, branch

	@display:
		bra.w	DisplaySprite
; ===========================================================================

Anml_FromPrison:	; Routine $14
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	DeleteObject				; if not, branch
		subq.w	#1,ost_animal_prison_num(a0)		; decrement prison queue ticket
		bne.w	@display				; branch if not 0
		move.b	#id_Anml_ChkFloor,ost_routine(a0)	; goto Anml_ChkFloor next
		move.b	#3,ost_priority(a0)

	@display:
		bra.w	DisplaySprite
; ===========================================================================

Anml_End_0A:	; Routine $16, $18
		bsr.w	Anml_End_ChkDist
		bcc.s	@far_away				; branch if Sonic is to the left, or > 184px right

		move.w	ost_animal_x_vel(a0),ost_x_vel(a0)	; reset speed
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)
		move.b	#id_Anml_Type5,ost_routine(a0)		; goto Anml_Type1 next
		bra.w	Anml_Type1

	@far_away:
		bra.w	Anml_End_ChkDel
; ===========================================================================

Anml_End_0C:	; Routine $1A
		bsr.w	Anml_End_ChkDist
		bpl.s	@far_away				; branch if Sonic is > 184px to the right
		clr.w	ost_x_vel(a0)
		clr.w	ost_animal_x_vel(a0)
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0)
		bsr.w	Anml_End_Update
		bsr.w	Anml_End_ChkDirection
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bpl.s	@far_away				; branch if time remains
		move.b	#1,ost_anim_time(a0)			; set timer to 1 frame
		addq.b	#1,ost_frame(a0)			; change frame
		andi.b	#1,ost_frame(a0)			; limit to 2 frames

	@far_away:
		bra.w	Anml_End_ChkDel
; ===========================================================================

Anml_End_0D:	; Routine $1C
		bsr.w	Anml_End_ChkDist
		bpl.s	Anml_End_ChkDel_			; branch if Sonic is > 184px to the right
		move.w	ost_animal_x_vel(a0),ost_x_vel(a0)	; reset speed
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)
		move.b	#id_Anml_Type0,ost_routine(a0)		; goto Anml_Type0 next
		bra.w	Anml_Type0
; ===========================================================================

Anml_End_14:	; Routine $2A
		bsr.w	ObjectFall				; make object fall and update position
		move.b	#id_frame_animal1_flap2,ost_frame(a0)
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	Anml_End_ChkDel_			; if yes, branch
		move.b	#id_frame_animal1_flap1,ost_frame(a0)
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	Anml_End_ChkDel_			; if not, branch
		not.b	ost_animal_direction(a0)		; change direction flag
		bne.s	@no_flip				; branch if 1
		neg.w	ost_x_vel(a0)				; reverse direction
		bchg	#render_xflip_bit,ost_render(a0)

	@no_flip:
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)	; reset y speed

Anml_End_ChkDel_:
		bra.w	Anml_End_ChkDel
; ===========================================================================

Anml_End_0E:	; Routine $1E, $22, $26
		bsr.w	Anml_End_ChkDist
		bpl.s	@far_away				; branch if Sonic is > 184px to the right
		clr.w	ost_x_vel(a0)
		clr.w	ost_animal_x_vel(a0)
		bsr.w	ObjectFall				; make object fall and update position
		bsr.w	Anml_End_Update
		bsr.w	Anml_End_ChkDirection

	@far_away:
		bra.w	Anml_End_ChkDel
; ===========================================================================

Anml_End_0F:	; Routine $20, $24
		bsr.w	Anml_End_ChkDist
		bpl.s	@chkdel					; branch if Sonic is > 184px to the right
		bsr.w	ObjectFall				; make object fall and update position
		move.b	#id_frame_animal1_flap2,ost_frame(a0)
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@chkdel					; if yes, branch
		move.b	#id_frame_animal1_flap1,ost_frame(a0)
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@chkdel					; if not, branch
		neg.w	ost_x_vel(a0)				; reverse direction
		bchg	#render_xflip_bit,ost_render(a0)
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)	; reset y speed

	@chkdel:
		bra.w	Anml_End_ChkDel
; ===========================================================================

Anml_End_13:	; Routine $28
		bsr.w	Anml_End_ChkDist
		bpl.s	@chkdel					; branch if Sonic is > 184px to the right
		bsr.w	SpeedToPos				; update position
		addi.w	#$18,ost_y_vel(a0)			; fall
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@chk_anim				; if yes, branch
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@chk_anim				; if not, branch
		not.b	ost_animal_direction(a0)		; change direction flag
		bne.s	@no_flip				; branch if 1
		neg.w	ost_x_vel(a0)				; reverse direction
		bchg	#render_xflip_bit,ost_render(a0)

	@no_flip:
		add.w	d1,ost_y_pos(a0)
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)

	@chk_anim:
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bpl.s	@chkdel					; branch if time remains
		move.b	#1,ost_anim_time(a0)			; set timer to 1 frame
		addq.b	#1,ost_frame(a0)			; change frame
		andi.b	#1,ost_frame(a0)			; limit to 2 frames

	@chkdel:
		bra.w	Anml_End_ChkDel

; ---------------------------------------------------------------------------
; Subroutine to animate and bounce on floor
; ---------------------------------------------------------------------------

Anml_End_Update:
		move.b	#id_frame_animal1_flap2,ost_frame(a0)
		tst.w	ost_y_vel(a0)				; is object currently moving upwards?
		bmi.s	@exit					; if yes, branch
		move.b	#id_frame_animal1_flap1,ost_frame(a0)
		jsr	(FindFloorObj).l
		tst.w	d1					; has object hit the floor?
		bpl.s	@exit					; if not, branch
		add.w	d1,ost_y_pos(a0)			; align to floor
		move.w	ost_animal_y_vel(a0),ost_y_vel(a0)	; reset y speed

	@exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to set/clear xflip bit if Sonic is to the left/right respectively
; ---------------------------------------------------------------------------

Anml_End_ChkDirection:
		bset	#render_xflip_bit,ost_render(a0)	; set bit
		move.w	ost_x_pos(a0),d0
		sub.w	(v_ost_player+ost_x_pos).w,d0		; d0 = distance between Sonic & object (-ve if Sonic is to the right)
		bcc.s	@exit					; branch if Sonic is to the left
		bclr	#render_xflip_bit,ost_render(a0)	; clear bit

	@exit:
		rts	

; ---------------------------------------------------------------------------
; Subroutine to check if Sonic is more than 184px to the right

; output:
;	d0 = +ve if true; -ve if false
; ---------------------------------------------------------------------------

Anml_End_ChkDist:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0			; d0 = distance between Sonic & object (-ve if Sonic is to the left)
		subi.w	#184,d0					; d0 is -ve if Sonic is left, or < 184px right
		rts	
; End of function Anml_End_ChkDist
