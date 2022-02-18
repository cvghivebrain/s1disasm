; ---------------------------------------------------------------------------
; Object 85 - Eggman (FZ)

; spawned by:
;	DynamicLevelEvents - routine 0
;	BossFinal - routines 2/4/6/8/$A/$C
; ---------------------------------------------------------------------------

BFZ_Delete:
		jmp	(DeleteObject).l
; ===========================================================================

BossFinal:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BFZ_Index(pc,d0.w),d0
		jmp	BFZ_Index(pc,d0.w)
; ===========================================================================
BFZ_Index:	index *,,2
		ptr BFZ_Main
		ptr BFZ_Eggman
		ptr BFZ_Panel
		ptr BFZ_Legs
		ptr BFZ_Cockpit
		ptr BFZ_EmptyShip
		ptr BFZ_Flame

BFZ_ObjData:	; x pos, y pos,	VRAM setting, mappings pointer
		dc.w $100, $100, tile_Nem_Sbz2Eggman_FZ
		dc.l Map_SEgg
		dc.w $25B0, $590, tile_Nem_FzBoss
		dc.l Map_EggCyl
		dc.w $26E0, $596, tile_Nem_FzEggman
		dc.l Map_FZLegs
		dc.w $26E0, $596, tile_Nem_Sbz2Eggman_FZ
		dc.l Map_SEgg
		dc.w $26E0, $596, tile_Nem_Eggman
		dc.l Map_Eggman
		dc.w $26E0, $596, tile_Nem_Eggman
		dc.l Map_Eggman

BFZ_ObjData2:	; routine num, animation, sprite priority, width, height
		dc.b id_BFZ_Eggman, id_ani_eggman_stand, 4, $20, $19
		dc.b id_BFZ_Panel, 0, 1, $12, 8
		dc.b id_BFZ_Legs, 0, 3, 0, 0
		dc.b id_BFZ_Cockpit, 0, 3, 0, 0
		dc.b id_BFZ_EmptyShip, 0, 3, $20, $20
		dc.b id_BFZ_Flame, 0, 3, 0, 0

ost_fz_cylinder_flag:	equ $30					; -1 when cylinders activate; id of cylinder Eggman is in when crushing (2 bytes)
ost_fz_phase_state:	equ $32					; 1 = crushing; 0 = plasma; -1 = crushing complete (2 bytes)
ost_fz_parent:		equ $34					; address of OST of parent object - children only (4 bytes)
ost_fz_mode:		equ $34					; action being performed, increments of 2 - parent only
ost_fz_flash_num:	equ $35					; number of times to make boss flash when hit - parent only
ost_fz_plasma_child:	equ $36					; address of OST of plasma object - parent only (2 bytes)
ost_fz_cylinder_child:	equ $38					; address of OST of cylinder object - parent only (2 bytes * 4)
; ===========================================================================

BFZ_Main:	; Routine 0
		lea	BFZ_ObjData(pc),a2
		lea	BFZ_ObjData2(pc),a3
		movea.l	a0,a1					; replace current object with 1st in list
		moveq	#5,d1					; 5 additional objects
		bra.s	@load_boss
; ===========================================================================

@loop:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	@fail					; branch if not found

@load_boss:
		move.b	#id_BossFinal,(a1)
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,ost_tile(a1)
		move.l	(a2)+,ost_mappings(a1)
		move.b	(a3)+,ost_routine(a1)			; goto BFZ_Main/BFZ_Eggman/BFZ_Panel/BFZ_Legs/BFZ_Cockpit/BFZ_EmptyShip/BFZ_Flame next
		move.b	(a3)+,ost_anim(a1)
		move.b	(a3)+,ost_priority(a1)
		if Revision=0
			move.b	(a3)+,ost_width(a1)
		else
			move.b	(a3)+,ost_actwidth(a1)
		endc
		move.b	(a3)+,ost_height(a1)
		move.b	#render_rel,ost_render(a1)
		bset	#render_onscreen_bit,ost_render(a0)
		move.l	a0,ost_fz_parent(a1)			; save address of OST of parent
		dbf	d1,@loop				; repeat 5 more times

	@fail:
		lea	ost_fz_plasma_child(a0),a2
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail2					; branch if not found
		move.b	#id_BossPlasma,(a1)			; load plasma ball launcher object
		move.w	a1,(a2)					; save address of OST of plasma launcher in parent OST
		move.l	a0,ost_plasma_parent(a1)		; save parent OST in plasma OST

		lea	ost_fz_cylinder_child(a0),a2
		moveq	#0,d2
		moveq	#4-1,d1					; number of crushers

	@loop_crushers:
		jsr	(FindNextFreeObj).l			; find free OST slot
		bne.s	@fail2					; branch if not found
		move.w	a1,(a2)+				; save address of OST of crusher in parent OST
		move.b	#id_EggmanCylinder,(a1)			; load crushing	cylinder object
		move.l	a0,ost_cylinder_parent(a1)		; save parent OST in crusher OST
		move.b	d2,ost_subtype(a1)			; set subtype to 0/2/4/6
		addq.w	#2,d2					; next subtype
		dbf	d1,@loop_crushers			; repeat for all crushers

	@fail2:
		move.w	#id_BFZ_Eggman_Wait,ost_fz_mode(a0)	; goto BFZ_Eggman_Wait next
		move.b	#8,ost_col_property(a0)			; set number of hits to 8
		move.w	#-1,ost_fz_cylinder_flag(a0)		; set crushers to activate

BFZ_Eggman:	; Routine 2
		moveq	#0,d0
		move.b	ost_fz_mode(a0),d0
		move.w	BFZ_Eggman_Index(pc,d0.w),d0
		jsr	BFZ_Eggman_Index(pc,d0.w)
		jmp	(DisplaySprite).l
; ===========================================================================
BFZ_Eggman_Index:
		index *,,2
		ptr BFZ_Eggman_Wait
		ptr BFZ_Eggman_Crush
		ptr BFZ_Eggman_Plasma
		ptr BFZ_Eggman_Fall
		ptr BFZ_Eggman_Run
		ptr BFZ_Eggman_Jump
		ptr BFZ_Eggman_Ship
		ptr BFZ_Eggman_Escape
; ===========================================================================

BFZ_Eggman_Wait:
		tst.l	(v_plc_buffer).w			; is pattern load cue buffer empty?
		bne.s	@wait					; if not, branch
		cmpi.w	#$2450,(v_camera_x_pos).w		; has camera reached boss arena?
		bcs.s	@wait					; if not, branch
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Crush next

	@wait:
		addq.l	#1,(v_random).w				; increment random number
		rts	
; ===========================================================================

BFZ_Eggman_Crush:
		tst.w	ost_fz_cylinder_flag(a0)		; are crushers set to activate?
		bpl.s	@skip_crushers				; if not, branch
		clr.w	ost_fz_cylinder_flag(a0)
		jsr	(RandomNumber).l			; get random number
		andi.w	#$C,d0					; low word of d0 = 0/4/8/$C (high word is kept)
		move.w	d0,d1
		addq.w	#2,d1					; add 2 to copy in d1
		tst.l	d0
		bpl.s	@d0_is_pos				; branch if high word was +ve
		exg	d1,d0					; swap d0 and d1

	@d0_is_pos:
		lea	BFZ_CylPattern(pc),a1
		move.w	(a1,d0.w),d0				; get value for first cylinder (0/2/4/6)
		move.w	(a1,d1.w),d1				; get value for second cylinder (0/2/4/6)
		move.w	d0,ost_fz_cylinder_flag(a0)
		moveq	#-1,d2
		move.w	ost_fz_cylinder_child(a0,d0.w),d2
		movea.l	d2,a1					; a1 = OST address for first cylinder
		move.b	#-1,ost_cylinder_flag(a1)		; activate that cylinder
		move.w	#-1,ost_cylinder_eggman(a1)
		move.w	ost_fz_cylinder_child(a0,d1.w),d2
		movea.l	d2,a1					; a1 = OST address for second cylinder
		move.b	#1,ost_cylinder_flag(a1)		; activate that cylinder
		move.w	#0,ost_cylinder_eggman(a1)
		move.w	#1,ost_fz_phase_state(a0)
		clr.b	ost_fz_flash_num(a0)
		play.w	1, jsr, sfx_Rumbling			; play rumbling sound

	@skip_crushers:
		tst.w	ost_fz_phase_state(a0)
		bmi.w	@crush_complete				; branch if cylinders have finished crushing process
		bclr	#status_xflip_bit,ost_status(a0)	; Eggman faces left
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	@sonic_is_left				; branch if Sonic is left of Eggman
		bset	#status_xflip_bit,ost_status(a0)	; Eggman faces right

	@sonic_is_left:
		move.w	#$2B,d1
		move.w	#$14,d2
		move.w	#$14,d3
		move.w	ost_x_pos(a0),d4
		jsr	(SolidObject).l
		tst.w	d4
		bgt.s	@side_collision				; branch if Sonic touches the side of the cylinder with Eggman

@just_solid:
		tst.b	ost_fz_flash_num(a0)			; is boss flashing from hit?
		bne.s	@flash					; if yes, branch
		bra.s	@missed
; ===========================================================================

@side_collision:
		addq.w	#7,(v_random).w
		cmpi.b	#id_Roll,(v_ost_player+ost_anim).w	; is Sonic rolling/jumping?
		bne.s	@just_solid				; if not, branch
		move.w	#$300,d0				; rebound Sonic right
		btst	#status_xflip_bit,ost_status(a0)	; is Eggman facing right?
		bne.s	@eggman_face_right			; if yes, branch
		neg.w	d0					; rebound Sonic left

	@eggman_face_right:
		move.w	d0,(v_ost_player+ost_x_vel).w		; set rebound speed for Sonic
		tst.b	ost_fz_flash_num(a0)			; is boss flashing from hit?
		bne.s	@flash					; if yes, branch
		subq.b	#1,ost_col_property(a0)			; decrement hit counter
		move.b	#$64,ost_fz_flash_num(a0)		; flash 100 times
		play.w	1, jsr, sfx_BossHit			; play boss damage sound

@flash:
		subq.b	#1,ost_fz_flash_num(a0)			; decrement flash counter
		beq.s	@missed					; branch if 0
		move.b	#id_ani_eggman_intube,ost_anim(a0)
		bra.s	@animate
; ===========================================================================

@missed:
		move.b	#id_ani_eggman_laugh,ost_anim(a0)

@animate:
		lea	Ani_SEgg(pc),a1
		jmp	(AnimateSprite).l
; ===========================================================================

@crush_complete:
		tst.b	ost_col_property(a0)			; has boss been beaten?
		beq.s	@beaten					; if yes, branch
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Plasma next
		move.w	#-1,ost_fz_cylinder_flag(a0)
		clr.w	ost_fz_phase_state(a0)
		rts	
; ===========================================================================

@beaten:
		if Revision=0
		else
			moveq	#100,d0
			bsr.w	AddPoints			; give Sonic 1000 points
		endc
		move.b	#id_BFZ_Eggman_Fall,ost_fz_mode(a0)	; goto BFZ_Eggman_Fall next
		move.w	#$25C0,ost_x_pos(a0)			; move Eggman outside arena to the right
		move.w	#$53C,ost_y_pos(a0)
		move.b	#$14,ost_height(a0)
		rts	
; ===========================================================================
BFZ_CylPattern:	dc.w cyl_bottom_left, cyl_bottom_right
		dc.w cyl_bottom_right, cyl_top_left
		dc.w cyl_top_left, cyl_top_right
		dc.w cyl_top_right, cyl_bottom_left

cyl_bottom_left:	equ 0
cyl_bottom_right:	equ 2
cyl_top_left:		equ 4
cyl_top_right:		equ 6
; ===========================================================================

BFZ_Eggman_Plasma:
		moveq	#-1,d0
		move.w	ost_fz_plasma_child(a0),d0
		movea.l	d0,a1					; get address of OST of plasma launcher
		tst.w	ost_fz_cylinder_flag(a0)		; has crushing process just finished?
		bpl.s	@skip_plasma				; if not, branch
		clr.w	ost_fz_cylinder_flag(a0)
		move.b	#-1,ost_plasma_flag(a1)			; activate plasma launcher
		bsr.s	@electric_sound				; play sound

	@skip_plasma:
		moveq	#$F,d0
		and.w	(v_vblank_counter_word).w,d0		; get word that increments every frame
		bne.s	@skip_sound				; branch if any of bits 0-3 are set
		bsr.s	@electric_sound				; play sound every 16th frame

	@skip_sound:
		tst.w	ost_fz_phase_state(a0)			; is plasma phase complete?
		beq.s	@wait					; if not, branch
		subq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Crush next
		move.w	#-1,ost_fz_cylinder_flag(a0)		; set flag to begin crushing phase
		clr.w	ost_fz_phase_state(a0)

	@wait:
		rts	
; ===========================================================================

@electric_sound:
		play.w	1, jmp, sfx_Electricity			; play electricity sound
; ===========================================================================

BFZ_Eggman_Fall:
		if Revision=0
			move.b	#$30,ost_width(a0)
		else
			move.b	#$30,ost_actwidth(a0)
		endc
		bset	#status_xflip_bit,ost_status(a0)	; Eggman faces right
		jsr	(SpeedToPos).l				; update position
		move.b	#id_frame_eggman_jump,ost_frame(a0)	; use jumping frame
		addi.w	#$10,ost_y_vel(a0)			; apply gravity
		cmpi.w	#$59C,ost_y_pos(a0)			; has Eggman reached bottom of tube?
		bcs.s	@wait					; if not, branch
		move.w	#$59C,ost_y_pos(a0)			; align to bottom of tube
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Run next
		if Revision=0
			move.b	#$20,ost_width(a0)
		else
			move.b	#$20,ost_actwidth(a0)
		endc
		move.w	#$100,ost_x_vel(a0)			; move right
		move.w	#-$100,ost_y_vel(a0)			; bounce up
		addq.b	#2,(v_dle_routine).w			; scroll camera right

	@wait:
		bra.w	BFZ_Eggman_Scroll
; ===========================================================================

BFZ_Eggman_Run:
		bset	#status_xflip_bit,ost_status(a0)	; Eggman faces right
		move.b	#id_ani_eggman_running,ost_anim(a0)	; use running animation
		jsr	(SpeedToPos).l				; update position
		addi.w	#$10,ost_y_vel(a0)			; apply gravity
		cmpi.w	#$5A3,ost_y_pos(a0)			; has Eggman hit the floor?
		bcs.s	@keep_falling				; if not, branch
		move.w	#-$40,ost_y_vel(a0)			; bounce off floor

	@keep_falling:
		move.w	#$400,ost_x_vel(a0)			; move right
		move.w	ost_x_pos(a0),d0
		sub.w	(v_ost_player+ost_x_pos).w,d0
		bpl.s	@sonic_is_left				; branch if Sonic is left of Eggman
		move.w	#$500,ost_x_vel(a0)			; move right faster
		bra.w	@chk_ship
; ===========================================================================

@sonic_is_left:
		subi.w	#$70,d0
		bcs.s	@chk_ship
		subi.w	#$100,ost_x_vel(a0)			; slow Eggman down the further Sonic is from him
		subq.w	#8,d0
		bcs.s	@chk_ship
		subi.w	#$100,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	@chk_ship
		subi.w	#$80,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	@chk_ship
		subi.w	#$80,ost_x_vel(a0)
		subq.w	#8,d0
		bcs.s	@chk_ship
		subi.w	#$80,ost_x_vel(a0)
		subi.w	#$38,d0
		bcs.s	@chk_ship
		clr.w	ost_x_vel(a0)

@chk_ship:
		cmpi.w	#$26A0,ost_x_pos(a0)			; has Eggman reached his ship?
		bcs.s	@keep_running				; if not, branch
		move.w	#$26A0,ost_x_pos(a0)			; align to position
		move.w	#$240,ost_x_vel(a0)			; move right
		move.w	#-$4C0,ost_y_vel(a0)			; jump up
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Jump next

	@keep_running:
		bra.s	BFZ_Eggman_AnimScroll
; ===========================================================================

BFZ_Eggman_Jump:
		jsr	(SpeedToPos).l				; update position
		cmpi.w	#$26E0,ost_x_pos(a0)			; is Eggman directly above his ship?
		bcs.s	@not_above_ship				; if not, branch
		clr.w	ost_x_vel(a0)				; stop moving right (drops vertically instead)

	@not_above_ship:
		addi.w	#$34,ost_y_vel(a0)			; apply gravity
		tst.w	ost_y_vel(a0)
		bmi.s	@not_in_ship				; branch if moving upwards
		cmpi.w	#$592,ost_y_pos(a0)			; is Eggman in his ship?
		bcs.s	@not_in_ship				; if not, branch
		move.w	#$592,ost_y_pos(a0)			; align to ship
		clr.w	ost_y_vel(a0)				; stop falling

	@not_in_ship:
		move.w	ost_x_vel(a0),d0
		or.w	ost_y_vel(a0),d0
		bne.s	BFZ_Eggman_AnimScroll			; branch if Eggman is still moving/falling
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Ship next
		move.w	#-$180,ost_y_vel(a0)			; move Eggman up
		move.b	#1,ost_col_property(a0)			; give Eggman a single hit point

BFZ_Eggman_AnimScroll:
		lea	Ani_SEgg(pc),a1
		jsr	(AnimateSprite).l

BFZ_Eggman_Scroll:
		cmpi.w	#$2700,(v_boundary_right).w		; check for new boundary
		bge.s	@chk_ship
		addq.w	#2,(v_boundary_right).w			; expand right edge of level boundary

	@chk_ship:
		cmpi.b	#id_BFZ_Eggman_Ship,ost_fz_mode(a0)	; is Eggman in his ship?
		bge.s	@not_solid				; if yes, branch
		move.w	#$1B,d1
		move.w	#$70,d2
		move.w	#$71,d3
		move.w	ost_x_pos(a0),d4
		jmp	(SolidObject).l				; Eggman is solid
; ===========================================================================

@not_solid:
		rts	
; ===========================================================================

BFZ_Eggman_Ship:
		move.l	#Map_Eggman,ost_mappings(a0)		; use standard boss mappings
		move.w	#tile_Nem_Eggman,ost_tile(a0)
		move.b	#id_ani_boss_ship,ost_anim(a0)
		bset	#status_xflip_bit,ost_status(a0)	; ship faces right
		jsr	(SpeedToPos).l				; update position
		cmpi.w	#$544,ost_y_pos(a0)			; has ship reached a certain height?
		bcc.s	@keep_rising				; if not, branch
		move.w	#$180,ost_x_vel(a0)			; move right
		move.w	#-$18,ost_y_vel(a0)			; move up slowly
		move.b	#id_col_24x24,ost_col_type(a0)		; enable collision
		addq.b	#2,ost_fz_mode(a0)			; goto BFZ_Eggman_Escape next

	@keep_rising:
		bra.w	BFZ_Eggman_AnimScroll			; animate & scroll screen
; ===========================================================================

BFZ_Eggman_Escape:
		bset	#status_xflip_bit,ost_status(a0)	; ship faces right
		jsr	(SpeedToPos).l				; update position
		tst.w	ost_fz_cylinder_flag(a0)		; this flag is repurposed as a timer
		bne.s	@skip_sound				; branch if time remains
		tst.b	ost_col_type(a0)			; has ship been hit?
		bne.s	@chk_sonic				; if not, branch
		move.w	#30,ost_fz_cylinder_flag(a0)		; set timer
		play.w	1, jsr, sfx_BossHit			; play boss damage sound every 0.5 seconds

	@skip_sound:
		subq.w	#1,ost_fz_cylinder_flag(a0)		; decrement timer
		bne.s	@chk_sonic				; branch if time remains
		tst.b	ost_status(a0)				; is ship on-screen?
		bpl.s	@off_screen				; if not, branch
		move.w	#$60,ost_y_vel(a0)			; move ship down
		bra.s	@chk_sonic
; ===========================================================================

@off_screen:
		move.b	#id_col_24x24,ost_col_type(a0)

@chk_sonic:
		cmpi.w	#$2790,(v_ost_player+ost_x_pos).w	; is Sonic at ledge?
		blt.s	@not_at_ledge				; if not, branch
		move.b	#1,(f_lock_controls).w			; disable controls 
		move.w	#0,(v_joypad_hold).w
		clr.w	(v_ost_player+ost_inertia).w		; stop Sonic moving
		tst.w	ost_y_vel(a0)
		bpl.s	@chk_ship				; branch if ship is moving down
		move.w	#btnUp<<8,(v_joypad_hold).w		; Sonic looks up

	@not_at_ledge:
		cmpi.w	#$27E0,(v_ost_player+ost_x_pos).w	; is Sonic on the outer edge?
		blt.s	@chk_ship				; if not, branch
		move.w	#$27E0,(v_ost_player+ost_x_pos).w	; align to edge (doesn't work if he's jumping)

@chk_ship:
		cmpi.w	#$2900,ost_x_pos(a0)			; has ship moved off the screen?
		bcs.s	@animate				; if not, branch
		tst.b	ost_render(a0)				; is ship on-screen?
		bmi.s	@animate				; if not, branch
		move.b	#id_Ending,(v_gamemode).w		; goto ending sequence
		bra.w	BFZ_Delete				; delete ship
; ===========================================================================

@animate:
		bra.w	BFZ_Eggman_AnimScroll			; animate & scroll screen
; ===========================================================================

BFZ_Flame:	; Routine $C
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		move.b	(a1),d0
		cmp.b	(a0),d0					; has parent been deleted?
		bne.w	BFZ_Delete				; if yes, branch
		move.b	#id_ani_boss_blank,ost_anim(a0)		; invisible
		cmpi.b	#id_BFZ_Eggman_Ship,ost_fz_mode(a1)	; is Eggman in his ship?
		bge.s	@chk_moving				; if yes, branch
		bra.s	BFZ_Update_SkipPos
; ===========================================================================

@chk_moving:
		tst.w	ost_x_vel(a1)				; is ship moving?
		beq.s	@not_moving				; if not, branch
		move.b	#id_ani_boss_bigflame,ost_anim(a0)	; use large flame animation

	@not_moving:
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l

BFZ_Update:
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		move.w	ost_x_pos(a1),ost_x_pos(a0)		; match position with parent
		move.w	ost_y_pos(a1),ost_y_pos(a0)

BFZ_Update_SkipPos:
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		move.b	ost_status(a1),ost_status(a0)
		moveq	#status_xflip+status_yflip,d0
		and.b	ost_status(a0),d0
		andi.b	#$FF-render_xflip-render_yflip,ost_render(a0) ; ignore x/yflip bits
		or.b	d0,ost_render(a0)			; combine x/yflip bits from status instead
		jmp	(DisplaySprite).l
; ===========================================================================

BFZ_Cockpit:	; Routine 8
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		move.b	(a1),d0
		cmp.b	(a0),d0					; has parent been deleted?
		bne.w	BFZ_Delete				; if yes, branch
		cmpi.l	#Map_Eggman,ost_mappings(a1)		; is Eggman in his ship?
		beq.s	@chk_hit				; if yes, branch
		move.b	#id_frame_eggman_cockpit,ost_frame(a0)	; use empty cockpit frame
		bra.s	BFZ_Update_SkipPos
; ===========================================================================

@chk_hit:
		move.b	#id_ani_boss_face1,ost_anim(a0)
		tst.b	ost_col_property(a1)			; has ship been hit?
		ble.s	@explode				; if yes, branch
		move.b	#id_ani_boss_panic,ost_anim(a0)		; use sweating animation
		move.l	#Map_Eggman,ost_mappings(a0)		; use standard boss mappings
		move.w	#tile_Nem_Eggman,ost_tile(a0)
		lea	Ani_Eggman(pc),a1
		jsr	(AnimateSprite).l
		bra.w	BFZ_Update
; ===========================================================================

@explode:
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BFZ_Delete				; if not, branch
		bsr.w	BossExplode				; spawn explosions
		move.b	#2,ost_priority(a0)
		move.b	#id_ani_fzeggman_0,ost_anim(a0)
		move.l	#Map_FZDamaged,ost_mappings(a0)		; use mappings for damaged ship
		move.w	#tile_Nem_FzEggman,ost_tile(a0)
		lea	Ani_FZEgg(pc),a1
		jsr	(AnimateSprite).l
		bra.w	BFZ_Update
; ===========================================================================

BFZ_Legs:	; Routine 6
		bset	#status_xflip_bit,ost_status(a0)
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		cmpi.l	#Map_Eggman,ost_mappings(a1)		; is Eggman in his ship?
		beq.s	@animate				; if yes, branch
		bra.w	BFZ_Update_SkipPos
; ===========================================================================

@animate:
		move.w	ost_x_pos(a1),ost_x_pos(a0)		; match position to ship
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		tst.b	ost_anim_time(a0)
		bne.s	@skip_reset				; branch if time remains for current frame
		move.b	#20,ost_anim_time(a0)			; set timer to 0.3 seconds

	@skip_reset:
		subq.b	#1,ost_anim_time(a0)			; decrement timer
		bgt.s	@wait					; branch if time remains
		addq.b	#1,ost_frame(a0)			; next frame
		cmpi.b	#id_frame_fzlegs_retracted,ost_frame(a0) ; was final frame displayed?
		bgt.w	BFZ_Delete				; if yes, branch

	@wait:
		bra.w	BFZ_Update
; ===========================================================================

BFZ_Panel:	; Routine 4
		move.b	#id_frame_cylinder_controlpanel,ost_frame(a0)
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcs.s	@display				; branch if Sonic is left of the panel
		tst.b	ost_render(a0)				; is object on-screen?
		bpl.w	BFZ_Delete				; if not, branch

	@display:
		jmp	(DisplaySprite).l
; ===========================================================================

BFZ_EmptyShip:	; Routine $A
		move.b	#id_frame_boss_ship,ost_frame(a0)
		bset	#status_xflip_bit,ost_status(a0)	; face right
		movea.l	ost_fz_parent(a0),a1			; get address of OST of parent object
		cmpi.b	#id_BFZ_Eggman_Ship,ost_fz_mode(a1)	; is Eggman in his ship? (pre-escaping)
		bne.s	@update					; if not, branch
		cmpi.l	#Map_Eggman,ost_mappings(a1)		; is Eggman in his ship at all?
		beq.w	BFZ_Delete				; if yes, branch

	@update:
		bra.w	BFZ_Update_SkipPos
