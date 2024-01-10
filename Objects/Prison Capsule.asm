; ---------------------------------------------------------------------------
; Object 3E - prison capsule

; spawned by:
;	ObjPos_GHZ3, ObjPos_MZ3, ObjPos_SYZ3, ObjPos_LZ3, ObjPos_SLZ3 - subtypes 0/1
; ---------------------------------------------------------------------------

Prison:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Pri_Index(pc,d0.w),d1
		jsr	Pri_Index(pc,d1.w)
		out_of_range.s	.delete
		jmp	(DisplaySprite).l

	.delete:
		jmp	(DeleteObject).l
; ===========================================================================
Pri_Index:	index offset(*),,2
		ptr Pri_Main
		ptr Pri_Body
		ptr Pri_Switch
		ptr Pri_Switch2
		ptr Pri_Panel
		ptr Pri_Explosion
		ptr Pri_Animals
		ptr Pri_EndAct

		; routine, width, priority, frame
Pri_Var:	dc.b id_Pri_Body, $20, 4, id_frame_prison_capsule ; 0 - body
		dc.b id_Pri_Switch, $C, 5, id_frame_prison_switch1 ; 1 - switch
		dc.b id_Pri_Switch2, $10, 4, id_frame_prison_switch2 ; 2 - unused
		dc.b id_Pri_Panel, $10, 3, id_frame_prison_unused_panel ; 3 - unused

		rsobj Prison,$30
ost_prison_y_start:	rs.w 1					; $30 ; original y position
		rsobjend
; ===========================================================================

Pri_Main:	; Routine 0
		move.l	#Map_Pri,ost_mappings(a0)
		move.w	#tile_Nem_Prison,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	ost_y_pos(a0),ost_prison_y_start(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (0 or 1)
		lsl.w	#2,d0					; multiply by 4
		lea	Pri_Var(pc,d0.w),a1
		move.b	(a1)+,ost_routine(a0)			; goto Pri_Body/Pri_Switch next
		move.b	(a1)+,ost_displaywidth(a0)
		move.b	(a1)+,ost_priority(a0)
		move.b	(a1)+,ost_frame(a0)
		cmpi.w	#8,d0					; is subtype = 2 ?
		bne.s	.not02					; if not, branch

		move.b	#id_col_16x16,ost_col_type(a0)
		move.b	#8,ost_col_property(a0)

	.not02:
		rts	
; ===========================================================================

Pri_Body:	; Routine 2
		cmpi.b	#2,(v_boss_status).w			; has prison been opened?
		beq.s	.is_open				; if yes, branch
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	ost_x_pos(a0),d4
		jmp	(SolidObject).l
; ===========================================================================

.is_open:
		tst.b	ost_solid(a0)				; is Sonic on top of the prison?
		beq.s	.not_on_top				; if not, branch
		clr.b	ost_solid(a0)
		bclr	#status_platform_bit,(v_ost_player+ost_status).w
		bset	#status_air_bit,(v_ost_player+ost_status).w

	.not_on_top:
		move.b	#id_frame_prison_broken,ost_frame(a0)	; use use borken prison frame (2)
		rts	
; ===========================================================================

Pri_Switch:	; Routine 4
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		lea	(Ani_Pri).l,a1
		jsr	(AnimateSprite).l
		move.w	ost_prison_y_start(a0),ost_y_pos(a0)
		tst.b	ost_solid(a0)				; is Sonic on top of the switch?
		beq.s	.not_on_top				; if not, branch

		addq.w	#8,ost_y_pos(a0)			; move switch down 8px
		move.b	#id_Pri_Explosion,ost_routine(a0)	; goto Pri_Explosion next
		move.w	#60,ost_anim_time(a0)			; set time for explosions to 1 sec
		clr.b	(f_hud_time_update).w			; stop time counter
		clr.b	(f_boss_loaded).w			; lock screen position
		move.b	#1,(f_lock_controls).w			; lock controls
		move.w	#(btnR<<8),(v_joypad_hold).w		; make Sonic run to the right
		clr.b	ost_solid(a0)
		bclr	#status_platform_bit,(v_ost_player+ost_status).w
		bset	#status_air_bit,(v_ost_player+ost_status).w

	.not_on_top:
		rts	
; ===========================================================================

Pri_Switch2:
Pri_Panel:
Pri_Explosion:	; Routine 6, 8, $A
		moveq	#7,d0
		and.b	(v_vblank_counter_byte).w,d0		; byte that increments every frame
		bne.s	.noexplosion				; branch if any of bits 0-2 are set

		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	.noexplosion				; branch if not found
		move.b	#id_ExplosionBomb,ost_id(a1)		; load explosion object every 8 frames
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,ost_x_pos(a1)			; pseudorandom position
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,ost_y_pos(a1)

	.noexplosion:
		subq.w	#1,ost_anim_time(a0)			; decrement timer
		beq.s	.makeanimal				; branch if 0
		rts	
; ===========================================================================

.makeanimal:
		move.b	#2,(v_boss_status).w			; set flag for prison open
		move.b	#id_Pri_Animals,ost_routine(a0)		; goto Pri_Animals next
		move.b	#id_frame_prison_blank,ost_frame(a0)	; make switch invisible
		move.w	#150,ost_anim_time(a0)			; set time for additional animals to load to 2.5 secs
		addi.w	#$20,ost_y_pos(a0)
		moveq	#8-1,d6					; number of animals to load
		move.w	#$9A,d5					; animal jumping queue start
		moveq	#-$1C,d4				; relative x position

	.loop:
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	.fail					; branch if not found
		move.b	#id_Animals,ost_id(a1)			; load animal object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		add.w	d4,ost_x_pos(a1)
		addq.w	#7,d4					; next animal loads 7px right
		move.w	d5,ost_animal_prison_num(a1)		; give each animal a num so it jumps at a different time
		subq.w	#8,d5					; decrement queue number
		dbf	d6,.loop				; repeat 7 more	times

	.fail:
		rts	
; ===========================================================================

Pri_Animals:	; Routine $C
		moveq	#7,d0
		and.b	(v_vblank_counter_byte).w,d0		; byte that increments every frame
		bne.s	.noanimal				; branch if any of bits 0-2 are set

		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	.noanimal				; branch if not found
		move.b	#id_Animals,ost_id(a1)			; load animal object every 8 frames
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		jsr	(RandomNumber).l
		andi.w	#$1F,d0
		subq.w	#6,d0
		tst.w	d1
		bpl.s	.ispositive
		neg.w	d0

	.ispositive:
		add.w	d0,ost_x_pos(a1)			; pseudorandom position
		move.w	#$C,ost_animal_prison_num(a1)		; set time for animal to jump out

	.noanimal:
		subq.w	#1,ost_anim_time(a0)			; decrement timer
		bne.s	.wait					; branch if time remains
		addq.b	#2,ost_routine(a0)			; goto Pri_EndAct next
		move.w	#180,ost_anim_time(a0)			; this does nothing

	.wait:
		rts	
; ===========================================================================

Pri_EndAct:	; Routine $E
		moveq	#$40-2,d0
		moveq	#id_Animals,d1
		moveq	#sizeof_ost,d2				; d2 = $40
		lea	(v_ost_player+sizeof_ost).w,a1		; start at first OST slot after Sonic

	.findanimal:
		cmp.b	(a1),d1					; is object $28	(animal) loaded?
		beq.s	.found					; if yes, branch
		adda.w	d2,a1					; next OST slot
		dbf	d0,.findanimal				; repeat $3E times (this misses the last $40 OST slots)

		jsr	(HasPassedAct).l			; load gfx, play music (see "Signpost & HasPassedAct.asm")
		jmp	(DeleteObject).l

	.found:
		rts	

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Pri:	index offset(*)
		ptr ani_prison_switchflash
		ptr ani_prison_switchflash
		
ani_prison_switchflash:
		dc.b 2
		dc.b id_frame_prison_switch1
		dc.b id_frame_prison_switch2
		dc.b afEnd
		even
