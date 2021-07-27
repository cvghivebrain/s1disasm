; ---------------------------------------------------------------------------
; Long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro loc
		bls.s	@nojump
		jmp	loc
	@nojump:
		endm

jcc:		macro loc
		bcs.s	@nojump
		jmp	loc
	@nojump:
		endm

jhs:		macro loc
		jcc	loc
		endm

jls:		macro loc
		bhi.s	@nojump
		jmp	loc
	@nojump:
		endm

jcs:		macro loc
		bcc.s	@nojump
		jmp	loc
	@nojump:
		endm

jlo:		macro loc
		jcs	loc
		endm

jeq:		macro loc
		bne.s	@nojump
		jmp	loc
	@nojump:
		endm

jne:		macro loc
		beq.s	@nojump
		jmp	loc
	@nojump:
		endm

jgt:		macro loc
		ble.s	@nojump
		jmp	loc
	@nojump:
		endm

jge:		macro loc
		blt.s	@nojump
		jmp	loc
	@nojump:
		endm

jle:		macro loc
		bgt.s	@nojump
		jmp	loc
	@nojump:
		endm

jlt:		macro loc
		bge.s	@nojump
		jmp	loc
	@nojump:
		endm

jpl:		macro loc
		bmi.s	@nojump
		jmp	loc
	@nojump:
		endm

jmi:		macro loc
		bpl.s	@nojump
		jmp	loc
	@nojump:
		endm