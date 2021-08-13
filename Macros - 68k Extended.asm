; ---------------------------------------------------------------------------
; Unsigned branches (easier to remember than bcc/bcs/bhi/bls)
; ---------------------------------------------------------------------------

ubge:		macros
		bcc.\0	\1

ubgt:		macros
		bhi.\0	\1

uble:		macros
		bls.\0	\1

ublt:		macros
		bcs.\0	\1

; ---------------------------------------------------------------------------
; Long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro
		bls.s	@nojump
		jmp	\1
	@nojump:
		endm

jcc:		macro
		bcs.s	@nojump
		jmp	\1
	@nojump:
		endm

jhs:		macros
		jcc	\1

jls:		macro
		bhi.s	@nojump
		jmp	\1
	@nojump:
		endm

jcs:		macro
		bcc.s	@nojump
		jmp	\1
	@nojump:
		endm

jlo:		macros
		jcs	\1

jeq:		macro
		bne.s	@nojump
		jmp	\1
	@nojump:
		endm

jne:		macro
		beq.s	@nojump
		jmp	\1
	@nojump:
		endm

jgt:		macro
		ble.s	@nojump
		jmp	\1
	@nojump:
		endm

jge:		macro
		blt.s	@nojump
		jmp	\1
	@nojump:
		endm

jle:		macro
		bgt.s	@nojump
		jmp	\1
	@nojump:
		endm

jlt:		macro
		bge.s	@nojump
		jmp	\1
	@nojump:
		endm

jpl:		macro
		bmi.s	@nojump
		jmp	\1
	@nojump:
		endm

jmi:		macro
		bpl.s	@nojump
		jmp	\1
	@nojump:
		endm

ujge:		macros
		jcc	\1

ujgt:		macros
		jhi	\1

ujle:		macros
		jls	\1

ujlt:		macros
		jcs	\1