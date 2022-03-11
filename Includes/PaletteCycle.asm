; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine

;	uses d0, d1, d2, a0, a1, a2
; ---------------------------------------------------------------------------

PaletteCycle:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		add.w	d0,d0
		move.w	PCycle_Index(pc,d0.w),d0
		jmp	PCycle_Index(pc,d0.w)			; jump to relevant palette routine

PCycle_Index:	index *
		ptr PCycle_GHZ
		ptr PCycle_LZ
		ptr PCycle_MZ
		ptr PalCycle_SLZ
		ptr PalCycle_SYZ
		ptr PalCycle_SBZ
		zonewarning PCycle_Index,2
		ptr PCycle_GHZ					; Ending

; ---------------------------------------------------------------------------
; Title screen (referenced from GM_Title)
; ---------------------------------------------------------------------------

PCycle_Title:
		lea	(Pal_TitleCyc).l,a0			; use different water palette
		bra.s	PCycle_GHZ_Run

; ---------------------------------------------------------------------------
; Green Hill Zone
; ---------------------------------------------------------------------------
PCycle_GHZ:
		lea	(Pal_GHZCyc).l,a0

PCycle_GHZ_Run:
		subq.w	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	@exit					; if time remains, branch

		move.w	#5,(v_palcycle_time).w			; reset timer to 5 frames
		move.w	(v_palcycle_num).w,d0			; get cycle number
		addq.w	#1,(v_palcycle_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0
		lea	(v_pal_dry_line3+(8*2)).w,a1		; 3rd line, 8 colours in
		move.l	(a0,d0.w),(a1)+				; copy 2 colours
		move.l	4(a0,d0.w),(a1)				; copy 2 more colours

	@exit:
		rts

; ---------------------------------------------------------------------------
; Labyrinth Zone
; ---------------------------------------------------------------------------

PCycle_LZ:
; Waterfalls
		subq.w	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	PCycle_LZ_Conveyor			; if time remains, branch

		move.w	#2,(v_palcycle_time).w			; reset timer to 2 frames
		move.w	(v_palcycle_num).w,d0
		addq.w	#1,(v_palcycle_num).w			; increment cycle number
		andi.w	#3,d0					; if cycle > 3, reset to 0
		lsl.w	#3,d0					; multiply by 8 (i.e. 4 colours)
		lea	(Pal_LZCyc1).l,a0
		cmpi.b	#3,(v_act).w				; check if level is SBZ3
		bne.s	@not_sbz3
		lea	(Pal_SBZ3Cyc1).l,a0			; load SBZ3 palette instead

	@not_sbz3:
		lea	(v_pal_dry_line3+(11*2)).w,a1		; 3rd line, 11 colours in
		move.l	(a0,d0.w),(a1)+				; copy 2 colours
		move.l	4(a0,d0.w),(a1)				; copy 2 more colours
		lea	(v_pal_water_line3+(11*2)).w,a1		; also do corresponding underwater palette
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

PCycle_LZ_Conveyor:
; Conveyor belts
		move.w	(v_frame_counter).w,d0			; get value that increments every frame
		andi.w	#7,d0					; read only bits 0-2 for number that is 0-7
		move.b	PCycLZ_Seq(pc,d0.w),d0			; get byte from palette sequence
		beq.s	@exit					; if byte is 0, branch
		moveq	#1,d1					; d1 = 1
		tst.b	(f_convey_reverse).w			; have conveyor belts been reversed?
		beq.s	@no_reverse				; if not, branch
		neg.w	d1					; d1 = -1

	@no_reverse:
		move.w	(v_palcycle_buffer).w,d0		; get saved value
		andi.w	#3,d0					; read bits 0-1
		add.w	d1,d0					; increment or decrement d0
		cmpi.w	#3,d0					; is d0 = 0/1/2?
		bcs.s	@no_wrap				; if yes, branch
		move.w	d0,d1
		moveq	#0,d0					; if d0 = 3, reset to 0
		tst.w	d1					; was d0 = -1?
		bpl.s	@no_wrap				; if not, branch
		moveq	#2,d0					; if d0 = -1, reset to 2

	@no_wrap:
		move.w	d0,(v_palcycle_buffer).w		; save updated value
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; multiply by 6
		lea	(Pal_LZCyc2).l,a0
		lea	(v_pal_dry_line4+(11*2)).w,a1		; 4th line, 11 colours in
		move.l	(a0,d0.w),(a1)+				; copy 2 colours
		move.w	4(a0,d0.w),(a1)				; copy 1 more colour
		lea	(Pal_LZCyc3).l,a0
		lea	(v_pal_water_line4+(11*2)).w,a1		; also do corresponding underwater palette
		move.l	(a0,d0.w),(a1)+
		move.w	4(a0,d0.w),(a1)

	@exit:
		rts

PCycLZ_Seq:	dc.b 1,	0, 0, 1, 0, 0, 1, 0

; ---------------------------------------------------------------------------
; Marble Zone
; ---------------------------------------------------------------------------

PCycle_MZ:
		rts	

; ---------------------------------------------------------------------------
; Star Light Zone
; ---------------------------------------------------------------------------

PalCycle_SLZ:
		subq.w	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	@exit					; if time remains, branch

		move.w	#7,(v_palcycle_time).w			; reset timer to 7 frames
		move.w	(v_palcycle_num).w,d0			; get cycle number
		addq.w	#1,d0					; increment
		cmpi.w	#6,d0					; is d0 less than 6?
		bcs.s	@no_reset				; if yes, branch
		moveq	#0,d0					; reset to 0

	@no_reset:
		move.w	d0,(v_palcycle_num).w			; update cycle number
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0					; multiply by 6
		lea	(Pal_SLZCyc).l,a0
		lea	(v_pal_dry_line3+(11*2)).w,a1		; 3rd line, 11 colours in
		move.w	(a0,d0.w),(a1)				; copy 1 colour
		move.l	2(a0,d0.w),4(a1)			; copy 2 more colours

	@exit:
		rts

; ---------------------------------------------------------------------------
; Spring Yard Zone
; ---------------------------------------------------------------------------

PalCycle_SYZ:
		subq.w	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	@exit					; if time remains, branch

		move.w	#5,(v_palcycle_time).w			; reset timer to 5 frames
		move.w	(v_palcycle_num).w,d0			; get cycle number
		addq.w	#1,(v_palcycle_num).w			; increment cycle number
		andi.w	#3,d0					; read bits 0-1
		lsl.w	#2,d0					; multiply by 4 (2 colours)
		move.w	d0,d1
		add.w	d0,d0					; multiply by 8 (4 colours)
		lea	(Pal_SYZCyc1).l,a0
		lea	(v_pal_dry_line4+(7*2)).w,a1		; 4th line, 7 colours in
		move.l	(a0,d0.w),(a1)+				; copy 2 colours
		move.l	4(a0,d0.w),(a1)				; copy 2 more colours
		lea	(Pal_SYZCyc2).l,a0
		lea	(v_pal_dry_line4+(11*2)).w,a1		; 4th line, 11 colours in
		move.w	(a0,d1.w),(a1)				; copy 1 colour
		move.w	2(a0,d1.w),4(a1)			; copy 1 more colour, with a gap of 1 colour after the 1st

	@exit:
		rts

; ---------------------------------------------------------------------------
; Scrap Brain Zone
; ---------------------------------------------------------------------------

PalCycle_SBZ:
		lea	(Pal_SBZCycList_Act1).l,a2
		tst.b	(v_act).w				; is this act 1?
		beq.s	@is_act1				; if yes, branch
		lea	(Pal_SBZCycList_Act2).l,a2

	@is_act1:
		lea	(v_palcycle_buffer).w,a1
		move.w	(a2)+,d1				; get number of palette scripts minus 1

@loop_scripts:
		subq.b	#1,(a1)					; decrement timer
		bmi.s	@run_script				; branch if less than 0
		addq.l	#2,a1					; jump to next timer
		addq.l	#6,a2					; jump to next script
		bra.s	@next
; ===========================================================================

@run_script:
		move.b	(a2)+,(a1)+				; reset timer
		move.b	(a1),d0					; get cycle number
		addq.b	#1,d0					; increment
		cmp.b	(a2)+,d0				; compare with max value from script
		bcs.s	@no_wrap				; branch if less than max
		moveq	#0,d0					; reset to 0

	@no_wrap:
		move.b	d0,(a1)+				; update cycle number
		andi.w	#$F,d0
		add.w	d0,d0					; multiply by 2 (1 colour)
		movea.w	(a2)+,a0				; set address of source data
		movea.w	(a2)+,a3				; set address of target palette
		move.w	(a0,d0.w),(a3)				; copy 1 colour

@next:
		dbf	d1,@loop_scripts

; Conveyor belts
		subq.w	#1,(v_palcycle_time).w			; decrement timer
		bpl.s	@exit					; if time remains, branch

		lea	(Pal_SBZCyc4).l,a0
		move.w	#1,(v_palcycle_time).w			; reset timer to 1 frame
		tst.b	(v_act).w				; is this act 1?
		beq.s	@is_act1_again				; if yes, branch
		lea	(Pal_SBZCyc10).l,a0
		move.w	#0,(v_palcycle_time).w			; reset timer to 0 frames (palette updates every frame)

	@is_act1_again:
		moveq	#-1,d1
		tst.b	(f_convey_reverse).w			; have conveyor belts been reversed?
		beq.s	@no_reverse				; if not, branch
		neg.w	d1					; d1 = 1

	@no_reverse:
		move.w	(v_palcycle_num).w,d0			; get cycle number
		andi.w	#3,d0					; read bits 0-1
		add.w	d1,d0					; increment or decrement d0
		cmpi.w	#3,d0					; is d0 = 0/1/2?
		bcs.s	@no_wrap_again				; if yes, branch
		move.w	d0,d1
		moveq	#0,d0					; if d0 = 3, reset to 0
		tst.w	d1					; was d0 = -1?
		bpl.s	@no_wrap_again				; if not, branch
		moveq	#2,d0					; if d0 = -1, reset to 2

	@no_wrap_again:
		move.w	d0,(v_palcycle_num).w			; update cycle number
		add.w	d0,d0					; multiply by 2 (1 colour offset)
		lea	(v_pal_dry_line3+(12*2)).w,a1		; 3rd line, 12 colours in
		move.l	(a0,d0.w),(a1)+				; copy 2 colours
		move.w	4(a0,d0.w),(a1)				; copy 1 more colour

@exit:
		rts

; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------
mSBZp:		macro time,length,paladdress,ramaddress
		dc.b time, length
		dc.w paladdress, ramaddress
		endm

; time between updates in frames, length of sequence, palette address, RAM address

include_Pal_SBZCycList:	macro
Pal_SBZCycList_Act1:
		dc.w ((@end-Pal_SBZCycList_Act1-2)/6)-1
		mSBZp	7,8,Pal_SBZCyc1,v_pal_dry_line3+(8*2)
		mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry_line3+(9*2)
		mSBZp	$E,8,Pal_SBZCyc3,v_pal_dry_line4+(7*2)
		mSBZp	$B,8,Pal_SBZCyc5,v_pal_dry_line4+(8*2)
		mSBZp	7,8,Pal_SBZCyc6,v_pal_dry_line4+(9*2)
		mSBZp	$1C,$10,Pal_SBZCyc7,v_pal_dry_line4+(15*2)
		mSBZp	3,3,Pal_SBZCyc8,v_pal_dry_line4+(12*2)
		mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry_line4+(13*2)
		mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry_line4+(14*2)
	@end:
		even

Pal_SBZCycList_Act2:
		dc.w ((@end-Pal_SBZCycList_Act2-2)/6)-1
		mSBZp	7,8,Pal_SBZCyc1,v_pal_dry_line3+(8*2)
		mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry_line3+(9*2)
		mSBZp	9,8,Pal_SBZCyc9,v_pal_dry_line4+(8*2)
		mSBZp	7,8,Pal_SBZCyc6,v_pal_dry_line4+(9*2)
		mSBZp	3,3,Pal_SBZCyc8,v_pal_dry_line4+(12*2)
		mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry_line4+(13*2)
		mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry_line4+(14*2)
	@end:
		even
		endm
