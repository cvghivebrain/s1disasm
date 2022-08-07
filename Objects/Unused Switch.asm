; ---------------------------------------------------------------------------
; Object 1D - switch that activates when Sonic touches it
; (this	is not used anywhere in	the game)
; ---------------------------------------------------------------------------

MagicSwitch:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Swi_Index(pc,d0.w),d1
		jmp	Swi_Index(pc,d1.w)
; ===========================================================================
Swi_Index:	index *,,2
		ptr Swi_Main
		ptr Swi_Action
		ptr Swi_Delete

		rsobj MagicSwitch,$30
ost_switch_y_start:	rs.w 1					; $30 ; original y-axis position
		rsobjend
; ===========================================================================

Swi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Switch,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.w	ost_y_pos(a0),ost_switch_y_start(a0)	; save position on y-axis
		move.b	#$10,ost_displaywidth(a0)
		move.b	#5,ost_priority(a0)

Swi_Action:	; Routine 2
		move.w	ost_switch_y_start(a0),ost_y_pos(a0)	; restore position on y-axis
		move.w	#$10,d1					; width
		bsr.w	Swi_Detect				; check if Sonic touches the switch
		beq.s	.display				; if not, branch

		addq.w	#2,ost_y_pos(a0)			; move object down 2px
		moveq	#1,d0
		move.w	d0,(v_button_state).w			; set button 0 as "pressed"

	.display:
		bsr.w	DisplaySprite
		out_of_range	Swi_Delete
		rts	
; ===========================================================================

Swi_Delete:	; Routine 4
		bsr.w	DeleteObject
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	check if Sonic touches the object

; input:
;	d1 = width of object

; output:
;	d0 = collision flag: 0 = none; -1 = touched
; ---------------------------------------------------------------------------

Swi_Detect:
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a1),d0
		sub.w	ost_x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.not_touched				; branch if Sonic is to the left
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	.not_touched				; branch if Sonic is to the right
		move.w	ost_y_pos(a1),d2
		move.b	ost_height(a1),d1
		ext.w	d1
		add.w	d2,d1					; take Sonic's height into account
		move.w	ost_y_pos(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	.not_touched				; branch if Sonic is above it
		cmpi.w	#-$10,d0
		bcs.s	.not_touched				; branch if Sonic is below it
		moveq	#-1,d0					; Sonic has touched it
		rts	
; ===========================================================================

.not_touched:
		moveq	#0,d0					; Sonic hasn't touched it
		rts	
; End of function Swi_Detect
