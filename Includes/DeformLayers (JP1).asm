; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeformLayers:
		tst.b	(f_disable_scrolling).w			; is scrolling disabled?
		beq.s	@bgscroll				; if not, branch
		rts	
; ===========================================================================

	@bgscroll:
		clr.w	(v_fg_redraw_direction).w		; clear all redraw flags
		clr.w	(v_bg1_redraw_direction).w
		clr.w	(v_bg2_redraw_direction).w
		clr.w	(v_bg3_redraw_direction).w
		bsr.w	ScrollHorizontal			; update camera position & redraw flags
		bsr.w	ScrollVertical
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
; End of function DeformLayers

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	index *
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

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		bsr.w	BGScroll_XY				; update bg x pos and set redraw flags
		bsr.w	ScrollBlock4

		; calculate y position
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_camera_y_pos).w,d0			; get camera pos
		andi.w	#$7FF,d0				; maximum $7FF
		lsr.w	#5,d0					; divide by $20
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,(v_bg2_y_pos).w			; update bg y pos
		move.w	d0,d4
		bsr.w	BGScroll_YAbsolute			; update bg y pos and set redraw flags
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		; clouds and distant mountains
		move.w	#112-1,d1
		sub.w	d4,d1
		move.w	(v_camera_x_pos).w,d0
		cmpi.b	#id_Title,(v_gamemode).w
		bne.s	@not_title
		moveq	#0,d0
	@not_title:
		neg.w	d0
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0

	@loop_clouds:
		move.l	d0,(a1)+
		dbf	d1,@loop_clouds

		else
; REV01 - additional scrolling for clouds

		; block 3 - distant mountains
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#0,d6
		bsr.w	BGScroll_Block3				; update bg x pos and set redraw flags

		; block 2 - hills & waterfalls
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#7,d4					; multiply by $80
		moveq	#0,d6
		bsr.w	BGScroll_Block2				; update bg x pos and set redraw flags

		; calculate Y position
		lea	(v_hscroll_buffer).w,a1
		move.w	(v_camera_y_pos).w,d0			; get camera pos
		andi.w	#$7FF,d0				; maximum $7FF
		lsr.w	#5,d0					; divide by $20
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	@limitY					; branch if v_camera_y_pos is between 0 and $400
		moveq	#0,d0					; use 0 if greater
	@limitY:
		move.w	d0,d4
		move.w	d0,(v_bg_y_pos_vsram).w			; update bg y pos
		move.w	(v_camera_x_pos).w,d0
		cmpi.b	#id_Title,(v_gamemode).w		; is this the title screen?
		bne.s	@notTitle				; if not, branch
		moveq	#0,d0					; reset camera position for title screen
	@notTitle:
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
		bcs.s	@gotoCloud2
	@cloudLoop1:						; upper cloud (32px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,@cloudLoop1

	@gotoCloud2:
		move.w	(v_bgscroll_buffer+4).w,d0		; get autoscroll position of middle cloud
		add.w	(v_bg3_x_pos).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	@cloudLoop2:						; middle cloud (16px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,@cloudLoop2

		move.w	(v_bgscroll_buffer+8).w,d0		; get autoscroll position of lower cloud
		add.w	(v_bg3_x_pos).w,d0			; add current bg position
		neg.w	d0					; reverse
		move.w	#16-1,d1
	@cloudLoop3:						; lower cloud (16px)
		move.l	d0,(a1)+				; write to v_hscroll_buffer
		dbf	d1,@cloudLoop3

		; mountains
		move.w	#48-1,d1
		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
	@mountainLoop:						; distant mountains (48px)
		move.l	d0,(a1)+
		dbf	d1,@mountainLoop

		endc

		; hills and waterfalls
		move.w	#40-1,d1
		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
	@hillLoop:						; hills & waterfalls (40px)
		move.l	d0,(a1)+
		dbf	d1,@hillLoop

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
	@waterLoop:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,@waterLoop
		rts
; End of function Deform_GHZ

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_LZ:
		; plain background scroll
		move.w	(v_camera_x_diff).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_XY

		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		if Revision=0
		else
; REV01 - additional water ripple effects

			lea	(Lz_Scroll_Data).l,a3		; get foreground wobble data
			lea	(Drown_WobbleData).l,a2		; get background wobble data
			move.b	(v_water_ripple_y_pos).w,d2	; get high byte of y pos. of wobble effect
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
	@loop_hscroll:
			move.l	d0,(a1)+			; write to v_hscroll_buffer
			dbf	d1,@loop_hscroll
			move.w	(v_water_height_actual).w,d0
			sub.w	(v_camera_y_pos).w,d0
			rts

		else
; REV01 - additional water ripple effects

			move.w	(v_water_height_actual).w,d4
			move.w	(v_camera_y_pos).w,d5

		; write normal scroll before meeting water position
	@normalLoop:		
			cmp.w	d4,d5				; is current scanline at or below actual water y pos?
			bge.s	@underwaterLoop			; if yes, branch
			move.l	d0,(a1)+			; write to v_hscroll_buffer without ripple effect
			addq.w	#1,d5				; next scanline
			addq.b	#1,d2
			addq.b	#1,d3
			dbf	d1,@normalLoop
			rts

		; apply ripple effects when underwater
	@underwaterLoop:
			move.b	(a3,d3),d4			; get fg ripple value from Lz_Scroll_Data
			ext.w	d4
			add.w	d6,d4
			move.w	d4,(a1)+			; write to v_hscroll_buffer
			move.b	(a2,d2),d4			; get bg ripple value from Drown_WobbleData
			ext.w	d4
			add.w	d0,d4
			move.w	d4,(a1)+			; write to v_hscroll_buffer
			addq.b	#1,d2
			addq.b	#1,d3
			dbf	d1,@underwaterLoop
			rts

Lz_Scroll_Data:
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; End of function Deform_LZ

		endc

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
			bsr.w	BGScroll_XY
		else
			moveq	#redraw_bottom,d6
			bsr.w	BGScroll_Block1

		; block 3 - mountains
			move.w	(v_camera_x_diff).w,d4		; get camera x pos change since last frame
			ext.l	d4
			asl.l	#6,d4				; multiply by $40
			moveq	#redraw_bottom+redraw_left,d6
			bsr.w	BGScroll_Block3

		; block 2 - bushes & antique buildings
			move.w	(v_camera_x_diff).w,d4		; get camera x pos change since last frame
			ext.l	d4
			asl.l	#7,d4				; multiply by $80
			moveq	#redraw_left,d6
			bsr.w	BGScroll_Block2

		endc

		; calculate y position
		move.w	#512,d0					; start with 512px, ignoring 2 chunks
		move.w	(v_camera_y_pos).w,d1
		subi.w	#456,d1
		bcs.s	@noYscroll				; branch if v_camera_y_pos < 456
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0					; d0 = 512+((v_camera_y_pos-456)*0.75) = (v_camera_y_pos*0.75)+170
	@noYscroll:
		move.w	d0,(v_bg2_y_pos).w
		if Revision=0
		else
			move.w	d0,(v_bg3_y_pos).w
		endc
		bsr.w	BGScroll_YAbsolute
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		if Revision=0
			lea	(v_hscroll_buffer).w,a1
			move.w	#223,d1
			move.w	(v_camera_x_pos).w,d0
			neg.w	d0
			swap	d0
			move.w	(v_bg1_x_pos).w,d0
			neg.w	d0

	@loop_hscroll:
			move.l	d0,(a1)+
			dbf	d1,@loop_hscroll
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
	@cloudLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,@cloudLoop

			move.w	(v_bg3_x_pos).w,d0
			neg.w	d0
			move.w	#1,d1
	@mountainLoop:		
			move.w	d0,(a1)+
			dbf	d1,@mountainLoop

			move.w	(v_bg2_x_pos).w,d0
			neg.w	d0
			move.w	#8,d1
	@bushLoop:		
			move.w	d0,(a1)+
			dbf	d1,@bushLoop

			move.w	(v_bg1_x_pos).w,d0
			neg.w	d0
			move.w	#$F,d1
	@interiorLoop:		
			move.w	d0,(a1)+
			dbf	d1,@interiorLoop

			lea	(v_bgscroll_buffer).w,a2
			move.w	(v_bg1_y_pos).w,d0
			subi.w	#512,d0				; subtract 512px (unused 2 chunks)
			move.w	d0,d2
			cmpi.w	#$100,d0
			bcs.s	@limitY
			move.w	#$100,d0
	@limitY:
			andi.w	#$1F0,d0
			lsr.w	#3,d0
			lea	(a2,d0),a2
			bra.w	Bg_Scroll_X

		endc
; End of function Deform_MZ

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ:
		if Revision=0
			move.w	(v_camera_x_diff).w,d4
			ext.l	d4
			asl.l	#7,d4
			move.w	(v_camera_y_diff).w,d5
			ext.l	d5
			asl.l	#7,d5
			bsr.w	Bg_Scroll_Y
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
			bsr.w	Deform_SLZ_2
		else
		; vertical scrolling
			move.w	(v_camera_y_diff).w,d5
			ext.l	d5
			asl.l	#7,d5
			bsr.w	Bg_Scroll_Y
			move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w
		endc

Deform_SLZ_2_m:	macro
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
	@starLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@starLoop

		move.w	d2,d0
		asr.w	#3,d0
		if Revision=0
		else
			move.w	d0,d1
			asr.w	#1,d1
			add.w	d1,d0
		endc
		move.w	#4,d1
	@buildingLoop1:						; distant black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop1

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
	@buildingLoop2:						; closer buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop2

		move.w	d2,d0
		asr.w	#1,d0
		move.w	#30-1,d1
	@bottomLoop:						; bottom part of background
		move.w	d0,(a1)+
		dbf	d1,@bottomLoop
		endm

		if Revision=0
		else
			Deform_SLZ_2_m
		endc

		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2

Bg_Scroll_X:
		lea	(v_hscroll_buffer).w,a1
		move.w	#$E,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	@pixelJump(pc,d2.w)			; skip pixels for first row
	@blockLoop:
		move.w	(a2)+,d0
	@pixelJump:		
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,@blockLoop
		rts

		if Revision=0
			Deform_SLZ_2_m
			rts
		else
		endc

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
			bsr.w	BGScroll_XY
		else
			bsr.w	Bg_Scroll_Y
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

	@loop_hscroll:
			move.l	d0,(a1)+
			dbf	d1,@loop_hscroll
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
	@cloudLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,@cloudLoop

			move.w	d2,d0
			asr.w	#3,d0
			move.w	#4,d1
	@mountainLoop:		
			move.w	d0,(a1)+
			dbf	d1,@mountainLoop

			move.w	d2,d0
			asr.w	#2,d0
			move.w	#5,d1
	@buildingLoop:		
			move.w	d0,(a1)+
			dbf	d1,@buildingLoop

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
	@bushLoop:		
			move.w	d3,(a1)+
			swap	d3
			add.l	d0,d3
			swap	d3
			dbf	d1,@bushLoop

			lea	(v_bgscroll_buffer).w,a2
			move.w	(v_bg1_y_pos).w,d0
			move.w	d0,d2
			andi.w	#$1F0,d0
			lsr.w	#3,d0
			lea	(a2,d0),a2
			bra.w	Bg_Scroll_X
		endc
; End of function Deform_SYZ

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


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
		moveq	#redraw_bottom,d6
		bsr.w	BGScroll_Block1

		; block 3 - distant brown buildings
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#6,d4					; multiply by $40
		moveq	#redraw_bottom+redraw_left,d6
		bsr.w	BGScroll_Block3

		; block 2 - upper black buildings
		move.w	(v_camera_x_diff).w,d4			; get camera x pos change since last frame
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4					; multiply by $60
		moveq	#redraw_left,d6
		bsr.w	BGScroll_Block2

		; vertical scrolling
		moveq	#0,d4
		move.w	(v_camera_y_diff).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_YRelative

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
	@cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,@cloudLoop

		move.w	(v_bg3_x_pos).w,d0
		neg.w	d0
		move.w	#9,d1
	@buildingLoop1:						; distant brown buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop1

		move.w	(v_bg2_x_pos).w,d0
		neg.w	d0
		move.w	#6,d1
	@buildingLoop2:						; upper black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop2

		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
		move.w	#$A,d1
	@buildingLoop3:						; lower black buildings
		move.w	d0,(a1)+
		dbf	d1,@buildingLoop3
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bg1_y_pos).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X

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
		bsr.w	BGScroll_XY
		move.w	(v_bg1_y_pos).w,(v_bg_y_pos_vsram).w

		; copy fg & bg x position to hscroll table
		lea	(v_hscroll_buffer).w,a1
		move.w	#223,d1
		move.w	(v_camera_x_pos).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bg1_x_pos).w,d0
		neg.w	d0
	@loop_hscroll:		
		move.l	d0,(a1)+
		dbf	d1,@loop_hscroll
		rts
; End of function Deform_SBZ
