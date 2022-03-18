; ---------------------------------------------------------------------------
; Object 6C - vanishing	platforms (SBZ)

; spawned by:
;	ObjPos_SBZ1, ObjPos_SBZ2 - subtypes 0/$40/$80/$C0/$C6/$D6/$E6
; ---------------------------------------------------------------------------

VanishPlatform:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	VanP_Index(pc,d0.w),d1
		jmp	VanP_Index(pc,d1.w)
; ===========================================================================
VanP_Index:	index *,,2
		ptr VanP_Main
		ptr VanP_Detect
		ptr VanP_StoodOn
		ptr VanP_Sync

ost_vanish_wait_time:	equ $30					; time until change (2 bytes)
ost_vanish_wait_master:	equ $32					; time between changes (2 bytes)
ost_vanish_sync_sub:	equ $36					; value to subtract from framecount for synchronising (2 bytes)
ost_vanish_sync_mask:	equ $38					; bitmask for synchronising (2 bytes)
; ===========================================================================

VanP_Main:	; Routine 0
		addq.b	#6,ost_routine(a0)			; goto VanP_Sync next
		move.l	#Map_VanP,ost_mappings(a0)
		move.w	#tile_Nem_SbzBlock+tile_pal3,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_displaywidth(a0)
		move.b	#4,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get object type
		andi.w	#$F,d0					; read only low nybble
		addq.w	#1,d0					; add 1
		lsl.w	#7,d0					; multiply by $80
		move.w	d0,d1					; copy to d1
		subq.w	#1,d0
		move.w	d0,ost_vanish_wait_time(a0)
		move.w	d0,ost_vanish_wait_master(a0)		; set as time between changes
		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get object type
		andi.w	#$F0,d0					; read only high nybble
		addi.w	#$80,d1
		mulu.w	d1,d0
		lsr.l	#8,d0
		move.w	d0,ost_vanish_sync_sub(a0)
		subq.w	#1,d1					; d1 = $FF if type $x0; $3FF if type $x6
		move.w	d1,ost_vanish_sync_mask(a0)

VanP_Sync:	; Routine 6
		move.w	(v_frame_counter).w,d0			; get word that increments every frame
		sub.w	ost_vanish_sync_sub(a0),d0
		and.w	ost_vanish_sync_mask(a0),d0		; apply bitmask
		bne.s	@animate				; branch if any bits are set
		subq.b	#4,ost_routine(a0)			; goto VanP_Detect next (every $100 or $400 frames)
		bra.s	VanP_Detect
; ===========================================================================

@animate:
		lea	(Ani_Van).l,a1
		jsr	(AnimateSprite).l
		bra.w	DespawnObject
; ===========================================================================

VanP_Detect:	; Routine 2
VanP_StoodOn:	; Routine 4
		subq.w	#1,ost_vanish_wait_time(a0)		; decrement timer
		bpl.s	@wait					; branch if time remains
		move.w	#127,ost_vanish_wait_time(a0)		; reset timer to 2 seconds
		tst.b	ost_anim(a0)				; is platform vanishing?
		beq.s	@isvanishing				; if yes, branch
		move.w	ost_vanish_wait_master(a0),ost_vanish_wait_time(a0) ; reset timer to $80 (type $x0) or $380 (type $x6)

	@isvanishing:
		bchg	#0,ost_anim(a0)				; switch between vanishing/appearing animations

	@wait:
		lea	(Ani_Van).l,a1
		jsr	(AnimateSprite).l
		btst	#1,ost_frame(a0)			; has platform vanished?
		bne.s	@notsolid				; if yes, branch
		cmpi.b	#id_VanP_Detect,ost_routine(a0)		; is platform being stood on?
		bne.s	@stood_on				; if yes, branch

		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		jsr	(DetectPlatform).l			; detect collision and goto VanP_StoodOn next if true
		bra.w	DespawnObject
; ===========================================================================

@stood_on:
		moveq	#0,d1
		move.b	ost_displaywidth(a0),d1
		jsr	(ExitPlatform).l			; goto VanP_Detect next if Sonic leaves platform
		move.w	ost_x_pos(a0),d2
		jsr	(MoveWithPlatform2).l
		bra.w	DespawnObject
; ===========================================================================

@notsolid:
		btst	#status_platform_bit,ost_status(a0)	; is Sonic on the platform?
		beq.s	@skip_clear				; if not, branch
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)	; clear all platform flags
		bclr	#status_platform_bit,ost_status(a0)
		move.b	#id_VanP_Detect,ost_routine(a0)
		clr.b	ost_solid(a0)

	@skip_clear:
		bra.w	DespawnObject

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Van:	index *
		ptr ani_vanish_vanish
		ptr ani_vanish_appear
		
ani_vanish_vanish:
		dc.b 7
		dc.b id_frame_vanish_whole
		dc.b id_frame_vanish_half
		dc.b id_frame_vanish_quarter
		dc.b id_frame_vanish_gone
		dc.b afBack, 1
		even

ani_vanish_appear:
		dc.b 7
		dc.b id_frame_vanish_gone
		dc.b id_frame_vanish_quarter
		dc.b id_frame_vanish_half
		dc.b id_frame_vanish_whole
		dc.b afBack, 1
		even
