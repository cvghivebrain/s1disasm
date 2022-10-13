; ---------------------------------------------------------------------------
; Subroutine to find a free OST

; output:
;	a1 = address of free OST slot
;	uses d0
; ---------------------------------------------------------------------------

FindFreeObj:
		lea	(v_ost_level_obj).w,a1			; start address for OSTs
		move.w	#countof_ost_ert-1,d0

	.loop:
		tst.b	(a1)					; is OST slot empty?
		beq.s	.found					; if yes, branch
		lea	sizeof_ost(a1),a1			; goto next OST
		dbf	d0,.loop				; repeat $5F times

	.found:
		rts

; ---------------------------------------------------------------------------
; Subroutine to find a free OST AFTER the current one

; input:
;	a0 = address of current OST slot

; output:
;	a1 = address of free OST slot
;	uses d0
; ---------------------------------------------------------------------------

FindNextFreeObj:
		movea.l	a0,a1					; address of OST of current object
		move.w	#v_ost_end&$FFFF,d0			; end of OSTs
		sub.w	a0,d0					; d0 = space between current OST and end
		lsr.w	#6,d0					; divide by $40
		subq.w	#1,d0
		bcs.s	.use_current				; branch if current OST is final

	.loop:
		tst.b	(a1)					; is OST slot empty?
		beq.s	.found					; if yes, branch
		lea	sizeof_ost(a1),a1			; goto next OST
		dbf	d0,.loop				; repeat until end of OSTs

	.use_current:
	.found:
		rts
