; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)

; spawned by:
;	ObjPos_SBZ1 - subtypes $80-$85
;	SpinConvey - subtypes 0-$53
; ---------------------------------------------------------------------------

SpinConvey:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SpinC_Index(pc,d0.w),d1
		jsr	SpinC_Index(pc,d1.w)
		out_of_range.s	SpinC_ChkDel,ost_spinc_x_pos_centre(a0)

SpinC_Display:
		jmp	(DisplaySprite).l
; ===========================================================================

SpinC_ChkDel:
		cmpi.b	#2,(v_act).w				; is this act 3?
		bne.s	@not_act3				; if not, branch
		cmpi.w	#-$80,d0				; is object to the right?
		bcc.s	SpinC_Display				; if yes, branch

	@not_act3:
		move.b	ost_spinc_subtype_copy(a0),d0		; get original subtype
		bpl.s	SpinC_Delete				; branch if not the parent object
		andi.w	#$7F,d0
		lea	(v_convey_init_list).w,a2
		bclr	#0,(a2,d0.w)

SpinC_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
SpinC_Index:	index *,,2
		ptr SpinC_Main
		ptr SpinC_Solid

ost_spinc_subtype_copy:	equ $2F					; copy of the initial subtype ($80/$81/etc.)
ost_spinc_x_pos_centre:	equ $30					; approximate x position of centre of conveyor (2 bytes)
ost_spinc_corner_x_pos:	equ $34					; x position of next corner (2 bytes)
ost_spinc_corner_y_pos:	equ $36					; y position of next corner (2 bytes)
ost_spinc_corner_next:	equ $38					; index of next corner
ost_spinc_corner_count:	equ $39					; total number of corners +1, times 4
ost_spinc_corner_inc:	equ $3A					; amount to add to corner index (4 or -4)
ost_spinc_reverse:	equ $3B					; 1 = conveyors run backwards
ost_spinc_corner_ptr:	equ $3C					; address of corner position data (4 bytes)
; ===========================================================================

SpinC_Main:	; Routine 0
		move.b	ost_subtype(a0),d0
		bmi.w	SpinC_LoadPlatforms			; branch if subtype is $80+
		addq.b	#2,ost_routine(a0)			; goto SpinC_Solid next
		move.l	#Map_Spin,ost_mappings(a0)
		move.w	#tile_Nem_SpinPform,ost_tile(a0)
		move.b	#$10,ost_displaywidth(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)

		moveq	#0,d0
		move.b	ost_subtype(a0),d0			; get subtype (not the same as initial subtype)
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0					; read high nybble of subtype
		lea	SpinC_Corner_Data(pc),a2
		adda.w	(a2,d0.w),a2				; get address of corner data
		move.w	(a2)+,ost_spinc_corner_count-1(a0)	; get corner count
		move.w	(a2)+,ost_spinc_x_pos_centre(a0)
		move.l	a2,ost_spinc_corner_ptr(a0)		; pointer to corner x/y values
		andi.w	#$F,d1					; read low nybble of subtype
		lsl.w	#2,d1					; multiply by 4
		move.b	d1,ost_spinc_corner_next(a0)
		move.b	#4,ost_spinc_corner_inc(a0)
		tst.b	(f_convey_reverse).w			; is conveyor set to reverse?
		beq.s	@no_reverse				; if not, branch

		move.b	#1,ost_spinc_reverse(a0)
		neg.b	ost_spinc_corner_inc(a0)
		moveq	#0,d1
		move.b	ost_spinc_corner_next(a0),d1
		add.b	ost_spinc_corner_inc(a0),d1
		cmp.b	ost_spinc_corner_count(a0),d1		; is next corner valid?
		bcs.s	@is_valid				; if yes, branch
		move.b	d1,d0
		moveq	#0,d1					; reset corner counter to 0
		tst.b	d0
		bpl.s	@is_valid
		move.b	ost_spinc_corner_count(a0),d1
		subq.b	#4,d1

	@is_valid:
		move.b	d1,ost_spinc_corner_next(a0)		; update corner counter

	@no_reverse:
		move.w	(a2,d1.w),ost_spinc_corner_x_pos(a0)	; get corner position data
		move.w	2(a2,d1.w),ost_spinc_corner_y_pos(a0)
		tst.w	d1					; is next corner top left?
		bne.s	@not_top_left				; if not, branch
		move.b	#id_ani_spinc_still,ost_anim(a0)	; use still animation

	@not_top_left:
		cmpi.w	#8,d1					; is next corner bottom right?
		bne.s	@not_btm_right				; if not, branch
		move.b	#id_ani_spinc_spin,ost_anim(a0)		; use spinning animation

	@not_btm_right:
		bsr.w	LCon_Platform_Move			; begin platform moving
		bra.w	SpinC_Solid
; ===========================================================================

SpinC_LoadPlatforms:
		move.b	d0,ost_spinc_subtype_copy(a0)
		andi.w	#$7F,d0					; d0 = bits 0-6 of subtype
		lea	(v_convey_init_list).w,a2
		bset	#0,(a2,d0.w)				; set flag to indicate object exists
		beq.s	@not_set				; branch if not previously set
		jmp	(DeleteObject).l
; ===========================================================================

@not_set:
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosSBZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2				; get address of platform position data
		move.w	(a2)+,d1				; get object count
		movea.l	a0,a1					; overwrite current object with 1st platform
		bra.s	@make_first
; ===========================================================================

	@loop:
		jsr	(FindFreeObj).l				; find free OST slot
		bne.s	@fail					; branch if not found

@make_first:
		move.b	#id_SpinConvey,ost_id(a1)		; load platform object
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,ost_subtype(a1)

	@fail:
		dbf	d1,@loop				; repeat for number of objects

		addq.l	#4,sp
		rts	
; ===========================================================================

SpinC_Solid:	; Routine 2
		lea	(Ani_SpinConvey).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_frame(a0)				; is platform on a spinning frame?
		bne.s	@spinning				; if yes, branch
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	SpinC_Update
		move.w	#$1B,d1
		move.w	#7,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		bra.w	SolidObject				; make platform solid on flat frame
; ===========================================================================

@spinning:
		btst	#status_platform_bit,ost_status(a0)	; is platform being stood on?
		beq.s	@skip_clr				; if not, branch
		lea	(v_ost_player).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)

	@skip_clr:
		bra.w	SpinC_Update

; ---------------------------------------------------------------------------
; Subroutine to get next corner coordinates and update platform position
; ---------------------------------------------------------------------------

SpinC_Update:
		move.w	ost_x_pos(a0),d0
		cmp.w	ost_spinc_corner_x_pos(a0),d0		; is platform at corner?
		bne.s	@not_at_corner				; if not, branch
		move.w	ost_y_pos(a0),d0
		cmp.w	ost_spinc_corner_y_pos(a0),d0
		bne.s	@not_at_corner

		moveq	#0,d1
		move.b	ost_spinc_corner_next(a0),d1
		add.b	ost_spinc_corner_inc(a0),d1
		cmp.b	ost_spinc_corner_count(a0),d1		; is next corner valid?
		bcs.s	@is_valid				; if yes, branch
		move.b	d1,d0
		moveq	#0,d1					; reset corner counter to 0
		tst.b	d0
		bpl.s	@is_valid
		move.b	ost_spinc_corner_count(a0),d1
		subq.b	#4,d1

	@is_valid:
		move.b	d1,ost_spinc_corner_next(a0)
		movea.l	ost_spinc_corner_ptr(a0),a1
		move.w	(a1,d1.w),ost_spinc_corner_x_pos(a0)	; get corner position data
		move.w	2(a1,d1.w),ost_spinc_corner_y_pos(a0)
		tst.w	d1					; is next corner top left?
		bne.s	@not_top_left				; if not, branch
		move.b	#id_ani_spinc_still,ost_anim(a0)	; use still animation

	@not_top_left:
		cmpi.w	#8,d1					; is next corner bottom right?
		bne.s	@not_btm_right				; if not, branch
		move.b	#id_ani_spinc_spin,ost_anim(a0)		; use spinning animation

	@not_btm_right:
		bsr.w	LCon_Platform_Move			; set direction and speed

	@not_at_corner:
		jmp	(SpeedToPos).l				; update position

; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_SpinConvey:	index *
		ptr ani_spinc_spin
		ptr ani_spinc_still
		
ani_spinc_spin:
		dc.b 0
		dc.b id_frame_spin_flat
		dc.b id_frame_spin_1
		dc.b id_frame_spin_2
		dc.b id_frame_spin_3
		dc.b id_frame_spin_4
		dc.b id_frame_spin_3+afyflip
		dc.b id_frame_spin_2+afyflip
		dc.b id_frame_spin_1+afyflip
		dc.b id_frame_spin_flat+afyflip
		dc.b id_frame_spin_1+afxflip+afyflip
		dc.b id_frame_spin_2+afxflip+afyflip
		dc.b id_frame_spin_3+afxflip+afyflip
		dc.b id_frame_spin_4+afxflip+afyflip
		dc.b id_frame_spin_3+afxflip
		dc.b id_frame_spin_2+afxflip
		dc.b id_frame_spin_1+afxflip
		dc.b id_frame_spin_flat
		dc.b afEnd
		even
ani_spinc_still:
		dc.b $F
		dc.b id_frame_spin_flat
		dc.b afEnd
		even

SpinC_Corner_Data:
		index *
		ptr SpinC_Corners_0
		ptr SpinC_Corners_1
		ptr SpinC_Corners_2
		ptr SpinC_Corners_3
		ptr SpinC_Corners_4
		ptr SpinC_Corners_5
SpinC_Corners_0:
		dc.w @end-(*+4)
		dc.w $E80					; x centre
		dc.w $E14, $370					; top left corner
		dc.w $EEF, $302					; top right corner
		dc.w $EEF, $340					; bottom right corner
		dc.w $E14, $3AE					; bottom left corner
	@end:

SpinC_Corners_1:
		dc.w @end-(*+4)
		dc.w $F80
		dc.w $F14, $2E0
		dc.w $FEF, $272
		dc.w $FEF, $2B0
		dc.w $F14, $31E
	@end:

SpinC_Corners_2:
		dc.w @end-(*+4)
		dc.w $1080
		dc.w $1014, $270
		dc.w $10EF, $202
		dc.w $10EF, $240
		dc.w $1014, $2AE
	@end:

SpinC_Corners_3:
		dc.w @end-(*+4)
		dc.w $F80
		dc.w $F14, $570
		dc.w $FEF, $502
		dc.w $FEF, $540
		dc.w $F14, $5AE
	@end:

SpinC_Corners_4:
		dc.w @end-(*+4)
		dc.w $1B80
		dc.w $1B14, $670
		dc.w $1BEF, $602
		dc.w $1BEF, $640
		dc.w $1B14, $6AE
	@end:

SpinC_Corners_5:
		dc.w @end-(*+4)
		dc.w $1C80
		dc.w $1C14, $5E0
		dc.w $1CEF, $572
		dc.w $1CEF, $5B0
		dc.w $1C14, $61E
	@end:
