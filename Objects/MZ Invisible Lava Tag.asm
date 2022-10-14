; ---------------------------------------------------------------------------
; Object 54 - invisible	lava tag (MZ)

; spawned by:
;	ObjPos_MZ1, ObjPos_MZ2, ObjPos_MZ3 - subtypes 0/1/2
; ---------------------------------------------------------------------------

LavaTag:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	LTag_Index(pc,d0.w),d1
		jmp	LTag_Index(pc,d1.w)
; ===========================================================================
LTag_Index:	index offset(*),,2
		ptr LTag_Main
		ptr LTag_ChkDel

LTag_ColTypes:	dc.b id_col_32x32+id_col_hurt			; 0
		dc.b id_col_64x32+id_col_hurt			; 1
		dc.b id_col_128x32+id_col_hurt			; 2
		even
; ===========================================================================

LTag_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto LTag_ChkDel next
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.b	LTag_ColTypes(pc,d0.w),ost_col_type(a0)	; get collision setting based on subtype
		move.l	#Map_LTag,ost_mappings(a0)
		move.b	#render_onscreen+render_rel,ost_render(a0)

LTag_ChkDel:	; Routine 2
		move.w	ost_x_pos(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_camera_x_pos).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts	
