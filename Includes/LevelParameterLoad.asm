; ---------------------------------------------------------------------------
; Subroutine to	load level boundaries and start	locations

;	uses d0, d1, d2, a0, a1, a2
; ---------------------------------------------------------------------------

LevelParameterLoad:
		moveq	#0,d0
		move.b	d0,(v_levelsizeload_unused_1).w		; clear unused variables
		move.b	d0,(v_levelsizeload_unused_2).w
		move.b	d0,(v_levelsizeload_unused_3).w
		move.b	d0,(v_levelsizeload_unused_4).w
		move.b	d0,(v_dle_routine).w			; clear DynamicLevelEvents routine counter
		move.w	(v_zone).w,d0				; get zone/act number
		lsl.b	#6,d0					; move act number next to zone number
		lsr.w	#4,d0					; move both into low byte
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0					; d0 = zone/act id multiplied by 12
		lea	LevelBoundaryList(pc,d0.w),a0		; load level boundaries
		move.w	(a0)+,d0
		move.w	d0,(v_boundary_unused).w		; unused, always 4
		move.l	(a0)+,d0
		move.l	d0,(v_boundary_left).w			; load left & right boundaries (2 bytes each)
		move.l	d0,(v_boundary_left_next).w
		move.l	(a0)+,d0
		move.l	d0,(v_boundary_top).w			; load top & bottom boundaries (2 bytes each)
		move.l	d0,(v_boundary_top_next).w
		move.w	(v_boundary_left).w,d0
		addi.w	#$240,d0
		move.w	d0,(v_boundary_left_unused).w		; unused, v_boundary_left+$240
		move.w	#$1010,(v_fg_x_redraw_flag).w		; set fg redraw flag
		move.w	(a0)+,d0
		move.w	d0,(v_camera_y_shift).w			; default camera shift = $60 (changes when Sonic looks up/down)
		bra.w	LPL_StartPos

; ---------------------------------------------------------------------------
; Level boundary list - 6 values per act:

; v_boundary_unused, v_boundary_left, v_boundary_right
; v_boundary_top, v_boundary_bottom, v_camera_y_shift
; ---------------------------------------------------------------------------

LevelBoundaryList:
		; GHZ
		dc.w $0004, $0000, $24BF, $0000, $0300, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0300, $0060
		dc.w $0004, $0000, $2960, $0000, $0300, $0060
		dc.w $0004, $0000, $2ABF, $0000, $0300, $0060
		; LZ
		dc.w $0004, $0000, $19BF, $0000, $0530, $0060
		dc.w $0004, $0000, $10AF, $0000, $0720, $0060
		dc.w $0004, $0000, $202F, $FF00, $0800, $0060
		dc.w $0004, $0000, $20BF, $0000, $0720, $0060
		; MZ
		dc.w $0004, $0000, $17BF, $0000, $01D0, $0060
		dc.w $0004, $0000, $17BF, $0000, $0520, $0060
		dc.w $0004, $0000, $1800, $0000, $0720, $0060
		dc.w $0004, $0000, $16BF, $0000, $0720, $0060
		; SLZ
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $2000, $0000, $06C0, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		; SYZ
		dc.w $0004, $0000, $22C0, $0000, $0420, $0060
		dc.w $0004, $0000, $28C0, $0000, $0520, $0060
		dc.w $0004, $0000, $2C00, $0000, $0620, $0060
		dc.w $0004, $0000, $2EC0, $0000, $0620, $0060
		; SBZ
		dc.w $0004, $0000, $21C0, $0000, $0720, $0060
		dc.w $0004, $0000, $1E40, $FF00, $0800, $0060
		dc.w $0004, $2080, $2460, $0510, $0510, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		zonewarning LevelBoundaryList,$30
		; Ending
		dc.w $0004, $0000, $0500, $0110, $0110, $0060
		dc.w $0004, $0000, $0DC0, $0110, $0110, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060

; ---------------------------------------------------------------------------
; Sonic start position list, ending credits demo
; ---------------------------------------------------------------------------

EndingStartPosList:
		dc.l startpos_ghz1_end1				; GHZ act 1
		dc.l startpos_mz2_end				; MZ act 2
		dc.l startpos_syz3_end				; SYZ act 3
		dc.l startpos_lz3_end				; LZ act 3
		dc.l startpos_slz3_end				; SLZ act 3
		dc.l startpos_sbz1_end				; SBZ act 1
		dc.l startpos_sbz2_end				; SBZ act 2
		dc.l startpos_ghz1_end2				; GHZ act 1
		even

; ===========================================================================

LPL_StartPos:
		tst.b	(v_last_lamppost).w			; have any lampposts been hit?
		beq.s	@no_lamppost				; if not, branch

		jsr	(Lamp_LoadInfo).l			; load lamppost variables
		move.w	(v_ost_player+ost_x_pos).w,d1
		move.w	(v_ost_player+ost_y_pos).w,d0		; d0/d1 = Sonic's position from lamppost variables
		bra.s	LPL_Camera
; ===========================================================================

@no_lamppost:
		move.w	(v_zone).w,d0				; get zone/act number
		lsl.b	#6,d0
		lsr.w	#4,d0					; convert to 1-byte id, multiplied by 4
		lea	StartPosList(pc,d0.w),a1		; load Sonic's start position
		tst.w	(v_demo_mode).w				; is ending demo mode on?
		bpl.s	@no_ending_demo				; if not, branch

		move.w	(v_credits_num).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	EndingStartPosList(pc,d0.w),a1		; load Sonic's start position

	@no_ending_demo:
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(v_ost_player+ost_x_pos).w		; set Sonic's x position
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(v_ost_player+ost_y_pos).w		; set Sonic's y position

LPL_Camera:
		subi.w	#160,d1					; is Sonic more than 160px from left edge?
		bcc.s	@chk_right				; if yes, branch
		moveq	#0,d1

	@chk_right:
		move.w	(v_boundary_right).w,d2
		cmp.w	d2,d1					; is Sonic inside the right edge?
		bcs.s	@set_camera_x				; if yes, branch
		move.w	d2,d1

	@set_camera_x:
		move.w	d1,(v_camera_x_pos).w			; set camera x position

		subi.w	#96,d0					; is Sonic within 96px of upper edge?
		bcc.s	@chk_bottom				; if yes, branch
		moveq	#0,d0

	@chk_bottom:
		cmp.w	(v_boundary_bottom).w,d0		; is Sonic above the bottom edge?
		blt.s	@set_camera_y				; if yes, branch
		move.w	(v_boundary_bottom).w,d0

	@set_camera_y:
		move.w	d0,(v_camera_y_pos).w			; set vertical screen position
		bsr.w	LPL_InitBG
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.b	#2,d0
		move.l	LoopTunnelList(pc,d0.w),(v_256x256_with_loop_1).w ; load level tile ids that contain loops and tunnels
		if Revision=0
			bra.w	LPL_ScrollBlockHeights
		else
			rts
		endc

; ---------------------------------------------------------------------------
; Sonic start position list - each zone has four acts, of which the fourth is
; unused (except LZ4 = SBZ3)
; ---------------------------------------------------------------------------

StartPosList:
		dc.l startpos_ghz1
		dc.l startpos_ghz2
		dc.l startpos_ghz3
		dc.l startpos_unused

		dc.l startpos_lz1
		dc.l startpos_lz2
		dc.l startpos_lz3
		dc.l startpos_sbz3

		dc.l startpos_mz1
		dc.l startpos_mz2
		dc.l startpos_mz3
		dc.l startpos_unused

		dc.l startpos_slz1
		dc.l startpos_slz2
		dc.l startpos_slz3
		dc.l startpos_unused

		dc.l startpos_syz1
		dc.l startpos_syz2
		dc.l startpos_syz3
		dc.l startpos_unused

		dc.l startpos_sbz1
		dc.l startpos_sbz2
		dc.l startpos_fz
		dc.l startpos_unused

		zonewarning StartPosList,$10

		dc.l startpos_ending1				; Ending (extra flowers)
		dc.l startpos_ending2				; Ending
		dc.l startpos_unused
		dc.l startpos_unused
		even

; ---------------------------------------------------------------------------
; Which	256x256	tiles contain loops or roll-tunnels
; ---------------------------------------------------------------------------

LoopTunnelList:
		;	loop	loop	tunnel	tunnel
		dc.b	$B5,	$7F,	$1F,	$20		; Green Hill
		dc.b	$7F,	$7F,	$7F,	$7F		; Labyrinth
		dc.b	$7F,	$7F,	$7F,	$7F		; Marble
		dc.b	$AA,	$B4,	$7F,	$7F		; Star Light
		dc.b	$7F,	$7F,	$7F,	$7F		; Spring Yard
		dc.b	$7F,	$7F,	$7F,	$7F		; Scrap Brain
		zonewarning LoopTunnelList,4
		dc.b	$7F,	$7F,	$7F,	$7F		; Ending (Green Hill)
		even

; ===========================================================================

		if Revision=0
LPL_ScrollBlockHeights:
			moveq	#0,d0
			move.b	(v_zone).w,d0
			lsl.w	#3,d0
			lea	ScrollBlockHeightList(pc,d0.w),a1
			lea	(v_scroll_block_1_height).w,a2
			move.l	(a1)+,(a2)+
			move.l	(a1)+,(a2)+
			rts

ScrollBlockHeightList:
; Only the first value is used
		dc.w $70, $100, $100, $100			; GHZ
		dc.w $800, $100, $100, 0			; LZ
		dc.w $800, $100, $100, 0			; MZ
		dc.w $800, $100, $100, 0			; SLZ
		dc.w $800, $100, $100, 0			; SYZ
		dc.w $800, $100, $100, 0			; SBZ
		zonewarning ScrollBlockHeightList,8
		dc.w $70, $100, $100, $100			; Ending (GHZ)
		
		endc

; ---------------------------------------------------------------------------
; Subroutine to	initialise background position and scrolling

; input:
;	d0 = v_camera_y_pos
;	d1 = v_camera_x_pos

;	uses d0, d1, d2, a2
; ---------------------------------------------------------------------------

LPL_InitBG:
		tst.b	(v_last_lamppost).w			; have any lampposts been hit?
		bne.s	@no_lamppost				; if yes, branch
		move.w	d0,(v_bg1_y_pos).w
		move.w	d0,(v_bg2_y_pos).w
		move.w	d1,(v_bg1_x_pos).w
		move.w	d1,(v_bg2_x_pos).w
		move.w	d1,(v_bg3_x_pos).w			; use same x/y pos for fg and bg

	@no_lamppost:
		moveq	#0,d2
		move.b	(v_zone).w,d2
		add.w	d2,d2
		move.w	LPL_InitBG_Index(pc,d2.w),d2
		jmp	LPL_InitBG_Index(pc,d2.w)

; ===========================================================================
LPL_InitBG_Index:
		index *
		ptr LPL_InitBG_GHZ
		ptr LPL_InitBG_LZ
		ptr LPL_InitBG_MZ
		ptr LPL_InitBG_SLZ
		ptr LPL_InitBG_SYZ
		ptr LPL_InitBG_SBZ
		zonewarning LPL_InitBG_Index,2
		ptr LPL_InitBG_End
; ===========================================================================

LPL_InitBG_GHZ:
		if Revision=0
			bra.w	Deform_GHZ
		else
			clr.l	(v_bg1_x_pos).w
			clr.l	(v_bg1_y_pos).w
			clr.l	(v_bg2_y_pos).w
			clr.l	(v_bg3_y_pos).w
			lea	(v_bgscroll_buffer).w,a2
			clr.l	(a2)+
			clr.l	(a2)+
			clr.l	(a2)+
			rts
		endc
; ===========================================================================

LPL_InitBG_LZ:
		asr.l	#1,d0					; d0 = v_camera_y_pos/2
		move.w	d0,(v_bg1_y_pos).w
		rts	
; ===========================================================================

LPL_InitBG_MZ:
		rts	
; ===========================================================================

LPL_InitBG_SLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0					; d0 = (v_camera_y_pos/2)+$C0
		move.w	d0,(v_bg1_y_pos).w
		if Revision=0
		else
			clr.l	(v_bg1_x_pos).w
		endc
		rts	
; ===========================================================================

LPL_InitBG_SYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0					; d0 = v_camera_y_pos/5 (approx)
		if Revision=0
			move.w	d0,(v_bg1_y_pos).w
			move.w	d0,(v_bg2_y_pos).w
		else
			addq.w	#1,d0
			move.w	d0,(v_bg1_y_pos).w
			clr.l	(v_bg1_x_pos).w
		endc
		rts	
; ===========================================================================

LPL_InitBG_SBZ:
		if Revision=0
			asl.l	#4,d0
			asl.l	#1,d0
			asr.l	#8,d0				; d0 = v_camera_y_pos/8
		else
			andi.w	#$7F8,d0
			asr.w	#3,d0
			addq.w	#1,d0				; d0 = (v_camera_y_pos/8)+1
		endc
		move.w	d0,(v_bg1_y_pos).w
		rts	
; ===========================================================================

LPL_InitBG_End:
		if Revision=0
			move.w	#$1E,(v_bg1_y_pos).w
			move.w	#$1E,(v_bg2_y_pos).w
			rts	

			move.w	#$A8,(v_bg1_x_pos).w
			move.w	#$1E,(v_bg1_y_pos).w
			move.w	#-$40,(v_bg2_x_pos).w
			move.w	#$1E,(v_bg2_y_pos).w
			rts
		else
			move.w	(v_camera_x_pos).w,d0
			asr.w	#1,d0
			move.w	d0,(v_bg1_x_pos).w
			move.w	d0,(v_bg2_x_pos).w
			asr.w	#2,d0
			move.w	d0,d1
			add.w	d0,d0
			add.w	d1,d0
			move.w	d0,(v_bg3_x_pos).w
			clr.l	(v_bg1_y_pos).w
			clr.l	(v_bg2_y_pos).w
			clr.l	(v_bg3_y_pos).w
			lea	(v_bgscroll_buffer).w,a2
			clr.l	(a2)+
			clr.l	(a2)+
			clr.l	(a2)+
			rts
		endc
