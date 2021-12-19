; ---------------------------------------------------------------------------
; Sonic start position constants
; ---------------------------------------------------------------------------

startpos:	macro
		startpos_\3: equ (\1<<16)+\2
		endm

		; Normal levels
		startpos $0050, $03B0, ghz1
		startpos $0050, $00FC, ghz2
		startpos $0050, $03B0, ghz3
		startpos $0060, $006C, lz1
		startpos $0050, $00EC, lz2
		startpos $0050, $02EC, lz3
		startpos $0B80, $0000, sbz3
		startpos $0030, $0266, mz1
		startpos $0030, $0266, mz2
		startpos $0030, $0166, mz3
		startpos $0040, $02CC, slz1
		startpos $0040, $014C, slz2
		startpos $0040, $014C, slz3
		startpos $0030, $03BD, syz1
		startpos $0030, $01BD, syz2
		startpos $0030, $00EC, syz3
		startpos $0030, $048C, sbz1
		startpos $0030, $074C, sbz2
		startpos $2140, $05AC, fz
		startpos $0620, $016B, ending1
		startpos $0EE0, $016C, ending2
		startpos $0080, $00A8, unused

		; Ending credits demos
		startpos $0050, $03B0, ghz1_end1
		startpos $0EA0, $046C, mz2_end
		startpos $1750, $00BD, syz3_end
		startpos $0A00, $062C, lz3_end
		startpos $0BB0, $004C, slz3_end
		startpos $1570, $016C, sbz1_end
		startpos $01B0, $072C, sbz2_end
		startpos $1400, $02AC, ghz1_end2

		; Special Stages
		startpos $03D0, $02E0, ss1
		startpos $0328, $0574, ss2
		startpos $04E4, $02E0, ss3
		startpos $03AD, $02E0, ss4
		startpos $0340, $06B8, ss5
		startpos $049B, $0358, ss6