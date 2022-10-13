; ---------------------------------------------------------------------------
; Crash error messages
; ---------------------------------------------------------------------------

BusError:
		move.b	#2,(v_error_type).w
		bra.s	Bad_Address

AddressError:
		move.b	#4,(v_error_type).w
		bra.s	Bad_Address

IllegalInstr:
		move.b	#6,(v_error_type).w
		addq.l	#2,2(sp)
		bra.s	Bad_Instruction

ZeroDivide:
		move.b	#8,(v_error_type).w
		bra.s	Bad_Instruction

ChkInstr:
		move.b	#$A,(v_error_type).w
		bra.s	Bad_Instruction

TrapvInstr:
		move.b	#$C,(v_error_type).w
		bra.s	Bad_Instruction

PrivilegeViol:
		move.b	#$E,(v_error_type).w
		bra.s	Bad_Instruction

Trace:
		move.b	#$10,(v_error_type).w
		bra.s	Bad_Instruction

Line1010Emu:
		move.b	#$12,(v_error_type).w
		addq.l	#2,2(sp)				; add 2 to error address
		bra.s	Bad_Instruction

Line1111Emu:
		move.b	#$14,(v_error_type).w
		addq.l	#2,2(sp)				; add 2 to error address
		bra.s	Bad_Instruction

ErrorExcept:
		move.b	#0,(v_error_type).w
		bra.s	Bad_Instruction
; ===========================================================================

Bad_Address:
		disable_ints
		addq.w	#2,sp					; skip current state flags
		move.l	(sp)+,(v_sp_buffer).w			; copy error address to RAM
		addq.w	#2,sp					; skip opcode word
		movem.l	d0-a7,(v_reg_buffer).w			; save all registers to RAM
		bsr.w	ShowErrorMessage			; display text for type of error
		move.l	2(sp),d0				; get value in program counter (pc)
		bsr.w	ShowErrorValue				; display value
		move.l	(v_sp_buffer).w,d0			; retrieve error address
		bsr.w	ShowErrorValue				; display value
		bra.s	ErrorWaitForC
; ===========================================================================

Bad_Instruction:
		disable_ints
		movem.l	d0-a7,(v_reg_buffer).w			; save all registers to RAM
		bsr.w	ShowErrorMessage			; display text for type of error
		move.l	2(sp),d0				; get error address
		bsr.w	ShowErrorValue				; display value

ErrorWaitForC:
		bsr.w	Error_Loop				; enter loop until C is pressed
		movem.l	(v_reg_buffer).w,d0-a7			; reload registers
		enable_ints
		rte						; return to game

; ---------------------------------------------------------------------------
; Subroutine to display an error message of v_error_type on screen

; output:
;	a6 = vdp_data_port ($C00000)

;	uses d0.l, d1.l, a0
; ---------------------------------------------------------------------------

ShowErrorMessage:
		lea	(vdp_data_port).l,a6
		locVRAM	vram_error				; target $F800 in VRAM
		lea	(Art_Text).l,a0				; level select text graphics
		move.w	#((sizeof_Art_Text-sizeof_cell)/2)-1,d1	; -$20 because the last letter (X) is missed off
	.loadgfx:
		move.w	(a0)+,(a6)
		dbf	d1,.loadgfx

		moveq	#0,d0					; clear	d0
		move.b	(v_error_type).w,d0			; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0			; jump to relevant ASCII text
		locVRAM	(vram_fg+(sizeof_vram_row*12)+(2*2))	; draw message on 12th row, 2nd column
		moveq	#19-1,d1				; number of characters (minus 1)

	.showchars:
		moveq	#0,d0
		move.b	(a0)+,d0				; get one character
		addi.w	#(vram_error/sizeof_cell)-"0",d0	; VRAM tile id minus ASCII baseline ("0" = $30)
		move.w	d0,(a6)					; write to fg nametable in VRAM
		dbf	d1,.showchars				; repeat for number of characters
		rts

; ===========================================================================
ErrorText:	index offset(*)
		ptr .exception
		ptr .bus
		ptr .address
		ptr .illinstruct
		ptr .zerodivide
		ptr .chkinstruct
		ptr .trapv
		ptr .privilege
		ptr .trace
		ptr .line1010
		ptr .line1111
.exception:	dc.b "ERROR EXCEPTION    "
.bus:		dc.b "BUS ERROR          "
.address:	dc.b "ADDRESS ERROR      "
.illinstruct:	dc.b "ILLEGAL INSTRUCTION"
.zerodivide:	dc.b "@ERO DIVIDE        "			; @ = Z
.chkinstruct:	dc.b "CHK INSTRUCTION    "
.trapv:		dc.b "TRAPV INSTRUCTION  "
.privilege:	dc.b "PRIVILEGE VIOLATION"
.trace:		dc.b "TRACE              "
.line1010:	dc.b "LINE 1010 EMULATOR "
.line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ---------------------------------------------------------------------------
; Subroutine to display a longword value on screen

; input:
;	d0 = longword to display
;	a6 = vdp_data_port ($C00000)

;	uses d0, d1, d2
; ---------------------------------------------------------------------------

ShowErrorValue:
		move.w	#(vram_error/sizeof_cell)+$A,(a6)	; display "$" symbol
		moveq	#8-1,d2

	.loop:
		rol.l	#4,d0					; move highest nybble into lowest nybble
		bsr.s	.shownumber				; display 8 numbers
		dbf	d2,.loop
		rts

.shownumber:
		move.w	d0,d1					; copy input to d1
		andi.w	#$F,d1					; read one nybble
		cmpi.w	#$A,d1
		blo.s	.chars0to9
		addq.w	#7,d1					; add 7 for characters A-F

	.chars0to9:
		addi.w	#(vram_error/sizeof_cell),d1
		move.w	d1,(a6)					; write to fg nametable in VRAM
		rts

; ---------------------------------------------------------------------------
; Loop that ends when C is pressed
; ---------------------------------------------------------------------------

Error_Loop:
		bsr.w	ReadJoypads				; get joypad inputs
		cmpi.b	#btnC,(v_joypad_press_actual).w		; is button C pressed?
		bne.w	Error_Loop				; if not, branch
		rts
