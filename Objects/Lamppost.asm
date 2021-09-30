; ---------------------------------------------------------------------------
; Object 79 - lamppost
; ---------------------------------------------------------------------------

Lamppost:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Lamp_Index(pc,d0.w),d1
		jsr	Lamp_Index(pc,d1.w)
		jmp	(RememberState).l
; ===========================================================================
Lamp_Index:	index *,,2
		ptr Lamp_Main
		ptr Lamp_Blue
		ptr Lamp_Finish
		ptr Lamp_Twirl

ost_lamp_x_start:	equ $30	; original x-axis position (2 bytes)
ost_lamp_y_start:	equ $32	; original y-axis position (2 bytes)
ost_lamp_twirl_time:	equ $36	; length of time to twirl the lamp (2 bytes)
; ===========================================================================

Lamp_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Lamp,ost_mappings(a0)
		move.w	#tile_Nem_Lamp,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#8,ost_actwidth(a0)
		move.b	#5,ost_priority(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.s	@red
		move.b	(v_lastlamp).w,d1
		andi.b	#$7F,d1
		move.b	ost_subtype(a0),d2 ; get lamppost number
		andi.b	#$7F,d2
		cmp.b	d2,d1		; is this a "new" lamppost?
		bcs.s	Lamp_Blue	; if yes, branch

	@red:
		bset	#0,2(a2,d0.w)
		move.b	#id_Lamp_Finish,ost_routine(a0) ; goto Lamp_Finish next
		move.b	#id_frame_lamp_red,ost_frame(a0) ; use red lamppost frame
		rts	
; ===========================================================================

Lamp_Blue:	; Routine 2
		tst.w	(v_debuguse).w	; is debug mode	being used?
		bne.w	@donothing	; if yes, branch
		tst.b	(f_lockmulti).w
		bmi.w	@donothing
		move.b	(v_lastlamp).w,d1
		andi.b	#$7F,d1
		move.b	ost_subtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1		; is this a "new" lamppost?
		bcs.s	@chkhit		; if yes, branch
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#id_Lamp_Finish,ost_routine(a0)
		move.b	#id_frame_lamp_red,ost_frame(a0)
		bra.w	@donothing
; ===========================================================================

@chkhit:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		addq.w	#8,d0
		cmpi.w	#$10,d0
		bcc.w	@donothing
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	ost_y_pos(a0),d0
		addi.w	#$40,d0
		cmpi.w	#$68,d0
		bcc.s	@donothing

		sfx	sfx_Lamppost,0,0,0 ; play lamppost sound
		addq.b	#2,ost_routine(a0)
		jsr	(FindFreeObj).l
		bne.s	@fail
		move.b	#id_Lamppost,0(a1) ; load twirling lamp object
		move.b	#id_Lamp_Twirl,ost_routine(a1) ; goto Lamp_Twirl next
		move.w	ost_x_pos(a0),ost_lamp_x_start(a1)
		move.w	ost_y_pos(a0),ost_lamp_y_start(a1)
		subi.w	#$18,ost_lamp_y_start(a1)
		move.l	#Map_Lamp,ost_mappings(a1)
		move.w	#tile_Nem_Lamp,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#4,ost_priority(a1)
		move.b	#id_frame_lamp_redballonly,ost_frame(a1) ; use "ball only" frame
		move.w	#32,ost_lamp_twirl_time(a1)

	@fail:
		move.b	#id_frame_lamp_poleonly,ost_frame(a0) ; use "post only" frame
		bsr.w	Lamp_StoreInfo
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		bset	#0,2(a2,d0.w)

	@donothing:
		rts	
; ===========================================================================

Lamp_Finish:	; Routine 4
		rts	
; ===========================================================================

Lamp_Twirl:	; Routine 6
		subq.w	#1,ost_lamp_twirl_time(a0) ; decrement timer
		bpl.s	@continue	; if time remains, keep twirling
		move.b	#id_Lamp_Finish,ost_routine(a0) ; goto Lamp_Finish next

	@continue:
		move.b	ost_angle(a0),d0
		subi.b	#$10,ost_angle(a0)
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$C00,d1
		swap	d1
		add.w	ost_lamp_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		muls.w	#$C00,d0
		swap	d0
		add.w	ost_lamp_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	store information when you hit a lamppost
; ---------------------------------------------------------------------------

Lamp_StoreInfo:
		move.b	ost_subtype(a0),(v_lastlamp).w 	; lamppost number
		move.b	(v_lastlamp).w,($FFFFFE31).w
		move.w	ost_x_pos(a0),($FFFFFE32).w	; x-position
		move.w	ost_y_pos(a0),($FFFFFE34).w	; y-position
		move.w	(v_rings).w,($FFFFFE36).w 	; rings
		move.b	(v_lifecount).w,($FFFFFE54).w 	; lives
		move.l	(v_time).w,($FFFFFE38).w 	; time
		move.b	(v_dle_routine).w,($FFFFFE3C).w ; routine counter for dynamic level mod
		move.w	(v_limitbtm2).w,($FFFFFE3E).w 	; lower y-boundary of level
		move.w	(v_screenposx).w,($FFFFFE40).w 	; screen x-position
		move.w	(v_screenposy).w,($FFFFFE42).w 	; screen y-position
		move.w	(v_bgscreenposx).w,($FFFFFE44).w ; bg position
		move.w	(v_bgscreenposy).w,($FFFFFE46).w ; bg position
		move.w	(v_bg2screenposx).w,($FFFFFE48).w ; bg position
		move.w	(v_bg2screenposy).w,($FFFFFE4A).w ; bg position
		move.w	(v_bg3screenposx).w,($FFFFFE4C).w ; bg position
		move.w	(v_bg3screenposy).w,($FFFFFE4E).w ; bg position
		move.w	(v_water_height_normal).w,($FFFFFE50).w 	; water height
		move.b	(v_water_routine).w,($FFFFFE52).w ; rountine counter for water
		move.b	(f_water_pal_full).w,($FFFFFE53).w 	; water direction
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	load stored info when you start	a level	from a lamppost
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Lamp_LoadInfo:
		move.b	($FFFFFE31).w,(v_lastlamp).w
		move.w	($FFFFFE32).w,(v_ost_player+ost_x_pos).w
		move.w	($FFFFFE34).w,(v_ost_player+ost_y_pos).w
		move.w	($FFFFFE36).w,(v_rings).w
		move.b	($FFFFFE54).w,(v_lifecount).w
		clr.w	(v_rings).w
		clr.b	(v_lifecount).w
		move.l	($FFFFFE38).w,(v_time).w
		move.b	#59,(v_timecent).w
		subq.b	#1,(v_timesec).w
		move.b	($FFFFFE3C).w,(v_dle_routine).w
		move.b	($FFFFFE52).w,(v_water_routine).w
		move.w	($FFFFFE3E).w,(v_limitbtm2).w
		move.w	($FFFFFE3E).w,(v_limitbtm1).w
		move.w	($FFFFFE40).w,(v_screenposx).w
		move.w	($FFFFFE42).w,(v_screenposy).w
		move.w	($FFFFFE44).w,(v_bgscreenposx).w
		move.w	($FFFFFE46).w,(v_bgscreenposy).w
		move.w	($FFFFFE48).w,(v_bg2screenposx).w
		move.w	($FFFFFE4A).w,(v_bg2screenposy).w
		move.w	($FFFFFE4C).w,(v_bg3screenposx).w
		move.w	($FFFFFE4E).w,(v_bg3screenposy).w
		cmpi.b	#1,(v_zone).w	; is this Labyrinth Zone?
		bne.s	@notlabyrinth	; if not, branch

		move.w	($FFFFFE50).w,(v_water_height_normal).w
		move.b	($FFFFFE52).w,(v_water_routine).w
		move.b	($FFFFFE53).w,(f_water_pal_full).w

	@notlabyrinth:
		tst.b	(v_lastlamp).w
		bpl.s	locret_170F6
		move.w	($FFFFFE32).w,d0
		subi.w	#$A0,d0
		move.w	d0,(v_limitleft2).w

locret_170F6:
		rts	
