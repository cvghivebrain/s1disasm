; ---------------------------------------------------------------------------
; Background layer deformation subroutines

;	uses d0.l, d1.l, d2.l, d3.l, d4.l, d5.l, d6.l, a1, a2, a3
; ---------------------------------------------------------------------------

DeformLayers:
		tst.b	(f_disable_scrolling).w			; is scrolling disabled?
		beq.s	.bgscroll				; if not, branch
		rts	
; ===========================================================================

	.bgscroll:
		clr.w	(v_fg_redraw_direction).w		; clear all redraw flags
		clr.w	(v_bg1_redraw_direction).w
		clr.w	(v_bg2_redraw_direction).w
		clr.w	(v_bg3_redraw_direction).w
		bsr.w	UpdateCamera_X				; update camera position & redraw flags
		bsr.w	UpdateCamera_Y
		bsr.w	DynamicLevelEvents			; update level boundaries, load bosses etc.
		if Revision=0
			move.w	(v_camera_x_pos).w,(v_fg_x_pos_hscroll).w
			move.w	(v_camera_y_pos).w,(v_fg_y_pos_vsram).w
			move.w	(v_bg1_x_pos).w,(v_bg_x_pos_hscroll).w
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
			move.w	(v_bg3_x_pos).w,(v_bg3_x_pos_copy_unused).w
			move.w	(v_bg3_y_pos).w,(v_bg3_y_pos_copy_unused).w
		else
			move.w	(v_camera_y_pos).w,(v_fg_y_pos_vsram).w ; v_fg_y_pos_vsram is sent to VSRAM during VBlank
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
		endc
		moveq	#0,d0
		move.b	(v_zone).w,d0				; get zone number
		add.w	d0,d0					; multiply by 2
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)			; goto relevant deformation code

; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	index offset(*)
		ptr Deform_GHZ
		ptr Deform_LZ
		ptr Deform_MZ
		ptr Deform_SLZ
		ptr Deform_SYZ
		ptr Deform_SBZ
		zonewarning Deform_Index,2
		ptr Deform_GHZ

; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_GHZ:
		if Revision=0
; REV00 - clouds and mountains scroll together

		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#0,d5
		bsr.w	UpdateBG_XY				; update bg x pos and set redraw flags
		bsr.w	UpdateBG_X_Block2_GHZ

		; calculate y position
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_camera_y_pos).w,d0			; get camera pos
		andi.w	#$7FF,d0				; maximum $7FF
		lsr.w	#5,d0					; divide by $20
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,(v_bg2_y_pos).w			; update bg y pos
		move.w	d0,d4
		bsr.w	UpdateBG_Y_Absolute			; update bg y pos and set redraw flags
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		; clouds and distant mountains
		move.w	#112-1,d1
		sub.w	d4,d1
		move.w	(v_camera_x_pos).w,d0
		cmpi.b	#id_Title,(v_gamemode).w
		bne.s	.not_title
		moveq	#0,d0
	.not_title:
		neg.w	d0
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0

	.loop_clouds:
		move.l	d0,(a1)+
		dbf	d1,.loop_clouds

		else
; REV01 - additional scrolling for clouds

		; block 3 - distant mountains
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#redraw_top_bit,d6
		bsr.w	UpdateBG_X_Block3			; update bg x pos and set redraw flags

		; block 2 - hills & waterfalls
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#redraw_bg2_left_bit,d6
		bsr.w	UpdateBG_X_Block2			; update bg x pos and set redraw flags

		; calculate Y position
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_camera_y_pos).w,d0			; get camera pos
		andi.w	#$7FF,d0				; maximum $7FF
		lsr.w	#5,d0					; divide by $20
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	.limitY					; branch if v_camera_y_pos is between 0 and $400
		moveq	#0,d0					; use 0 if greater
	.limitY:
		move.w	d0,d4
		move.w	d0,(v_bg_y_pos_vsram).w			; update bg y pos
		move.w	(v_camera_x_pos).w,d0
		cmpi.b	#id_Title,(v_gamemode).w		; is this the title screen?
		bne.s	.notTitle				; if not, branch
		moveq	#0,d0					; reset camera position for title screen
	.notTitle:
		neg.w	d0
		swap	d0

		; clouds
		lea	(v_bgscroll_buffer).w,a2
		addi.l	#$10000,(a2)+				; autoscroll upper cloud fastest
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+

		move.w	(v_bgscroll_buffer).w,d0		; get autoscroll position of upper cloud
		add.w	(v_bg3_x_pos).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#32-1,d1
		sub.w	d4,d1
		bcs.s	.gotoCloud2
	.cloudLoop1:						; upper cloud (32px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,.cloudLoop1

	.gotoCloud2:
		move.w	(v_bgscroll_buffer+4).w,d0		; get autoscroll position of middle cloud
		add.w	(v_bg3_x_pos).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	.cloudLoop2:						; middle cloud (16px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,.cloudLoop2

		move.w	(v_bgscroll_buffer+8).w,d0		; get autoscroll position of lower cloud
		add.w	(v_bg3_x_pos).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	.cloudLoop3:						; lower cloud (16px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,.cloudLoop3

		; mountains
		move.w	#48-1,d1
		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
	.mountainLoop:						; distant mountains (48px)
		move.l	d0,(a1)+
		dbf	d1,.mountainLoop

		endc

		; hills and waterfalls
		move.w	#40-1,d1
		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
	.hillLoop:						; hills & waterfalls (40px)
		move.l	d0,(a1)+
		dbf	d1,.hillLoop

		; water
		move.w	(v_bg2_x_pos).w,d0
		if Revision=0
			addi.w	#0,d0
		endc
		move.w	(v_camera_x_pos).w,d2
		if Revision=0
			addi.w	#-$200,d2
		endc
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#72-1,d1
		add.w	d4,d1
	.waterLoop:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,.waterLoop
		rts

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_LZ:
		; plain background scroll
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	UpdateBG_XY

		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		if Revision=0
		else
; REV01 - additional water ripple effects

			lea	(LZ_FG_Ripple_Data).l,a3	; get foreground ripple data
			lea	(LZ_BG_Ripple_Data).l,a2	; get background ripple data (see Objects\LZ Drowning Numbers.asm)
			move.b	(v_water_ripple_y_pos).w,d2	; get high byte of y pos. of ripple effect
			move.b	d2,d3
			addi.w	#$80,(v_water_ripple_y_pos).w	; add $80 to low byte (i.e. high byte increments every other frame)

			add.w	(v_bg1_y_pos).w,d2
			andi.w	#$FF,d2				; d2 = low byte of bg y pos
			add.w	(v_camera_y_pos).w,d3
			andi.w	#$FF,d3				; d3 = low byte of camera y pos
		endc

		lea	(v_hscroll_buffer).w,a1
		move.w	#224-1,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		if Revision=0
		else
			move.w	d0,d6
		endc
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0

		if Revision=0
	.loop_hscroll:
			move.l	d0,(a1)+			; write to v_hscroll_buffer
			dbf	d1,.loop_hscroll
			move.w	(v_water_height_actual).w,d0
			sub.w	(v_camera_y_pos).w,d0
			rts

		else
; REV01 - additional water ripple effects

			move.w	(v_water_height_actual).w,d4
			move.w	(v_camera_y_pos).w,d5

		; write normal scroll before meeting water position
	.normalLoop:		
			cmp.w	d4,d5				; is current scanline at or below actual water y pos?
			bge.s	.underwaterLoop			; if yes, branch
			move.l	d0,(a1)+			; write to v_hscroll_buffer without ripple effect
			addq.w	#1,d5				; next scanline
			addq.b	#1,d2
			addq.b	#1,d3
			dbf	d1,.normalLoop
			rts

		; apply ripple effects when underwater
	.underwaterLoop:
			move.b	(a3,d3.w),d4			; get fg ripple value from LZ_FG_Ripple_Data
			ext.w	d4
			add.w	d6,d4
			move.w	d4,(a1)+			; write to v_hscroll_buffer
			move.b	(a2,d2.w),d4			; get bg ripple value from Drown_WobbleData
			ext.w	d4
			add.w	d0,d4
			move.w	d4,(a1)+			; write to v_hscroll_buffer
			addq.b	#1,d2
			addq.b	#1,d3
			dbf	d1,.underwaterLoop
			rts

LZ_FG_Ripple_Data:
		dc.b 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 1, 1		; 12 lines shifted to right
		dcb.b 116, 0					; 116 lines normal
		dc.b -1, -1, -2, -2, -3, -3, -3, -3, -2, -2, -1, -1 ; 12 lines shifted to left
		dcb.b 20, 0					; 20 lines normal
		dc.b 1, 1, 2, 2, 3, 3, 3, 3, 2, 2, 1, 1		; 12 lines shifted to right
		dcb.b 84, 0					; 84 lines normal (total 256 lines)

		endc

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_MZ:
		; block 1 - dungeon interior
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $C0

		if Revision=0
			moveq	#0,d5
			bsr.w	UpdateBG_XY
		else
			moveq	#redraw_left_bit,d6
			bsr.w	UpdateBG_X_Block1

		; block 3 - mountains
			move.w	(v_camera_x_diff).w,d4		; get camera x pos change since last frame
			ext.l	d4
			asl.l	#6,d4				; multiply by $40
			moveq	#6,d6
			bsr.w	UpdateBG_X_Block3

		; block 2 - bushes & antique buildings
			move.w	(v_camera_x_diff).w,d4		; get camera x pos change since last frame
			ext.l	d4
			asl.l	#7,d4				; multiply by $80
			moveq	#redraw_topall_bit,d6
			bsr.w	UpdateBG_X_Block2

		endc

		; calculate y position
		move.w	#512,d0					; start with 512px, ignoring 2 chunks
		move.w	(v_camera_y_pos).w,d1
		subi.w	#456,d1
		bcs.s	.noYscroll				; branch if v_camera_y_pos < 456
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0					; d0 = 512+((v_camera_y_pos-456)*0.75) = (v_camera_y_pos*0.75)+170
	.noYscroll:
		move.w	d0,(v_bg2_y_pos).w
		if Revision=0
		else
			move.w	d0,(v_bg3_y_pos).w
		endc
		bsr.w	UpdateBG_Y_Absolute
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		if Revision=0
			lea	(v_hscroll_buffer).w,a1
			move.w	#223,d1
			move.w	(v_camera_x_pos).w,d0
			neg.w	d0
			swap	d0
			move.w	(v_bg1_x_pos).w,d0
			neg.w	d0

	.loop_hscroll:
			move.l	d0,(a1)+
			dbf	d1,.loop_hscroll
			rts	
		else
		; do something with redraw flags
			move.b	(v_bg1_redraw_direction).w,d0
			or.b	(v_bg2_redraw_direction).w,d0
			or.b	d0,(v_bg3_redraw_direction).w
			clr.b	(v_bg1_redraw_direction).w
			clr.b	(v_bg2_redraw_direction).w

		; calculate background scroll buffer
			lea	(v_bgscroll_buffer).w,a1
			move.w	(v_camera_x_pos).w,d2
			neg.w	d2
			move.w	d2,d0
			asr.w	#2,d0
			sub.w	d2,d0
			ext.l	d0
			asl.l	#3,d0
			divs.w	#5,d0
			ext.l	d0
			asl.l	#4,d0
			asl.l	#8,d0
			moveq	#0,d3
			move.w	d2,d3
			asr.w	#1,d3
			move.w	#4,d1
	.cloudLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,.cloudLoop

			move.w	(v_bg3_x_pos).w,d0
			neg.w	d0
			move.w	#1,d1
	.mountainLoop:		
			move.w	d0,(a1)+
			dbf	d1,.mountainLoop

			move.w	(v_bg2_x_pos).w,d0
			neg.w	d0
			move.w	#8,d1
	.bushLoop:		
			move.w	d0,(a1)+
			dbf	d1,.bushLoop

			move.w	(v_bg1_x_pos).w,d0
			neg.w	d0
			move.w	#$F,d1
	.interiorLoop:		
			move.w	d0,(a1)+
			dbf	d1,.interiorLoop

			lea	(v_bgscroll_buffer).w,a2
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#512,d0				; subtract 512px (unused 2 chunks)
			move.w	d0,d2
			cmpi.w	#$100,d0
			bcs.s	.limitY
			move.w	#$100,d0
	.limitY:
			andi.w	#$1F0,d0
			lsr.w	#3,d0
			lea	(a2,d0.w),a2
			bra.w	UpdateHscrollBuffer

		endc

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

Deform_SLZ:
		if Revision=0
			move.w	(v_camera_x_diff).w,d4
			ext.l	d4
			asl.l	#7,d4
			move.w	(v_camera_y_diff).w,d5
			ext.l	d5
			asl.l	#7,d5
			bsr.w	UpdateBG_Y2
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
			bsr.w	Deform_SLZ_2
		else
		; vertical scrolling
			move.w	(v_camera_y_diff).w,d5
			ext.l	d5
			asl.l	#7,d5
			bsr.w	UpdateBG_Y2
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
		endc

include_Deform_SLZ_2:	macro
Deform_SLZ_2:
		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#28-1,d1
	.starLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.starLoop

		move.w	d2,d0
		asr.w	#3,d0
		if Revision=0
		else
			move.w	d0,d1
			asr.w	#1,d1
			add.w	d1,d0
		endc
		move.w	#4,d1
	.buildingLoop1:						; distant black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
	.buildingLoop2:						; closer buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	d2,d0
		asr.w	#1,d0
		move.w	#30-1,d1
	.bottomLoop:						; bottom part of background
		move.w	d0,(a1)+
		dbf	d1,.bottomLoop
		endm

		if Revision=0
		else
			include_Deform_SLZ_2
		endc

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2					; d2 = v_bg1_y_pos
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0					; d0 = (v_bg1_y_pos-$C0)/8
		lea	(a2,d0.w),a2				; jump to relevant part of bg scroll buffer

; ---------------------------------------------------------------------------
; Subroutine to update the hscroll buffer with contents of bg scroll buffer
; and camera x position

; input:
;	d2 = background y position
;	a2 = address of bg scroll buffer

;	uses d0, d1, d2, a1, a2
; ---------------------------------------------------------------------------

UpdateHscrollBuffer:
		lea	(v_hscroll_buffer).w,a1
		move.w	#$E,d1
		move.w	(v_camera_x_pos).w,d0			; get camera x pos
		neg.w	d0					; make negative
		swap	d0					; move to high word
		andi.w	#$F,d2					; read low nybble of bg y pos
		add.w	d2,d2					; multiply by 2
		move.w	(a2)+,d0				; get 1st value from bg scroll buffer
		jmp	.skip_rows(pc,d2.w)			; skip rows that are off screen
	.loop_hscroll:
		move.w	(a2)+,d0				; get subsequent value from bg scroll buffer
	.skip_rows:
		rept 16
		move.l	d0,(a1)+				; write 16 fg/bg values to v_hscroll_buffer
		endr
		dbf	d1,.loop_hscroll
		rts

		if Revision=0
			include_Deform_SLZ_2
			rts
		else
		endc

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

Deform_SYZ:
		; vertical scrolling
		if Revision=0
			move.w	(v_camera_x_diff).w,d4		; get camera x pos change since last frame
			ext.l	d4
			asl.l	#6,d4				; multiply by $40
		else
		endc
		move.w	(v_camera_y_diff).w,d5			; get camera y pos change since last frame
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5					; multiply by $30
		if Revision=0
			bsr.w	UpdateBG_XY
		else
			bsr.w	UpdateBG_Y2
		endc
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		; calculate background scroll buffer
		if Revision=0
			lea	(v_hscroll_buffer).w,a1
			move.w	#223,d1
			move.w	(v_camera_x_pos).w,d0
			neg.w	d0
			swap	d0
			move.w	(v_bg1_x_pos).w,d0
			neg.w	d0

	.loop_hscroll:
			move.l	d0,(a1)+
			dbf	d1,.loop_hscroll
			rts
		else
			lea	(v_bgscroll_buffer).w,a1
			move.w	(v_camera_x_pos).w,d2
			neg.w	d2
			move.w	d2,d0
			asr.w	#3,d0
			sub.w	d2,d0
			ext.l	d0
			asl.l	#3,d0
			divs.w	#8,d0
			ext.l	d0
			asl.l	#4,d0
			asl.l	#8,d0
			moveq	#0,d3
			move.w	d2,d3
			asr.w	#1,d3
			move.w	#7,d1
	.cloudLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,.cloudLoop

			move.w	d2,d0
			asr.w	#3,d0
			move.w	#4,d1
	.mountainLoop:		
			move.w	d0,(a1)+
			dbf	d1,.mountainLoop

			move.w	d2,d0
			asr.w	#2,d0
			move.w	#5,d1
	.buildingLoop:		
			move.w	d0,(a1)+
			dbf	d1,.buildingLoop

			move.w	d2,d0
			move.w	d2,d1
			asr.w	#1,d1
			sub.w	d1,d0
			ext.l	d0
			asl.l	#4,d0
			divs.w	#$E,d0
			ext.l	d0
			asl.l	#4,d0
			asl.l	#8,d0
			moveq	#0,d3
			move.w	d2,d3
			asr.w	#1,d3
			move.w	#$D,d1
	.bushLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,.bushLoop

			lea	(v_bgscroll_buffer).w,a2
			move.w	(v_bg1_y_pos).w,d0
			move.w	d0,d2
			andi.w	#$1F0,d0
			lsr.w	#3,d0
			lea	(a2,d0.w),a2
			bra.w	UpdateHscrollBuffer
		endc

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

Deform_SBZ:
		if Revision=0
		else
; REV01 - different scrolling for act 1

		tst.b	(v_act).w				; is this act 1?
		bne.w	Deform_SBZ2				; if not, branch

		; block 1 - lower black buildings
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#redraw_left_bit,d6
		bsr.w	UpdateBG_X_Block1

		; block 3 - distant brown buildings
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4					; multiply by $40
		moveq	#6,d6
		bsr.w	UpdateBG_X_Block3

		; block 2 - upper black buildings
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#redraw_topall_bit,d6
		bsr.w	UpdateBG_X_Block2

		; vertical scrolling
		moveq	#0,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	UpdateBG_Y

		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,(v_bg2_y_pos).w
		move.w	d0,(v_bg3_y_pos).w
		move.w	d0,(v_bg_y_pos_vsram).w
		move.b	(v_bg1_redraw_direction).w,d0
		or.b	(v_bg3_redraw_direction).w,d0
		or.b	d0,(v_bg2_redraw_direction).w
		clr.b	(v_bg1_redraw_direction).w
		clr.b	(v_bg3_redraw_direction).w

		; calculate background scroll buffer
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_camera_x_pos).w,d2
		neg.w	d2
		asr.w	#2,d2
		move.w	d2,d0
		asr.w	#1,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#4,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#3,d1
	.cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#9,d1
	.buildingLoop1:						; distant brown buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
		move.w	#6,d1
	.buildingLoop2:						; upper black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		move.w	#$A,d1
	.buildingLoop3:						; lower black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop3
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	UpdateHscrollBuffer

		endc
;-------------------------------------------------------------------------------
Deform_SBZ2:
		; plain background deformation
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4		
		asl.l	#6,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		if Revision=0
			asl.l	#4,d5
			asl.l	#1,d5
		else
			asl.l	#5,d5
		endc
		bsr.w	UpdateBG_XY
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		; copy fg & bg x position to hscroll table
		lea	(v_hscroll_buffer).w,a1
		move.w	#223,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
	.loop_hscroll:		
		move.l	d0,(a1)+
		dbf	d1,.loop_hscroll
		rts

; ---------------------------------------------------------------------------
; Subroutine to	update camera and redraw flags as Sonic moves horizontally

;	uses d0, d1, d4
; ---------------------------------------------------------------------------

UpdateCamera_X:
		move.w	(v_camera_x_pos).w,d4			; save old screen position
		bsr.s	UCX_Camera
		move.w	(v_camera_x_pos).w,d0
		andi.w	#$10,d0
		move.b	(v_fg_x_redraw_flag).w,d1
		eor.b	d1,d0
		bne.s	.return
		eori.b	#$10,(v_fg_x_redraw_flag).w
		move.w	(v_camera_x_pos).w,d0
		sub.w	d4,d0					; compare new with old screen position
		bpl.s	.scrollRight

		bset	#redraw_left_bit,(v_fg_redraw_direction).w ; screen moves backward
		rts	

	.scrollRight:
		bset	#redraw_right_bit,(v_fg_redraw_direction).w ; screen moves forward

	.return:
		rts
; ===========================================================================

UCX_Camera:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	(v_camera_x_pos).w,d0			; d0 = Sonic's distance from left edge of screen
		subi.w	#144,d0					; is distance less than 144px?
		bcs.s	UCX_BehindMid				; if yes, branch
		subi.w	#16,d0					; is distance more than 160px?
		bcc.s	UCX_AheadOfMid				; if yes, branch
		clr.w	(v_camera_x_diff).w			; no camera movement
		rts	
; ===========================================================================

UCX_AheadOfMid:
		cmpi.w	#16,d0					; is Sonic within 16px of middle area?
		bcs.s	.within_16				; if yes, branch
		move.w	#16,d0					; set to 16 if greater

	.within_16:
		add.w	(v_camera_x_pos).w,d0			; d0 = new camera x pos
		cmp.w	(v_boundary_right).w,d0			; is camera within boundary?
		blt.s	UCX_SetScreen				; if yes, branch
		move.w	(v_boundary_right).w,d0			; stop camera moving outside boundary

UCX_SetScreen:
		move.w	d0,d1
		sub.w	(v_camera_x_pos).w,d1			; d1 = difference since last camera x pos
		asl.w	#8,d1					; move into high byte (multiply by $100)
		move.w	d0,(v_camera_x_pos).w			; set new screen position
		move.w	d1,(v_camera_x_diff).w			; set distance for camera movement
		rts	
; ===========================================================================

UCX_BehindMid:
		add.w	(v_camera_x_pos).w,d0			; d0 = new camera x pos
		cmp.w	(v_boundary_left).w,d0			; is camera within boundary?
		bgt.s	UCX_SetScreen				; if yes, branch
		move.w	(v_boundary_left).w,d0			; stop camera moving outside boundary
		bra.s	UCX_SetScreen

; ---------------------------------------------------------------------------
; Unused subroutine to scroll the level horizontally at a fixed rate

;	uses d0
; ---------------------------------------------------------------------------

AutoScroll:
		tst.w	d0
		bpl.s	.forwards
		move.w	#-2,d0
		bra.s	UCX_BehindMid

	.forwards:
		move.w	#2,d0
		bra.s	UCX_AheadOfMid

; ---------------------------------------------------------------------------
; Subroutine to	update camera and redraw flags as Sonic moves vertically

;	uses d0, d1, d3, d4
; ---------------------------------------------------------------------------

UpdateCamera_Y:
		moveq	#0,d1
		move.w	(v_ost_player+ost_y_pos).w,d0
		sub.w	(v_camera_y_pos).w,d0			; d0 = Sonic's distance from top of screen
		btst	#status_jump_bit,(v_ost_player+ost_status).w ; is Sonic jumping/rolling?
		beq.s	.not_rolling				; if not, branch
		subq.w	#5,d0

	.not_rolling:
		btst	#status_air_bit,(v_ost_player+ost_status).w ; is Sonic in the air?
		beq.s	.ground					; if not, branch

		addi.w	#32,d0					; pretend Sonic is 32px lower
		sub.w	(v_camera_y_shift).w,d0			; is Sonic within 96px of top of screen? (or other value if looked up/down recenly)
		bcs.s	UCY_OutsideMid_Air			; if yes, branch
		subi.w	#64,d0					; is distance more than 160px?
		bcc.s	UCY_OutsideMid_Air			; if yes, branch
		tst.b	(f_boundary_bottom_change).w		; is bottom level boundary set to change?
		bne.s	UCY_BoundaryChange			; if yes, branch
		bra.s	.no_change
; ===========================================================================

.ground:
		sub.w	(v_camera_y_shift).w,d0			; is Sonic exactly 96px from top of screen?
		bne.s	UCY_OutsideMid_Ground			; if not, branch
		tst.b	(f_boundary_bottom_change).w		; is bottom level boundary set to change?
		bne.s	UCY_BoundaryChange

.no_change:
		clr.w	(v_camera_y_diff).w			; no camera movement
		rts	
; ===========================================================================

UCY_OutsideMid_Ground:
		cmpi.w	#camera_y_shift_default,(v_camera_y_shift).w ; has Sonic looked up/down recently? (default y shift is 96)
		bne.s	.y_shift_different			; if yes, branch

		move.w	(v_ost_player+ost_inertia).w,d1		; get Sonic's inertia
		bpl.s	.inertia_positive			; branch if positive
		neg.w	d1					; make it positive

	.inertia_positive:
		cmpi.w	#$800,d1
		bcc.s	UCY_OutsideMid_Air			; branch if inertia >= $800
		move.w	#$600,d1
		cmpi.w	#6,d0					; is Sonic more than 6px below middle area?
		bgt.s	UCY_BelowMid				; if yes, branch
		cmpi.w	#-6,d0					; is Sonic more than 6px above middle area?
		blt.s	UCY_AboveMid				; if yes, branch
		bra.s	UCY_InsideMid
; ===========================================================================

.y_shift_different:
		move.w	#$200,d1
		cmpi.w	#2,d0					; is Sonic more than 2px below middle area?
		bgt.s	UCY_BelowMid				; if yes, branch
		cmpi.w	#-2,d0					; is Sonic more than 2px above middle area?
		blt.s	UCY_AboveMid				; if yes, branch
		bra.s	UCY_InsideMid
; ===========================================================================

UCY_OutsideMid_Air:
		move.w	#$1000,d1
		cmpi.w	#16,d0					; is Sonic more than 16px below middle area?
		bgt.s	UCY_BelowMid				; if yes, branch
		cmpi.w	#-16,d0					; is Sonic more than 16px above middle area?
		blt.s	UCY_AboveMid				; if yes, branch
		bra.s	UCY_InsideMid
; ===========================================================================

UCY_BoundaryChange:
		moveq	#0,d0
		move.b	d0,(f_boundary_bottom_change).w		; clear boundary change flag

UCY_InsideMid:
		moveq	#0,d1
		move.w	d0,d1					; d0/d1 = Sonic's distance from middle area
		add.w	(v_camera_y_pos).w,d1			; add camera y pos to d1
		tst.w	d0					; is Sonic below middle?
		bpl.w	UCY_BelowMid_Short			; if yes, branch
		bra.w	UCY_AboveMid_Short
; ===========================================================================

UCY_AboveMid:
		neg.w	d1					; d1 = -$200/-$600/-$1000
		ext.l	d1					; convert to longword
		asl.l	#8,d1					; d1 = -$20000/-$60000/-$100000
		add.l	(v_camera_y_pos).w,d1			; add v_camera_y_pos
		swap	d1					; d1 = v_camera_y_pos minus 2/6/$10 in low word

UCY_AboveMid_Short:
		cmp.w	(v_boundary_top).w,d1			; is camera within top boundary?
		bgt.s	UCY_SetScreen				; if yes, branch
		cmpi.w	#-$100,d1				; is camera no more than 255px outside boundary?
		bgt.s	.just_outside				; if yes, branch

		andi.w	#$7FF,d1				; clear high bits for levels that wrap vertically
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		andi.w	#$7FF,(v_camera_y_pos).w
		andi.w	#$3FF,(v_bg1_y_pos).w
		bra.s	UCY_SetScreen
; ===========================================================================

.just_outside:
		move.w	(v_boundary_top).w,d1
		bra.s	UCY_SetScreen
; ===========================================================================

UCY_BelowMid:
		ext.l	d1
		asl.l	#8,d1					; d1 = $20000/$60000/$100000
		add.l	(v_camera_y_pos).w,d1			; add v_camera_y_pos
		swap	d1					; d1 = v_camera_y_pos plus 2/6/$10 in low word

UCY_BelowMid_Short:
		cmp.w	(v_boundary_bottom).w,d1		; is camera within bottom boundary?
		blt.s	UCY_SetScreen				; if yes, branch
		subi.w	#$800,d1
		bcs.s	.just_outside
		andi.w	#$7FF,(v_ost_player+ost_y_pos).w
		subi.w	#$800,(v_camera_y_pos).w
		andi.w	#$3FF,(v_bg1_y_pos).w
		bra.s	UCY_SetScreen
; ===========================================================================

.just_outside:
		move.w	(v_boundary_bottom).w,d1

UCY_SetScreen:
		move.w	(v_camera_y_pos).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(v_camera_y_pos).w,d3			; d3 = difference since last camera y pos
		ror.l	#8,d3
		move.w	d3,(v_camera_y_diff).w			; set distance for camera movement
		move.l	d1,(v_camera_y_pos).w			; set new screen position
		move.w	(v_camera_y_pos).w,d0
		andi.w	#$10,d0
		move.b	(v_fg_y_redraw_flag).w,d1
		eor.b	d1,d0
		bne.s	.return
		eori.b	#$10,(v_fg_y_redraw_flag).w
		move.w	(v_camera_y_pos).w,d0
		sub.w	d4,d0
		bpl.s	.scrollBottom
		bset	#redraw_top_bit,(v_fg_redraw_direction).w
		rts	
; ===========================================================================

	.scrollBottom:
		bset	#redraw_bottom_bit,(v_fg_redraw_direction).w

	.return:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	update bg position and redraw flags

; input:
;	d4 = background x diff
;	d5 = background y diff

;	uses d0, d1, d2, d3
; ---------------------------------------------------------------------------

UpdateBG_XY:
		move.l	(v_bg1_x_pos).w,d2
		move.l	d2,d0					; save old bg position
		add.l	d4,d0					; apply difference
		move.l	d0,(v_bg1_x_pos).w			; update bg position
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	.no_redraw_x				; insufficient change to redraw bg
		eori.b	#$10,(v_bg1_x_redraw_flag).w
		sub.l	d2,d0					; new bg pos minus old
		bpl.s	.redraw_right				; branch if positive (i.e. moving right)
		bset	#redraw_left_bit,(v_bg1_redraw_direction).w
		bra.s	.next
	.redraw_right:
		bset	#redraw_right_bit,(v_bg1_redraw_direction).w
	.no_redraw_x:
	.next:
UpdateBG_Y:
		move.l	(v_bg1_y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bg1_y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.l	d3,d0
		bpl.s	.redraw_bottom
		bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		rts
	.redraw_bottom:
		bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
	.return:
		rts
; ===========================================================================

UpdateBG_Y2:
		if revision=0
			move.l	(v_bg1_x_pos).w,d2
			move.l	d2,d0
			add.l	d4,d0
			move.l	d0,(v_bg1_x_pos).w
		endc
		move.l	(v_bg1_y_pos).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bg1_y_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.l	d3,d0
		bpl.s	.redraw_bottom
		if revision=0
			bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		else
			bset	#redraw_topall_bit,(v_bg1_redraw_direction).w
		endc
		rts
	.redraw_bottom:
		if revision=0
			bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
		else
			bset	#redraw_bottomall_bit,(v_bg1_redraw_direction).w
		endc
	.return:
		rts

; ---------------------------------------------------------------------------
; Subroutine to	update bg y position and redraw flags

; input:
;	d0 = new background y position

;	uses d0, d1, d2, d3
; ---------------------------------------------------------------------------

UpdateBG_Y_Absolute:
		move.w	(v_bg1_y_pos).w,d3			; save old bg position
		move.w	d0,(v_bg1_y_pos).w			; update bg position
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(v_bg1_y_redraw_flag).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_y_redraw_flag).w
		sub.w	d3,d0
		bpl.s	.redraw_bottom
		bset	#redraw_top_bit,(v_bg1_redraw_direction).w
		rts
	.redraw_bottom:
		bset	#redraw_bottom_bit,(v_bg1_redraw_direction).w
	.return:
		rts

; ---------------------------------------------------------------------------
; Subroutine to update bg position and redraw flags for bg block 2 in GHZ

;	uses d0, d1, d2, d3
; ---------------------------------------------------------------------------

		if Revision=0
UpdateBG_X_Block2_GHZ:
		move.w	(v_bg2_x_pos).w,d2			; get bg position
		move.w	(v_bg2_y_pos).w,d3
		move.w	(v_camera_x_diff).w,d0			; get camera x diff
		ext.l	d0
		asl.l	#7,d0					; multiply by $80
		add.l	d0,(v_bg2_x_pos).w			; update bg position
		move.w	(v_bg2_x_pos).w,d0
		andi.w	#$10,d0
		move.b	(v_bg2_x_redraw_flag).w,d1
		eor.b	d1,d0
		bne.s	.no_redraw_x				; insufficient change to redraw bg
		eori.b	#$10,(v_bg2_x_redraw_flag).w
		move.w	(v_bg2_x_pos).w,d0
		sub.w	d2,d0					; new bg pos minus old
		bpl.s	.redraw_right				; branch if positive (i.e. moving right)
		bset	#redraw_left_bit,(v_bg2_redraw_direction).w
		bra.s	.next
	.redraw_right:
		bset	#redraw_right_bit,(v_bg2_redraw_direction).w
	.no_redraw_x:
	.next:
		rts
		endc

; ---------------------------------------------------------------------------
; Subroutines to update bg position and redraw flags for bg blocks 1, 2 and 3

; input:
;	d4 = background x diff
;	d6 = bit to set for redraw direction

;	uses d0, d1, d2, d3, d6
; ---------------------------------------------------------------------------

		if Revision=0
		else
UpdateBG_X_Block1:
		move.l	(v_bg1_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg1_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg1_redraw_direction).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg1_redraw_direction).w
	.return:
		rts

UpdateBG_X_Block2:
		move.l	(v_bg2_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg2_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg2_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg2_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg2_redraw_direction).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg2_redraw_direction).w
	.return:
		rts

UpdateBG_X_Block3:
		move.l	(v_bg3_x_pos).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg3_x_pos).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg3_x_redraw_flag).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg3_x_redraw_flag).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg3_redraw_direction).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg3_redraw_direction).w
	.return:
		rts
		endc
