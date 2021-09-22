; ---------------------------------------------------------------------------
; Object 6B - stomper and sliding door (SBZ)
; ---------------------------------------------------------------------------

ScrapStomp:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Sto_Index(pc,d0.w),d1
		jmp	Sto_Index(pc,d1.w)
; ===========================================================================
Sto_Index:	index *,,2
		ptr Sto_Main
		ptr Sto_Action

Sto_Var:	; width, height, move distance, type number
		dc.b  $40,  $C,	$80,   1	; door
		dc.b  $1C, $20,	$38,   3	; stomper
		dc.b  $1C, $20,	$40,   4	; stomper
		dc.b  $1C, $20,	$60,   4	; stomper
		dc.b  $80, $40,	  0,   5	; huge sliding door in SBZ3

ost_stomp_y_start:	equ $30	; original y-axis position (2 bytes)
ost_stomp_x_start:	equ $34	; original x-axis position (2 bytes)
ost_stomp_wait_time:	equ $36	; time until next action (2 bytes)
ost_stomp_flag:		equ $38	; flag set when associated switch is pressed
ost_stomp_moved:	equ $3A	; distance moved (2 bytes)
ost_stomp_distance:	equ $3C	; distance to move (2 bytes)
ost_stomp_switch_num:	equ $3E	; switch number associated with door
; ===========================================================================

Sto_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype
		lsr.w	#2,d0
		andi.w	#$1C,d0		; read only high nybble
		lea	Sto_Var(pc,d0.w),a3 ; get variables from list
		move.b	(a3)+,ost_actwidth(a0)
		move.b	(a3)+,ost_height(a0)
		lsr.w	#2,d0
		move.b	d0,ost_frame(a0)
		move.l	#Map_Stomp,ost_mappings(a0)
		move.w	#tile_Nem_Stomper+tile_pal2,ost_tile(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ/SBZ3
		bne.s	@isSBZ12	; if not, branch
		bset	#0,(v_obj6B).w
		beq.s	@isSBZ3

@chkdel:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================

@isSBZ3:
		move.w	#tile_Nem_LzBlock2+tile_pal3,ost_tile(a0)
		cmpi.w	#$A80,ost_x_pos(a0)
		bne.s	@isSBZ12
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@isSBZ12
		btst	#0,2(a2,d0.w)
		beq.s	@isSBZ12
		clr.b	(v_obj6B).w
		bra.s	@chkdel
; ===========================================================================

@isSBZ12:
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.w	ost_x_pos(a0),ost_stomp_x_start(a0)
		move.w	ost_y_pos(a0),ost_stomp_y_start(a0)
		moveq	#0,d0
		move.b	(a3)+,d0
		move.w	d0,ost_stomp_distance(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype
		bpl.s	Sto_Action
		andi.b	#$F,d0		; read only low nybble
		move.b	d0,ost_stomp_switch_num(a0) ; copy to ost_stomp_switch_num
		move.b	(a3),ost_subtype(a0) ; update subtype with value from list
		cmpi.b	#5,(a3)		; is object the huge sliding door from SBZ3?
		bne.s	@chkgone	; if not, branch
		bset	#render_useheight_bit,ost_render(a0)

	@chkgone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	Sto_Action
		bclr	#7,2(a2,d0.w)

Sto_Action:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d1
		move.b	ost_actwidth(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	ost_height(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	SolidObject

	@chkdel:
		out_of_range.s	@chkgone,ost_stomp_x_start(a0)
		jmp	(DisplaySprite).l

	@chkgone:
		cmpi.b	#id_LZ,(v_zone).w
		bne.s	@delete
		clr.b	(v_obj6B).w
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		jmp	(DeleteObject).l
; ===========================================================================
@index:		index *
		ptr @type00
		ptr @type01
		ptr @type02
		ptr @type03
		ptr @type04
		ptr @type05
; ===========================================================================

@type00:
		rts
; ===========================================================================

; Horizonal door, opens when switch (ost_stomp_switch_num) is pressed
@type01:
		tst.b	ost_stomp_flag(a0)
		bne.s	@isactive01
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_stomp_switch_num(a0),d0
		btst	#0,(a2,d0.w)	; has switch been pressed?
		beq.s	@loc_15DC2	; if not, branch
		move.b	#1,ost_stomp_flag(a0)

	@isactive01:
		move.w	ost_stomp_distance(a0),d0
		cmp.w	ost_stomp_moved(a0),d0
		beq.s	@finished01
		addq.w	#2,ost_stomp_moved(a0)

	@loc_15DC2:
		move.w	ost_stomp_moved(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip01
		neg.w	d0
		addi.w	#$80,d0

	@noflip01:
		move.w	ost_stomp_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@finished01:
		addq.b	#1,ost_subtype(a0) ;  change type to 2
		move.w	#180,ost_stomp_wait_time(a0) ; set timer to 3 seconds
		clr.b	ost_stomp_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_15DC2
		bset	#0,2(a2,d0.w)
		bra.s	@loc_15DC2
; ===========================================================================

; Horizonal door, returns to its original position after 3 seconds
@type02:
		tst.b	ost_stomp_flag(a0)
		bne.s	@isactive02
		subq.w	#1,ost_stomp_wait_time(a0)
		bne.s	@loc_15E1E
		move.b	#1,ost_stomp_flag(a0)

	@isactive02:
		tst.w	ost_stomp_moved(a0) ; has door reached its original position?
		beq.s	@finished02	; if yes, branch
		subq.w	#2,ost_stomp_moved(a0) ; move back 2 pixels

	@loc_15E1E:
		move.w	ost_stomp_moved(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip02
		neg.w	d0
		addi.w	#$80,d0

	@noflip02:
		move.w	ost_stomp_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@finished02:
		subq.b	#1,ost_subtype(a0) ; change back to type 1
		clr.b	ost_stomp_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_15E1E
		bclr	#0,2(a2,d0.w)
		bra.s	@loc_15E1E
; ===========================================================================

; Stomper, drops quickly and rises slowly
@type03:
		tst.b	ost_stomp_flag(a0)
		bne.s	@isactive03
		tst.w	ost_stomp_moved(a0)
		beq.s	@loc_15E6A
		subq.w	#1,ost_stomp_moved(a0)
		bra.s	@loc_15E8E
; ===========================================================================

@loc_15E6A:
		subq.w	#1,ost_stomp_wait_time(a0)
		bpl.s	@loc_15E8E
		move.w	#60,ost_stomp_wait_time(a0)
		move.b	#1,ost_stomp_flag(a0)

@isactive03:
		addq.w	#8,ost_stomp_moved(a0)
		move.w	ost_stomp_moved(a0),d0
		cmp.w	ost_stomp_distance(a0),d0
		bne.s	@loc_15E8E
		clr.b	ost_stomp_flag(a0)

@loc_15E8E:
		move.w	ost_stomp_moved(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip03
		neg.w	d0
		addi.w	#$38,d0

	@noflip03:
		move.w	ost_stomp_y_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

; Stomper, drops quickly and rises quickly
@type04:
		tst.b	ost_stomp_flag(a0)
		bne.s	@isactive04
		tst.w	ost_stomp_moved(a0)
		beq.s	@loc_15EBE
		subq.w	#8,ost_stomp_moved(a0)
		bra.s	@loc_15EF0
; ===========================================================================

@loc_15EBE:
		subq.w	#1,ost_stomp_wait_time(a0)
		bpl.s	@loc_15EF0
		move.w	#60,ost_stomp_wait_time(a0)
		move.b	#1,ost_stomp_flag(a0)

@isactive04:
		move.w	ost_stomp_moved(a0),d0
		cmp.w	ost_stomp_distance(a0),d0
		beq.s	@loc_15EE0
		addq.w	#8,ost_stomp_moved(a0)
		bra.s	@loc_15EF0
; ===========================================================================

@loc_15EE0:
		subq.w	#1,ost_stomp_wait_time(a0)
		bpl.s	@loc_15EF0
		move.w	#60,ost_stomp_wait_time(a0)
		clr.b	ost_stomp_flag(a0)

@loc_15EF0:
		move.w	ost_stomp_moved(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip04
		neg.w	d0
		addi.w	#$38,d0

	@noflip04:
		move.w	ost_stomp_y_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

; Huge sliding door from SBZ3
@type05:
		tst.b	ost_stomp_flag(a0)
		bne.s	@loc_15F3E
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_stomp_switch_num(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@locret_15F5C
		move.b	#1,ost_stomp_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_15F3E
		bset	#0,2(a2,d0.w)

@loc_15F3E:
		subi.l	#$10000,ost_x_pos(a0)
		addi.l	#$8000,ost_y_pos(a0)
		move.w	ost_x_pos(a0),ost_stomp_x_start(a0)
		cmpi.w	#$980,ost_x_pos(a0)
		beq.s	@loc_15F5E

@locret_15F5C:
		rts	
; ===========================================================================

@loc_15F5E:
		clr.b	ost_subtype(a0)
		clr.b	ost_stomp_flag(a0)
		rts	
