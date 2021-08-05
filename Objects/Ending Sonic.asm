; ---------------------------------------------------------------------------
; Object 87 - Sonic on ending sequence
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	ESon_Index(pc,d0.w),d1
		jsr	ESon_Index(pc,d1.w)
		jmp	(DisplaySprite).l
; ===========================================================================
ESon_Index:	index *,,2
		ptr ESon_Main
		ptr ESon_MakeEmeralds
		ptr ESon_Animate
		ptr ESon_LookUp
		ptr ESon_ClrObjRam
		ptr ESon_Animate
		ptr ESon_MakeLogo
		ptr ESon_Animate
		ptr ESon_Leap
		ptr ESon_Animate

eson_time:	equ $30	; time to wait between events
; ===========================================================================

ESon_Main:	; Routine 0
		cmpi.b	#6,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	ESon_Main2	; if yes, branch
		addi.b	#id_ESon_Leap,ost_routine2(a0) ; else, skip emerald sequence
		move.w	#216,eson_time(a0)
		rts	
; ===========================================================================

ESon_Main2:
		addq.b	#2,ost_routine2(a0)
		move.l	#Map_ESon,ost_mappings(a0)
		move.w	#tile_Nem_EndSonic,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		clr.b	ost_status(a0)
		move.b	#2,ost_priority(a0)
		move.b	#0,ost_frame(a0)
		move.w	#80,eson_time(a0) ; set duration for Sonic to pause

ESon_MakeEmeralds:
		; Routine 2
		subq.w	#1,eson_time(a0) ; subtract 1 from duration
		bne.s	ESon_Wait
		addq.b	#2,ost_routine2(a0)
		move.w	#id_Confused,ost_anim(a0)
		move.b	#id_EndChaos,(v_objspace+$400).w ; load chaos emeralds objects

	ESon_Wait:
		rts	
; ===========================================================================

ESon_LookUp:	; Routine 6
		cmpi.w	#$2000,((v_objspace&$FFFFFF)+$400+$3C).l
		bne.s	locret_5480
		move.w	#1,(f_restart).w ; set level to	restart	(causes	flash)
		move.w	#90,eson_time(a0)
		addq.b	#2,ost_routine2(a0)

locret_5480:
		rts	
; ===========================================================================

ESon_ClrObjRam:
		; Routine 8
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait2
		lea	(v_objspace+$400).w,a1
		move.w	#$FF,d1

ESon_ClrLoop:
		clr.l	(a1)+
		dbf	d1,ESon_ClrLoop ; clear the object RAM
		move.w	#1,(f_restart).w
		addq.b	#2,ost_routine2(a0)
		move.b	#id_Confused,ost_anim(a0)
		move.w	#60,eson_time(a0)

ESon_Wait2:
		rts	
; ===========================================================================

ESon_MakeLogo:	; Routine $C
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait3
		addq.b	#2,ost_routine2(a0)
		move.w	#180,eson_time(a0)
		move.b	#id_Leaping,ost_anim(a0)
		move.b	#id_EndSTH,(v_objspace+$400).w ; load "SONIC THE HEDGEHOG" object

ESon_Wait3:
		rts	
; ===========================================================================

ESon_Animate:	; Rountine 4, $A, $E, $12
		lea	(AniScript_ESon).l,a1
		jmp	(AnimateSprite).l
; ===========================================================================

ESon_Leap:	; Routine $10
		subq.w	#1,eson_time(a0)
		bne.s	ESon_Wait4
		addq.b	#2,ost_routine2(a0)
		move.l	#Map_ESon,ost_mappings(a0)
		move.w	#tile_Nem_EndSonic,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		clr.b	ost_status(a0)
		move.b	#2,ost_priority(a0)
		move.b	#5,ost_frame(a0)
		move.b	#id_Leaping,ost_anim(a0) ; use "leaping" animation
		move.b	#id_EndSTH,(v_objspace+$400).w ; load "SONIC THE HEDGEHOG" object
		bra.s	ESon_Animate
; ===========================================================================

ESon_Wait4:
		rts	
