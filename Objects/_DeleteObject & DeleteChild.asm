; ---------------------------------------------------------------------------
; Subroutine to	delete an object

; input:
;	a0 = address of OST of object (DeleteObject only)
;	a1 = address of OST of object (DeleteChild only)

; output:
;	a1 = address of next OST
;	uses d0, d1
; ---------------------------------------------------------------------------

DeleteObject:
		movea.l	a0,a1					; move object RAM address to (a1)

DeleteChild:							; child objects are already in (a1)
		moveq	#0,d1
		moveq	#(sizeof_ost/4)-1,d0

	@loop:
		move.l	d1,(a1)+				; clear	the object RAM
		dbf	d0,@loop				; repeat for length of object RAM
		rts	
