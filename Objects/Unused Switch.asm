; ---------------------------------------------------------------------------
; Object 1D - switch that activates when Sonic touches it
; (this	is not used anywhere in	the game)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Swi_Index(pc,d0.w),d1
		jmp	Swi_Index(pc,d1.w)
; ===========================================================================
Swi_Index:	index *,,2
		ptr Swi_Main
		ptr Swi_Action
		ptr Swi_Delete

swi_origY:	equ $30		; original y-axis position
; ===========================================================================

Swi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Swi,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	ost_y_pos(a0),swi_origY(a0) ; save position on y-axis
		move.b	#$10,ost_actwidth(a0)
		move.b	#5,ost_priority(a0)

Swi_Action:	; Routine 2
		move.w	swi_origY(a0),ost_y_pos(a0) ; restore position on y-axis
		move.w	#$10,d1
		bsr.w	Swi_ChkTouch	; check if Sonic touches the switch
		beq.s	Swi_ChkDel	; if not, branch

		addq.w	#2,ost_y_pos(a0)	; move object 2	pixels
		moveq	#1,d0
		move.w	d0,(f_switch).w	; set switch 0 as "pressed"

Swi_ChkDel:
		bsr.w	DisplaySprite
		out_of_range	Swi_Delete
		rts	
; ===========================================================================

Swi_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	check if Sonic touches the object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swi_ChkTouch:
		lea	(v_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	Swi_NoTouch
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	Swi_NoTouch
		move.w	ost_y_pos(a1),d2
		move.b	ost_height(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	ost_y_pos(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	Swi_NoTouch
		cmpi.w	#-$10,d0
		bcs.s	Swi_NoTouch
		moveq	#-1,d0		; Sonic has touched it
		rts	
; ===========================================================================

Swi_NoTouch:
		moveq	#0,d0		; Sonic hasn't touched it
		rts	
; End of function Swi_ChkTouch
