; ---------------------------------------------------------------------------
; Object 56 - floating blocks (SYZ/SLZ), large doors (LZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	FBlock_Index(pc,d0.w),d1
		jmp	FBlock_Index(pc,d1.w)
; ===========================================================================
FBlock_Index:	index *
		ptr FBlock_Main
		ptr FBlock_Action

FBlock_Var:	; width/2, height/2
		dc.b  $10, $10	; subtype 0x/8x
		dc.b  $20, $20	; subtype 1x/9x
		dc.b  $10, $20	; subtype 2x/Ax
		dc.b  $20, $1A	; subtype 3x/Bx
		dc.b  $10, $27	; subtype 4x/Cx
		dc.b  $10, $10	; subtype 5x/Dx
		dc.b	8, $20	; subtype 6x/Ex
		dc.b  $40, $10	; subtype 7x/Fx

ost_fblock_y_start:	equ $30	; original y position (2 bytes)
ost_fblock_x_start:	equ $34	; original x position (2 bytes)
ost_fblock_move_flag:	equ $38	; 1 = block/door is moving
ost_fblock_height:	equ $3A	; total object height (2 bytes)
ost_fblock_switch_num:	equ $3C	; which switch the block is linked to
; ===========================================================================

FBlock_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_FBlock,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		bne.s	@notLZ
		move.w	#tile_Nem_LzDoor1+tile_pal3,ost_tile(a0) ; LZ specific code

	@notLZ:
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get subtype
		lsr.w	#3,d0
		andi.w	#$E,d0		; read only the 1st digit
		lea	FBlock_Var(pc,d0.w),a2 ; get size data
		move.b	(a2)+,ost_actwidth(a0)
		move.b	(a2),ost_height(a0)
		lsr.w	#1,d0
		move.b	d0,ost_frame(a0)
		move.w	ost_x_pos(a0),ost_fblock_x_start(a0)
		move.w	ost_y_pos(a0),ost_fblock_y_start(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,ost_fblock_height(a0)
		if Revision=0
		else
			cmpi.b	#$37,ost_subtype(a0)
			bne.s	@dontdelete
			cmpi.w	#$1BB8,ost_x_pos(a0)
			bne.s	@notatpos
			tst.b	($FFFFF7CE).w
			beq.s	@dontdelete
			jmp	(DeleteObject).l
	@notatpos:
			clr.b	ost_subtype(a0)
			tst.b	($FFFFF7CE).w
			bne.s	@dontdelete
			jmp	(DeleteObject).l
	@dontdelete:
		endc
		moveq	#0,d0
		cmpi.b	#id_LZ,(v_zone).w ; check if level is LZ
		beq.s	@stillnotLZ
		move.b	ost_subtype(a0),d0 ; SYZ/SLZ specific code
		andi.w	#$F,d0		; read low nybble of subtype
		subq.w	#8,d0		; subtract 8
		bcs.s	@stillnotLZ
		lsl.w	#2,d0
		lea	(v_oscillate+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	@stillnotLZ
		bchg	#status_xflip_bit,ost_status(a0)

	@stillnotLZ:
		move.b	ost_subtype(a0),d0 ; get subtype
		bpl.s	FBlock_Action	; if subtype is 0-$7F, branch
		andi.b	#$F,d0		; read low nybble
		move.b	d0,ost_fblock_switch_num(a0) ; save to variable
		move.b	#5,ost_subtype(a0) ; force subtype to 5 (moves up when switch is pressed)
		cmpi.b	#7,ost_frame(a0) ; is object a large horizontal LZ door?
		bne.s	@chkstate	; if not, branch
		move.b	#$C,ost_subtype(a0) ; force subtype to $C (moves left when switch is pressed)
		move.w	#$80,ost_fblock_height(a0)

@chkstate:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	FBlock_Action
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	FBlock_Action
		addq.b	#1,ost_subtype(a0)
		clr.w	ost_fblock_height(a0)

FBlock_Action:	; Routine 2
		move.w	ost_x_pos(a0),-(sp)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object subtype
		andi.w	#$F,d0		; read only the	2nd digit
		add.w	d0,d0
		move.w	@index(pc,d0.w),d1
		jsr	@index(pc,d1.w)	; block movement subroutines
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
		if Revision=0
		out_of_range	DeleteObject,ost_fblock_x_start(a0)
		bra.w	DisplaySprite
		else
			out_of_range.s	@chkdel2,ost_fblock_x_start(a0)
		@display:
			bra.w	DisplaySprite
		@chkdel2:
			cmpi.b	#$37,ost_subtype(a0)
			bne.s	@delete
			tst.b	ost_fblock_move_flag(a0)
			bne.s	@display
		@delete:
			jmp	(DeleteObject).l
		endc
; ===========================================================================
@index:		index *
		ptr @type00
		ptr @type01
		ptr @type02
		ptr @type03
		ptr @type04
		ptr @type05
		ptr @type06
		ptr @type07
		ptr @type08
		ptr @type09
		ptr @type0A
		ptr @type0B
		ptr @type0C
		ptr @type0D
; ===========================================================================

@type00:
; doesn't move
		rts	
; ===========================================================================

@type01:
; moves side-to-side
		move.w	#$40,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	@moveLR
; ===========================================================================

@type02:
; moves side-to-side
		move.w	#$80,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

	@moveLR:
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip
		neg.w	d0
		add.w	d1,d0

	@noflip:
		move.w	ost_fblock_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0) ; move object horizontally
		rts	
; ===========================================================================

@type03:
; moves up/down
		move.w	#$40,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	@moveUD
; ===========================================================================

@type04:
; moves up/down
		move.w	#$80,d1		; set move distance
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

	@moveUD:
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip04
		neg.w	d0
		add.w	d1,d0

	@noflip04:
		move.w	ost_fblock_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0) ; move object vertically
		rts	
; ===========================================================================

@type05:
; moves up when a switch is pressed
		tst.b	ost_fblock_move_flag(a0)
		bne.s	@loc_104A4
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w ; is level LZ1 ?
		bne.s	@aaa		; if not, branch
		cmpi.b	#3,ost_fblock_switch_num(a0)
		bne.s	@aaa
		clr.b	(f_wtunnelallow).w
		move.w	(v_player+ost_x_pos).w,d0
		cmp.w	ost_x_pos(a0),d0
		bcc.s	@aaa
		move.b	#1,(f_wtunnelallow).w

	@aaa:
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_fblock_switch_num(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@loc_104AE
		cmpi.w	#(id_LZ<<8)+0,(v_zone).w ; is level LZ1 ?
		bne.s	@loc_1049E	; if not, branch
		cmpi.b	#3,d0
		bne.s	@loc_1049E
		clr.b	(f_wtunnelallow).w

@loc_1049E:
		move.b	#1,ost_fblock_move_flag(a0)

@loc_104A4:
		tst.w	ost_fblock_height(a0)
		beq.s	@loc_104C8
		subq.w	#2,ost_fblock_height(a0)

@loc_104AE:
		move.w	ost_fblock_height(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@loc_104BC
		neg.w	d0

@loc_104BC:
		move.w	ost_fblock_y_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@loc_104C8:
		addq.b	#1,ost_subtype(a0)
		clr.b	ost_fblock_move_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_104AE
		bset	#0,2(a2,d0.w)
		bra.s	@loc_104AE
; ===========================================================================

@type06:
		tst.b	ost_fblock_move_flag(a0)
		bne.s	@loc_10500
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_fblock_switch_num(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	@loc_10512
		move.b	#1,ost_fblock_move_flag(a0)

@loc_10500:
		moveq	#0,d0
		move.b	ost_height(a0),d0
		add.w	d0,d0
		cmp.w	ost_fblock_height(a0),d0
		beq.s	@loc_1052C
		addq.w	#2,ost_fblock_height(a0)

@loc_10512:
		move.w	ost_fblock_height(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@loc_10520
		neg.w	d0

@loc_10520:
		move.w	ost_fblock_y_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@loc_1052C:
		subq.b	#1,ost_subtype(a0)
		clr.b	ost_fblock_move_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_10512
		bclr	#0,2(a2,d0.w)
		bra.s	@loc_10512
; ===========================================================================

@type07:
		tst.b	ost_fblock_move_flag(a0)
		bne.s	@loc_1055E
		tst.b	(f_switch+$F).w	; has switch number $F been pressed?
		beq.s	@locret_10578
		move.b	#1,ost_fblock_move_flag(a0)
		clr.w	ost_fblock_height(a0)

@loc_1055E:
		addq.w	#1,ost_x_pos(a0)
		move.w	ost_x_pos(a0),ost_fblock_x_start(a0)
		addq.w	#1,ost_fblock_height(a0)
		cmpi.w	#$380,ost_fblock_height(a0)
		bne.s	@locret_10578
		if Revision=0
		else
			move.b	#1,($FFFFF7CE).w
			clr.b	ost_fblock_move_flag(a0)
		endc
		clr.b	ost_subtype(a0)

@locret_10578:
		rts	
; ===========================================================================

@type0C:
		tst.b	ost_fblock_move_flag(a0)
		bne.s	@loc_10598
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_fblock_switch_num(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	@loc_105A2
		move.b	#1,ost_fblock_move_flag(a0)

@loc_10598:
		tst.w	ost_fblock_height(a0)
		beq.s	@loc_105C0
		subq.w	#2,ost_fblock_height(a0)

@loc_105A2:
		move.w	ost_fblock_height(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@loc_105B4
		neg.w	d0
		addi.w	#$80,d0

@loc_105B4:
		move.w	ost_fblock_x_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@loc_105C0:
		addq.b	#1,ost_subtype(a0)
		clr.b	ost_fblock_move_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@loc_105A2
		bset	#0,2(a2,d0.w)
		bra.s	@loc_105A2
; ===========================================================================

@type0D:
		tst.b	ost_fblock_move_flag(a0)
		bne.s	@loc_105F8
		lea	(f_switch).w,a2
		moveq	#0,d0
		move.b	ost_fblock_switch_num(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	@wtf
		move.b	#1,ost_fblock_move_flag(a0)

@loc_105F8:
		move.w	#$80,d0
		cmp.w	ost_fblock_height(a0),d0
		beq.s	@loc_10624
		addq.w	#2,ost_fblock_height(a0)

@wtf:
		move.w	ost_fblock_height(a0),d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@loc_10618
		neg.w	d0
		addi.w	#$80,d0

@loc_10618:
		move.w	ost_fblock_x_start(a0),d1
		add.w	d0,d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@loc_10624:
		subq.b	#1,ost_subtype(a0)
		clr.b	ost_fblock_move_flag(a0)
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@wtf
		bclr	#0,2(a2,d0.w)
		bra.s	@wtf
; ===========================================================================

@type08:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2A).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillate+$2C).w,d3
		bra.s	@square
; ===========================================================================

@type09:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2E).w,d0
		move.w	(v_oscillate+$30).w,d3
		bra.s	@square
; ===========================================================================

@type0A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillate+$32).w,d0
		move.w	(v_oscillate+$34).w,d3
		bra.s	@square
; ===========================================================================

@type0B:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillate+$36).w,d0
		move.w	(v_oscillate+$38).w,d3

@square:
		tst.w	d3
		bne.s	@loc_1068E
		addq.b	#status_xflip,ost_status(a0)
		andi.b	#status_xflip+status_yflip,ost_status(a0)

@loc_1068E:
		move.b	ost_status(a0),d2
		andi.b	#status_xflip+status_yflip,d2
		bne.s	@loc_106AE
		sub.w	d1,d0
		add.w	ost_fblock_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		neg.w	d1
		add.w	ost_fblock_y_start(a0),d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@loc_106AE:
		subq.b	#1,d2
		bne.s	@loc_106CC
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	ost_fblock_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		addq.w	#1,d1
		add.w	ost_fblock_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		rts	
; ===========================================================================

@loc_106CC:
		subq.b	#1,d2
		bne.s	@loc_106EA
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	ost_fblock_x_start(a0),d0
		move.w	d0,ost_x_pos(a0)
		addq.w	#1,d1
		add.w	ost_fblock_y_start(a0),d1
		move.w	d1,ost_y_pos(a0)
		rts	
; ===========================================================================

@loc_106EA:
		sub.w	d1,d0
		add.w	ost_fblock_y_start(a0),d0
		move.w	d0,ost_y_pos(a0)
		neg.w	d1
		add.w	ost_fblock_x_start(a0),d1
		move.w	d1,ost_x_pos(a0)
		rts	
